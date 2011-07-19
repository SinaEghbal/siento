function line = aubt_getLine (y1, y2, samples)

line = zeros(1, samples);
deltaY = (y2-y1) / (samples-1);
for i=1:samples
    line(i) = y1 + (i-1)*deltaY;     
end

