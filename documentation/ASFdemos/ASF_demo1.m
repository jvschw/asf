function ExpInfo = ASF_demo1
%function ExpInfo = ASF_demo1
%ASF_demo1 demonstrates a simple masked priming experiment

Cfg.Screen.skipSyncTests = 0;
Cfg.enableTimingDiagnosis = 1;
Cfg.hasEndRTonPageInfo = 0; %BACKWARD COMPATIBILITY TO OLD WAY OF DEFINING TRDs

%UNCOMMENT FOR FORCING A CERTAIN SCREEN RESOLUTION
% Cfg.Screen.Resolution.width = 1024;
% Cfg.Screen.Resolution.height = 768;
% Cfg.Screen.Resolution.pixelSize = 32;
% Cfg.Screen.refreshRateHz = 60;

Cfg.environment = 'SONYVAYO-VGN';

switch Cfg.environment
    case 'SONYVAYO-VGN'
        Cfg.Screen.skipSyncTests = 1;
%         Cfg.Screen.Resolution.width = 1024;
%         Cfg.Screen.Resolution.height = 768;
%         Cfg.Screen.Resolution.pixelSize = 32;
%         Cfg.Screen.refreshRateHz = 60;
        
    case 'MR'
        %EPSON IN MR
        Cfg.Screen.xDimCm = 42;
        Cfg.Screen.yDimCm = 34;
        Cfg.Screen.distanceCm = 134;
        Cfg.synchToScanner = 1;
        Cfg.synchToScannerPort = 'SERIAL';
        Cfg.responseDevice = 'LUMINASERIAL';

    case 'DELLM70'
        %DELL M70
        Cfg.Screen.xDimCm = 33;
        Cfg.Screen.yDimCm = 20.625;
        Cfg.Screen.distanceCm = 45;
        %Cfg.responseDevice = 'KEYBOARD';
        Cfg.responseDevice = 'MOUSE';

    case 'DELLM6400'
        %DELL M6400
        Cfg.Screen.xDimCm = 33;
        Cfg.Screen.yDimCm = 20.625;
        Cfg.Screen.distanceCm = 45;
        %Cfg.responseDevice = 'KEYBOARD';
        Cfg.responseDevice = 'MOUSE';

        Cfg.Screen.Resolution.width = 1920;
        Cfg.Screen.Resolution.height = 1200;
        Cfg.Screen.refreshRateHz = 60;
        Cfg.Screen.Resolution.pixelSize = 32;
    case 'DELL1907'
        %%DELL 1907 WITH 1280 x 720 Screen resolution
        Cfg.Screen.xDimCm = 37.5;
        Cfg.Screen.yDimCm = 30;
        Cfg.Screen.distanceCm = 80;

    case 'DELL2407'
        %%DELL 2407WFP WITH 1280 x 720 Screen resolution
        Cfg.Screen.xDimCm = 53;
        Cfg.Screen.yDimCm = 29;
        Cfg.Screen.distanceCm = 80;
        
    case 'ASUSF3J'
        %%ASUS WITH 1280 x 800 Screen resolution 
        Cfg.Screen.xDimCm = 45;
        Cfg.Screen.yDimCm = 28;
        Cfg.Screen.distanceCm = 80; 
        Cfg.useBackBuffer = 0;

end



% [ExpInfo] = ASF('Demo1.std', 'Demo1a.trd', 'testsubject', Cfg); %FROM ASF's DEMO DIRECTORY
[ExpInfo] = ASF('Demo1.std', 'Demo1b.trd', 'testsubject', Cfg); %FROM ASF's DEMO DIRECTORY
% [ExpInfo] = ASF('Demo1.std', 'Demo1c.trd', 'testsubject', Cfg); %FROM ASF's DEMO DIRECTORY
% [ExpInfo] = ASF('Demo1.std', 'Demo1d.trd', 'testsubject', Cfg); %FROM ASF's DEMO DIRECTORY
