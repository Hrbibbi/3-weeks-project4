function im_noisy = addnoise(im,tau,varargin)
% Adds noise to either a normal or DFT image.
% Input arguments:
% im: 2D array image
% pc: percentage either as a decimal (default) or in [0,100].
% varargin{1} (optional argument): specify 'p' if tau is in [0,100].

if nargin == 3 && varargin{1} == 'p'
    tau = tau/100;
end

% This is for the non-complex case
noise_i = zeros(size(im));
v_r = 1;
e_c = 0;

im = double(im);

% Frobenius norm of input
fro_im = norm(im,'fro');

% If complex
if ~isreal(im)
    v_r = 1/sqrt(2);
    v_c = 1/sqrt(2);
    r_c = rand(size(im));
    r_c = r_c/norm(r_c,'fro');
    e_c = v_c*tau*r_c*fro_im;
end

r_r = rand(size(im));
r_r = r_r/norm(r_r,'fro');
e_r = v_r*tau*r_r*fro_im;
im_noisy = im + e_r + e_c;