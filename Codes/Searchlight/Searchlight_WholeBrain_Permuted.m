%% Voxel wise permutation-based analysis
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

p_perm = zeros(1, nVoxel);
tic
for iteVoxel = 1:2000
    actv_vector = zeros(1, length(subList));
    avg_val = searchlight_avg(iteVoxel);
    for iteSub = 1:length(subList)
        actv_vector(iteSub) = searchlight_bySub{iteSub}(iteVoxel);
    end
    p_perm(iteVoxel) = permute_significance(avg_val, actv_vector, 100);
end
toc


function permuted_p = permute_significance(val, vector, n_ite)
count = 0;
rng('shuffle');
for ite = 1:n_ite % Number of iterations for the permutation
    vector_perm = zeros(1, length(vector)); % Set the base
    for i = 1:length(vector)
        % rng('shuffle'); % Give another random seed
        rngseed = randi(2);
        switch rngseed
            case 1
                vector_perm(i) = vector(i);
            case 2
                vector_perm(i) = -vector(i); % In this case, change the sign of the original value;
        end
    end

    avg_perm = mean(vector_perm);
    if val > avg_perm 
        % Here, use "greater" because we're only looking for positively significant values (one-tailed)
        count = count + 1;
    else

    end

end
permuted_p = count/n_ite;

end
%% Contrast all subjects' voxel values against zero as a t-parametric contrast