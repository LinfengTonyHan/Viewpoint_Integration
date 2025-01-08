function [betas, RSM, RDM] = genRDMs(Subject, Session, ROI, ImageType, betaImageSeries)
%% Look at the EPI data while masking the ROIs
% function [betas, RSM, RDM] = genRDMs(Subject, Session, ROI, ImageType, nVoxel, betaImageSeries)
% betaImageSeries, if ImageType == 'beta', then this is required, usually 1:24, 32:55, etc.
% Subject: 'Subject0##'
% Session: 'JRD#'; a total of 4 runs
% ROI: 'lrXXX_LOC', 'lrXXX_MEM', 'lrEVC'

nCond = 24;
patt_norm = 0; % No longer in use; If 1, then each pattern vector is normalized by z-scoring
%% ROI file
%% Individually defined ROIs (standard pipeline used previously in the lab)
% Bilateral
mask_lrPPA_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lrPPA_LOC.nii']);
mask_lrRSC_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lrRSC_LOC.nii']);
mask_lrOPA_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lrOPA_LOC.nii']);

%% Group defined ROIs (for the control analysis)
% mask_lrPPA_LOC = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_ScenePerceptionGroup/Generated_ROIs/lrPPA_PCP_Group_Parcel.nii');
% mask_lrRSC_LOC = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_ScenePerceptionGroup/Generated_ROIs/lrRSC_PCP_Group_Parcel.nii');
% mask_lrOPA_LOC = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_ScenePerceptionGroup/Generated_ROIs/lrOPA_PCP_Group_Parcel.nii');

%% Scene-memory parcels
% Defined by individual subject (obselete)
% mask_lrPPA_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lrPPA_MEM.nii']);
% mask_lrRSC_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lrRSC_MEM.nii']);
% mask_lrOPA_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lrOPA_MEM.nii']);

% Defined by the same threshold (but different number of voxels)
% mask_lrPPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/mPPA.nii');
% mask_lrRSC_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/mRSC.nii');
% mask_lrOPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/mOPA.nii');

% Defined by the same number of voxels (200, group-wise mask)
mask_lrPPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemoryGroup/Generated_ROIs_200/lrPPA_MEM_Group.nii');
mask_lrRSC_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemoryGroup/Generated_ROIs_200/lrRSC_MEM_Group.nii');
mask_lrOPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemoryGroup/Generated_ROIs_200/lrOPA_MEM_Group.nii');

% SPL: no "MEM" needed
mask_lrSPL = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemoryGroup/Generated_ROIs_200/lrSPL_MEM_Group.nii');
mask_lrEVC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lrEVC.nii']);

mask_rPPA_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/rPPA_LOC.nii']);
mask_rRSC_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/rRSC_LOC.nii']);
mask_rOPA_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/rOPA_LOC.nii']);

% mask_rPPA_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/rPPA_MEM.nii']);
% mask_rRSC_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/rRSC_MEM.nii']);
% mask_rOPA_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/rOPA_MEM.nii']);

mask_rPPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/rmPPA.nii');
mask_rRSC_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/rmRSC.nii');
mask_rOPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/rmOPA.nii');

mask_rEVC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/rEVC.nii']);

mask_lPPA_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lPPA_LOC.nii']);
mask_lRSC_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lRSC_LOC.nii']);
mask_lOPA_LOC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lOPA_LOC.nii']);

% mask_lPPA_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lPPA_MEM.nii']);
% mask_lRSC_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lRSC_MEM.nii']);
% mask_lOPA_MEM = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lOPA_MEM.nii']);

mask_lPPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/lmPPA.nii');
mask_lRSC_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/lmRSC.nii');
mask_lOPA_MEM = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/Memory_Parcels/lmOPA.nii');

mask_lEVC = niftiread(['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lEVC.nii']);

% mask_lSPL = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/l_mSPL_mask.nii');
% mask_rSPL = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/r_mSPL_mask.nii');
% mask_lrSPL = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Scripts/Localizer_SceneMemory/Generated_Parcels/lrSPL.nii');

% Defined by generic anatomical masks (hippocampus, anterior hippocampus)
mask_HPC = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/aROIs/HPC_bilat.nii'); % hippocampus (bilateral)
mask_aHPC = niftiread('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/aROIs/aHPC_bilat.nii'); % anterior hippocampus (bilateral)

mask = eval(['mask_', ROI]);
% mask_length = size(mask, 1) * size(mask, 2) * size(mask, 3);
% mask_reshape = reshape(mask, [1, mask_length]);
% mask_reshape(isnan(mask_reshape)) = []; % Clear up all the nans
% mask_reshape = sort(mask_reshape, 'descend');
% % Select the top n voxels
% avg = 0.5 * mask_reshape(nVoxel) + 0.5 * mask_reshape(nVoxel + 1);

%% The easier way: all the masks were pre-defined, in binary files for each individual
ROIindex = find(mask ~= 0); % Some participants have smaller than 0 t-values for contrasts 

filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/', Session];
filenames = cell(1, nCond);

% beta maps
if strcmp(ImageType, 'beta')
    for iteName = betaImageSeries
        if iteName <= 9
            filenames{iteName} = ['beta_000', num2str(iteName), '.nii'];
        elseif iteName >= 10 && iteName <= 99
            filenames{iteName} = ['beta_00', num2str(iteName), '.nii'];
        elseif iteName >= 100
            filenames{iteName} = ['beta_0', num2str(iteName), '.nii'];
        end
    end
    
    for i = 1:nCond
        EPIdata = niftiread([filedir, '/', filenames{betaImageSeries(i)}]);
        betas{i} = EPIdata(ROIindex);
        
        % Normalizing within each pattern
        if patt_norm
        betas{i} = zscore(betas{i});
        end
    end
    
% t maps (currently used for ROI/searchlight analyses)
% t maps do not need betaImageSeries (all concatenated)
elseif strcmp(ImageType, 't')
    for iteName = 1:nCond
        if iteName <= 9
            filenames{iteName} = ['spmT_000', num2str(iteName), '.nii'];
        elseif iteName >= 10
            filenames{iteName} = ['spmT_00', num2str(iteName), '.nii'];
        end
    end
    
    for i = 1:nCond
        EPIdata = niftiread([filedir, '/', filenames{i}]);
        betas{i} = EPIdata(ROIindex);
        
        % Normalizing within each pattern (zscoring, typically not needed)
        if patt_norm
            betas{i} = zscore(betas{i});
        end
    end
end
%% Calculate the same vs. different image correlations: correlation
for i = 1:nCond
    for j = 1:nCond
        corrValue = corr(betas{i}, betas{j}, 'rows', 'complete', 'Type', 'Pearson');
        corrValue = r2z(corrValue); % Fisher's z transformation
        RSM(i, j) = corrValue;
    end
    RSM(i, i) = NaN; % Self correlation: NaN
end

%% Using Euclidean distances
for i = 1:nCond
    for j = 1:nCond
        distValue = EucDist(betas{i}, betas{j});
        RDM(i, j) = distValue;
    end
    RDM(i, i) = NaN;
end

end