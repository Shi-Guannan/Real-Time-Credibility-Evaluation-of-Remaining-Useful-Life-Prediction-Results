load('cmapss.mat')
d=c{1,1,100}(:,:);%engine-100
Data=d(:,7);%T24sensor
ND=[];
Max=length(Data);
for j=6:1:Max
    x=Data(j-5:j,1);
    a=rms(x);
    ND=[ND a];
end

x=1:1:Max;
plot(x,Data,'b-') 
hold on  

GD0=ND;
max=length(GD0);
x=0:1:max;
figure(1)
for i=1:1:194
    xy=line([x(i),x(i+1)],[GD0(1,i),GD0(1,i)],'color','k');
    line([x(i+1),x(i+1)],[GD0(1,i),GD0(1,i+1)],'color','k'); 
    hold on 
     line([0,1],[642.25,642.25],'color','k');
    line([1,1],[642.25,642.31],'color','k');
     line([199,200],[642.7414,642.7414],'color','k');
end 
xlabel('数据获取时刻 \itt_k')
ylabel('均方根值')
% 
% GD1=downsample(ND,5);
% x1=0:5:max;
% for j=2:1:40
%     x1y=line([x1(j),x1(j+1)],[GD1(1,j),GD1(1,j)],'color','r');
%     line([x1(j),x1(j)],[GD1(1,j-1),GD1(1,j)],'color','r'); 
%     hold on 
%      line([0,5],[642.25,642.25],'color','r');
%     line([5,5],[642.25,642.3618],'color','r');
%     line([200,200],[642.7257,642.7414],'color','r');
% end 
% legend([xy,x1y],'RMS data extraction','RMS data combination','Location','northwest')
% xlabel('Data-acquire epoch \itt_k')
% ylabel('RMS')