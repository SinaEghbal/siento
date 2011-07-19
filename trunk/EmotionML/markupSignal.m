%% define all the variables to be used in emotionML
xmlNS='http://www.w3.org/2008/11/emotiomml';
dateTime=datestr(now);
catSet='everyday';
catName='joy';
modMed='physiological';
modMode1='ecg';
modMode2='emg';
modMode3='gsr';
linkECG='ecg.mat';
linkEMG='emg.mat';
linkGSR='gsr.mat';


%%  SPECIAL FIELDNAMES
%     .ATTRIBUTE.              define additional attributes by using subfields, eg V.ATTRIBUTE.type='mydbtype'
%     .CONTENT                 define content if attribute field given (all capitals)
%     .ATTRIBUTE.NAMESPACE     define namespace (all capitals)
%     .ATTRIBUTE.TAGNAME       define element tag name (if not an allowed Matlab fieldname in struct)  e.g.: v.any.ATTRIBUTE.TAGNAME = 'xml-gherkin'

%% create varables for XML/emotionML
v.ATTRIBUTE.xmlns=xmlNS; %create emotionML namespace

%<emotion> for ECG
v.emotion(1).ATTRIBUTE.date=dateTime;
v.emotion(1).category.ATTRIBUTE.set=catSet;
v.emotion(1).category.ATTRIBUTE.name=catName;
v.emotion(1).modality.ATTRIBUTE.medium=modMed;
v.emotion(1).modality.ATTRIBUTE.mode=modMode1;
v.emotion(1).link.ATTRIBUTE.uri=linkECG;

%<emotion> for EMG
v.emotion(2).ATTRIBUTE.date=dateTime;
v.emotion(2).category.ATTRIBUTE.set=catSet;
v.emotion(2).category.ATTRIBUTE.name=catName;
v.emotion(2).modality.ATTRIBUTE.medium=modMed;
v.emotion(2).modality.ATTRIBUTE.mode=modMode2;
v.emotion(2).link.ATTRIBUTE.uri=linkEMG;

%<emotion> for GSR
v.emotion(3).ATTRIBUTE.date=dateTime;
v.emotion(3).category.ATTRIBUTE.set=catSet;
v.emotion(3).category.ATTRIBUTE.name=catName;
v.emotion(3).modality.ATTRIBUTE.medium=modMed;
v.emotion(3).modality.ATTRIBUTE.mode=modMode3;
v.emotion(3).link.ATTRIBUTE.uri=linkGSR;

%% create the XML/emotionML 
str1=xml_formatany(v, 'emotionml');

% Save the XML document.
dlmwrite('emotionML.xml', str1, '')
