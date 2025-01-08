%% This script is for the group level RSA, plotting the results by regions
clear;

ROI_type = 'perception'; % 'perception' or 'memory', which determines which localizer contrast is used
ylab = "Model similarity (Fisher's z)";

nSub = 28;
exclusionList = [2, 8, 16, 22]; % Data exclusion

subList = 1:nSub;
subList = setdiff(subList, exclusionList);

for iteSub = 1:length(subList)
    if subList(iteSub) <= 9
        Subject = ['Subject00', num2str(subList((iteSub)))];
    elseif subList(iteSub) >= 10
        Subject = ['Subject0', num2str(subList((iteSub)))];
    end
    
    %% bilateral PPA
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, 'lrPPA', ROI_type, 'RSM');

    Street_PPA_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_PPA_JRD(iteSub, 1) = Building_RS; 
    Distance_PPA_JRD(iteSub, 1) = Distance_RS;
    Direction_PPA_JRD(iteSub, 1) = Direction_RS;
    Category_PPA_JRD(iteSub, 1) = Category_RS;
    GIST_PPA_JRD(iteSub, 1) = GIST_RS;
    
    %% bilateral RSC
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, 'lrRSC', ROI_type, 'RSM');

    Street_RSC_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_RSC_JRD(iteSub, 1) = Building_RS; 
    Distance_RSC_JRD(iteSub, 1) = Distance_RS;
    Direction_RSC_JRD(iteSub, 1) = Direction_RS;
    Category_RSC_JRD(iteSub, 1) = Category_RS;
    GIST_RSC_JRD(iteSub, 1) = GIST_RS;
    
    %% bilateral OPA
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, 'lrOPA', ROI_type, 'RSM');

    Street_OPA_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_OPA_JRD(iteSub, 1) = Building_RS; 
    Distance_OPA_JRD(iteSub, 1) = Distance_RS;
    Direction_OPA_JRD(iteSub, 1) = Direction_RS;
    Category_OPA_JRD(iteSub, 1) = Category_RS;
    GIST_OPA_JRD(iteSub, 1) = GIST_RS;
    
    %% bilateral EVC
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, 'lrEVC', ROI_type, 'RSM'); % ROI_type doesn't matter here

    Street_EVC_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_EVC_JRD(iteSub, 1) = Building_RS; 
    Distance_EVC_JRD(iteSub, 1) = Distance_RS;
    Direction_EVC_JRD(iteSub, 1) = Direction_RS;
    Category_EVC_JRD(iteSub, 1) = Category_RS;
    GIST_EVC_JRD(iteSub, 1) = GIST_RS;

    %% bilateral HPC
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, 'HPC', ROI_type, 'RSM'); % ROI_type doesn't matter here

    Street_HPC_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_HPC_JRD(iteSub, 1) = Building_RS; 
    Distance_HPC_JRD(iteSub, 1) = Distance_RS;
    Direction_HPC_JRD(iteSub, 1) = Direction_RS;
    Category_HPC_JRD(iteSub, 1) = Category_RS;
    GIST_HPC_JRD(iteSub, 1) = GIST_RS;

    %% bilateral anterior HPC
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, 'aHPC', ROI_type, 'RSM'); % ROI_type doesn't matter here

    Street_aHPC_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_aHPC_JRD(iteSub, 1) = Building_RS; 
    Distance_aHPC_JRD(iteSub, 1) = Distance_RS;
    Direction_aHPC_JRD(iteSub, 1) = Direction_RS;
    Category_aHPC_JRD(iteSub, 1) = Category_RS;
    GIST_aHPC_JRD(iteSub, 1) = GIST_RS;

    %% bilateral SPL
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject(Subject, 'lrSPL', ROI_type, 'RSM'); % ROI_type doesn't matter here

    Street_SPL_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_SPL_JRD(iteSub, 1) = Building_RS; 
    Distance_SPL_JRD(iteSub, 1) = Distance_RS;
    Direction_SPL_JRD(iteSub, 1) = Direction_RS;
    Category_SPL_JRD(iteSub, 1) = Category_RS;
    GIST_SPL_JRD(iteSub, 1) = GIST_RS;

end

% Columns: PPA, RSC, OPA, EVC
Data_Street{1, 1} = Street_PPA_JRD;
Data_Street{1, 2} = Street_RSC_JRD;
Data_Street{1, 3} = Street_OPA_JRD;
Data_Street{1, 4} = Street_SPL_JRD;


Data_Building{1, 1} = Building_PPA_JRD;
Data_Building{1, 2} = Building_RSC_JRD;
Data_Building{1, 3} = Building_OPA_JRD;
Data_Building{1, 4} = Building_SPL_JRD;


Data_Distance{1, 1} = Distance_PPA_JRD;
Data_Distance{1, 2} = Distance_RSC_JRD;
Data_Distance{1, 3} = Distance_OPA_JRD;
Data_Distance{1, 4} = Distance_SPL_JRD;


Data_Direction{1, 1} = Direction_PPA_JRD;
Data_Direction{1, 2} = Direction_RSC_JRD;
Data_Direction{1, 3} = Direction_OPA_JRD;
Data_Direction{1, 4} = Direction_SPL_JRD;


