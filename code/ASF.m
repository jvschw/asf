function [ExpInfo] = ASF(stimNames, trialFileName, expName, Cfg)
% function [ExpInfo] = ASF(stimNames, trialFileName, expName, Cfg)
%
%-------------------------------------------------------------
% A SIMPLE
% MULTI PURPOSE PLAYBACK MACHINE FOR PSYCHOPHYSICS EXPERIMENTS
% created 20070107
% jens.schwarzbach@unitn.it
%-------------------------------------------------------------
%
%CONFIGURATIONS. Options are given in [] with default being between {}
%
%DISPLAY:
% Cfg.Screen.rect                       = [{[]}, [ulRowStart, ulColStart, ulRowEnd, ulColEnd] ]
% Cfg.Screen.useBackBuffer              = [ 0 | {1} ]   %USE AUXILIARY BACKBUFFERS FOR PAGE FLIPPING
% Cfg.Screen.color                      = [{[255, 255, 255]}|[R, G, B]] %DEFAULTS TO WHITE BACKGROUND
% Cfg.Screen.Resolution.width           = [{width of current video resolution}] %
% Cfg.Screen.Resolution.height          = [{heigth of current video resolution}]
% Cfg.Screen.Resolution.pixelSize       = [{color depth of current video resolution}]
% Cfg.Screen.Resolution.hz              = [{refresh rate of current video resolution}]
% Cfg.Screen.fontSize                   = [{24}]
% Cfg.Screen.fontName                   = {'Courier New'}
%
%SOUND:
% Cfg.Sound.soundMethod                 = [{'none'}|'psychportaudio'|'audioplayer'|'wavplay'|'snd']
%
%RESPONSE
% Cfg.responseDevice                    = [ {'MOUSE'}|'VOICEKEY'|'LUMINAPARALLEL'|'SERIAL'|'KEYBOARD' ]
% Cfg.responseTerminatesTrial           = [ {0}, 1 ]
% Cfg.waitUntilResponseAfterTrial       = [ {0}, 1 ]
% Cfg.plotVOT                           = [ {0}, 1 ]    %PLOT VOICE ONSET TIMES, REQUIRES TWO SCREENS
% Cfg.Eyetracking.useEyelink            = [ {0}, 1 ]    %USE EYELINK
% Cfg.Eyetracking.useEyelinkMouseMode   = [ {0}, 1 ]    %SIMULATE EYE BY MOUSE
%
%TRIGGERING
% Cfg.issueTriggers                     = [ {0} | 1 ] %ALLOWS TRIGGERING, REQUIRES DATA ACQUISITION TOOLBOX
% Cfg.validTriggerValues                = [{[]}, vectorOfValues] %ALLOWS RESTRICTING WHICH PAGES RELEASE A TRIGGER [] means all valid
% Cfg.synchToScanner                    = [ {0} | 1 ] %WAIT FOR EXTERNAL SIGNAL (E.G. TRIGGER FROM MR-SCANNER)
% Cfg.synchToScannerPort                = [{'PARALLEL'}|'SERIAL', 'SIMULATE']; %PORT FOR EXTERNAL SYNCH SIGNAL
% Cfg.scannerSynchTimeOutMs             = [ {inf} ] %TIMEOT IN MILLISECONDS WHEN WAITING FOR SCANNER TRIGGER ON ANY PORT
% Cfg.digitalInputDevice                = [ {'NONE'}|'PARALLEL'|'NIDAQ2' ]
% Cfg.digitalOutputDevice               = [ {'NONE'}|'PARALLEL'|'NIDAQ2' ]
% Cfg.ScannerSynchShowDefaultMessage    = [0|{1}]
% Cfg.scannerSynchTimeOutMs             = {inf} %BY DEFAULT WAIT FOREVER
% Cfg.serialPortName                    = [ {'COM1'}, ... 'COMn' ]
%
%TIMING
%Cfg.useTrialOnsetTimes                 = [ {0} | 1 ] %THIRD COLUMN IN TRIAL-DEFINITION FILE DETERMINES WHEN TRIAL IS STARTED WR TO START OF EXPT
%
%FEEDBACK
%Cfg.feedbackTrialCorrect               = [ {0} | 1 ] %BEEP FOR CORRECT RESPONSES %WILL BECOME FREQUENCY AND DURATION
%Cfg.feedbackTrialError                 = [ {0} | 1 ] %BEEP FOR INCORRECT RESPONSES %WILL BECOME FREQUENCY AND DURATION
%
%USER SUPPLIED
%Cfg.userSuppliedTrialFunction          = [ {[]} | FUNCTIONHANDLE ]
%Cfg.userDefinedSTMcolumns              = [ {0} | nColumns ]
%
%MISC
% Cfg.randomizeTrials                   = [ {0} | 1 ] %TRIALWISE RANDOMIZATION OF CONTENT OF STM-FILE
% Cfg.randomizeTrialsNoImmediateRepeat  = [ {0} | 1 ] %RESTRICTED RANDOMIZATION
%
%
%%EXAMPLE CALL
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', []) %FROM ASF's DEMO DIRECTORY
%
%%SAME WITH KEYBOARD INSTEAD OF MOUSE
%Cfg.responseDevice = 'KEYBOARD'
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', Cfg) %FROM ASF's DEMO DIRECTORY
%
%%SAME BUT RUNNING IN THE MR WITH LUMINA BOX
% %EPSON IN MR
% Cfg.Screen.xDimCm = 42;
% Cfg.Screen.yDimCm = 34;
% Cfg.Screen.distanceCm = 134;
% Cfg.synchToScanner = 1;
% Cfg.useTrialOnsetTimes = 1;
% Cfg.synchToScannerPort = 'SERIAL';
% Cfg.responseDevice = 'LUMINASERIAL';
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', Cfg) %FROM ASF's DEMO DIRECTORY
%
%
%%VOICEKEY, PARALLEL PORT, OLD COMPUTER
%Cfg.Screen.useBackBuffer = 0; %OLD COMPUTER
%Cfg.Screen.rect = [1, 1, 640, 480]; %USE PART OF THE SCREEN
%Cfg.responseDevice = 'VOICEKEY';
%Cfg.issueTriggers = 1;
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', Cfg) %FROM ASF's DEMO DIRECTORY
%
%
%%MEG PICTURENAMING STUDY ON INSPIRON
%Cfg.Screen.useBackBuffer = 0; %OLD COMPUTER
%Cfg.responseDevice = 'VOICEKEY';
%Cfg.issueTriggers = 1;
%Cfg.plotVOT = 1; %CREATES AN ONLINE DISPLAY FOR VOICE RECORDING AND VoiceOnsetTimes
%ExpInfo = ASF('MEG_PICTURENAMING.TXT', 'MEG_PICTURENAMING.STM', 'TEST', Cfg)
%
%%FMRI EXPERIMENTS USING A FILE FOR TRIAL ONSET TIMING
%Cfg.useTrialOnsetTimes = 1;
%Cfg.feedbackTrialError = 1;
% [ExpInfo] = ASF('test.std', 'test.trd', 'testsubject', Cfg) %FROM ASF's HOME DIRECTORY
%
%%EXPERIMENTAL: USER SUPPLIED TRIAL PRESENTATION FUNCTION
%Cfg.userSuppliedTrialFunction = @ShowTrialAuditoryOddball;
% [ExpInfo] = ASF('test.std', 'test.trd', 'testsubject', Cfg) %FROM ASF's HOME DIRECTORY
%
%%EXPERIMENTAL: USER SUPPLIED STM COLUMNS
%Cfg.userDefinedSTMcolumns = 3;
%[ExpInfo] = ASF('stimdef.txt', 'OrcoMRTilt2_al_01.stm', 'generic_xx_01', Cfg) %FROM ASF's HOME DIRECTORY
%
%%EXPERIMENTAL: USE EYELINK IN MOUSE MODE
%Cfg.Screen.rect = [1, 1, 640, 480];
%Cfg.Eyetracking.useEyelink = 1;
%Cfg.Eyetracking.useEyelinkMouseMode = 1;
%[ExpInfo] = ASF('Demo1.std', 'Demo1.trd', 'testsubject', Cfg) %FROM ASF's HOME DIRECTORY
%
%
%20070620 ADDED     VERSION ENTRY TO Cfg
%20070620 REMOVED   "WaitSecs(0.001);" IN WaitForMousePress FUNCTION
%20070622 ADDED     VoiceKey functionality
%20070622 ADDED     TRIGGER OUTPUT FOR MEG/EEG (requires data acquisition toolbox)
%20070624 ADDED     NONDESTRUCTIVE FLIPPING
%20070710 ADDED     SYNCHRONIZATION TO EXTERNAL TRIGGERS
%20070906 ADDED     GRACEFUL EXIT WHEN STM or STIMDEF FILES ARE NOT FOUND
%20070906 ADDED     TRIAL ONSET TIMES ARE NOW CODED IN THE SECOND COLUMN OF STM FILES
%                   USER CAN DECIDE WHETHER TO USE OR IGNORE THEM BY
%                   SETTING Cfg.useTrialOnsetTimes FLAG
%20070906 ADDED     TRIAL BY TRIAL FEEDBACK: Cfg.feedbackTrialCorrect, Cfg.feedbackTrialError
%20070906 ADDED     GRACEFUL EXIT WHEN PRESSING THE q BUTTON REPEATEDLY
%20070930 ADDED     READ TEXT AND SOUND STIMULI
%20071010 FIXED     REMOVED ERROR THAT OCCURRED WHEN NO DATA ACQUISITION TOOLBOX WAS INSTALLED
%20071103 FIXED     INCREASED MEMORY EFFICIENCY (ALTHOUGH STILL ROOM FOR IMPROVEMENTS)
%20071128 CHANGED   PTB_Init does not return rect directly any more, the screen rect is now Cfg.Screen.rect
%20071202 CHANGED   starting to adjust all variable names according to mixedCase convention.
%                   This means, that variables start lower case and each new word with upper case.
%                   BUT: structures start with upper case, e.g. Cfg, Cfg.Screen etc.
%                   Example: cfg.UseBackBuffer became Cfg.useBackBuffer
%                   (which in the meantime has changed again to Cfg.Screen.useBackBuffer)
%                   THIS WILL AFFECT PLUGINS WRITTEN BY USERS BASED ON PREVIOUS TEMPLATES
%20071203 ADDED     KEYBOARD as possible response device
%20071203 ADDED     FEEDBACK: COMMAND WINDOW SHOWS RT AND KEY FOR EACH TRIAL
%20080114 CHANGED   HANDLING OF DIGITAL IO, NOW DIGITAL INPUT CAN BE DONE
%                   ON DIFFERENT HARDWARE THAN DIGITAL OUTPUT (SO FAR PARALLEL PORT AND NIDAQ)
%20080114 ADDED     TMS DEMO
%20080126 ADDED     EYELINK CODE AND DEMO (AL)
%20080219 ADDED     RANDOMIZATION WITH RESTRICTION
%20080607 ADDED     SCREEN RESOLUTION AND REFRESH RATE CONFIGURABLE, DEFAULT 1024x768@60Hz
%20080707 ADDED     BUGFIX RT REPORTED WRONGLY WHEN USING LUMINA BOX ON SERIAL PORT
%20080707 ADDED     EYELINK LOGS ONSET OF EVERY PAGE
%20080725 ADDED     TRD FILE ALSO CONTAIN FACTOR NAMES (DOWNWARD COMPATIBILITY WITH TRD FILES THAT DON'T HAVE THIS FEATURE)
%20081014 ADDED     TMS BURST MODE USING NI-CARD
%20081127 BUGFIX    RT TIMES ARE NOW CORRECTLY RECORDED USING THE LUMINA SERIAL BOX (HOWEVER IT DISCARDS SIMULTANEOUS BUTTON PRESSES AT THIS TIME)
%20081205 ADDED     parameter Cfg.enableTimingDiagnosis TIMING DIAGNOSIS IS OFF BY DEFAULT, BECAUSE IT HAS CREATED TROUBLE WITH USER PLUGINS
%20081205 BUGFIX    Cfg.defaultFontSize and Cfg.Screen.defaultTextColor NOW BEHAVE PROPERLY
%20081205 BUGFIX    OLDER BUILDS OF PTB DID NOT KNOW Screen('Resolutions'), this command is now ignored by older builds; Will soon change to: Program exists and requests update of PTB
%20090127 CHANGED   Cfg.defaultFontSize is called Cfg.Screen.fontSize
%20090127 CHANGED   Cfg.Screen.defaultTextColor is called Cfg.Screen.textColor
%20090127 ADDED     Cfg.Screen.fontName lets you determine which font ASF uses (default 'Courier')
%20090127 CHANGED   internal variable Cfg.MonitorFlipInterval renamed to Cfg.Screen.monitorFlipInterval
%20090127 CHANGED   internal variable Cfg.newResolution renamed to Cfg.Screen.NewResolution (it's a structure)
%20090127 CHANGED   All EyeLink related cfg settings (useEyelink, doDriftCorrection, doCalibration, useEyelinkMouseMode, edfLargeCalibrationTargets, edfName) are now moved to a structure Cfg.Eyetracking
%20090127 CHANGED   Cfg.useBackBuffer to Cfg.Screen.useBackBuffer (ATTENTION: this may require updating of user-supplied trial functions; ASF forces functions to crash that do not comply)
%20090223 BUGFIX    fixed some internal inconsistencies (Cfg was still sometimes called cfg)
%20090223 ADDED     when no suitable graphics mode can be found, program now provides list of available modes
%20090228 ADDED     simulated synchronization to scanner, see Cfg.synchToScannerPort
%20090302 CHANGED   previously undocumented feature of configurable timeout when waiting for trigger pulses
%                   was treated separately for different ports (Cfg.timeOutWaitSerial, Cfg.timeOutWaitParallel).
%                   This has been replaced by a unified setting Cfg.scannerSynchTimeOutMs with default value of inf.
%20090302 BUGFIX    removed all references to hardware from ExpInfo at exit. Remaining hardware objects
%                   have been creating problems when loading results on a computer othe than the
%                   experimental computer (different harware, different toolboxes, different OS)
%20090303 BUGFIX    Accessing an external function for the first time can require hundreds of milliseconds.
%                   This may create timing inaccuracies. ASF_waitForScannerSynch, ASF_waitForResponse are now
%                   preloaded by ASFInit.
%20090325 CHANGED   ASF_timing_diagnostics can handle trials that only show two pages
%20090325 ADDED     Now you can change the serial port through which ASF communicates with the Lumina box.
%                   Default setting is Cfg.serialPortName = 'COM1'
%20090519           V 0.38
%20090519 BUGFIX    Possible crash at startup because the default screen resolution may not be available. Now, ASF's default screen resolution is
%                   the one that the computer is currently in
%20090525 ADDED     Checks for the presence of requested std and trd file before initializing graphics
%20091019 CHANGED   All ASF-functions follow this naming convention ASF_doThisAndThat.m
%                   (this may require many changes in your self-written programs). See documentation about how to do this with little effort
%20091021 ADDED     Cfg.Screen.skipSyncTests needed to run ASF on certain systems
%20091021 CHANGED   the way ASF tried to ensure that PTB functions for
%                   hardware commands exist has been updated because it did not catch some
%                   problems. This led to errors upon program termination with data loss
%20100118 BUGFIX    initialization of parallel port now updates Cfg structure
%V.041
%20100314 BUGFIX    some Eyelink-related structures (driftCorrection was not properly named)
%20100314 ADDED     Current OS's screen settings are used as default screen settings (before ASF tried to force machine into certain setting)
%20100314 CHANGED   Current OS's screen settings are used as default screen settings (before ASF tried to force machine into certain setting)
%V.042
%V.043              
%20101222 ADDED     support for PsychPortAudio
%20110106 ADDED     Valid trigger values
%
%TO DOs
%rename Cfg.hardware to Cfg.Hardware
%add MEG related hardware inits
%
%KNOWN ISSUES:
%there are problems configuring ASF for ATI graphics boards. Please report
%with a screendump that lets me understand all Cfg - settings to jens.schwarzbach@unitn.it
%

%% ***ASF-MAIN LOOP***

%DEFAULT CONFIGURATION
Cfg.ASFVersion = 0.43;
%SCREEN SETTINGS
if ~isfield(Cfg, 'Screen'), Cfg.Screen = []; else end;
if ~isfield(Cfg.Screen, 'skipSyncTests'), Cfg.Screen.skipSyncTests = 0; else end;
if ~isfield(Cfg.Screen, 'rect'), Cfg.Screen.rect = []; else end; %Cfg.Screen.rect = [1, 1, 320, 240]
if ~isfield(Cfg.Screen, 'color'), Cfg.Screen.color = [255, 255, 255]; else end;% [{[255, 255, 255]}|[R, G, B]]
%NEED TO REWORK THE ENTIRE SCREEN RESOLUTION SETUP
%if ~isfield(Cfg.Screen, 'Resolution'), Cfg.Screen.Resolution = []; else end; %the rest of this structure is set it PTBInit
%MatlabResolutionNow = get(0, 'ScreenSize');
%if ~isfield(Cfg.Screen, 'useDefaultResolution'), Cfg.Screen.useDefaultResolution = 1; else end;
%if ~isfield(Cfg.Screen.Resolution, 'width'), Cfg.Screen.Resolution.width = MatlabResolutionNow(3); else end;
%if ~isfield(Cfg.Screen.Resolution, 'height'), Cfg.Screen.Resolution.height = MatlabResolutionNow(4); else end;
%if ~isfield(Cfg.Screen.Resolution, 'pixelSize'), Cfg.Screen.Resolution.pixelSize = 32; else end;
%if ~isfield(Cfg.Screen, 'refreshRateHz'), Cfg.Screen.Resolution.hz = 60; else end;
if ~isfield(Cfg.Screen, 'fontSize'), Cfg.Screen.fontSize = 24; end;
if ~isfield(Cfg.Screen, 'fontName'), Cfg.Screen.fontName = 'Courier New'; end;
%SHOULD BE CALLED Cfg.Screen.useBackBuffer
if ~isfield(Cfg, 'useBackBuffer')
    Cfg.Screen.useBackBuffer = 1;
else
    fprintf(1, 'WARNING Cfg.useBackBuffer should be called Cfg.Screen.useBackBuffer\n');
    Cfg = rmfield(Cfg, 'useBackBuffer');
end
if ~isfield(Cfg.Screen, 'useBackBuffer'), Cfg.Screen.useBackBuffer = 1; else end;

%SOUND SUPPORT
if ~isfield(Cfg, 'Sound'), Cfg.Sound= []; else end;
if ~isfield(Cfg.Sound, 'soundMethod'), Cfg.Sound.soundMethod = 'none'; else end; %[{'none'}|'psychportaudio'|'audioplayer'|'wavplay'|'snd']

%TRIAL EXECUTION SETTINGS USED IN SHOWTRIAL AND POSSIBLY USED IN USER
%DEFINED TRIAL FUNCTION
if ~isfield(Cfg, 'userSuppliedTrialFunction'), Cfg.userSuppliedTrialFunction = []; else end;
if ~isfield(Cfg, 'userDefinedSTMcolumns'), Cfg.userDefinedSTMcolumns = 0; else end;
if ~isfield(Cfg, 'readTextStimuli'), Cfg.readTextStimuli = []; else end;
if ~isfield(Cfg, 'readSoundStimuli'), Cfg.readSoundStimuli = []; else end;
if ~isfield(Cfg, 'responseTerminatesTrial'), Cfg.responseTerminatesTrial = 0; else end;
if ~isfield(Cfg, 'randomizeTrials'), Cfg.randomizeTrials = 0; else end;
if ~isfield(Cfg, 'randomizeTrialsNoImmediateRepeat'), Cfg.randomizeTrialsNoImmediateRepeat = 0; else Cfg.randomizeTrials = 1; end;
if ~isfield(Cfg, 'waitUntilResponseAfterTrial'), Cfg.waitUntilResponseAfterTrial = 0; else end;
if ~isfield(Cfg, 'useTrialOnsetTimes'), Cfg.useTrialOnsetTimes = 0; else end;
if ~isfield(Cfg, 'feedbackTrialCorrect'), Cfg.feedbackTrialCorrect = 0; else Cfg.sndOK = MakeBeep(1000, 0.1);end;
if ~isfield(Cfg, 'feedbackTrialError'), Cfg.feedbackTrialError = 0; else Cfg.sndERR = MakeBeep(500, 0.1);end;
if ~isfield(Cfg, 'onlineFeedback'), Cfg.onlineFeedback = 0; else end; %[{0}|1]
if ~isfield(Cfg, 'writeVideo'), Cfg.writeVideo = 0; else end;
if ~isfield(Cfg, 'videoIndexStepSize'), Cfg.videoIndexStepSize = 1; else end; %FOR READING AVIs (e.g. 1: read all frames; 3: read every third frame) 
%NOT SURE WETHER THIS WILL STAY
if ~isfield(Cfg, 'task'), Cfg.task = 'default'; else end; %ALTERNATIVES: [ {'DEFAULT'}, 'AUDITORYODDBALL' ]

%MISC STIMULATION DEVICE SETTINGS
%OTHER STIMULATION DEVICES:
if ~isfield(Cfg, 'StimulationDevices'), Cfg.StimulationDevices = []; else end;
if ~isfield(Cfg.StimulationDevices, 'usePiezo'), Cfg.StimulationDevices.usePiezo = 0; else end; %[{0}|1]

if ~isfield(Cfg, 'hardware'), Cfg.hardware = []; else end;
%ARDUINO
if ~isfield(Cfg.hardware, 'Arduino'), Cfg.hardware.Arduino = []; else end;
if ~isfield(Cfg.hardware.Arduino, 'useArduino'), Cfg.hardware.Arduino.useArduino = 0; else end; 
if ~isfield(Cfg.hardware.Arduino, 'comPort'), Cfg.hardware.Arduino.comPort = []; else end;
if ~isfield(Cfg.hardware.Arduino.comPort, 'port'), Cfg.hardware.Arduino.comPort.port = 'COM4'; else end;
if ~isfield(Cfg.hardware.Arduino.comPort, 'baudRate'), Cfg.hardware.Arduino.comPort.baudRate = 9600; else end;


%RESPONSE DEVICE SETTINGS
if ~isfield(Cfg, 'responseDevice'), Cfg.responseDevice = 'MOUSE'; else end; %[ {'MOUSE'}|'VOICEKEY'|'LUMINAPARALLEL'|'SERIAL'|'KEYBOARD' ]
if ~isfield(Cfg, 'plotVOT'), Cfg.plotVOT = 0; else end;
if ~isfield(Cfg, 'digitalInputDevice'), Cfg.digitalInputDevice = 'NONE'; else end; %[ {'NONE'}|'PARALLEL'|'NIDAQ2' ]
if ~isfield(Cfg, 'digitalOutputDevice'), Cfg.digitalOutputDevice = 'NONE'; else end; %[ {'NONE'}|'PARALLEL'|'NIDAQ2' ]
if ~isfield(Cfg, 'issueTriggers'), Cfg.issueTriggers = 0; else end; %[{0}|1]
if ~isfield(Cfg, 'validTriggerValues'), Cfg.validTriggerValues = []; else end; %[{[]}, vectorOfValues] %[] means all valid
if ~isfield(Cfg, 'synchToScanner'), Cfg.synchToScanner = 0; else end; %[{0}|1]
if ~isfield(Cfg, 'ScannerSynchShowDefaultMessage'), Cfg.ScannerSynchShowDefaultMessage = 1; else end; %[0|{1}]
if ~isfield(Cfg, 'synchToScannerPort'), Cfg.synchToScannerPort = 'PARALLEL'; else end; %[{'PARALLEL'}|'SERIAL']
if ~isfield(Cfg, 'scannerSynchTimeOutMs'), Cfg.scannerSynchTimeOutMs= inf; else end; %BY DEFAULT WAIT FOREVER
%if ~isfield(Cfg, 'timeOutWaitSerial'), Cfg.timeOutWaitSerial = inf; else end; %BY DEFAULT WAIT FOREVER
%if ~isfield(Cfg, 'timeOutWaitParallel'), Cfg.timeOutWaitParallel = 300; else end;
if ~isfield(Cfg, 'Fs'), Cfg.Fs = 44100; else end;
if ~isfield(Cfg, 'serialPortName'), Cfg.serialPortName = 'COM1'; else end

%EYE TRACKING
if ~isfield(Cfg, 'Eyetracking'), Cfg.Eyetracking = []; else end;
if ~isfield(Cfg.Eyetracking, 'useEyelink'), Cfg.Eyetracking.useEyelink = 0;  else end; %USE EYELINK [ {0}, 1 ]
if ~isfield(Cfg.Eyetracking, 'doDriftCorrection'), Cfg.Eyetracking.doDriftCorrection = 0; else end;
if ~isfield(Cfg.Eyetracking, 'doCalibration'), Cfg.Eyetracking.doCalibration = 0; else end;
%if ~isfield(Cfg.Eyetracking, 'edfLargeCalibrationTargets'), Cfg.Eyetracking.edfLargeCalibrationTargets = []; else end; %{[], 1}
if ~isfield(Cfg.Eyetracking, 'useEyelinkMouseMode'), Cfg.Eyetracking.useEyelinkMouseMode = 0; else end; %SIMULATE EYE BY MOUSE useEyelinkMouseMode [ {0}, 1 ]
if ~isfield(Cfg.Eyetracking, 'edfName'), Cfg.Eyetracking.edfName = 'demo.edf'; else end;

%TMS
%burstMode should be renamed BurstMode, since it is a structure
if ~isfield(Cfg, 'burstModeTMS')
    Cfg.TMS.burstMode.on = 0;
    Cfg.TMS.burstMode.freqHz = 0;
    Cfg.TMS.burstMode.nPulses = 0;
else
    if ~isfield(Cfg.TMS.burstMode, 'freqHz')
        error('ASF_CONFIG_ERROR', 'No frequency provided for TMS bursts') %#ok<CTPCT>
    end
    if ~isfield(Cfg.TMS.burstMode, 'nPulses')
        error('ASF_CONFIG_ERROR', 'Number of pulses for TMS bursts not provided') %#ok<CTPCT>
    end
end
%AT PROGRAM CHECKOUT
if ~isfield(Cfg, 'enableTimingDiagnosis'), Cfg.enableTimingDiagnosis = 0; else end; %DEFAULT NO TIMING DIAGNOSIS BECAUSE IT CREATES TROUBLE WITH MOST USER SUPPLIED TRIAL FUNCTION

Cfg.stimNames = stimNames; %'stimdef.txt';
Cfg.trialFileName = trialFileName;%'test.stm';

%try
%     Normally, only the statements between the TRY and CATCH are executed.
%     However, if an error occurs while executing any of the statements, the
%     error is captured into LASTERR and the statements between the CATCH
%     and END are executed.  If an error occurs within the CATCH statements,
%     execution will stop unless caught by another TRY...CATCH block.  The
%     error string produced by a failed TRY block can be obtained with
%     LASTERR.


%------------------------------------------------------------------
% INITIALIZATION
%------------------------------------------------------------------
[ExpInfo, Cfg, trial, windowPtr, Stimuli] = ASFInit(Cfg, expName);

%------------------------------------------------------------------
% EYELINK
%------------------------------------------------------------------
if Cfg.Eyetracking.useEyelink
    %[edfFile, Cfg.el, status, stopkey, startkey, eye_used] = ASF_initEyelinkConnection(Cfg.Eyetracking.useEyelinkMouseMode, windowPtr, Cfg.Eyetracking.edfName);
    [edfFile, Cfg.el, Cfg.Eyetracking.status, Cfg.Eyetracking.stopkey, Cfg.Eyetracking.startkey, Cfg.Eyetracking.eye_used] = ASF_initEyelinkConnection(Cfg.Eyetracking.useEyelinkMouseMode, Cfg.Eyetracking.doCalibration, Cfg.Eyetracking.doDriftCorr, windowPtr, Cfg.Eyetracking.edfName, Cfg.Eyetracking.edfLargeCalibrationTargets);
end
%------------------------------------------------------------------

%------------------------------------------------------------------
% START EXPERIMENT AND LOOP THROUGH TRIALS
%------------------------------------------------------------------
Cfg.nTrials = length(trial); %determine number of trials to present

%DEPENDING ON DIFFERENT CONFIGURATION SETTINGS THE PROGRAM USES
%DIFFERENT BUILT IN OR USER-SUPPLIED FUNCTIONS TO PRESENT A TRIAL
ASFSHOWTRIAL = determineRenderingFunction(Cfg);

%EXPERIMENTAL CACHING OF FUNCTION POINTERS
hASFWAITFORRESPONSE= @ASF_waitForResponse; %#ok<NASGU> %CHECK WHETHER THIS SPEEDS UP THE FIRST TRIAL OR NOT
hASFXFLIP = @ASF_xFlip; %#ok<NASGU>

%SYNCHRONIZATION TO MR SCANNER
if Cfg.synchToScanner
    ASF_waitForScannerSynch(windowPtr, Cfg);
end
Cfg.experimentStart = GetSecs; %store time when experiment was started
%WAIT FOR ADDITIONAL PULSES?
if Cfg.synchToScanner > 1
    for iCount = 1:Cfg.synchToScanner-1
        ASF_waitForScannerSynch(windowPtr, Cfg);
    end
end

%------------------------------------------------------------------
% EYELINK
%------------------------------------------------------------------
if Cfg.Eyetracking.useEyelink
    status=Eyelink('message', 'EXPERIMENTSTART');
end
%------------------------------------------------------------------

if Cfg.onlineFeedback
    ASF_onlineFeedback(ExpInfo, trial, [], 0)
end

for i = 1:Cfg.nTrials
    %s = whos;
    %fprintf(1, '%12d bytes used\n', sum(vertcat(s.bytes)));
    fprintf(1, 'TRIAL %3d/%d: ', i, Cfg.nTrials); %feedback on operator screen
    
    %THIS WILL HAVE TO BE DONE AT A LATER POINT
    %IT WOULD HAVE BEEN EASY WITH BITMAPS ONLY
    %BUT I NEED TO COME UP WITH A WAY THAT TELLS ME FOR VIDEOS
    %TO WHICH VIDEO AND FRAME NUMBER A CERTAIN pageNumber RELATES
    %AND ALL OF THIS WITHOUT ACTUALLY READING THE VIDEOS BECAUSE
    %THAT WOUL PARTIALLY DEFEAT THE PUTPOSE OF ONLINE LOADING
    %     Cfg.loadStimuliDuringExperiment = 1;
%     if Cfg.loadStimuliDuringExperiment
%         idxUsedStimuli = unique(trial(i).pageNumber);
%             [errorFlag, aStimulus, frameCounter] =...
%         ASF_readStimulus(stimNames{iStimulus}, windowPtr, Cfg);
%     end

    %SHOW TRIAL
    Cfg.currentTrialNumber = i;
    this_TrialInfo = ASFSHOWTRIAL(trial(i), windowPtr, Stimuli, Cfg);
    %PREALLOCATE MEMORY FOR TRIALS
    if i == 1
        TrialInfo = repmat(this_TrialInfo, [1, Cfg.nTrials]);
    end
    %CONSIDER ADDING A CHECK HERE WHETHER ALL FIELDS IN TRIALINFO EXIST
    %ESPECIALLY PROGRAMMERS OF PLUGIN FNCTIONS MAY FORGET SOMETHING
    %check_trialinfo(TrialInfo(i));
    TrialInfo(i) = this_TrialInfo;

    if Cfg.onlineFeedback
        %FEEDBACK ON OPERATOR SCREEN
        fprintf(1, 'RT: %4d ms, KEY: %4d, CORRECT: %4d\n', fix(TrialInfo(i).Response.RT), TrialInfo(i).Response.key, trial(i).correctResponse);
        ASF_onlineFeedback(ExpInfo, trial, TrialInfo, i)
    else
        fprintf(1, 'RT: %4d ms, KEY: %4d, CORRECT: %4d\n', fix(TrialInfo(i).Response.RT), TrialInfo(i).Response.key, trial(i).correctResponse);
    end

    %------------------------------------------------------------------
    % EYELINK
    %------------------------------------------------------------------
    if Cfg.Eyetracking.useEyelink
        %              if(err~=0)
        %                 error('checkrecording problem, status: %d', err)
        %                 break;
        %             end
        %el.TRIAL_OK = 0;
        Cfg.Eyetracking.status = Eyelink('message', 'TRIALEND');

        [~, ~, keyCode] = KbCheck;
        % if spacebar was pressed stop display
        if keyCode(Cfg.Eyetracking.stopkey)
            break;
        end
    end
    %------------------------------------------------------------------

    %fprintf(1, '\n');

    %FOR MEMORY DEBUGGING
    %s = whos;
    %fprintf(1, '%12d bytes used\n', sum(vertcat(s.bytes)));

    %out = imaqmem;
    %mem_left = out.FrameMemoryLimit - out.FrameMemoryUsed
end

%     %SYNCHRONIZATION TO MR SCANNER
%     if Cfg.synchToScanner
%         for i=1:10
%             WaitForScannerSynch(windowPtr, Cfg);
%         end
%     end

%------------------------------------------------------------------
%SHUTDOWN PROGRAM
%------------------------------------------------------------------
%RELEASE TEXTURES
Screen('Close', Stimuli.tex);

%CLOSE WINDOWS, FORCE DELETE TEXTURES
Cfg = ASF_PTBExit(windowPtr, Cfg, 0);

%SAVE DATA
ExpInfo.Cfg = Cfg;
ExpInfo.TrialInfo = TrialInfo;
cmd = sprintf('save %s ExpInfo', expName);
eval(cmd)

%------------------------------------------------------------------
% EYELINK
%------------------------------------------------------------------
if Cfg.Eyetracking.useEyelink
    ASF_shutDownEyelink(status, edfFile);
end


%CREATES A SURFACE PLOT THAT SHOWS TIMING DEVIATIONS FOR EACH PAGE IN
%EACH TRIAL
if Cfg.enableTimingDiagnosis
    timing_diagnosis(ExpInfo)
end

% catch
%     % catch error
%     PTBCatchError
% end % try ... catch %



return

%% ***INITIALIZATION ROUTINES***
%% ASFInit
function [ExpInfo, Cfg, trial, windowPtr, Stimuli] = ASFInit(Cfg, expName)

fprintf(1, '***********************\n');
fprintf(1, '*** ASF VERSION %5.3f ***\n', Cfg.ASFVersion);
fprintf(1, '***********************\n');

%CHECK WHETHER INPUT FILES EXIST
fprintf(1, 'CHECKING FOR %s ... ', Cfg.stimNames);
if exist(Cfg.stimNames, 'file') == 2
    fprintf(1, 'OK.\n');
else
    fprintf(1, 'does not exist. Program aborted\n');
    return
end

fprintf(1, 'CHECKING FOR %s ... ', Cfg.trialFileName);
if exist(Cfg.trialFileName, 'file') == 2
    fprintf(1, 'OK.\n');
else
    fprintf(1, 'does not exist. Program aborted\n');
    return
end


%INIT HARDWARE
% Check for OpenGL compatability
fprintf(1, 'CHECKING OpenGL compatibility ...');
AssertOpenGL;
fprintf(1, 'OK\n');


%INIT SOUND
if ~isfield(Cfg.Sound, 'fSample'), Cfg.Sound.fSample = 44100; else end;
if ~isfield(Cfg.Sound, 'nBits'), Cfg.Sound.nBits = 16; else end
if ~isfield(Cfg.Sound, 'nChannels'), Cfg.Sound.nChannels = 2; else end

switch Cfg.Sound.soundMethod
    case {'audioplayer', 'wavplay'}
        warning('audioplayer and wavplay not yet properly implemented')
        
    case 'psychportaudio'
        
        %INIT PSYCHPORTAUDIO
        % Perform basic initialization of the sound driver:
        InitializePsychSound(1)
        PsychPortAudio('Verbosity', 0)
        % Open the default audio device [], with default mode [] (==Only playback),
        % and a required latencyclass of one 1 == low-latency mode, as well as
        % a frequency of freq and nrchannels sound channels.
        % This returns a handle to the audio device:
        Cfg.Sound.pahandle = PsychPortAudio('Open',...
            [], [], 4, Cfg.Sound.fSample, Cfg.Sound.nChannels);
    case 'none'
        fprintf(1, 'NOT USING ANY SOUND OUTPUT.\n');
end


%INITIALIZE PTB-ENVIRONMENT
%OPEN A DOUBLE BUFFERED WINDOW
%SET PROGRAM PRIORITY TO HIGHEST
%QUERY HARDWARE AND SOFTWARE FEATURES AND STORE THEM IN CFG
[windowPtr, Cfg] = PTBInit(Cfg, expName);
if isempty(windowPtr)
    fprintf(1, 'Program aborted\n');
    return
end


%INITIALIZE PARALLEL PORT
%FOR OUTPUT
if Cfg.issueTriggers
    Cfg = InitDigitalOutput(Cfg);
end

%INITIALIZE PIEZO STIMULATOR
% i.e. LOAD THe LIBRARY
if Cfg.StimulationDevices.usePiezo
    fprintf(1, 'INITIALIZING PIEZO STIMULATOR ...');
    loadlibrary stimlib0.dll stimlibrel.h alias stimlib ;
    fprintf(1, 'DONE.\n');
end

%INITIALIZE RESPONSE DEVICES
%e.g. PARALLEL PORT, SERIAL PORT, MOUSE
% GP ->
% do the input hardware initialization
% before the synch box initialization
% so we do it only once
Cfg = InitResponseDevice(Cfg);
fprintf(1, 'LOADING ASF_waitForResponse into memory ... ');
ASF_waitForResponse(Cfg, 0);
fprintf(1, 'DONE\n');

%FOR INPUT
if Cfg.synchToScanner
    switch Cfg.synchToScannerPort
        case 'PARALLEL'
            Cfg = InitParallelPortInput(Cfg);
        case 'SERIAL'
            % WE SHOULD CONSIDER THIS
            % Cfg = InitSerialPortInput(Cfg);
            % define this function
            % DO NOTHING, we initialize it
            % before in the InitResponseDevice
        case 'SIMULATE'
            %NO SPECIFIC ACTION DEFINED

    end
    %RUN THE FUNCTION ASF_waitForScannerSynch once with a short timeout to
    %make sure that it is stored in memory, this will increase timing
    %accuracy
    fprintf(1, 'LOADING ASF_waitForScannerSynch into memory ...');
    CfgTmp = Cfg;
    CfgTmp.ScannerSynchShowDefaultMessage = 0;
    CfgTmp.scannerSynchTimeOutMs = 100;
    ASF_waitForScannerSynch(windowPtr, CfgTmp)
    fprintf(1, ' DONE.\n');
end

%PREPARE A BURST TASK ON NI-CARD
if Cfg.TMS.burstMode.on
    Cfg.hBurstTmsTask = libpointer('uint32Ptr', 0);
    [Cfg.hBurstTmsTask, errorFlag] = ASF_PulseTrainCreateTask(Cfg.hBurstTmsTask, Cfg.TMS.burstMode.freqHz, Cfg.TMS.burstMode.nPulses);
    if errorFlag
        Cfg = ASF_PTBExit(windowPtr, Cfg, errorFlag, 'CANNOT CREATE PULSE TRAIN TASK.\nSHUT DOWN MATLAB AND START IT AGAIN.\n') %#ok<NOPRT>
    end
end

Cfg %#ok<NOPRT>


% %INITIALIZE PTB-ENVIRONMENT
% %OPEN A DOUBLE BUFFERED WINDOW
% %SET PROGRAM PRIORITY TO HIGHEST
% %QUERY HARDWARE AND SOFTWARE FEATURES AND STORE THEM IN CFG
% [windowPtr, Cfg] = PTBInit(Cfg, expName);
% if isempty(windowPtr)
%     fprintf(1, 'Program aborted\n');
%     return
% end

Screen('DrawText', windowPtr, sprintf('WELCOME TO ASF %5.3f', Cfg.ASFVersion), 100, 70);

Screen('DrawText', windowPtr, sprintf('Width: %d [pxl]', Cfg.Screen.NewResolution.width), 100, 120);
Screen('DrawText', windowPtr, sprintf('Height: %d [pxl]', Cfg.Screen.NewResolution.height), 100, 170);
Screen('DrawText', windowPtr, sprintf('Refresh: %5.3f [Hz]', Cfg.Screen.NewResolution.hz), 100, 220);
Screen('DrawText', windowPtr, sprintf('actual refresh rate: %5.3f Hz', 1/Cfg.Screen.monitorFlipInterval), 100, 270);

%Screen('Flip', windowPtr);
%pause(1)
%LOAD BMPs ONTO TEXTURES
Screen('DrawText', windowPtr, '... Loading Bitmaps...', 100, 320);
Screen('Flip', windowPtr, 0, 1);
[ExpInfo.stimNames, Stimuli, errorFlag] = read_stimuli(windowPtr, Cfg);
if errorFlag
    ASF_PTBExit(windowPtr, Cfg, errorFlag)
    error('PROGRAM ABORTED')
end

%READ TRIAL DEFINITIONS
%[trial, ExpInfo.factorinfo, errorFlag] = read_trialdefs(Cfg.trialFileName, Cfg);
[trial, ExpInfo.factorinfo, errorFlag] = ASF_readTrialDefs(Cfg.trialFileName, Cfg);
if errorFlag
    ASF_PTBExit(windowPtr, Cfg, errorFlag)
    error('PROGRAM ABORTED')
end

%GET READY
Screen('DrawText', windowPtr, '... press mouse button to begin ...', 100, 370);
Screen('Flip', windowPtr);
ASF_waitForMousePressBenign(inf);
Screen('Flip', windowPtr);
WaitSecs(1);

%% PTBInit
% Open a double buffered fullscreen window and draw a gray background to front and back buffers
% Set program priority to highest
function [windowPtr, Cfg] = PTBInit(Cfg, expName)
if(~isfield(Cfg, 'Screen')), Cfg.Screen = []; end
%if(~isfield(Cfg.Screen, 'useDefaultResolution')), Cfg.Screen.useDefaultResolution = 1; end
if(~isfield(Cfg.Screen, 'color')), Cfg.Screen.color = [255, 255, 255]; end %OBSOLETE BUT I'LL LEAVEIT FOR NOW
if(~isfield(Cfg.Screen, 'rect')), Cfg.Screen.rect = []; end
if(~isfield(Cfg.Screen, 'Resolution'))
    Cfg.Screen.Resolution.pixelSize = 32; 
    monitorPositions = get(0, 'MonitorPositions');
    Cfg.Screen.Resolution.width = monitorPositions(end, end - 1) - monitorPositions(end, 1) + 1;
    Cfg.Screen.Resolution.height = monitorPositions(end, end);
    Cfg.Screen.Resolution.hz = 60;
    Cfg.Screen.Resolution.pixelSize= 32;
end
if(~isfield(Cfg.Screen.Resolution, 'pixelSize')), Cfg.Screen.Resolution.pixelSize = 32; end
if(~isfield(Cfg.Screen.Resolution, 'hz')), Cfg.Screen.Resolution.hz = 60; end
if(~isfield(Cfg.Screen, 'numberOfBuffers')), Cfg.Screen.numberOfBuffers = []; end
if(~isfield(Cfg.Screen, 'stereomode')), Cfg.Screen.stereomode = []; end
if(~isfield(Cfg.Screen, 'multisample')), Cfg.Screen.multisample = []; end
if(~isfield(Cfg.Screen, 'fontName')), Cfg.Screen.fontName = 'Courier New'; end
if(~isfield(Cfg.Screen, 'fontSize')), Cfg.Screen.fontSize = 24; end
if(~isfield(Cfg.Screen, 'textColor')), Cfg.Screen.textColor = [255, 0, 0]; end
if(~isfield(Cfg.Screen, 'xDimCm')), Cfg.Screen.xDimCm = 33; end %DELL M70
if(~isfield(Cfg.Screen, 'yDimCm')), Cfg.Screen.yDimCm = 20.625; end %DELL M70
if(~isfield(Cfg.Screen, 'distanceCm')), Cfg.Screen.distanceCm = 45; end %DELL M70


windowPtr = [];
%CHECK WHETHER DATA FILE ALREADY EXISTS
Cfg.version = []; %VERSION OUTPUT WILL BE REMOVED FROM fileparts
[Cfg.pathstr, Cfg.name, Cfg.ext] = fileparts(expName);
filename = fullfile(Cfg.pathstr, [Cfg.name, '.mat']);
if exist(filename, 'file') == 2
    msg = sprintf('File %s already exists. Overwrite?', filename);
    ButtonName = questdlg(msg, 'Warning', 'Yes','No','No');
    if strcmp(ButtonName, 'No')
        %trialdef = [];
        return
    end
end

% get screen
screens = Screen('Screens'); %RETURNS A LIST OF AVAIALBLE DISPLAYS
screenNumber = max(screens); %#ok<NASGU> %PICK THE ONE WITH THE HIGEST NUMBER
if length(screens) > 1
    screenNumber = screens(end);
else
    screenNumber = 0;
end

HideCursor;

Cfg.Screen.NewResolution.width = 0;
Cfg.Screen.NewResolution.height = 0;
Cfg.Screen.NewResolution.hz = 0;
%SET REQUESTED SCREEN RESOLUTION AND REFRESH RATE
Cfg.ScreenVersion = Screen('Version');

if ~isempty(Cfg.Screen.Resolution)
    %IF THIS STRUCTURE IS NOT EMPTY THEN THE USER WISHES TO SET THE RESOLUTION 
    %SCREEN RESOLUTIONS IS A RELATIVELY RECENT ADDITION TO PTB
    if Cfg.ScreenVersion.build >= 170126971
        availableResolutions = Screen('Resolutions',0);
        [vertcat(availableResolutions.width), vertcat(availableResolutions.height), vertcat(availableResolutions.pixelSize), vertcat(availableResolutions.hz)]
        if size(availableResolutions, 2) > 0
            resIdx = find(...
                [availableResolutions(:).width] == Cfg.Screen.Resolution.width...
                & [availableResolutions(:).height] == Cfg.Screen.Resolution.height...
                & [availableResolutions(:).pixelSize] == Cfg.Screen.Resolution.pixelSize...
                & [availableResolutions(:).hz] == Cfg.Screen.Resolution.hz );
            if ~isempty(resIdx)
                Cfg.Screen.NewResolution = availableResolutions(max(resIdx));
                Cfg.Screen.OldResolution = Screen('Resolution', 0, Cfg.Screen.NewResolution.width, Cfg.Screen.NewResolution.height, Cfg.Screen.NewResolution.hz, Cfg.Screen.NewResolution.pixelSize);
            else
                %PRODUCE A GRACEFUL EXIT
                fprintf('Requested Screen Parameters not available\nwidth: %d, height: %d, pixelSize: %d, refresh: %d\n',...
                    Cfg.Screen.Resolution.width, Cfg.Screen.Resolution.height, ...
                    Cfg.Screen.Resolution.pixelSize, Cfg.Screen.Resolution.hz);
                nAvailableResolutions = length(availableResolutions);
                for i = 1:nAvailableResolutions
                    fprintf(1, '%4d, %4d, %4d, %4d\n',...
                        availableResolutions(i).width, availableResolutions(i).height, ...
                        availableResolutions(i).pixelSize, availableResolutions(i).hz);
                end

                return
            end
        else
            fprintf(1, 'Cannot find any available screen resolution. Will try opening the PTP screen with default parameters.\n');
        end

    end
end
Screen('Preference', 'SkipSyncTests', Cfg.Screen.skipSyncTests);

% Open a double buffered fullscreen window and draw a gray background to front and back buffers:
fprintf(1, '*****************************************************************************\n');
fprintf(1, '********** OPENING ONSCREEN WINDOW AND PERFORMING SOME DIAGNOSTICS **********\n');
fprintf(1, '*****************************************************************************\n');
%[windowPtr, Cfg.Screen.rect] = Screen('OpenWindow', screenNumber);%[windowPtr, Cfg.Screen.rect] = Screen('OpenWindow', screenNumber, Cfg.Screen.color, Cfg.Screen.rect);
[windowPtr, Cfg.Screen.rect] = Screen('OpenWindow', screenNumber, Cfg.Screen.color, Cfg.Screen.rect, Cfg.Screen.Resolution.pixelSize, Cfg.Screen.numberOfBuffers);
Cfg.Screen.NewResolution = Screen('Resolution', windowPtr); %ALTHOUGH THIS PARAMETER MAY HAVE BEEN SET, THIS NOW ALSO CATCHES THE SITUATION WHEN CURRENT SETTINGS ARE USED

%SOME GRAPHICS BOARDS SEEM NOT TO LIKE THIS
%[oldmaximumvalue oldclampcolors] = Screen('ColorRange', windowPtr)
fprintf(1, '*****************************************************************************\n');
fprintf(1, '********** DIAGNOSTICS COMPLETED                                   **********\n');
fprintf(1, '*****************************************************************************\n');



Cfg.Screen.FrameRate = Screen('NominalFrameRate', windowPtr);
[Cfg.Screen.monitorFlipInterval, Cfg.Screen.GetFlipInterval.nrValidSamples, Cfg.Screen.GetFlipInterval.stddev ] = Screen('GetFlipInterval', windowPtr );
[Cfg.Screen.width, Cfg.Screen.height] = Screen('WindowSize', windowPtr);
Cfg.Environment.computer = Screen('Computer');
Cfg.Environment.version = Screen('Version');

%CENTER OF THE SCREEN
Cfg.Screen.centerX = Cfg.Screen.width/2;
Cfg.Screen.centerY = Cfg.Screen.height/2;


%DEG VISUAL ANGLE FOR SCREEN
Cfg.Screen.visualAngleDegX = atan(Cfg.Screen.xDimCm/(2*Cfg.Screen.distanceCm))/pi*180*2;
Cfg.Screen.visualAngleDegY = atan(Cfg.Screen.yDimCm/(2*Cfg.Screen.distanceCm))/pi*180*2;
%DEG VISUAL ANGLE PER PIXEL
Cfg.Screen.visualAngleDegPerPixelX = Cfg.Screen.visualAngleDegX/Cfg.Screen.width;
Cfg.Screen.visualAngleDegPerPixelY = Cfg.Screen.visualAngleDegY/Cfg.Screen.height;
Cfg.Screen.visualAnglePixelPerDegX = Cfg.Screen.width/Cfg.Screen.visualAngleDegX;
Cfg.Screen.visualAnglePixelPerDegY = Cfg.Screen.height/Cfg.Screen.visualAngleDegY;

fprintf(1, 'Screen Parameters:\n');
fprintf(1, ' Width: %5.3f cm, %5d pixels, %5.3f deg [%5.3f deg/pix, %5.3f pix/deg]\n', Cfg.Screen.xDimCm, Cfg.Screen.width, Cfg.Screen.visualAngleDegX, Cfg.Screen.visualAngleDegPerPixelX, Cfg.Screen.visualAnglePixelPerDegX);
fprintf(1, 'Height: %5.3f cm, %5d pixels, %5.3f deg [%5.3f deg/pix, %5.3f pix/deg]\n', Cfg.Screen.yDimCm, Cfg.Screen.height, Cfg.Screen.visualAngleDegY, Cfg.Screen.visualAngleDegPerPixelY, Cfg.Screen.visualAnglePixelPerDegY);
fprintf(1, 'Width: %d [pxl], height: %d [pxl]\n nominal refresh rate: %5.3f [Hz], actual refresh rate: %5.3f\n', Cfg.Screen.NewResolution.width, Cfg.Screen.NewResolution.height, Cfg.Screen.NewResolution.hz, 1/Cfg.Screen.monitorFlipInterval);
%pause

%DEFAULT FONT
Screen('TextFont', windowPtr, Cfg.Screen.fontName);

%DEFAULT TEXT SIZE
Screen('TextSize', windowPtr, Cfg.Screen.fontSize);


% returns as default the mean gray value of screen
% gray = GrayIndex(screenNumber);
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);

Screen('TextColor', windowPtr, Cfg.Screen.textColor);

Screen('FillRect', windowPtr, Cfg.Screen.color);
Screen('Flip', windowPtr);

% set priority
priorityLevel = MaxPriority(windowPtr);
Priority(priorityLevel);


%% InitResponseDevice
function Cfg = InitResponseDevice(Cfg)

switch Cfg.responseDevice

    case 'MOUSE'
        fprintf(1, 'USING MOUSE AS RESPONSE DEVICE\n');

    case 'VOICEKEY'
        %RESULTS SHOULD BE BEST IF PROGRAM WAITS FOR A VERTICAL SYNCH BEFORE
        %STARTING THE AUDIORECORDER
        fprintf(1, 'USING VOICE-KEY AS RESPONSE DEVICE\n');
        fprintf(1, '\tINITIALIZING AUDIO CARD FOR VOICE KEY OPERATION...');
        %APPLY DEFAULT SETTINGS UNLESS REQUESTED OTHERWISE
        if ~isfield(Cfg, 'audio'), Cfg.audio = []; else end
        if ~isfield(Cfg.audio, 'f'), Cfg.audio.f = 44100; else end
        if ~isfield(Cfg.audio, 'nBits'),Cfg.audio.nBits = 16; else end
        if ~isfield(Cfg.audio, 'nChannels'), Cfg.audio.nChannels = 1; else end

        Cfg.audio.recorder = audiorecorder(Cfg.audio.f, Cfg.audio.nBits, Cfg.audio.nChannels);
        %set(recorder, 'StartFcn',  'global s; crsRTSStartStream(s, CRS.SS_IMMEDIATE);');
        %we might consider automatically sending a trigger
        fprintf(1, 'DONE\n');

    case 'LUMINAPARALLEL'
        fprintf(1, 'START INITIALIZING LUMINA ON PARALLEL PORT...\n');
        %CHECK WHETHER THIS ALREADY EXISTS
        %Cfg.hardware.parallel.mydio_in
        Cfg = InitParallelPortInput(Cfg);
        fprintf(1, 'DONE INITIALIZING LUMINA\n');


    case 'LUMINASERIAL'
        if ~isfield(Cfg, 'hardware'), Cfg.hardware = []; else end
        if ~isfield(Cfg.hardware, 'serial'), Cfg.hardware.serial = []; else end
        if ~isfield(Cfg.hardware.serial, 'BaudRate'), Cfg.hardware.serial.BaudRate = 115200;else end

        fprintf(1, 'CREATING SERIAL OBJECT ... ');
        Cfg.hardware.serial.oSerial = serial(Cfg.serialPortName, 'Tag', 'SerialResponseBox', 'BaudRate', Cfg.hardware.serial.BaudRate);
        set(Cfg.hardware.serial.oSerial, 'Timeout', 0.001) %RECONSIDER
        Cfg.hardware.serial.oSerial.Terminator = '';
        set(Cfg.hardware.serial.oSerial,'InputBufferSize',128)
        %Cfg.hardware.serial.oSerial.ReadAsyncMode = 'manual';%'continuous';
        %Cfg.hardware.serial.ClassSerial = class(Cfg.hardware.serial, 'SerialResponseBox');
        %dummy = warning( 'off', 'instrument:fscanf:unsuccessfulRead')
        warning off all %THIS IS NASTY!!! We do this because of timeout warning
        fprintf(1, 'DONE\n');
        fprintf(1, 'STARTING SERIAL COMMUNICATION WITH SERIAL RESPONSE BOX (BAUD RATE: %d) ... ', Cfg.hardware.serial.BaudRate);
        fopen(Cfg.hardware.serial.oSerial);
        fprintf('DONE\n');
        %Cfg.hardware.serial.oSerial.BytesAvailable
    case  'KEYBOARD'
        fprintf(1, 'USING KEYBOARD AS RESPONSE DEVICE\n');

end

%% read_stimuli
% Loads bitmaps from a list specified in a textfile onto textures
function [stimNames, Stimuli, errorFlag] = read_stimuli(windowPtr, Cfg)
%function [stimNames, tex] = read_stimuli(windowPtr, fname_stim)
%Loads bitmaps from a list specified in a textfile onto textures
%if successful returns nstimulus names and textures
%Example Call:
%[stimNames, tex] = read_stimuli(windowPtr, 'stimdef.txt')

fname_stim = Cfg.stimNames;
%READ STIMULUS-NAMES
stimNames  = importdata(fname_stim);
nStimuli = size(stimNames, 1);

%USE MATLAB'S PROGRESS BAR FOR FEEDBACK
%h = waitbar(0,'Loading images...');

%CHECK WHETHER IMAGES EXIST
errorFlag = 0;
frameCounter = 0; %#ok<NASGU>
%Stimuli.tex(nStimuli) = NaN;
Stimuli.tex = [];
Stimuli.size = [];

for iStimulus = 1:nStimuli
    %WAITBAR ON CONSOLE
    %waitbar(iStimulus/nStimuli,h)
    fprintf(1, 'STIMULUS: %s ...', stimNames{iStimulus});
    
    %WAITBAR ON ASF STARTUP SCREEN
    Screen('FillRect', windowPtr, [ 255, 0, 0], [1, 1, 100, 20])
    Screen('FillRect', windowPtr, [0, 255, 0], [1, 1, ceil(iStimulus/nStimuli*100), 20]);
    Screen('Flip', windowPtr, [], 1); %NONDESTRUCTIVE FLIP
 
%     Screen('DrawText', windowPtr, sprintf('%32s', stimNames{iStimulus}), 100, 370);
%     Screen('Flip', windowPtr, 0, 1);
%     Screen('DrawText', windowPtr, sprintf('%32s', '                                '), 100, 370);

    %CREATE TEXTURE(S) FOR A GIVEN STIMULUS
    [errorFlag, aStimulus, frameCounter] =...
        ASF_readStimulus(stimNames{iStimulus}, windowPtr, Cfg);
    %CONCATENATE VECTOR OF EXISTING AND NEWLY CREATED TEXTURE HANDLES
    Stimuli.tex = [Stimuli.tex, aStimulus.tex];
    %Stimuli.size = vertStimuli.size
end
%CLOSE WAITBAR
%close(h)

%READ TEXT STIMULI
Stimuli.CellArray_TextStimuli = [];
if ~isempty(Cfg.readTextStimuli)
    fprintf(1, 'READING: %s ...', Cfg.readTextStimuli);

    if exist(Cfg.readTextStimuli, 'file')
        Stimuli.CellArray_TextStimuli = importdata(Cfg.readTextStimuli);
        fprintf(1, 'OK\n');
    else
        fprintf(1, 'NOT FOUND\n');
        errorFlag = errorFlag + 1;
    end
end

%READ SOUND STIMULI
Stimuli.CellArray_Sound = [];
if ~isempty(Cfg.readSoundStimuli)
    fprintf(1, 'READING: %s ...', Cfg.readSoundStimuli);

    if exist(Cfg.readSoundStimuli, 'file')
        soundstimnames = importdata(Cfg.readSoundStimuli);
        nStimuli = size(soundstimnames, 1);
        %USE MATLAB'S PROGRESS BAR FOR FEEDBACK
        h = waitbar(0,'Loading sounds...');

        %CHECK WHETHER IMAGES EXIST
        errorFlag = 0;
        for iStimulus = 1:nStimuli
            waitbar(iStimulus/nStimuli,h)

            fprintf(1, 'STIMULUS: %s ...', soundstimnames{iStimulus});
            if(exist(soundstimnames{iStimulus}, 'file'))
                %IF FILE EXISTS...
                fprintf(1, 'OK\n');

                %READ IMAGE INTO MATRIX
                Stimuli.CellArray_Sound{iStimulus} = wavread(soundstimnames{iStimulus});
            else
                %IF FILE DOES NOT EXIST
                fprintf(1, 'NOT FOUND\n');
                errorFlag = errorFlag + 1;
                stimNames = [];
                Stimuli.tex = [];
                close(h)
                return
            end

        end
        close(h)
        drawnow

        fprintf(1, 'OK\n');
    else
        fprintf(1, 'NOT FOUND\n');
        errorFlag = errorFlag + 1;
    end
end


%% ***TRIAL-PRESENTATION AND RENDERING***
%% ShowTrial (SHOWTRIAL WITH MOUSE, SERIAL OR PARALLEL RESPONSE BOX AS RESPONSE DEVICE)
function TrialInfo = ShowTrial(atrial, windowPtr, Stimuli, Cfg)
%SAVE TIME BY ALLOCATING ALL VARIABLES UPFRONT

% VBLTimestamp system time (in seconds) when the actual flip has happened in the return argument
% StimulusOnsetTime An estimate of Stimulus-onset time
% FlipTimestamp is a timestamp taken at the end of Flip's execution
% Use the difference between FlipTimestamp and VBLTimestamp to get an estimate of how long Flips execution takes.
% Missed indicates if the requested presentation deadline for your stimulus has been missed. A negative
% value means that dead- lines have been satisfied. Positive values indicate a deadline-miss.
% Beampos is the position of the monitor scanning beam when the time measurement was taken (useful for correctness tests)
VBLTimestamp = 0; StimulusOnsetTime = 0; FlipTimestamp = 0; Missed = 0; Beampos = 0;

StartRTMeasurement = 0; EndRTMeasurement = 0;
timing = [0, VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos];
nPages = length(atrial.pageNumber);
timing(nPages, end) = 0;
this_response = [];

tolerance = Cfg.Screen.monitorFlipInterval*0.75; %WAS 1/400 BUT THIS SEEMED TO PRODUCE TOO MANY TIMING ERRORS ON PAGES WITH RESPONSE COLLECTION
%HOWEVER, THIS MUST NOT BE LONGER THAN ONE FRAME
%DURATION. EXPERIMENTING WITH ONE QUARTER OF A FRAME
responseGiven = 0;
this_response.key = [];
this_response.RT = [];

%IF YOU WANT TO DO ANY OFFLINE STIMULUS RENDERING (I.E. BEFORE THE TRIAL STARTS), PUT THAT CODE HERE

%--------------------------------------------------------------------------
%TRIAL PRESENTATION HAS SEVERAL PHASES
% 1) WAIT FOR THE RIGHT TIME TO START TRIAL PRESENTATION. THIS MAY BE IMMEDIATELY OR USER DEFINED (E.G. IN fMRI EXPERIMENTS)
%
% 2) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION
%
% 3) LOOP THROUGH PAGE PRESENTATIONS WHILE CHECKING FOR USER INPUT/RESPONSES
%
% 4) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION (AFTER RESPONSE HAS BEEN GIVEN)
%
% 5) FEEDBACK
%--------------------------------------------------------------------------

