function err = error_measure(Data, Reconstruction)
% Gives the error measure of the reconstructed matrix using the Frobenius
% norm.

% Usage: error_measure(Data, Reconstruction)
% Inputs: Data, the original matrix.
%         Reconstruction, the reconstructed matrix to compare with the
%         original data.
%
% Date : 01-2022

if ~all(size(Data) == size(Reconstruction))
    error('Both matrices must be of same size')
end

Num = norm(Data - Reconstruction, 'fro');
Den = norm(Data,'fro');

err = Num/Den;