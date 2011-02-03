function results = ASF_soundTestPsychPortAudio
%function results = ASF_soundTestPsychPortAudio
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


% Running on PTB-3? Abort otherwise.
AssertOpenGL;

s = serial('COM4', 'BaudRate', 9600);
fopen(s)

s


%CREATE A SOUNDVECTOR OF 100ms DURATION AND 1000Hz FREQUENCY
f = 1000;
frequSampling = 44100;
nbits = 16;
nrchannels = 2;
durSeconds = 0.025;
t = 0:1/frequSampling:(durSeconds-1/frequSampling);
y = repmat(sin(2*pi*f*t)', [1, nrchannels])';

%MAKE SURE NECESSARY METHODS RESIDE IN MEMORY
GetSecs;


%NUMBER OF TIMES THE TEST WILL BE PERFORMED
nTrials = 5;


% Perform basic initialization of the sound driver:
InitializePsychSound(1)
PsychPortAudio('Verbosity', 5);
% Open the default audio device [], with default mode [] (==Only playback),
% and a required latencyclass of one 1 == low-latency mode, as well as
% a frequency of frequSampling and nrchannels sound channels.
% This returns a handle to the audio device:
requestedLatencyClass = 0
pahandle = PsychPortAudio('Open', [], [], requestedLatencyClass, frequSampling, nrchannels);

%NOT SURE YET WHAT THIS DOES
oldbias = PsychPortAudio('LatencyBias', pahandle);

% Fill the audio playback buffer with the audio data 'wavedata':
PsychPortAudio('FillBuffer', pahandle, y);


requDelaySecs = [0:.125:1];
requDelaySecs = [0.5, 0.6, 0.7, 0.8];

nTrials = 5;
requDelaySecs = [0.2];

%requDelaySecs = [0.75:.05:0.80];
%requDelaySecs = (median(resultsppa.delta)/1000:.1:(median(resultsppa.delta)/1000+.4))

nDelays = length(requDelaySecs);
t0 = zeros(nDelays, nTrials);
tOnset = zeros(nDelays, nTrials);
t1 = zeros(nDelays, nTrials);

for j = 1:nDelays
    fprintf(1, 'DELAY %5.3f\n', requDelaySecs(j));
    for i = 1:nTrials
        fprintf(1, 'TRIAL %d/%d\n', i, nTrials);
        t0(j, i) = GetSecs;
        arduinoTrigger(s)
        
        % Start audio playback for 'repetitions' repetitions of the sound data,
        % start it immediately (0) and wait for the playback to start, return onset
        % timestamp.
        tOnset(j, i) = PsychPortAudio('Start', pahandle, 1, t0(j, i)+requDelaySecs(j), 1);
        t1(j, i) = GetSecs;
        WaitSecs(2);
    end
end
results.t0 = t0;
results.tOnset = tOnset;
results.t1 = t1;

%CLOSE CONNECTION TO ARDUINO
fclose(s)
clear s
fclose(instrfind)


for j = 1:nDelays
    delaymat(j, :)=(tOnset(j, :) - t0(j, :) - requDelaySecs(j))*1000;
end
results.delaymat = delaymat;

%subplot(3,1,3)
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
return

%     % Query current playback status and print it to the Matlab window:
%     s = PsychPortAudio('GetStatus', pahandle);
%
%     % Print it:
%     fprintf('\n\nAudio playback started, press any key for about 1 second to quit.\n');
%     fprintf('This is some status output of PsychPortAudio:\n');
%     disp(s);
%
%     realSampleRate = (s.ElapsedOutSamples - lastSample) / (s.CurrentStreamTime - lastTime);
%     % lastSample = s.ElapsedOutSamples; lastTime = s.CurrentStreamTime;
%     fprintf('Measured average samplerate Hz: %f\n', realSampleRate);