%LOG DATE AND TIME OF TRIAL
strDate = datestr(now); %store when trial was presented

%--------------------------------------------------------------------------
% PHASE 1) WAIT FOR THE RIGHT TIME TO START TRIAL PRESENTATION. THIS MAY BE IMMEDIATELY OR USER DEFINED (E.G. IN fMRI EXPERIMENTS)
%--------------------------------------------------------------------------

% %JS METHOD: LOOP
% %IF EXTERNAL TIMING REQUESTED (e.g. fMRI JITTERING)
% if Cfg.useTrialOnsetTimes
%     while((GetSecs- Cfg.experimentStart) < atrial.tOnset)
%     end
% end
% %LOG TIME OF TRIAL ONSET WITH RESPECT TO START OF THE EXPERIMENT
% %USEFUL FOR DATA ANALYSIS IN fMRI
% tStart = GetSecs - Cfg.experimentStart;

%SUGGESTED METHOD: TIMED WAIT
%IF EXTERNAL TIMING REQUESTED (e.g. fMRI JITTERING)
if Cfg.useTrialOnsetTimes
    wakeupTime = WaitSecs('UntilTime', Cfg.experimentStart + atrial.tOnset);
else
    wakeupTime = GetSecs;
end
%LOG TIME OF TRIAL ONSET WITH RESPECT TO START OF THE EXPERIMENT
%USEFUL FOR DATA ANALYSIS IN fMRI
tStart = wakeupTime - Cfg.experimentStart;


