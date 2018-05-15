function ExpInfo = run_dots
Cfg = [];
Cfg.userSuppliedTrialFunction = @ASF_showTrial_dotsXY;
Cfg.userDefinedSTMcolumns = 2; 
Cfg.randomizeTrials = 1;

% %Macbook Pro Retina needs this when running without external monitor
% Cfg.Screen.skipSyncTests = 0;
% Cfg.Screen.Resolution.width = 1650;
% Cfg.Screen.Resolution.height = 1050;
% Cfg.Screen.Resolution.pixelSize = 24;
% Cfg.Screen.Resolution.hz = 0;


ExpInfo = ASF('stimuli.std', 'trialdefs.trd', 'test', Cfg);

%for data analysis, try
analyze_dots(ExpInfo)