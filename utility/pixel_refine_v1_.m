function [ map_norm ] = pixel_refine_v1_( feature, reg_prop, adjloop, im, reg_sal )
% from region-level to pixel-level refinement
%   inspired by saliency filters paper

global spnum superpixels row col dim para
im_lab = colorspace_('Lab<-',im);
column_lab = reshape(im_lab, row*col, dim);
pixel_sal = zeros(row, col);

for i = 1:spnum
    neighbor = find( adjloop(i,:)==1 );
    
    [x, y] = find( superpixels==i );
    ind = find( superpixels==i );
    pixel_color = column_lab( ind, : );
    pixel_position = [ x y ];
    weight = zeros(length(ind), length(neighbor));
    
    for j = 1:length(neighbor)
        temp_position = reg_prop(neighbor(j)).Centroid;
        temp_color = feature(neighbor(j),1:3);
        region_position = repmat(temp_position, length(ind), 1);
        region_color = repmat(temp_color, length(ind), 1);
        position = sqrt(sum((pixel_position - region_position).^2, 2));
        color = sqrt(sum((pixel_color - region_color).^2, 2));
%         position_norm = normVector_(position,0);
%         color_norm = normVector_(color,0);
        temp = -( para.k1.*color + para.k2.*position );     % size: 区域像素个数*1
        
        
        %expo_weight = exp(temp);
        %weight(:,j) = expo_weight*reg_sal(neighbor(j));    % 没有归一化结果
        
        
        weight(:,j) = exp(temp);
    end
    
    dd = sum(weight,2);
    dd_temp = repmat(dd, 1, length(neighbor));
    weight_row_norm = weight./dd_temp;
    temp = reg_sal(neighbor)';
    sal_rep = repmat(temp, length(ind), 1);
    weight_final = weight_row_norm.*sal_rep;
    pixel_sal(ind) = sum(weight_final,2);
    
    %pixel_sal(ind) = sum(weight,2);
    
end

pixel_map = pixel_sal;
%pixel_map = objMap.*pixel_sal;

% norm
temp = max((max(pixel_map(:))-min(pixel_map(:))),eps);
map_norm = (pixel_map - min(pixel_map(:)))/temp;

end

