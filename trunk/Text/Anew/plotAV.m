clear all;
AnewDataReader;


xlabel('Arousal');
ylabel('Valence'); 
axis([1 9 1 9]);
title('ANEW');
hold on;

valence_up = 0;
arousal_up = 0;
valence_down = 0;
sym = '.';
for i = [2:length(ANEW_words)]
    valence   = str2double(cell2mat(ANEW_val(i)));
    arousal   = str2double(cell2mat(ANEW_aro(i)));
    %dominance = cell2mat(ANEW_dom(i));
    if (valence > 8.8 | arousal < 2.5 | valence < 1.3 | arousal > 8.3)
        color = 'red';
    else
         color = 'blue';
    end
    
    if (valence > 8.8)
        if (valence_up == 0)
            txt = strcat (ANEW_words(i),'\rightarrow');
            text(arousal,valence,txt,'HorizontalAlignment','right','Color',color);
            valence_up = 1;
        else
            %txt = strcat ('\leftarrow', ANEW_words(i));
            %text(arousal,valence,txt,'Color',color);
            color = 'blue';
            valence_up = 0;
        end
    end
    
    if (arousal > 8.3)
        if (arousal_up == 0)
            txt = strcat (ANEW_words(i),'\rightarrow');
            text(arousal,valence,txt,'HorizontalAlignment','right','Color',color);
            arousal_up = 1;
        else
            txt = strcat ('\leftarrow', ANEW_words(i));
            text(arousal,valence,txt,'Color',color);
            arousal_up = 0;
        end
    end
    
    if (valence < 1.3)
        if (valence_down == 0)
            txt = strcat (ANEW_words(i),'\rightarrow');
            text(arousal,valence,txt,'HorizontalAlignment','right','Color',color);
            valence_down = 1;
        else
            %txt = strcat ('\leftarrow', ANEW_words(i));
            %text(arousal,valence,txt,'Color',color);
            color = 'blue';
            valence_down = 0;
        end
    end
    
    if (arousal < 2.5)
        txt = strcat ( ANEW_words(i),'\rightarrow');
        text(arousal,valence,txt,'HorizontalAlignment','right','Color',color);
    end
    
    plot( arousal, valence, sym,'Color',color);
end

plot([0, 9], [5 , 5],'black');
plot([5 ,5], [0, 9], 'black');

hold off;
%gname(ANEW_words)
