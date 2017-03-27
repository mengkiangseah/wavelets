%% Preparation
clear;
close all;
clc;

%% Preamble from the start
% Some constants
T = 64;
maxT = 32;
signalLength = T * maxT;
numberOfIterations = 6;

%% Creation of dirac stream
% K = 2, so two diracs. 
xt = zeros(signalLength, 1);
xt(517) = 6.98;
xt(1569) = 2.67;
% Two diracs created, at 517, and 1569, amps 6.98 and 2.67

%% Exercise 1 
% Generate the 4th order Daubechie scaling function
phi = zeros(1, signalLength);
[phiT, ~, ~] = wavefun('db4',numberOfIterations);
phi(1:length(phiT))=phiT;

%% Some constants
% Support both the length of the filter divided by the resolution
% OR according to MATLAB, the 2N -1, which is 2(4) - 1 = 7.
L = round(length(phiT)/T,1);
nVec = 0:32-L;

%% Create t
% Only need up to 3rd Order! 
tVals = ones(signalLength, 4);
for order = 2:4
    tVals(:, order) = ((0:signalLength-1)/T).^(order - 1);
end

%% Create shifted phi
allPhi = zeros(length(nVec), length(phi));
for n = nVec
    allPhi(n+1, :) = [zeros(1, n*T) phi(1:end - n*T)];
end

%% Acquire coefficients (Because we need them again, copied from Ex1
% Can use phi because phi is orthogonal to its shifts except at 0. 
% allPhi is rows of each phi. tVal is column of each t^m. 
% Multiplication means each row times column, summed, i.e. dot product!

coefficients =  (1/T) * allPhi * tVals;
save('coefficients.mat', 'coefficients');

%% Sample using allPhi. 
yn = allPhi * xt;

%% Acquire tau, i.e. take dot product of sampled coefficients
% With each set of coefficients from t^m. i.e. some matrix multiplication
tm = yn' * coefficients;

%% Annihilating filter
[h, tk, ak] = annihilatingFilter(tm', 2);

reconstructed = zeros(signalLength, 1);
for index = 1:length(tk)
    t = tk(index);
    amp = ak(index);
    reconstructed(round(t * 64) + 1) = amp;
end

%% Time to plot!
figure('position',[0 0 1280 800]);

subplot(2, 1, 1);
stem(tVals(:, 2), xt);
title('Original Signal');
xlabel('Time Value (Resolution 64 samples per second)');
ylabel('Value');
axis([0 32.5 0 8]);

subplot(2, 1, 2);
stem(tVals(:, 2), reconstructed);
title('Reconstructed Signal');
xlabel('Time Value (Resolution 64 samples per second)');
ylabel('Value');
axis([0 32.5 0 8]);

set(findall(gcf,'type','axes'),'fontsize',25)
set(findall(gcf,'type','text'),'fontSize',25) 
fig = gcf;
fig.PaperPositionMode = 'auto';
print('pictures/ex4','-depsc','-r0');
