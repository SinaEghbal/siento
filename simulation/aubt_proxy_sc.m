function FeatSC = aubt_proxy_sc(u)
%AUBT_PROXY_SC Calculate and return features for skin conductivity
%   based on aubt

hz = 1000.0;

FeatSC = aubt_extractFeatSC (u, hz);

end

