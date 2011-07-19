function NNDistr = aubt_NNdistr (nn, bins)
% distribution of NN intervals

minNN = min (nn);
maxNN = max (nn);
NNDistr = histc (nn, minNN:(maxNN-minNN)/(bins-1):maxNN);


