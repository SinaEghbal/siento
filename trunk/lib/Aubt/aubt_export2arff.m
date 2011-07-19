function export2arff (data, labels, featnames, labelnames, filename)

% number of features
[samplen, featlen] = size (data);
classlen = max (labels);

% create featnames if necessary
if isempty (featnames) | size (featnames, 1) ~= featlen
   featnames = cell (featlen, 1);
   for i = 1:featlen
      featnames{i} = ['F', num2str(i)]; 
   end
   featnames = char (featnames);
end

% create labelnames if necessary
if isempty (labelnames) | size (labelnames, 1) ~= classlen
    labelnames = cell (classlen, 1);
    for i = 1:classlen
       labelnames{i} = num2str (i); 
    end
    labelnames = char (labelnames);
end

% open file
fid = fopen (filename, 'w');

% write header
fprintf (fid, ['@RELATION ', filename, '\n']);
fprintf (fid, '\n');
for i = 1:featlen
  fprintf (fid, ['@ATTRIBUTE ', strtrim(featnames(i,:)), ' NUMERIC\n']);
end
fprintf (fid,['@ATTRIBUTE Class {']);
for i = 1:classlen-1
    fprintf (fid, [strtrim(labelnames(i,:)), ',']);
end
fprintf (fid, [strtrim(labelnames(i+1,:)), '}\n']);
fprintf (fid,'\n');

% write data
fprintf(fid, '@DATA\n');
for i = 1:samplen 
  for j = 1:featlen
    fprintf(fid,['%f,'], data(i,j));    
  end
  fprintf(fid, [strtrim(labelnames(labels(i),:)), '\n']); 
end

% close file
fclose (fid);