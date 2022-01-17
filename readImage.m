function im = readImage(fileName)
% Loads in image in a matrix form with values from 0 to 1
%
% input : fileName, name of the image file.
% output : the image in matrix-form
%
% Date = 01-2022

im = imread(fileName);
if any(im > 1)
    im = 1/255*double();
end
