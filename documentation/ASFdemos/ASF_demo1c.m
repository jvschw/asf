% ASF_demo1c demonstrates a simple masked priming experiment with:
%      skipping SyncTest
%      change of screen resolution
%      timing diagnosis at the end of the experiment
% Example call:
% ExpInfo = ASF_demo1c
function ExpInfo = ASF_demo1c
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', []); %FROM ASF's DEMO DIRECTORY
Cfg.Screen.skipSyncTests = 0;
%Cfg.Screen.Resolution.width = 1920;
%Cfg.Screen.Resolution.height = 1200;
Cfg.enableTimingDiagnosis = 1;
%Cfg.Screen.rect = [1, 1, 800, 600];
%Cfg.Screen.Resolution.hz = 60;
%Cfg.Screen.Resolution.pixelSize = 32;
Cfg.responseSettings.multiResponse = 'allowMultipleResponses';% {'allowSingleResponse', 'allowMultipleResponses', 'responseTerminatesTrial'
Cfg.userSuppliedTrialFunction = @ASF_ShowTrialMultiResponse;
Cfg.responseDevice = 'MOUSE'; %'KEYBOARD', 'MOUSE'
[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', Cfg); %FROM ASF's DEMO DIRECTORY
