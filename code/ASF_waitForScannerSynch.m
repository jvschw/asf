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
switch Cfg.synchToScannerPort
    case 'PARALLEL'
        WaitForScannerSynchParallel(Cfg.hardware.parallel.mydio_in.LuminaPort, Cfg.scannerSynchTimeOutMs);
    case 'SERIAL'
        WaitForScannerSynchSerial(Cfg.hardware.serial.oSerial, Cfg.scannerSynchTimeOutMs)
    case 'SIMULATE'
        WaitForScannerSynchSimulated(Cfg, windowPtr, Cfg.scannerSynchTimeOutMs);
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
