% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {'/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/GLM_JRD_allRuns_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
