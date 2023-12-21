GD=xlsread('OriginaldataOFdegration.xlsx');
max=length(GD);
x=1:1:max;
plot(x,GD,'b-') 
hold on  
legend('Original signals of \itT_2_4','Selected Degradation state trajectory','Fault threshold','Location','northwest')
xlabel('Data-acquire epoch \itt_k')
ylabel('Monitoring data of \itT_2_4 sensors')