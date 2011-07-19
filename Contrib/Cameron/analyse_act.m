function res=analyse_act(user,window,offset)
[mergedfeatmat,mergedemomat]=extract_chunks(user,window,offset)
res=run_classifier('knn',mergedfeatmat,mergedemomat);