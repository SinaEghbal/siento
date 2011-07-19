function dataset = colcheck(dataset)

%function to remove feature columns that are not relevant
%(have the same value all over the instances) or thier Varinace = 0
% 
%Input : dataset
%output: reduced dataset with colmuns with zero variance removed
[m n] = size(dataset);

temp = [];
for i =1:n
if var(dataset(:,i)) ~=0
    temp = [temp dataset(:,i)];
end
end
dataset = temp;
end
