function [ type , output ] = ProcessInput( input )
%PROCESSINPUT Summary of this function goes here
%   Detailed explanation goes here
Protocol;
output = input;
input = regexp(input, DELIM, 'split');

if (strcmp(input(1,1),HELLO))
    type = 0;
elseif (strcmp(input(1,1), EMOTION_REQUEST))
      
      type = 1;
      output = input(2:end);
        
      return; 
elseif (strcmp(input(1,1), TEXT))
      
      type = 3;
      output = input(2:end);
      return;       
end    
    

end

