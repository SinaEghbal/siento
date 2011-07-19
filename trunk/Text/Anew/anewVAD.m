%% returns VAD for a single word
% [v a d] = anewVAD( w )

function [v a d] = anewVAD( w )

valence   = '0';
arousal   = '0';
dominance = '0';
         
% for each word in the db 

global ANEW_words;
global ANEW_words_stem; 
global ANEW_val ;
global ANEW_aro ;
global ANEW_dom;

count =0;
for i = [2:length(ANEW_words)]
     if strcmpi(ANEW_words_stem(i), w);
         valence   = cell2mat(ANEW_val(i));
         arousal   = cell2mat(ANEW_aro(i));
         dominance = cell2mat(ANEW_dom(i));
         break;
     end
end

v =  str2double(valence);
a = str2double(arousal);
d= str2double(dominance);

end

