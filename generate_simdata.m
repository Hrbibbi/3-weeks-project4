function im = generate_simdata(K)
%
% The function generates a simulated data image with black background and
% the following randomly placed figures : a circle, a triangle and a
% square.
%
% Usage: im = generate_simdata(K)
% Input: K is the size of the image.
% Output: K*K sized black image with randomly placed figures.
%
% Date: 13/01/2022

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

% Generate random coordinates for the shapes, so that the entire shapes are
% in the image
coords = floor(rand(3,2)*(K-k));

% Return the image
im = zeros(K);
im(coords(1,1):coords(1,1)+k-1, coords(1,2):coords(1,2)+k-1) = 1;
im(coords(2,1):coords(2,1)+k-1, coords(2,2):coords(2,2)+k-1) = im(coords(2,1):coords(2,1)+k-1, coords(2,2):coords(2,2)+k-1) + triangle;
im(coords(3,1):coords(3,1)+k-1, coords(3,2):coords(3,2)+k-1) = im(coords(3,1):coords(3,1)+k-1, coords(3,2):coords(3,2)+k-1) + circle;

im = rescale(im);