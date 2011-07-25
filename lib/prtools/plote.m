%PLOTE Plot error curves
%
%   H = PLOTE(E,LINEWIDTH,S,FONTSIZE,OPTIONS)
%
% INPUT
%   E          Structure containing error curves (see e.g. CLEVAL)
%   LINEWIDTH  Line width, < 5 (default 1.5)
%   S          Plot strings
%   FONTSIZE   Font size, >= 5 (default 5)
%   OPTIONS    Character strings:
%              'nolegend' suppresses the legend plot
%              'errorbar' add errorbars to the plot
%
% OUTPUT
%   H          Array of graphics handles
%
% DESCRIPTION
% Various evaluation routines like CLEVAL return an error curves packed in a
% structure E. PLOTE uses the information stored in E to plot the curves. The 
% remaining parameters may be given in an arbitrary order.
%
% E may contain the following fields (E.ERROR is obligatory):
%   E.ERROR    C x N matrix of error values for C methods at N points
%   E.XVALUES  C x N matrix of measurement points; if 1 x N, it is used for 
%                all C curves
%   E.TITLE    the title of the plot
%   E.XLABEL   the label for the x-axis
%   E.YLABEL   the label for the y-axis
%   E.NAMES    a string array of C names used for creating a LEGEND
%   E.PLOT     the plot command in a string: 'plot', 'semilogx', 'semilogy' 
%                or 'loglog'
%   E.STD      C x N matrix with standard deviations of the mean error values
%                which are plotted if ERRBAR == 1
%
% These fields are automatically set by a series of commands like CLEVAL,
% CLEVALF, ROC and REJECT.
%
% The legend generated by PLOTE can be removed by LEGEND OFF. A new legend
% may be created by the LEGEND command using the handles stored in H.
%
% E may be a cell array of structures. These structures are combined
% vertically, assuming multiple runs of the same method and
% horizontally, assuming different methods.
%
% EXAMPLES
% See PREX_CLEVAL
%
% SEE ALSO
% CLEVAL, CLEVALF, ROC, REJECT

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% $Id: plote.m,v 1.1 2006/12/19 12:04:29 duin Exp $

function handle = plote(varargin)

	prtrace(mfilename);
	
	% Set default parameter values.

	e         = [];
	s         = [];
	linewidth = 1.5;
	nolegend  = 0;
	fontsize  = 16;
	errbar    =  0;
	ss = char('k-','r-','b-','m-','k--','r--','b--','m--');
	ss = char(ss,'k-.','r-.','b-.','m-.','k:','r:','b:','m:');

	% The input is so flexible, that we have to do a lot of work...

	for j = 1:nargin
		p = varargin{j};
		if (isstruct(p)) | iscell(p)
			e = p;
		elseif (isstr(p)) & (strcmp(p,'errorbar') | strcmp(p,'ERRORBAR'))
			errbar = 1;
		elseif (isstr(p)) & (strcmp(p,'nolegend') | strcmp(p,'NOLEGEND'))
			nolegend = 1;
		elseif (isstr(p))
			ss = p;
		elseif (length(p) == 1) & (p < 5)
			linewidth = p;
		elseif (length(p) == 1) & (p >= 5)
			fontsize = p;
		end
	end
	
	if iscell(e) 
		if min(size(e)) > 1
			ee = cell(1,size(e,2));
			for j=1:size(e,2)
				ee{j} = vertcomb(e(:,j));
			end
			e = horzcomb(ee);
		elseif size(e,1) > 1
			e = vertcomb(e);
		elseif size(e,2) > 1
			e = horzcomb(e);
		else
			e = e{1};
		end
	end
	
	% Handle multiple plots
	
	if length(e) > 1
		names = [];
		hold_stat = ishold;
		h = [];
		ymax = 0;
		for j = 1:length(e)
			if errbar
				hh = plote(e(j),linewidth,ss(j,:),'nolegend','errorbar');
			else
				hh = plote(e(j),linewidth,ss(j,:),'nolegend');
			end
			V = axis; ymax = max(ymax,V(4));
			hold on
			names = char(names,e(j).names);
			h = [h; hh];
		end
		names(1,:) = [];
		V(4) = ymax;
		axis(V);
		if ~nolegend
			legend(h,names);
		end
		if ~hold_stat, hold off; end
		if nargout > 0, handle = h; end
		return
	end

	% Check if we have the required data and data fields.

	if (isempty(e))
		error('Error structure not specified.')
	end

	if (~isfield(e,'error'))
		error('Input structure should contain the ''error''-field.');
	end

	n = size(e.error,1);

	if (~isfield(e,'xvalues'))
		e.xvalues = [1:length(e.error)];
	end
	if (size(e.xvalues,1) == 1)
		e.xvalues = repmat(e.xvalues,n,1);
	end

	if (isempty(s))
		s = ss(1:n,:);
	end
	if (size(s,1) == 1) & (n > 1)
		s = repmat(s,n,1);
	end
	if (size(s,1) < n)
		error('Insufficient number of plot strings.')
	end

	if (~isfield(e,'plot'))
		e.plot = 'plot';
	end

	if errbar
		if (isfield(e,'std'))
			ploterrorbar = 1;
		else
			error('No standard deviations given, so errorbars cannot be plotted')
		end
	else
		ploterrorbar = 0;
	end
	
	% We can now start making the plot.

	if ~ishold
		clf;
	end
	h = [];
	for j = 1:n
		L = find(e.error(j,:) ~= NaN);
		if ploterrorbar
			hh = feval('errorbar',e.xvalues(j,L),e.error(j,L),e.std(j,L),deblank(s(j,:)));
		else
			hh = feval(e.plot,e.xvalues(j,L),e.error(j,L),deblank(s(j,:)));
		end
		set(hh,'linewidth',linewidth); hold on; h = [h hh(end)];
	end
		
	% That was basically it, now we only have to beautify it.
	errmax = max(e.error(:));
	set(gca,'fontsize',fontsize);

	if (isfield(e,'xlabel')), xlabel(e.xlabel); end
	if (isfield(e,'ylabel')), ylabel(e.ylabel); end
	if (isfield(e,'title')),  title(e.title);   end
	if (isfield(e,'names')) & (~isempty(e.names) & (~nolegend))
		if ploterrorbar
