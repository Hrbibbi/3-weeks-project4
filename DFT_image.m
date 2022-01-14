function im_transform = DFT_image(im,output_type)
% Takes the DFT2 (2-Dimensional Discrete Fourier Tranform) of the 
% matrix-representation of an image.
%
% Inputs: - im (a matrix representing the image)
% Optional argument: - output_type (one of following strings: 
%   'matrix' - (default setting), outputs the matrix of the frequency
% space with complex values.
%   'real-matrix' - outputs normed frequency space matrix
%   'visualize' - outputs a figure of the normed frequency space  with
% zero-frequency components in the middle of the spectrum
%
% Date: 01-2022

% Verify the input type
arguments
    im double {mustBeNumeric}
    output_type char = 'matrix'
end

% Rescale to float from 0 to 1
if max(im(:))>1
    im=rescaling(im);
end

% Output depends on the type demanded
switch output_type
    case "matrix"
        im_transform = fft2(im);
    case 'real-matrix'
        im_transform =log(abs(fft2(im)));
    case 'visualize'
        im_transform=fftshift(log(abs(fft2(im))));
        imshow(rescaling(im_transform));
    otherwise
        error('Incorrect output type')
end

end