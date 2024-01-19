%%% The Decline of the Labor Share: New Empirical Evidence
%%% Authors: Drago Bergholt, Francesco Furlanetto and Nicolò Maffei-Faccioli
%%% Historical decomposition - Figure 7

clear;
close all;
clc;

addpath('Data')
addpath('Functions')

%% Historical decomposition - Figure 7:

% Load the draw closest to the median:

load 'mediantargetdraw.mat' 

Histdec; % compute the historical decomposition based on the median-target draw