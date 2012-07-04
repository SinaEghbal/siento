% NormalizeRatio: compute the ratio between two numbers except that it will
% output zero when the denominator is 0
%

function result = NormalizeRatio(Numerator, Denominator)

if (Denominator ~= 0) 
    result =  Numerator / Denominator;    
else
    result = 0;
end;