%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

function [value,vote] = majority(t1,w)
%majority vote rule

w=cell2mat(w);

[d,n] = size(t1);
if (nargin==1), w=ones(1,n); end

if(d~=1), error('row vectors only !'); end

a = min(t1);
b = max(t1);
index = 0;
value = 0;
vote=0;

% normalize negative weights (neg kappa scores)
m=min(w);
w=(w+abs(m));
% w=(w+abs(m)).^2;
% w=w.^2;

for i=a:b   
    myvote = sum((t1==i).*w);
    if (myvote>vote)
        vote=myvote;
        value=i;
    end
end
