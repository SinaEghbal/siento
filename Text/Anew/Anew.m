%% Anew.m calculates distances bewteen 1 doc and emotions
% emotions are considered groups of words from the anew corpus


%Read all datasets

AnewDataReader;

%% define the emotions used in this experiment
% the definitions are synonyms or words from heuristics that indicate high
% likelihood of the emotion. They are not context based, so this is a naive
% approach.

emotionsMaker;

%% get the document
% from a folder
%directory = '/Users/rafa/MATLAB/siento/Text/example';

% from tcpConnection
% Payam
% 

% or define it here
doc1 = {'annoy' 'RAM'};

[X, Y, Z] = weightVAD(doc1); % get VA values for emotion

%% view what we have
% This should be code as a funtion to be reused
plot3(X, Y, Z,'o');
%grid on
axis square
hold on;
axis([1 9 1 9 1 9]);
xlabel('Valence');
ylabel('Arousal ');
zlabel('Dominance');


tx = linspace(0, X , 300);
ty = linspace(0, Y , 300);
tz = linspace(0, Z , 300);
    
plot3(X, Y, tz , 'red');
plot3(X, ty, Z, 'red');
plot3(tx, Y, Z, 'red');



% find distances to each emotion 
for emo=1:length(emotions)
    emotions(emo);
    [ex ey ez] = weightVAD(eval(char(emotions(emo))));
    
    tx = linspace(0, ex , 300);
    ty = linspace(0, ey , 300);
    tz = linspace(0, ez, 300);
    
    plot3(ex, ey, tz);
    plot3(ex, ty, ez);
    plot3(tx, ey, ez);
    
    
    plot3(ex, ey, ez, 'x');
    text(ex-.3,ey+.3, ez+.3,emotions(emo));
    %distance = [X Y Z] - [ex ey ez] 
end
hold off;

% plot valence arousal for each doc and emotions

% plotVA(docsX,docsY,'o',words);
% plotVA(emotionsX,emotionsY,'x',emotions);

% find closest emotion to document in VA space



