clear all;
% reading words from the database!
MPQADataReader;

AnewDataReader;


neutralCorrect = 0;
positCorrect = 0;
negatCorrect = 0;
neutralWrong = 0;
positWrong = 0;
negatWrong = 0;

for w = [1:length(MPQA_words)]
    [v a d] = anewVAD(MPQA_words_stem(w));
    w
    if ((v + a + d) ~= 0)
      
        if strcmp(MPQA_polarity(w),'neutral')
            if (v == 5)  
                neutralCorrect = neutralCorrect + 1;
            else
                neutralWrong = neutralWrong + 1;
            end
        end
        if strcmp(MPQA_polarity(w),'positive') 
            if (v > 5)  
                positCorrect = positCorrect + 1;
            else
                positWrong = positWrong + 1;
            end
        end
        if strcmp(MPQA_polarity(w),'negative')
            if (v < 5.0)
                negatCorrect = negatCorrect + 1;
            else
                negatWrong = negatWrong + 1;
            end
        end
    end
end


neutralCorrect 
positCorrect 
negatCorrect
neutralWrong
positWrong
negatWrong
