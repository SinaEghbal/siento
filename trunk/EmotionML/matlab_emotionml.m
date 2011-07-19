%define all the variables to be used in emotionML
xmlNS='http://www.w3.org/2008/11/emotiomml';
dateTime=datestr(now);
catSet='everyday';
catName='anger';
modMed='physiological';
modMode='body';
linkURI='ecg.mat';
lStart='2000';
lEnd='3999';

% SPECIAL FIELDNAMES
%     .ATTRIBUTE.              define additional attributes by using subfields, eg V.ATTRIBUTE.type='mydbtype'
%     .CONTENT                 define content if attribute field given (all capitals)
%     .ATTRIBUTE.NAMESPACE     define namespace (all capitals)
%     .ATTRIBUTE.TAGNAME       define element tag name (if not an allowed Matlab fieldname in struct)  e.g.: v.any.ATTRIBUTE.TAGNAME = 'xml-gherkin'

%create varables for XML/emotionML
v.ATTRIBUTE.xmlns=xmlNS;
v.emotion.ATTRIBUTE.date=dateTime;
v.emotion.category.ATTRIBUTE.set=catSet;
v.emotion.category.ATTRIBUTE.name=catName;
v.emotion.modality.ATTRIBUTE.medium=modMed;
v.emotion.modality.ATTRIBUTE.mode=modMode;
v.emotion.link.ATTRIBUTE.uri=linkURI;
v.emotion.link.ATTRIBUTE.start=lStart;
v.emotion.link.ATTRIBUTE.end=lEnd;

%create the XML/emotionML 
str1=xml_formatany(v, 'emotionml');

% Save the XML document.
% xmlFileName = fullfile(pathname, filename);
xml_save('emotionML',str1,'off');
