for k=1:5
    if k==1
        results_a=zeros(10,4);
        results_a_20=zeros(10,4);
        results_v=zeros(10,4);
        results_v_20=zeros(10,4);
    end
for i=[1:10]
    %for each user
    [res_a,res_v]=analyse2(i);
    
        results_a(i,1)=results_a(i,1)+res_a.knn_correct;
        results_a_20(i,1)=results_a_20(i,1)+res_a.knn_correct20;
        results_a(i,2)=results_a(i,2)+res_a.lda_correct;
        results_a_20(i,2)=results_a_20(i,2)+res_a.lda_correct20;
        results_a(i,3)=results_a(i,3)+res_a.qdr_correct;
        results_a_20(i,3)=results_a_20(i,3)+res_a.qdr_correct20;
        results_a(i,4)=results_a(i,4)+res_a.svm_correct;
        results_a_20(i,4)=results_a_20(i,4)+res_a.svm_correct20;
        results_v(i,1)=results_v(i,1)+res_v.knn_correct;
        results_v_20(i,1)=results_v_20(i,1)+res_v.knn_correct20;
        results_v(i,2)=results_v(i,2)+res_v.lda_correct;
        results_v_20(i,2)=results_v_20(i,2)+res_v.lda_correct20;
        results_v(i,3)=results_v(i,3)+res_v.qdr_correct;
        results_v_20(i,3)=results_v_20(i,3)+res_v.qdr_correct20;
        results_v(i,4)=results_v(i,4)+res_v.svm_correct;
        results_v_20(i,4)=results_v_20(i,4)+res_v.svm_correct20;
      
end
end
results_a=results_a/5;
results_a_20=results_a_20/5;
results_v=results_v/5;
results_v_20=results_v_20/5;