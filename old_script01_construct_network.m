% read correlation matrix of rsfMRI data from ADNI:
% correlation matrix is created with python script and results are saved as .txt files.
% this script is not necessary.
% xin Mar 29 2022.


work_dir = "/home/niki/Downloads/Harmonics/"
input_dir = "/home/niki/Downloads/BrainImaging_UNC/out05_adni_corr_matrix1/";
output_dir = strcat(work_dir, "adni_out01_correlation_matrix_hc");

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

files = dir(strcat(work_dir, input_dir, '/corr_matrix_power264_*.txt'));

for i = 1:length(files)

    
    CorrMatrix = corr(ROISignals);
    save(strcat(output_dir, '/', out_file_name), 'CorrMatrix')

end
