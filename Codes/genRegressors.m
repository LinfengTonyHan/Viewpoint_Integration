function [conditions, headmotion] = genRegressors(Subject, Session)
%% This script is for generating the regressors for fMRI GLMs
% Names for vargin Subject: 'Subject001' 'Subject013' etc.
% Names for vargin Session:
% Localizers: 'Localizer1' 'Localizer2'
% Passive Viewing D1: 'PasViewingR1D1' 'PasViewingR2D1' 'PasViewingR3D1'
% Passive Viewing D2: 'PasViewingR1D2' 'PasViewingR2D2' 'PasViewingR3D2'
% JRDs: 'JRD1' 'JRD2'

% Using the data from ./BehavioralData/Subject# to generate the non-nuisance
% regressors (onset, duration, etc.)

% Using the data from the ./Regressor/Subject# to generate the head-motion
% regressors (ending in .tsv)
%% Generating Regressors for Localizer Runs
if strcmp(Session, 'Localizer1') || strcmp(Session, 'Localizer2')
    filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/BehavioralData/', Subject];
    filename = [Session, '.mat'];
    loadfilename = [filedir, '/', filename];
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_Conditions.mat'];
    
    load(loadfilename);
    names = cell(1, 4); onsets = cell(1, 4); durations = cell(1, 4);
    
    %% Specifying the names
    names{1} = 'Scenes'; names{2} = 'Faces'; names{3} = 'Objects'; names{4} = 'ScrObjects';
    
    %% Specifying the stimulus onsets
    onsets{1} = scene_onset;
    onsets{2} = face_onset;
    onsets{3} = obj_onset;
    onsets{4} = objscr_onset;
    
    %% Specifying the stimulus durations
    durations{1} = ones(1,4) * 16;
    durations{2} = ones(1,4) * 16;
    durations{3} = ones(1,4) * 16;
    durations{4} = ones(1,4) * 16;
    
    cd(savefiledir);
    clearvars -except Subject Session names onsets durations savefilename
    save(savefilename);
    
    conditions.names = names;
    conditions.onsets = onsets;
    conditions.durations = durations;
    
    %% Generate the head motion regressors
    filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    filename = [Session, '.tsv'];
    loadfilename = [filedir, '/', filename];
    aC = tdfread(loadfilename); % aC: all confounds
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_HeadMotionRegressors.mat'];
    names = cell(1, 7);
    names{1} = 'Trans_X';
    names{2} = 'Trans_Y';
    names{3} = 'Trans_Z';
    names{4} = 'Rot_X';
    names{5} = 'Rot_Y';
    names{6} = 'Rot_Z';
    names{7} = 'Global_csf';
    
    R = [aC.trans_x, aC.trans_y, aC.trans_z, aC.rot_x, aC.rot_y, aC.rot_z, aC.csf];
    
    cd(savefiledir);
    clearvars -except Subject Session names R savefilename
    save(savefilename);
    
    headmotion.names = names;
    headmotion.R = R;
end

%% Generating Regressors for the Memory Localizer run
if strcmp(Session, 'LocalizerMemory')
    % All onsets were pre-set. No randomizations were implemented.
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_Conditions.mat'];
    
    names{1} = 'Faces'; names{2} = 'Scenes';
    onsets{1} = [12, 72, 132, 192, 252, 312]; % Face onsets
    onsets{2} = [42, 102, 162, 222, 282, 342]; % Scene onsets
    durations{1} = [30, 30, 30, 30, 30, 30]; % Mini-block: 30 s
    durations{2} = [30, 30, 30, 30, 30, 30];
    
    cd(savefiledir);
    clearvars -except names onsets durations Subject Session savefilename
    save(savefilename);
    
    conditions.names = names;
    conditions.onsets = onsets;
    conditions.durations = durations;
    
    %% Generating regressors for head motion
    filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    filename = [Session, '.tsv'];
    loadfilename = [filedir, '/', filename];
    aC = tdfread(loadfilename); % aC: all confounds
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_HeadMotionRegressors.mat'];
    names = cell(1, 7);
    names{1} = 'Trans_X';
    names{2} = 'Trans_Y';
    names{3} = 'Trans_Z';
    names{4} = 'Rot_X';
    names{5} = 'Rot_Y';
    names{6} = 'Rot_Z';
    names{7} = 'Global_csf';
    
    R = [aC.trans_x, aC.trans_y, aC.trans_z, aC.rot_x, aC.rot_y, aC.rot_z, aC.csf];
    
    cd(savefiledir);
    clearvars -except Subject Session names R savefilename
    save(savefilename);
    
    headmotion.names = names;
    headmotion.R = R;
