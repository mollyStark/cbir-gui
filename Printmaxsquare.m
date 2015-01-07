function Printmaxsquare(matches,inliersH,H,image1,image2,figurenumber,titleText1,titleText2)
% image2=I;
% image1=Ic;

if (  ( (~exist('inliersH','var')) || (isempty(inliersH)) )  ||  ((numel(inliersH)<2)&&(inliersH==0))  )
    inliersH=1:size(matches,1);
end
if (size(inliersH,1)>size(inliersH,2)) %inliersH is an horizontal vector 1xN
    inliersH=inliersH';
end
if ( (~exist('titleText2','var')) || (isempty(titleText2)) )
    titleText2='Selected from dataset';
end
if ( (~exist('titleText1','var')) || (isempty(titleText1)) )
    titleText1='Test image';
end
if ( (~exist('figurenumber','var')) || (isempty(figurenumber)) )
    figurenumber=1;
end

%consider matched matches
match_inliers=matches(inliersH',:);
%match and match_inliers are matrices [test_x, test_y, candidate_x, candidate_y; ...]

allmaxs=max(match_inliers,[],1);
allmins=min(match_inliers,[],1);



figure(figurenumber);
set(gcf, 'color', 'white');



subplot(1, 2, 1);
imagesc(image2); %imshow(image2);
hold on;
posi=3;
posj=4;
maxi=allmaxs(posi);
maxj=allmaxs(posj);
mini=allmins(posi);
minj=allmins(posj);

line([maxi,maxi],[maxj,minj], 'Color', 'r');
line([mini,mini],[maxj,minj], 'Color', 'r');
line([maxi,mini],[minj,minj], 'Color', 'r');
line([maxi,mini],[maxj,maxj], 'Color', 'r');

plot(match_inliers(:,3),match_inliers(:,4),'+b'); %plot(x,y)
hold off;
title(titleText1);


subplot(1, 2, 2);
imagesc(image1); %imshow(image1);
hold on;
posi=3;
posj=4;
maxi=allmaxs(posi);
maxj=allmaxs(posj);
mini=allmins(posi);
minj=allmins(posj);

minmin=[mini;minj;1];
maxmax=[maxi;maxj;1];
minmax=[mini;maxj;1];
maxmin=[maxi;minj;1];

minmin=H*minmin; minmin(1)=minmin(1)/minmin(3); minmin(2)=minmin(2)/minmin(3); minmin(3)=1;
maxmax=H*maxmax; maxmax(1)=maxmax(1)/maxmax(3); maxmax(2)=maxmax(2)/maxmax(3); maxmax(3)=1;
minmax=H*minmax; minmax(1)=minmax(1)/minmax(3); minmax(2)=minmax(2)/minmax(3); minmax(3)=1;
maxmin=H*maxmin; maxmin(1)=maxmin(1)/maxmin(3); maxmin(2)=maxmin(2)/maxmin(3); maxmin(3)=1;

line([maxmax(1),maxmin(1)],[maxmax(2),maxmin(2)], 'Color', 'r');
line([minmax(1),minmin(1)],[minmax(2),minmin(2)], 'Color', 'r');
line([maxmin(1),minmin(1)],[maxmin(2),minmin(2)], 'Color', 'r');
line([maxmax(1),minmax(1)],[maxmax(2),minmax(2)], 'Color', 'r');

plot(match_inliers(:,1),match_inliers(:,2),'+b');
hold off;
title(titleText2);

