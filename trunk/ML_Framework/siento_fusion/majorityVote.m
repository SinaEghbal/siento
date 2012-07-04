%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

function [value,vote] = majorityVote(t1,w,label_vec)
%majority vote preprocess

[d,n] = size(t1); % d=ch; n=instance;

if (nargin==1), w=ones(1,n); end

if(d==1)
    [value,vote] = majority(t1,w);
else
    if (nargin==1), w=ones(1,d); end
    value = zeros(1,n);
    vote = zeros(1,n);
    
    for i=1:n
        [value(i),vote(i)] = majority(t1(:,i)',w);
    end
end
