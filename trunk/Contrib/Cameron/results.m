a_byRate=zeros(5,2);
v_byRate=zeros(5,2);
for i=1:10 %for each subject
    [actual_arousal,chance_arousal,actual_valence,chance_valence,a_rate,v_rate]=analyse(i);
    arousal_matrix(i,:)=actual_arousal;
    valence_matrix(i,:)=actual_valence;
    chancev_matrix(i,:)=chance_valence;
    chancea_matrix(i,:)=chance_arousal;
    %a_byRate=a_byRate+a_rate;
    %v_byRate=a_byRate+v_rate;
end
