close all;
clear;clc

%% load brain connectivity network
p=55;% p is the number of eignvectors %55
Graph=Preprocess_network_data('/home/niki/Downloads/HarmonicData/DataTS.csv', ...
    '/home/niki/Downloads/HarmonicData/',p);

%% Estimating global common harmonic waves
fprintf('Estimating global common harmonic waves!\n');
CommonHarmonics=Estimate_glob_com_harmonics(Graph,p);

%% Constructing region-adaptive individual harmonic wavelets
fprintf('Constructing region-adaptive individual harmonic wavelets!\n');
Graph=Construct_individual_harmonic_wavelets(CommonHarmonics,Graph);

%% Identifying region-adaptive common harmonic wavelets
fprintf('Identifying region-adaptive common harmonic wavelets!\n');
CommonHarWavelets=Identify_glob_com_har_wavelets(Graph);
fprintf('Finished!\n')
