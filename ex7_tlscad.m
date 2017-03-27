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
K = 2;
xt = zeros(signalLength, 1);
xt(517) = 6.98;
xt(1569) = 2.67;
% Two diracs created, at 517, and 1569, amps 6.98 and 2.67

%% Acquire moments
for moment = 5:8
    if moment == 5
        load('moments5.mat');
    elseif moment == 6
        load('moments6.mat');
    elseif moment == 7
        load('moments7.mat');
    elseif moment == 8
        load('moments8.mat');
    end

    %% Make S
    noises = size(momentsNoise, 1);

    % Calculate the Diracs!
    for index = 1:noises
        tau = momentsNoise(index, :);
        [h, tk, ak] = annihilatingFilterTLSCadzow(tau, 2, 2);

            reconstructed = zeros(signalLength, 1);
            for index2 = 1:length(tk)
                t = tk(index2);
                amp = ak(index2);
                reconstructed(round(t * 64) + 1) = amp;
            end

            figure('position',[0 0 1280 800]);

            stem((0:length(reconstructed)-1) * (1/64), reconstructed);
            for index2 = 1:length(tk)
                t = tk(index2);
                amp = ak(index2);
                str = {['Amplitude: ' num2str(amp)],...
                    ['Time: ' num2str(t)], ...
                    ['Sample Number: ' num2str(round(t * 64) + 1)]};
                y = amp;
                if amp > 8
                    y = 8;
                end
                if abs(amp) < 1
                    y = amp + sign(amp) * 1.5;
                end
                if y < -3
                    y = -2;
                end
                text(t+.5, y, str);
            end

            title('Reconstructed Signal');
            xlabel('Time Value (Resolution 64 samples per second)');
            ylabel('Value');
            
            axis([0 37 -5 12]);

            set(findall(gcf,'type','axes'),'fontsize',25)
            set(findall(gcf,'type','text'),'fontSize',25) 
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            print(['pictures/ex7_tlscad_' num2str(moment) '_' num2str(index)],'-depsc','-r0');

    end
end

close all;