if Cfg.Eyetracking.doDriftCorrection
    EyelinkDoDriftCorrect(Cfg.el);
end

%--------------------------------------------------------------------------
%END OF PHASE 1
%--------------------------------------------------------------------------



%MESSAGE TO EYELINK
Cfg = ASF_sendMessageToEyelink(Cfg, 'TRIALSTART');

%--------------------------------------------------------------------------
% PHASE 2) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION
%--------------------------------------------------------------------------
%CYCLE THROUGH PAGES FOR THIS TRIAL
atrial.nPages = length(atrial.pageNumber);
for i = 1:atrial.startRTonPage-1
    if (i > atrial.nPages)
        break;
    else
        %PUT THE APPROPRIATE TEXTURE ON THE BACK BUFFER
        Screen('DrawTexture', windowPtr, Stimuli.tex(atrial.pageNumber(i)));
        
        %PRESERVE BACK BUFFER IF THIS TEXTURE S TO BE SHOW AGAIN AT THE NEXT FLIP
        bPreserveBackBuffer = atrial.pageDuration(i) > 1;
        
        %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
        %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
        [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] =...
            ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg, bPreserveBackBuffer);
        
        %SET TRIGGER (PARALLEL PORT AND EYELINK)
        ASF_setTrigger(Cfg, atrial.pageNumber(i));
        
        
        %LOG WHEN THIS PAGE APPEARED
        timing(i, 1:6) = [atrial.pageDuration(i), VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos];
        
        
        %WAIT OUT STIMULUS DURATION IN FRAMES. WE USE PAGE FLIPPING RATHER THAN
        %A TIMER WHENEVER POSSIBLE BECAUSE GRAPHICS BOARDS PROVIDE EXCELLENT
        %TIMING; THIS IS THE REASON WHY WE MAY WANT TO KEEP A STIMULUS IN THE
        %BACKBUFFER (NONDESTRUCTIVE PAGE FLIPPING)
        %NOT ALL GRAPHICS CARDS CAN DO THIS. FOR CARDS WITHOUT AUXILIARY
        %BACKBUFFERS WE COPY THE TEXTURE EXPLICITLY ON THE BACKBUFFER AFTER IT
        %HAS BEEN DESTROYED BY FLIPPING
        nFlips = atrial.pageDuration(i) - 1; %WE ALREADY FLIPPED ONCE
        for FlipNumber = 1:nFlips
            %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN AT THE NEXT FLIP
            bPreserveBackBuffer = FlipNumber < nFlips;
            
            %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
            %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
            ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg, bPreserveBackBuffer);
        end
    end
