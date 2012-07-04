
% OPTSTUMPS find a decision stump classifier to minimize
% weighted empirical risk.
% 
% [bestaxis, bestthresh, bestsign, wterr] = optstumps(patts,labels,wts)
% bestaxis, bestthresh, bestsign: optimal decision stump computes
% function x(:) -> (x(bestaxis)-bestthresh)*bestsign <= 0.
% wterr: weighted empirical risk of returned decision stump
% patts: matrix of n column vectors, one for each pattern
% labels: row vector of associated labels, from {0,1}.
% wts: row vector of weights.

function [bestaxis, bestthresh, bestsign, bestwterr] = optstumps(patts, labels, wts)

if (nargin < 3), wts = ones(size(labels)); end;
    
totwt = sum(wts,2); oneswt = sum(wts.*labels,2);
bestwterr = totwt+1;
for axnum = 1:size(patts, 1)
   [thisthresh, thissign, thiswterr] = optthresh(patts(axnum,:), labels, wts, totwt, oneswt);
   if thiswterr < bestwterr
      bestthresh = thisthresh; bestsign = thissign;
      bestwterr = thiswterr; bestaxis = axnum;
   end
end

function [bestthresh, bestsign, bestwterr] = optthresh(vals, labels, weights, totwt, oneswt)

% OPTTHRESH - return optimal threshold function to minimize wted error

[svals, sindex] = sort(vals,2);
numpatt = size(vals,2);
bestthresh = svals(numpatt) + abs(svals(numpatt));
bestsign = 2*(totwt-oneswt < oneswt)-1;
bestwterr = min(totwt-oneswt,oneswt);
leftoneswt = 0; leftzeroswt=0;
for cn = 1:numpatt-1
   if labels(sindex(cn))
      leftoneswt = leftoneswt + weights(sindex(cn));
   else
      leftzeroswt = leftzeroswt + weights(sindex(cn));
   end
   if (svals(cn+1) ~= svals(cn))
      if leftoneswt + totwt - oneswt - leftzeroswt < bestwterr
         bestwterr = leftoneswt + totwt - oneswt - leftzeroswt;
         bestsign = -1;
         bestthresh = (svals(cn) + svals(cn+1))/2;
      end
      if leftzeroswt + oneswt - leftoneswt < bestwterr
         bestwterr = leftzeroswt + oneswt - leftoneswt;
         bestsign = 1;
         bestthresh = (svals(cn) + svals(cn+1))/2;
      end
   end
end
