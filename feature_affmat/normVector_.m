function  VV = normVector_(V, scalar)
% function VV = normVector(V)
% normalize each column for the input V
% input --- 
% V: the matrix that needs to normalize
% output ---
% VV: the normalized matrix
% scalar = 3: NO normalisation
% scalar = 2: l-2 normalisation
% scalar = 1: l-1 normalisation
% scalar = 0: maximum value set to be 1.


N = size(V,2);
VV =zeros(size(V));

if scalar == 2
    for i = 1 : N
        if norm(V(:,i))~=0
            k = norm(V(:,i));
            VV(:,i) = V(:,i)/k;
        else
            VV(:,i) = V(:,i);
        end
    end
    
elseif scalar == 1
    for i = 1 : N
        if sum(V(:,i))~=0
            k = sum(V(:,i));
            VV(:,i) = V(:,i)/k;
        else
            VV(:,i) = V(:,i);
        end
    end
    
elseif scalar == 0
    for i = 1 : N
        temp = V(:,i);
        VV(:,i) = (V(:,i)-min(temp))/(max(temp)-min(temp));
    end
    
elseif scalar == 3
    VV = V;   
end