end
%--------------------------------------------------------------------------
%END OF PHASE 2
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% PHASE 3) LOOP THROUGH PAGE PRESENTATIONS WHILE CHECKING FOR USER INPUT/RESPONSES
%--------------------------------------------------------------------------
%SPECIAL TREATMENT FOR THE DISPLAY PAGE ON WHICH WE ALLOW REACTIONS
%RT PAGE
for i = atrial.startRTonPage:atrial.startRTonPage
    if (i > atrial.nPages)
        break;
    else

    %PUT THE APPROPRIATE TEXTURE ON THE BACK BUFFER
    Screen('DrawTexture', windowPtr, Stimuli.tex(atrial.pageNumber(i)));

    %DO NOT PUT THIS PAGE AGAIN ON THE BACKBUFFER, WE WILL WAIT IT OUT
    %USING THE TIMER NOT FLIPPING
    bPreserveBackBuffer = 0;

    %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
    %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] =...
        ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg, bPreserveBackBuffer);

    %SET TRIGGER
    ASF_setTrigger(Cfg, atrial.pageNumber(i));

    StartRTMeasurement = VBLTimestamp;

    %STORE TIME OF PAGE FLIPPING FOR DIAGNOSTIC PURPOSES
    timing(i, 1:6) = [atrial.pageDuration(i), VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos];

    pageDuration_in_sec = atrial.pageDuration(i)*Cfg.Screen.monitorFlipInterval;
    [x, y, buttons, t0, t1] = ASF_waitForResponse(Cfg, pageDuration_in_sec - tolerance);
    if any(buttons)
        responseGiven = 1;
        %a button has been pressed before timeout
        if Cfg.responseTerminatesTrial
            Snd('Play','Quack')
        else
            WaitSecs(pageDuration_in_sec - (t1 - StartRTMeasurement) -tolerance); %wait out the remainder of the stimulus duration 5ms margin
        end
        this_response.key = find(buttons); %find which button it was
        this_response.RT = (t1 - StartRTMeasurement)*1000; %compute response time
    end
    end
