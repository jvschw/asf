# Configuration options #

CONFIGURATIONS. Options are given in [.md](.md) with default being between {}

```
DISPLAY:
 * Cfg.Screen.rect                       = [{[]}, [ulRowStart, ulColStart, ulRowEnd, ulColEnd] ]
 * Cfg.Screen.useBackBuffer              = [ 0 | {1} ]   %USE AUXILIARY BACKBUFFERS FOR PAGE FLIPPING
 * Cfg.Screen.color                      = [{[255, 255, 255]}|[R, G, B]] %DEFAULTS TO WHITE BACKGROUND
 * Cfg.Screen.Resolution.width           = [{width of current video resolution}] %
 * Cfg.Screen.Resolution.height          = [{heigth of current video resolution}]
 * Cfg.Screen.Resolution.pixelSize       = [{color depth of current video resolution}]
 * Cfg.Screen.Resolution.hz              = [{refresh rate of current video resolution}]
 * Cfg.Screen.fontSize                   = [{24}]
 * Cfg.Screen.fontName                   = {'Courier New'}

SOUND:
 * Cfg.Sound.soundMethod                 = [{'none'}|'psychportaudio'|'audioplayer'|'wavplay'|'snd']
 
RESPONSE
 * Cfg.responseDevice                    = [ {'MOUSE'}|'VOICEKEY'|'LUMINAPARALLEL'|'SERIAL'|'KEYBOARD' ]
 * Cfg.responseTerminatesTrial           = [ {0}, 1 ]
 * Cfg.waitUntilResponseAfterTrial       = [ {0}, 1 ]
 * Cfg.plotVOT                           = [ {0}, 1 ]    %PLOT VOICE ONSET TIMES, REQUIRES TWO SCREENS
 * Cfg.Eyetracking.useEyelink            = [ {0}, 1 ]    %USE EYELINK
 * Cfg.Eyetracking.useEyelinkMouseMode   = [ {0}, 1 ]    %SIMULATE EYE BY MOUSE
 
TRIGGERING
 * Cfg.issueTriggers                     = [ {0} | 1 ] %ALLOWS TRIGGERING, REQUIRES DATA ACQUISITION TOOLBOX
 * Cfg.validTriggerValues                = [{[]}, vectorOfValues] %ALLOWS RESTRICTING WHICH PAGES RELEASE A TRIGGER [] means all valid
 * Cfg.synchToScanner                    = [ {0} | 1 ] %WAIT FOR EXTERNAL SIGNAL (E.G. TRIGGER FROM MR-SCANNER)
 * Cfg.synchToScannerPort                = [{'PARALLEL'}|'SERIAL', 'SIMULATE']; %PORT FOR EXTERNAL SYNCH SIGNAL
 * Cfg.scannerSynchTimeOutMs             = [ {inf} ] %TIMEOT IN MILLISECONDS WHEN WAITING FOR SCANNER TRIGGER ON ANY PORT
 * Cfg.digitalInputDevice                = [ {'NONE'}|'PARALLEL'|'NIDAQ2' ]
 * Cfg.digitalOutputDevice               = [ {'NONE'}|'PARALLEL'|'NIDAQ2' ]
 * Cfg.ScannerSynchShowDefaultMessage    = [0|{1}]
 * Cfg.scannerSynchTimeOutMs             = {inf} %BY DEFAULT WAIT FOREVER
 * Cfg.serialPortName                    = [ {'COM1'}, ... 'COMn' ]
 
TIMING
 * Cfg.useTrialOnsetTimes                 = [ {0} | 1 ] %THIRD COLUMN IN TRIAL-DEFINITION FILE DETERMINES WHEN TRIAL IS STARTED WR TO START OF EXPT
 
FEEDBACK
 * Cfg.feedbackTrialCorrect               = [ {0} | 1 ] %BEEP FOR CORRECT RESPONSES %WILL BECOME FREQUENCY AND DURATION
 * Cfg.feedbackTrialError                 = [ {0} | 1 ] %BEEP FOR INCORRECT RESPONSES %WILL BECOME FREQUENCY AND DURATION
 
USER SUPPLIED
 * Cfg.userSuppliedTrialFunction          = [ {[]} | FUNCTIONHANDLE ]
 * Cfg.userDefinedSTMcolumns              = [ {0} | nColumns ]
 
MISC
 * Cfg.randomizeTrials                   = [ {0} | 1 ] %TRIALWISE RANDOMIZATION OF CONTENT OF STM-FILE
 * Cfg.randomizeTrialsNoImmediateRepeat  = [ {0} | 1 ] %RESTRICTED RANDOMIZATION
```
