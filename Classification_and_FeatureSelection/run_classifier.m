function [classper,NLAB_OUT] = run_classifier( dataset,classifier)

% Runs a number of classification schemes such as LDA, Quadratic, SVM and
% KNN classifiers
%
%  results = run_classifier(method, dataset, labels)
%   
%   input:
%   method :   Could be one of the following:  'LDA', 'Quadratic', 'SVM', 'KNN'
%   dataset:   ( dataset mapping)  
%   
%   output:
%   results: a matlab callsification performance object which contains standard
%            performance parameters  ErrorRate,CorrectRate, ErrorDistributionByClass,
%            Sensitivity and Specificity.
%   classifier_mapping: Classification Model

%   2009, Omar AlZoubi <oalz5092@usyd.edu.au>


dataset = setprior(dataset,getprior(dataset));

switch classifier

    case 'LDA'
         
%       [ERR,CERR,NLAB_OUT] = CROSSVAL(A,CLASSF,N,1,TESTFUN) 
         w1 = ldc; % Linear discriminant
%          classper = crossval(dataset,w1,10);
         [classper,CERR,NLAB_OUT] = crossval(dataset,w1,10);
         disp('Classification error: ' );
         disp('LDA = ' );
         disp(classper);
         

    case 'Naive Bayes'
 
         w2 = naivebc;  % Naive Bayes
%         classper = crossval(dataset,w2,10);
         [classper,CERR,NLAB_OUT]= crossval(dataset,w2,10);
         disp(' NaiveBayes = ' );
         disp(classper);
                  
    case 'qdc'      
    
        % w3 = qdc; % quadratic 
        % classper = crossval(dataset,w3,5);
        % disp(' quadratic = ' );
        % disp(classper);
    
    case 'mogc'

        % w4 = mogc; % Mixture of gaussians 
        % classper = crossval(dataset,w3,0);
        % [Training, Testing] = gendat(D,.5);
        % w3 = mogc(Training);
        % classper = testc(Testing*w3);
        % disp(' Mixture of gaussians = ' );
        % disp(classper);

    case 'SVM'

        w4 = svc; % Support Vector Machines
%         classper = crossval(dataset,w4,10);
        [classper,CERR,NLAB_OUT]= crossval(dataset,w4,10);
        disp(' Support vector = ' );
        disp(classper);
        
        
    case 'ANN'

        % w5 = bpxnc; % neural network with back-propagation 
        % %classper = crossval(dataset,w5,0);
        % [Training, Testing] = gendat(dataset,.8);
        % w5 = bpxnc(Training,3);
        % classper = testc(Testing*w5);
        % disp(' NNBP = ' );
        % disp(classper);
    
    case 'K Nearest Neighbor'

        w6 = knnc(); % K Nearest Neighbor
%         classper = crossval(dataset,w6,10);
        [classper,CERR,NLAB_OUT]= crossval(dataset,w6,10);
        disp(' Knn  = ' );
        disp(classper);
        
     otherwise 
        classper = ' No method has been selected ';
                
end % Switch



end
