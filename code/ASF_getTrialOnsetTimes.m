function tOnset = ASF_getTrialOnsetTimes(ExpInfo)
%function tOnset = ASF_getTrialOnsetTimes(ExpInfo)

nTrials = length(ExpInfo.TrialInfo);
tOnset = zeros(nTrials, 1);
for iTrial = 1:nTrials
	tOnset(iTrial) = ExpInfo.TrialInfo(iTrial).timing(1, 2) - ExpInfo.Cfg.experimentStart;
end
