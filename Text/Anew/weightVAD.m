%% returns VAD for document (cell array)

function [valence arousal dominance] = weightVAD( doc )
%WEIGHTVAD Summary of this function goes here
%   Detailed explanation goes here

% init
valence = 0.;
arousal = 0.;
dominance = 0.;

% for each term get weights
count = 0;
for w=1:length(doc)
   if (anewVAD(doc{w})) 
       [v a d] = anewVAD(doc{w});
       valence = valence + v;
       arousal = arousal + a;
       dominance = dominance + d;
       count = count +1;
   end
end

if (count)
    valence = valence/count;
    arousal = arousal/count;
    dominance = dominance/count;
end

end

