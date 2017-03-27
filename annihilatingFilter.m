function [ h, tk, ak ] = annihilatingFilter( tau, K )
%ANNIHILATINGFILTER Takes in the signal tau, and the K value, returns
%the annihilating filter coefficients, the tks, and the weights ak. 
    
    % Value of N is one less than length of tau.
    N = length(tau) - 1;
    
    % We know size of h (O to K)
    h = ones(K+1, 1);
    
    % Construct and solve the tauMat *  hVec = - tauVecH part.
    % Matlab indexing. Urg.
    tauVecH = tau(K+1:N+1);
    tauMat = zeros(N - K + 1, K);
    
    for col = K:-1:1
        tauMat(:, col) = tau(K - col + 1: N + 1 - col );
    end
    
    % hVec = tauMat^-1 * tauVecH, but that's also tauMat\tauVecH.
    % h is [1; hvec]
    h(2:end) = tauMat\-tauVecH;
    
    % tks are the roots of the polynomial h. Using MATLAB function. Roots
    % Input is coefficients, highest order lowest. Since h[0] = 1, means
    % that's the highest order, so is already in order.
    tk = roots(h);
    
    % The Vandermonde system is:
    % tMat * ak = tauVecA, aka: ak = tMat\tauVecA
    tauVecA = tau(1:K);
    
    tMat = ones(K, K);
    for row = 2:K
        tMat(row, :) = tk' .^ (row - 1);
    end
    
    ak = tMat\tauVecA;
end

