% read CSV data file, [did, rater1, rater 2]
newData1 = importdata('test.csv');

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

[MaPrecision, MaRecall, MaF1, miPrecision, miRecall, miF1 ] = PerformanceX2(data)