function path = aubt_getPath (file)

ind = strfind (file, filesep);
path = file(1:ind(length (ind)));