%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2012
%------------------------------------------------------------------
%------------------------------------------------------------------

function [NLAB_OUT, labels_shuff]=decisionFusion(featset,LabelList,labels,crossVal)
%classfication using weighted majority voting (from classifier decisions)

[nData, nCh]=size(featset);

dataset=[];
dataset=[featset LabelList];

%shuffle the instances
Vec_rand = rand(nData, 1);
[B, Index] = sort(Vec_rand);
dataset_shuff = dataset(Index, :); %shuffle dataset-labels
labels_shuff=labels(Index,:);%shuffle labels names

data1=dataset_shuff(:,1:(end-1));
label=dataset_shuff(:,end);

nInstFold=floor(nData/crossVal);
valueList=[];
sIndex=1;
eIndex=nInstFold;
for cv=1:crossVal
    %for m=1:nCh
        if cv==1
            test_data=[];
            train_data=[];
            w=[];
            test_data=data1(1:eIndex,:);%traning set
            train_data=data1((eIndex+1):end,:);%test set
            train_label=labels_shuff((eIndex+1):end);
            
            for m=1:nCh
                [Perf_M, Perf_M1, ConfMat, KRes,AllRes]=confm(train_data(:,m),train_label);
                w=[w;AllRes(8)];
            end           
            [value,vote] = majorityVote(test_data',w',label);
            valueList=[valueList;value'];
        elseif cv>1 & cv<10
            test_data=[];
            train_data=[];
            w=[];
            test_data=data1(sIndex:eIndex,:);%traning set
            train_data=[data1(1:(sIndex-1),:); data1((eIndex+1):end,:)];%test set
            train_label=[labels_shuff(1:(sIndex-1)); labels_shuff((eIndex+1):end)];
            for m=1:nCh
                [Perf_M, Perf_M1, ConfMat, KRes,AllRes]=confm(train_data(:,m),train_label);
                w=[w;AllRes(8)];
            end
            [value,vote] = majorityVote(test_data',w',label);
            valueList=[valueList;value'];
        elseif cv==crossVal
            test_data=[];
            train_data=[];
            w=[];
            test_data=data1(sIndex:end,:);%traning set
            train_data=data1(1:(sIndex-1),:);%test set
            train_label=labels_shuff(1:(sIndex-1));
            for m=1:nCh
                [Perf_M, Perf_M1, ConfMat, KRes,AllRes]=confm(train_data(:,m),train_label);
                w=[w;AllRes(8)];
            end
            [value,vote] = majorityVote(test_data',w',label);
            valueList=[valueList;value'];
        end
        
    %end    
    sIndex=sIndex+nInstFold;
    eIndex=eIndex+nInstFold;
end
NLAB_OUT=valueList;%majority vote output (n-fold)

