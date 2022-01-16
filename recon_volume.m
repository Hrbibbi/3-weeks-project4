function vol_out = recon_volume(vol_in,slice_vec)
% recon_volume performs inverse DFT and reconstructs a subset of slices from a volume scan.
% --- Input arguments ---
% vol_in: 3D array of the composed volume
% slice_vec: vector that recounts which slices to be reconstructed
% --- Output arguments ---
% vol_out: 3D array of the reconstructed slices
% Date: 01-2022

% Checks if all elements of slice_vec is contained in the 3rd dimension of vol_in
if ~all(ismember(slice_vec, 1:size(vol_in,3)))
    error('Invalid slice vector.')
end

% Perform inverse fourier transorm on selected slices
vol_out(:,:,1:length(slice_vec)) = ifft2(vol_in(:,:,slice_vec));
