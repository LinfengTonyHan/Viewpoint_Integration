function newMat = reorderMat2(oldMat, sequence)
%% This function is written for reorganizing the matrix (shuffling the order)
% An example -- shuffling from category-based order to location-based order
% Location sequence:
% [7, 20, 21, 6, 12, 24, 14, 22, 3, 10, 8, 15, 19, 11, 5, 4, 16, 1, 13, 2, 23, 17, 18, 9]
% Then newMat(1, 2) = oldMat(7, 20)
sizeMat = size(oldMat, 2);

for i = 1:sizeMat
    for j = 1:sizeMat
        newMat(i, j) = oldMat(sequence(i), sequence(j));
    end
end