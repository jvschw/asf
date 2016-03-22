function ASF_playSound( Cfg, when, varargin )
%function ASF_playSound( Cfg, delay_ms )
%WRAPPER FUNCTION FOR DIFFERENT METHODS TO PLAY SOUNDS
%
%20110107 jens.schwarzbach@unitn.it
if nargin > 2
    playBackDevice = varargin{1};
else
    playBackDevice = 1;
end

switch Cfg.Sound.soundMethod
    case 'psychportaudio'
        %ASSUMES THAT
        %PsychPortAudio('FillBuffer', Cfg.Sound.pahandle, Cfg.SoundStim.y);
        %HAS ALREADY HAPPENED
        %startTime = PsychPortAudio('Start', pahandle [, repetitions=1] [, when=0] [, waitForStart=0] [, stopTime=inf]);
        %PsychPortAudio('Start', Cfg.Sound.pahandle, 1, when, 0);
        PsychPortAudio('Start', Cfg.Sound.playbackHandle(playBackDevice), 1, when, 0);
        status = PsychPortAudio('GetStatus', Cfg.Sound.playbackHandle(playBackDevice));
        
    case 'audioplayer'
        %IGNORES when ARGUMENT
        %ASSUMES THAT
        %Cfg.Sound.playbackHandle = audioplayer(Cfg.SoundStim.y, Cfg.SoundStim.frequSampling);
        %HAS ALREADY HAPPENED
        play(Cfg.Sound.playbackHandle(playBackDevice)); %change to playbackHandle?

    case 'wavplay'
        %IGNORES when ARGUMENT
        wavplay(Cfg.SoundStim.y, Cfg.SoundStim.frequSampling, 'async');

end

