function newMat = reorderMat(oldMat, sequence)
%% This function is written for reorganizing the matrix (shuffling the order)
% An example -- shuffling from location-based order to category-based order
% Location sequence (Subject 002): 
% [7, 20, 21, 6, 12, 24, 14, 22, 3, 10, 8, 15, 19, 11, 5, 4, 16, 1, 13, 2, 23, 17, 18, 9]
% Then newMat(7, 20) = oldMat(1, 2) (7th facade and 20th facade in the category-based sequence)
% newMat(21, 6) = newMat(6, 21) = oldMat(3, 4) = oldMat(4, 3);
sizeMat = size(oldMat, 2);

for i = 1:sizeMat
    for j = 1:sizeMat
        i_index = find(sequence == i);
        j_index = find(sequence == j);
        newMat(i, j) = oldMat(i_index, j_index);
    end
end

% Next, check if newMat is a legit matrix
% newMatValid = checkMat(newMat);

% if newMatValid ~= 1
%     disp('Error with the newly generated matrix!');
% end