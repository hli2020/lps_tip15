function [ edges, temp ] = MakeEdges_( superpixels, spnum )
%
% Debug Area
% clc;clear;close all;
% temp = load('superpixels.mat');
% temp = struct2cell(temp);
% superpixels = cell2mat(temp);
% spnum = 205;

global para
adjloop = zeros(spnum, spnum);
[row, col] = size(superpixels);

for i=1:row-1
    for j=1:col-1
        if superpixels(i,j)~=superpixels(i,j+1)
            adjloop(superpixels(i,j),superpixels(i,j+1)) = 1;
            adjloop(superpixels(i,j+1),superpixels(i,j)) = 1;
        end
        
        if superpixels(i,j)~=superpixels(i+1,j)
            adjloop(superpixels(i,j),superpixels(i+1,j)) = 1;
            adjloop(superpixels(i+1,j),superpixels(i,j)) = 1;
        end
        
        if superpixels(i,j)~=superpixels(i+1,j+1)
            adjloop(superpixels(i,j),superpixels(i+1,j+1)) = 1;
            adjloop(superpixels(i+1,j+1),superpixels(i,j)) = 1;
        end
        
        if superpixels(i+1,j)~=superpixels(i,j+1)
            adjloop(superpixels(i+1,j),superpixels(i,j+1)) = 1;
            adjloop(superpixels(i,j+1),superpixels(i+1,j)) = 1;
        end
    end
end

temp = adjloop;
%-----------------Geodesic Constraint------------------------%
if para.constraint == 1
    
    boundary = unique([superpixels(1,:), superpixels(row,:)...
        superpixels(:,1)', superpixels(:,col)']);
    for i=1:length(boundary)
        for j=i+1:length(boundary)
            adjloop(boundary(i),boundary(j)) = 1;
            adjloop(boundary(j),boundary(i)) = 1;
        end
    end
    
end
%------------------------------------------------------------%
edges = [];

if para.k == 1
    
    num = 0;
    for i=1:spnum
        ind = find(adjloop(i,:)==1);
        ind = ind(ind>i);
        for j=1:length(ind)
            edges(num+j,1) = ind(j);
            edges(num+j,2) = i;
        end
        num = num + length(ind);
    end
    
elseif para.k == 2
    
    for i = 1:spnum
        indext = [];
        ind = find(adjloop(i,:)==1);
        for j = 1:length(ind)
            indj = find(adjloop(ind(j),:)==1);
            indext = [indext, indj];
        end
        indext = [indext, ind];
        indext = indext((indext>i));
        indext = unique(indext);
        
        if (~isempty(indext))
            ed = ones(length(indext),2);
            ed(:,2) = i*ed(:,2);
            ed(:,1) = indext;
            edges = [edges;ed];
        end
    end
end


end

