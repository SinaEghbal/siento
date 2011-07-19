%ISOBJIM test if the dataset contains objects that are images
%
%  N = ISOBJIM(A)
%      ISOBJIM(A)
%
% INPUT
%  A  input dataset
%
% OUTPUT
%  N  logical value
%
% DESCRIPTION
% True if dataset contains objects that are images. If no output is required,
% false outputs are turned into errors. This may be used for assertion.
%
% SEE ALSO
% ISDATASET, ISDATAIM

% $Id: isobjim.m,v 1.4 2007/05/04 08:35:33 duin Exp $

function n = isobjim(a)

	prtrace(mfilename);
	
	n = isa(a,'dataset') & length(a.featsize) > 1;

	% generate error if input is not a dataset with image data with
   % pixels being features AND no output is requested (assertion)

	if nargout == 0 & n == 0
		error([newline '---- Dataset with object images expected -----'])
	end

return
