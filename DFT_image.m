function im_transform = DFT_image(im,output_type)
% Takes the DFT of the matrix-representation of an image
% Performs a rescaling of the image to the range 0-1 and performs
% 2-dimensional FFT on the image.
% Input: - im (a matrix representing the image)
% Optional arguments - output_type (Choose the outputtype: 
% 'matrix' - default, outputs the matrix of the frequency space with
% complex values
% 'real-matrix' - outputs normed frequency space matrix
% 'vizualize' - outputs a figure of the normed frequency space  with
% zero-frequency components in the middle of the spectrum
arguments
    im double {mustBeNumeric}
    output_type char = 'matrix'
end
if max(im(:))>1
    im=rescaling(im);
end
switch output_type
    case "matrix"
        im_transform = fft2(im);
    case 'real-matrix'
        im_transform =abs(fft2(im));
    case 'vizualize'
        im_transform=fftshift(abs(fft2(im)));
        imshow(rescaling(im_transform));
    otherwise
        error('Incorrect output type')
end

end