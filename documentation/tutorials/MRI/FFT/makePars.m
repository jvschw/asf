function makePars(subjectID, session, run)
%%example call:
%makePars('Test', 1, 1)
outDir = fullfile('.', 'logs');
logName = fullfile(outDir, sprintf('%s-%d-%d.mat', subjectID, session, run)); 
load(logName)
tOnset = ASF_getTrialOnsetTimes(ExpInfo);
res = ASF_readExpInfo(ExpInfo);
for iLevel = 1:ExpInfo.factorinfo.factorLevels
    thisLevelName = ExpInfo.factorinfo.levelNames{iLevel};
    cases = find(res(:, 1) == iLevel);
    nTrials = numel(cases);
    parName = fullfile(outDir, sprintf('%s-%d-%d-%s.txt', subjectID, session, run, thisLevelName));
    fid = fopen(parName, 'wt');
    fprintf(1, 'SAVING %s\n', parName);
    for iTrial = 1:nTrials
        fprintf(fid, '%7.3f\t 16.0\t1\t1\n', tOnset(cases(iTrial)));
    end
    fclose(fid);
end