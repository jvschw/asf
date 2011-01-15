function ASF_playSound( Cfg, when )
%function ASF_playSound( Cfg, delay_ms )
%WRAPPER FUNCTION FOR DIFFERENT METHODS TO PLAY SOUNDS
%
%20110107 jens.schwarzbach@unitn.it 
switch Cfg.Sound.soundMethod
    case 'psychportaudio'
        %ASSUMES THAT
        %PsychPortAudio('FillBuffer', Cfg.Sound.pahandle, Cfg.SoundStim.y);
        %HAS ALREADY HAPPENED
        %startTime = PsychPortAudio('Start', pahandle [, repetitions=1] [, when=0] [, waitForStart=0] [, stopTime=inf]);
        %PsychPortAudio('Start', Cfg.Sound.pahandle, 1, when, 0);
        PsychPortAudio('Start', Cfg.Sound.pahandle);
        status = PsychPortAudio('GetStatus', Cfg.Sound.pahandle);
        when = when; %FOR DEBUGGING

        
    case 'audioplayer'
        %IGNORES when ARGUMENT
        %ASSUMES THAT
        %Cfg.Sound.pahandle = audioplayer(Cfg.SoundStim.y, Cfg.SoundStim.frequSampling);
        %HAS ALREADY HAPPENED
        play(Cfg.Sound.pahandle);

    case 'wavplay'
        %IGNORES when ARGUMENT
        wavplay(Cfg.SoundStim.y, Cfg.SoundStim.frequSampling, 'async');

end

