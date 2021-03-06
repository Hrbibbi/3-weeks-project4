function lim_signal =  signal_limited(signal,frac)
% Imitates the sampling of a DFT by zero-padding a part of the information.
%
% Inputs: signal - a 2D DFT matrix, the data to work on.
%         frac - a floating number from 0 to 1, the ratio of the data to
%                keep. (the rest is deleted)
% Output: A matrix containing a fraction of the data from the input signal,
% but of the same size.
% Date: 01-2022

% Verify the inputs types 
arguments
    signal double
    frac double
end
if (frac>1 | frac<0)
    error('frac is not between 0 and 1')
end

lim_signal = zeros(size(signal));

% Perform FFT on the input signal 
signal = fftshift(signal);

% C is the coordinate of the center
C = round(length(signal)/2);

% L is the half length of the preserved data square
L = floor((length(signal)*sqrt(frac))/2);
lim_signal(C-L:C+L,C-L:C+L) = signal(C-L:C+L,C-L:C+L);

% Invert FFT back
lim_signal = fftshift(lim_signal);
end
