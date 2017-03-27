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

%% Load values
load('samples.mat');
% Load my coefficients
load('coefficients.mat');

% The sample had 32 though. But 27-32 were 0 anyway.
% Only 1-26 was used because the instructions said until 32 - L.
% L = 26 in my case.
actualy = y_sampled(1:26);

% Acquire moments
tm = actualy * coefficients;
% Filter of an annihilation-y nature.
[h, tk, ak] = annihilatingFilter(tm', 2);

% Reconstruct signal
reconstructed = zeros(signalLength, 1);
for index = 1:length(tk)
    t = tk(index);
    amp = ak(index);
    reconstructed(round(t * 64) + 1) = amp;
end

disp(round(tk * 64) + 1);
disp(ak);
disp(tk);

%% Plot it all
figure('position',[0 0 1280 800]);

stem((0:signalLength-1) * (1/64), reconstructed);
title('Reconstructed Signal');
xlabel('Time Value (Resolution 64 samples per second)');
ylabel('Value');
axis([0 32.5 0 3]);

set(findall(gcf,'type','axes'),'fontsize',25)
set(findall(gcf,'type','text'),'fontSize',25) 
fig = gcf;
fig.PaperPositionMode = 'auto';
print('pictures/ex5','-depsc','-r0');
