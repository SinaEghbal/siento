function [C mt]= findcolor(labels)

% function C = findcolor(labels)
% assigns a color and a marker type for every row in labels, for use
% with fisher projection plot
%
% Input: 
% lables: a vector matrix of n x 1 class labels
%
% Output:
% C: a vector matrix of n x 1 color codes [r g b m y c w k]
[n m] = size(labels);
for i = 1:n
    
    switch labels(i)
        case 1
            C(i) = 'r';
            mt(i) = '+';
        case 2
            C(i) = 'g';
            mt(i) = 'o';
        case 3
            C(i) = 'b';
            mt(i) = 'x';
        case 4
            C(i) = 'y';
            mt(i) = 'p';
        case 5
            C(i) = 'k';
            mt(i) = 'v';
        case 6
            C(i) = 'm';
            mt(i) = 'd';
        case 7
            C(i) = 'c';
            mt(i) = '*';
        case 8
            C(i) = 'w';
            mt(i) = '^';
         
    end
end
C = reshape(C,n,1);
mt = reshape(mt,n,1);
end