C1=xlsread('Calculation time of Wiener');
C2=xlsread('Calculation time of Gamma');
C3=xlsread('Calculation time of IG');
x=60:10:190;
hold on
plot(x,C1,'-*');
plot(x,C2,'-o');
plot(x,C3,'-^');
legend('Based on Wiener Process','Based on Gamma Process','Based on IG Process','Based on Gamma Process(Breakpoint identificattion)','FontSize',7,'Location','northwest')
xlabel('Data-acquire epoch \itt_k')
ylabel('Time/s')
box off
grid on