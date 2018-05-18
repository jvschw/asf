Cfg = []; %clear config
if ismac
    %Macbook Pro Retina needs this when running without external monitor
    Cfg.Screen.skipSyncTests = 0;
    Cfg.Screen.Resolution.width = 1650; %1024;
    Cfg.Screen.Resolution.height = 1050; %768;
    Cfg.Screen.Resolution.pixelSize = 24;
    Cfg.Screen.Resolution.hz = 0;
end

%GENERATE TRD-FILE ON THE FLY
makeTRD_animals_dm('trialdefs_full.trd')

%RUN EXPERIMENT WITH NEWLY CREATED TRD-FILE
ExpInfo = ASF('stimuli.std', 'trialdefs_full.trd', 'test4', Cfg);