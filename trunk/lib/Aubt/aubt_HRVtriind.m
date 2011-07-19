function triind = aubt_HRVtriind (NNdistr)
% Total number of all NN intervals divided by the height of the histogram
% of all NN intervals measured on a discrete scale of n bins.

triind = sum (NNdistr) / max (NNdistr);
