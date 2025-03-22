%% Generate all the regressors for one subject
Subject = 'Subject028';

genRegressors(Subject, 'Localizer1');
genRegressors(Subject, 'Localizer2');
genRegressors(Subject, 'LocalizerMemory');
genRegressors(Subject, 'JRD1');
genRegressors(Subject, 'JRD2');
genRegressors(Subject, 'JRD3');
genRegressors(Subject, 'JRD4');