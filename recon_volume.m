function vol_out = recon_volume(vol_in,slice_vec)
slices = vol_in(:,:,slice_vec);
for i = 1:length(slice_vec)
    slices(:,:,i) = recon_2D(slices(:,:,i));
end
vol_in(:,:,slice_vec) = slices;
vol_out = vol_in;
end

function recon = recon_2D(slice)
recon = ifft2( fftshift(fftshift(slice)) );
end