%% For running Monte Carlo statistics of searchlight results: Same-panorama integration
nSub = 24;
clusterStat = 'tfce';
niteration = 1000;

clearvars -except nSub clusterStat niteration;

data_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/outputs_3_MeanPreserved_independent';
data_fn = fullfile(data_dir, 'Street_AllSub.nii');

mask_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight';
mask_fn = fullfile(mask_dir, 'wholeBrain.nii');

ds = cosmo_fmri_dataset(data_fn, 'mask', mask_fn);
ds.samples = r2z(ds.samples);
ds.sa.targets = ones(nSub, 1); % number of subjects, one-sample t-test against zero
ds.sa.chunks = (1:nSub)';

nbrhood = cosmo_cluster_neighborhood(ds, 'fmri', 3);

opt = struct();
opt.cluster_stat = clusterStat;
opt.niter = niteration;
opt.h0_mean = 0;
opt.progress = true;
% opt.p_uncorrected = 0.001;

%% Run monte carlo statistics
z = cosmo_montecarlo_cluster_stat(ds, nbrhood, opt);

output_path = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/searchlight_grouplevel/MeanPreserved_3_independent';
output_fn = fullfile(output_path, 'z_Street_AllSub.nii');
cosmo_map2fmri(z, output_fn);

%% For running Monte Carlo statistics of searchlight results: Same-landmark integration
clearvars -except nSub clusterStat niteration;

data_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/outputs_3_MeanPreserved_independent';
data_fn = fullfile(data_dir, 'Building_AllSub.nii');

mask_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight';
mask_fn = fullfile(mask_dir, 'wholeBrain.nii');

ds = cosmo_fmri_dataset(data_fn, 'mask', mask_fn);
ds.samples = r2z(ds.samples);
ds.sa.targets = ones(nSub, 1); % number of subjects, one-sample t-test against zero
ds.sa.chunks = (1:nSub)';

nbrhood = cosmo_cluster_neighborhood(ds, 'fmri', 3);

opt = struct();
opt.cluster_stat = clusterStat;
opt.niter = niteration;
opt.h0_mean = 0;
opt.progress = true;
% opt.p_uncorrected = 0.001;

%% Run monte carlo statistics
z = cosmo_montecarlo_cluster_stat(ds, nbrhood, opt);

output_path = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/searchlight_grouplevel/MeanPreserved_3_independent';
output_fn = fullfile(output_path, 'z_Building_AllSub.nii');
cosmo_map2fmri(z, output_fn);

%% For running Monte Carlo statistics of searchlight results: Same-landmark integration
clearvars -except nSub clusterStat niteration;

data_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/outputs_3_MeanPreserved_independent';
data_fn = fullfile(data_dir, 'Category_AllSub.nii');

mask_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight';
mask_fn = fullfile(mask_dir, 'wholeBrain.nii');

ds = cosmo_fmri_dataset(data_fn, 'mask', mask_fn);
ds.samples = r2z(ds.samples);
ds.sa.targets = ones(nSub, 1); % number of subjects, one-sample t-test against zero
ds.sa.chunks = (1:nSub)';

nbrhood = cosmo_cluster_neighborhood(ds, 'fmri', 3);

opt = struct();
opt.cluster_stat = clusterStat;
opt.niter = niteration;
opt.h0_mean = 0;
opt.progress = true;
% opt.p_uncorrected = 0.001;

%% Run monte carlo statistics
z = cosmo_montecarlo_cluster_stat(ds, nbrhood, opt);

output_path = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Analysis_Searchlight/searchlight_grouplevel/MeanPreserved_3_independent';
output_fn = fullfile(output_path, 'z_Category_AllSub.nii');
cosmo_map2fmri(z, output_fn);

function f_z = r2z(s_r)
f_z = 0.5 * log(1 + s_r) - 0.5 * log(1 - s_r);
end