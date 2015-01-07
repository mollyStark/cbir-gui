function [ region,H ] = Find_min_region( I, dataset_dir )
%  This function is used to find the minum region of the query image I. 

vImgNames = dir(fullfile(dataset_dir, '*.jpg'));
nImgs = length(vImgNames);
% if nImgs==1
% 	region.maxi = size(I,1);
% 	region.maxj = size(I,2);
% 	region.mini = 0;
% 	region.minj = 0;
% 	H = eye(3);
% 	return;	
% end
%I = imread(I);
img = single(rgb2gray(I));
[sift_frames, sift_desc] = vl_sift(img);
minarea = size(I,1)*size(I,2);
square = minarea;
for i=1:nImgs
	Ic = imread(fullfile(dataset_dir,vImgNames(i).name));
	imgc = single(rgb2gray(Ic));
	[csift_frames, csift_desc] = vl_sift(imgc);
	
	distRatio=1.6;
	%Feature matching based on descriptor
	%match is a matrix of feature point correspondences:
	% [test_x, test_y, candidate_x, candidate_y; ...]	
	matches=Find_sift_matches(sift_desc,sift_frames,csift_desc,csift_frames,distRatio);

	% assume the relevance is correct.
	if (size(matches,1)<6)
        %score=0;
        inliersH=[];
        H=[];
        return;
    end
	
   % plot the match
    figure(1) ; clf ;colormap gray;
    imagesc(cat(2, img', imgc')) ;

    xa = matches(:,2) ;
    xb = matches(:,4) + size(I,1) ;
    ya = matches(:,1) ;
    yb = matches(:,3) ;

    hold on ;
    for n=1:size(xa,1)
        line([xa(n,:) ; xb(n,:)], [ya(n,:) ; yb(n,:)],'color','r') ;
    end
    
   
   
	th=.01;
	[inliersH,cH]=GetInliersH(matches,th);
	
	disp(cH);
	

	if (  ( (~exist('inliersH','var')) || (isempty(inliersH)) )  ||  ((numel(inliersH)<2)&&(inliersH==0))  )
    		inliersH=1:size(matches,1);
	end
	if (size(inliersH,1)>size(inliersH,2)) %inliersH is an horizontal vector 1xN
   		 inliersH=inliersH';
	end
	
	%consider matched matches
	match_inliers=matches(inliersH',:);
	%match and match_inliers are matrices [test_x, test_y, candidate_x, candidate_y; ...]

    % Show the two images and their relevance region.
    figure(2) ; clf ; colormap gray;
    imagesc(cat(2, img', imgc')) ;

    xa = match_inliers(:,2) ;
    xb = match_inliers(:,4) + size(I,1) ;
    ya = match_inliers(:,1) ;
    yb = match_inliers(:,3) ;

    hold on ;
    for n=1:size(xa,1)
        line([xa(n,:) ; xb(n,:)], [ya(n,:) ; yb(n,:)],'color','r') ;
    end



%     figure(1);
%     imagesc(I);
%     hold on;
%     for n=1:size(match_inliers,1)
%         x1=match_inliers(n,1);
%         x2=match_inliers(n,3)+size(I,2);
%         y1 = match_inliers(n,2);
%         plot(x1,y1,'ro');
%         y2 = match_inliers(n,4);
%         line([x1,x2],[y1,y2], 'Color', 'r');
%     end
%     
%     figure(2);
%     imagesc(Ic);
%     hold on;
%     for n=1:size(match_inliers,1)
%         x2=match_inliers(n,3);
%         %x2=match_inliers(n,3)+size(I,2);
%         y2 = match_inliers(n,4);
%         plot(x2,y2,'ro');
%         %y2 = match_inliers(n,4);
%         %line([x1,x2],[y1,y2], 'Color', 'r');
%     end
    
	allmaxs=max(match_inliers,[],1);
	allmins=min(match_inliers,[],1);
	
	posi=3;
	posj=4;
	cregion.maxi = allmaxs(posi);
	cregion.maxj = allmaxs(posj);
	cregion.mini = allmins(posi);
	cregion.minj = allmins(posj);	
    
% plot the region
%     maxi=cregion.maxi;
%     maxj=cregion.maxj;
%     mini=cregion.mini;
%     minj=cregion.minj;

%     image(Ic);
%     hold on;
%     line([maxi,maxi],[maxj,minj], 'Color', 'r');
%     line([mini,mini],[maxj,minj], 'Color', 'r');
%     line([maxi,mini],[minj,minj], 'Color', 'r');
%     line([maxi,mini],[maxj,maxj], 'Color', 'r');
% 
% 
%     image(I);
%     hold on;
%     minmin=[mini;minj;1];
%     maxmax=[maxi;maxj;1];
%     minmax=[mini;maxj;1];
%     maxmin=[maxi;minj;1];
% 
%     minmin=cH*minmin; minmin(1)=minmin(1)/minmin(3); minmin(2)=minmin(2)/minmin(3); minmin(3)=1;
%     maxmax=cH*maxmax; maxmax(1)=maxmax(1)/maxmax(3); maxmax(2)=maxmax(2)/maxmax(3); maxmax(3)=1;
%     minmax=cH*minmax; minmax(1)=minmax(1)/minmax(3); minmax(2)=minmax(2)/minmax(3); minmax(3)=1;
%     maxmin=cH*maxmin; maxmin(1)=maxmin(1)/maxmin(3); maxmin(2)=maxmin(2)/maxmin(3); maxmin(3)=1;
% 
%     line([maxmax(1),maxmin(1)],[maxmax(2),maxmin(2)], 'Color', 'r');
%     line([minmax(1),minmin(1)],[minmax(2),minmin(2)], 'Color', 'r');
%     line([maxmin(1),minmin(1)],[maxmin(2),minmin(2)], 'Color', 'r');
%     line([maxmax(1),minmax(1)],[maxmax(2),minmax(2)], 'Color', 'r');

	% see if the region is the min one.
    %carea = (cregion.maxi-cregion.mini)*(cregion.maxj-cregion.minj);
    
    % count the points that is in the square after compute back ,
    % and that's the area of the test iamge.
    
    iH = inv(cH);
    count = 0;
    for x = 1:size(I,1)
        for y=1:size(I,2)
            coord = [x;y;1];
            candi_coord = iH*coord;
            cx = candi_coord(1)/candi_coord(3);
            cy = candi_coord(2)/candi_coord(3);
            if cx>=cregion.mini && cx<=cregion.maxi
                if cy>=cregion.minj && cy<=cregion.maxj
                    count = count+1;
                end
            end
        end
    end
    
    
    
    %affine = cH(1:2,1:2);
    
% 	area = det(affine)*carea;
    area = count;
    th = 0.5;
	if area<minarea && area>th*square
		region = cregion;
		minarea = area;
		H = cH;
	end
end

