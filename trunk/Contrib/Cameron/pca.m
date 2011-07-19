function feat_new=pca(feat)
mu=mean(feat);
dim=size(feat);
for m=1:dim(1)
    MU(m,:)=mu;
end
D=feat-MU;
S=cov(D);
[V,v]=eig(S);
for m=1:dim(2)
    v2(m,m)=v(dim(2)+1-m,dim(2)+1-m);
    V2(:,m)=V(:,dim(2)+1-m);
end
pc=D*V2;
lambda=v2(1,1);
epsilon=0.25;
m=1;
while m<dim(2)-1 && lambda>epsilon
    m=m+1;
    lambda=v2(m,m);
end
feat_new=pc(:,1:m);
