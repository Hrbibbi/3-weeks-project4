function im_noisy = addnoise(im,tau,varargin)
% Adds noise to either a normal or DFT image.
% --- Input arguments ---
% im: 2D array image
% tau: percentage either as a decimal (default) or in [0,100].
% varargin{1} (optional argument): specify 'p' if tau is in [0,100].
% --- Output arguments ---
% im_noisy: 2D array of image with noise
% Date: 01-2022

% check to see if fraction is specified as decimal or percentage value
if nargin == 3 && varargin{1} == 'p'
    if tau < 0 || tau > 100
        error('Invalid percentage')
    end
    tau = tau/100; % convert to decimal
else
    if tau < 0 || tau > 1
        error('Invalid decimal percentage')
    end
end
im = double(im); % in case image is not already double, i.e. uint8

if any(imag(im) ~= 0)
    % complex
    r = rand(size(im));
    r = r/norm(r,'fro');
    e_imag = r*norm(imag(im),'fro');
    r = rand(size(im));
    r = r/norm(r,'fro');
    e_real = r*norm(real(im),'fro');
    im_noisy = im + tau*(e_real + e_imag*1i);
else
    % real
    r = rand(size(im));
    r = r/norm(r,'fro');
    e = tau*r*norm(im,'fro');
    im_noisy = im + e;
end
