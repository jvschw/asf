function ExpInfo = runExampleUpperLower
%THIS PROGRAM PUTS TOGETHER 
% -CREATION OF TRIAL DEFINITION FILE (TRD)
% -RUNNING A MASKED PRIMING EXPERIMENT IN WHICH STIMULI ARE PRESENTED ABOVE
%  OR BELOW THE HORIZONTAL MERIDIAN IN ORDER TO MAXIMIZE MASKING
% -POSTHOC CHECKING OF TIMING ERRORS
% -SIMPLE FACTORIAL DATA ANALYSIS + EXCLUSION OF TRIALS WITH TIMING ERRORS
%%ASF Jens Schwarzbach


Cfg.userDefinedSTMcolumns = 6; %DEFAULT CONFIGURATION
Cfg.userSuppliedTrialFunction = @ASF_showTrialMaskedPrimingUpperLower;

%ENFORCE A CERTAIN SCREEN RESOLUTION
Cfg.Screen.Resolution.width = 1024;
Cfg.Screen.Resolution.height = 768;
Cfg.Screen.Resolution.pixelSize = 32;
Cfg.Screen.refreshRateHz = 60; % Mac not yet tested

%PROJECT INFO FOR TRD AND LOGFILES
projectName = 'exampleUpperLower';
stdName = 'example.std';
logName = projectName;

%MAKE TRD FILE
trdName = makeExampleUpperLowerTrd(projectName);

%RUN EXPERIMENT
ExpInfo = ASF(stdName, trdName, logName, Cfg);

%EXTENDED TIMING CONTROL
diagMat = ASF_timingDiagnosis(ExpInfo); %CONTROL TIMING

%ANALYZE DATA
analyzeExampleUpperLower(logName, diagMat)