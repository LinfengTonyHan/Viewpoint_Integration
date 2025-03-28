%% Creating a t-map for each stimulus image
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
    
    save_folder = ['/Users/linfenghan/Desktop/DVIM_fMRI_Analysis/Analysis/Outputfiles/', Subject, '/JRD'];
    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(strcat(save_folder,'/SPM.mat'));
    
    for iteImage = 1:24
        matlabbatch{1}.spm.stats.con.consess{iteImage}.tcon.name = ['img', num2str(iteImage)];
       
        if subList(iteSub) == 14 % Missing responses in Run 4 or excessive head motion in Run 4    
            % Drop the 4th run due to missed behavioral response
            matlabbatch{1}.spm.stats.con.consess{iteImage}.tcon.convec = [zeros(1, iteImage - 1), 1, zeros(1, 30), 1, zeros(1, 30), 1, zeros(1, 30), 0];
        elseif subList(iteSub) == 19 
            matlabbatch{1}.spm.stats.con.consess{iteImage}.tcon.convec = [zeros(1, iteImage - 1), 1, zeros(1, 30), 1, zeros(1, 30), 1, zeros(1, 30), 0];
        elseif subList(iteSub) == 21
            matlabbatch{1}.spm.stats.con.consess{iteImage}.tcon.convec = [zeros(1, iteImage - 1), 1, zeros(1, 30), 1, zeros(1, 30), 1, zeros(1, 30), 1];
        else
            matlabbatch{1}.spm.stats.con.consess{iteImage}.tcon.convec = [zeros(1, iteImage - 1), 1, zeros(1, 30), 1, zeros(1, 30), 1, zeros(1, 30), 1];
        end
        
        %% 
        % Including all the runs
        % matlabbatch{1}.spm.stats.con.consess{iteImage}.tcon.convec = [zeros(1, iteImage - 1), 1, zeros(1, 30), 1, zeros(1, 30), 1, zeros(1, 30), 1];
        
        %% 
        matlabbatch{1}.spm.stats.con.consess{iteImage}.tcon.sessrep = 'none';
        matlabbatch{1}.spm.stats.con.delete = 1;

    end
    spm_jobman('run',matlabbatch);
    
end
