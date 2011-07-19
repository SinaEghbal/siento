% Example on how to use the TML-Matlab integration class
% Author: Jorge Villalon

% This util is just to simplify the call to the constructor, it saves 
% in a variable the path to tml within the user documents.
% This is the directory that Matlab uses as default, and where you 
% were supposed to extract this file with the others.
%tmlPath=fullfile(strrep(userPath,';',''),'tml')
% tmlPath = fullfile('/Users/rafa/MATLAB/','tml')
% textPath= fullfile(experimentPath,'example')


tmlPath = fullfile('/Users/rafa/MATLAB/','tml')
experimentPath = '/Users/rafa/MATLAB/siento/Text/example'
%processingPath = fullfile(experimentPath,'Processing')
textPath= fullfile(experimentPath,'Text')
%physioPath= fullfile(experimentPath,'Physio')
%stimulusPath = fullfile(experimentPath,'Stimulus')

%experimentPath = '/Users/rafa/MATLAB/siento/Text'


% The creation of the semantic space with default values, this is:
% Term selection: Minimum number of documents. Threshold: 1
% Dimensionality reduction: No reduction. Threshold: -1
% Term weighting. Local: TF. Global: Idf.
A = SemanticSpace(experimentPath, tmlPath);

% Term selection criteria can be changed using this primitives
% 1: MIN_DF (Minimum number of documents the term appears)
% 2: MIN_TF (Minimum number of times the term appears in the corpus)
% 3: MIN_AVG_TF (Average number of times the term appears in one document)
A.setTermSelectionCriteria(1,1);

% Dimensionality reduction criteria can be changed using this primitives
% 1: DIMENSIONS_MAX_NUMBER (A fixed number of dimensions to keep)
% 2: DIMENSIONS_MAX_PERCENTAGE (A percentage of the dimensions will be
% kept)
% 3: VARIANCE_COVERAGE (A percentage of the total variance will be kept)
% 4: NO_REDUCTION (No reduction will be performed)
A.setDimensionalityReductionCriteria(1,2);

% Term weighting criteria can be changed using this primitives
% Local weight
% 1: Binary
% 2: LOGTF 
% 3: TF
% 4: TFn
% Global weight
% 1: Entropy
% 2: GfIdf
% 3: Idf
% 4: None
% 5: Normal
%
% Descriptions and formulas for each can be found in tml documentation
A.setTermWeightingCriteria(1,1);

% Once the parameters are set, the semantic space is loaded
A.load();

% You can retrieve the Term by Documents matrix
M = A.getTermDocMatrix();

% The vector with the terms corresponding to the matrix
T = A.getTerms();

% The vector with the documents corresponding to the matrix
D = A.getDocuments();


[U,S,V] = svd(M);

% Truncated SVD
k = 2;
Uk = U(:, 1:k)
Sk = S(1:k,1:k)
Vk = V(:,1:k)

% plot 
lsaPlot (Uk, Sk, Vk,T,D);
