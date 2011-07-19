%% Plot data on 2D with labels
function lsaPlot (Uk,Sk,Vk, terms, documents)

% To join
Weighted = [ Uk(:,1)*Sk(1,1), Uk(:,2)*Sk(1,1); Vk(:,1)*Sk(2,2), Vk(:,2)*Sk(2,2)];
%withKeys = strvcat (terms,documents);

plot(Weighted(:,1),Weighted(:,2),'o');
%plot(data(:,1),data(:,2),'x');
%gname(withKeys)