end
%--------------------------------------------------------------------------
%END OF PHASE 3
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% PHASE 4) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION (AFTER RESPONSE HAS BEEN GIVEN)
%--------------------------------------------------------------------------
%OTHER PICS
for i = atrial.startRTonPage+1:nPages
        if (i > atrial.nPages)
        break;
    else

    %PUT THE APPROPRIATE TEXTURE ON THE BACK BUFFER
    Screen('DrawTexture', windowPtr, Stimuli.tex(atrial.pageNumber(i)));

    %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN AT THE NEXT FLIP
    bPreserveBackBuffer = atrial.pageDuration(i) > 1;

    %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
    %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg, bPreserveBackBuffer);

    %SET TRIGGER
    ASF_setTrigger(Cfg, atrial.pageNumber(i));

    %STORE TIME OF PAGE FLIPPING FOR DIAGNOSTIC PURPOSES
    timing(i, 1:6) = [atrial.pageDuration(i), VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos];

    if(responseGiven)
        %IF THE RESPONSE HAS ALREADY BEEN GIVEN


        %WAIT OUT STIMULUS DURATION IN FRAMES
        nFlips = atrial.pageDuration(i) - 1; %WE ALREADY FLIPPED ONCE
        for FlipNumber = 1:nFlips
            %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN AT THE NEXT FLIP
            bPreserveBackBuffer = FlipNumber < nFlips;

            %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
            %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
            ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg, bPreserveBackBuffer);
        end
    else
        %THE RESPONSE HAS NOT YET BEEN GIVEN
        pageDuration_in_sec = atrial.pageDuration(i)*Cfg.Screen.monitorFlipInterval;
        [x, y, buttons, t0, t1] = ASF_waitForResponse(Cfg, pageDuration_in_sec - tolerance);

        if any(buttons)
            responseGiven = 1;
            %a button has been pressed before timeout
            if Cfg.responseTerminatesTrial
                Snd('Play','Quack')
            else
                %THIS IS DIFFERENT WITH RESPECT TO THE RT PAGE FOR THE
                %PAGES FOLLOWING THE RTPAGE
                WaitSecs(pageDuration_in_sec - (t1-t0) -tolerance); %wait out the remainder of the stimulus duration 5ms margin
            end
            this_response.key = find(buttons); %find which button it was
            this_response.RT = (t1 - StartRTMeasurement)*1000; %compute response time
        end

    end
        end
