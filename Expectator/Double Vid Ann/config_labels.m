mylabels={
    'Confusion' 
    'Frustration' 
    'Boredom' 
    'Flow/Engagement'
    'Curiosity' 
    'Delight'
    'Surprise'
    'Neutral'
    'Other'
    };

mylabelsTooltip={
    'Confusion - a noticeable lack of understanding'
    'Frustration - dissatisfaction or annoyance. from being stuck and not being able to accomplish a goal'
    'Boredom - being weary or restless through lack of interest'
    'Flow/Engagement - state of interest that results from involvement in an activity'
    'Curiosity - desire to acquire more knowledge or learn the material more deeply'
    'Delight - high degree of satisfaction'
    'Surprise - wonder or amazement, especially from the unexpected'
    'Neutral - no apparent emotion or feeling'
    'If emotion is not in the list, specify here'
 };





if length(mylabels)>12
    h=msgbox('Some Labels My Not Appear','Exceeded Maximum Labls','warn') 
    pause(4);
    close(h);
end