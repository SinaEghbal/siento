function [mergedfeatmat,mergedsammat]=eliminate_redundant_classes(feat,sam)
mergedsammat=sam;
mergedfeatmat=feat;

one=mergedsammat==1;
if sum(one)<=4
    dim=size(mergedsammat);
    tm=[];
    for k=1:dim(1)
        if one(k)~=1
            l=size(tm);
            l=l(1);
            tm(l+1,:)=zeros(1,dim(1));
            tm(l+1,k)=1;
        end
    end
    mergedsammat=tm*mergedsammat;
    mergedfeatmat=tm*mergedfeatmat;
end

two=mergedsammat==2;
if sum(two)<=3
    dim=size(mergedsammat);
    tm=[];
    for k=1:dim(1)
        if two(k)~=1
            l=size(tm);
            l=l(1);
            tm(l+1,:)=zeros(1,dim(1));
            tm(l+1,k)=1;
        end
    end
    mergedsammat=tm*mergedsammat;
    mergedfeatmat=tm*mergedfeatmat;
end

three=mergedsammat==3;
if sum(three)<=3
    dim=size(mergedsammat);
    tm=[];
    for k=1:dim(1)
        if three(k)~=1
            l=size(tm);
            l=l(1);
            tm(l+1,:)=zeros(1,dim(1));
            tm(l+1,k)=1;
        end
    end
    mergedsammat=tm*mergedsammat;
    mergedfeatmat=tm*mergedfeatmat;
end

four=mergedsammat==4;
if sum(four)<=3
    dim=size(mergedsammat);
    tm=[];
    for k=1:dim(1)
        if four(k)~=1
            l=size(tm);
            l=l(1);
            tm(l+1,:)=zeros(1,dim(1));
            tm(l+1,k)=1;
        end
    end
    mergedsammat=tm*mergedsammat;
    mergedfeatmat=tm*mergedfeatmat;
end

five=mergedsammat==5;
if sum(five)<=3
    dim=size(mergedsammat);
    tm=[];
    for k=1:dim(1)
        if five(k)~=1
            l=size(tm);
            l=l(1);
            tm(l+1,:)=zeros(1,dim(1));
            tm(l+1,k)=1;
        end
    end
    mergedsammat=tm*mergedsammat;
    mergedfeatmat=tm*mergedfeatmat;
end

end