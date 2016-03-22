function [edfFile, Cfg] = ASF_initEyelinkConnection(Cfg, windowPtr, edfName)
%function [edfFile, el, status, stopkey, startkey, eye_used] = ASF_initEyelinkConnection(useEyelinkMouseMode, doCalibration, doDriftCorr, windowPtr, edfName)
%function [edfFile, el, status, stopkey, startkey, eye_used] = ASF_initEyelinkConnection(useEyelinkMouseMode, doCalibration, doDriftCorr, windowPtr, edfName, varargin)
% define connection mode and initialize connection as configured in ASF
% created by Angelika Lingnau, 2008-01-26
% 16-05-2008 included calibration into code
%            start key: left mouse instead of middle mouse
%            optional use of calibration and drift correction
% 01-08-2008 added code to show large calibration targets for
%            low vision patients

% if isempty(varargin)==0
%     largeCalibTargets = 1;
% else
%     largeCalibTargets = 0;
% end

%----check connection status and connect if required----
switch Cfg.Eyetracking.useEyelinkMouseMode
    case 1 %use mouse instead of gaze, initialize dummy connection to the eye tracker
        if (Eyelink('Initializedummy') ~= 0)
            error('could not init connection to Eyelink')
%             return;
        end
    case 0 %use gaze position; initialize real connection to the eye tracker
        if (Eyelink('Initialize') ~= 0)
            error('could not init connection to Eyelink')
%             return;
        end
end

%textOut=1; %write reports from tracker to stdout
%edfFile = sprintf('%s.edf', expName);
edfFile = edfName; %WE NEED TO ADD CODE THAT MAKES SURE THAT THE FILENAME IS NOT LONGER THAN X CHARACTERS

%--------initialize eyelink default settings-----------
el=EyelinkInitDefaults(windowPtr);
%el=EyelinkInitDefaults(windowPtr, largeCalibTargets);

status=Eyelink('command','link_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT');
if status~=0
    error('link_sample_data error, status: ', status); % make sure that we get gaze data from the Eyelink
end

%--------open data file if data are recorded-----------
status=Eyelink('openfile',edfFile); % open file to record data to
if status~=0
    error('openfile error, status: ',status)
end

%--------perform calibration and drift correction if gaze data are collected-----------
if Cfg.Eyetracking.useEyelinkMouseMode==0
    if Cfg.Eyetracking.doCalibration==1
        EyelinkDoTrackerSetup(el);
    end
    if Cfg.Eyetracking.doDriftCorrection==1
        EyelinkDoDriftCorrect(el);
    end
end
%--------start recording eye position--------
status=Eyelink('startrecording'); 
if status~=0
    error('startrecording error, status: ',status)
end

%--------record a few samples before we actually start displaying--------
WaitSecs(0.1); 

%--------mark zero-plot time in data file--------
status=Eyelink('message','SYNCTIME'); 
if status~=0
    error('message error, status: ',status)
end

%--------initialize keys--------
stopkey=KbName('space');
startkey=KbName('middle_mouse');

%--------just an initializer to remind us to ask tracker which eye is tracked--------
eye_used = -1; 
Cfg.Eyetracking.status = status;
Cfg.Eyetracking.stopkey = stopkey;
Cfg.Eyetracking.startkey = startkey;
Cfg.Eyetracking.el = el;
Cfg.Eyetracking.eye_used = eye_used;
Cfg.Eyetracking.edfName = edfName;

    