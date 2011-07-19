function  plot_featselect( mapped_data)

% Runs a number of classification schemes such as LDA, Quadratic, SVM and
% KNN classifiers
%
%  results = run_classifier(method, dataset, labels)
%   
%   input:
%   method :   Could be one of the following:  'LDA', 'Quadratic', 'SVM', 
%              'KNN'
%   dataset:   An  (M x N) feature matrix (or data set)  
%   labels :   Label vector (should be M x 1 vector)
%
%   output:
%   results: a matlab callsification performance object which contains standard
%            performance parameters  ErrorRate,CorrectRate, ErrorDistributionByClass,
%            Sensitivity and Specificity.
%
%   2009, Omar AlZoubi <oalz5092@usyd.edu.au>


% figure; gridsize(50);
scatterd(mapped_data,'legend');

end
