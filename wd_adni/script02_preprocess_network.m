close all;
clear;clc

%% load brain connectivity network

work_dir = "/home/niki/Downloads/OCD_116ROIs_TimeSeries_Guorong_10_13/";
input_dir = strcat(work_dir, "out01_correlation_matrix_hc");
output_dir = strcat(work_dir, "out02_harmonics_hc");
out_file_name = 'Graph_all.mat';

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end


files = dir(strcat(input_dir, '/CorrelationMatrix*.mat'));
Graph = struct;
GroupNum = 1;
p=55;% p is the number of eignvectors %55

for i = 1:length(files)

    load(strcat(files(i).folder, '/', files(i).name))
    % out_file_name = strcat('PreprocessCorrMat', files(i).name(18:end))
    subject_id = files(i).name(19:end-4)

    temp = CorrMatrix;
    if ~isempty(temp)
        temp(temp<0.007)=0;
        v=sum(temp,2);

        if sum(v==0)==0
            D=diag(v); 
            temp=D^-1*temp;
            Graph(GroupNum).W=(temp+temp')/2; %Adjacency matrix
            Graph(GroupNum).D=diag(sum(Graph(GroupNum).W,2)); % Degree matrix
            Graph(GroupNum).L=Graph(GroupNum).D-Graph(GroupNum).W;% Laplacian matrix
            [Phi_temp,value]=eig(Graph(GroupNum).L);

            if sum(Phi_temp(:,1))<0
                Phi_temp=-Phi_temp;
            end
            
            Graph(GroupNum).Phi{1}=Phi_temp(:,1:p);
            Graph(GroupNum).Eigenvalue=value(1:p,1:p);
            Graph(GroupNum).SubjectID=subject_id;
            %Graph(GroupNum).PTID=Data_profile{i,2};
            %Graph(GroupNum).VISCODE=Data_profile{i,4};
            %Graph(GroupNum).DX_bl=Data_profile{i,5};
            %Graph(GroupNum).Age=Data_profile{i,6};
            %Graph(GroupNum).Gender=Data_profile{i,7};

            GroupNum=GroupNum+1;
        end
    end
end

save(strcat(output_dir, '/', out_file_name), 'Graph')

%% Estimating global common harmonic waves
fprintf('Estimating global common harmonic waves!\n');
CommonHarmonics=Estimate_glob_com_harmonics(Graph,p);
fprintf('Done!\n')

%% Constructing region-adaptive individual harmonic wavelets
fprintf('Constructing region-adaptive individual harmonic wavelets!\n');
Graph=Construct_individual_harmonic_wavelets(CommonHarmonics,Graph);
fprintf('Done!\n')

%% Identifying region-adaptive common harmonic wavelets
fprintf('Identifying region-adaptive common harmonic wavelets!\n');
CommonHarWavelets=Identify_glob_com_har_wavelets(Graph);
fprintf('Finished!\n')
