function im = generate_simdata(K, texture_files)
% The function generates a simulated data image with black background and
% the following randomly placed figures : a circle, a triangle and a
% square.
% Usage: im = generate_simdata(K, texture_files)
% Inputs: K is the size of the image.
%         texture_files (optional): a string, the path of a folder
%         containing three texture images
% Output: K*K sized black image with randomly placed figures.
% Date: 01-2022

% Create the shapes in square matrices of size K/3
k = floor(K/3);
vector = [1:k];

circle = repmat(vector - floor(k/2),k,1).^2;
circle = sqrt(circle + repmat(vector' - floor(k/2),1,k).^2);
circle(circle > floor(k/2)) = 0;
circle(circle > 0) = 1;

triangle = repmat(vector,k,1);
triangle = triangle + repmat(k-vector',1,k);
triangle(triangle > k) = 0;
triangle(triangle > 0) = 1;

switch nargin
    case 1
        square = ones(k);

    case 2
        if ~isfolder(texture_files)
            error('second argument must be a correct folder path string.')
        end

        % Apply the textures if a folder path is given
        listing = dir(texture_files);
        listing = listing(~[listing.isdir]);

        texture = {};
        texture{1} = readImage([texture_files '\' listing(1).name]);
        texture{2} = readImage([texture_files '\' listing(2).name]);
        texture{3} = readImage([texture_files '\' listing(3).name]);

        texture{1} = imresize(texture{1},[k,k]);
        texture{2} = imresize(texture{2},[k,k]);
        texture{3} = imresize(texture{3},[k,k]);

        square = rescale(texture{1});

        texture{2}(triangle == 0) = 0;
        triangle = rescale(texture{2});

        texture{3}(circle == 0) = 0;
        circle = rescale(texture{3});
end

% Generate random coordinates for the shapes, while making sure that the
% entire shapes are in the image
coords = floor(rand(3,2)*(K-k));
coords(coords == 0) = 1;

% Return the image
im = zeros(K);
im(coords(1,1):coords(1,1)+k-1, coords(1,2):coords(1,2)+k-1) = square;
im(coords(2,1):coords(2,1)+k-1, coords(2,2):coords(2,2)+k-1) = im(coords(2,1):coords(2,1)+k-1, coords(2,2):coords(2,2)+k-1) + triangle;
im(coords(3,1):coords(3,1)+k-1, coords(3,2):coords(3,2)+k-1) = im(coords(3,1):coords(3,1)+k-1, coords(3,2):coords(3,2)+k-1) + circle;

im = rescale(im);
