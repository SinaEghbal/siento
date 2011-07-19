%SHOW PRTools general show
%
%   H = SHOW(A,N)
%
% INPUT
%   A      Image
%   N      Number of images on a row
%
% OUTPUT 
%   H      Graphics handle
%
% DESCRIPTION
% PRTools offers a SHOW command for variables of the data classes DATASET
% and DATAFILE. In order to have a simliar command for images not converted
% to a DATASET this commands made availble. A should be 2D, 3D or 4D image.
%
% 2D images are fully displayed.
%
% 3D images are converted to a dataset with as many feature images as given
% in the 3rd dimension and displayed by DATASET/SHOW.
%
% 4D images with 3 bands in the 3rd dimension are converted to a dataset with 
% as many 3-color object images as are given in the 4th dimension and
% displayed by DATASET/SHOW
%
% All other 4D images are converted to a dataset with as many 2D feature
% images as given by the dimensions 3 and 4 and displayed by DATASET/SHOW.
% Unless given otherwise, N is set to size(A,3).
%
% SEE ALSO DATASET/SHOW

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function h = show(a,n)

	prtrace(mfilename);

if nargin < 2, n = []; end
a = double(a);
s = size(a);

if length(s) == 2
	if any(s==1)
		error('Image expected')
	end
	a = im2obj(a);
elseif length(s) == 3
	a = im2feat(a);
	a = dataset(a,NaN); % avoid display label image
else
	if length(s) == 4 & s(3) == 3
		a = im2obj(a);
	else
		a = reshape(a,s(1),s(2),prod(s(3:end)));
		a = im2feat(a);
		a = dataset(a,0); % avoid display label image
	end
end
if nargout > 0
	h = show(a,n);
else
	show(a,n);
end