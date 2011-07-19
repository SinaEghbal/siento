%GENDAT Random generation of datasets for training and testing
% 
%  [A,B,IA,IB] = GENDAT(X,N)
%  [A,B,IA,IB] = GENDAT(X)
%  [A,B,IA,IB] = GENDAT(X,ALF)
% 
% INPUT
%   X      Dataset
%   N,ALF  Number/fraction of objects to be selected 
%          (optional; default: bootstrapping)
%
% OUTPUT
%   A,B    Datasets
%   IA,IB  Original indices from the dataset X
%
% DESCRIPTION
% Generation of N objects from dataset X. They are stored in dataset A,
% the remaining objects in dataset B. IA and IB are the indices of the
% objects selected from X for A and B. The random object generation follows
% the class prior probabilities. So is the prior probability of a class is
% PA, then in expectation PA*N objects are selected from that class. If N
% is a vector of sizes, exactly N(i) objects are generated for class i.
% Classes are ordered using RENUMLAB(GETLAB(X)). 
%
% If the function is called without specifying N, the data set X is
% bootstrapped and stored in A. Not selected samples are stored in B.
%
% ALF should be a scalar < 1. For each class a fraction ALF of the objects
% is selected for A and the not selected objects are stored in B.
%
% If X is a cell array of datasets the command is executed for each
% dataset separately. Results are stored in cell arrays. For each dataset
% the random seed is reset, resulting in aligned sets for the generated
% datasets if the sets in X were aligned.
% 
% EXAMPLES 
% See PREX_PLOTC.
%
% SEE ALSO
% DATASETS

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Sciences, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

% $Id: gendat.m,v 1.4 2007/01/25 08:06:24 davidt Exp $

function [A,B,IA,IB] = gendat(X,N);

	prtrace(mfilename);
	
	if (nargin < 2), 
		prwarning(4,'Second parameter is not specified. A bootstrapping a dataset.');
		N = []; 
	end

	% If an input is a cell array of datasets, apply this procedure
  % to the individual datasets.
	if (iscell(X))
		A  = cell(size(X));
		B  = cell(size(X));
		IA = cell(size(X));
		IB = cell(size(X));
		seed = rand('seed');
		for j=1:length(X(:))
			rand('seed',seed);
			[A{j},B{j},IA{j},IB{j}] = feval(mfilename,X{j},N);
		end
		return;
	end

	% When required, get the right number of objects from the given
	% fraction ALF.
	if ~isdatafile(X), X = dataset(X); end
	%DXD, if the input dataset is empty, sampling is no use:
	if isempty(X)
		%error('Dataset X does not contain samples.');
		prwarning(4,'Dataset X does not contain samples.');
		A = X; B = X; IA = []; IB = [];
		return
	end
	X = setlablist(X); % remove empty classes first
	%p = getprior(X);
	[m,k,c] = getsize(X);
	% we need at least one class below:
	if c==0, 
	   X=cdats(X,1); 
	   c=1;
	end

	R = classsizes(X);
	if ~isempty(N) & length(N) ~= 1 & length(N) ~= c
		error('Data size should be scalar or a vector matching the number of classes')
	end
	if (nargin == 2) & (N < 1)
		%DXD it should also be possible to have a fraction for each of the
		%classes, I think...
		if length(N)==1
			N = ceil(N*R);
		else
			N = ceil(N(:).*R(:));
		end
	end

	% Depending if N (or ALF) is given, the objects are created using
	% subsampling or bootstrapping.
	IA = [];
	if (nargin < 2) | (isempty(N))			% Bootstrap
		for i=1:c
			J = findnlab(X,i);
			K = ceil(rand(R(i),1)*R(i));
			IA = [IA; J(K)];
		end
	else																% Subsampling
		if islabtype(X,'targets')
			N = genclass(N,1);
			K = randperm(R);
			if (N > R)
				%DXD: I would like to have just a warning:
				%error('More objects requested than available.')
				prwarning(4,'More objects requested than available.')
				N = R;
			end
			IA = K(1:N);
		else
			p = X.prior;   % avoid warning
			if isempty(p)
				p = classsizes(X);
				p = p/sum(p);
			end
			%p = getprior(X);
			N = genclass(N,p);
			for i=1:c
				J = findnlab(X,i);
				K = randperm(R(i));
				if (N(i) > R(i))
					%DXD: I would like to have just a warning:
					%error('More objects requested than available.')
					prwarning('More objects requested than available in class %d.',i)
					N(i) = R(i);
				end
				IA = [IA; J(K(1:N(i)))];
			end
		end
	end

	% Finally, extract the datasets:
	IB = [1:m]';
	IB(IA) = [];
	A = X(IA,:);
	B = X(IB,:);

return;
