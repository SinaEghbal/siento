%FIXEDCC Construction of fixed combiners
%
%   V = FIXEDCC(A,W,TYPE,NAME)
%
% INPUT
%   A      Dataset
%   W      A set of classifier mappings
%   TYPE   The type of combination rule
%   NAME   The name of this combination rule
%
% OUTPUT
%   V      Mapping
%
% DESCRIPTION
% Define a mapping V which applies the combination rule TYPE to the
% set of mappings W. The set of mappings W should be a parallel
% combination (see MAPPINGS).
%
% The TYPE of combining can be any of the following:
%   average, min, max, mean, median, prod, vote,
%
% Note that average is only possible for affine 2-class classifiers.
%
% When W is a set of classifiers and A a dataset (possibly the result
% of  B*W, where W is again a set of classifiers) then:
%
%   V = FIXEDCC(W,[],TYPE)   combines the mappings W with the comb. rule TYPE
%   V = FIXEDCC(A,[],TYPE)   computes the combining output for dataset A
%   V = FIXEDCC(A,W,TYPE)    computes the combining output for dataset A,
%                            where W is trained using A
% 
% EXAMPLES
% See prex_combining.
%
% SEE ALSO
% MAPPINGS, MAJORC, MAXC, MEANC, MEDIANC, MINC, PRODC, AVERAGEC

% $Id: fixedcc.m,v 1.2 2006/03/08 22:06:58 duin Exp $

function v = fixedcc(a,w,type,name)

	prtrace(mfilename);

	if nargin == 0
		% Without input, just return an completely empty combiner mapping (even
		% without defining the combination rule):

		v = mapping(mfilename,'combiner');
		return
	end	

	if isempty(a)
		% just return a combiner mapping with just the combining rule
		
		v = mapping(mfilename,'combiner',{[],type,name});
		
	elseif isa(a,'mapping') & isempty(w)
		
		% v = comb_classifier*fixedcc,
		% we combine a set of classifiers, not interesting, except for the
		% 'average' type, there a new affine transformation is computed:
		
		if isuntrained(a) % store untrained comb_classifier
			
			v = mapping(mfilename,'untrained',{a,type,name});
			
		else              % handle or store trained comb_classifier and all info
			
			[nclass,classlist] = renumlab(getlabels(a));

			% Special case is to average affine coefficients for 'average' combining
			switch type
			 case 'average'
			  if ~(isaffine(a) & size(classlist,1) == 2)
				  error('Average combining only possible for affine 2-class classifiers')
			  end
			  n = length(a.data);
			  rot = zeros(size(a,1),1);
			  off = 0;
			  for j=1:length(a.data)
				  rot = rot + a.data{j}.data.rot(:,1);
				  off = off + a.data{j}.data.offset(1);
			  end
			  v = affine(rot/n,off/n);			
			otherwise
			  % Standard procedure: make a new trained mapping
			  v = mapping(mfilename,'trained',{a,type,name});
			end
			v = set(v,'size_in',size(a,1),'size_out',size(classlist,1),'labels',classlist);
			v = setcost(v,a);
		end	
		
	elseif isa(a,'dataset') & isempty(w) 
		
		% Call like v = dataset*fixedcc,
		% Here the work will be done:
		% the dataset has already been mapped through the mappings, and the outputs
		% should be processed according to the combiner type.
		
		% get all the relevant parameters:
		[m,k] = size(a);
		featlist = getfeatlab(a);
		[nclass,classlist] = renumlab(featlist);
		c = size(classlist,1);
		d = zeros(size(a,1),c);
		b = +a;  % the classifier outputs to be processed

		% for each of the classes the outputs should now be combined to a new
		% one, using the combining rule:
		for j=1:c
			
			J = find(nclass==j);
			
			switch type
				
			case 'min'
			  d(:,j) = min(b(:,J),[],2);
			  
			case 'max'
			  d(:,j) = max(b(:,J),[],2);
			  
			case 'mean'
			  d(:,j) = mean(b(:,J),2);
			  
			case 'prod'
			  d(:,j) = prod(b(:,J),2);
			  
			case 'median'
			  d(:,j) = median(b(:,J),2);
			  
			case 'vote' % Assumes that classifier outcomes are well ordered in b
				% For voting we cannot combine the basic classifier outputs,
				% but we should use the classifier labels:
				n = size(a,2) / c;
				if ~isint(n)
					error('All classifiers should refer to all classes')
				end
				% First get the votes for each of the classes:
				[nf,fl] = renumlab(featlist);
				mlab = zeros(m,n);
				for j=1:n
					J = [(j-1)*c+1:j*c];
					labels = labeld(a(:,J));
					[nl,nlab,ll] = renumlab(fl,labels);
					mlab(:,j) = nlab;
				end
				% Then count the number of votes:
				for j=1:c
					d(:,j) = (sum(mlab==j,2)+1)/(n+c);
				end
				
			case 'average'
				error([newline 'Average combiner should directly call the classifiers' ...
				newline 'e.g. A*AVERAGEC([W1 W2 W3]), or A*([W1 W2 W3]*AVERAGEC)'])
				     
			otherwise
			  error(['Unknown method for fixed combining: ' type])
			end
			
		end
		
		v = setdata(a,d,classlist);
		
	elseif isa(a,'dataset') & isa(w,'mapping')
		
		% call like v = dataset * trained combiner (e.g. a*votec([u v w]))

		% This means that we first have to map the data through the mappings, and
		% then map this new dataset through the combiner:

		if strcmp(getmapping_file(w),mfilename)
			% Then we already have a nice combining rule:
			% get the relevant parameters:
			type = w.data{2};
			name = w.data{3};
			% Evaluate the mapped data (a*w.data{1}) by this combining rule:
			v = feval(mfilename,a*w.data{1},[],type,name);
		else
			% We will use the parameters given in the argument list
			% evaluate the mapped data (a*w) by this combining rule:
			v = feval(mfilename,a*w,[],type,name);
		end
		
	else                   % this should not happen
		
		error('Call cannot be parsed')
		
	end

	if isa(v,'mapping')
		v = setname(v,name);
	end

	return
