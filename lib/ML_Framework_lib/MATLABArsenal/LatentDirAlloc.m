function [output, beta, alpha] = LatentDirAlloc(A, num_hidden_var)

rand('state', 1);
[num_data, num_text_feature] = size(A);

alpha = ones(num_hidden_var, 1) / num_hidden_var;
betainit = rand(num_hidden_var, num_text_feature) + 1/num_text_feature;
beta = betainit ./ repmat(sum(betainit, 2), 1, num_text_feature);

% Parameter estimation and dimension reduction
[beta, alpha, output] = ParaEst(A, num_hidden_var, beta, alpha, num_data);

function [beta, alpha, output] = ParaEst(A, num_hidden_var, beta, alpha, num_data)

global preprocess;

oldLL = -2e7;
LL = -1e7;
iter = 0;
mindiff = 1e-4;
smoothfactor = 0;
maxiter = 100;
while ((abs(LL - oldLL)/abs(LL) > mindiff) & (LL >= oldLL) & (iter <= maxiter)), 
    % Compute conditional probability of hidden variables, num_data * num_hidden_var matrix
    oldLL = LL;
    LLarray = zeros(num_data, 1);
    newbeta = zeros(size(beta)); 
    gammaarray = ones(num_hidden_var, num_data) .* repmat(sum(A, 2)', num_hidden_var, 1) /num_hidden_var;
    gammaarray = repmat(alpha, 1, num_data) + gammaarray;
    for d = 1:size(A, 1), 
        oldLL1 = -2e7;
        LL1 = -1e7;
        iter1 = 0;
        mindiff1 = 1e-5;
        maxiter1 = 20;
        while ((abs(LL1 - oldLL1)/abs(LL1) > mindiff1) & (iter1 <= maxiter1)),
            oldLL1 = LL1;
            [lambda, gamma, LL1] = InferenceOnce(A(d,:), num_hidden_var, beta, alpha, gammaarray(:, d), num_data);
            gammaarray(:, d) = gamma;
            iter1 = iter1 + 1;
        end;
        TB = zeros(size(beta));
        TB(:, A(d, :) > 0) = lambda .* repmat(A(d, A(d,:) > 0), num_hidden_var, 1); 
        newbeta = newbeta + TB;
        LLarray(d, :) = LL1;
        % if (rem(d, 100) == 0), fprintf('%d,', d); end;
    end;
    oldbeta = beta; oldalpha = alpha;
    beta = (smoothfactor + newbeta) ./ repmat(sum((smoothfactor + newbeta), 2), 1, size(beta, 2));
    alpha = singledigammasolver(gammaarray', num_hidden_var);
    
    LL = sum(LLarray);
    iter = iter + 1;
    if (preprocess.Verbosity > 0), 
        fprintf('Iter: %d, LL = %f alpha = %d\n', iter, LL, mean(alpha));
    end;
end;
output = gammaarray'; 
beta = oldbeta;
alpha = oldalpha;

function [lambda, gamma1, LL] = InferenceOnce(a, num_hidden_var, beta, alpha, gamma0, num_data)

w = find(a > 0);
lambda = beta(:, w) .* repmat(exp(psi(gamma0)), 1, length(w));
lambda = lambda ./ repmat(sum(lambda), num_hidden_var, 1);
gamma1 = alpha + sum(lambda, 2);

digdiff = psi(gamma1) - psi(sum(gamma1));
LL = gammaln(sum(alpha)) - sum(gammaln(alpha)) + sum((alpha - 1) .* digdiff); 
LL = LL + sum(sum(lambda .* repmat(digdiff, 1, length(w))));
LL = LL + sum(sum(lambda .* log(beta(:, w))));
LL = LL - (gammaln(sum(gamma1)) - sum(gammaln(gamma1)) + sum((gamma1 - 1) .* digdiff));
LL = LL - sum(sum(lambda .* log(lambda)));

function [alpha] = singledigammasolver(gammaarray, num_hidden_var)
        
sample_mean = mean(mean(psi(gammaarray) - repmat(psi(sum(gammaarray,2)), 1, num_hidden_var)));
t = 0;
alpha_old = 0;	
alpha_new = 1;

while (sum(abs(alpha_new - alpha_old) > 1e-3)) 
	alpha_old = alpha_new;
	y = psi(num_hidden_var*alpha_old) + sample_mean';	

    % Initialize 
	x0 = (exp(y) + 0.5) .* (y >= -2.22 ) + (-1./(y-psi(1))) .* (y < -2.22);
		
	% Iteration
	while (sum(abs(alpha_new - x0) > 1e-3)) 
		alpha_new = x0;
		x0 = x0 - (psi(x0) - y) ./ psi(1, x0);
    end;
	alpha_new = x0;			
	t = t + 1;
end;
alpha = repmat(alpha_new, num_hidden_var, 1);

function [alpha] = digammasolver(gammaarray, num_hidden_var)
        
sample_mean = mean(psi(gammaarray) - repmat(psi(sum(gammaarray,2)), 1, num_hidden_var));
t = 0;
alpha_old = zeros(num_hidden_var, 1);	
alpha_new = ones(num_hidden_var, 1);

while (sum(abs(alpha_new - alpha_old) > 1e-3)) 
	alpha_old = alpha_new;
	y = psi(sum(alpha_old)) + sample_mean';	

    % Initialize 
	x0 = (exp(y) + 0.5) .* (y >= -2.22 ) + (-1./(y-psi(1))) .* (y < -2.22);
		
	% Iteration
	while (sum(abs(alpha_new - x0) > 1e-3)) 
		alpha_new = x0;
		x0 = x0 - (psi(x0) - y) ./ psi(1, x0);
    end;
	alpha_new = x0;			
	t = t + 1;
end;
alpha = alpha_new;
        