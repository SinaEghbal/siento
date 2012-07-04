% ParseCmd: parse the command line
%
% Parameters:
% classifier_str: classifier description string
% delimiter: delimiter to separate the command
% display: display the detailed infomation, default: 1
%
% Output parameters:
% classifier: the main classifier
% para: the parameters
% other_classifier: auxiliary classifiers
%

function [classifier, para, other_classifier] = ParseCmd(classifier_str, delimiter, display)

global preprocess;
if (nargin < 3), display = 1; end;
if (preprocess.Verbosity < 1), display = 0; end;
if (preprocess.Verbosity > 1), display = 1; end;

% Extract the parameters and classifiers
[classifier rem] = strtok(classifier_str);

para = [];
additional_classifier = [];
while (~isempty(rem)),
    [cell_para rem] = strtok(rem);
    if (strcmp(cell_para, delimiter)), break; end;
    if (~isempty(strmatch(delimiter, cell_para))), 
        rem = strcat(cell_para(3:length(cell_para)), rem);
        break;
    end;
    para = [para cell_para ' '];
end;

% remove the leading blanks
[r,c] = find((rem ~=0) & ~isspace(rem));
other_classifier = rem(min(c):length(rem));

if (display > 0), 
    fprintf('Classifier: %s, ', classifier);
end;