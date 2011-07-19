function [effect degree] = evalMultimodality(k_comb,k_single) 
%k_comb: combine kappa score
%k_signel: list of signel channel kappa scores 
%effect: the resulted mutimodal effect
%degree: degree of superadditivity

if length(k_single)==2
    k_add=k_single(1)+k_single(2)- k_single(1)*k_single(2);
    k_eval1=k_comb>k_single(1) & k_comb>k_single(2);
    k_eval2=k_comb<k_single(1) & k_comb<k_single(2);
elseif length(k_single)==3
    k_add=(k_single(1)+k_single(2)+k_single(3)) - k_single(1)*k_single(2) - k_single(1)*k_single(3) - k_single(2)*k_single(3) + k_single(1)*k_single(2)*k_single(3);
    k_eval1=k_comb>k_single(1) & k_comb>k_single(2) & k_comb>k_single(3);
    k_eval2=k_comb<k_single(1) & k_comb<k_single(2) & k_comb<k_single(3);
else
    disp('Incorrect dimension for k_single');
    effect='null';
    return
end

if k_eval1
    if k_comb>k_add
        effect='superadditivity';
    elseif k_comb<k_add
        effect='redundancy';
    elseif k_comb==k_add
        effect='additivity';
    end
elseif  k_eval2  
    effect='inhibitory';
else
    effect='Other';
% else
%     effect='inhibitory';
end

degree=(k_comb-max(k_single))/max(k_single);