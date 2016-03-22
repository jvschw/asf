function [edfFile, el, status, stopkey, startkey, eye_used] = ASF_initEyelinkConnection(useEyelinkMouseMode, doCalibration, doDriftCorr, windowPtr, edfName)
%function [edfFile, el, status, stopkey, startkey, eye_used] = ASF_initEyelinkConnection(useEyelinkMouseMode, doCalibration, doDriftCorr, windowPtr, edfName, varargin)
% define connection mode and initialize connection as configured in ASF
% created by Angelika Lingnau, 2008-01-26
% 16-05-2008 included calibration into code
%            start key: left mouse instead of middle mouse
%            optional use of calibration and drift correction
% 01-08-2008 added code to show large calibration targets for
%            low vision patients


%JS VERSION
% Initialize 'el' eyelink struct with proper defaults for output to
% window 'w':

%el=ASF_EyelinkInitDefaults(windowPtr);
el = EyelinkInitDefaults(windowPtr);

if ~EyelinkInit([], 1)
    fprintf('Eyelink Init aborted.\n');
    %cleanup;
    return;
end
% Perform tracker setup: The flag 1 requests interactive setup with
% video display:
result = Eyelink('StartSetup',1);


% Perform drift correction: The special flags 1,1,1 request
% interactive correction with video display:
% You have to hit esc before return.
rect = Screen(windowPtr, 'Rect');
midX = round((rect(3) - rect(1)+1)/2);
midY = round((rect(4) - rect(2)+1)/2);
%result = Eyelink('DriftCorrStart',midX,midY,1,1,1);


%textOut=1; %write reports from tracker to stdout
%edfFile = sprintf('%s.edf', expName);
edfFile = edfName; %WE NEED TO ADD CODE THAT MAKES SURE THAT THE FILENAME IS NOT LONGER THAN 8 CHARACTERS

%--------initialize eyelink default settings-----------
%el=EyelinkInitDefaults(windowPtr);
%el=EyelinkInitDefaults(windowPtr, largeCalibTargets);

   


status=Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT');
status=Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');

if status~=0
    error('link_sample_data error, status: ', status); % make sure that we get gaze data from the Eyelink
end

%--------open data file if data are recorded-----------
status=Eyelink('openfile',edfFile); % open file to record data to
if status~=0
    error('openfile error, status: ',status)
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
startkey=KbName('s'); %was middle_mouse

%--------just an initializer to remind us to ask tracker which eye is tracked--------
eye_used = -1; 
return


% if isempty(varargin)==0
%     largeCalibTargets = 1;
% else
%     largeCalibTargets = 0;
% end

%----check connection status and connect if required----
switch useEyelinkMouseMode
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

Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,AREA');
Eyelink('command', 'link_event_data = GAZE,GAZERES,HREF,AREA,VELOCITY');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,BLINK,SACCADE,BUTTON');

% 
% 
% status=Eyelink('command','link_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT');
% if status~=0
%     error('link_sample_data error, status: ', status); % make sure that we get gaze data from the Eyelink
% end
% 
% status=Eyelink('command','file_event_data = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT');
% if status~=0
%     error('file_event_data error, status: ', status); % make sure that we get gaze data from the Eyelink
% end
% 

%--------open data file if data are recorded-----------
status=Eyelink('openfile',edfFile); % open file to record data to
if status~=0
    error('openfile error, status: ',status)
end

%--------perform calibration and drift correction if gaze data are collected-----------
if useEyelinkMouseMode==0
    if doCalibration==1
        EyelinkDoTrackerSetup(el);
    end
    if doDriftCorr==1
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

    