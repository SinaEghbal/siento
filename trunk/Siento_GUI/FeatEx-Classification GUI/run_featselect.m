function mapped_data = run_featselect( dataset,featsel)

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

dataset = setprior(dataset,getprior(dataset));

switch featsel

    case 'PCA'

        W = pca(dataset,2);  % compute PCA 
        dataset = dataset*W;      % maps all data to 2D
        mapped_data = dataset;

    case 'Fisher Projection'

        W = fisherm(dataset,2);  % compute fisher projection
        dataset = dataset*W;      % maps all data to 2D
        mapped_data = dataset;
      
    case 'Non Linear Fisher Projection'      

        W = nlfisherm(dataset,2);  % compute Non Linear Fisher Projection
        dataset = dataset*W;      % maps all data 
        mapped_data = dataset;
    
    case 'Forward feature selection'

        W = featself(dataset,'NN',20);  % compute Forward feature selection
        dataset = dataset*W;      % maps all data 
        mapped_data = dataset;
        
    case 'Backward feature selection'

        W = featselb(dataset);  % compute Backward feature selection
        dataset = dataset*W;      % maps all data 
        mapped_data = dataset;

    case 'floating forward feature selection'

        W = featselp(dataset);  % compute floating forward feature selection
        dataset = dataset*W;      % maps all data 
        mapped_data = dataset;
    
    otherwise 
        mapped_data = [];
                
end % Switch

end
