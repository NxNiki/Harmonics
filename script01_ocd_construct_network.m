% read OCD data:

% correlation matrix is created with python script and results are saved as .txt files.
% this script is not necessary.
% xin Mar 29 2022.

input_dir = "/home/xin/Downloads/OCD_116ROIs_TimeSeries_Guorong_10_13/HC_ROI_signals";
output_dir = "/home/xin/Downloads/BrainImaging_UNC/ocd_out01_correlation_matrix_hc";

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

files = dir(strcat(input_dir, '/ROISignals*.mat'));

for i = 1:length(files)
    fprintf([files(i).name, '\n'])

    load(strcat(files(i).folder, '/', files(i).name))
    out_file_name = strcat('CorrelationMatrix', files(i).name(11:end));

    CorrMatrix = corr(ROISignals);
    save(strcat(output_dir, '/', out_file_name), 'CorrMatrix')

end
