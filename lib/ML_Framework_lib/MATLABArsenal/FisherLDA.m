% FisherLDA: Fisher linear discriminant analysis
%
%	Usage:
%	[NEWSAMPLE, DISCRIM_VEC] = lda(SAMPLE, DISCRIM_VEC_N)
%	SAMPLE: Sample data with class information
%		(Each row of SAMPLE is a sample point, with the 
%		last column being the class label ranging from 1 to
%		no. of classes.)
%	DISCRIM_VEC_N: No. of discriminant vectors
%	NEWSAMPLE: new sample after projection
%
%	Reference:
%	J. Duchene and S. Leclercq, "An Optimal Transformation for
%	Discriminant Principal Component Analysis," IEEE Trans. on
%	Pattern Analysis and Machine Intelligence,
%	Vol. 10, No 6, November 1988
%
%	Roger Jang, 990829

function [newSampleIn, discrim_vec] = FisherLDA(sampleIn, label, discrim_vec_n, class_set)

if nargin < 3, discrim_vec_n = size(sampleIn ,2); end;
if nargin < 4, class_set = unique(label); end;
% Smooth factor
lambda = 0.9; 

% ====== Initialization
data_n = size(sampleIn, 1);
feature_n = size(sampleIn,2);
featureMatrix = sampleIn;
class_n = length(class_set);
sampleMean = mean(featureMatrix);

% ====== Compute B and W
% ====== B: between-class scatter matrix
% ====== W:  within-class scatter matrix
% MMM = \sum_k m_k*mu_k*mu_k^T
% U = sampleOut';
U = [];
for i = 1:class_n, U = [U; (label == class_set(i))']; end;
count = sum(U, 2);	% Cardinality of each class

% Each row of MU is the mean of a class
MU = U*featureMatrix./(count*ones(1, feature_n));
MMM = MU'*diag(count)*MU;
W = featureMatrix'*featureMatrix - MMM;
B = MMM - data_n*sampleMean'*sampleMean;
W = lambda .* W + (1 - lambda) .* eye(size(W));

% ====== Find the best discriminant vectors
invW = inv(W);
Q = invW*B;
D = [];
for i = 1:discrim_vec_n,
	[eigVec, eigVal] = eig(Q);
	[maxEigVal, index] = max(abs(diag(eigVal)));  
	D = [D, eigVec(:, index)];	% Each col of D is a eigenvector
	Q = (eye(feature_n)-invW*D*inv(D'*invW*D)*D')*invW*B;
end
newSampleIn = featureMatrix*D(:,1:discrim_vec_n); 
discrim_vec = D;
