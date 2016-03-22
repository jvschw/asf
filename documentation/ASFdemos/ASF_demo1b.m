% ASF_demo1b demonstrates a simple masked priming experiment with:
%      skipping SyncTest
%      change of screen resolution
% Example call:
% ExpInfo = ASF_demo1b
function ExpInfo = ASF_demo1b
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', []); %FROM ASF's DEMO DIRECTORY
Cfg.Screen.skipSyncTests = 1;
Cfg.Screen.Resolution.width = 1024;
Cfg.Screen.Resolution.height = 768;
[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', Cfg); %FROM ASF's DEMO DIRECTORY
