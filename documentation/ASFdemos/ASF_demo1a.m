% ASF_demo1a demonstrates a simple masked priming experiment with:
%      skipping SyncTest
% Example call:
% ExpInfo = ASF_demo1a
function ExpInfo = ASF_demo1a
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', []); %FROM ASF's DEMO DIRECTORY
Cfg.Screen.skipSyncTests = 1;
Cfg.hasEndRTonPageInfo = 1; %BACKWARD COMPATIBILITY TO OLD WAY OF DEFINING TRDs

[ExpInfo] = ASF('Demo1_MAC.std', 'Demo1.trd', 'testsubject', Cfg); %FROM ASF's DEMO DIRECTORY
