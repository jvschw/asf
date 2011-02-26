function ExpInfo = runExampleCentralEL
%THIS PROGRAM PUTS TOGETHER 
% -CREATION OF TRIAL DEFINITION FILE (TRD)
% -RUNNING A MASKED PRIMING EXPERIMENT IN WHICH STIMULI ARE
%  CENTRALLY PRESENTED
% -POSTHOC CHECKING OF TIMING ERRORS
% -SIMPLE FACTORIAL DATA ANALYSIS
% -WITH EYETRACKING
%%ASF Jens Schwarzbach

%Cfg = []; %DEFAULT CONFIGURATION

%----------------------------------------------
%SETTINGS FOR EYETRACKING
Cfg.Eyetracking.useEyelink = 1; %0: no eye tracking, 1: eye tracking!!!
Cfg.Eyetracking.useEyelinkMouseMode = 0;
Cfg.Eyetracking.doDriftCorrection = 0;
if Cfg.Eyetracking.useEyelink == 1
    Cfg.Eyetracking.doCalibration = 1;
else 
    Cfg.Eyetracking.doCalibration = 0;
end
%----------------------------------------------

projectName = 'exampleCentralEL';
stdName = 'example.std';
logName = projectName;
Cfg.Eyetracking.edfName = [projectName, '.edf'];

%MAKE TRD FILE
trdName = makeExampleCentralTrd(projectName);

%RUN EXPERIMENT
ExpInfo = ASF(stdName, trdName, logName, Cfg);

ASF_timingDiagnosis(ExpInfo); %CONTROL TIMING 