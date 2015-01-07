function rank = feedback_test(pos_dir,neg_dir,test_img)
% This function is used to test if can learn from the pos_dir
% version 1.0
% Add learning images from neg_dir
% version 2.0

load('ifindex-1000v2-4.mat');
load('vocabulary-1000v2-4.mat');
%load('scores.mat');
%vPosNames = dir([pos_dir '\*.jpg'])
vPosNames = pos_dir;
vNegNames = dir([neg_dir '\*.jpg']);
[path,name,ext] = fileparts(test_img);
I = imread(test_img);
test_image = single(rgb2gray(I));
[sift_frames, sift_desc] = vl_sift(test_image);
rscores = [];
rimages = [];

% only the positive images 
[region, H] = Find_min_region(I, pos_dir);

cur_sift_desc = [];

% plot the min region 
% image(I);
% hold on;
% maxi=region.maxi;
% maxj=region.maxj;
% mini=region.mini;
% minj=region.minj;
% 
% minmin=[mini;minj;1];
% maxmax=[maxi;maxj;1];
% minmax=[mini;maxj;1];
% maxmin=[maxi;minj;1];
% 
% minmin=H*minmin; minmin(1)=minmin(1)/minmin(3); minmin(2)=minmin(2)/minmin(3); minmin(3)=1;
% maxmax=H*maxmax; maxmax(1)=maxmax(1)/maxmax(3); maxmax(2)=maxmax(2)/maxmax(3); maxmax(3)=1;
% minmax=H*minmax; minmax(1)=minmax(1)/minmax(3); minmax(2)=minmax(2)/minmax(3); minmax(3)=1;
% maxmin=H*maxmin; maxmin(1)=maxmin(1)/maxmin(3); maxmin(2)=maxmin(2)/maxmin(3); maxmin(3)=1;
% 
% line([maxmax(1),maxmin(1)],[maxmax(2),maxmin(2)], 'Color', 'r');
% line([minmax(1),minmin(1)],[minmax(2),minmin(2)], 'Color', 'r');
% line([maxmin(1),minmin(1)],[maxmin(2),minmin(2)], 'Color', 'r');
% line([maxmax(1),minmax(1)],[maxmax(2),minmax(2)], 'Color', 'r');

H = inv(H);
weight = ones(1,size(sift_desc,2));
th = 1.5;
for i=1:size(sift_desc,2)
    ori_coord = [sift_frames(1:2,i);1];
    candi_coord = H*ori_coord;
    x = candi_coord(1)/candi_coord(3);
    y = candi_coord(2)/candi_coord(3);
    if x>=region.mini && x<=region.maxi
        if y>=region.minj && y<=region.maxj
             cur_sift_desc = [cur_sift_desc sift_desc(:,i)];
%            weight(i) = th;
        end
    end
end

rank = Re_Retrieve(cur_sift_desc,vocabulary_tree,ifindex,weight);


% the positive images 
% for num = 1:size(vPosNames,1)
%     if [name ext]==vPosNames(num,:).name
%         rscores = scores.val;
%         rimages = scores.img;
%         continue;
%     end
%     
%     cur_filename = [pos_dir '/' vPosNames(num,:).name];    
%     img = single(rgb2gray(imread(cur_filename)));
%     [cur_sift_frames,cur_sift_desc] = vl_sift(img);
%     
%     [match_corresp_which,scores] = vl_ubcmatch(cur_sift_desc, sift_desc);
%     count=0;
    
    % plot the match
%     [drop, perm] = sort(scores, 'descend') ;
%     match_corresp_which = match_corresp_which(:, perm) ;
%     scores  = scores(perm) ;
% 
%     figure(1) ; clf ;
%     imagesc(cat(2, img, test_image)) ;
%     axis image off ;
%     vl_demo_print('sift_match_1', 1) ;
% 
%     figure(2) ; clf ;
%     imagesc(cat(2, img, test_image)) ;
% 
%     xa = cur_sift_frames(1,match_corresp_which(1,:)) ;
%     xb = sift_frames(1,match_corresp_which(2,:)) + size(test_image,2) ;
%     ya = cur_sift_frames(2,match_corresp_which(1,:)) ;
%     yb = sift_frames(2,match_corresp_which(2,:)) ;
% 
%     hold on ;
%     h = line([xa ; xb], [ya ; yb]) ;
    % set(h,'linewidth', 1, 'color', 'b') ;

    % vl_plotframe(cur_sift_frames(:,match_corresp_which(1,:))) ;
    % sift_frames(1,:) = sift_frames(1,:) + size(img,2) ;
    % vl_plotframe(sift_frames(:,match_corresp_which(2,:))) ;
    % axis image off ;
    
