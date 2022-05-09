close all;
clear;clc


%%% Estimating global common harmonic waves

work_dir = "/home/niki/Downloads/OCD_116ROIs_TimeSeries_Guorong_10_13/";
input_dir = strcat(work_dir, "out02_harmonics_hc");
output_dir = strcat(work_dir, "out03_global_com_harmonics");

out_file_name = 'CommonHarmonics.mat';

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end


load(strcat(input_dir, "Graph_all.mat")


save(strcat(output_dir, '/', out_file_name), "CommonHarmonics")

%fprintf('Estimating global common harmonic waves!\n');
%CommonHarmonics=Estimate_glob_com_harmonics(Graph,p);
%
%%% Constructing region-adaptive individual harmonic wavelets
%fprintf('Constructing region-adaptive individual harmonic wavelets!\n');
%Graph=Construct_individual_harmonic_wavelets(CommonHarmonics,Graph);
%
%%% Identifying region-adaptive common harmonic wavelets
%fprintf('Identifying region-adaptive common harmonic wavelets!\n');
%CommonHarWavelets=Identify_glob_com_har_wavelets(Graph);
%fprintf('Finished!\n')
