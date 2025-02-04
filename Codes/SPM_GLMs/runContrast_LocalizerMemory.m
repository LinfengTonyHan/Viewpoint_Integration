Subject = 'Subject028';
save_folder = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/LocalizerMemory'];

matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat = cellstr(strcat(save_folder,'/SPM.mat'));

% Faces > Objects (Face Memory)
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Faces > Scenes';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [1, -1];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

% Scenes > Faces (Scene Memory)
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Scenes > Faces';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [-1, 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 1;
spm_jobman('run',matlabbatch);