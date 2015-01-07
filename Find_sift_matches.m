function matches=Find_sift_matches(cur_sift_desc,sift_frames,ccur_sift_desc,csift_frames,distRatio)
%matches is a matrix of feature point correspondences:
% [test_x, test_y, candidate_x, candidate_y; ...]

%correspondences with vl_ubcmatch and distRatio
%...
match_corresp_which = vl_ubcmatch(cur_sift_desc, ccur_sift_desc, distRatio);

%matches matrix
%...
for i=1:size(match_corresp_which,2)
	test_x_coord = sift_frames(1,match_corresp_which(1,i));
	test_y_coord = sift_frames(2,match_corresp_which(1,i));
	
	candidate_x_coord = csift_frames(1,match_corresp_which(2,i));
	candidate_y_coord = csift_frames(2,match_corresp_which(2,i));
	
	matches(i,:) = [test_x_coord,test_y_coord,candidate_x_coord,candidate_y_coord];
end

%eliminate repeated correnspondences with unique
%...
unique(matches,'rows');





