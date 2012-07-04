% ComputeAP: calculate the average precision
% 
% Parameters:
% Y_prob: array of predicted probability
% Y_test: array of true labels
% class_set: set of all possible labels

function AvgPrec = ComputeAP(Y_prob, Y_test, class_set)

[junk, Index] = sort(-Y_prob);
TrueLabel = Y_test(Index);
AvgPrec = 0;
NumPos = 0;
for j = 1:length(TrueLabel)
    NumPos = NumPos + (TrueLabel(j) == class_set(1));
    AvgPrec = AvgPrec + (TrueLabel(j) == class_set(1)) * NumPos / j;
end;
if (sum(TrueLabel == class_set(1)) ~= 0) 
	AvgPrec = AvgPrec / sum(TrueLabel == class_set(1));
end;
	