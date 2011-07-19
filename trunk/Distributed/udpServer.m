%% udpServer receives signals from registered clients, weights the
%% classifications and produces a control signal.

serverIP = '127.0.0.1';
u2 = udp(serverIP, 'RemotePort', 8844, 'LocalPort', 8866)
fopen(u2);

fprintf(u1, 'Ready for data transfer.')

