%% Generate group-level RSMs
function [RSM_Mean, RSM_adjusted, RSM_single] = genGroupRSM(ROI)
%%
% ROI: lrXXX_YYY
% XXX - RSC/PPA/OPA
% YYY - LOC/MEM

Session = 'JRD';
ImageType = 't';

load('facadeSequenceAllSub.mat');

RSM_AllSub = zeros(24, 24);

%% Specifying the subjects
nSub = 28;
exclusionList = [2, 8, 16, 22];
subList = setdiff(1:nSub, exclusionList);

SS_index = [1, 2, 5, 6, 9, 10, 11, 12, 17, 18, 23, 24];
SB_index = setdiff(1:24, SS_index);

%% Reordering location indices (or not)
% If location_index is 1:24, then do not organize the matrix by 6 SS + 6 SB
location_index = [SS_index, SB_index]; % First 6 diagnal cells as SS, last 6 as SB
% location_index = 1:24;

direction_index_mountain = [1, 4, 8, 10, 20, 23];
direction_index_bridge = [6, 7, 12, 16, 17, 19];
direction_index_tower = [2, 9, 13, 15, 22, 24];
direction_index_lighthouse = [3, 5, 11, 14, 18, 21];

% Organized by facing directions
direction_index = [direction_index_mountain, direction_index_bridge, direction_index_tower, direction_index_lighthouse];

for iteSub = 1:length(subList)
    f_index = facadeSequenceAllSub(subList(iteSub), :);
    if subList(iteSub) <= 9
        Subject = ['Subject00', num2str(subList((iteSub)))];
    elseif subList(iteSub) >= 10
        Subject = ['Subject0', num2str(subList((iteSub)))];
    end
    
    [~, RSM, RDM] = genRDMs(Subject, Session, ROI, ImageType); % Designated ROI
    RSM = double(RSM);
    RDM = double(RDM);
    %% There are two ways of organizing: first, by locations, second, by facade ID
    % To generate the lme model matrix, we organize by locations (already
    % reordered based on facade IDs
    % RSM_single{iteSub} = RSM;
    RSM_single{iteSub} = reorderMat2(RSM, f_index);
    RSM_single{iteSub} = reorderMat2(RSM_single{iteSub}, location_index);
    % RSM_single{iteSub} = nan_zscore(RSM_single{iteSub}); 
    RSM_AllSub = RSM_AllSub + RSM_single{iteSub};
end

RSM_Mean = RSM_AllSub/length(subList);

% Next, calculate the variation
for iteCell_i = 1:24
    for iteCell_j = 1:24
        for iteSub = 1:length(subList)
            RSM_iteSub = RSM_single{iteSub};
            VarVec(iteSub) = RSM_iteSub(iteCell_i, iteCell_j);
            
        end
        VarMat(iteCell_i, iteCell_j) = std(VarVec);
    end
end

RSM_adjusted = RSM_Mean./VarMat; % RSM adjusted by overall variance (?)
       
