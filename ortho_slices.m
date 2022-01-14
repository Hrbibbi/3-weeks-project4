function [O1,O2,O3] = ortho_slices(vol_in,s1,s2,s3)
O1 = vol_in(:,:,s1);
O2 = squeeze(vol_in(:,s2,:));
O3 = squeeze(vol_in(s3,:,:));
end