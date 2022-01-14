function [O1,O2,O3] = ortho_slices(vol_in,s1,s2,s3)
% Returns three 2D orthoslices, from a 3D volume Matrix.
%
% Usage: [O1,O2,O3] = ortho_slices(vol_in,s1,s2,s3);
% Inputs: vol_in - the 3D matrix to take three slices from.
%         s1 - first slice z-coordinate.
%         s2 - second slice z-coordinate.
%         s3 - third slice z-coordinate.
% Outputs: O1 - first slice.
%          O2 - second slice.
%          O3 - third slice.
% ! Remark: the first character of the variable is the capital letter 'o',
% not to be confused with the digit 0.
%
% Date: 01-2022

O1 = vol_in(:,:,s1);
O2 = squeeze(vol_in(:,s2,:));
O3 = squeeze(vol_in(s3,:,:));
end