clc
clearvars
close all
load('cmapss.mat')
d=c{1,1,6}(:,:);%engine-100
Data=d(:,7);%T24sensor

%%% Data preprocessing %%%
ND=[];
Max=length(Data);
for j=1:1:Max
    x=Data(1:j,1);
    a=rms(x);
    ND=[ND a];
end
ND=ND';
L=ND(Max,1);%Fault threshold

PM=[];%used to store parameter
PDF=[];%used to store pdf of RUL
INDEX=[];
MM=[];%membership matrix
W=[];
CE=[];
CRE=[];
ET=[];
GD1=downsample(ND,5);

for i=60:10:180
    tic;
    k=(i-50)/10;
    xi=ND(i,1);

    if k==1
        Di=diff(ND(50:1:i));
        Di(Di<=0)=[];
        phat=mle(Di,'distribution','InverseGaussian');
        a=phat(1);
        b=phat(2);
    else
        GD1=downsample(ND,5);
        Dd=GD1(10:(i/5),1);
        Di=diff(Dd);
        Di(Di<=0)=[];
    [phat,pci]=mle(Di,'distribution','InverseGaussian');
    a=phat(1)./5;%phat(1)./5 based on characteristics based on IG distribution
    b=phat(2)./5;%phat(1)./5 based on characteristics based on IG distribution
    end
    PM(k,1)=a;
    PM(k,2)=b;
    X=0.00001:0.00001:0.025;
    pd = makedist('InverseGaussian','mu',PM(k,1),'lambda',PM(k,2));%t=1
   
    p=RULprediction(PM(k,1),PM(k,2),xi,L);
    PDF(k,:)=p;

    A=1-KSE(Di,PM(k,1),PM(k,2));
    X=0.0001:0.0001:0.02;
    if k==1
        C=0;%Insufficient data to calculate consistency evaluation factor
    else
        C=1-JS(X,PM(k,1),PM(k,2),PM(k-1,1),PM(k-1,2));
    end
    E=EntropyOFRUL(p);
    INDEX(k,1)=A;
    INDEX(k,2)=C;
    INDEX(k,3)=E;

    if k==1
        w=[0.5 0 0.5];%Insufficient data to calculate weights and consistency
    else
        w=weight(INDEX(:,1),INDEX(:,2),INDEX(:,3));
    end

    AA=ambiguity(A,0.5,0.75,0.875,0.9375,0.96875);
    AC=ambiguity(C,0.5,0.75,0.875,0.9375,0.96875);
    AE=ambiguity(E,0.03125,0.0625,0.125,0.25,0.5);
    MM(k,:)=[AA AC AE];
    ce=AA.*w(1,1)+AC.*w(1,2)+AE.*w(1,3);
    CE=[CE;ce];

    cre=sum(ce.*[0,0.25,0.5,0.75,1]);
    CRE=[CRE cre];
    toc;
    etime = toc;
    ET=[ET etime];
