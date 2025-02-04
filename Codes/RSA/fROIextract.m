function [fROImap, fROIindex, minTval, maxTval] = fROIextract(Subject, ROI, numVoxel, plotYN, writefileYN)
%% several ROIs: left and right brain separated (?)
% lPPA_Localizer, rPPA_Localizer, lRSC_Localizer, rRSC_Localizer,
% lOPA_Localizer
% lPPA, rPPA, lRSC, rRSC, lOPA, rOPA
% fROIindex: The indices for the top #numVoxel responding voxels
% The indices can be used directly for MVPAs
size_nii = 97 * 115 * 97;

% ROI: input in the format of "l/r + region + _ + task", e.g., 'lPPA_MEM'
ROI_section = ROI(1:4);
ROI_task = ROI((end-2):end);
% Well... note that niftiread.m is from the image processing toolbox
if strcmp(ROI_section, 'lPPA')
    if strcmp(ROI_task, 'LOC')
        ROI_filename = 'lPPA.nii';
    elseif strcmp(ROI_task, 'MEM')
        ROI_filename = 'lmPPA.nii';
    end

elseif strcmp(ROI_section, 'rPPA')
    if strcmp(ROI_task, 'LOC')
        ROI_filename = 'rPPA.nii';
    elseif strcmp(ROI_task, 'MEM')
        ROI_filename = 'rmPPA.nii';
    end

elseif strcmp(ROI_section, 'lRSC')
    if strcmp(ROI_task, 'LOC')
        ROI_filename = 'lRSC.nii';
    elseif strcmp(ROI_task, 'MEM')
        ROI_filename = 'lmRSC.nii';
    end

elseif strcmp(ROI_section, 'rRSC')
    if strcmp(ROI_task, 'LOC')
        ROI_filename = 'rRSC.nii';
    elseif strcmp(ROI_task, 'MEM')
        ROI_filename = 'rmRSC.nii';
    end

elseif strcmp(ROI_section, 'lOPA')
    if strcmp(ROI_task, 'LOC')
        ROI_filename = 'lOPA.nii';
    elseif strcmp(ROI_task, 'MEM')
        ROI_filename = 'lmOPA.nii';
    end

elseif strcmp(ROI_section, 'rOPA')
    if strcmp(ROI_task, 'LOC')
        ROI_filename = 'rOPA.nii';
    elseif strcmp(ROI_task, 'MEM')
        ROI_filename = 'rmOPA.nii';
    end

elseif strcmp(ROI_section, 'lEVC')
    ROI_filename = 'lEVC.nii'; 

elseif strcmp(ROI_section, 'rEVC')
    ROI_filename = 'rEVC.nii'; 

end

%% Selecting the contrast file.
% For EVC, select scrambled objects > null from the perceptual localizer
% For scene-selective regions, select scenes > faces or scenes > objects
% For scene-memory regions, select scenes > faces in the memory localizer
if strcmp(ROI_section, 'lEVC') || strcmp(ROI_section, 'rEVC')
    localizerT_dir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/Localizer'];
    t_map_filename = 'spmT_0004.nii'; % Fourth contrast: Scrambled Objects > None

elseif strcmp(ROI_section, 'lPPA') || strcmp(ROI_section, 'rPPA') || ...
        strcmp(ROI_section, 'lRSC') || strcmp(ROI_section, 'rRSC') || ...
        strcmp(ROI_section, 'lOPA') || strcmp(ROI_section, 'rOPA')

    if strcmp(ROI_task, 'LOC') % Perceptual Localizer Task
        localizerT_dir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/Localizer'];
        t_map_filename = 'spmT_0002.nii';  % To keep things consistent, I now use the scenes > faces contrast
    elseif strcmp(ROI_task, 'MEM') % Memory Localizer Task
        localizerT_dir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/LocalizerMemory'];
        t_map_filename = 'spmT_0002.nii'; % Scenes > Faces
        t_perception_map_filename = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/Localizer/spmT_0006.nii'];        
    end
end

scene_t_map = niftiread([localizerT_dir, '/', t_map_filename]);

%%% This might not be used (subtracting the perceptual selectivity, which makes it completely separated)
% if strcmp(ROI_task, 'MEM')
%     memory_map = scene_t_map;
%     memory_map = reshape(memory_map, 1, size(memory_map, 1) * size(memory_map, 2) * size(memory_map, 3));
%     memory_mean = nanmean(memory_map);
%     memory_std = nanstd(memory_map);
% 
%     scene_t_map_perception = niftiread(t_perception_map_filename);
%     perception_map = niftiread(t_perception_map_filename);
%     perception_map = reshape(perception_map, 1, size(perception_map, 1) * size(perception_map, 2) * size(perception_map, 3));
%     perception_mean = nanmean(perception_map);
%     perception_std = nanstd(perception_map);
%     scene_t_map = ((scene_t_map - memory_mean)/memory_std) - ((scene_t_map_perception - perception_mean)/perception_std);
% end
%%%

scene_t_map = double(scene_t_map); % Transform from single to double

ROI_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Anatomical_Parcels/scene_parcels';
% ROI_dir = '/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Anatomical_Parcels/scene_parcels_Steel';
ROI_mask = niftiread([ROI_dir, '/', ROI_filename]);
ROI_mask = double(ROI_mask); % Transform from uint8 to double
ROI_mask(ROI_mask <= 0) = nan; % All voxels outside the mask will be eliminated
ROI_mask(ROI_mask > 0) = 1; % Transform into 1

% fROI map = original t*map * valid voxels (in parcellation)
fROImap = scene_t_map .* ROI_mask;

% If EVC, there is a possibility that some values in the brain are 0
if strcmp(ROI_section, 'lEVC') || strcmp(ROI_section, 'rEVC')
    fROImap(fROImap == 0) = NaN;
end

%% Find the top responding # voxels
% First step: identify the threshold value -- 0.5 * (i(N) + i(N+1))
fROImap_reshape = reshape(fROImap, 1, size_nii);
fROImap_reshape(isnan(fROImap_reshape)) = []; % Clean out all the nans
fROImap_reshape = sort(fROImap_reshape, 'descend'); % Sort by order
threshold = (fROImap_reshape(numVoxel) + fROImap_reshape(numVoxel + 1)) * 0.5;

minTval = fROImap_reshape(numVoxel);
maxTval = fROImap_reshape(1);

fROIindex = find(fROImap > threshold); % Identify the top responding voxels
fROImap(fROImap < threshold) = 0;
fROImap(isnan(fROImap)) = 0; % Transform back to zeros
%% Next, plot out the distribution, if plotYN == 1
step = 20;
multipliedIndex = 100;

if plotYN
    scene_t_map_reshape = reshape(scene_t_map, 1, size_nii);
    fROImap_reshape = reshape(fROImap, 1, size_nii);
    scene_t_map_reshape(scene_t_map_reshape == 0) = [];
    fROImap_reshape(fROImap_reshape == 0) = [];
    fROImap_reshape = repmat(fROImap_reshape, 1, multipliedIndex);

    figure;
    histogram(scene_t_map_reshape, step, 'FaceColor', 'g');
    hold on
    histogram(fROImap_reshape, step, 'FaceColor', 'r');
end

if writefileYN
    % fROImap = uint8(fROImap);
    fROImapInfo = niftiinfo('/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Anatomical_Parcels/scene_parcels/lPPA.nii');
    fROImapInfo.Filename = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/fROIs/', Subject, '/', ROI, '.nii'];
    fROImapInfo.Datatype = 'double';
    niftiwrite(fROImap, fROImapInfo.Filename, fROImapInfo);
end