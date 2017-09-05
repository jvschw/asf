%% WaitForScannerSynch
function ASF_waitForScannerSynch(windowPtr, Cfg)
if ~isfield(Cfg, 'scannerSynchTimeOutMs'), Cfg.scannerSynchTimeOutMs = inf; else end;

if Cfg.ScannerSynchShowDefaultMessage
    fprintf(1, 'WAITING FOR SCANNER ... ');
    if ~isempty(windowPtr)
        Screen('DrawText', windowPtr, 'WAITING FOR SCANNER ...', 10, 170);
        Screen('Flip', windowPtr);
    end
end

%SEE also ASFInit() to find out which digital input line has been configured for
%the synch signal
switch Cfg.synchToScannerPort
    case 'PARALLEL' %PIN X ON PARALLEL PORT
        WaitForScannerSynchParallel(Cfg.Hardware.parallel.mydio_in.LuminaPort, Cfg.scannerSynchTimeOutMs);
    case 'SERIAL' %BUTTON NUMBER 5 ON SERIAL PORT (defined for Lumina Response Box)
        WaitForScannerSynchSerial(Cfg.Hardware.Serial.oSerial, Cfg.scannerSynchTimeOutMs)
    case 'SIMULATE'
        WaitForScannerSynchSimulated(Cfg, windowPtr, Cfg.scannerSynchTimeOutMs);
    case 'KEYBOARD'
        WaitForScannerSynchKeyboard(Cfg, Cfg.scannerSynchTimeOutMs);
    case 'NISES' %NATIONAL INSTRUMENTS CARD THROUGH MATLAB DATA ACQUISITION TOOLBOX (PORT A0)
        WaitForScannerSynchNises(Cfg.Hardware.nises.s,  Cfg.scannerSynchTimeOutMs);
end

if Cfg.ScannerSynchShowDefaultMessage
    fprintf(1, 'DONE.\n');
    %Screen('DrawText', windowPtr, 'DONE', 10, 170);
    if ~isempty(windowPtr)
        Screen('Flip', windowPtr);
    end
end

%% WaitForScannerSynchSimulated
function WaitForScannerSynchSimulated(Cfg, windowPtr, timeoutMilliSeconds)
t0 = GetSecs;
t1 = t0;

while( (GetSecs - t0) < timeoutMilliSeconds/1000)
    WaitSecs(0.001);
    ASF_checkforuserabort(windowPtr, Cfg);
end

%% WaitForScannerSynchNises
function WaitForScannerSynchNises(hDIO, timeoutMilliSeconds)
synchSignal = 0;
t0 = GetSecs;
t1 = t0;

while( (~synchSignal) &&( (t1- t0) < timeoutMilliSeconds/1000))
    synchSignal = inputSingleScan(hDIO);
    wait(hDIO) %TIMEOUT SHOULD GO IN HERE, NOT IN THE OUTER LOOP 
    t1 = GetSecs;
    WaitSecs(0.001);
end

%% WaitForScannerSynchParallel
function WaitForScannerSynchParallel(hDIO, timeoutMilliSeconds)
synchSignal = 0;
output = zeros(1, 8); %#ok<NASGU>
t0 = GetSecs;
t1 = t0;

while( (~synchSignal) &&( (t1- t0) < timeoutMilliSeconds/1000))
    output = getvalue(hDIO);
    synchSignal = output(5);
    t1 = GetSecs;
    WaitSecs(0.001);
end

%% WaitForScannerSynchSerial
function WaitForScannerSynchSerial(hSerial, timeoutMilliSeconds)

contflag = 1;
tStart = GetSecs;
while contflag
    if hSerial.BytesAvailable
        sbuttons = str2num(fscanf(hSerial)); %#ok<ST2NM>
        %CLEAN UP IN CASE MONKEY GOES WILD
        while hSerial.BytesAvailable
            junk = fscanf(hSerial); %#ok<NASGU>
        end
        if sbuttons == 5
            contflag = 0;
        end
    else
        %NOTHING AVAILABLE, CHECK TIMEOUT
        if (GetSecs - tStart) > timeoutMilliSeconds/1000
            return;
        end
    end
end

function WaitForScannerSynchKeyboard(Cfg, timeoutMilliSeconds)
% t0 = GetSecs;
%
% while( (GetSecs - t0) < timeoutMilliSeconds/1000)
%     %timeSecs = KbWait([], [], GetSecs + timeoutMilliSeconds/1000); %single key stroke
%     timeSecs = KbWait; %single key stroke
%     [ keyIsDown, t, keyCode ] = KbCheck
%     if keyIsDown
%         fprintf('"%s" typed\n', KbName(keyCode));
%     end
% end
%

if timeoutMilliSeconds > 0
    t0 = GetSecs;
    while( (GetSecs - t0) < timeoutMilliSeconds/1000)
        [ch, when] = GetChar;
        %fprintf(1, '%12.2f %d\n', when.secs - t0, ch);
        if (ch==Cfg.triggerKey)
            break;
        end
        %
        %     % Check the state of the keyboard.
        %     [ keyIsDown, seconds, keyCode ] = KbCheck([], [], GetSecs + 0.05);
        %     fprintf(1, '%12.2f %d\n', GetSecs - t0, keyIsDown);
        %
        %     % If the user is pressing a key, then display its code number and name.
        %     if keyIsDown
        % 5
        %         % Note that we use find(keyCode) because keyCode is an array.
        %         % See 'help KbCheck'
        %         fprintf('You pressed key %i which is %s\n', find(keyCode), KbName(keyCode));
        %
        %         if keyCode(Cfg.triggerKey)
        %             break;
        %         end
        %
        %         % If the user holds down a key, KbCheck will report multiple events.
        %         % To condense multiple 'keyDown' events into a single event, we wait until all
        %         % keys have been released.
        %         KbReleaseWait;
        %     end
    end
end
