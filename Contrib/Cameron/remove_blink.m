function [eyeblinks,data_filt]=remove_blink(data,hz)
%count eyeblinks; defined as where majority of data points>1.5 for 0.1s 
%successive points
k=1;
data=data-mean(data);
len=0.1*hz;
eyeblinks=0;
while k<length(data)
    if abs(data(k))>1.5
        window=k+len;
        if(window)>=length(data)
            window=length(data);
        end
        temp=abs(data(k:window))>1.5;
        if sum(temp)>len/2
            eyeblinks=eyeblinks+1;
            %remove eyeblink artefact
            k=k-10;
            if k<1
                data(1:10)=data(1:10)-mean(data(1:10));
                k=11;
            end
            slide=1;
            while k<window+len && k<=length(data);
                lower=k-slide;
                upper=k+slide;
                if lower<1
                    lower=1;
                end
                if upper>length(data)
                    upper=length(data);
                end
                data(k)=data(k)-mean(data(lower:upper));
                k=k+1;
            end
        end
    end
    k=k+1;
end
[b,a]=butter(2,30/500);
data_filt=filter(b,a,data);
end