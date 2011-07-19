%% This configures the TML library in Matlab and must be run once
% a lib folder contains the jars used
% a lucene folder will contain the temp files produced (create the empty
% folder by hand)

fprintf('Setting the java classpaths within Matlab for TML.\n')

javaaddpath(fullfile('lib','glosser-tml-2.1.jar'))
javaaddpath(fullfile('lib','stanford-parser-1.6.0.jar'))
javaaddpath(fullfile('lib','weka-3.5.6.jar'))
javaaddpath(fullfile('lib'))
javaaddpath(fullfile('lib','lucene-snowball-2.3.0.jar'))
javaaddpath(fullfile('lib','log4j-1.2.14.jar'))

% javaaddpath(fullfile(strrep(userpath,';',''),'tml','lib','glosser-tml-2.1.jar'))
% javaaddpath(fullfile(strrep(userpath,';',''),'tml','lib','stanford-parser-1.6.0.jar'))
% javaaddpath(fullfile(strrep(userpath,';',''),'tml','lib','weka-3.5.6.jar'))
% javaaddpath(fullfile(strrep(userpath,';',''),'tml','lib'))
% javaaddpath(fullfile(strrep(userpath,';',''),'tml','lib','lucene-snowball-2.3.0.jar'))
% javaaddpath(fullfile(strrep(userpath,';',''),'tml','lib','log4j-1.2.14.jar'))


clear java
fprintf('Done.\n')
fprintf('To run TML from Matlab use:\n');
fprintf('tmlPath=fullfile(strrep(userpath,'';'',''''),''tml'')\n')
fprintf('A = SemanticSpace(''C:\\\\Path\\\\To\\\\Documents\\\\Folder'',tmlPath)\n')
fprintf('A.load()\n')
fprintf('M = A.getTermDocMatrix()\n')
fprintf('T = A.getTerms()\n')
fprintf('D = A.getDocuments()\n')