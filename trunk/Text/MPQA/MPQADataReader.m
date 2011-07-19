MPQA_Address = 'MPQA.txt';

tmlPath=fullfile(strrep(userpath,';',''),'tml');
A = SemanticSpace(fullfile(tmlPath,'example'),tmlPath);

[MPQA_type  MPQA_len MPQA_word1 MPQA_pos1 MPQA_stemmed1 MPQA_priorpolarity] = textread(MPQA_Address,'%s %s %s %s %s %s');

for jj = [1:length(MPQA_type)]
     input = regexp(MPQA_word1(jj), '=', 'split');
     MPQA_words(jj) = input{1,1}(2);
     MPQA_words_stem(jj) = A.stemWords(MPQA_words(jj));
     input = regexp(MPQA_priorpolarity(jj), '=', 'split');
     MPQA_polarity(jj) = input{1,1}(2);

end

MPQA_words_stem = cell(MPQA_words_stem);

clear input;
clear jj;
clear MPQA_type;
clear MPQA_len;
clear MPQA_word1;
clear MPQA_pos1;
clear MPQA_stemmed1;
clear MPQA_priorpolarity;
clear MPQA_Address;

