function aubt_fisherPlot ( data, labels, colors,markertype, pointsize, labelnames)
% Uses fisher-transformation to project the data into a two dimensional 
% space and shows the result in a 2D plot. A legend is shown if labelnames
% is not empty.
%
%  aubt_fisherPlot (ahandle, data, labels, colors, [pointsize], [labelnames])
%   
%   input:
%   ahandle:    axes handle of the current figure
%   data:       feature matrix (one sample per row)
%   labels:     label vector
%   colors:     matrix with color values
%               one color [r, g, b] per row for each label
%   pointsize:  pointsize (default = 3)
%   labelnames: matrix with label names (default = [])
%               one name per row for each label
%               names are used to display a legend 
%
%   2005, Johannes Wagner <go.joe@gmx.de>

if nargin < 4 || isempty (pointsize)
   pointsize = 3; 
end

if nargin < 5
   labelnames = []; 
end


data = aubt_fisher (data, labels, 2);
%figure('Name','Fisher Projection');
%hold on;
for i = 1:max (labels)
  
    cdata = data (not (labels - repmat(i, size(data, 1), 1)), :);
 % scatter (cdata(:,1), cdata(:,2), 25,'MarkerFaceColor', colors(i,:), 'Marker', markertype(i,:), 'MarkerEdgeColor', 'k');
  scatter (cdata(:,1), cdata(:,2), 25,'MarkerFaceColor', colors(i,:), 'Marker', markertype(i,:));
     hold on;
end

if ~ isempty (labelnames)
    legend (labelnames);
end

hold off;