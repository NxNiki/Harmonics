% read OCD data:

% correlation matrix is created with python script and results are saved as .txt files.
% this script is not necessary for adni data.
% xin Mar 29 2022.

% we still need this cor ocd data as the input are .mat files.
% xin Apr 25 2022.

% input_dir = "/home/xin/Downloads/OCD_116ROIs_TimeSeries_Guorong_10_13/HC_ROI_signals";
% output_dir = "/home/xin/Downloads/Harmonics/ocd_out01_correlation_matrix_hc";

input_dir = "/home/xin/Downloads/OCD_116ROIs_TimeSeries_Guorong_10_13/OCD_ROI_signals";
output_dir = "/home/xin/Downloads/Harmonics/ocd_out01_correlation_matrix_ocd";

% input_dir = "/home/xin/Downloads/OCD_116ROIs_TimeSeries_Guorong_10_13/OCDS_ROI_signals";
% output_dir = "/home/xin/Downloads/Harmonics/ocd_out01_correlation_matrix_ocds";


if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

files = dir(strcat(input_dir, '/ROISignals*.mat'));

for i = 1:length(files)
    
    fprintf([files(i).name, '\n'])

    % load .mat file.
    load(strcat(files(i).folder, '/', files(i).name))

%     CorrMatrix = corr(ROISignals);

    % remove rows with nan:
    nan_row = any(isnan(ROISignals), 2);
    CorrMatrix = corrcoef(ROISignals(~nan_row,:));
    
    
    out_file_name = strcat('ROISignals', files(i).name(11:end));
    writematrix(ROISignals(~nan_row,:), strcat(output_dir, '/', strrep(out_file_name, '.mat', '.csv')))
    % save correlation matrix as .csv file:
    out_file_name = strcat('CorrelationMatrix', files(i).name(11:end));
    writematrix(CorrMatrix, strcat(output_dir, '/', strrep(out_file_name, '.mat', '.csv')))
    %save(strcat(output_dir, '/', out_file_name), 'CorrMatrix')

end
