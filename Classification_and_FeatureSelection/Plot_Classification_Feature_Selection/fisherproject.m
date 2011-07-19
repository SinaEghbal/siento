%% Added by Omar Alzoubi 15 Apr 09
%  a script to view a fisher projection plot of the diffierent emotions
%% 
function fisherproject(data,labels,labelnames)
[c mt] = findcolor(labels);
aubt_fisherPlot(data,labels,c,mt,3,labelnames);
end
