function [ score_weight ] = objWeight_( xmin, ymin, xmax, ymax, score )

factor = .25;
row = ymax - ymin + 1;  
col = xmax - xmin + 1;
row_cen = floor(row/2);
col_cen = floor(col/2);
sigma_y = factor*row;
sigma_x = factor*col;
expo = zeros(row, col);
for i = 1:row
    for j = 1:col
        temp = (j-col_cen)^2/(2*sigma_x^2) + (i-row_cen)^2/(2*sigma_y^2) ;
        expo(i,j) = exp(-temp);
    end
end
score_weight = expo*score;

end

