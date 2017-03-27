clear;
close all;
clc;

limits = 0:0.01:1;
snr = zeros(length(limits), 1);
tic;

parfor index = 1:length(limits)
    disp(index);
   [~, snr(index)] =  Main_SR(limits(index));
   close;
end
disp(toc);

%% Plot
load('snr.mat');
figure('position',[0 0 1280 800]);

[maxSNR, limitIndex] = max(snr);

plot(limits, snr, 'LineWidth', 4);
axis([0 1 0 30]);
str = {['Maximum PSNR: ', num2str(maxSNR)], ['Noise Threshold: ', num2str(limits(limitIndex))]};
text(0.5, 15, str);

title('PSNR vs. Noise Threshold');
xlabel('Noise Limit');
ylabel('PSNR');

set(findall(gcf,'type','axes'),'fontsize',25)
set(findall(gcf,'type','text'),'fontSize',25) 
fig = gcf;
fig.PaperPositionMode = 'auto';
print('pictures/ex8_2','-depsc','-r0');