ANEW_Address = 'E:\contrib\datasets\Datasets\ANEW\ANEW.TXT';


tmlPath=fullfile(strrep(userpath,';',''),'tml');
A = SemanticSpace(fullfile(tmlPath,'example'),tmlPath);


% read the ANEW database
global ANEW_words;
global ANEW_words_stem;
global ANEW_val ;
global ANEW_aro ;
global ANEW_dom;
[ANEW_words ANEW_freq ANEW_val ANEW_valSD ANEW_aro ANEW_aroSD ANEW_dom ANEW_domSD ANEW_freq2] = textread(ANEW_Address,'%s %s %s %s %s %s %s %s %s');

ANEW_words_stem = ANEW_words;

for i = [1:length(ANEW_words)]
     ANEW_words_stem(i) = A.stemWords(ANEW_words(i));
end

ANEW_words_stem = cell(ANEW_words_stem);
%ANEW_words = char(ANEW_words);

