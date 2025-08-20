function b = padstring(a,n)
% b = padstring(a,n)
%
% Utility function to crop or pad a string to n characters
%
% AUTHOR  : Mike Tyszka, Ph.D.
% PLACE   : Caltech BIC
% DATES   : 12/01/2003 JMT From scratch

b = repmat(' ',[1 n]);
na = length(a);
if na > n na = n; end
b(1:na) = a(1:na);

return