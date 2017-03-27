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

%% Time to plot!
figure('position',[0 0 1280 800]);

stem((0:signalLength-1) * (1/64), xt);
title('Original Signal');
xlabel('Time Value (Resolution 64 samples per second)');
ylabel('Value');
axis([0 32.5 0 8]);
text(517/64 + 2, 6.98, {['Sample: ' num2str(517)], ['Amplitude: ' num2str(6.98)]});
text(1569/64 + 2, 2.67, {['Sample: ' num2str(1569)], ['Amplitude: ' num2str(2.67)]});

set(findall(gcf,'type','axes'),'fontsize',25)
set(findall(gcf,'type','text'),'fontSize',25) 
fig = gcf;
fig.PaperPositionMode = 'auto';
print('pictures/originalDirac','-depsc','-r0');