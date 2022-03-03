% read OCD data:

work_dir = "/home/niki/Downloads/OCD_116ROIs_TimeSeries_Guorong_10_13/";
input_dir = "HC_ROI_signals";
output_dir = strcat(work_dir, "out01_correlation_matrix_hc");

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

files = dir(strcat(work_dir, input_dir, '/ROISignals*.mat'));

for i = 1:length(files)

    load(strcat(files(i).folder, '/', files(i).name))
    out_file_name = strcat('CorrelationMatrix', files(i).name(11:end))

    CorrMatrix = corr(ROISignals);
    save(strcat(output_dir, '/', out_file_name), 'CorrMatrix')

end
