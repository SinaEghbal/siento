function Sample1(index)

if nargin < 1, index = 1; end;

clear global preprocess;

switch index
    case 1,
    % Classify DataExample1.txt with shot information('-sh 1')
    % Shuffle the data before classfication ('-sf 1')
    % 3 folder Cross Validation 
    % Linear Kernel Support Vector Machine

		Arsenal('classify -t DataExample1.txt -sf 1 -- LibSVM -Kernel 0 -CostFactor 3');

    case 2,
    % Classify DataExample1.txt with shot information('-sh 1')
    % Shuffle the data before classfication ('-sf 1')
    % Reduce the number of dimension to 15
    % 3 folder Cross Validation 
    % 3 Nearest Negihbor

		Arsenal('classify -t DataExample1.txt -sf 1 -svd 15 -- cross_validate -t 3 -- kNN_classify -k 3');
           
    case 3,
    % Classify DataExample2.txt with shot information('-sh 1')
    % Do not shuffle the data
    % Use first 100 data as training, the rest as testing  
    % Apply a multi-class classification wrapper 
    % RBF Kernel SVM_LIGHT Support Vector Machine

		Arsenal('classify -t DataExample2.txt -sf 0 -- Train_Test_Validate -t 100 -- Train_Test_Multiple_Class -- SVM_Light -Kernel 2 -KernelParam 0.01 -CostFactor 3');

    case 4,
    % Train with DataExample2.train.txt, Test with DataExample2.test.txt 
    % Do not shuffle the data
    % Use Weka provided C4.5 Decision Trees
    % AdaBoostM1 Wrapper
    % No Multi-class Wrapper for Weka 

		Arsenal('classify -t DataExample2.train.txt -sf 0  -- Test_File_Validate -t DataExample2.test.txt -- MCAdaBoostM1 -- WekaClassify -MultiClassWrapper 0 -- trees.J48');
           
    case 5,
    % Classify DataExample2.txt with shot information('-sh 1')
    % Do not shuffle the data
    % Rewrite the output file 
    % Use first 100 data as training, the rest as testing  
    % Apply a stacking classification wrapper, first learn three classifiers based on features (1..120), (121..150) and (154..225), then do majority voting on top    
    % Improved Iterative Scaling with 50 iterations
		Arsenal('classify -t DataExample2.txt -sf 0 -oflag w  -- Train_Test_Validate -t 100 -- MCWithMultiFSet -Voting -Separator 1,120,121,150,154,225 -- IIS_classify -Iter 50');;

	case 6,	  
	  % Classify DataExample1.txt 
		% Training the model using DataExample1.train.txt
		% Linear Kernel Support Vector Machine

		Arsenal(strcat('classify -t DataExample1.train.txt -- Train_Only -m DataExample1.libSVM.model -- LibSVM -Kernel 0 -CostFactor 3'));

		% Classify DataExample1.txt 
		% Testing the new data for DataExample1.test.txt using DataExample1.libSVM.model
		% Linear Kernel Support Vector Machine

		Arsenal(strcat('classify -t DataExample1.test.txt -- Test_Only -m DataExample1.libSVM.model -- LibSVM -Kernel 0 -CostFactor 3'));

   	case 7,	  

  		Arsenal(strcat('classify -if 2 -t DataExample3.txt -- LibSVM -Kernel 0 -CostFactor 10'));

end;