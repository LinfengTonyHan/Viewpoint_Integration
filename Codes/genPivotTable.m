%% This code is used to generate the pivot chart
% Run the RSM code
clear;
genGroupRSM;

for sub_ID = 1:19

sub_ID = 10;
sub_List = [1, 3, 4, 5, 6, 7, 9, 10, 11, 12];
RSM = RSM_single{sub_ID};
Subject = ['s', num2str(sub_ID)];
ROI = 'EVC';
% By subject by ROI
load facadeSequenceAllSub.mat % Only for the category matrix

cd('Behavioral_Matrices');

load('StreetMat_ByLoc.mat');
load('BuildingMat_ByLoc.mat');
load('DirectionMat2_ByLoc.mat');
load('DistanceMat_ByLoc.mat');
load('TemporalMat_ByLoc.mat');

cd ..
% First, generate the category matrix by location
CategoryMat = zeros(24, 24);

f_ID = facadeSequenceAllSub(sub_List(sub_ID), :);
for i = 1:12
    f1 = find(f_ID == 2*i-1);
    f2 = find(f_ID == 2*i);
    
    CategoryMat(f1, f2) = 1;
    CategoryMat(f2, f1) = 1;
end

% Start generating the pivot table
count = 1;
pTable = {};

for i = 1:24
    for j = 1:24
        if i < j
            pTable{count, 1} = Subject;
            
            pTable{count, 2} = ROI;
            
            pTable{count, 3} = ['P', num2str(i), 'P', num2str(j)];
            
            if CategoryMat(i, j) == 1
                pTable{count, 4} = 'SameCat';
            elseif CategoryMat(i, j) == 0
                pTable{count, 4} = 'DiffCat';
            end
            
            pTable{count, 5} = DirectionMat2_ByLoc(i, j);
            
            if StreetMat(i, j) == 1
                pTable{count, 6} = 'SameStreet';
            elseif StreetMat(i, j) == 0
                pTable{count, 6} = 'DiffStreet';
            end
            
            if BuildingMat(i, j) == 1
                pTable{count, 7} = 'SameBuilding';
            elseif BuildingMat(i, j) == 0
                pTable{count, 7} = 'DiffBuilding';
            end
            
            pTable{count, 8} = DistanceMat(i, j);
            
            pTable{count, 9} = TemporalMat(i, j);
            
            pTable{count, 10} = RSM(i, j);
            count = count + 1;
        end
    end
end
