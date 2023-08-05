<<<<<<< HEAD
function out=rsum(in)
% Compute two-term running sum: 
%
%       out=rsum(in);
% INPUT
% in   input matrix
% OUTPUT
% out  output matrix: out=(in(1:end-1,:)+in(2:end,:)*0.5

=======
function out=rsum(in)
% Compute two-term running sum: 
%
%       out=rsum(in);
% INPUT
% in   input matrix
% OUTPUT
% out  output matrix: out=(in(1:end-1,:)+in(2:end,:)*0.5

>>>>>>> 2b27bf6 (百度网盘Windows10)
out=(in(1:end-1,:)+in(2:end,:))*0.5;