% ComputeRandAP: calculate the random baseline w.r.t. average precision
% 
% Parameters:
% Y_test: array of true labels
% class_set: set of all possible labels

function AvgPrec = ComputeRandAP(Y_test, class_set)

IterNum = 100;
for i = 1:IterNum
    Y_prob = rand(size(Y_test));
    AP(i) = ComputeAP(Y_prob, Y_test, class_set);
end;
AvgPrec = sum(AP) / IterNum;


