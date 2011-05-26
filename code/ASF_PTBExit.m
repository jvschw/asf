%function cfg = ASF_PTBExit(windowPtr, cfg, errorFlag, varargin)
function Cfg = ASF_PTBExit(windowPtr, Cfg, errorFlag, varargin)
%% PTBExit
% cleanup at end of experiment
fprintf(1, 'Shutting down experiment ... ');
if ~isempty(varargin)
    errorMsg = varargin{1};
else
    errorMsg = 'NO ERROR MESSAGE PROVIDED';
end

% %GET VALID SCREEN TO PRINT ON
% windowPtrs = Screen('Windows');
% windowPtr = windowPtrs(1);

switch errorFlag
    case 0
        Screen('DrawText', windowPtr, '... press mouse button ...', 10, 70);
        Screen('Flip', windowPtr);
        %WaitForMousePress(5);
        ASF_waitForMousePressBenign(5);
        Screen('DrawText', windowPtr, '... THANKS ...', 10, 70, 255);
        Screen('Flip', windowPtr);
        WaitSecs(1);
        
    otherwise
        %TRY SAVING THE DATA
        fprintf(1, 'DUE TO ERROR ... \n%s\n', errorMsg);
end

%CLOSE ALL PTB SCREENS
Screen('CloseAll');

% %RESTORE ORIGINAL SCREEN RESOLUTION IF POSSIBLE
% HAS A BUG WITH DUAL MONITOR
% if isfield(Cfg, 'oldResolution')
%     Screen('Resolution', 0, Cfg.oldResolution.width, Cfg.oldResolution.height, Cfg.oldResolution.hz, Cfg.oldResolution.pixelSize);
% end

%RESTORE MOUSE POINTER
ShowCursor;

%CLOSE ALL OPEN FILES
fclose('all');

%CLOSE AUDIO
% Stop playback:
switch Cfg.Sound.soundMethod
    case 'psychportaudio'
        fprintf(1, 'Closing PsychPortAudio ...');
        PsychPortAudio('Stop', Cfg.Sound.pahandle);
        % Close the audio device:
        PsychPortAudio('Close', Cfg.Sound.pahandle);
        fprintf(1, ' DONE.\n');
    case 'audioplayer'
        warning('method for closing audioplayer not yet programmed')
    case 'wavplay'
end

switch Cfg.responseDevice
    case 'VOICEKEYPPA'
        fprintf(1, 'Closing PsychPortAudio ...');
        % Close the audio device:
        PsychPortAudio('Close', Cfg.audio.pahandle);
        fprintf(1, ' DONE.\n');
end

%RESORE TO NORMAL PRIORITY
Priority(0);
fprintf(1, 'DONE\n')

%SHUT DOWN SERIAL PORT
out = instrfind('Tag', 'SerialResponseBox');
if  ~isempty(out)
    fclose(out);
    %MAYBE I NEED TO INVALIDATE THE HANDLE TO SERIAL PORT
    %SUCH AS
    %delete(cfg.hardware.serial.oSerial)
    Cfg.hardware.serial = [];
end

%ANY TAKS RUNNING ON THE NI CARD?
if Cfg.TMS.burstMode.on
    ASF_PulseTrainStopPulseTask(Cfg.hBurstTmsTask);
    [status, Cfg.hBurstTmsTask] = ASF_PulseTrainClearPulseTask(Cfg.hBurstTmsTask);
    %MAYBE SAY SOMETHING ABOUT THE STATUS
    ASF_PulseTrainUnloadNIDAQmx
end

%FIND ALL DIO STUFF THATY WE MAY HAVE CREATED
%if exist('DaqFind', 'file') == 2
if exist('PsychHID.dll', 'file') == 2
    daqdevices = DaqFind;
    if not(isempty(daqdevices))
        for i = length(daqdevices):-1:1
            delete(daqdevices(i));
        end
        if isfield(Cfg.hardware, 'DigitalOutput')
            Cfg.hardware.DigitalOutput = [];
        end
    end
end

if Cfg.StimulationDevices.usePiezo
    calllib('stimlib', 'closeStimulator');
    fprintf(1, 'UNMOUNTING PIEZO STIMULATOR ...');
    unloadlibrary stimlib
    fprintf(1, 'DONE.\n');
end

%CLOSE CONNECTION TO ARDUINO
if Cfg.hardware.Arduino.useArduino
    fclose(Cfg.hardware.Arduino.hSerial);
    %clear(Cfg.hardware.Arduino.hSerial)
end

% %KILL WHATEVER
% if ~isempty(instrfind)
%     fclose(instrfind)
% end

if errorFlag
    error('PROGRAM TERMINATED')
end


