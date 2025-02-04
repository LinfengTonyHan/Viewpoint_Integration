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

    save_folder = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/Localizer'];
    %% Defining contrasts

    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(strcat(save_folder,'/SPM.mat'));

    % Faces > Objects (FFA)
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Faces > Objects';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [0, 1, -1, 0, zeros(1, 7), 0, 1, -1, 0];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    % Scenes > Objects (Scene Perception)
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Scenes > Objects';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [1, 0, -1, 0, zeros(1, 7), 1, 0, -1, 0];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    % LOC
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Objects > ScrObjects';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.convec = [0, 0, 1, -1, zeros(1, 7), 0, 0, 1, -1];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

    % EVC
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'ScrObjects > None';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.convec = [0, 0, 0, 1, zeros(1, 7), 0, 0, 0, 1];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    % Scene > None
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Scenes > None';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.convec = [1, 0, 0, 0, zeros(1, 7), 1, 0, 0, 0];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    % Scenes > Faces
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Scenes > Faces';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.convec = [1, -1, 0, 0, zeros(1, 7), 1, -1, 0, 0];
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.delete = 1;
    spm_jobman('run',matlabbatch);

end