function vol_out = recon_volume(vol_in,slice_vec)
% recon_volume performs inverse DFT and reconstructs a subset of slices from a volume scan.
% --- Input arguments ---
% vol_in: 3D array of the composed volume
% slice_vec: vector that recounts which slices to be reconstructed
% --- Output arguments ---
% vol_out: 3D array of the reconstructed slices
% Date: 14/01/2022

% Checks if all elements of slice_vec is contained in the 3rd dimension of vol_in
if ~all(ismember(slice_vec, 1:size(vol_in,3)))
    error('Invalid slice vector.')
end

% Fetch the original slices to be reconstructed
slices = vol_in(:,:,slice_vec);
for i = 1:length(slice_vec)
    slices(:,:,i) = recon_2D(slices(:,:,i));
end

% Insert the reconstructed slices back in
vol_in(:,:,slice_vec) = slices;
vol_out = vol_in;
end

function recon = recon_2D(slice)
% Reconstruct slices
recon = ifft2( fftshift(fftshift(slice)) );
end
