function [fROImap, fROIindex] = fROIcombine(Subject, ROI, numVoxel, writefileYN)
%% This function is written for combining the ROIs in the left and right hemispheres

% Step 1, get the left and right ROIs
[left_ROI, left_Index] = fROIextract(Subject, ['l', ROI], numVoxel, 0, 0); % Do not write the file!
[right_ROI, right_Index] = fROIextract(Subject, ['r', ROI], numVoxel, 0, 0); % Do not write the file!

fROImap = left_ROI + right_ROI;
fROIindex = [left_Index, right_Index];

if writefileYN
    fROImapInfo = niftiinfo('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Anatomical_Parcels/scene_parcels/lPPA.nii');
    fROImapInfo.Filename = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/lr', ROI, '.nii'];
    fROImapInfo.Datatype = 'double';
    niftiwrite(fROImap, fROImapInfo.Filename, fROImapInfo);
end