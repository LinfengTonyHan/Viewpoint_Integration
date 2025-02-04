%% This script is written for correlating the behavioral condition matrix and the neural RSM
close all;
Subject = 'Subject005';
nVoxel = 400;
genROIs(Subject, nVoxel/2);

ROI = 'lrRSC'; % l/r PPA, RSC or OPA + _PVT (Passive Viewing Task)
ROI_type = 'localizer'; % Localizer vs. task 

if ((strcmp(ROI, 'lrPPA') || strcmp(ROI, 'lrRSC') || strcmp(ROI, 'lrOPA')) || ...
        (strcmp(ROI, 'rPPA') || strcmp(ROI, 'rRSC') || strcmp(ROI, 'rOPA')) || ...
        (strcmp(ROI, 'lPPA') || strcmp(ROI, 'lRSC') || strcmp(ROI, 'lOPA'))) ... 
        && strcmp(ROI_type, 'task')
    ROI_PasViewing = [ROI, '_PVT']; % l/r PPA, RSC or OPA + _PVT (Passive Viewing Task)
    ROI_JRD = [ROI, '_JRD']; % l/rs PPA, RSC or OPA + _JRD
elseif ((strcmp(ROI, 'lrPPA') || strcmp(ROI, 'lrRSC') || strcmp(ROI, 'lrOPA')) || ...
        (strcmp(ROI, 'rPPA') || strcmp(ROI, 'rRSC') || strcmp(ROI, 'rOPA')) || ...
        (strcmp(ROI, 'lPPA') || strcmp(ROI, 'lRSC') || strcmp(ROI, 'lOPA'))) ... 
        && strcmp(ROI_type, 'localizer')
    ROI_PasViewing = [ROI, '_LOC']; % l/r PPA, RSC or OPA + _PVT (Passive Viewing Task)
    ROI_JRD = [ROI, '_LOC']; % l/rs PPA, RSC or OPA + _JRD
elseif strcmp(ROI, 'HPC') || strcmp(ROI, 'EVC')
    ROI_PasViewing = ROI;
    ROI_JRD = ROI;
end

%% Permutation settings
nIteration = 50;

%% Figure Settings
mainBarWidth = 0.5;

if strcmp(Subject, 'Subject001')
    % This sequence is for Subject001 only
    f_index = [2, 20, 17, 6, 7, 4, 24, 13, 5, 3, 14, 22, 23, 8, 11, 18, 15, 21, 19, 16, 10, 12, 9, 1];
elseif strcmp(Subject, 'Subject002')
    % This sequence is for Subject002 only
    f_index = [7, 20, 21, 6, 12, 24, 14, 22, 3, 10, 8, 15, 19, 11, 5, 4, 16, 1, 13, 2, 23, 17, 18, 9];
elseif strcmp(Subject, 'Subject003')
    f_index = [10, 22, 11, 3, 16, 12, 14, 24, 2, 18, 23, 1, 15, 5, 9, 19, 4, 20, 8, 6, 13, 7, 21, 17];
elseif strcmp(Subject, 'Subject004')
    f_index = [3, 6, 13, 18, 15, 24, 1, 14, 23, 11, 7, 20, 17, 9, 4, 12, 19, 21, 8, 16, 2, 10, 22, 5];
elseif strcmp(Subject, 'Subject005')
    f_index = [22, 18, 6, 19, 8, 1, 7, 23, 4, 9, 3, 15, 12, 24, 11, 20, 14, 17, 5, 16, 21, 2, 13, 10];
end
% Generate the neural RSM

[~, RSM_PasViewingD1, RDM_PasViewingD1] = genRDMs(Subject, 'PasViewingD1', ROI_PasViewing, 't', nVoxel);
[~, RSM_PasViewingD2, RDM_PasViewingD2] = genRDMs(Subject, 'PasViewingD2', ROI_PasViewing, 't', nVoxel);
[~, RSM_JRD, RDM_JRD] = genRDMs(Subject, 'JRD', ROI_JRD, 't', nVoxel);

checkMat(RSM_PasViewingD1);
checkMat(RSM_PasViewingD2);
checkMat(RSM_JRD);
figLocation = figure;
%% Neural RSM <-> Same street matrix
% Convert the same-street matrix to category-based order
cd('Behavioral_Matrices'); load('StreetMat_ByLoc.mat'); cd ..

% Because the same-street matrix was organized by location, it needs to be
% reordered by category
StreetMat = reorderMat(StreetMat, f_index);

[r_PV1, p_PV1] = corMat(StreetMat, RSM_PasViewingD1, 'Spearman'); 
r_PV1 = r2z(r_PV1);

[r_PV2, p_PV2] = corMat(StreetMat, RSM_PasViewingD2, 'Spearman'); 
r_PV2 = r2z(r_PV2);
r_diff = r_PV2 - r_PV1;

