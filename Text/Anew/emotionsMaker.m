%for stemming
tmlPath=fullfile(strrep(userpath,';',''),'tml');
A = SemanticSpace(fullfile(tmlPath,'example'),tmlPath);


% for Atutor: boredom, flow, confusion, frustrution, delight and surprise
confusion = {'confused' 'puzzled' 'perplexed' 'baffled' 'disconcerted' 'what?' 'i dont know' 'skeptical' 'what?' 'o no'};
frustration = {'frustrated' 'annoyed' 'irritation' 'discontent'};
surprise = {'surprised' 'unexpected' 'wow','astonishment','amazement','wonder','disbelief'}; 
boredom =  {'bored' 'apathy' 'tedium' 'lethargy' 'monotony'};
flow = {'flow' 'concentrate' 'focus' 'immersed' 'involvement'};
delight = {'delight' 'joy' 'desire'};

% for AlmFairy
% Angry-Disgusted (code: 2; merged), Fearful (code: 3), Happy (code: 4),
% Sad (code: 6), and Surprised (code: 7; merged)
AngryDisgusted = {'mad' 'annoyed' 'cross' 'vexed' 'irritated' 'raging'};
Fearful = {'frightened' 'scared' 'terrified' 'petrified' 'uneasy' 'anxious'};
Happy = {'happy' 'merry' 'joy' 'jovial' 'jolly' 'delight' 'pleased'};
Sad  = {'sad' 'cry' 'sorrow' 'depressed' 'gloom' 'dismal'};
Surprised = surprise;

% all the emotions in this particular experiment are
emotions = {'confusion' 'frustration' 'surprise' 'boredom' 'flow' 'delight'};

AlmFairy_emotions = {'AngryDisgusted' 'Fearful' 'Happy' 'Sad' 'Surprised'};
AlmFairy_emotions_codes = [2, 3, 4, 6, 7];

for emo=1:length(emotions)
    tmp = char(emotions(emo));
    name = strcat(tmp, '_stem');
    emotions_val = eval(tmp);
    val = cell(1,length(emotions_val));
    for emo_v=1:length(emotions_val)
        val(emo_v) = A.stemWords(emotions_val(emo_v));
    end
    val = cell(val);
    assignin('base', name,val); 
end
for emo=1:length(AlmFairy_emotions)
    tmp = char(AlmFairy_emotions(emo));
    name = strcat(tmp, '_stem');
    emotions_val = eval(tmp);
    val = cell(1,length(emotions_val));
    for emo_v=1:length(emotions_val)
        val(emo_v) = A.stemWords(emotions_val(emo_v));
    end
    val = cell(val);
    assignin('base', name,val); 
end