end
%--------------------------------------------------------------------------
%END OF PHASE 4
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% PHASE 5) FEEDBACK
%--------------------------------------------------------------------------
%IF YOU WANT TO FORCE A RESPONSE
if Cfg.waitUntilResponseAfterTrial && ~responseGiven
    %[x, y, buttons, t0, t1] = WaitForMousePress(10);
    [x, y, buttons, t0, t1] = ASF_waitForResponse(Cfg, 10);

    if any(buttons)
        responseGiven = 1; %#ok<NASGU>
        %a button has been pressed before timeout
        this_response.key = find(buttons); %find which button it was
        this_response.RT = (t1 - StartRTMeasurement)*1000; %compute response time
    end
end

%TRIAL BY TRIAL FEEDBACK
if Cfg.feedbackTrialCorrect || Cfg.feedbackTrialError
    %EVALUATE RESPONSE
    if this_response.key == atrial.CorrectResponse
        %CORRECT RESPONSE
        if Cfg.feedbackTrialCorrect
            Snd('Play', Cfg.sndOK)
            Snd('Wait');
        end
    else
        %WRONG RESPONSE
        if Cfg.feedbackTrialError
            Snd('Play', Cfg.sndERR)
            Snd('Wait');
        end
    end
end
%--------------------------------------------------------------------------
%END OF PHASE 5
%--------------------------------------------------------------------------




%PACK INFORMATION ABOUT THIS TRIAL INTO STRUCTURE TrialInfo (THE RETURN ARGUMENT)
%PLEASE MAKE SURE THAT TrialInfo CONTAINS THE FIELDS:
%   trial
%   datestr
%   tStart
%   Response
%   timing
%   StartRTMeasurement
%   EndRTMeasurement
%OTHERWISE DIAGNOSTIC PROCEDURES OR ROUTINES FOR DATAANALYSIS MAIGHT FAIL
TrialInfo.trial = atrial;  %store page numbers and durations
TrialInfo.datestr = strDate;
TrialInfo.tStart = tStart;
TrialInfo.Response = this_response;
TrialInfo.timing = timing;
TrialInfo.StartRTMeasurement = StartRTMeasurement;
TrialInfo.EndRTMeasurement = EndRTMeasurement;

%% ShowTrialVK (SHOWTRIAL WITH VOICEKEY AS RESPONSE DEVICE)
%USE THIS AS A TEMPLATE FOR OTHER RESPONSE DEVICES THAT NEED NO POLLING
%function TrialInfo = ShowTrialVK(trialnumber, atrial, windowPtr, Stimuli, Cfg)
function TrialInfo = ShowTrialVK(atrial, windowPtr, Stimuli, Cfg)
%SAVE TIME BY ALLOCATING ALL VARIABLES UPFRONT

% Show Screen
% VBLTimestamp system time (in seconds) when the actual flip has happened in the return argument
% StimulusOnsetTime An estimate of Stimulus-onset time
% FlipTimestamp is a timestamp taken at the end of Flip's execution
% Use the difference between FlipTimestamp and VBLTimestamp to get an estimate of how long Flips execution takes.
% Missed indicates if the requested presentation deadline for your stimulus has been missed. A negative
% value means that dead- lines have been satisfied. Positive values indicate a deadline-miss.
% Beampos is the position of the monitor scanning beam when the time measurement was taken (useful for correctness tests)
VBLTimestamp = 0; StimulusOnsetTime = 0; FlipTimestamp = 0; Missed = 0; Beampos = 0;

StartRTMeasurement = 0; EndRTMeasurement = 0;

timing = [0, VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos];
nPages = length(atrial.pageNumber);
timing(nPages, end) = 0;
this_response = [];


this_response.key = [];
this_response.RT = [];


%IF YOU WANT TO DO ANY OFFLINE STIMULUS RENDERING (I.E. BEFORE THE TRIAL STARTS), PUT THAT CODE HERE


%LOG DATE AND TIME OF TRIAL
TrialInfo.datestr = datestr(now); %store when trial was presented



%JS VERSION

%IF EXTERNAL TIMING REQUESTED (e.g. fMRI JITTERING)
if Cfg.useTrialOnsetTimes
    currentTime = GetSecs;
    while((GetSecs- Cfg.experimentStart) < atrial.tOnset)
    end
end

%LOG TIME OF TRIAL ONSET WITH RESPECT TO START OF THE EXPERIMENT
%USEFUL FOR DATA ANALYSIS IN fMRI
TrialInfo.tStart = GetSecs - Cfg.experimentStart;

% %REVIEWER VERSION
% 
% %IF EXTERNAL TIMING REQUESTED (e.g. fMRI JITTERING)
% if Cfg.useTrialOnsetTimes
%     currentTime = GetSecs;
%     wakeup = WaitSecs('UntilTime', Cfg.experimentStart - currentTime);
% end
% %LOG TIME OF TRIAL ONSET WITH RESPECT TO START OF THE EXPERIMENT
% %USEFUL FOR DATA ANALYSIS IN fMRI
% TrialInfo.tStart = wakeup - Cfg.experimentStart;

%CYCLE THROUGH PAGES FOR THIS TRIAL
for i = 1:nPages
    %PUT THE APPROPRIATE TEXTURE ON THE BACK BUFFER
    Screen('DrawTexture', windowPtr, Stimuli.tex(atrial.pageNumber(i)));


    %PRESERVE BACK BUFFER IF THIS TEXTURE S TO BE SHOW AGAIN AT THE NEXT FLIP
    bPreserveBackBuffer = atrial.pageDuration(i) > 1;

    %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
    %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg, bPreserveBackBuffer);

    if i == atrial.startRTonPage
        StartRTMeasurement = VBLTimestamp;

        %VOICEKEY
        record(Cfg.audio.recorder, 2);       %RECORD for two seconds

    end
    timing(i, 1:6) = [atrial.pageDuration(i), VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos];

    %WAIT OUT STIMULUS DURATION IN FRAMES
    nFlips = atrial.pageDuration(i) - 1; %WE ALREADY FLIPPED ONCE
    for FlipNumber = 1:nFlips
        %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN AT THE NEXT FLIP
        bPreserveBackBuffer = FlipNumber < nFlips;

        %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
        %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
        ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg, bPreserveBackBuffer);
    end
end

%***********
%COMPUTE VOT
%***********
%MAKE SURE WE ARE NOT RECORDING ANYMORE
while(isrecording(Cfg.audio.recorder))
end
%GET DATA
audioarray = getaudiodata(Cfg.audio.recorder);
this_response.key = [];
this_response.wavname = sprintf('%s_trial_%05d.wav', Cfg.name, Cfg.currentTrialNumber);
this_response.RT = handle_audio_data(audioarray, Cfg.audio, 0, this_response.wavname, Cfg.plotVOT)*1000;

%PACK INFORMATION ABOUT THIS TRIAL INTO STRUCTURE TrialInfo (THE RETURN ARGUMENT)
%PLEASE MAKE SURE THAT TrialInfo CONTAINS THE FIELDS:
%   datestr
%   tStart
%   Response
%   timing
%   StartRTMeasurement
%   EndRTMeasurement
%OTHERWISE DIAGNOSTIC PROCEDURES ORE ROUTINES FOR DATAANALYSIS MAIGHT FAIL

%TrialInfo.datestr DEFINED ABOVE
%TrialInfo.tStart DEFINED ABOVE
TrialInfo.Response = this_response;
TrialInfo.timing = timing;
TrialInfo.StartRTMeasurement = StartRTMeasurement;
TrialInfo.EndRTMeasurement = EndRTMeasurement;
return

%% handle_audio_data
% compute voice onset time from audio data
function rt = handle_audio_data(audioarray, Cfg_audio, startstim, wavname, plotVOT)
%    wavwrite(audioarray, audio.f, audio.nBits, wavname)
%    plot((1:length(audioarray))./audio.f, [audioarray, sqrt(audioarray.^2)])
%    legend({'data', 'demeaned', 'abs'})
t = (0:length(audioarray)-1)./Cfg_audio.f;

audioarray_stimlocked = audioarray(t >= startstim);
t2 =    (0:length(audioarray_stimlocked)-1)./Cfg_audio.f;

wavwrite(audioarray_stimlocked, Cfg_audio.f, Cfg_audio.nBits, wavname);
Cfg.fnames = wavname;
rt = get_rts(Cfg);

if plotVOT
    subplot(2, 1, 1)
    plot(t, audioarray)
    ylim = get(gca, 'ylim');
    hold on
    plot([startstim, startstim], ylim, 'r')
    hold off

    subplot(2, 1, 2)
    plot(t2, audioarray_stimlocked)

    hold on
    ylim = get(gca, 'ylim');
    plot([rt, rt], ylim, 'g')
    hold off
    set(gcf, 'name', sprintf('%s, RT = %f', wavname, rt))
    drawnow
end


