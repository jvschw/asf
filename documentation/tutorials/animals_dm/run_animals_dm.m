%Macbook Pro Retina needs this when running without external monitor
Cfg.Screen.skipSyncTests = 0;
Cfg.Screen.Resolution.width = 1650; %1024;
Cfg.Screen.Resolution.height = 1050; %768;
Cfg.Screen.Resolution.pixelSize = 24;
Cfg.Screen.Resolution.hz = 0;

Cfg.randomizeTrials = 1;

ExpInfo = ASF('stimuli.std', 'trialdefs_12.trd', 'test3', Cfg);