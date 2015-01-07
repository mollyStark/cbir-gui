function index = Path2index(path_to_leaf,K)
sum = 0;
depth = size(path_to_leaf,1);
for i = 1:(depth-1)
    sum = sum + (path_to_leaf(i)-1)*K^(depth-i);
end
index =  sum + path_to_leaf(depth);
end