%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code that loads in data, computes, then plots the data found
% in Measuring Opennes to Trade by Ravikumar and Waugh. Specifically
% Figures 1(a and b) and 2(a and b). The code for Figure 3 is in a seperate
% file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear

[ndata, text_var, alldata] = xlsread('matlab_data.xls');
% Read in the data. Note that all this data is straight from the Penn World
% Table as discussed in the data section. The Home Share variable simply is
% 1-Imports/GDP and we drop the countries that have a value that is
% greather than one. 

labor = ndata(:,1);

home_share = ndata(:,2);

gdp = ndata(:,3);

cntry_names = alldata(2:end,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = 4; % This is the baseline theta used.

common_component = (labor.*gdp).^(theta/(1+theta)).*home_share.^(1/(1+theta));
common_component = sum(common_component)^(1/theta);
% This computes the common_componentn in equation (19) of the formula

potential = common_component.*(home_share./(labor.*gdp)).^(1/(1+theta));
% This then computes the country specific measure, equation (18).

relative_openness = (1-home_share.^(1/theta))./(common_component.*(home_share./(gdp.*labor)).^(1/(1+theta)) - home_share.^(1/theta));
% This then maps it into an index number, equation (21)

% We are done. It is that simple!!!!!

close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1(a)
axes1 = axes('Parent',figure,...
'XTickLabel',{'1/128','1/64','1/32','1/16','1/8','1/4','1/2','1', '2'},...
'YTick',[-1 0 1 2 3],...
'YTickLabel',{'1/2','1', '2','4','8','16','32'},...
'FontWeight','bold','FontSize',22);

xlim(axes1,[-7 1]);
ylim(axes1,[-1 4]);
hold('all');

plot(log2(gdp),log2(potential),'w*')
text(log2(gdp),log2(potential),cntry_names,'Fontsize',14,'FontWeight','bold','Color','k')
xlabel('GDP Per Worker (Data, USA = 1)','FontWeight','bold','FontSize',22);
ylabel('Potential GDP / Data','FontWeight','bold','FontSize',22);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1(b)
axes1 = axes('Parent',figure,...
'XTickLabel',{'1/128','1/64','1/32','1/16','1/8','1/4','1/2','1', '2'},...
'YTick',[-1 0 1 2 3],...
'YTickLabel',{'1/2','1', '2','4','8','16','32'},...
'FontWeight','bold','FontSize',22);

xlim(axes1,[-7 1]);
ylim(axes1,[-1 4]);
hold('all');

plot(log2(gdp),log2(home_share.^(1/theta)),'w*')
text(log2(gdp),log2(home_share.^(1/theta)),cntry_names(:),'Fontsize',14,'FontWeight','bold','Color','k')
xlabel('GDP Per Worker (Data, USA = 1)','FontWeight','bold','FontSize',22);
ylabel('Autarky GDP / Data','FontWeight','bold','FontSize',22);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2(a)
axes1 = axes('Parent',figure,...
'XTickLabel',{'1/128','1/64','1/32','1/16','1/8','1/4','1/2','1', '2'},...
'FontWeight','bold','FontSize',22);

xlim(axes1,[-7 1]);
ylim(axes1,[0 1.0]);
hold('all');

plot(log2(gdp),relative_openness,'w*')
text(log2(gdp),relative_openness,cntry_names(:),'Fontsize',14,'FontWeight','bold','Color','k')
xlabel('GDP Per Worker (Data, USA = 1)','FontWeight','bold','FontSize',22);
ylabel('Trade Potential Index (0 = Autarky, 1 = Frictionless)','FontWeight','bold','FontSize',22);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2(b)
axes1 = axes('Parent',figure,...
'XTickLabel',{'1/128','1/64','1/32','1/16','1/8','1/4','1/2','1', '2'},...
'FontWeight','bold','FontSize',22);

xlim(axes1,[-7 1]);
ylim(axes1,[0 0.30]);
hold('all');

plot(log2(gdp),relative_openness,'w*')
text(log2(gdp),relative_openness,cntry_names(:),'Fontsize',14,'FontWeight','bold','Color','k')
xlabel('GDP Per Worker (Data, USA = 1)','FontWeight','bold','FontSize',22);
ylabel('Trade Potential Index (0 = Autarky, 1 = Frictionless)','FontWeight','bold','FontSize',22);