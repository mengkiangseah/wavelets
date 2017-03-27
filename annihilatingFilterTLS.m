function [ h, tk, ak ] = annihilatingFilterTLS( tau, K )
% function [  ] = annihilatingFilterTLS( tau, K )
%ANNIHILATINGFILTERTLS Same as before, but instead, there is an TLS
%approach
    
    N = length(tau) - 1;
    % Construct S
    c = tau(K+1:N);
    r = fliplr(tau(1:K+1));
    S = toeplitz(c', r);
    % SVD to get V
    [~, ~, V] = svd(S);
    % H is last column of V
    h = V(:, end);
    % As before
    tk = roots(h);
    
    % The Vandermonde system is:
    % tMat * ak = tauVecA, aka: ak = tMat\tauVecA
    tauVecA = tau(1:K)';
    
    tMat = ones(K, K);
    for row = 2:K
        tMat(row, :) = tk' .^ (row - 1);
    end
    
    ak = tMat\tauVecA;

end