end
xlswrite('Credibility and membership of IG.xlsx',[CE CRE']);
xlswrite('Calculation time of IG.xlsx',ET);
%%plot RUL prediction results%%%

figure(1)
Erul=[];
t=1:1:300;
for i=1:size(PDF,1)
    x=i*ones(1,length(t));
    xyz1=plot3(x,t,PDF(i,:),'b');
    hold on
    [~,index]=max(PDF(i,:));
    erul=t(1,index);
    Erul=[Erul erul];
end
j=1:1:13;
R_R=[130:-10:10];%ground-true RULs
xyz2=plot3(j,R_R,zeros(1,13),'-o','Color','0.00 0.45 0.74');
xyz3=plot3(j,Erul,zeros(1,13),'r-*');
grid on
legend([xyz1(1),xyz2,xyz3],'The PDF of RUL','The actual RUL','The expected RUL','location','northwest')
xlim([1,14]);
set(gca,'xticklabel',{'70','90','110','130','150','170','190'});
title('IG process model')
xlabel('Data-acquire epoch \itt_k ')
ylabel('RUL')
zlabel('PDF')

%%%plot Credibility and membership%%%
figure(2)
b=bar(CE,'stacked');
b(1).FaceColor = [.84 .39 .39];
b(2).FaceColor = [1 .75 .48 ];
b(3).FaceColor = [.6 .6 .6];
b(4).FaceColor = [.51 .69 .82];
b(5).FaceColor = [.16 .47 .71];
hold on
plot(j,CRE,'r-*');
set(gca,'YTick',0:0.1:1);
set(gca,'YLim',[0 1]);
xlabel('Data-acquire epoch \itt_k')
set(gca,'XTickLabel',{'60','70','80','90','100','110','120','130','140','150','160','170','180','190'})
ylabel('Membership')
title('IG process model')
box off




%%% RUL based on Gamma,increment of degradation per time~Gam(alpha,beta)%%%
function p=RULprediction(a,b,xi,L)
p=[];
for t=1:1:300
        c=sqrt(b/(L-xi));%简化公式
        d=(L-xi)/a;%简化公式
        f=c*normpdf(c*(t-d))+(2*b*t/a)*exp(2*b*t/a)*normcdf(-c*(t+d))-c*exp(2*b*t/a)*normpdf(-c*(t+d));
        f(isnan(f))=0;
        f(isinf(f))=0;
        f(f<0)=0;
        p=[p f];
end 
p=p./sum(p);
end

%%% Computational model for the accuracy evaluation factor%%%
function A=KSE(Di,a,b)
    di=sort(Di);
    step=0.0001;
    totalNum=length(di);
    y1=cdf('InverseGaussian',0:step:1,a,b);
    y0=[];
    for j=0:step:1
        temp=length(find(di<=j))/totalNum;
        y0=[y0 temp];
    end
    A=max(abs(y1-y0));
end

%%% Computational model for the consistency evaluation factor%%%
function C=JS(X,a,b,ha,hb)
    P1=pdf('InverseGaussian',X,a,b);
    P1=P1./(sum(P1));
    P2=pdf('InverseGaussian',X,ha,hb);
    P2=P2./(sum(P2));
    C=kldiv(X,P1,P2,'js');
end

%%% Computational model for the effectiveness evaluation factor%%%
function E=EntropyOFRUL(p)
    p(p==0)=[];
    Max=length(p);
    f=(p.*log2(p))./log2(1/Max);
    E=1-sum(f);
end

function E=ambiguity(u,l1,l2,l3,l4,l5)
    if u<=l1
        e1=1;e2=0;e3=0;e4=0;e5=0;
    elseif(l1<u)&&(u<l2)
        e1=(l2-u)/(l2-l1);e2=1-e1;e3=0;e4=0;e5=0;
    elseif(l2<u)&&(u<l3)
        e1=0;e2=(l3-u)/(l3-l2);e3=1-e2;e4=0;e5=0;
    elseif(l3<u)&&(u<l4)
        e1=0;e2=0;e3=(l4-u)/(l4-l3);e4=1-e3;e5=0;
    elseif(l4<u)&&(u<l5)
        e1=0;e2=0;e3=0;e4=(l5-u)/(l5-l4);e5=1-e4;
    elseif(l5<u)
        e1=0;e2=0;e3=0;e4=0;e5=1;
    end
    E=[e1 e2 e3 e4 e5];
end

function w=weight(IA,IC,IE)
    k=length(IA);
    pA=IA./sum(IA);
    hA=-sum(pA.*log(pA))./log(1/k);
    gA=1-hA;
    IC=IC+eps;
    pC=IC./sum(IC);
    hC=-sum(pC.*log(pC))./log(1/k);
    gC=1-hC;
    pE=IE./sum(IE);
    hE=-sum(pE.*log(pE))./log(1/k);
    gE=1-hE;
    wA=gA/(gA+gC+gE);
    wC=gC/(gA+gC+gE);
    wE=gE/(gA+gC+gE);
    w=[wA,wC,wE];
end