% %% xFlip (extended Screen('Flip'))
% function [ VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos ] = xFlip(windowPtr, texture, Cfg, bPreserveBackBuffer)
% % persistent flipval
% %
% % if isempty( flipval )
% %     flipval = 0;
% % end
%
% [bUpDn, T, keyCodeKbCheck] = KbCheck;
% if bUpDn % break out of loop
%     if find(keyCodeKbCheck) == 81
%         fprintf(1, 'USER ABORTED PROGRAM\n');
%         ASF_PTBExit(windowPtr, Cfg, 1)
%         %FORCE AN ERROR
%         error('USERABORT')
%         %IF TRY/CATCH IS ON THE FOLLOWING LINE CAN BE COMMENTED OUT
%         %ASF_PTBExit(windowPtr);
%     end
% end;
%
% switch bPreserveBackBuffer
%     case 0 %DESTRUCTIVE FLIP
%             [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr);
%     case 1 %NONDESTRUCTIVE FLIP
%         if Cfg.Screen.useBackBuffer
%             %FOR A MACHINE THAT HAS AUXILIARY BACKBUFFERS
%             [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr, [], 1);
%         else
%             %FOR A MACHINE THAT HAS NO BACKBUFFERS
%             [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr);
%             Screen('DrawTexture', windowPtr, texture);
%         end
% end
%
% % if Cfg.issueTriggers
% %     flipval = (flipval == 0);
% %     if flipval
% %         putvalue(Cfg.hardware.parallel.mydio.OutPutLine, Cfg.hardware.parallel.ON);
% %     else
% %         putvalue(Cfg.hardware.parallel.mydio.OutPutLine, Cfg.hardware.parallel.OFF);
% %     end
% % end
%
%
% %% ***RESPONSE COLLECTION***
% %% WaitForResponse Wrapper
% %WRAPPER FUNCTION THAT CHECKS FOR A RESPONSE USING:
% %MOUSE
% %LUMINA
% %CRS RESPONSE BOX - NOT YET IMPLEMENTED
% %KEYBOARD - NOT YET IMPLEMENTED
% function [x, y, buttons, t0, t1] = WaitForResponse(Cfg, timeout)
% switch Cfg.responseDevice
%     case 'MOUSE'
%         [x, y, buttons, t0, t1] = WaitForMousePress(timeout);
%
%     case 'LUMINAPARALLEL'
%         %[x, y, buttons] = WaitForLuminaPress(Cfg.hResponseDevice, timeout);
%         [x, y, buttons, t0, t1] = WaitForLuminaPress(Cfg.hardware.parallel.mydio_in, timeout);
%
%     case 'LUMINASERIAL'
%         x = [];
%         y = [];
%         [buttons, t0, t1] = WaitForSerialBoxPress(Cfg, timeout);
%
%     otherwise
%         error(sprintf('Unknown response device %s', Cfg.responseDevice)) %#ok<SPERR>
%
% end
%
% %DISCARD SIMULTANEOUS BUTTON PRESSES
% if sum(buttons) > 1
%     buttons = zeros(1, 4);
%     t1 = t0 + timeout;
%     x = [];
%     y = [];
% end
%
%
% %% WaitForSerialBoxPress
% function [buttons, t0, t1] = WaitForSerialBoxPress(Cfg, timeout)
% buttons(4) = 0;
% t0 = GetSecs;
% t1 = t0;
% % while ((~Cfg.hardware.serial.oSerial.BytesAvailable) && (t1 - t0)<timeout) % wait for press
% %     buttons = fgets(Cfg.hardware.serial.oSerial);
% %
% %     t1 = GetSecs;
% % end
%
% while ((t1 - t0) < timeout) % wait for press
%     if Cfg.hardware.serial.oSerial.BytesAvailable
%         %buttons = fgets(Cfg.hardware.serial.oSerial);
%         sbuttons = str2num(fscanf(Cfg.hardware.serial.oSerial)); %#ok<ST2NM>
%         if sbuttons < 5
%             %TRANSFORM INTO A 4 ELEMENT VECTOR
%             buttons(sbuttons) = 1;
%         end
%
% %         %CLEAN UP IN CASE MONKEY GOES WILD
% %         while Cfg.hardware.serial.oSerial.BytesAvailable
% %             junk = fscanf(Cfg.hardware.serial.oSerial);
% %         end
%
%
%     end
%     t1 = GetSecs;
% end
%
%
% %% WaitForMousePress
% %**************************************************************************
% %WAIT FOR MOUSE BUTTON PRESS UNTIL TIMEOUT HAS BEEN REACHED OR A BUTTON
% %HAS BEEN PRESSED
% %RETURNS
% %   X, Y:       CURSOR POSITION
% %   BUTTONS:    A VECTOR WITH LENGTH OF NUMBER OF MUSE BUTTONS,
% %               THE PRESSED BUTTON(S) HAS/HAVE A 1
% %   T0, T1:     TIME WHEN THE FUNCTION IS ENTERED AND LEFT
% %**************************************************************************
% function [x, y, buttons, t0, t1] = WaitForMousePress(timeout)
% buttons = 0;
% t0 = GetSecs;
% t1 = t0;
% while (~any(buttons) && (t1 - t0)<timeout) % wait for press
%     [x, y, buttons] = GetMouse;
%     t1 = GetSecs;
%     % Wait 1 ms before checking the mouse again to prevent
%     % overload of the machine at elevated Priority()
%     %JS: I REMOVED THIS BECAUSE IT SEEMS TO INVITE FOR GARBAGE COLLECTION
%     %AND MAY PRODUCE FRAME DROPS
%     %WaitSecs(0.001);
% end
%
% %% WaitForMousePressBenign
% %**************************************************************************
% %WAIT FOR MOUSE BUTTON PRESS UNTIL TIMEOUT HAS BEEN REACHED OR A BUTTON
% %HAS BEEN PRESSED
% %RETURNS
% %   X, Y:       CURSOR POSITION
% %   BUTTONS:    A VECTOR WITH LENGTH OF NUMBER OF MUSE BUTTONS,
% %               THE PRESSED BUTTON(S) HAS/HAVE A 1
% %   T0, T1:     TIME WHEN THE FUNCTION IS ENTERED AND LEFT
% %**************************************************************************
% function [x, y, buttons, t0, t1] = WaitForMousePressBenign(timeout)
% buttons = 0;
% t0 = GetSecs;
% t1 = t0;
% while (~any(buttons) && (t1 - t0)<timeout) % wait for press
%     [x, y, buttons] = GetMouse;
%     t1 = GetSecs;
%     % Wait 10 ms before checking the mouse again to prevent
%     % overload of the machine at elevated Priority()
%     WaitSecs(0.01);
% end
%
% %% WaitForLuminaPress
% %LUMINA RESPONSE BOX
% %needs a handle to a digital IO port hDIO
% %returns dio line status
% %x and y are unused dummies to keep compatibility with mouse
% function [x, y, buttons, t0, t1] = WaitForLuminaPress(hDIO, timeout)
% %function [x, y, buttons] = WaitForLuminaPress(hDIO, timeout)
% buttons = zeros(1, 8);
% t0 = GetSecs;
% t1 = t0;
% x = NaN;
% y = NaN;
% while (~any(buttons(1:4)) && (t1 - t0)<timeout) % wait for press
%     buttons = getvalue(hDIO);
%     t1 = GetSecs;
%     % Wait 1 ms before checking the DIO again to prevent
%     % overload of the machine at elevated Priority()
%
%     %CONSIDER REMOVING !!!!!!!!!!!!!!!!!!!
%     WaitSecs(0.001);
% end
% buttons = buttons(1:4); %ONLY USE FIRST 4 BUTTONS
%

% %% WaitForMousePressBenign
% %**************************************************************************
% %WAIT FOR MOUSE BUTTON PRESS UNTIL TIMEOUT HAS BEEN REACHED OR A BUTTON
% %HAS BEEN PRESSED
% %RETURNS
% %   X, Y:       CURSOR POSITION
% %   BUTTONS:    A VECTOR WITH LENGTH OF NUMBER OF MUSE BUTTONS,
% %               THE PRESSED BUTTON(S) HAS/HAVE A 1
% %   T0, T1:     TIME WHEN THE FUNCTION IS ENTERED AND LEFT
% %**************************************************************************
% function [x, y, buttons, t0, t1] = WaitForMousePressBenign(timeout)
% buttons = 0;
% t0 = GetSecs;
% t1 = t0;
% while (~any(buttons) && (t1 - t0)<timeout) % wait for press
%     [x, y, buttons] = GetMouse;
%     t1 = GetSecs;
%     % Wait 10 ms before checking the mouse again to prevent
%     % overload of the machine at elevated Priority()
%     WaitSecs(0.01);
% end

% %% ASF_PTBExit
% function Cfg = ASF_PTBExit(windowPtr, Cfg, errorFlag)
% % cleanup at end of experiment
% fprintf(1, 'Shutting down experiment ... ');
%
% % %GET VALID SCREEN TO PRINT ON
% % windowPtrs = Screen('Windows');
% % windowPtr = windowPtrs(1);
%
% switch errorFlag
%     case 0
%         Screen('DrawText', windowPtr, '... press mouse button ...', 10, 70);
%         Screen('Flip', windowPtr);
%         %WaitForMousePress(5);
%         WaitForMousePressBenign(5);
%         Screen('DrawText', windowPtr, '... THANKS ...', 10, 70, 255);
%         Screen('Flip', windowPtr);
%         WaitSecs(1);
%     otherwise
%         fprintf(1, 'DUE TO ERROR ... ');
% end
% Screen('CloseAll');
% ShowCursor;
% fclose('all');
% Priority(0);
% fprintf(1, 'DONE\n')
%
% %SHUT DOWN SERIAL PORT
% out = instrfind('Tag', 'SerialResponseBox');
% if  ~isempty(out)
%     fclose(out);
%     %MAYBE I NEED TO INVALIDATE THE HANDLE TO SERIAL PORT
%     %SUCH AS
%     %delete(Cfg.hardware.serial.oSerial)
% end
%
% %FIND ALL DIO STUFF THATY WE MAY HAVE CREATED
% daqdevices = daqfind;
% if not(isempty(daqdevices))
%     for i = length(daqdevices):-1:1
%         delete(daqdevices(i));
%     end
% end
%
%
% % switch Cfg.responseDevice
% %     case 'LUMINAPARALLEL'
% %         delete(Cfg.hardware.parallel.mydio_in)
% % end

function PTBCatchError
Screen('CloseAll');
ShowCursor;
fclose('all');
Priority(0);
psychrethrow(psychlasterror);


function test_stability(nFrames, windowPtr)
%% test_stability
%LOOP THROUGH TRIALS
VBLTimestamp(nFrames) = 0;
StimulusOnsetTime(nFrames) = 0;
FlipTimestamp(nFrames) = 0;

for i = 1:nFrames
    [VBLTimestamp(i), StimulusOnsetTime(i), FlipTimestamp(i)] = ShowTestTrial(i, windowPtr);
end

