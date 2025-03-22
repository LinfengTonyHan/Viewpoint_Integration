clear;
% Normalized t-maps: Removing the cocktail mean

nSub = 28;
exclusionList = [2, 8, 16, 22];

subList = 1:nSub;
subList = setdiff(subList, exclusionList);

for iteSub = 1:length(subList)
    if subList(iteSub) <= 9
        Subject = ['Subject00', num2str(subList((iteSub)))];
    elseif subList(iteSub) >= 10
        Subject = ['Subject0', num2str(subList((iteSub)))];
    end
    inputdir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/JRD'];
    outputdir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/JRD'];
    
    fileIndex = 1:24; % 4 Runs
    
    for i = 1:length(fileIndex)
        
        indexStr = num2str(fileIndex(i));
        if length(indexStr) == 1
            inputfiles{i} = ['spmT_000', indexStr, '.nii'];
        elseif length(indexStr) == 2
            inputfiles{i} = ['spmT_00', indexStr, '.nii'];
        end
        
    end
    
    Tmean = calNormalizedBeta(inputdir, outputdir, inputfiles);
    TmeanInfo = niftiinfo([inputdir, '/spmT_0001.nii']);
    TmeanInfo.Filename = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/Others/mean_pattern.nii'];
    niftiwrite(Tmean, TmeanInfo.Filename, TmeanInfo);
end

