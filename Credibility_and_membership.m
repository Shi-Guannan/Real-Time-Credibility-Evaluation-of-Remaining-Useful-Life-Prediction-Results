t=tiledlayout(2,2);
t.Padding = 'tight';
t.TileSpacing = 'tight';
ax1=nexttile;
hold on
E=xlsread('Credibility and membership of Wiener.xlsx');
C1=E(1:end,1);
C2=E(1:end,2);
C3=E(1:end,3);
C4=E(1:end,4);
C5=E(1:end,5);
C6=E(1:end,6);
x=1:1:13;
C=[C1 C2 C3 C4 C5];
b=bar(C,'stacked');
b(1).FaceColor = [.84 .39 .39];
b(2).FaceColor = [1 .75 .48 ];
b(3).FaceColor = [.6 .6 .6];
b(4).FaceColor = [.51 .69 .82];
b(5).FaceColor = [.16 .47 .71];
hold on
plot(x,C6,'r-*');
set(gca,'YTick',0:0.1:1);
set(gca,'YLim',[0 1]);
xlabel('Data-acquire epoch \itt_k')
set(gca,'XTickLabel',{'50','100','150','200'})
ylabel('Membership')
title('Wiener process model')
box off

ax2=nexttile;
hold on
E=xlsread('Credibility and membership of Gamma.xlsx');
C1=E(1:end,1);
C2=E(1:end,2);
C3=E(1:end,3);
C4=E(1:end,4);
C5=E(1:end,5);
C6=E(1:end,6);
x=1:1:13;
C=[C1 C2 C3 C4 C5];
b=bar(C,'stacked');
b(1).FaceColor = [.84 .39 .39];
b(2).FaceColor = [1 .75 .48 ];
b(3).FaceColor = [.6 .6 .6];
b(4).FaceColor = [.51 .69 .82];
b(5).FaceColor = [.16 .47 .71];
hold on
plot(x,C6,'r-o');
set(gca,'YTick',0:0.1:1);
set(gca,'YLim',[0 1]);
xlabel('Data-acquire epoch \itt_k')
set(gca,'XTickLabel',{'50','100','150','200'})
ylabel('Membership')
title('Gamma process model')
box off

ax3=nexttile;
hold on
E=xlsread('Credibility and membership of IG.xlsx');
C1=E(1:end,1);
C2=E(1:end,2);
C3=E(1:end,3);
C4=E(1:end,4);
C5=E(1:end,5);
C6=E(1:end,6);
x=1:1:13;
C=[C1 C2 C3 C4 C5];
b=bar(C,'stacked');
b(1).FaceColor = [.84 .39 .39];
b(2).FaceColor = [1 .75 .48 ];
b(3).FaceColor = [.6 .6 .6];
b(4).FaceColor = [.51 .69 .82];
b(5).FaceColor = [.16 .47 .71];
hold on
plot(x,C6,'r-^');
set(gca,'YTick',0:0.1:1);
set(gca,'YLim',[0 1]);
legend('very low credibility','low credibility','medium credibility','high credibility','very high credibility')
xlabel('Data-acquire epoch \itt_k')
set(gca,'XTickLabel',{'50','100','150','200'})
ylabel('Membership')
title('IG process model')
box off

