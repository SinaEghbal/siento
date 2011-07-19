function [x]=closePort(s)
    fclose(s);
    delete(s);
    clear s;
    x=1;
end