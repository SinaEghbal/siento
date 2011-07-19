ANET_Address = 'E:\contrib\datasets\Datasets\ANET\ANETall_Win.txt';

tmlPath=fullfile(strrep(userpath,';',''),'tml');
A = SemanticSpace(fullfile(tmlPath,'example'),tmlPath);

cnt = 1;

fid = fopen(ANET_Address, 'r'); 
while 1 
    tline = fgetl(fid);
    if ~ischar(tline) 
        break 
    end 
    input = regexp(tline, '\t', 'split');
    
    if length(input) < 9
        continue
    end 
    
    ANET_No(cnt) = input(1);
    ANET_val(cnt) = input(2); 
    ANET_valSD(cnt) = input(3); 
    ANET_aro(cnt) = input(4); 
    ANET_aroSD(cnt) = input(5); 
    ANET_dom(cnt) = input(6); 
    ANET_domSD(cnt) = input(7); 
    ANET_set(cnt) = input(8); 
    ANET_sentence(cnt) = input(9);
    ANET_sentence_stem(cnt) = A.stemWords(input(9));
    cnt = cnt +1;
    
end

fclose(fid); 

ANET_sentence_stem = cell(ANET_sentence_stem);

clear cnt;
clear fid;
clear input;
clear tline;
clear ANET_Address;
clear A;
clear tmlPath;

