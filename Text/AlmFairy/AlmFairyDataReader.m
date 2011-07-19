%% processes corpora of 
% annotated children short stories compiled by
% Cecilia Ovesdotter Alm
% http://lrc.cornell.edu/swedish/dataset/affectdata/index.html 

%files = {'/Users/rafa/Desktop/Working/Dataset/AlmFairy/GrimmsAll4labsagree.txt'};

%for Stemming
tmlPath=fullfile(strrep(userpath,';',''),'tml');
A = SemanticSpace(fullfile(tmlPath,'example'),tmlPath);


AlmFairy_Address = 'E:\contrib\datasets\Datasets\AlmFairy\GrimmsAll4labsagree.txt';

cnt = 1;
fid = fopen(AlmFairy_Address, 'r'); 
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break
    end
    
    input = regexp(tline, '@', 'split');
    
    if length(input) < 3
        continue
    end
    
    AlmFairy_sid(cnt) = input(1);
    AlmFairy_emo(cnt) = input(2); 
    AlmFairy_sentence(cnt) = input(3);
    AlmFairy_sentence_stem(cnt) = A.stemWords(AlmFairy_sentence(cnt));
    
    cnt = cnt +1;
end
fclose(fid);

AlmFairy_sentence_stem = cell(AlmFairy_sentence_stem);

% run anew classifier on data
