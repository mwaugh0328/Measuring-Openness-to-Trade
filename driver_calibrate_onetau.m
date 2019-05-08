%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code calibrates the model with one tau per country to exactly match
% the home trade share. The T parameters are recoverd as a residual.

clear 

alpha = 1./3;

theta = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import Data. This is the penn world table data that is imported via
% stata, then generates an excel file which Matlab can import. 

[pwt_data,text] = xlsread('openness_data.xls');

labor = pwt_data(:,1)./pwt_data(152,1);

home_share = pwt_data(:,2);

gdp = pwt_data(:,3);

capital = pwt_data(:,4)./pwt_data(152,4);

n_country = length(labor);

cntry_names = text(2:end,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now recover the T parameters and define the Tk compenonent that is used
% to compute the capital prices, etc.

T = (gdp./capital.^alpha).^(theta).*home_share;

Tk_part = T.*(capital.^(-alpha)).^(-theta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below is the actuall calibration algorithim. The idea is to guess a wage,
% and a tau for each country. This then uses trade balance to infer a new
% tau and the wage equation to infer a new wage. Then itterate. 
%
% A key issue is making sure this algorithing is stable. I found that by
% guessing tau.^-theta and not tau and itterate on this, everything worked
% very well. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The algorithim...

tau = ones(n_country,1).*3; tau_hat = tau.^(-theta);

wage = gdp;

tau_new = zeros(n_country,1);
wage_new = zeros(n_country,1);

for n_times = 1:2000

    tau_mat = repmat(tau',n_country,1); 
    tau_mat(eye(n_country)==1) = 1;
    trade_matrix = zeros(n_country,n_country);
    
    % This should create a tau matrix so the importing barrier is the same
    % across all locations, so for each column as you go down the row, the tau
    % value should be the same. 

    p_index = zeros(n_country,1);
    omega_index = zeros(n_country,1);
    
    total_gdp = labor.*wage;

    % This now consturct the trade share matrix and the price index, etc. 
    for zx = 1:n_country
    
        home_part_p = Tk_part(zx).*(wage(zx)).^(-theta);
        
        p_index(zx) = sum(Tk_part.*(wage).^(-theta).*tau_mat(:,zx));
    
        omega_index(zx) = sum(Tk_part.*(wage).^(-theta))-home_part_p;
    
        trade_matrix(:,zx) = (Tk_part.*(wage).^(-theta).*tau_mat(:,zx))./p_index(zx);
                                        
    end
    
    tau_new = (1-home_share).*(p_index./omega_index);
    % this is not matching up withe the stuff below. It does look like it
    % converged though. 
            
    for zx = 1:n_country
                        
        sum_term = sum(trade_matrix(zx,:)'.*total_gdp);
        
        wage_new(zx) = sum_term./labor(zx);
    end
     
    wage_new = wage_new./wage_new(1); %Normalize it.

    test1 = norm(log([wage;tau]) - log([wage_new;tau_new]))
    
    if test1 < 10^-3
        disp('Algorithim Converged')
        break
    else
        % Update...
        wage = .25.*wage_new + .75.*wage;
        tau = .25.*tau_new + .75.*tau;
        
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Everything is done, but because of the normalization, we do one final
% loop to compute the price index and trade share matrix.

for zx = 1:n_country
           
        p_index(zx) = sum(Tk_part.*(wage).^(-theta).*tau_mat(:,zx));
        
        trade_matrix(:,zx) = (Tk_part.*(wage).^(-theta).*tau_mat(:,zx))./p_index(zx);
                                        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are checks of the data...

tau = tau.^(-1/theta);

trade_matrix_test = compute_trade(wage,Tk_part,theta,tau);

home_test = ((capital.^-alpha.*wage).^(-theta).*T)./(p_index);

income_test = T.^(1/theta).*home_share.^(-1/theta).*capital.^(alpha);

common_component = labor.^(theta/(1+theta)).*T.^(1/(1+theta)).*capital.^(alpha*theta/(1+theta));
common_component = sum(common_component)^(1/theta);

relative_openness = (1-home_share.^(1/theta))./(common_component.*(home_share./(gdp.*labor)).^(1/(1+theta)) - home_share.^(1/theta));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
old_wage = wage;

save tau_calibrate.mat T capital labor tau gdp home_share old_wage theta alpha relative_openness cntry_names

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot_results
