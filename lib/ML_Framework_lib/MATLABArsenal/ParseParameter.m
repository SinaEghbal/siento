% ParseParameter: parse the parameters 
%
% Parameters:
% str: parameter description string
% format: available options
% initpara: initial values
% display: display the detailed infomation, default: 1
%
% Output parameters:
% p: parameters
%

function p = ParseParameter(str, format, initpara, display)

global preprocess;

if (nargin < 4), display = 1; end;
if (preprocess.Verbosity < 1), display = 0; end;
if (preprocess.Verbosity > 1), display = 1; end;

p = initpara;
rem = str;

if (display > 0), fprintf('Parameters: '); end;
bEmpty = 1;
while (~isempty(rem)), 
    [tok, rem] = strtok(rem);
    if (strcmpi(tok, '-help') == 1),
        fprintf('(Usage) ');
        for i = 1:length(format), 
            fprintf('%s: %s ', char(format{i}), char(initpara{i}));
        end;
        fprintf('\n');
    end;
    for i = 1: length(format),
        if strcmpi(char(format{i}), tok), break; end;
    end;
    if (strcmpi(char(format{i}), tok)), 
        bEmpty = 0;
        [tok, rem1] = strtok(rem);
        if ((isempty(tok)) | ((tok(1) == '-') & isletter(tok(2)))), 
            % on/off parameters, next token is a keyword
            p{i} = '1';
            if (display > 0), fprintf('%s: %s ', char(format{i}), p{i}); end;
        else
            % real/binary value parameters
            p{i} = tok; rem = rem1;
            if (display > 0), fprintf('%s: %s ', char(format{i}), p{i}); end;
        end;
    end;
end;
if ((display > 0) & (bEmpty)), 
    fprintf('(def) ');
    for i = 1:length(format), 
        fprintf('%s: %s ', char(format{i}), char(initpara{i}));
    end;
end;
if (display > 0), fprintf('\n'); end;