%			legend(h((2:2:end)),e.names); %sometimes this is needed
			legend(h,e.names);
		else
			legend(h,e.names);
		end  
	end

	% A lot of work to make the scaling of the y-axis nice.

	if (errmax > 0.6)
		errmax = ceil(errmax*5)/5;
		yticks = [0:0.2:errmax];
	elseif (errmax > 0.3)
		errmax = ceil(errmax*10)/10;
		yticks = [0:0.1:errmax];
	elseif (errmax > 0.2)
		errmax = ceil(errmax*20)/20;
		yticks = [0:0.05:errmax];
	elseif (errmax > 0.1)
		errmax = ceil(errmax*30)/30;
		yticks = [0:0.03:errmax];
	elseif (errmax > 0.06)
		errmax = ceil(errmax*50)/50;
		yticks = [0:0.02:errmax];
	elseif (errmax > 0.03)
		errmax = ceil(errmax*100)/100;
		yticks = [0:0.01:errmax];
	else
		yticks = [0:errmax/3:errmax];
	end

		% atttempt to beautify plot
	if (e.xvalues(end) >= 2)
		%DXD
		%axis([e.xvalues(1)-1,e.xvalues(end)+1,0,errmax]);
		axis([min(min(e.xvalues)),max(max(e.xvalues)),0,errmax]);
	elseif (e.xvalues(1) == 0)
		axis([-0.003,e.xvalues(end),0,errmax]);
	end
		
	set(gca,'ytick',yticks);
	
	hold off; if (nargout > 0), handle = h; end;
	
	return
	
function e = vertcomb(e) % combine cell array
	e1 = e{1};
	for j=2:length(e);
		e2 = e{j};
		v = e1.n*(e1.n*(e1.std.^2) + e1.error.^2);
		v = v + e2.n*(e2.n*(e2.std.^2) + e2.error.^2);
		n = e1.n + e2.n;
		e1.error = (e1.n*e1.error + e2.n*e2.error)/n;
		e1.std = sqrt((v/n - e1.error.^2)/n);
		e1.n = n;
	end
	e = e1;
return

function ee = horzcomb(e) % combine cell array
	for j=1:length(e)
		ee(j) = e{j};
	end