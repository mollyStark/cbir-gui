function [inliers,H]=GetInliersH(matches,th)

if ( (~exist('th','var')) || (isempty(th)) )
    th=.001; % Distance threshold for deciding outliers
end

m1(:,:)=(matches(:,1:2))';
m2(:,:)=(matches(:,3:4))';

[H, inliers] = ransacfithomography(m2, m1, th);

