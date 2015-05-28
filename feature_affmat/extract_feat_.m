
function [ feat, bound_ind ] = extract_feat_( im )

global row col dim superpixels spnum

% alpha = 0;
% gradient using gray-scale image
% if size(im,3) ~= 1
%     gray = rgb2gray(im);
% else
%     gray = input_im;
% end
% [x, y] = gradient(gray);
% magnitude = sqrt(x.^2 + y.^2);
% angle = atan2(y,x);
% mag = (magnitude - min(magnitude(:)))/(max(magnitude(:))-min(magnitude(:)));
% ang = (angle - min(angle(:)))/(max(angle(:))-min(angle(:)));
% 
% % find boundary pixels of each region
% op = [1 0 -1];
% x_mask = op';
% y_mask = op;
% edgemap_x = filter2(x_mask, uint8(superpixels), 'same');
% edgemap_y = filter2(y_mask, uint8(superpixels), 'same');
% edgemap = edgemap_x | edgemap_y;

% extract structure descriptor and Lab color of each region
rgb_vals = zeros(spnum,3);
inds = cell(spnum,1);
input_rgb = reshape(im, row*col, dim);

binNum = 10;
struct_hist = zeros(spnum, binNum*2);
for i = 1:spnum
    % color
    inds{i} = find(superpixels == i);
    temp1 = input_rgb(inds{i},:);
    rgb_vals(i,:) = mean(temp1,1);
    
%     % structure
%     temp2 = (superpixels==i);
%     
%     if alpha == 1    
%         % only borders of superpixels
%         reg_ind =  (temp2 & edgemap) == 1 ;   
%     else
%         % all pixels within a superpixel
%         reg_ind = temp2;
%     end
%     
%     reg_mag = mag(reg_ind);
%     reg_ang = ang(reg_ind);
%     struct_hist(i,:) = cal_hist_(reg_mag, reg_ang, binNum);
    
end
lab_vals = colorspace_('Lab<-',rgb_vals);


% locCollection = cell(spnum,1);          % mapping spatial (x,y) to superpixel region.
% for x=1:row
%     for y=1:col
%         label = superpixels(x,y);
%         locCollection{label} = [locCollection{label};x,y];
%     end
% end
% 
% loc_vals = [];
% for i=1:spnum
%     loc_vals = [loc_vals; mean(locCollection{i},1)];  
% end


feat = [lab_vals, struct_hist];                 % FEAT size: spnum*D, 
                                                % 1:3, lab; 4:23, OM hist;
                                                % 24:25, coordinates. (no more this variable)
bound_ind = unique([superpixels(1,:), superpixels(row,:)...
    superpixels(:,1)', superpixels(:,col)'])';      % BOUND_IND: column vector   
                                                
end

