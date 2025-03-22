function tRange = genROIs(Subject, nVoxel)
%% This script is for generating the ROIs for a specific subject
% Subject = 'Subject002';
% nVoxel = 200;
%% PPA
[~, ~, lPPAt1, lPPAt2] = fROIextract(Subject, 'lPPA_LOC', nVoxel, 0, 1);
[~, ~, rPPAt1, rPPAt2] = fROIextract(Subject, 'rPPA_LOC', nVoxel, 0, 1);
tRange(1, 1:4) = [lPPAt1, rPPAt1, lPPAt2, rPPAt2];
fROIcombine(Subject, 'PPA_LOC', nVoxel, 1); % This should be equivalent to the sum of the two lines above

[~, ~, lPPAt1, lPPAt2] = fROIextract(Subject, 'lPPA_MEM', nVoxel, 0, 1);
[~, ~, rPPAt1, rPPAt2] = fROIextract(Subject, 'rPPA_MEM', nVoxel, 0, 1);
tRange(4, 1:4) = [lPPAt1, rPPAt1, lPPAt2, rPPAt2];
fROIcombine(Subject, 'PPA_MEM', nVoxel, 1); % This should be equivalent to the sum of the two lines above

%% RSC
[~, ~, lRSCt1, lRSCt2] = fROIextract(Subject, 'lRSC_LOC', nVoxel, 0, 1);
[~, ~, rRSCt1, rRSCt2] = fROIextract(Subject, 'rRSC_LOC', nVoxel, 0, 1);
fROIcombine(Subject, 'RSC_LOC', nVoxel, 1); % This should be equivalent to the sum of the two lines above
tRange(2, 1:4) = [lRSCt1, rRSCt1, lRSCt2, rRSCt2];

[~, ~, lRSCt1, lRSCt2] = fROIextract(Subject, 'lRSC_MEM', nVoxel, 0, 1);
[~, ~, rRSCt1, rRSCt2] = fROIextract(Subject, 'rRSC_MEM', nVoxel, 0, 1);
fROIcombine(Subject, 'RSC_MEM', nVoxel, 1); % This should be equivalent to the sum of the two lines above
tRange(5, 1:4) = [lRSCt1, rRSCt1, lRSCt2, rRSCt2];

%% OPA
[~, ~, lOPAt1, lOPAt2] = fROIextract(Subject, 'lOPA_LOC', nVoxel, 0, 1);
[~, ~, rOPAt1, rOPAt2] = fROIextract(Subject, 'rOPA_LOC', nVoxel, 0, 1);
fROIcombine(Subject, 'OPA_LOC', nVoxel, 1); % This should be equivalent to the sum of the two lines above
tRange(3, 1:4) = [lOPAt1, rOPAt1, lOPAt2, rOPAt2];

[~, ~, lOPAt1, lOPAt2] = fROIextract(Subject, 'lOPA_MEM', nVoxel, 0, 1);
[~, ~, rOPAt1, rOPAt2] = fROIextract(Subject, 'rOPA_MEM', nVoxel, 0, 1);
fROIcombine(Subject, 'OPA_MEM', nVoxel, 1); % This should be equivalent to the sum of the two lines above
tRange(6, 1:4) = [lOPAt1, rOPAt1, lOPAt2, rOPAt2];

%% EVC
[~, ~, lEVCt1, lEVCt2] = fROIextract(Subject, 'lEVC', nVoxel, 0, 1);
[~, ~, rEVCt1, rEVCt2] = fROIextract(Subject, 'rEVC', nVoxel, 0, 1);
fROIcombine(Subject, 'EVC', nVoxel, 1);

disp(tRange);