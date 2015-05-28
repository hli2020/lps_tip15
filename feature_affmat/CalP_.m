function [ P, W, adjloop ] = CalP_( feature, scale, choose )
%CALP_ creat a normalised affinity matrix.
%   Geodesic constraints, k-regular graph, defined similarly as the 
%   mannifold ranking paper.

global superpixels spnum

% graph construction here, very important subfunction 
[ edges,adjloop ] = MakeEdges_(superpixels, spnum);

% case of fully-connected
% edges = [];
% for i = 1:spnum-1
%     for j = i+1:spnum
%         edges = [edges; i,j];
%     end
% end

if choose == 0
    
    temp1 = feature(edges(:,1),:) - feature(edges(:,2),:);
    temp2 = sum(temp1.^2, 2);
    valDistance = sqrt(temp2);
    valDistance = normVector_(valDistance,0);
    weights = exp( -scale*valDistance );
    
elseif choose == 1
    
    temp1 = feature(edges(:,1),:) - feature(edges(:,2),:);
    temp2 = feature(edges(:,1),:) + feature(edges(:,2),:);
    temp3 = (temp1.^2)./max(temp2, eps);
    chi_dist = 2*sum(temp3, 2);
    chi_dist_norm = 1./(1 + exp( - (chi_dist-mean(chi_dist)) ) );   % normalisation via sigmoid function
    weights = exp( -scale*chi_dist_norm );

else
    error('CalP_: wrong indication of distance');
end

W = Adjacency_(edges, weights);     % 对角线为0，消除了对自身的影响
dd = sum(W, 2);
D = sparse(1:spnum, 1:spnum, dd);
P = full(D\W);      % Warning: Matrix is singular to working precision.             

end

