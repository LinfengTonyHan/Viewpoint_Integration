%% Plot results for coding of other spatial quantities
clear;
close all
figure;

%% Distance
load("Data_OtherQuantities/Data_Distance_MEM_Restricted.mat");
Data_Distance_combined = Data_Distance;
load("Data_OtherQuantities/Data_Distance_PCP_Restricted.mat");
Data_Distance_combined{5} = nan(24, 1);
Data_Distance_combined{6} = Data_Distance{1};
Data_Distance_combined{7} = Data_Distance{2};
Data_Distance_combined{8} = Data_Distance{3};
Data_Distance_combined{9} = nan(24, 1);
Data_Distance_combined{10} = Data_Distance{5};

subplot(1, 3, 1)
scatterBarPlot_manyGroups(Data_Distance_combined);
xticks([1:4, 6, 7, 8, 10]);
xticklabels({'VPMA', 'MPMA', 'LPMA', 'SPPMA', 'PPA', 'RSC', 'OPA', 'EVC'});
title('Coding of Euclidean distance');
ylim([-0.2, 0.3]);
xlabel('Region of interest')
ylabel("Model similiarty (Fisher's z)")
set(gca, 'FontSize', 22);

%% Direction
load("Data_OtherQuantities/Data_Direction_MEM.mat");
Data_Direction_combined = Data_Direction;
load("Data_OtherQuantities/Data_Direction_PCP.mat");
Data_Direction_combined{5} = nan(24, 1);
Data_Direction_combined{6} = Data_Direction{1};
Data_Direction_combined{7} = Data_Direction{2};
Data_Direction_combined{8} = Data_Direction{3};
Data_Direction_combined{9} = nan(24, 1);
Data_Direction_combined{10} = Data_Direction{5};

subplot(1, 3, 2)
scatterBarPlot_manyGroups(Data_Direction_combined);
xticks([1:4, 6, 7, 8, 10]);
xticklabels({'VPMA', 'MPMA', 'LPMA', 'SPPMA', 'PPA', 'RSC', 'OPA', 'EVC'});
title('Coding of facing direction');
ylim([-0.2, 0.3]);
xlabel('Region of interest')
% ylabel("");
% ylabel("Model similiarty (Fisher's z)")
set(gca, 'FontSize', 22);

%% Category
load("Data_OtherQuantities/Data_Category_MEM.mat");
Data_Category_combined = Data_Category;
load("Data_OtherQuantities/Data_Category_PCP.mat");
Data_Category_combined{5} = nan(24, 1);
Data_Category_combined{6} = Data_Category{1};
Data_Category_combined{7} = Data_Category{2};
Data_Category_combined{8} = Data_Category{3};
Data_Category_combined{9} = nan(24, 1);
Data_Category_combined{10} = Data_Category{5};

subplot(1, 3, 3)
scatterBarPlot_manyGroups(Data_Category_combined);
xticks([1:4, 6, 7, 8, 10]);
xticklabels({'VPMA', 'MPMA', 'LPMA', 'SPPMA', 'PPA', 'RSC', 'OPA', 'EVC'});
title('Coding of category');
ylim([-0.2, 0.3]);
xlabel('Region of interest')
% ylabel("");
% ylabel("Model similiarty (Fisher's z)")
set(gca, 'FontSize', 22);
