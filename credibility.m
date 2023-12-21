C1=xlsread('Credibility and membership of Wiener','F1:F14');
C2=xlsread('Credibility and membership of Gamma','F1:F14');
C3=xlsread('Credibility and membership of IG','F1:F14');
x=60:10:190;
hold on
plot(x,C1,'-*');
plot(x,C2,'-o');
plot(x,C3,'-^');
legend('Based on Wiener Process','Based on Gamma Process','Based on IG Process','Based on Gamma Process(Breakpoint identificattion)','FontSize',7,'Location','northwest')
axis([60 200 0 1])
set(gca,'YTick',0:0.1:1);
xlabel('Data-acquire epoch \itt_k')
ylabel('Credibility')
box off
grid on