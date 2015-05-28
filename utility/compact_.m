% calculate the compactness of an image
function compactness = compact_(reg_prop, sim)
% note: 'sim' must be a [0,1] vector
global spnum row col

bin_num = 10;
compactness = 0;
hist = zeros(bin_num+1,1);
for i = 1:spnum
    bin = floor(sim(i)*bin_num) + 1;
    hist(bin) = hist(bin) + reg_prop(i).Area;
end
hist(bin_num) = hist(bin_num) + hist(bin_num+1);
hist_norm = hist(1:end-1)/(row*col);

for i = 1:bin_num
    compactness = compactness + hist_norm(i)*min(i,(bin_num+1-i));
end

end