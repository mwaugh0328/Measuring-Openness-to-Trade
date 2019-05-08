function trade_matrix = compute_trade(wage,Tk_part,theta,tau)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This computes the trade share matrix. This is setup so a row is a column
% defines a importer and each row is an exporter. So row 1,2 is the share
% that country 1 buys from 2.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_country = length(wage);

trade_matrix = zeros(n_country,n_country);

tau_mat = repmat(tau',n_country,1); 
tau_mat(eye(n_country)==1) = 1;



p_index = zeros(n_country,1);

for zx = 1:n_country
    
        home_part_p = Tk_part(zx).*(wage(zx)).^(-theta);
        
        p_index(zx) = sum(Tk_part.*(wage.*tau_mat(:,zx)).^(-theta));
        
        trade_matrix(:,zx) = (Tk_part.*(wage.*tau_mat(:,zx)).^(-theta))./p_index(zx);
                                        
end

    
    