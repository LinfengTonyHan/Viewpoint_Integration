%% Searchlight script for distance coding, using CosMoMVPA
nSub = 28;
exclusionList = [2, 8, 16, 22];
subList = setdiff(1:nSub, exclusionList);

% Single subject testing
distanceMap = cell(1, length(subList));

Type = 'radius'; % 'radius' or 'count'
radius = 3;
Method = 'independent'; % Interaction vs. independent, doesn't matter in this script

for iteSub = 1:length(subList)
    if subList(iteSub) <= 9
        Subject = ['Subject00', num2str(subList((iteSub)))];
    elseif subList(iteSub) >= 10
        Subject = ['Subject0', num2str(subList((iteSub)))];
    end

    distanceMap{iteSub} = runSearchlight(Subject, Type, radius, Method);
end

%% Main searchlight function using CosMoMVPA
function mapRSM = runSearchlight(Subject, Type, Param, Method)
%% Type: 'radius' or 'count'
%% Param: parameter for the corresponding searchlight defining method. Radius-3/4 Count-100/200
%% Method: 'interaction' or 'independent'; if 'interaction', then building effect is modeled as building MINUS street

close all; % Close all the figures for the previous particpant
disp(['Running searchlight analysis for ', Subject, ' in condition: ', 'Distance']);

mask_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight';
mask_fn = fullfile(mask_dir, 'wholeBrain.nii'); % Specify this: Perform searchlight analysis on which level

data_dir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/JRD'];
data_fn = fullfile(data_dir, 'JRD_24conds.nii');
% Note: JRD_24conds.nii - cocktail mean removed
% Note: JRD_24conds_MeanPreserved.nii - cocktail mean preserved

ds = cosmo_fmri_dataset(data_fn, 'mask', mask_fn, 'targets', 1:24, 'chunks', 1);

labels = cell(1, 24);
for i = 1:24
    labels{i} = ['facade', num2str(i)];
end

ds.sa.labels = labels';
clearvars labels i;

cosmo_check_dataset(ds);

% print dataset
fprintf('Dataset input:\n');
cosmo_disp(ds);

%% Begin the searchlight analysis
% Define neighborhood for each feature
fprintf('Defining neighborhood for each feature\n');
nbrhood = cosmo_spherical_neighborhood(ds, Type, Param);

fprintf('Searchlight neighborhood definition:\n');
cosmo_disp(nbrhood);

%% RSM-based searchlight
nsamples = size(ds.samples, 1);

% First, generate the street matrix and building matrix, based on each
% subject's unique facade sequence
load facadeSequenceAllSub.mat
subIndex_1 = str2double(Subject(end));
subIndex_2 = str2double(Subject(end - 1));
subIndex = subIndex_1 + 10 * subIndex_2;

f_index = facadeSequenceAllSub(subIndex, :);

behav_matrix_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Behavioral_Matrices';

% Distance matrix
distance_temp = load([behav_matrix_dir, '/DistanceMat_ByLoc_Restricted.mat']);
distanceMat = reorderMat(distance_temp.DistanceMat, f_index);
target_dsm = zeros(24, 24);

% Remember: dsm is the dissimilarity matrix, so you have to reverse code it
%% Not sure if this is the right way to do so... 
if strcmp(Method, 'interaction')
    target_dsm = distanceMat;
elseif strcmp(Method, 'independent')
    target_dsm = 1 - distanceMat;
end
% Should I set this?
% target_dsm(isnan(target_dsm)) = 0;

% set measure
measure = @cosmo_target_dsm_corr_measure;
measure_args = struct();
measure_args.target_dsm = target_dsm;

if cosmo_check_external('@stats', false)
    measure_args.type = 'Spearman';
else
    measure_args.type = 'Pearson';
    fprintf('Matlab stats toolbox not present, using %s correlation\n', measure_args.type)
end

% % print measure and arguments
% fprintf('Searchlight measure:\n');
% cosmo_disp(measure);
% fprintf('Searchlight measure arguments:\n');
% cosmo_disp(measure_args);

% Run searchlight
mapRSM = cosmo_searchlight(ds, nbrhood, measure, measure_args);

%% show and store results
% cosmo_plotices(mapRSM);
output_path = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/outputs_3_MeanRemoved_independent';
output_fn = fullfile(output_path, [Subject, '_', 'Distance', '.nii']);
cosmo_map2fmri(mapRSM, output_fn);
end