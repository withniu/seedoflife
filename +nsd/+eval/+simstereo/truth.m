function [y,k_valid_simlft,y_occluded,k_occluded,ij_simlft,ij_simleftinrgt] = truth(fr_rgt,fr_simlft,im_rgt,im_simlft,imdisp,imdisc,B,r_match,do_debug)
%--------------------------------------------------------------------------
%
% Copyright (c) 2013 Jeffrey Byrne 
%
%--------------------------------------------------------------------------


%% Inputs
if ~exist('do_debug','var') || isempty(do_debug)
  do_debug = 0;
end


%% Ground truth
ij_rgt = [fr_rgt(1,:); fr_rgt(2,:)];
ij_simlft = [fr_simlft(1,:); fr_simlft(2,:)];
xy_simlft = [fr_simlft(2,:); fr_simlft(1,:)];

% Inverse transform: simleft -> left
xy_lft = round(nsd.util.dehomogenize(B\nsd.util.homogenize(xy_simlft)));  % inverse transform, undo similarity
[k_lft,k_valid_simleft2left] = nsd.util.sub2ind(size(im_simlft),xy_lft(2,:)',xy_lft(1,:)');

% Valid disparity: left -> right
xy_simleftinrgt = nan(size(xy_lft));  
xy_simleftinrgt(1,k_valid_simleft2left) = xy_lft(1,k_valid_simleft2left) - imdisp(k_lft)';  % valid disparity 
xy_simleftinrgt(2,k_valid_simleft2left) = xy_lft(2,k_valid_simleft2left);  
ij_simleftinrgt = nsd.util.xy2ij(xy_simleftinrgt);

% Valid matches: simleft -> right
k_valid_disp = find(imdisp(k_lft) > 0);  % for tsukuba border
k_valid_simlft = nsd.util.inmat(size(im_rgt),ij_simleftinrgt(1,:)',ij_simleftinrgt(2,:)');
k_valid_simlft = intersect(k_valid_simlft,k_valid_disp);

% True matches: simleft -> right
%D_match = sqdist(ij_simleftinrgt(:,k_valid_simlft), ij_rgt);
D_match = sqdist(ij_simleftinrgt, ij_rgt);
k_match = find(D_match < (r_match.^2));
n_match = numel(D_match);
%y = -ones(n_match,1); y(k_match) = 1;  % true matches
y = -ones(size(D_match)); y(k_match) = 1;  % true matches

% Debugging
if do_debug
  nsd.show.matching(im_simlft, im_rgt, ij_simlft(:,k_valid_simlft)', ij_simleftinrgt(:,k_valid_simlft)', figure(100));  % ground truth  
end


%% Occlusions
% if exist('imdisc','var') && ~isempty(imdisc)
%   [k_siminref,k_valid_siminref] = nsd.util.sub2ind(size(imdisp),xy_siminrgt(2,:)',xy_siminrgt(1,:)');
%   k_occluded = intersect(k_valid,k_valid_siminref(find(imdisc(k_siminref) == 1)));
%   D_match = sqdist(ij_siminobs(:,k_occluded), ij_rgt);
%   k_match = find(D_match < (r_match.^2));
%   n_match = numel(D_match);
%   y_occluded = -ones(n_match,1); 
%   y_occluded(k_match) = 1;  % occluded matches
% 
%   % Debugging
%   if do_debug
%     nsd.show.matching(im_simlft, im_rgt, ij_simlft(:,k_occluded)', ij_siminobs(:,k_occluded)', figure(101));  % ground truth
%   end
% end