[r_JRD, p_JRD] = corMat(StreetMat, RSM_JRD, 'Spearman');
r_JRD = r2z(r_JRD);

% Load and save the results
cd('Analysis_Temporary');
load R.mat
% get the # voxels
R.nVoxel(end + 1) = nVoxel;
% same street passive viewing
R.SS(1, end + 1) = r_diff;
% same street JRD
R.SS(2, end) = r_JRD;
save R.mat R
cd ..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(1, 2, 1);
bar(1, [r_PV1, r_PV2], 'FaceColor',[200, 69, 64]/255, 'EdgeColor',[235, 122, 119]/255, 'LineWidth', 0.5);
hold on
bar(2, r_diff, 'BarWidth', mainBarWidth, 'FaceColor', [76, 87, 216]/255);
hold on
bar(3, r_JRD, 'BarWidth', mainBarWidth, 'FaceColor', [0, 185, 69]/255);
xticks(1:3);
ylim([-0.2, 0.2]);
xticklabels({'Day 1 & Day 2', 'Day 2 - Day 1', 'JRD'});
ylabel('Representational similarity (correlation between matrices)');
title(['Same-street coding in the ', ROI((end-2):end)]);
set(gca, 'FontSize', 15);

% Permutation analysis
pval.sameSt_PV = permMat2(RSM_PasViewingD1, RSM_PasViewingD2, StreetMat, 'Spearman', nIteration, 'greater');
pval.sameSt_JRD = permMat(RSM_JRD, StreetMat, 'Spearman', nIteration, 'greater');

