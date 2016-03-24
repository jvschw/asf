%% InitResponseDevice
function Cfg = ASF_initResponseDevice(Cfg)

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
        %Cfg.Hardware.parallel.mydio_in
        Cfg = ASF_initParallelPortInput(Cfg);
        fprintf(1, 'DONE INITIALIZING LUMINA\n');

    
     case 'LUMINASERIAL'
        if ~isfield(Cfg, 'Hardware'), Cfg.Hardware = []; else end
        if ~isfield(Cfg.Hardware, 'serial'), Cfg.Hardware.serial = []; else end
        if ~isfield(Cfg.Hardware.serial, 'BaudRate'), Cfg.Hardware.serial.BaudRate = 115200;else end 
        
        fprintf(1, 'CREATING SERIAL OBJECT ... ');
        Cfg.Hardware.serial.oSerial = serial('COM1', 'Tag', 'SerialResponseBox', 'BaudRate', Cfg.Hardware.serial.BaudRate);
        set(Cfg.Hardware.serial.oSerial, 'Timeout', 0.001) %RECONSIDER
        Cfg.Hardware.serial.oSerial.Terminator = '';
        set(Cfg.Hardware.serial.oSerial,'InputBufferSize',128)
        %Cfg.Hardware.serial.oSerial.ReadAsyncMode = 'manual';%'continuous';
        %Cfg.Hardware.serial.ClassSerial = class(Cfg.Hardware.serial, 'SerialResponseBox');
        %dummy = warning( 'off', 'instrument:fscanf:unsuccessfulRead')
        warning off all %THIS IS NASTY!!! We do this because of timeout warning
        fprintf(1, 'DONE\n');
        fprintf(1, 'STARTING SERIAL COMMUNICATION WITH SERIAL RESPONSE BOX (BAUD RATE: %d) ... ', Cfg.Hardware.serial.BaudRate);
        fopen(Cfg.Hardware.serial.oSerial);
        fprintf('DONE\n')
        %Cfg.Hardware.serial.oSerial.BytesAvailable
    case  'KEYBOARD'
        fprintf(1, 'USING KEYBOARD AS RESPONSE DEVICE\n');

end
