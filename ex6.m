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

%% Daubechies
orders = 5:8;
noises = sqrt([0.001 0.01 0.1 1 10]);
% Multiplying by a gives variance of a^2. 

for order = orders
    % Create moments
    [moments, phi, ~] = daubechieMoments(xt, order);
    % Duplicate
    momentsNoise = repmat(moments, length(noises), 1);
    
    % Add different values of noise.
    for index = 1:length(noises)
        momentsNoise(index, :) = noises(index) * randn(1, length(moments)) + momentsNoise(index, :);
    end
    
    % Picture time!
    figure('position',[0 0 1280 800]);

    subplot(3, 2, 1);
    plot(phi);
    axis([0 length(phi) -0.4 1.2]);
    the_title = ['Order ' num2str(order) ' Daubechie Kernel'];
    title(the_title);
    xlabel('Time Value (Resolution 64 samples per second)');
    ylabel('Value');
    
    for index = 1:length(noises)
        subplot(3, 2, index+1);
        stem(momentsNoise(index, :));
        xlabel('m');
        ylabel('Value');
        title(['Moment, \sigma^2: ' num2str(noises(index)^2)]);
    end
    
    filename = ['moments' num2str(order)];
    
    set(findall(gcf,'type','axes'),'fontsize',25)
    set(findall(gcf,'type','text'),'fontSize',25) 
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print(['pictures/ex6_' filename],'-depsc','-r0');
    
    save(filename, 'momentsNoise', 'phi');
end