figure
subplot(2, 1, 1)
plot([diff(VBLTimestamp)', diff(StimulusOnsetTime)', diff(FlipTimestamp)']*1000, 'LineWidth', 2)
xlabel('TRIAL')
ylabel('Duration [ms]')
legend('VBLTimestamp', 'StimulusOnsetTime', 'FlipTimestamp')

subplot(2, 1, 2)
plot([VBLTimestamp(:), StimulusOnsetTime(:), FlipTimestamp(:)] - VBLTimestamp(1), 'LineWidth', 2)
xlabel('TRIAL')
ylabel('Duration [ms]')
legend('VBLTimestamp', 'StimulusOnsetTime', 'FlipTimestamp')

%% ShowTestTrial
%DRAW A NUMBER ON THE BACK BUFFER, FLIP BACK BUFFER TO FRONT
%SHOULD TAKE ONE FRAME
function [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = ShowTestTrial(i, windowPtr)
Screen('DrawText', windowPtr, sprintf('%04d', i), 10, 10);
[VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr);

%% timing_diagnosis
%TRIAL BY TRIAL COMPARISON OF REQUESTED AND ELAPSED TIMES FOR EACH PAGE
function timing_diagnosis(ExpInfo)
nTrials = length(ExpInfo.TrialInfo);
Cfg.plottrial = 0;

if Cfg.plottrial
    figure
end
for i = 1:nTrials

    %WAS
    %ti = ExpInfo.TrialInfo(i).timing(1:end-1, :);
    %req = ti(1:end-1, 1);
    ti = ExpInfo.TrialInfo(i).timing;
    if size(ti, 1) > 1
        req = ti(1:end-1, 1);

        %THIS REFERS TO NOMINAL FRAMERATE
        %perf = diff(ti(:, 2))*ExpInfo.Cfg.Screen.FrameRate;
        %THIS REFERS TO ACTUAL FRAMERATE
        pageDurationPerformed_ms = diff(ti(:, 2)-ti(1, 2)) *1000;
        pageDurationRequested_ms = ti(1:end-1, 1)*ExpInfo.Cfg.Screen.monitorFlipInterval*1000;

        %THIS IS EITHER A BUG IN LOGGING OR IN THE EXPERIMENT, CHECK IT!
        %pageDurationPerformed_ms(end) = pageDurationPerformed_ms(end) + pageDurationRequested_ms(end-1); %DON'T KNOW WHY, LOGGING SEEMS TO FORGET THE STIMULUS DURATION

        deltams = pageDurationPerformed_ms - pageDurationRequested_ms;


        deltamat(i, 1:length(deltams)) = deltams(:)';
        x = [pageDurationRequested_ms(:), pageDurationPerformed_ms(:), pageDurationPerformed_ms(:) - pageDurationRequested_ms(:), deltams];

        if Cfg.plottrial
            %PLOT
            set(gcf, 'Name', sprintf('Trial %04d', i))
            subplot(1,2,1)
            bar(x(:, 1:3))
            title('Timing of Pages')
            xlabel('Page')
            ylabel('Frames')
            legend('requested', 'performed', 'deviation')
            subplot(1,2,2)
            plot(x(:, 4), 'LineWidth', 2)
            xlabel('Page')
            ylabel('ms')
            if max(deltams) < 5
                set(gca, 'ylim', [-5 5])
            end
            title('Timing of Pages: Deviation in ms')

            pause
        end
    end

end

[nRows, nCols] = size(deltamat);
if nCols > 1 %ADDITIONAL SAFETY MEASURE AGAINST CRASH

    figure
    surf(deltamat)
    %mybar3(deltamat)
    shading interp
    xlabel('Page Number')
    ylabel('Trial Number')
    zlabel('Deviation [ms]')
    title('Timing Accuracy of Experiment')
    %set(gca, 'zlim', [-20 20])
    %set(gca, 'xtick', 1:size(deltamat, 2))
end

function mybar3(tmpr)
bh = bar3(tmpr');
Z = tmpr';
view(-145, 34)
%     set(gca, 'CameraPosition', [-12, -58,  3])
xlabel('x')
ylabel('y')
%set(gca, 'ytick', 1:nRows, 'yticklabel', 1:Rows )
%set(gca, 'xtick', 1:5, 'xticklabel', (5:-1:1)-3 )

%SHADED COLORS
for i2 = 1:length(bh)
    zdata = ones(6*length(bh),4);
    k2 = 1;
    for j2 = 0:6:(6*length(bh)-6)
        zdata(j2+1:j2+6,:) = Z(k2,i2);
        k2 = k2+1;
    end
    set(bh(i2),'Cdata',zdata)
end

%colorbar

shading interp
for i2 = 1:length(bh)
    zdata = get(bh(i2),'Zdata');
    set(bh(i2),'Cdata',zdata)
    set(bh,'EdgeColor','k')
end



%% INPUT-OUTPUT LOW-LEVEL
function Cfg = InitDigitalOutput(Cfg)
if ~isfield(Cfg, 'hardware'), Cfg.hardware = []; else end
if ~isfield(Cfg.hardware, 'DigitalOutput'), Cfg.hardware.DigitalOutput = []; else end
%if ~isfield(Cfg.hardware.parallel, 'ON'), Cfg.hardware.parallel.ON = 0; Cfg.hardware.parallel.OFF = 1;else end
switch Cfg.digitalOutputDevice
    case 'NONE'
    case 'PARALLEL'
        Cfg = InitParallelPortOutput(Cfg);
    case 'NIDAQ2'
        Cfg = InitNidaqOutput(Cfg);
    case 'ARDUINO'
        Cfg = InitArduinoOutput(Cfg);
end

%% InitArduino
function Cfg = InitArduinoOutput(Cfg)
fprintf('INITIALIZING ARDUINO BOARD ON %s\n', Cfg.hardware.Arduino.comPort.port);

%    s = serial('COM4', 'BaudRate', 9600);

Cfg.hardware.Arduino.hSerial =...
    serial(Cfg.hardware.Arduino.comPort.port,...
    'BaudRate', Cfg.hardware.Arduino.comPort.baudRate);
fopen(Cfg.hardware.Arduino.hSerial);
Cfg.hardware.Arduino.hSerial
Cfg.hardware.Arduino.useArduino = 1;


%% InitParallelPortOutput
function Cfg = InitParallelPortOutput(Cfg)
if ~isfield(Cfg, 'hardware'), Cfg.hardware = []; else end
if ~isfield(Cfg.hardware, 'parallel'), Cfg.hardware.parallel = []; else end
if ~isfield(Cfg.hardware.parallel, 'ON'), Cfg.hardware.parallel.ON = 0; Cfg.hardware.parallel.OFF = 1;else end

fprintf(1, 'INITIALIZING PARALLEL PORT ...\n');


% OPEN PARPORT
Cfg.hardware.DigitalOutput.mydio = digitalio('parallel');

% SET THE HIGHEST SPEED POSSIBLE
set(Cfg.hardware.DigitalOutput.mydio, 'TimerPeriod', 0.001)

%SUGGESTED BY AL
%CHECK!
%Cfg.hardware.parallel.mydio = digitalio('parallel');
%set(Cfg.hardware.parallel.mydio, 'TimerPeriod', 0.001)
%addline(Cfg.hardware.parallel.mydio, 0:7, 'out', 'TriggerPort')
%Cfg.hardware.parallel.dioinfos = getvalue(Cfg.hardware.parallel.mydio)

%
% PortID Pins         Description
% 0      2-9          Eight I/O lines, with pin 9 being the most significant bit (MSB).
% 1      10-13,15     Five input lines used for status
% 2      1, 14, 16,17 Four I/O lines used for control

% First Line of Port TWO, i.e. PIN1, has LineID 13
% First Line of Port ZERO, i.e. PIN2, has LineID 1

% SET PORT AS AN OUTPUT
addline(Cfg.hardware.DigitalOutput.mydio, 0:7, 'out', 'TriggerPort')

%Cfg.hardware.parallel.ON=0; Cfg.hardware.parallel.OFF=1; %Reverse Logic

Cfg.hardware.DigitalOutput.dioinfos = getvalue(Cfg.hardware.parallel.mydio); %#ok<NOPRT>
fprintf(1, 'DONE\n');



function Cfg = InitNidaqOutput(Cfg)
if ~isfield(Cfg, 'hardware'), Cfg.hardware = []; else end
if ~isfield(Cfg.hardware, 'nidaq'), Cfg.hardware.nidaq = []; else end
if ~isfield(Cfg.hardware.nidaq, 'ON'), Cfg.hardware.nidaq.ON = 0; Cfg.hardware.nidaq.OFF = 1;else end

fprintf(1, 'INITIALIZING NATIONAL INSTRUMENTS CARD...\n');
% OPEN PARPORT
Cfg.hardware.DigitalOutput.mydio = digitalio('nidaq','Dev2');
% SET THE HIGHEST SPEED POSSIBLE
%set(Cfg.hardware.parallel.mydio, 'TimerPeriod', 0.001)

%
% PortID Pins         Description
% 0      2-9          Eight I/O lines, with pin 9 being the most significant bit (MSB).
% 1      10-13,15     Five input lines used for status
% 2      1, 14, 16,17 Four I/O lines used for control

% First Line of Port TWO, i.e. PIN1, has LineID 13
% First Line of Port ZERO, i.e. PIN2, has LineID 1

% SET PORT AS AN OUTPUT
addline(Cfg.hardware.DigitalOutput.mydio, 0:7, 'out', 'TriggerPort')

%Cfg.hardware.parallel.ON=0; Cfg.hardware.parallel.OFF=1; %Reverse Logic

Cfg.hardware.DigitalOutput.dioinfos = getvalue(Cfg.hardware.DigitalOutput.mydio) %#ok<NOPRT>
%THIS ENSURES A PREDEFINED STATE AND ALSO THAT ASF_setTrigger is loaded
ASF_setTrigger(Cfg, 0);

fprintf(1, 'DONE\n');


%% InitParallelPortInput
function Cfg = InitParallelPortInput(Cfg)
if ~isfield(Cfg, 'hardware'), Cfg.hardware = []; else end
if ~isfield(Cfg.hardware, 'parallel'), Cfg.hardware.parallel = []; else end
if ~isfield(Cfg.hardware.parallel, 'ON'), Cfg.hardware.parallel.ON = 0; Cfg.hardware.parallel.OFF = 1;else end

fprintf(1, 'INITIALIZING PARALLEL PORT FOR INPUT\n');
% OPEN PARPORT
Cfg.hardware.parallel.mydio_in = digitalio('parallel');

% SET THE HIGHEST SPEED POSSIBLE
set(Cfg.hardware.parallel.mydio_in, 'TimerPeriod', 0.001)

%
% PortID Pins         Description
% 0      2-9          Eight I/O lines, with pin 9 being the most significant bit (MSB).
% 1      10-13,15     Five input lines used for status
% 2      1, 14, 16,17 Four I/O lines used for control

% First Line of Port TWO, i.e. PIN1, has LineID 13
% First Line of Port ZERO, i.e. PIN2, has LineID 1

% SET PIN1 AS AN OUTPUT
% addline(Cfg.hardware.parallel.mydio, 13, 'out','OutPutLine')

% SET PIN2 AS AN OUTPUT
%addline(Cfg.hardware.parallel.mydio, 1, 'out','OutPutLine')

% SET PORT AS AN OUTPUT
%addline(Cfg.hardware.parallel.mydio, 0:7, 'out', 'TriggerPort')

% SET PORT AS AN INPUT AND OUTPUT
addline(Cfg.hardware.parallel.mydio_in, 0:7, 'In', 'LuminaPort') %MAYBE 8:12 PINS [10:13, 15]

%Cfg.hardware.parallel.ON=0; Cfg.hardware.parallel.OFF=1; %Reverse Logic

Cfg.hardware.parallel.dioinfos = getvalue(Cfg.hardware.parallel.mydio_in) %#ok<NOPRT>
fprintf(1, 'DONE\n');

% %% ***TRIGGERING***
% %% setTrigger
% function setTrigger(Cfg, TriggerVal)
% if Cfg.issueTriggers
%     putvalue(Cfg.hardware.DigitalOutput.mydio.TriggerPort, TriggerVal);
% end


%% ***MR SCANNER RELATED STUFF***
% %% WaitForScannerSynch
% function WaitForScannerSynch(windowPtr, Cfg)
% Screen('DrawText', windowPtr, 'WAITING FOR SCANNER ...', 10, 170);
% Screen('Flip', windowPtr);
% switch Cfg.synchToScannerPort
%     case 'PARALLEL'
%         WaitForScannerSynchParallel(Cfg.hardware.parallel.mydio_in.LuminaPort, Cfg.scannerSynchTimeOutMs);
%     case 'SERIAL'
%         WaitForScannerSynchSerial(Cfg.hardware.serial.oSerial, Cfg.scannerSynchTimeOutMs)
%     case 'SIMULATE'
%         WaitForScannerSynchSimulated(Cfg, windowPtr, Cfg.scannerSynchTimeOutMs);
% end
% %Screen('DrawText', windowPtr, 'DONE', 10, 170);
% Screen('Flip', windowPtr);
%
% %% WaitForScannerSynchSimulated
% function WaitForScannerSynchSimulated(Cfg, windowPtr, timeoutMilliSeconds)
% t0 = GetSecs;
% t1 = t0;
%
% while( (GetSecs - t0) < timeoutMilliSeconds/1000)
%     WaitSecs(0.001);
%     ASF_checkforuserabort(windowPtr, Cfg);
% end
%
% %% WaitForScannerSynchParallel
% function WaitForScannerSynchParallel(hDIO, timeout)
% synchSignal = 0;
% output = zeros(1, 8); %#ok<NASGU>
% t0 = GetSecs;
% t1 = t0;
%
% while( (~synchSignal) &&( (t1- t0) < timeout))
%     output = getvalue(hDIO);
%     synchSignal = output(5);
%     t1 = GetSecs;
%     WaitSecs(0.001);
% end
%
% %% WaitForScannerSynchSerial
% function WaitForScannerSynchSerial(hSerial, timeout)
%
% contflag = 1;
% tStart = GetSecs;
% while contflag
%     if hSerial.BytesAvailable
%         sbuttons = str2num(fscanf(hSerial)); %#ok<ST2NM>
%         %CLEAN UP IN CASE MONKEY GOES WILD
%         while hSerial.BytesAvailable
%             junk = fscanf(hSerial); %#ok<NASGU>
%         end
%         if sbuttons == 5
%             contflag = 0;
%         end
%     else
%         %NOTHING AVAILABLE, CHECK TIMEOUT
%         if (GetSecs - tStart) > timeout
%             return;
%         end
%     end
% end
%

%DETERMINE RENDERING FUNCTION
function fHandle = determineRenderingFunction(Cfg)
%THIS FUNCTION DETERMINES WHICH FUNCTION IS USED TO ACTUALLY PRESENT A
%TRIAL. SOME FLEXIBILITY IS ALREADY IN ASF, e.g. USING A VOICE KEY
%REQUIRES SOME DIFFERENT PROGRAMMING LOGIC THAN POLLING A MOUSE BUTTON.
%USERS GET EVEN MORE FLEXIBILITY BY PROVIDING THEIR OWN STIMULUS FUNCTIONS
%THAT CAN EVEN HAVE COMPLETELY NEW FUNCTIONALITY SUCH AS RENDERING THE
%STIMULUS ONLINE INSTEAD OF JUST PLAYING BACK PREDEFINED BITMAPS.
%THE USER-SUPPLIED FUNCTION MUST COMPLY TO THE FOLLOWING CONVENTIONS:
%function [this_response, timing, StartRTMeasurement, EndRTMeasurement] = MyTrialFunction(atrial, windowPtr, tex, Cfg)
%
if isa(Cfg.userSuppliedTrialFunction, 'function_handle')
    fHandle = Cfg.userSuppliedTrialFunction;
else
    switch Cfg.responseDevice
        case {'MOUSE', 'LUMINAPARALLEL', 'LUMINASERIAL', 'KEYBOARD'}
            fHandle = @ShowTrial;
        case 'VOICEKEY'
            fHandle = @ShowTrialVK;
    end
end


