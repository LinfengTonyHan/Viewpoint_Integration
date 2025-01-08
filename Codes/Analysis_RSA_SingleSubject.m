function [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, ROI, ROI_type, Matrix)
%% This script is written for correlating the behavioral condition matrix and the neural RSM/RDM for a single subject
% function [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = Analysis_RSA_SingleSubject(Subject, Session, ROI, ROI_type, nVoxel, Matrix)

% ROI: 'lrPPA', 'lrRSC', 'lrOPA', 'lrEVC'

% ROI_type: 'perception' or 'memory', only applied to the scene regions

% nVoxel: The total number of voxels (bilaterally, usually should be 400)

% Matrix: 'RSM' or 'RDM', deciding whether RSMs or RDMs will be used

close all;

if ((strcmp(ROI, 'lrPPA') || strcmp(ROI, 'lrRSC') || strcmp(ROI, 'lrOPA')) || ...
        (strcmp(ROI, 'rPPA') || strcmp(ROI, 'rRSC') || strcmp(ROI, 'rOPA')) || ...
        (strcmp(ROI, 'lPPA') || strcmp(ROI, 'lRSC') || strcmp(ROI, 'lOPA'))) ... 
        && strcmp(ROI_type, 'perception')
    ROI_JRD = [ROI, '_LOC']; % l/rs PPA, RSC or OPA + _JRD
elseif ((strcmp(ROI, 'lrPPA') || strcmp(ROI, 'lrRSC') || strcmp(ROI, 'lrOPA')) || ...
        (strcmp(ROI, 'rPPA') || strcmp(ROI, 'rRSC') || strcmp(ROI, 'rOPA')) || ...
        (strcmp(ROI, 'lPPA') || strcmp(ROI, 'lRSC') || strcmp(ROI, 'lOPA'))) ... 
        && strcmp(ROI_type, 'memory')
    ROI_JRD = [ROI, '_MEM']; % l/rs PPA, RSC or OPA + _JRD

    % For the following ROIs, no perception/memory distinction
    % HPC/aHPC anatomical masks derived from freesurfer
elseif strcmp(ROI, 'HPC') || strcmp(ROI, 'aHPC') || strcmp(ROI, 'lrEVC') || strcmp(ROI, 'lSPL') || strcmp(ROI, 'rSPL') || strcmp(ROI, 'lrSPL')
    ROI_JRD = ROI;
end

%% Generate the representational (dis)similarities
load facadeSequenceAllSub.mat
subIndex_1 = str2double(Subject(end));
subIndex_2 = str2double(Subject(end - 1));
subIndex = subIndex_1 + 10 * subIndex_2;

f_index = facadeSequenceAllSub(subIndex, :);
% Generate the neural RSM

[~, RSM_JRD, RDM_JRD] = genRDMs(Subject, 'JRD', ROI_JRD, 't');

% Check if these matrices meet certain criteria
% checkMat(RSM_JRD);

%% Neural RSM <-> Same street matrix
% Convert the same-street matrix to category-based order
cd('Behavioral_Matrices'); 
S_Mat = load('StreetMat_ByLoc.mat'); 
cd ..

% Because the same-street matrix was organized by location, it needs to be
% reordered by category (hence becoming off the diagnal)
StreetMat = reorderMat(S_Mat.StreetMat, f_index);

if strcmp(Matrix, 'RSM')
    [r_JRD, ~] = corMat(StreetMat, RSM_JRD, 'Spearman');
    
elseif strcmp(Matrix, 'RDM')
    [r_JRD, ~] = corMat(StreetMat, RDM_JRD, 'Spearman');
    r_JRD = -r_JRD;
end

r_JRD = r2z(r_JRD);

Street_RS = r_JRD;

%% Neural RSM <-> Same building matrix
% Convert the same-street matrix to category-based order (reorderMat)
cd('Behavioral_Matrices'); 
B_Mat = load('BuildingMat_ByLoc.mat'); 
cd ..

% Because the same-street matrix was organized by location, it needs to be
% reordered by category
BuildingMat = reorderMat(B_Mat.BuildingMat, f_index);

if strcmp(Matrix, 'RSM')
    [r_JRD, ~] = corMat(BuildingMat, RSM_JRD, 'Spearman');
    
elseif strcmp(Matrix, 'RDM')
    [r_JRD, ~] = corMat(BuildingMat, RDM_JRD, 'Spearman');
    r_JRD = -r_JRD;
end

r_JRD = r2z(r_JRD);

Building_RS = r_JRD;

%% Neural RSM <-> Distance matrix
cd('Behavioral_Matrices'); 
Dis_Mat = load('DistanceMat_ByLoc_Restricted.mat'); 
cd ..

% Because the same-street matrix was organized by location, it needs to be
% reordered by category
DistanceMat = reorderMat(Dis_Mat.DistanceMat, f_index);

if strcmp(Matrix, 'RSM') 
    [r_JRD, ~] = corMat(-DistanceMat, RSM_JRD, 'Spearman');
elseif strcmp(Matrix, 'RDM') 
    [r_JRD, ~] = corMat(-DistanceMat, RDM_JRD, 'Spearman');
    r_JRD = -r_JRD;
end

r_JRD = r2z(r_JRD);

Distance_RS = r_JRD;
%% Neural RSM <-> Facing direction matrix
cd('Behavioral_Matrices'); 
Dir_Mat = load('DirectionMat_ByLoc.mat'); 
cd ..

% Because the same-street matrix was organized by location, it needs to be
% reordered by category
DirectionMat = reorderMat(Dir_Mat.DirectionMat, f_index);

if strcmp(Matrix, 'RSM')
    [r_JRD, ~] = corMat(DirectionMat, RSM_JRD, 'Spearman');
    
elseif strcmp(Matrix, 'RDM')
    [r_JRD, ~] = corMat(DirectionMat, RDM_JRD, 'Spearman');
    r_JRD = -r_JRD;
end

r_JRD = r2z(r_JRD);


Direction_RS = r_JRD;

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
% checkMat(CategoryMat);

if strcmp(Matrix, 'RSM')
    [r_JRD, ~] = corMat(CategoryMat, RSM_JRD, 'Spearman');

elseif strcmp(Matrix, 'RDM')
    [r_JRD, ~] = corMat(CategoryMat, RDM_JRD, 'Spearman');
    r_JRD = -r_JRD;
end

r_JRD = r2z(r_JRD);

Category_RS = r_JRD;

%% Neural RSM <-> GIST dissimilarity
cd('Behavioral_Matrices'); 
Vis_Mat = load('imgDM_GIST.mat'); 
cd ..

% Because the same-street matrix was organized by location, it needs to be
% reordered by category
VisualMat = reorderMat(Vis_Mat.imgDM_GIST, f_index);

if strcmp(Matrix, 'RSM')
    [r_JRD, ~] = corMat(VisualMat, RSM_JRD, 'Spearman');
    
elseif strcmp(Matrix, 'RDM')
    [r_JRD, ~] = corMat(VisualMat, RDM_JRD, 'Spearman');
    r_JRD = -r_JRD;
end

r_JRD = r2z(r_JRD);

GIST_RS = -r_JRD;
end
