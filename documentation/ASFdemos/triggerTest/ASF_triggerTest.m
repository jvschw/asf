function ExpInfo = ASF_triggerTest
%function ExpInfo = ASF_triggerTest
%
%jens.schwarzbach@unitn.it
Cfg.Screen.skipSyncTests = 0;
Cfg.enableTimingDiagnosis = 1;

Cfg.environment = 'DELLM6400';

switch Cfg.environment
    case 'MR'
        %EPSON IN MR
        Cfg.Screen.xDimCm = 42;
        Cfg.Screen.yDimCm = 34;
        Cfg.Screen.distanceCm = 134;
        Cfg.synchToScanner = 1;
        Cfg.synchToScannerPort = 'SERIAL';
        Cfg.responseDevice = 'LUMINASERIAL';

    case 'DELLM6400'
        %DELL M6400
        Cfg.Screen.xDimCm = 33;
        Cfg.Screen.yDimCm = 20.625;
        Cfg.Screen.distanceCm = 45;
        %Cfg.responseDevice = 'KEYBOARD';
%         Cfg.responseDevice = 'MOUSE';
%         Cfg.synchToScanner = 1;
%         Cfg.synchToScannerPort = 'SIMULATE';
%         Cfg.scannerSynchTimeOutMs = 2000;
        
        %ARDUINO EMULATED
        Cfg.serialPortName = 'COM4';
        Cfg.hardware.serial.BaudRate = 9600;
        Cfg.responseDevice = 'LUMINASERIAL';
        Cfg.synchToScanner = 1;
        Cfg.synchToScannerPort = 'SERIAL';
        Cfg.scannerSynchTimeOutMs = 2500;

        
        Cfg.Screen.Resolution.width = 1920;
        Cfg.Screen.Resolution.height = 1200;
        Cfg.Screen.refreshRateHz = 60;
        Cfg.Screen.Resolution.pixelSize = 32;
end

Cfg.userSuppliedTrialFunction = @ASF_showTrialTriggerTest;
Cfg.ScannerSynchShowDefaultMessage = 0;
logName = sprintf('TriggerTest_%s.mat', datestr(now, 'yyyymmddTHHMMSS'));
[ExpInfo] = ASF('ASF_triggerTest.std', 'ASF_triggerTest.trd', logName, Cfg); %FROM ASF's DEMO DIRECTORY
ExpInfo.TrialInfo(1).Response
[AX,H1,H2] = plotyy(ExpInfo.TrialInfo(1).Response.key, ExpInfo.TrialInfo(1).Response.RT, ExpInfo.TrialInfo(1).Response.key(2:end), diff(ExpInfo.TrialInfo(1).Response.RT)*1000);
set(get(AX(1), 'ylabel'), 'String', 'Elapsed [s]')
set(get(AX(2), 'ylabel'), 'String', 'TriggerOnset Asynchrony [ms]')
xlabel('Trigger Count')

