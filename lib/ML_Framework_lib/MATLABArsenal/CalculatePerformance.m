% CalculatePerformance: calculate the classification performance
% 
% Parameters:
% Y_compute: array of predicted labels
% Y_test: array of true labels
% class_set: set of all possible labels
% verbosity: verbosity of the message outputs

function [yy, yn, ny, nn, prec, rec, F1, err, ap, bap] = CalculatePerformance(Y_compute, Y_prob, Y_test, class_set, verbosity) 

global preprocess; 

if (nargin <= 4), verbosity = preprocess.Verbosity; end;
num_class = length(class_set);
ap = 0; bap = 0;
if (num_class == 2), 
    % Make sure it's two-classes cases 
    [yy, yn, ny, nn, prec, rec, F1, err] = CalculateOnePerformance(Y_compute, Y_test, class_set);    
	if (preprocess.ComputeMAP == 1),
        ap = ComputeAP(Y_prob, Y_test, class_set);
      	bap = ComputeRandAP(Y_test, class_set);
    end;
    if (verbosity >= 1), 
        fprintf('YY:%d, YN:%d, NY:%d, NN:%d, Prec:%f, Rec:%f, Err:%f, Baseline=%f', ...
            yy, yn, ny, nn, prec, rec, err, max(sum(Y_test == class_set(1)), sum(Y_test ~= class_set(1))) / length(Y_test));
        if (preprocess.ComputeMAP == 1), 
      		fprintf(', AP:%f, BaseAP:%f', ap, bap);
		end;
	end;
    fprintf('\n');
elseif (size(Y_compute, 2) == 1),
    % multi-class one column
    err = NormalizeRatio(sum(Y_compute ~= Y_test), length(Y_test));      
    prec = 1 - err; rec = 1 - err; F1 = 1 - err;
    yy = 0; yn = 0; ny = 0; nn = 0;
    if (verbosity >= 1),
        fprintf('Prec:%f, Rec:%f, Err:%f\n', prec, rec, err);    
    end;
    if (verbosity > 1), 
        for i = 1:num_class
            for j = 1:num_class
                confusion_matrix(i, j) = sum((Y_compute == i) & (Y_test == j));
            end;
        end;
        disp(confusion_matrix);
    end;
else
    % multi-label multi-column
    actual_num_class = size(Y_compute, 2);
    for j = 1:actual_num_class,
        Y_compute_col = Y_compute(:, j);
        Y_test_col = Y_test(:, j);
        [yy(j), yn(j), ny(j), nn(j), prec(j), rec(j), F1(j), err(j)] = CalculateOnePerformance(Y_compute_col, Y_test_col, class_set) 
        if (verbosity >= 1), 
            fprintf('YY:%d, YN:%d, NY:%d, NN:%d, Prec:%f, Rec:%f, Err:%f,  Baseline=%f\n', ...
                yy(j), yn(j), ny(j), nn(j), prec(j), rec(j), err(j), max(sum(Y_test == class_set(1)), sum(Y_test ~= class_set(1))) / length(Y_test));
        end;
    end;
    % micro precison and recall
    %run.Macro_Prec = sum(run_class.prec) / actual_num_class;
    %run.Macro_Rec = sum(run_class.rec) / actual_num_class;
    %run.Macro_F1 = NormalizeRatio(2 * run.Macro_Prec * run.Macro_Rec, run.Macro_Prec + run.Macro_Rec);
    prec = NormalizeRatio(sum(yy), sum(yy) + sum(ny)); 
    rec = NormalizeRatio(sum(yy), sum(yy) + sum(yn));  
    F1 = NormalizeRatio(2 * prec * rec, prec + rec);
    err = sum(run_class.err) / actual_num_class;
    yy = 0; yn = 0; ny = 0; nn = 0;
end;

function [yy, yn, ny, nn, prec, rec, F1, err] = CalculateOnePerformance(Y_compute, Y_test, class_set) 

yy = sum((Y_compute == class_set(1)) & (Y_test == class_set(1)));
yn = sum((Y_compute ~= class_set(1)) & (Y_test == class_set(1)));
ny = sum((Y_compute == class_set(1)) & (Y_test ~= class_set(1)));
nn = sum((Y_compute ~= class_set(1)) & (Y_test ~= class_set(1)));
prec = NormalizeRatio(yy, yy + ny); 
rec = NormalizeRatio(yy, yy + yn); 
F1 = NormalizeRatio(2 * prec * rec , prec + rec);
err = NormalizeRatio(sum(Y_compute ~= Y_test), length(Y_test));