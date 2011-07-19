function FeatECG = aubt_proxy_ecg( u,t )
%AUBT_PROXY Summary of this function goes here
%   Detailed explanation goes here

hz = 1000;
%FeatECG = aubt_extractFeatECG (u, hz);
FeatECG = [u(1,1)  u(1,3)];
end

