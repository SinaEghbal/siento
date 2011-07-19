%ADABOOSTC
%
% [W,V,ALF] =  ADABOOSTC(A,CLASSF,N,RULE,VERBOSE);
%
% INPUT
%   A       Dataset
%   CLASSF  Untrained weak classifier
%   N       Number of classifiers to be trained
%   RULE    Combining rule (default: weighted voting)
%   VERBOSE Suppress progress report if 0 (default 1)
%
% OUTPUT
%   W       Combined trained classifier
%   V       Cell array of all classifiers
%           Use VC = stacked(V) for combining
%   ALF     Weights
%
% DESCRIPTION
%
% Computation of a combined classifier according to adaboost.
%
% In total N weighted versions of the training set A are generated
% iteratevely and used for the training of the specified classifier.
% Weights, to be used for the probabilities of the objects in the training
% set to be selected, are updated according to the Adaboost rule.
%
% The entire set of generated classifiers is given in V.
% The set of classifier weigths, according to Adaboost is returned in ALF
%
% Various aggregating possibilities can be given in 
% the final parameter rule:
% []:      WVOTEC, weighted voting.
% VOTEC    voting
% MEANC    sum rule
% AVERAGEC averaging of coeffients (for linear combiners)
% PRODC    product rule
% MAXC     maximum rule
% MINC     minimum rule
% MEDIANC  median rule
%
% SEE ALSO
% MAPPINGS, DATASETS,

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [W,V,alf,U] = adaboostc(a,clasf,n,rule,verbose);

	prtrace(mfilename);

%               INITIALISATION

if nargin < 5, verbose = 1; end
if nargin < 4, rule = []; end
if nargin < 3, n = 1; end
if nargin < 2 | isempty(clasf), clasf = nmc; end
if nargin < 1 | isempty(a)
	W = mapping(mfilename,{clasf,n,rule,verbose});
	W = setname(W,'Adaboost');
	return
end

[m,k,c] = getsize(a);
V = [];
lablist = getlablist(a);
laba = getnlab(a);
p = getprior(a);
a = dataset(a,laba);         % use numeric labels for speed
a = setprior(a,p);
u =ones(m,1)/m;              % initialise object weights
alf = zeros(1,n);            % space for classifier weights
if verbose > 0 & k == 2
	figure(verbose);
	scatterd(a);
end
eprior = 1-max(getprior(a)); % maximum error

                             % generate n classifiers
for i = 1:n
	b=gendatw(a,u,ceil(0.2*m));            % sample training set
	b = setprior(b,getprior(a)); % use original priors
  labb=getlab(b);            
	w = b*clasf;               % train weak classifier
	if verbose & k == 2
  	plotc(w,1); drawnow
	end
  erra = a*w*testc;          % compute its error
  labc = a*w*labeld;         % find objects that ...
	diff = labc~=laba;         % are erroneously classified
  dd = 1-2*diff;      
	r = sum(u.*dd);  
	if erra ~= 0 | 1           % do not stop for zero error classifier
		alf(i) = 0.5*log((1+r)/(1-r+realmin)); % classifier weight
		correct = find(diff==0);       % find correctly classified objects
		wrong = find(diff==1);         % find incorrectly classified objects
		u(correct) = u(correct)*exp(-alf(i));  % give them the ...
		u(wrong) = u(wrong)*exp(alf(i));       % proper weights
		u=u./sum(u);                   % normalize weights
	else                             % if classifier perfect
		alf = alf(1:i-1);              % stop
		break
	end
	w = setlabels(w,lablist);        % restore original labels
	if verbose
		%disp([erra r alf(i) sum(alf)])
	end
  V = [V w];                       % store all classifiers

end
                                   % combine
if isempty(rule)
	W = wvotec(V,alf);               % default is weighted combiner
else
	W = traincc(a,V,rule);           % otherwise, use user supplied combiner
end

if verbose > 0 & k == 2
	plotc(W,'r',3)
	ee = a*W*testc;
	title(['Error: ', num2str(ee)]);
end

return
