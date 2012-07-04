% GetModelFilename: Obtain the model filename for save/load parameters
%
% Output:
% model_file: the next model filename 
% 
function [model_file] = GetModelFilename()

global temp_model_file preprocess;

if (isempty(preprocess.model_file)),
    model_file = temp_model_file;
else
    model_file = sprintf('%s.model%d', preprocess.model_file, preprocess.CurModelCount);
    preprocess.CurModelCount = preprocess.CurModelCount + 1;
end;

return;