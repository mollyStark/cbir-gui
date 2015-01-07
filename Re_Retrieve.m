function  scores  = Re_Retrieve( descs,vocabulary_tree,ifindex,weight )
%   Retrieve the tree according to the limited descriptors.
%   

all_voted_images=[];
all_voting_scores=[];
for i=1:size(descs,2)
	path_to_leaf = vl_hikmeanspush(vocabulary_tree, descs(:,i));
	index = Path2index(path_to_leaf,vocabulary_tree.K);
	cur_voted_images = ifindex(index).images;
    	for img_id = 1:size(cur_voted_images,2)
        %cast a vote: add (if not yet encountered) or imcrement the corresponding image score in all_voting_scores
        	vote_img = cur_voted_images(img_id);        
       	 	pos = find(all_voted_images==vote_img);
       		if isempty(pos)
           		all_voted_images = [all_voted_images vote_img];
            	all_voting_scores = [all_voting_scores weight(i)*ifindex(index).scores(img_id)];
        	else 
           		all_voting_scores(pos) = all_voting_scores(pos) + weight(i)*ifindex(index).scores(img_id);
        	end
    	end
	

end

%sort candidates (all_voted_images) according to descending all_voting_scores
%with sort Matlab command
[all_voting_scores,ind] = sort(all_voting_scores,'descend');
candidates = all_voted_images(ind);

scores.img = candidates;
scores.val = all_voting_scores;

fprintf('Image %d - score %g\n',[candidates(1:min(10,numel(candidates)));all_voting_scores(1:min(10,numel(all_voting_scores)))]);


