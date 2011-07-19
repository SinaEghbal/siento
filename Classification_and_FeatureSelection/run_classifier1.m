function results = run_classifier1(method, data, labels)

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

% Runs KKN classifier with 10 fold cross validation
indices = crossvalind('Kfold',labels,10);
cp = classperf(labels); % initializes the CP object
for i = 1:10
    test = (indices == i); train = ~test;
    class = knnclassify(data(test,:),data(train,:),labels(train)); 
    classperf(cp,class,test); % updates the CP object with the current classification results
end
results = cp; % queries for the correct classification rate

%Construct the dataset
D = dataset(data,labels);
D = setprior(D,getprior(D));

w1 = ldc; % Linear discriminant  
classper = crossval(D,w1,5);
disp('Classification error: ' );
disp('LDA = ' );
disp(classper);

w2 = qdc; % quadratic 
classper = crossval(D,w2,5);
disp(' quadratic = ' );
disp(classper);

% w3 = mogc; % Mixture of gaussians 
% %classper = crossval(D,w3,0);
% [Training, Testing] = gendat(D,.5);
% w3 = mogc(Training);
% classper = testc(Testing*w3);
% disp(' Mixture of gaussians = ' );
% disp(classper);

w4 = svc; % Support vector 
classper = crossval(D,w4,5);
disp(' Support vector = ' );
disp(classper);

% w5 = bpxnc; % neural network with back-propagation 
% %classper = crossval(D,w5,0);
% [Training, Testing] = gendat(D,.8);
% w5 = bpxnc(Training,3);
% classper = testc(Testing*w5);
% disp(' NNBP = ' );
% disp(classper);

w6 = knnc; % Knn  
classper = crossval(D,w6,5);
disp(' Knn  = ' );
disp(classper);
end
