


%config;

Protocol;

serverIP = '127.0.0.1';
serverPort = 2222;

% Create TCP/IP object 't'. Specify server machine and port number. 
con = tcpip(serverIP, serverPort); 

% Set size of receiving buffer, if needed. 
set(con, 'InputBufferSize', 30000); 

% Open connection to the server. 
fopen(con); 

% Pause for the communication delay, if needed. 
pause(5) 

requestedEmotions = '';

% Receive lines of data from server 
while (get(con, 'BytesAvailable') > 0) 
    con.BytesAvailable;
    messageHeader = fscanf(con);
    [type res] = ProcessInput(messageHeader);
    if (type == 1)
       requestedEmotions = res;
    end
end 


em1 =  char(requestedEmotions(1,1));
em2 =  char(requestedEmotions(1,2));

loopC = 1;

while (loopC < 100)
    loopC
    enteredText = '';
    % Receive lines of data from server 
    while (get(con, 'BytesAvailable') > 0) 
        con.BytesAvailable;
        [type res] = ProcessInput(fscanf(con));
        if (type == 3)
            
            ID = res(1,1)
            enteredText = res(1,2)
            
            w1 = sprintf('%i',loopC); 
            %hear we call the classifier to classify the text!!
            
            % get data
            %[featmat featnames] = aubtProxy(processingPath, filename,j); 

            % run classifier
            %results = run_classifier(method, data, labels)

            %generating output data
            s = strcat('data',DELIM, em1  , DELIM, w1 ,DELIM, em2  ,DELIM,'2.98');
            s = sprintf(s);
            
            %real data can be sent here
            fprintf(con, s); 
        end
    end 
% Pause for the communication delay, if needed. 
pause(3) 
loopC = loopC +1;
end

% Disconnect and clean up the server connection. 
fclose(con); 
delete(con); 
clear con 

