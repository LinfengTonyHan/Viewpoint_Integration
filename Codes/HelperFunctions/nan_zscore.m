function newMat = nan_zscore(oldMat)

vec = reshape(oldMat, 1, size(oldMat, 1) * size(oldMat, 2));
meanv = nanmean(vec);
stdv = nanstd(vec);
newMat = (oldMat - meanv)/stdv;