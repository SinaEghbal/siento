function results = run_classifier2(data, labels)

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
% indices = crossvalind('Kfold',labels,5);
% cp = classperf(labels); % initializes the CP object
% for i = 1:10
%     test = (indices == i); train = ~test;
%     class = knnclassify(data(test,:),data(train,:),labels(train)); 
%     classperf(cp,class,test); % updates the CP object with the current classification results
% end
%results = cp; % queries for the correct classification rate

%Construct the dataset
D = dataset(data,labels);
D = setprior(D,getprior(D));

numfolds=5;

%disp('Classification error: ' );

w6 = knnc; % Knn  
[err,class_err,map] = crossval(D,w6,numfolds);
error=abs(map-labels);
c_20=sum(error<=1)/length(map);
results.knn_correct=1-err;
results.knn_correct20=c_20;
results.knn_map=map;
%confmat=zeros

% disp(' Knn  = ' );
% disp(classper);
%knn=classper;

w1 = ldc; % Linear discriminant  
[err,class_err,map] = crossval(D,w1,numfolds);
error=abs(map-labels);
c_20=sum(error<=1)/length(map);
results.lda_correct=1-err;
results.lda_correct20=c_20;
results.lda_map=map;
% disp('LDA = ' );
% disp(classper);
% lda=classper;

w2 = qdc; % quadratic 
%classper = crossval(D,w2,5);
[err,class_err,map] = crossval(D,w2,numfolds);
error=abs(map-labels);
c_20=sum(error<=1)/length(map);
results.qdr_correct=1-err;
results.qdr_correct20=c_20;
results.qdr_map=map;
% disp(' quadratic = ' );
% disp(classper);
% quad=classper;

% w3 = mogc; % Mixture of gaussians 
% %classper = crossval(D,w3,0);
% [Training, Testing] = gendat(D,.5);
% w3 = mogc(Training);
% classper = testc(Testing*w3);
% disp(' Mixture of gaussians = ' );
% disp(classper);

w4 = svc; % Support vector 
%classper = crossval(D,w4,5);
[err,class_err,map] = crossval(D,w4,numfolds);
error=abs(map-labels);
c_20=sum(error<=1)/length(map);
results.svm_correct=1-err;
results.svm_correct20=c_20;
results.svm_map=map;
% disp(' Support vector = ' );
% disp(classper);
% svm=classper;

% w5 = bpxnc; % neural network with back-propagation 
% classper = crossval(D,w5,0);
% % [Training, Testing] = gendat(D,.8);
% % w5 = bpxnc(Training,3);
% % classper = testc(Testing*w5);
% disp(' NNBP = ' );
% disp(classper);
p(1)=sum(labels==1)/length(labels);
p(2)=sum(labels==2)/length(labels);
p(3)=sum(labels==3)/length(labels);
p(4)=sum(labels==4)/length(labels);
p(5)=sum(labels==5)/length(labels);
results.chance_correct=sum(p.^2);
results.chance_20=p(1)*(p(1)+p(2))+p(2)*(p(1)+p(2)+p(3))+p(3)*(p(2)+p(3)+p(4))+p(4)*(p(3)+p(4)+p(5))+p(5)*(p(4)+p(5));
%results=1-[knn,lda,quad,svm];
end
