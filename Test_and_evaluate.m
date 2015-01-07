function Test_and_evaluate(vocab_dir,candi_dir)
% This function is used to evaluate the perfomance of the retrieval
% results.

% Edit by Molly v1.0 (specially for ukbench) 22-05-2014 15:37
% Edit by Molly v2.0 (add the feedback part) 3-06-2014 9:50

vImageNames = dir([vocab_dir '/*.jpg']);
addpath('E:\wml\cbir_m\Verification\');

n=0;
mean1 = 0;
mean2 = mean1+0.1;
candidates = [];

for i=1:250
% i = 30;
    test_img = [vocab_dir '/' vImageNames((i-1)*4+2,:).name];
    
    ts = tic;
    scores = Retrieve_best_candidates(test_img);
    te = toc(ts);
    time1(i) = te;
    
    [Y,I] = sort(scores.val,'descend');
    rank = scores.img(I);
    ap1(i) = 0;
    for j=1:4
        pos = find(rank==(i-1)*4+j);
        if ~isempty(pos)
            ap1(i) = ap1(i) + pos;
        else
           ap1(i) = ap1(i) + 500; 
        end
    end
    
    
    % clear the fold of candidate images
    delete([candi_dir '/positive/*.jpg']);
%     delete([candi_dir '/negative/*.jpg']);
    
    % copy the top 10 files into the candi_dir
    ccandi = [0,0,0,0];
    for j=1:10
        if floor((rank(j)-1)/4)+1==i
            copyfile([vocab_dir '/' vImageNames(rank(j),:).name],[candi_dir '/positive']);
            ccandi(rank(j)+4-i*4) = rank(j);
%         else
%             copyfile([vocab_dir '/' vImageNames(rank(j),:).name],[candi_dir '/negative']);
        end
    end
    candidates = [candidates;ccandi];
    
    ts = tic;
    rank = feedback_test([candi_dir '/positive'],[candi_dir '/negative'],test_img);
    te = toc(ts);
    time2(i) = te;
    
    % compute the average precision (AP)
    ap2(i) = 0;
    for j=1:4
        pos = find(rank==(i-1)*4+j);
        if ~isempty(pos)
            ap2(i) = ap2(i) + pos;
        else
           ap2(i) = ap2(i) + 500; 
        end
    end
    
end 

save('candidates','candidates');
% load('candidates');
% load('ap-1.2-v1.4.mat');
mean1 = mean(ap1);
mean2 = mean(ap2);
while(mean2>mean1&&n<=5)   
    n=n+1;
    candi_tmp = []; 
    for i = 1:250
    test_img = [vocab_dir '/' vImageNames((i-1)*4+2,:).name];
    % clear the fold of candidate images
    delete([candi_dir '/positive/*.jpg']);
    %delete([candi_dir '/negative/*.jpg']);
    
    % copy the candidate files into the candi_dir
    ccandi = candidates(i,:);
    for j=1:4
        if ccandi(j)~=0
            copyfile([vocab_dir '/' vImageNames(ccandi(j),:).name],[candi_dir '/positive']);
        end
    end
    
    ts = tic;
    rank = feedback_test([candi_dir '/positive'],[candi_dir '/negative'],test_img);
    te = toc(ts);
    time2(i) = te;

    ccandi = [0,0,0,0];
    for j=1:10
        if floor((rank(j)-1)/4)+1==i
%             copyfile([vocab_dir '/' vImageNames(rank(j),:).name],[candi_dir '/positive']);
            ccandi(rank(j)+4-i*4) = rank(j);
%         else
%             copyfile([vocab_dir '/' vImageNames(rank(j),:).name],[candi_dir '/negative']);
        end
    end
    
    % compute the average precision (AP) && improve the can
    ap2(i) = 0;
    for j=1:4
        if candidates(i,j)==0 && ccandi(j)~=0
            candidates(i,j)=ccandi(j);
        end
        pos = find(rank==(i-1)*4+j);
        if ~isempty(pos)
           ap2(i) = ap2(i) + pos;
        else
           ap2(i) = ap2(i) + 500; 
        end
    end
    end    
    
   % compute the mean AP.
    mean2 = mean(ap2);
end

mean2 = mean(ap2);


    
    
    