%     for i=1:size(match_corresp_which,2)
%        cur_sift_num = match_corresp_which(1,i);
%        sift_num = match_corresp_which(2,i);
%        cpath_to_leaf = vl_hikmeanspush(vocabulary_tree,cur_sift_desc(:,cur_sift_num));
%        path_to_leaf = vl_hikmeanspush(vocabulary_tree,sift_desc(:,sift_num));
%        cindex = Path2index(cpath_to_leaf,vocabulary_tree.K);
%        index = Path2index(path_to_leaf,vocabulary_tree.K); 
%        
%        if(cindex==index) 
%            count=count+1;
%            candi_images = ifindex(cindex).images;
%            weight=3;
%        else
%            cimages = ifindex(cindex).images;
%            images = ifindex(index).images;
%            candi_images = getImages(cimages,images);
%            weight=2;
%        end   
%        for j=1:size(candi_images,2)
%            pos = find(rimages==candi_images(j));
%            ifpos = find(ifindex(cindex).images==candi_images(j));
%            if isempty(pos)
%                rimages = [rimages candi_images(j)];
%                % rscores = [rscores weight];
%                rscores = [rscores weight*ifindex(cindex).scores(ifpos)];
%            else
%                % rscores(pos) = rscores(pos) + weight;
%                rscores(pos) = rscores(pos) + weight*ifindex(cindex).scores(ifpos);
%            end
%        end
%        
%     end
% end

% the negative images
% for num = 1:size(vNegNames,1)
%     cur_filename = [neg_dir '/' vNegNames(num,:).name];
%     img = single(rgb2gray(imread(cur_filename)));
%     [cur_sift_frames,cur_sift_desc] = vl_sift(img);
%     
%     [match_corresp_which,scores] = vl_ubcmatch(cur_sift_desc, sift_desc);
%     count=0;
    
    % plot the matches
%     [drop, perm] = sort(scores, 'descend') ;
%     match_corresp_which = match_corresp_which(:, perm) ;
%     scores  = scores(perm) ;
% 
%     figure(1) ; clf ;
%     imagesc(cat(2, img, test_image)) ;
%     axis image off ;
%     vl_demo_print('sift_match_1', 1) ;
% 
%     figure(2) ; clf ;
%     imagesc(cat(2, img, test_image)) ;
% 
%     xa = cur_sift_frames(1,match_corresp_which(1,:)) ;
%     xb = sift_frames(1,match_corresp_which(2,:)) + size(test_image,2) ;
%     ya = cur_sift_frames(2,match_corresp_which(1,:)) ;
%     yb = sift_frames(2,match_corresp_which(2,:)) ;
% 
%     hold on ;
%     h = line([xa ; xb], [ya ; yb]) ;
    
%      retrieve again
%     for i=1:size(match_corresp_which,2)
%        cur_sift_num = match_corresp_which(1,i);
%        sift_num = match_corresp_which(2,i);
%        cpath_to_leaf = vl_hikmeanspush(vocabulary_tree,cur_sift_desc(:,cur_sift_num));
%        path_to_leaf = vl_hikmeanspush(vocabulary_tree,sift_desc(:,sift_num));
%        cindex = Path2index(cpath_to_leaf,vocabulary_tree.K);
%        index = Path2index(path_to_leaf,vocabulary_tree.K); 
%        
%        if(cindex==index) 
%            count=count+1;
%            candi_images = ifindex(cindex).images;
%            weight=-3;
%        else
%            cimages = ifindex(cindex).images;
%            images = ifindex(index).images;
%            candi_images = getImages(cimages,images);
%            weight=-2;
%        end   
%        for j=1:size(candi_images,2)
%            pos = find(rimages==candi_images(j));
%            ifpos = find(ifindex(cindex).images==candi_images(j));
%            if isempty(pos)
%                rimages = [rimages candi_images(j)];
%                rscores = [rscores weight*ifindex(cindex).scores(ifpos)];
%            else
%                rscores(pos) = rscores(pos) + weight*ifindex(cindex).scores(ifpos);
%            end
%        end       
%     end
% end

% rank = zeros(1,size(rscores,2));
% [Y,I] = sort(rscores,'descend');
% for i=1:size(rscores,2)
%     rank(i) = rimages(I(i));
% end


function return_images = getImages(cimages,images)
return_images = [];
for i = 1:size(cimages,2)
    pos = find(images==cimages(i));
    if ~isempty(pos)
        return_images = [return_images cimages(i)];
    end
end

        
        
        
        
    