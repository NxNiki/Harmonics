%% load brain connectivity network

close all;
clear;clc


%% use hc as the training set to estimate harmonic wavelets:

input_dir = strcat("ocd_out01_correlation_matrix_hc");
output_dir = strcat("ocd_out02_harmonics");
files = dir(strcat(input_dir, '/CorrelationMatrix*.csv'));

out_file_name = 'harmonics_all.mat';

if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

%% construct graph:

Graph = struct;
GroupNum = 1;
p=55;% p is the number of eignvectors %55

for i = 1:size(files, 1)
    
    f = strcat(files(i).folder, filesep, files(i).name);
    temp = readmatrix(f);
    %temp = temp(2:end,:); % remove header in correlation matrix.
    
    subject_id = f(strfind(f, 'sub-'): strfind(f, '.txt')-1);
    
    % check for NaNs:
    if any(isnan(temp), 'all')
        fprintf('NaN values on matrix for subject: %d', subject_id)
        break
    end
    
    if ~isempty(temp)
        temp(temp<0.007)=0; % all correlations less than .007 are removed.
        v=sum(temp,2);

        if sum(v==0)==0
            %disp('compute harmonics...')
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
load(strcat(output_dir, '/', out_file_name), 'Graph')
fprintf('Estimating global common harmonic waves!\n');
CommonHarmonics=Estimate_glob_com_harmonics(Graph, p);
% save(strcat(output_dir, '/', out_file_name), 'CommonHarmonics', '-append')
fprintf('Done!\n')

%% Constructing region-adaptive individual harmonic wavelets
fprintf('Constructing region-adaptive individual harmonic wavelets!\n');
% load(strcat(output_dir, '/', out_file_name), 'CommonHarmonics', 'Graph')
Graph=Construct_individual_harmonic_wavelets(CommonHarmonics, Graph);
% save(strcat(output_dir, '/', out_file_name), 'Graph', '-append')
fprintf('Done!\n')

%% Identifying region-adaptive common harmonic wavelets
fprintf('Identifying region-adaptive common harmonic wavelets!\n');
% load(strcat(output_dir, '/', out_file_name), 'Graph')
CommonHarWavelets=Identify_glob_com_har_wavelets(Graph, CommonHarmonics);
save(strcat(output_dir, '/', out_file_name), 'CommonHarWavelets', 'CommonHarmonics', '-append')
fprintf('Finished!\n')


%% save results to txt files:
writematrix(CommonHarmonics, strcat(output_dir, '/CommonHarmonics.csv'))

for i = 1:length(CommonHarmonics)
    
    writematrix(CommonHarWavelets(i).Region_mask, strcat(output_dir, '/CommonHarWavelets_Region_Mask', sprintf('%03d', i), '.csv'))
    writematrix(CommonHarWavelets(i).Harmonics, strcat(output_dir, '/CommonHarWavelets_Harmonics', sprintf('%03d',i), '.csv'))
    
end



