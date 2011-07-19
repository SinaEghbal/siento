%FDSC Feature based Dissimilarity Space Classification (outdated)
%
%  This routine is outdated, use KERNELC instead
%
%   W = FDSC(A,R,FEATMAP,TYPE,P,CLASSF)
%   W = A*FDSC([],R,FEATMAP,TYPE,P,CLASSF)
%
% INPUT
%   A       Dateset used for training
%   R       Dataset used for representation
%           or a fraction of A to be used for this.
%           Default: R = 0.2.
%   FEATMAP Preprocessing in feature space (e.g. SCALEM)
%           Default: no preprocessing.
%   TYPE    Dissimilarity rule, see PROXM
%           Default 'DISTANCE'.
%   P       Parameter for dissimilarity rule, see PROXM
%           Default P = 1.
%   CLASSF  Classifier used in dissimilarity space
%           Default FISHERC.
%
% OUTPUT
%   W       Resulting, trained feature space classifier
%
% DESCRIPTION
% This routine builds a classifier in feature space based on a 
% dissimilarity representation defined by the representation set R
% and the dissimilarities found by A*FEATMAP*PROXM(R*FEATMAP,TYPE,P).
% FEATMAP is a preprocessing in feature space, e.g. scaling
% (SCALEM([],'variance') or pre-whitening (KLMS).
%
% R can either be explicitely given, or by a fraction of A. In the
% latter case the part of A that is randomly generated to create the
% representation set R is excluded from the training set.
%
% New objects in feature space can be classified by D = B*W or by
% D = MAP(B,W). Labels can be found by LAB = D*LABELD or LAB = LABELD(D).
%
% EXAMPLE
% A = GENDATB([100 100]);    % Training set of 200 objects
% R = GENDATB([10 10]);      % Representation set of 20 objects
% W = FDSC(A,R);             % Compute classifier
% SCATTERD(A);               % Scatterplot of trainingset
% HOLD ON; SCATTERD(R,'ko'); % Add representation set to scatterplot
% PLOTC(W);                  % Plot classifier
%
% SEE ALSO
% DATASETS, MAPPINGS, SCALEM, KLMS, PROXM, LABELD

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function w = fdsc(a,r,featmap,type,p,classf)

warning('FDSC is outdated, use KERNELC instead')

if nargin < 6 | isempty(classf), classf = fisherc; end
if nargin < 5 | isempty(p), p = 1; end
if nargin < 4 | isempty(type), type = 'distance'; end
if nargin < 3 | isempty(featmap), featmap = []; end
if nargin < 2, r = 0.2; end
if nargin < 1 | isempty(a)
		w1 = mapping(mfilename,'untrained',{r,featmap,type,p,classf}); 
		w = setname(w1,'FeatDisSpaceC');
	return
end


isvaldfile(a,1,2); % at least 1 object per class, 2 classes

if isdataset(a) | isdatafile(a)
	isvaldfile(a,1,1);
	if isempty(featmap)
		v = scalem(a); % shift mean to the origin
	elseif isuntrained(featmap)
		v = a*featmap;
	elseif ismapping(featmap)
		v = featmap;
	else
		error('Feature mapping expected')
	end
	if isempty(r)
		r = a;
	elseif is_scalar(r)
		[r,a] = gendat(a,r);
	end
	w = proxm(r*v,type,p);
	if ~isuntrained(classf)
		error('Untrained classifier expected')
	end
	b = a*v*w;
	%b = testdatasize(b);
	u = b*classf;
	w = v*w*u;
else
	error('Unexpected input')
end
	

	

