function eegfeat=extractEEGFeatures2(data,hz)
data=data-mean(data);

data_orig=data;

eegfeat=[];
delta_power=[];
theta_power=[];
alpha_power=[];
beta_power=[];
alpha_peak=[];
ab_ratio=[];

[eyeblinks,data]=remove_blink(data_orig,hz);

% subplot(2,1,1);
% plot(data_orig);
% subplot(2,1,2);
% plot(data);

%extract hjorth parameters
d1data=diff(data);
d2data=diff(d1data);
h1=var(data);
h2=std(d1data)/std(data);
h3=std(d2data)/std(data);

%extract 8 to 10 Hz bandpower
delta=round(0.5/500*1024);
theta=round(4.5/500*1024);
alpha=round(8/500*1024);
beta=round(12/500*1024);
outer=round(26/500*1024);

%set frequency band window in seconds
window=2;

for k=1:round(length(data)/(window*hz))
    temp=data(((k-1)*(window*hz))+1:k*(window*hz));
    y=fft(temp,2048);
    Pyy=(y.*conj(y));
    nonzero=Pyy==0;
    if sum(nonzero)~=0
        Pyy=Pyy+nonzero/1000;
    end
    delta_power=[delta_power,sum(log(Pyy(delta:theta)))];
    theta_power=[theta_power,sum(log(Pyy(theta:alpha)))];
    alpha_power=[alpha_power,sum(log(Pyy(alpha:beta)))];
    beta_power=[beta_power,sum(log(Pyy(beta:outer)))];
    ab_ratio=[ab_ratio,sum(log(Pyy(alpha:beta)))/sum(log(Pyy(beta:outer)))];
    peakind=alpha;
    peakval=0;
    for m=alpha:beta-1
        if log(Pyy(m))>peakval
            peakval=log(Pyy(m));
            peakind=m;
        end
    end
    alpha_peak=[alpha_peak,peakind*500/1024];
end
deltafeat=[delta_power,max(delta_power),min(delta_power),mean(delta_power),std(delta_power)];
thetafeat=[theta_power,max(theta_power),min(theta_power),mean(theta_power),std(theta_power)];
alphafeat=[alpha_power,max(alpha_power),min(alpha_power),mean(alpha_power),std(alpha_power)];
betafeat=[beta_power,max(beta_power),min(beta_power),mean(beta_power),std(beta_power)];
alphapfeat=[alpha_peak,max(alpha_peak),min(alpha_peak),mean(alpha_peak),std(alpha_peak)];
abfeat=[ab_ratio,max(ab_ratio),min(ab_ratio),mean(ab_ratio),std(ab_ratio)];

eegfeat=[eyeblinks,deltafeat,thetafeat,alphafeat,betafeat,alphapfeat,abfeat,h1,h2,h3];
%standard=aubt_extractFeatSC(data',hz);
%eegfeat=[eegfeat,standard];
end
        