Data_Category{1, 1} = Category_PPA_JRD;
Data_Category{1, 2} = Category_RSC_JRD;
Data_Category{1, 3} = Category_OPA_JRD;
Data_Category{1, 4} = Category_SPL_JRD;


Data_GIST{1, 1} = GIST_PPA_JRD;
Data_GIST{1, 2} = GIST_RSC_JRD;
Data_GIST{1, 3} = GIST_OPA_JRD;
Data_GIST{1, 4} = GIST_SPL_JRD;
% Data_GIST{1, 5} = GIST_EVC_JRD;

% % Early visual cortex results
%%%%%%%
%% Choose to comment out this section if necessary for figure creation
% Data_Street{1, 5} = Street_EVC_JRD;
% Data_Building{1, 5} = Building_EVC_JRD;
% Data_Distance{1, 5} = Distance_EVC_JRD;
% Data_Direction{1, 5} = Direction_EVC_JRD;
% Data_Category{1, 5} = Category_EVC_JRD;
% %%%%%%%

% The order should be PPA-Pano, RSC-Pano, PPA-Landmark, RSC-Landmark
Data2Test = [Data_Street{1}, Data_Street{2}, Data_Building{1}, Data_Building{2}];

% Calculate the effect size: Cohen's d
cohenD = mean(Data2Test)./std(Data2Test);
disp(cohenD);

% Do this for OPA and EVC
Data2Test_OPA_EVC = [Data_Street{3}, Data_Street{4}, Data_Building{3}, Data_Building{4}];
cohenD_OPA_EVC = mean(Data2Test_OPA_EVC)./std(Data2Test_OPA_EVC);
disp(cohenD_OPA_EVC);

%% Create the plots
if strcmp(ROI_type, 'perception')
    ROI_labels = {'PPA', 'RSC', 'OPA', 'SPL', 'EVC'};
elseif strcmp(ROI_type, 'memory')
    ROI_labels = {'VPMA', 'MPMA', 'LPMA', 'SPPMA'};
end

figure;
fig_SS = subplot(2, 3, 1);
scatterBarPlot_colorCoded(Data_Street);
title('Panoramic association')
xticklabels(ROI_labels);
ylabel(ylab);
ylim([-0.2, 0.2]);
set(gca, 'FontSize', 20);

fig_SB = subplot(2, 3, 2);
scatterBarPlot_colorCoded(Data_Building);
title('Landmark association')
xticklabels(ROI_labels);
ylabel(ylab);
ylim([-0.2, 0.2]);
set(gca, 'FontSize', 20);

fig_Dis = subplot(2, 3, 3);
scatterBarPlot_colorCoded(Data_Distance);
title('Coding of distance')
xticklabels(ROI_labels);
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_Dir = subplot(2, 3, 4);
scatterBarPlot_colorCoded(Data_Direction);
title('Coding of direction')
xticklabels(ROI_labels);
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_Cat = subplot(2, 3, 5);
scatterBarPlot_colorCoded(Data_Category);
title('Coding of category')
xticklabels(ROI_labels);
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_GIST = subplot(2, 3, 6);
scatterBarPlot_colorCoded(Data_GIST);
title('Coding of visual features')
xticklabels(ROI_labels);
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_combined = figure;

%% These for including OPA in the figures
% data_combined_SpacAssoc = {Data_Street{1}, Data_Building{1}; Data_Street{2}, Data_Building{2}; Data_Street{3}, Data_Building{3}};
% data_combined_forTest = [Data_Street{1}, Data_Building{1}, Data_Street{2}, Data_Building{2}, Data_Street{3}, Data_Building{3}];
% data_combined_V2 = [Data_Street{1}, Data_Street{2}, Data_Street{3}, Data_Street{4}, Data_Building{1}, Data_Building{2}, Data_Building{3}, Data_Building{4}];
% scatterBarPlot3_Dsc(data_combined_SpacAssoc);

data_combined_SpacAssoc = {Data_Street{1}, Data_Street{2}; Data_Building{1}, Data_Building{2}}; % In the cell format for visualization
scatterBarPlot2_Dsc(data_combined_SpacAssoc);
ylim([-0.2, 0.2]); % More symetric?

% title('Spatial association representation in PPA and RSC')
ylabel(ylab)
xticklabels({'PPA', 'RSC'});
xlabel('Region of interest')
set(gca, 'FontSize', 32);

for iteTest = 1:4
    [h(iteTest), p(iteTest), ~, stats] = ttest(Data2Test(:, iteTest), 0, 'Tail', 'right');
    tval(iteTest) = stats.tstat;
end

% Tests of simple effects

% Concatenate the statistics
statsAll = [tval; p; cohenD];

%% Create separate figures for street and building
figure('Position', [100, 100, 700, 700]); 
scatterBarPlot_colorCoded(Data_Street);
% title('Panoramic representation')
xticklabels(ROI_labels);
xlabel('Region of interest')
ylabel(ylab);
ylim([-0.2, 0.2]);
set(gca, 'FontSize', 28);

figure('Position', [1100, 100, 700, 700]); 
scatterBarPlot_colorCoded(Data_Building);
% title('Landmark representation')
xticklabels(ROI_labels);
xlabel('Region of interest')
ylabel(ylab);
ylim([-0.2, 0.2]);
set(gca, 'FontSize', 28);