end

%% Generating regressor files for JRD runs
if strcmp(Session, 'JRD1') || strcmp(Session, 'JRD2') || strcmp(Session, 'JRD3') || strcmp(Session, 'JRD4')
    
    filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/BehavioralData/', Subject];
    filename = [Session, '.mat'];
    loadfilename = [filedir, '/', filename];
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_Conditions.mat'];
    
    load(loadfilename);
    
    % % % % %
    RunInfo = eval(['Run', Session(4)]); % The 4th letter in the name indicates the run number (1, 2, or 3)
    % % % % %
    RunInfo = RunInfo(1:2, 1:48);
    
    for i = 1:24 
        index = find(RunInfo(2, :) == i);
        names{i} = ['img', num2str(i)];
        onsets{i} = RunInfo(1, index) * 2;
        durations{i} = ones(1, length(index)) * 0;
    end 
    
    cd(savefiledir);
    clearvars -except names onsets durations Subject Session savefilename
    save(savefilename);
    
    conditions.names = names;
    conditions.onsets = onsets;
    conditions.durations = durations;
    
    %% Generating head motion regressors
    filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    filename = [Session, '.tsv'];
    loadfilename = [filedir, '/', filename];
    aC = tdfread(loadfilename); % aC: all confounds
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_HeadMotionRegressors.mat'];
    names = cell(1, 7);
    names{1} = 'Trans_X';
    names{2} = 'Trans_Y';
    names{3} = 'Trans_Z';
    names{4} = 'Rot_X';
    names{5} = 'Rot_Y';
    names{6} = 'Rot_Z';
    names{7} = 'Global_csf';
    
    R = [aC.trans_x, aC.trans_y, aC.trans_z, aC.rot_x, aC.rot_y, aC.rot_z, aC.csf];
    
    cd(savefiledir);
    clearvars -except Subject Session names R savefilename
    save(savefilename);
    
    headmotion.names = names;
    headmotion.R = R;

end

%% Generating regressors for JRD runs based on landmarks
if strcmp(Session, 'JRD1_Landmark') || strcmp(Session, 'JRD2_Landmark')
    
    filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/BehavioralData/', Subject];
    filename = [Session(1:4), '.mat'];
    loadfilename = [filedir, '/', filename];
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_Conditions.mat'];
    
    load(loadfilename);
    
    % % % % %
    RunInfo = eval(['Run', Session(4)]); % The 4th letter indicates the run number
    % % % % %
    RunInfo = RunInfo(1:3, 1:48);
    
    for i = 1:4
        index = find(RunInfo(3, :) == i);
        names{i} = ['landmark', num2str(i)];
        onsets{i} = RunInfo(1, index) * 2;
        durations{i} = ones(1, length(index)) * 7;
    end 
    
    cd(savefiledir);
    clearvars -except names onsets durations Subject Session savefilename
    save(savefilename);
    
    conditions.names = names;
    conditions.onsets = onsets;
    conditions.durations = durations;
    
    %% Generating head motion regressors
    filedir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    filename = [Session(1:4), '.tsv'];
    loadfilename = [filedir, '/', filename];
    aC = tdfread(loadfilename); % aC: all confounds
    
    savefiledir = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Regressors/', Subject];
    savefilename = [Subject, '_', Session, '_HeadMotionRegressors.mat'];
    names = cell(1, 6);
    names{1} = 'Trans_X';
    names{2} = 'Trans_Y';
    names{3} = 'Trans_Z';
    names{4} = 'Rot_X';
    names{5} = 'Rot_Y';
    names{6} = 'Rot_Z';
    
    R = [aC.trans_x, aC.trans_y, aC.trans_z, aC.rot_x, aC.rot_y, aC.rot_z];
    
    cd(savefiledir);
    clearvars -except Subject Session names R savefilename
    save(savefilename);
    
    headmotion.names = names;
    headmotion.R = R;

end

end
