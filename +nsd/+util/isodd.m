function [is] = isodd(x)
%--------------------------------------------------------------------------
%
% Copyright (c) 2009-2011 Jeffrey Byrne
% $Id: isodd.m 79 2012-07-27 14:30:30Z jebyrne $
%
%--------------------------------------------------------------------------

is = (rem(x,2) == 1);

