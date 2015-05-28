function [ output ] = mod_( num, base )

% example: mod_(50,50) = 50; mod_(0,50) = 50;
if mod(num, base) == 0
    output = base;
elseif num == 0
    output = base;
else
    output = mod(num, base);
    
end

