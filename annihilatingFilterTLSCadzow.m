function [ h, tk, ak ] = annihilatingFilterTLSCadzow( tau, K, times )
% function [  ] = annihilatingFilterTLS( tau, K )
%ANNIHILATINGFILTERTLS Same as before, but instead, there is an TLS
%approach
    
    N = length(tau) - 1;
    % Construct S
    c = tau(K+1:N);
    r = fliplr(tau(1:K+1));
    S = toeplitz(c', r);
    % SVD to get V
    for iteration = 1:times
        [U, D, V] = svd(S);
        % Remove smaller eigenvalues
        Dr = size(D, 1) - K;
        Dc = size(D, 2) - K;
        Ddash = [D(1:K, 1:K), zeros(K, Dc); zeros(Dr, K), zeros(Dr, Dc)];
        S = U * Ddash * V'; 
        % Make "Toeplitz"
        Pr = size(S, 1);
        Pc = size(S, 2);

        if Pr > Pc
            maxSize = Pr;
        else
            maxSize = Pc;
        end

        S_temp = zeros(maxSize, maxSize);
        for dIndex = -(Pr-1):1:Pc-1
            working = diag(S, dIndex);
            longth = maxSize - abs(dIndex);

            temp = mean(working);
            new = diag(temp * ones(longth, 1), dIndex);
            S_temp = S_temp + new;
        end
        S = S_temp(1:Pr, 1:Pc);
    end
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

