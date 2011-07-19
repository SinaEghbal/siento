function plot_classifier(dataset,classifier)

              
dataset = setprior(dataset,getprior(dataset));
W = pca(dataset,2);  % compute PCA on training set only
dataset = dataset*W;      % maps all data to 2D
% figure; gridsize(50); 
scatterd(dataset,'legend');


switch classifier

    case 'LDA'
        w1 = ldc; % Linear discriminant
        V = dataset*w1;    % compute classifier in 2D
        plotc(V);      % plot in 2D
        
    case 'Naive Bayes'
        w2 = naivebc;  % Naive Bayes
        V = dataset*w2;    % compute classifier in 2D
        plotc(V);      % plot in 2D
        
    case 'SVM'
        w3 = svc; % Support Vector Machines
        V = dataset*w3;    % compute classifier in 2D
        plotc(V);      % plot in 2D
        
    case 'K Nearest Neighbor'
        w4 = knnc(); % K Nearest Neighbor
        V = dataset*w4;    % compute classifier in 2D
        plotc(V);      % plot in 2D
        
    otherwise 
%         display (' No method has been selected ');
        
  end % Switch

end
