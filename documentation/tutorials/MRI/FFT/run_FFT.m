function ExpInfo = run_FFT(subjectID, session, run, Cfg)
%function ExpInfo = run_FFT(subjectID, session, run, Cfg)
%ExpInfo = run_FFT('Test', 1, 1, [])

Cfg.Screen.skipSyncTests = 1;
Cfg.Screen.color = [0, 0, 0];
%Cfg.Screen.Resolution.width = 1280;
%Cfg.Screen.Resolution.height = 800;
%Cfg.Screen.Resolution.pixelSize = 24;
Cfg.useTrialOnsetTimes = 1;
Cfg.nRep = 3;
[TRDfileName, Cfg] = makeTRD_FFT(subjectID, session, run, Cfg);
outDir = fullfile('.', 'logs');

%RUN EXPERIMENT
[ExpInfo] = ASF('FFT.std', TRDfileName, fullfile(outDir, sprintf('%s-%d-%d', subjectID, session, run)), Cfg); %FROM ASF's DEMO DIRECTORY

%MAKE PARAMETER FILES FOR FSL
makePars(subjectID, session, run)