% Put the permutation results on the figure
hold on
text(2, 0.15, ['p=', num2str(pval.sameSt_PV)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(3, 0.15, ['p=', num2str(pval.sameSt_JRD)], 'HorizontalAlignment', 'center', 'FontSize', 14);

%% Neural RSM <-> Same building matrix
% Convert the same-street matrix to category-based order
cd('Behavioral_Matrices'); load('BuildingMat_ByLoc.mat'); cd ..

% Because the same-building matrix was organized by location, it needs to be
% reordered by category
BuildingMat = reorderMat(BuildingMat, f_index);

[r_PV1, p_PV1] = corMat(BuildingMat, RSM_PasViewingD1, 'Spearman');
r_PV1 = r2z(r_PV1);

[r_PV2, p_PV2] = corMat(BuildingMat, RSM_PasViewingD2, 'Spearman');
r_PV2 = r2z(r_PV2);
r_diff = r_PV2 - r_PV1;

[r_JRD, p_JRD] = corMat(BuildingMat, RSM_JRD, 'Spearman');
r_JRD = r2z(r_JRD);

% Load and save the results
cd('Analysis_Temporary');
load R.mat
% get the # voxels
% R.nVoxel(end + 1) = nVoxel;
% same street passive viewing
R.SB(1, end + 1) = r_diff;
% same street JRD
R.SB(2, end) = r_JRD;
save R.mat R
cd ..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the results
subplot(1, 2, 2);
bar(1, [r_PV1, r_PV2], 'FaceColor',[200, 69, 64]/255, 'EdgeColor',[235, 122, 119]/255, 'LineWidth', 0.5);
hold on
bar(2, r_diff, 'BarWidth', mainBarWidth, 'FaceColor', [76, 87, 216]/255);
hold on
bar(3, r_JRD, 'BarWidth', mainBarWidth, 'FaceColor', [0, 185, 69]/255);
ylim([-0.2, 0.2]);
xticks(1:3);
xticklabels({'Day 1 & Day 2', 'Day 2 - Day 1', 'JRD'});
ylabel('Representational similarity (correlation between matrices)');
title(['Same-building coding in the ', ROI((end-2):end)]);
set(gca, 'FontSize', 15);

%%%%%%
% Permutation analysis - Same building
pval.sameBd_PV = permMat2(RSM_PasViewingD1, RSM_PasViewingD2, BuildingMat, 'Spearman', nIteration, 'greater');
pval.sameBd_JRD = permMat(RSM_JRD, BuildingMat, 'Spearman', nIteration, 'greater');
% Put the results on the figure
hold on
text(2, 0.15, ['p=', num2str(pval.sameBd_PV)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(3, 0.15, ['p=', num2str(pval.sameBd_JRD)], 'HorizontalAlignment', 'center', 'FontSize', 14);
%% Create a new figure
figureOthers = figure;

%% Neural RSM <-> Distance matrix
cd('Behavioral_Matrices'); load('DistanceMat_ByLoc.mat'); cd ..

% The distance matrix was organized by location, needs to be reordered
DistanceMat = reorderMat(DistanceMat, f_index);

[r_PV1, ~] = corMat(DistanceMat, RSM_PasViewingD1, 'Pearson');
r_PV1 = r2z(r_PV1);

[r_PV2, ~] = corMat(DistanceMat, RSM_PasViewingD2, 'Pearson');
r_PV2 = r2z(r_PV2);
r_diff = r_PV2 - r_PV1;

[r_JRD, ~] = corMat(DistanceMat, RSM_JRD, 'Pearson');
r_JRD = r2z(r_JRD);

% Load and save the results
cd('Analysis_Temporary');
load R.mat
% distance passive viewing
R.DIS(1, end + 1) = r_diff;
% distance JRD
R.DIS(2, end) = r_JRD;
save R.mat R
cd ..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2, 2, 1);
bar(1, [r_PV1, r_PV2], 'FaceColor',[200, 69, 64]/255, 'EdgeColor',[235, 122, 119]/255, 'LineWidth', 0.5);
hold on
bar(2, r_diff, 'BarWidth', mainBarWidth, 'FaceColor', [76, 87, 216]/255);
hold on
bar(3, r_JRD, 'BarWidth', mainBarWidth, 'FaceColor', [0, 185, 69]/255);
ylim([-0.2, 0.2]);
xticks(1:3);
xticklabels({'Day 1 & Day 2', 'Day 2 - Day 1', 'JRD'});
ylabel('Representational similarity');
title(['Distance coding in the ', ROI((end-2):end)]);
set(gca, 'FontSize', 15);

%%%%%%
% Permutation analysis - distance
pval.distance_PV = permMat2(RSM_PasViewingD1, RSM_PasViewingD2, DistanceMat, 'Pearson', nIteration, 'greater');
pval.distance_JRD = permMat(RSM_JRD, DistanceMat, 'Pearson', nIteration, 'greater');
% Put the results on the figure
hold on
text(2, 0.15, ['p=', num2str(pval.distance_PV)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(3, 0.15, ['p=', num2str(pval.distance_JRD)], 'HorizontalAlignment', 'center', 'FontSize', 14);
%% Neural RSM <-> Facing direction matrix
cd('Behavioral_Matrices'); load('DirectionMat_ByLoc.mat'); cd ..

% The direction matrix was organized by location, needs to be reordered
DirectionMat = reorderMat(DirectionMat, f_index);

[r_PV1, ~] = corMat(DirectionMat, RSM_PasViewingD1, 'Spearman');
r_PV1 = r2z(r_PV1);

[r_PV2, ~] = corMat(DirectionMat, RSM_PasViewingD2, 'Spearman');
r_PV2 = r2z(r_PV2);
r_diff = r_PV2 - r_PV1;

[r_JRD, ~] = corMat(DirectionMat, RSM_JRD, 'Spearman');
r_JRD = r2z(r_JRD);

% Load and save the results
cd('Analysis_Temporary');
load R.mat
% direction passive viewing
R.DIR(1, end + 1) = r_diff;
% distance JRD
R.DIR(2, end) = r_JRD;
save R.mat R
cd ..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2, 2, 2);
bar(1, [r_PV1, r_PV2], 'FaceColor',[200, 69, 64]/255, 'EdgeColor',[235, 122, 119]/255, 'LineWidth', 0.5);
hold on
bar(2, r_PV2 - r_PV1, 'BarWidth', mainBarWidth, 'FaceColor', [76, 87, 216]/255);
hold on
bar(3, r_JRD, 'BarWidth', mainBarWidth, 'FaceColor', [0, 185, 69]/255);
ylim([-0.2, 0.2]);
xticks(1:3);
xticklabels({'Day 1 & Day 2', 'Day 2 - Day 1', 'JRD'});
ylabel('Representational similarity');
title(['Facing direction coding in the ', ROI((end-2):end)]);
set(gca, 'FontSize', 15);

%%%%%%
% Permutation analysis - direction
pval.direction_PV = permMat2(RSM_PasViewingD1, RSM_PasViewingD2, DirectionMat, 'Pearson', nIteration, 'greater');
pval.direction_JRD = permMat(RSM_JRD, DirectionMat, 'Pearson', nIteration, 'greater');
% Put the results on the figure
hold on
text(2, 0.15, ['p=', num2str(pval.direction_PV)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(3, 0.15, ['p=', num2str(pval.direction_JRD)], 'HorizontalAlignment', 'center', 'FontSize', 14);

%% Neural RSM <-> Category matrix
% Create the category matrix manually
CategoryMat = zeros(24, 24);
for i = 1:12
    CategoryMat(i*2-1, i*2) = 1;
    CategoryMat(i*2, i*2-1) = 1;
end

for i = 1:24
    CategoryMat(i, i) = NaN;
end
checkMat(CategoryMat);

[r_PV1, ~] = corMat(CategoryMat, RSM_PasViewingD1, 'Spearman');
r_PV1 = r2z(r_PV1);

[r_PV2, ~] = corMat(CategoryMat, RSM_PasViewingD2, 'Spearman');
r_PV2 = r2z(r_PV2);
r_diff = r_PV2 - r_PV1;
r_avg = (r_PV1 + r_PV2)/2;

[r_JRD, ~] = corMat(CategoryMat, RSM_JRD, 'Spearman');
r_JRD = r2z(r_JRD);

% Load and save the results
cd('Analysis_Temporary');
load R.mat
% distance passive viewing
R.CAT(1, end + 1) = r_avg;
% distance JRD
R.CAT(2, end) = r_JRD;
save R.mat R
cd ..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2, 2, 3);
bar(1, [r_PV1, r_PV2], 'FaceColor',[200, 69, 64]/255, 'EdgeColor',[235, 122, 119]/255, 'LineWidth', 0.5);
hold on
bar(2, r_avg, 'BarWidth', mainBarWidth, 'FaceColor', [76, 87, 216]/255);
hold on
bar(3, r_JRD, 'BarWidth', mainBarWidth, 'FaceColor', [0, 185, 69]/255);
ylim([-0.2, 0.2]);
xticks(1:3);
xticklabels({'Day 1 & Day 2', 'Two-day average', 'JRD'});
ylabel('Representational similarity');
title(['Category coding in the ', ROI((end-2):end)]);
set(gca, 'FontSize', 15);

%%%%%%
% Permutation analysis - category
pval.category_PVD1 = permMat(RSM_PasViewingD1, CategoryMat, 'Spearman', nIteration, 'greater');
pval.category_PVD2 = permMat(RSM_PasViewingD2, CategoryMat, 'Spearman', nIteration, 'greater');
pval.category_JRD = permMat(RSM_JRD, CategoryMat, 'Spearman', nIteration, 'greater');
% Put the results on the figure
hold on
text(0.8, 0.17, ['p=', num2str(pval.category_PVD1)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(1.2, 0.14, ['p=', num2str(pval.category_PVD2)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(3, 0.15, ['p=', num2str(pval.category_JRD)], 'HorizontalAlignment', 'center', 'FontSize', 14);

%% Neural RSM <-> GIST dissimilarity
cd('Behavioral_Matrices'); load('imgDM_GIST.mat'); cd ..

[r_PV1, ~] = corMat(imgDM_GIST, RSM_PasViewingD1, 'Pearson');
r_PV1 = r2z(r_PV1);

[r_PV2, ~] = corMat(imgDM_GIST, RSM_PasViewingD2, 'Pearson');
r_PV2 = r2z(r_PV2);
r_avg = (r_PV1 + r_PV2)/2;

[r_JRD, ~] = corMat(imgDM_GIST, RSM_JRD, 'Pearson');

% Load and save the results
cd('Analysis_Temporary');
load R.mat
% distance passive viewing
R.VIS(1, end + 1) = r_avg;
% distance JRD
R.VIS(2, end) = r_JRD;
save R.mat R
cd ..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2, 2, 4);
bar(1, [r_PV1, r_PV2], 'FaceColor',[200, 69, 64]/255, 'EdgeColor',[235, 122, 119]/255, 'LineWidth', 0.5);
hold on
bar(2, r_avg, 'BarWidth', mainBarWidth, 'FaceColor', [76, 87, 216]/255);
hold on
bar(3, r_JRD, 'BarWidth', mainBarWidth, 'FaceColor', [0, 185, 69]/255);
ylim([-0.2, 0.2]);
xticks(1:3);
xticklabels({'Day 1 & Day 2', 'Two-day average', 'JRD'});
ylabel('Representational dissimilarity');
title(['GIST visual similarity coding in the ', ROI((end-2):end)]);
set(gca, 'FontSize', 15);

% Permutation analysis - GIST
pval.gist_PVD1 = permMat(RSM_PasViewingD1, imgDM_GIST, 'Pearson', nIteration, 'smaller');
pval.gist_PVD2 = permMat(RSM_PasViewingD2, imgDM_GIST, 'Pearson', nIteration, 'smaller');
pval.gist_JRD = permMat(RSM_JRD, imgDM_GIST, 'Pearson', nIteration, 'smaller');
% Put the results on the figure
hold on
text(0.8, 0.17, ['p=', num2str(pval.gist_PVD1)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(1.2, 0.14, ['p=', num2str(pval.gist_PVD2)], 'HorizontalAlignment', 'center', 'FontSize', 14);
text(3, 0.15, ['p=', num2str(pval.gist_JRD)], 'HorizontalAlignment', 'center', 'FontSize', 14);