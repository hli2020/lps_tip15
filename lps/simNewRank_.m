function [ sim ] = simNewRank_( postive, negative, affmat )
% measures how similar to the negative sets
global spnum
sim = zeros(spnum,1);
sim(postive) = 0;
sim(negative) = 1;
label = [postive; negative];

step = 0;
check = 10;
win_size = 20;
watch_back = zeros(spnum, win_size);
% list = randperm(spnum);
while check > 0.000001
    for i = 1:spnum
%     for i = spnum:-1:1
%     for ii = 1:spnum
%         i = list(ii);        
        if isempty(find( label==i, 1 ))
            sim(i) = sum( affmat(i,:).*sim' );
        end
    end
    step = step+1;
    watch_back(:,mod_(step,win_size)) = sim;
    check_temp = var(watch_back,1,2);
    check = mean(check_temp);
end

end

