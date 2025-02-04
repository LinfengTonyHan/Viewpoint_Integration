%% This script is for the group level RSA, plotting the results by regions
clear;
nSub = 28;
exclusionList = [2, 8, 16, 22];
subList = setdiff(1:nSub, exclusionList);

ROI_type = 'perception';
ylab = 'Model similarity';

for iteSub = 1:length(subList)
    if subList(iteSub) <= 9
        Subject = ['Subject00', num2str(subList((iteSub)))];
    elseif subList(iteSub) >= 10
        Subject = ['Subject0', num2str(subList((iteSub)))];
    end
    
    %% bilateral PPA
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject_PCA(Subject, 'lrPPA', ROI_type, 'RSM');

    Street_PPA_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_PPA_JRD(iteSub, 1) = Building_RS; 
    Distance_PPA_JRD(iteSub, 1) = Distance_RS;
    Direction_PPA_JRD(iteSub, 1) = Direction_RS;
    Category_PPA_JRD(iteSub, 1) = Category_RS;
    GIST_PPA_JRD(iteSub, 1) = GIST_RS;
    
    %% bilateral RSC
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject_PCA(Subject, 'lrRSC', ROI_type, 'RSM');

    Street_RSC_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_RSC_JRD(iteSub, 1) = Building_RS; 
    Distance_RSC_JRD(iteSub, 1) = Distance_RS;
    Direction_RSC_JRD(iteSub, 1) = Direction_RS;
    Category_RSC_JRD(iteSub, 1) = Category_RS;
    GIST_RSC_JRD(iteSub, 1) = GIST_RS;
    
    %% bilateral OPA
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject_PCA(Subject, 'lrOPA', ROI_type, 'RSM');

    Street_OPA_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_OPA_JRD(iteSub, 1) = Building_RS; 
    Distance_OPA_JRD(iteSub, 1) = Distance_RS;
    Direction_OPA_JRD(iteSub, 1) = Direction_RS;
    Category_OPA_JRD(iteSub, 1) = Category_RS;
    GIST_OPA_JRD(iteSub, 1) = GIST_RS;
    
    %% bilateral EVC
    [Street_RS, Building_RS, Distance_RS, Direction_RS, Category_RS, GIST_RS] = ...
    Analysis_RSA_SingleSubject_PCA(Subject, 'lrEVC', ROI_type, 'RSM');

    Street_EVC_JRD(iteSub, 1) = Street_RS; % Column matrix
    Building_EVC_JRD(iteSub, 1) = Building_RS; 
    Distance_EVC_JRD(iteSub, 1) = Distance_RS;
    Direction_EVC_JRD(iteSub, 1) = Direction_RS;
    Category_EVC_JRD(iteSub, 1) = Category_RS;
    GIST_EVC_JRD(iteSub, 1) = GIST_RS;
   
end

% Columns: PPA, RSC, OPA, EVC
Data_Street{1, 1} = Street_PPA_JRD;
Data_Street{1, 2} = Street_RSC_JRD;
Data_Street{1, 3} = Street_OPA_JRD;
Data_Street{1, 4} = Street_EVC_JRD;

Data_Building{1, 1} = Building_PPA_JRD;
Data_Building{1, 2} = Building_RSC_JRD;
Data_Building{1, 3} = Building_OPA_JRD;
Data_Building{1, 4} = Building_EVC_JRD;

Data_Distance{1, 1} = Distance_PPA_JRD;
Data_Distance{1, 2} = Distance_RSC_JRD;
Data_Distance{1, 3} = Distance_OPA_JRD;
Data_Distance{1, 4} = Distance_EVC_JRD;

Data_Direction{1, 1} = Direction_PPA_JRD;
Data_Direction{1, 2} = Direction_RSC_JRD;
Data_Direction{1, 3} = Direction_OPA_JRD;
Data_Direction{1, 4} = Direction_EVC_JRD;

Data_Category{1, 1} = Category_PPA_JRD;
Data_Category{1, 2} = Category_RSC_JRD;
Data_Category{1, 3} = Category_OPA_JRD;
Data_Category{1, 4} = Category_EVC_JRD;

Data_GIST{1, 1} = GIST_PPA_JRD;
Data_GIST{1, 2} = GIST_RSC_JRD;
Data_GIST{1, 3} = GIST_OPA_JRD;
Data_GIST{1, 4} = GIST_EVC_JRD;

Data2Test = [Data_Street{1}, Data_Street{2}, Data_Building{1}, Data_Building{2}];

figure;
fig_SS = subplot(2, 3, 1);
scatterBarPlot(Data_Street);
title('Panoramic association')
xticklabels({'PPA', 'RSC', 'OPA', 'EVC'});
ylabel(ylab);
ylim([-0.2, 0.2]);
set(gca, 'FontSize', 20);

fig_SB = subplot(2, 3, 2);
scatterBarPlot(Data_Building);
title('Landmark association')
xticklabels({'PPA', 'RSC', 'OPA', 'EVC'});
ylabel(ylab);
ylim([-0.2, 0.2]);
set(gca, 'FontSize', 20);

fig_Dis = subplot(2, 3, 3);
scatterBarPlot(Data_Distance);
title('Coding of distance')
xticklabels({'PPA', 'RSC', 'OPA', 'EVC'});
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_Dir = subplot(2, 3, 4);
scatterBarPlot(Data_Direction);
title('Coding of direction')
xticklabels({'PPA', 'RSC', 'OPA', 'EVC'});
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_Cat = subplot(2, 3, 5);
scatterBarPlot(Data_Category);
title('Coding of category')
xticklabels({'PPA', 'RSC', 'OPA', 'EVC'});
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_GIST = subplot(2, 3, 6);
scatterBarPlot(Data_GIST);
title('Coding of visual features')
xticklabels({'PPA', 'RSC', 'OPA', 'EVC'});
ylabel(ylab);
set(gca, 'FontSize', 20);

fig_combined = figure;
% data_combined_SpacAssoc = {Data_Street{1}, Data_Building{1}; Data_Street{2}, Data_Building{2}; Data_Street{3}, Data_Building{3}};
% data_combined_forTest = [Data_Street{1}, Data_Building{1}, Data_Street{2}, Data_Building{2}, Data_Street{3}, Data_Building{3}];
% data_combined_V2 = [Data_Street{1}, Data_Street{2}, Data_Street{3}, Data_Street{4}, Data_Building{1}, Data_Building{2}, Data_Building{3}, Data_Building{4}];
% scatterBarPlot3_Dsc(data_combined_SpacAssoc);

data_combined_SpacAssoc = {Data_Street{1}, Data_Building{1}; Data_Street{2}, Data_Building{2}};
scatterBarPlot2_Dsc(data_combined_SpacAssoc);
ylim();

title('Spatial representations in PPA and RSC')
ylabel(ylab)
xticklabels({'Panorama', 'Landmark'});
xlabel('Local spatial association type')
set(gca, 'FontSize', 32);

for iteTest = 1:4
    [h(iteTest), p(iteTest), ~, stats] = ttest(Data2Test(:, iteTest));
    tval(iteTest) = stats.tstat;
end

