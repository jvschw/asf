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
        if ~isfield(Cfg, 'Audio'), Cfg.Audio = []; else end
        if ~isfield(Cfg.Audio, 'f'), Cfg.Audio.f = 44100; else end
        if ~isfield(Cfg.Audio, 'nBits'),Cfg.Audio.nBits = 16; else end
        if ~isfield(Cfg.Audio, 'nChannels'), Cfg.Audio.nChannels = 1; else end

        Cfg.Audio.recorder = audiorecorder(Cfg.Audio.f, Cfg.Audio.nBits, Cfg.Audio.nChannels);
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
        if ~isfield(Cfg.Hardware, 'serial'), Cfg.Hardware.Serial = []; else end
        if ~isfield(Cfg.Hardware.Serial, 'baudRate'), Cfg.Hardware.Serial.baudRate = 115200;else end 
        
        fprintf(1, 'CREATING SERIAL OBJECT ... ');
        Cfg.Hardware.Serial.oSerial = serial('COM1', 'Tag', 'SerialResponseBox', 'baudRate', Cfg.Hardware.Serial.baudRate);
        set(Cfg.Hardware.Serial.oSerial, 'Timeout', 0.001) %RECONSIDER
        Cfg.Hardware.Serial.oSerial.Terminator = '';
        set(Cfg.Hardware.Serial.oSerial,'InputBufferSize',128)
        %Cfg.Hardware.Serial.oSerial.ReadAsyncMode = 'manual';%'continuous';
        %Cfg.Hardware.Serial.ClassSerial = class(Cfg.Hardware.Serial, 'SerialResponseBox');
        %dummy = warning( 'off', 'instrument:fscanf:unsuccessfulRead')
        warning off all %THIS IS NASTY!!! We do this because of timeout warning
        fprintf(1, 'DONE\n');
        fprintf(1, 'STARTING SERIAL COMMUNICATION WITH SERIAL RESPONSE BOX (BAUD RATE: %d) ... ', Cfg.Hardware.Serial.baudRate);
        fopen(Cfg.Hardware.Serial.oSerial);
        fprintf('DONE\n')
        %Cfg.Hardware.Serial.oSerial.BytesAvailable
    case  'KEYBOARD'
        fprintf(1, 'USING KEYBOARD AS RESPONSE DEVICE\n');

end
