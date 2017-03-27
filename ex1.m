%% Preparation
clear;
close all;

%% Preamble from the start
% Some constants
T = 64;
maxT = 32;
signalLength = T * maxT;
numberOfIterations = 6;

%% Exercise 1 
% Generate the 4th order Daubechie scaling function
phi = zeros(1, signalLength);
[phiT, psiT, xVal] = wavefun('db4',numberOfIterations);
phi(1:length(phiT))=phiT;

%% Create and save picture.
figure('position',[0 0 1280 800]);

plot(phiT);
axis([0 length(phiT) -0.4 1.2]);

title('Order 4 Daubechie Filter');
xlabel('Time Value (Resolution 64 samples per second)');
ylabel('Value');

set(findall(gcf,'type','axes'),'fontsize',25)
set(findall(gcf,'type','text'),'fontSize',25) 
fig = gcf;
fig.PaperPositionMode = 'auto';
print('ex1_1','-depsc','-r0');

%% Some constants
% Support both the length of the filter divided by the resolution
% OR according to MATLAB, the 2N -1, which is 2(4) - 1 = 7.
L = round(length(phiT)/T,1);
nVec = 0:32-L;

%% Create t
% So have to check for up to 4th order. Meaning, 0 - 4. i.e 1 to 5. 
% Construct the vectors of t^m. 
tVals = ones(signalLength, 5);
for order = 2:5
    tVals(:, order) = ((0:signalLength-1)/T).^(order - 1);
end

%% Create shifted phi
allPhi = zeros(length(nVec), length(phi));
for n = nVec
    allPhi(n+1, :) = [zeros(1, n*T) phi(1:end - n*T)];
end

%% Acquire coefficients
% Can use phi because phi is orthogonal to its shifts except at 0. 
% allPhi is rows of each phi. tVal is column of each t^m. 
% Multiplication means each row times column, summed, i.e. dot product!

coefficients =  (1/T) * allPhi * tVals;

%% Reconstruction
reconstructed = zeros(5, signalLength);

for m = 1:5
    temp = 0;
    for n = nVec
        temp = temp + coefficients(n+1, m) .* allPhi(n+1, :);
    end
    reconstructed(m, :) = temp;
end

%% Plot original with reconstructed and kernels
error = zeros(5, 1);
for m = 1:5 
    figure('position',[0 0 1280 800]);
    hold on;
    plot(tVals(:, 2), tVals(:, m), 'r', 'LineWidth', 5);
    plot(tVals(:, 2), reconstructed(m, :), 'b', 'LineWidth', 3);
    kernels = diag(coefficients(:, m)) * allPhi;
    plot(tVals(:, 2), kernels' , 'LineWidth', 1);
    hold off;
    xlim([0 32]);
    title(['m = ' num2str(m - 1) ', Original and Reconstructed']);
    xlabel('Time Value/s (Sampling Freq: 64Hz)');
    ylabel('Value');
    leg = legend('Original', 'Reconstructed'); 
    error(m) = sum(abs(tVals(7*32:22*32, m) - reconstructed(m, 7*32:22*32)'));
    set(leg,'FontSize',25);
    set(findall(gcf,'type','axes'),'fontsize',25)
    set(findall(gcf,'type','text'),'fontSize',25) 
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    filename = ['ex1_2_' num2str(m-1)];
    print(filename,'-depsc','-r0');
end