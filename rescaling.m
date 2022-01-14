function im_resc = rescaling(in_im)
% For rescaling the numbers of a matrix (image) to only floats from 0 to 1.
%
% Input: in_im - the matrix to rescale
% Output: im_resc - the rescaled matrix
%
% Date: 01-2022

minv = min(in_im(:));
maxv = max(in_im(:));
im_resc = (in_im - minv)/(maxv-minv);
end