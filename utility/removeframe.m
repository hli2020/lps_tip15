function [output_im,w]=removeframe( input_im )

threshold = 0.6;
if size(input_im,3) ~= 1
    gray = rgb2gray(input_im);
else
    gray = input_im;
end

edgemap = edge(gray,'canny');       % logical matrix
[m,n] = size(edgemap);

flagt = 0; flagd = 0; flagr = 0; flagl = 0;
t = 1; d = 1; l = 1; r = 1;

% we assume that the frame is not wider than 60 pixels.
for k = 1:60 
    pbt = mean(edgemap(k,:));
    pbd = mean(edgemap(m-k+1,:));
    pbl = mean(edgemap(:,k));
    pbr = mean(edgemap(:,n-k+1));
    if pbt > threshold
        t = k; flagt = 1;
    end
    if pbd > threshold
        d = k; flagd = 1;
    end
    if pbl > threshold
        l = k; flagl = 1;
    end
    if pbr > threshold
        r = k; flagr = 1;
    end
end

flagrm = flagt+flagd+flagl+flagr;
% we assume that there exists a frame when one more lines 
% parallel to the image side are detected 
if flagrm > 1 
    maxwidth = max([t,d,l,r]);
    if t == 1
        t = maxwidth;
    end
    if d == 1
        d = maxwidth;
    end
    if l == 1
        l = maxwidth;
    end
    if r == 1
        r = maxwidth;
    end    
    output_im = input_im(t:m-d+1,l:n-r+1,:);
    w = [m,n,t,m-d+1,l,n-r+1];
else
    output_im = input_im;
    w = [m,n,1,m,1,n];
end  



      