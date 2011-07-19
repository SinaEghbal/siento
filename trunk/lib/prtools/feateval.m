%FEATEVAL Evaluation of feature set for classification
% 
% 	J = FEATEVAL(A,CRIT,T)
% 	J = FEATEVAL(A,CRIT,N)
% 
% INPUT
%       A      input dataset
%       CRIT   string name of a method or untrained mapping
%       T      validation dataset (optional)
%       N      number of cross-validations (optional)
%
% OUTPUT
%       J      scalar criterion value
%
% DESCRIPTION
%  Evaluation of features by the criterion CRIT for classification,
%  using objects in the dataset A. The larger J, the better. Resulting
%  J-values are incomparable over the various methods.
%  The following methods are supported:
%  
%   crit='in-in' : inter-intra distance.
%   crit='maha-s': sum of estimated Mahalanobis distances.
%   crit='maha-m': minimum of estimated Mahalanobis distances.
%   crit='eucl-s': sum of squared Euclidean distances.
%   crit='eucl-m': minimum of squared Euclidean distances.
%   crit='NN'    : 1-Nearest Neighbour leave-one-out
%                  classification performance (default).
%                  (performance = 1 - error). 
%  
%  CRIT can also be any untrained classifier, e.g. LDC([],1e-6,1e-6). 
%  The classification error is used for a performance estimate. If 
%  supplied, the dataset T is used for obtaining an unbiased estimate 
%  of the performance of classifiers trained with the dataset A. 
%  If a number of cross-validations N is supplied, the routine is
%  run for N times with different training and test sets generated
%  from A by cross-validation. Results are averaged. If T nor N are 
%  given, the apparent performance on A is used. 
% 
% SEE ALSO
% DATASETS, FEATSELO, FEATSELB, FEATSELF, FEATSELP, FEATSELM, FEATRANK

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% REVISIONS
% DXD1: David Tax, 08-05-2003
%       I added the inter/intra distance criterion.

% $Id: feateval.m,v 1.7 2008/04/06 20:03:15 duin Exp $

function J = feateval(a,crit,t)

	prtrace(mfilename);
	
	[ma,k,c] = getsize(a);
	if nargin < 2
		crit = 'NN';
	end
	if nargin < 3
		t =[]; 
		prwarning(4,'Where needed, input dataset is used for validation')
	end

	if is_scalar(t) & ~isdataset(t) % cross-validation desired, t rotations
		K = crossval(a,nmc,t,0); % trick to get rotation set from crossval
		J = 0;
		JALL = [1:size(a,1)];
		if ~ismapping(crit) | ~isuntrained(crit)
			error('Cross-validation only possible with untrained classifiers')
		end
		for j=1:t
			JIN = JALL;
			JOUT = find(K==j);
			JIN(JOUT) = [];
			JOUT = JALL(JOUT);
			train = a(JIN,:);
			test  = a(JOUT,:);
			J = J + feval(mfilename,train,crit,test);
		end
		J = J/t;
		return
	end
		
%	islabtype(a,'crisp');
	isvaldfile(a,1,2); % at least 1 object per class, 2 classes
	a = testdatasize(a);
	iscomdset(a,t);

	if isstr(crit)
		%DXD1
		if strcmp(crit,'in-in')     % inter/intra distances
			islabtype(a,'crisp','soft');
			if isempty(t)
				[U,G] = meancov(a);
			else
				[U,G] = meancov(t);
			end
			S_b = cov(+U); % between scatter
			prior = getprior(a);
			S_w = reshape(sum(reshape(G,k*k,c)*prior',2),k,k); % within scatter
			J = trace(inv(S_w)*S_b);
		elseif strcmp(crit,'maha-s') | strcmp(crit,'maha-m') % Mahalanobis distances
			islabtype(a,'crisp','soft');
			if isempty(t)
				D = distmaha(a);
			else
				[U,G] = meancov(a);
				D = distmaha(t,U,G);
				D = meancov(D);
			end
			if strcmp(crit,'maha-m')
				D = D + realmax*eye(c);
				J = min(min(D));
			else
				J = sum(sum(D))/2; 
			end
		elseif strcmp(crit,'eucl-s') | strcmp(crit,'eucl-m') % Euclidean distances
			islabtype(a,'crisp','soft');
			U = meancov(a);
			if isempty(t)
				D = distm(U);
			else
				D = distm(t,U);
				D = meancov(D);
			end
			if strcmp(crit,'eucl-m')
				D = D + realmax*eye(c);
				J = min(min(D));
			else
				J = sum(sum(D))/2; 
			end
		elseif strcmp(crit,'NN')	% 1-NN performance
			islabtype(a,'crisp','soft');
			if isempty(t)
				J = 1 - testk(a,1);
			else
				J = 1 - testk(a,1,t);
			end
		elseif strcmp(crit,'kcentres') % data radius, unsupervised
				% assumes disrep, so experimental
			J = max(min(+a,[],2));
			if J == 0, J = inf; else J = 1/J; end
		else
			error('Criterion undefined');
		end
	else
		ismapping(crit);
		isuntrained(crit);
		if isempty(t)
			J = 1 - (a * (a * crit) * testc);
		else
			J = 1 - (t * (a * crit) * testc);
		end
	end

return
