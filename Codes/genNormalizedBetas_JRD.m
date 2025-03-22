clear;

nSub = 21;
exclusionList = [2, 8];

subList = 1:nSub;
subList = setdiff(subList, exclusionList);

% Normalize all the betas
for iteSub = 1:length(subList)
    if subList(iteSub) <= 9
        Subject = ['Subject00', num2str(subList((iteSub)))];
    elseif subList(iteSub) >= 10
        Subject = ['Subject0', num2str(subList((iteSub)))];
    end

    inputdir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/JRD'];
    outputdir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/JRD'];
    
    % 7 nuisance regressors here, 24 + 7 = 31
    fileIndex = [1:24, (1:24) + 31, (1:24) + 62, (1:24) + 93]; % 4 Runs

    for i = 1:length(fileIndex)
        indexStr = num2str(fileIndex(i));
        if length(indexStr) == 1
            inputfiles{i} = ['beta_000', indexStr, '.nii'];
        elseif length(indexStr) == 2
            inputfiles{i} = ['beta_00', indexStr, '.nii'];
        end
    end

    betamean = calNormalizedBeta(inputdir, outputdir, inputfiles);
    betameanInfo = niftiinfo([inputdir, '/beta_0001.nii']);
    betameanInfo.Filename = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/Others/betamean_JRD_Kernel3.nii'];
    niftiwrite(betamean, betameanInfo.Filename, betameanInfo);
end