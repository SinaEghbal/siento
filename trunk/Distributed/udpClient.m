%% udpClient This Client is a service that produces a recognition 
%% (e.g physiology) and send it to a service that will adapt a user
%% interface
config;
serverIP = '127.0.0.1';

u1 = udp(serverIP, 'RemotePort', 8866, 'LocalPort', 8844);
fopen(u1);

% get data
[featmat featnames] = aubtProxy(processingPath, filename,j); 

% run classifier
results = run_classifier(method, data, labels)

% stablish connetion and send results to server
fprintf(u1,'Request Time');


