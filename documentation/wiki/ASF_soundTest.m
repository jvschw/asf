function results = ASF_soundTest
%function results = ASF_soundTest
%
%THIS TEST PRESENTS A SOUND SEVERAL TIMES AT DIFFERENT DELAYS
%AND PRODUCES A BAR GRAPH OF THE DIFFERENCE IN TIME BETWEEN REQUESTED ONSET
%AND ACTUAL ONSET. IF EVERYTHING WORKS PERFECTLY THIS SHOULD YIELD A
%DIFFERENCE BELOW 1MS.
%HOWEVER, YOU WILL SEE THAT THIS IS ONLY TRUE FROM CERTAIN DELAYS ON. FOR
%EXAMPLE ON MY DELL PRECISION M6400 RUNNING WINDOWS7, THE CRITICAL DELAY
%ABOVE WHICH REQUESTED AND ACTUAL DELAY ARE BASICALLY THE SAME IS 750MS.
%
% 20101222 jens.schwarzbach@unitn.it

%AGILENT: TIME WINDOW 50ms
%CHANNEL 1: SOUND [1V] (crank up computer vol to max)
%CHANNEL 2: TRIGGER FROM ARDUINO [1V]
%TRIGGERED ACQUISITION FROM CHANNEL 2, TRIGGER THRESH 200mV

%ARDUINO
%UPLOAD C:\Users\jens.schwarzbach\Documents\MATLAB\arduino\Trigger\Trigger.pde
%CONNECT GROUND AND DIG11 TO CHANNEL 2 OF OSCILLOSCOPE

cfg.useOsc = 0;

% Running on PTB-3? Abort otherwise.
AssertOpenGL;

if cfg.useOsc
    s = serial('COM4', 'BaudRate', 9600);
    fopen(s)
    
    s
end

%CREATE A SOUNDVECTOR OF 100ms DURATION AND 1000Hz FREQUENCY
f = 1000;
frequSampling = 44100;
nbits = 16;
nrchannels = 1;
durSeconds = 0.1;
t = 0:1/frequSampling:(durSeconds-1/frequSampling);
y = sin(2*pi*f*t);

%MAKE SURE NECESSARY METHODS RESIDE IN MEMORY
GetSecs;
wavplay(y, frequSampling);
player = audioplayer(y, frequSampling);
playblocking(player);
Snd('Play', y, frequSampling);


%NUMBER OF TIMES THE TEST WILL BE PERFORMED
nTrials = 5;

t0 = zeros(1, nTrials);
tOnset = zeros(1, nTrials);
t1 = zeros(1, nTrials);

%TEST OF wavplay
for i = 1:nTrials
    t0(i) = GetSecs;
    if cfg.useOsc
        arduinoTrigger(s)
    end
    wavplay(y, frequSampling);
    t1(i) = GetSecs;
    resultswav.delta(i) = (t1(i)-t0(i) - durSeconds)*1000;
end


%TEST OF audioplayer
%player = audioplayer(y, frequSampling);
for i = 1:nTrials
    t0(i) = GetSecs;
    if cfg.useOsc
        arduinoTrigger(s)
    end
    playblocking(player);
    t1(i) = GetSecs;
    resultsaudiplayer.delta(i) = (t1(i)-t0(i) - durSeconds)*1000;
end

%TEST OF PTB-SND
for i = 1:nTrials
    t0(i) = GetSecs;
    if cfg.useOsc
        arduinoTrigger(s)
    end
    Snd('Play', y, frequSampling);
    Snd('Wait')
    t1(i) = GetSecs;
    resultssnd.delta(i) = (t1(i)-t0(i) - durSeconds)*1000;
end

figure
%subplot(3,1,1)
bar([resultswav.delta; resultsaudiplayer.delta; resultssnd.delta]')
xlabel('Repetition')
ylabel('Delay with respect to immediate onset [ms]')
title('Legacy Methods')
drawnow
legend('wavplay', 'audioplayer', 'PTB snd')

% Perform basic initialization of the sound driver:
InitializePsychSound(1)
PsychPortAudio('Verbosity', 0)
% Open the default audio device [], with default mode [] (==Only playback),
% and a required latencyclass of one 1 == low-latency mode, as well as
% a frequency of frequSampling and nrchannels sound channels.
% This returns a handle to the audio device:
pahandle = PsychPortAudio('Open', [], [], 0, frequSampling, nrchannels);

%NOT SURE YET WHAT THIS DOES
oldbias = PsychPortAudio('LatencyBias', pahandle);

% Fill the audio playback buffer with the audio data 'wavedata':
PsychPortAudio('FillBuffer', pahandle, y);


repetitions = 1;
waitForStart = 1;
for i = 1:nTrials
    t0(i) = GetSecs;
    if cfg.useOsc
        arduinoTrigger(s)
    end
    tOnset(i) =...
        PsychPortAudio('Start', pahandle, repetitions,  t0(i), waitForStart);
    t1(i) = GetSecs;
    resultsppa.delta(i) = (tOnset(i)-t0(i))*1000;
    WaitSecs(durSeconds*2);
end

%subplot(3,1,2)
figure
bar(resultsppa.delta, 0.25)
xlabel('Repetition')
ylabel('Delay with respect to immediate onset [ms]')
title('PSYCHPORTAUDIO IMMEDIATE')
drawnow

%requDelaySecs = [0:.125:1];
% requDelaySecs = [0.75:.05:0.80];
% requDelaySecs = median(resultsppa.delta)/1000:.1:(median(resultsppa.delta)/1000+.4);
requDelaySecs =...
    (floor(median(resultsppa.delta)-50):50:(median(resultsppa.delta) + 50))/1000

nDelays = length(requDelaySecs);
t0 = zeros(nDelays, nTrials);
tOnset = zeros(nDelays, nTrials);
t1 = zeros(nDelays, nTrials);

for j = 1:nDelays
    for i = 1:nTrials
        t0(j, i) = GetSecs;
        if cfg.useOsc
            arduinoTrigger(s)
        end
        
        % Start audio playback for 'nTrials' repetitions of the sound data,
        % using different requested delays. Return timestamp of onset.
        tOnset(j, i) = ...
            PsychPortAudio('Start', pahandle, 1, t0(j, i)+requDelaySecs(j), 1);
        t1(j, i) = GetSecs;
        WaitSecs(2);
    end
end
results.t0 = t0;
results.tOnset = tOnset;
results.t1 = t1;

if cfg.useOsc
    %CLOSE CONNECTION TO ARDUINO
    fclose(s)
    clear s
    fclose(instrfind)
end

for j = 1:nDelays
    delaymat(j, :)=(tOnset(j, :) - t0(j, :) - requDelaySecs(j))*1000;
end
results.delaymat = delaymat;

%subplot(3,1,3)
figure
bar(delaymat)
ylabel('\delta(actual delay, requested delay) [ms]')
set(gca, 'xtick', 1:nDelays, 'xticklabel', requDelaySecs*1000)
xlabel('Requested Delay')
title('PSYCHPORTAUDIO VARIOUS DELAYS')

for i = 1:nTrials
    legstr{i} = sprintf('Rep %03d', i);
end
legend(char(legstr))

% Stop playback:
PsychPortAudio('Stop', pahandle);

% Close the audio device:
PsychPortAudio('Close', pahandle);