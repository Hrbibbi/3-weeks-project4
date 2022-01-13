function im_resc = rescaling(in_im)
    minv = min(in_im(:));
    maxv = max(in_im(:));
    im_resc = (in_im - minv)/(maxv-minv);
end