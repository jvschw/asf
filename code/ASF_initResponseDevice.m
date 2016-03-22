%% InitResponseDevice
function Cfg = ASF_initResponseDevice(Cfg)

switch Cfg.responseDevice
    
    case 'MOUSE'
        fprintf(1, 'USING MOUSE AS RESPONSE DEVICE\n')
    
    case 'VOICEKEY'
        %RESULTS SHOULD BE BEST IF PROGRAM WAITS FOR A VERTICAL SYNCH BEFORE
        %STARTING THE AUDIORECORDER
        fprintf(1, 'USING VOICE-KEY AS RESPONSE DEVICE\n')
        fprintf(1, '\tINITIALIZING AUDIO CARD FOR VOICE KEY OPERATION...')
        %APPLY DEFAULT SETTINGS UNLESS REQUESTED OTHERWISE
        if ~isfield(Cfg, 'audio'), Cfg.audio = []; else end
        if ~isfield(Cfg.audio, 'f'), Cfg.audio.f = 44100; else end
        if ~isfield(Cfg.audio, 'nBits'),Cfg.audio.nBits = 16; else end
        if ~isfield(Cfg.audio, 'nChannels'), Cfg.audio.nChannels = 1; else end

        Cfg.audio.recorder = audiorecorder(Cfg.audio.f, Cfg.audio.nBits, Cfg.audio.nChannels);
        %set(recorder, 'StartFcn',  'global s; crsRTSStartStream(s, CRS.SS_IMMEDIATE);');
        %we might consider automatically sending a trigger
        fprintf(1, 'DONE\n')
    
    case 'LUMINAPARALLEL'
        fprintf(1, 'START INITIALIZING LUMINA ON PARALLEL PORT...\n')
        %CHECK WHETHER THIS ALREADY EXISTS
        %Cfg.hardware.parallel.mydio_in
        Cfg = ASF_initParallelPortInput(Cfg);
        fprintf(1, 'DONE INITIALIZING LUMINA\n')

    
     case 'LUMINASERIAL'
        if ~isfield(Cfg, 'hardware'), Cfg.hardware = []; else end
        if ~isfield(Cfg.hardware, 'serial'), Cfg.hardware.serial = []; else end
        if ~isfield(Cfg.hardware.serial, 'BaudRate'), Cfg.hardware.serial.BaudRate = 115200;else end 
        
        fprintf(1, 'CREATING SERIAL OBJECT ... ');
        Cfg.hardware.serial.oSerial = serial('COM1', 'Tag', 'SerialResponseBox', 'BaudRate', Cfg.hardware.serial.BaudRate);
        set(Cfg.hardware.serial.oSerial, 'Timeout', 0.001) %RECONSIDER
        Cfg.hardware.serial.oSerial.Terminator = '';
        set(Cfg.hardware.serial.oSerial,'InputBufferSize',128)
        %Cfg.hardware.serial.oSerial.ReadAsyncMode = 'manual';%'continuous';
        %Cfg.hardware.serial.ClassSerial = class(Cfg.hardware.serial, 'SerialResponseBox');
        %dummy = warning( 'off', 'instrument:fscanf:unsuccessfulRead')
        warning off all %THIS IS NASTY!!! We do this because of timeout warning
        fprintf(1, 'DONE\n')
        fprintf(1, 'STARTING SERIAL COMMUNICATION WITH SERIAL RESPONSE BOX (BAUD RATE: %d) ... ', Cfg.hardware.serial.BaudRate);
        fopen(Cfg.hardware.serial.oSerial);
        fprintf('DONE\n')
        %Cfg.hardware.serial.oSerial.BytesAvailable
    case  'KEYBOARD'
        fprintf(1, 'USING KEYBOARD AS RESPONSE DEVICE\n')

end
