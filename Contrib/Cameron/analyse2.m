function [res_a,res_v]=analyse2(k)
load(fullfile('C:\Experiment',int2str(k),'Processing\features.mat'));
%load(fullfile('C:\Experiment',int2str(k),'Processing\features_ten_s.mat'))

% %compare to iaps scale
load('C:\Experiment\General_Data\rate_scaled')
sam_a=rate(:,1);
sam_v=rate(:,2);
 feat_a=mergedfeatmat;
 feat_v=feat_a;
 %sam_a=mergedsammat(:,1);
 %sam_v=mergedsammat(:,2);

% % %Ecg features only
% ecgfeat=mergedfeatmat(:,1:84);
% %Eeg features only
% eegfeat=mergedfeatmat(:,127:172);
% % %sc features only
% scfeat=mergedfeatmat(:,106:126);
% % %emg features only
% emgfeat=mergedfeatmat(:,85:105);
% mergedfeatmat=[ecgfeat,eegfeat,scfeat];

%remove rows that didn't pass ttest
% load('C:\Experiment\General_Data\ttest.mat','success_ar','success_va');
% ind=find(success_ar(:,1));
% feat_a=removerows(mergedfeatmat,ind);
% sam_a=removerows(mergedsammat(:,1),ind);
% ind=find(success_va(:,1));
% feat_v=removerows(mergedfeatmat,ind);
% sam_v=removerows(mergedsammat(:,2),ind);


%reduce data set in case <=3 instances of a particular class
[feat_a,sam_a]=eliminate_redundant_classes(feat_a,sam_a);
%reduce data set in case <=3 instances of a particular class
[feat_v,sam_v]=eliminate_redundant_classes(feat_v,sam_v);

%FEATURE REDUCTION
% feat_a=pca(feat_a);
% feat_v=pca(feat_v);


cm_a=zeros(5,5);
cm_v=zeros(5,5);
% for i=1:4
%     if i==1
%         type='knn';
%     else if i==2
%             type='lda';
%         else if i==3
%                 type='Quadratic';
%             else if i==4
%                     type='svm';
%                 end
%             end
%         end
%     end
    %run results for full fusion of features
    res_a=run_classifier2(feat_a,sam_a);
    %generate counting matrix
%     for f=1:length(sam_a)
%         cm_a(sam_a(f),res_a.map(f))=cm_a(sam_a(f),res_a.map(f))+1;
%     end
    %run results for full fusion of features
    res_v=run_classifier2(feat_v,sam_v);
    %generate counting matrix
%     for f=1:length(sam_v)
%         cm_v(sam_v(f),res_v.map(f))=cm_v(sam_v(f),res_v.map(f))+1;
%     end
    
%generate confusion matrices
for k=1:length(sam_a)
    cm_a(sam_a(k),res_a.knn_map(k))=cm_a(sam_a(k),res_a.knn_map(k))+1;
end
res_a.cm_a=cm_a;
for k=1:length(sam_v)
    cm_v(sam_v(k),res_v.knn_map(k))=cm_v(sam_v(k),res_v.knn_map(k))+1;
end
res_v.cm_v=cm_v;
    
%find mean square error
res_a.se=(abs(sam_a-res_a.knn_map));
res_v.se=(abs(sam_v-res_v.knn_map));
%     
%     

end