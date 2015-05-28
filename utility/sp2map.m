function  [final] = sp2map( reg )
%function  [final] = sp2map( reg, out_path, name, suffix )
global superpixels w row col
sal = zeros(row, col);
for i=1:row
    for j=1:col
        temp = superpixels(i,j);
        sal(i,j) = reg(temp);
    end
end

final = zeros(w(1),w(2));
final(w(3):w(4),w(5):w(6)) = sal;
%imwrite(final, [out_path name(1:end-4) suffix]);

%final_int = uint8(final*255);
%imwrite(final_int, [out_path name(1:end-4) suffix]);
end

