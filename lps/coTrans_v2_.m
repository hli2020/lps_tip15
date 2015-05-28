function [ sim1,sim2 ] = coTrans_v2_( positive, negative, affmat )
% Co-transduction, v2

global spnum para
% negative: boundary nodes;
sim1 = zeros(spnum, 1);
sim1(negative) = 1; 
% positive: objectness nodes.
sim2 = zeros(spnum, 1);
sim2(positive) = 1;

step = 0;
check_back = 10;
check_obj = 10;
win_size = 20;
watch_back = zeros(spnum, win_size);
watch_obj = zeros(spnum, win_size);

while (check_back > 0.000001) && (check_obj > 0.000001)
    % ranking background
    for i = 1:spnum
        if isempty(find( negative==i, 1 ))
            sim1(i) = sum( affmat(i,:).*sim1' );
        end
    end
    step = step+1;
    watch_back(:,mod_(step,win_size)) = sim1;
    check_temp_back = var(watch_back,1,2);
    check_back = mean(check_temp_back);
    
    [~, ind] = sort(sim1,'ascend');
    bound_info_label = ind(1:para.neg);
        
    % ranking objectness
    for i = 1:spnum
        if isempty(find( positive==i, 1 ))
            sim2(i) = sum( affmat(i,:).*sim2' );
        end
    end
    watch_obj(:,mod_(step,win_size)) = sim2;
    check_temp_obj = var(watch_obj,1,2);
    check_obj = mean(check_temp_obj);
        
    [~, ind] = sort(sim2,'ascend');
    
    if length(ind) < para.pos
        obj_info_label = ind(1:100);
    else
        obj_info_label = ind(1:para.pos);
    end
    
    % switch labels
    negative_temp = [negative; obj_info_label];
    negative = unique(negative_temp);
    sim1(negative) = 1;
    
    positive_temp = [positive; bound_info_label];
    positive = unique(positive_temp);
    sim2(positive) = 1;
end

end

