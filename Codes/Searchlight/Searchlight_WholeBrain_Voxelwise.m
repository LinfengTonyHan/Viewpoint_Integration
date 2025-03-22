%% Voxel wise contrast against zero

nSub = 28;
exclusionList = [2, 8, 16, 22]; % Data exclusion

subList = 1:nSub;
subList = setdiff(subList, exclusionList);

pathname = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/outputs_3_MeanRemoved_independent';

mask_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight';
mask_fn = fullfile(mask_dir, 'wholeBrain.nii'); % Specify this: Perform searchlight analysis on which level

nVoxel = 228589;
searchlight_avg = zeros(1, nVoxel); % Create a zero-vector based on the mask dimension

for iteSub = 1:length(subList)
    if subList(iteSub) <= 9
        Subject = ['Subject00', num2str(subList((iteSub)))];
    elseif subList(iteSub) >= 10
        Subject = ['Subject0', num2str(subList((iteSub)))];
    end
    
    filename_searchlightMap = [pathname, '/s4', Subject, '_Street.nii'];

    searchlight_file = cosmo_fmri_dataset(filename_searchlightMap, 'mask', mask_fn);
    searchlight_bySub{iteSub} = searchlight_file.samples;
    searchlight_avg = searchlight_avg + searchlight_file.samples;
end

searchlight_avg = searchlight_avg/24;

searchlight_avg_struct = searchlight_file; % Create a new struct for the averaged map
searchlight_avg_struct.samples = searchlight_avg;

% t > 1.714 -> one-tailed p < 0.05 (uncorrected)
% t > 2.500 -> one-tailed p < 0.01 (uncorrected)
% t > 3.485 -> one-tailed p < 0.001 (uncorrected)

%% Contrast all subjects' voxel values against zero as a t-parametric contrast
for iteVoxel = 1:nVoxel
    Vec = zeros(1, 24);
    for iteSub = 1:length(subList)
        Vec(iteSub) = searchlight_bySub{iteSub}(iteVoxel);
    end
   
    [~, p, ~, stats] = ttest(Vec);
    p_voxel(iteVoxel) = p;
    t_voxel(iteVoxel) = stats.tstat;
end

t_map = searchlight_file;
t_map.samples = t_voxel;

cosmo_map2fmri(t_map, 'Parametric_t_map.nii');