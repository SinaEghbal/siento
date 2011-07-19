%load emotiomML file
str1=xml_load('emotionML.xml');
%emotiomML Parse Variables
str2=xml_parseany(str1);

%retrieve emotiomML variables to matlab
xmlNS2=str2.ATTRIBUTE.xmlns;
dateTime2=str2.emotion{1}.ATTRIBUTE.date;
catSet2=str2.emotion{1}.category{1}.ATTRIBUTE.set;
catName2=str2.emotion{1}.category{1}.ATTRIBUTE.name;
modMed2=str2.emotion{1}.modality{1}.ATTRIBUTE.medium;
modMode2=str2.emotion{1}.modality{1}.ATTRIBUTE.mode;
linkURI2=str2.emotion{1}.link{1}.ATTRIBUTE.uri;
lStart2=str2.emotion{1}.link{1}.ATTRIBUTE.start;
lEnd=str2.emotion{1}.link{1}.ATTRIBUTE.end;