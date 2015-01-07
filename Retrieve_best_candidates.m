function scores = Retrieve_best_candidites(query_dir)
% The function does the following things:
%   compute interest points and extract SIFT features around each interest point;
%   pass all descriptors through the vocabulary tree down to the leaves;
%   use the index associated with each leaf to cast votes on the images at that inverted file index according
%   to the corresponding scores;
%   accumulate the scores for all images
%   order the candidate images according to their scores and return the best 10

% Edit by Molly v1.0 30-04-2014 15:41
% Edit by Molly v2.0 14-05-2014 09:26
% Edit by Molly v3.0 19-05-2014 10:40

% 1.0 
load('vocabulary-1000v2-4.mat');
load('ifindex-1000v2-4.mat');

% 3.0
% load('vocabulary-k3core2-1000.mat');
% load('ifindex-k3core2-1000.mat');

% 1.0&3.0
% load('ifindex-uktest-4-1000.mat')

% 2.0
% load('vocabulary-image-k3-1000.mat');
% load('ifindex-image-k3-1000.mat');
% load('C-image.mat');


% 3.0
sigma = 100;
x=320;
y=240;
% weight = [0.4, 0.1, 0.1, 0.4];

I = imread(query_dir);
% image(I);
% hold on;
img = single(rgb2gray(I));

[sift_frames,sift_descs] = vl_sift(img);

% 1.0
nleaves=vocabulary_tree.K^vocabulary_tree.depth;

%2.0
% nleaves=vocabulary_tree(1).K^(vocabulary_tree(1).depth+1);
% vtree_leaves = nleaves/size(vocabulary_tree,2);

% 3.0
% vtree_leaves=vocabulary_tree(1).K^vocabulary_tree(1).depth;
% nleaves = vtree_leaves*size(vocabulary_tree,2);

all_voted_images = [];
all_voting_scores = [];
for sift_num = 1:size(sift_descs,2)
    % 3.0 
%     tmp = [sift_frames(1,sift_num)-x;sift_frames(2,sift_num)-y];
%     for i = 1:4
%         if norm(tmp)<i*sigma && norm(tmp)>=(i-1)*sigma
%             id =i;
%         end
%     end

    % Only for core
     %if norm(tmp)<sigma*2
        
%     path_to_leaf = vl_hikmeanspush(vocabulary_tree(id),sift_descs(:,sift_num)); 
%     index = Path2index(path_to_leaf,vocabulary_tree(id).K)+vtree_leaves*(id-1);
    
    % 1.0
    path_to_leaf = vl_hikmeanspush(vocabulary_tree, sift_descs(:,sift_num));
    index = Path2index(path_to_leaf,vocabulary_tree.K);
    
    % 2.0 
%     id = kmeanspush(sift_frames(1:2,sift_num),C);
%     path_to_leaf = vl_hikmeanspush(vocabulary_tree(id), sift_descs(:,sift_num));
%     index = Path2index(path_to_leaf,vocabulary_tree(id).K)+vtree_leaves*(id-1);
    
    cur_voted_images = ifindex(index).images;
    for img_id = 1:size(cur_voted_images,2)
        vote_img = cur_voted_images(img_id);
        % test 413
%         if vote_img==413
%             score = ifindex(index).scores(img_id)
%             colormap gray;
%             frame = sift_frames(:,sift_num);
%             x1_cord = floor(max(1,frame(1,:)-3*frame(3,:)))
%             x2_cord = floor(min(frame(1,:)+3*frame(3,:),size(img,2)))
%             y1_cord = floor(max(1,frame(2,:)-3*frame(3,:)))
%             y2_cord = floor(min(frame(2,:)+3*frame(3,:),size(img,1)))
%             
%             % clf;
%             rectangle('Position',[x1_cord,y1_cord,x2_cord-x1_cord,y2_cord-y1_cord],'Curvature',[0,0],'LineWidth',2,'EdgeColor','w');
%             hold on;
%             h1 = vl_plotframe(frame); set(h1,'color','k');
%         end
        pos = find(all_voted_images==vote_img);
        if isempty(pos)
           all_voted_images = [all_voted_images vote_img];
            all_voting_scores = [all_voting_scores ifindex(index).scores(img_id)];
%           all_voting_scores = [all_voting_scores weight(id)*ifindex(index).scores(img_id)];
        else 
           all_voting_scores(pos) = all_voting_scores(pos) + ifindex(index).scores(img_id);
%             all_voting_scores(pos) = all_voting_scores(pos) + weight(id)*ifindex(index).scores(img_id);
        end
    end
    
    % 3.0
    %end
end

[all_voting_scores,ind] = sort(all_voting_scores,'descend');
candidates = all_voted_images(ind);

scores.img = candidates;
scores.val = all_voting_scores;
%save('scores.mat','scores');


function index = Path2index(path_to_leaf,K)
sum = 0;
depth = size(path_to_leaf,1);
for i = 1:(depth-1)
    sum = sum + (path_to_leaf(i)-1)*K^(depth-i);
end
index =  sum + path_to_leaf(depth);

function id = kmeanspush(X,C)
distance = [];
for i=1:size(C,2)
    cur_dist = power(X(1,:)-C(1,i),2)+power(X(2,:)-C(2,i),2);
    distance = [distance cur_dist];
end
[Y,I] = sort(distance);
id = I(1);
    
    
    
