clear
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load tau_calibrate.mat


axes1 = axes('Parent',figure,...
'XTickLabel',{'1/128','1/64','1/32','1/16','1/8','1/4','1/2','1', '2'},...
'YTickLabel',{'1','2','4','8','16'},...
'YTick',[0 1 2 3 4],...
'FontWeight','bold','FontSize',22);

xlim(axes1,[-7 1]);
ylim(axes1,[0 4.5]);

hold('all');

plot(log2(gdp),log2(tau),'w*')
text(log2(gdp),log2(tau),cntry_names(:),'Fontsize',14,'FontWeight','bold','Color','k')
xlabel('GDP Per Worker (Data, USA = 1)','FontWeight','bold','FontSize',22);
ylabel('Trade Cost','FontWeight','bold','FontSize',22);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'YTickLabel',{'1','2','4','8','16'},...
axes1 = axes('Parent',figure,...
'XTickLabel',{'2','4','8','16'},...
'XTick',[1 2 3 4],...
'YTickLabel',{'1/512','1/256','1/128','1/64','1/32','1/16','1/8','1/4','1/2'},...
'yTick',[-9 -8 -7 -6 -5 -4 -3 -2 -1],...
'FontWeight','bold','FontSize',22);

%xlim(axes1,[-7 1]);
xlim(axes1,[0.5 4.5]);

hold('all');

plot(log2(tau),log2(relative_openness),'w*')
text(log2(tau),log2(relative_openness),cntry_names(:),'Fontsize',14,'FontWeight','bold','Color','k')
xlabel('Trade Cost','FontWeight','bold','FontSize',22);
ylabel('Log Trade Potential Index','FontWeight','bold','FontSize',22);

disp('Correlation Tau and Relative Openness')
disp(corr(log(tau),log(relative_openness)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'YTickLabel',{'1','2','4','8','16'},...
acr = home_share.^(-1/theta);

axes1 = axes('Parent',figure,...
'XTickLabel',{'2','4','8','16'},...
'XTick',[1 2 3 4],...
'YTickLabel',{'1','1.41','2'},...
'yTick',[0,0.5,1],...
'FontWeight','bold','FontSize',22);

%xlim(axes1,[-7 1]);
xlim(axes1,[0.5 4.5]);
ylim(axes1,[0 1]);

hold('all');

plot(log2(tau),log2(acr),'w*')
text(log2(tau),log2(acr),cntry_names(:),'Fontsize',14,'FontWeight','bold','Color','k')
xlabel('Log Trade Cost','FontWeight','bold','FontSize',22);
ylabel('Log Welfare Cost of Autarky','FontWeight','bold','FontSize',22);

disp('Correlation Tau and Relative Openness')
disp(corr(log(tau),(acr)))

[b,~,r,~,stats] = regress((acr),[ones(length(acr),1), (gdp)])

corr(r,log(tau))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





