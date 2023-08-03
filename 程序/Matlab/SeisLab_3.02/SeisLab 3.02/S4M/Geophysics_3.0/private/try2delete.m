<<<<<<< HEAD
function try2delete(handle)
% Try to delet the graphics object with handle "handle"
%
% Written by: E. Rietsch: September 2004
% Last updated:
%
%    try2delete(handle)

try
   delete(handle)
   drawnow
catch
   % do nothing if it fails
end
=======
function try2delete(handle)
% Try to delet the graphics object with handle "handle"
%
% Written by: E. Rietsch: September 2004
% Last updated:
%
%    try2delete(handle)

try
   delete(handle)
   drawnow
catch
   % do nothing if it fails
end
>>>>>>> 2b27bf6 (百度网盘Windows10)
