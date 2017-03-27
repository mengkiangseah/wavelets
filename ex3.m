%% Preparation
clear;
close all;
clc;

%% Preamble from the start
% Some constants
T = 64;
maxT = 32;
signalLength = T * maxT;

%% Load
load('tau.mat');

%% Solve
K = 2;
% Check out function script to learn more. 
[h, tk, ak] = annihilatingFilter(tau', K);

% Display!
disp('H');
disp(h);

disp('Tk');
disp(tk);

disp('Ak');
disp(ak);
