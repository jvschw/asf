# Introduction #
ASF’s slideshow model also allows you presenting videos. To this aim, ASF reads in videoclips and copies them frame by frame into textures which reside on the videocard’s RAM. This ensures maximal execution speed. Your experiment treats each texture as a single image. A video is defined as a series of images in a defined order with each frame having a certain duration. This tutorial shows how to create animated presentations with material borrowed from Lingnau, Gesierich, and Caramazza (2009). We will use this material to show eight different hand movements for three times in random order with interleaved fixation periods.

![https://asf.googlecode.com/hg/documentation/wiki/Lingnau%20Gesieriech%20Caramazza%20Material.jpg](https://asf.googlecode.com/hg/documentation/wiki/Lingnau%20Gesieriech%20Caramazza%20Material.jpg)

_Figure 1. Material presented during motor act observation. Each row shows one of the 8 different motor acts. Columns correspond to the movie frames shown at 250, 500, 1,000, 1,250, and 1,500 ms._

Materials. For observation trials, video clips of 8 different simple right-hand motor acts were taken. All video clips were edited to contain 50 frames, color information was removed, and resolution was reduced to 432\_346 pixels. In each of the 8 videos the hand performed a different, but in all cases meaningless gesture (see Figure 1). You can download the videos and matlab scripts [here](http://code.google.com/p/asf/downloads/detail?name=VideoTutorial.zip&can=2&q=).

## Experiment 1: Presenting different movie clips ##
Here we create an experiment with a single factor action-type, which has 8 levels.
The eight action-videos are called A1.avi – A8.avi. The fixation cross is stored as a bitmap called fix.bmp. The entire stimulus material resides in a directory \stimuli (one directory level below the code).
We will present each video three times. Videos are presented in random order followed by a two-second fixation period. Responses are collected (left and right mouse button), but note that this is done for demonstration purposes since there is no task associated with watching these clips.

### STD file ###
```
.\stimuli\fixation.bmp
.\stimuli\A1.avi
.\stimuli\A2.avi
.\stimuli\A3.avi
.\stimuli\A4.avi
.\stimuli\A5.avi
.\stimuli\A6.avi
.\stimuli\A7.avi
.\stimuli\A8.avi
```

### TRD file ###
The trd-file contains one line per trial, with a list of stimulus-numbers and their respective durations. Instead of providing the listing of the trd-file, find below a Matlab program, which creates such a trd file and thus the entire experiment.

```
function VideoTutorialSimple_make_trd
%function VideoTutorialSimple_make_trd
%CREATES TRD FILE FOR A SIMPLE EXPERIMENT THAT SHOWS MOVIES
%jens.schwarzbach@unitn.it 201012

Cfg.outputName = 'ASF_movieDemo.trd';
%--------------------------------------------------------------------------
%STIMULI
%--------------------------------------------------------------------------
%WE WILL USE ONE BITMAP
Cfg.onsetFramesBitmaps = [1];
Cfg.nBitmaps = length(Cfg.onsetFramesBitmaps);

%WE WILL USE 16 VIDEOS THAT CONTAIN 50 FRAMES EACH
Cfg.nVideos = 8;
Cfg.nFramesPerVideo = 50;
Cfg.onsetFramesVideos = (0:(Cfg.nVideos-1))*Cfg.nFramesPerVideo +...
    1 + Cfg.nBitmaps;
Cfg.fixationPage = 1;
Cfg.fixationDuration =  1; %2 seconds

%--------------------------------------------------------------------------
%DESIGN
%--------------------------------------------------------------------------
Cfg.defaultFrameDuration = 2;   %EACH VIDEOFRAME WILL BE PRESENTED FOR 3
                                %REFRESH CYCLES, THAT IS FOR 50MS ASSUMING
                                %60 Hz; THIS LEADS TO AN OVERALL DURATION
                                %OF 2.5s PER CLIP

Cfg.nRepetitionsPerCondition = 3;   %EACH CONDITION IS SHOWN 3 TIMES

Cfg.nTrials =  Cfg.nVideos * Cfg.nRepetitionsPerCondition;

%CREATE A COLUMN VECTOR THAT CONTAINS THE MOVIENUMBERS IN RANDOM ORDER
%ALTERNATING WITH ZEROS (WHICH INDICATE FIXATION PERIODS)
trialVec = [];
for iRep = 1:Cfg.nRepetitionsPerCondition
    randIdx = randPerm(Cfg.nVideos);
    zeroVec = zeros(size(randIdx));
    thisTrialVec = vertcat(randIdx, zeroVec);
    trialVec = [trialVec; thisTrialVec(:)];
end
trialVec = [0; trialVec; 0]; %START WITH FIXATION BLOCK (END WITH [0, 0])

nextOnsetTime = 0;
for i = 1:length(trialVec)
    switch(trialVec(i)>0)
        case 0 %FIXATION
            trial(i) = createFixationTrial(Cfg.fixationPage);
            trial(i).code = 0;    
            trial(i).tOnset = nextOnsetTime;
            nextOnsetTime = nextOnsetTime + Cfg.fixationDuration;
        case 1 %MOVIE CLIP
            thisClip = createClip(trialVec(i), Cfg);
            trial(i).code = trialVec(i);
            trial(i).tOnset = nextOnsetTime;
            trial(i).pageNo = thisClip.pageNo;
            trial(i).dur = thisClip.dur;
            trial(i).startRTpage = Cfg.nFramesPerVideo + 1;
            trial(i).endRTpage = trial(i).startRTpage;
            %NO RESPONSE WILL BE COLLECTED DURING THIS TRIAL
            %trial(i).startRTpage = length(trial(i).pageNo)+1; 
            trial(i).correctResponse = -1; %USE AN INVALID RESPONSE CODE
            nextOnsetTime = nextOnsetTime +...
                Cfg.nFramesPerVideo*Cfg.defaultFrameDuration/60;
    end
end

%WRITE TRIAL-DEFINITION FILE
writeTRD(trial, Cfg.outputName)

function clip = createClip(stimulusNumber, Cfg)
idxStart = Cfg.onsetFramesVideos(stimulusNumber);
idxEnd = idxStart +  Cfg.nFramesPerVideo - 1;
clip.pageNo = idxStart:idxEnd;
clip.dur = ones(1, Cfg.nFramesPerVideo)*Cfg.defaultFrameDuration;

function trial = createFixationTrial(fixationPage)
trial.code = 0;    %USE INVALID TRIAL CODE
trial.tOnset = -1;  %USE INVALID ONSET TIME, TO BE POPULATED LATER
trial.pageNo = [fixationPage, fixationPage];
trial.dur = [1, 1];          %ONE FRAME DURATION
trial.startRTpage = 3;  %THIS TRIAL ONLY HASE ONE PAGE, SETTING THE START
%PAGE FOR RESPONSE COLLECTION TO 2 MEANS THAT
%NO RESPONSE WILL BE COLLECTED DURING THIS TRIAL
trial.endRTpage = trial.startRTpage; 
trial.correctResponse = -1; %USE AN INVALID RESPONSE CODE

function writeTRD(trial, outputName)
%fid = 1;
fid = fopen(outputName, 'wt');
fprintf(fid, '%5d\n', length(trial));
for iTrial = 1:length(trial)
    %FORMAT OF A SINGLE TRIAL IN A TRD FILE
    %CODE TONSET    p1 d1 p2 d2 ... pn dn  startRTonPage correctResponse
    fprintf(fid, '%4d\t', trial(iTrial).code);
    fprintf(fid, '%8.2f\t', trial(iTrial).tOnset);
    %TWO ENTRIES PER PAGE TO DISPLAY: pageNumber, pageDuration
    for iPage = 1:length(trial(iTrial).pageNo)
        fprintf(fid, '%4d %4d      ',...
            trial(iTrial).pageNo(iPage), trial(iTrial).dur(iPage));
    end
    fprintf(fid, '%4d\t', trial(iTrial).startRTpage);
    fprintf(fid, '%4d\t', trial(iTrial).endRTpage);
    fprintf(fid, '%4d', trial(iTrial).correctResponse);
    fprintf(fid, '\n');
end
if (fid > 1)
    fclose(fid);
end
```

### Running the experiment ###
Running the program
To run the program, either type
Cfg.useTrialOnsetTimes = 1;
ExpInfo =...
> ASF('VideoTutorialSimple.std', 'ASF\_movieDemo.trd', 'ASF\_movieDemo', Cfg)

or invoke the script
VideoTutorialSimple\_run





## Experiment 2: Localizer fMRI experiment (Block design: Rest - Stim- Rest - Control ##
Using the same material, we only have to change the TRD file in order to implement a so called localizer experiment, which can be used to identifiy the Action Observation System. To this aim, one can present alternating blocks of 16s duration (Rest - Stim- Rest - Co ntrol ). A program that creates a corresponding trd file is presented below.

```
function VideoTutorialLocalizer_make_trd

%--------------------------------------------------------------------------
%STIMULI
%--------------------------------------------------------------------------
%WE WILL USE ONE BITMAP
Cfg.onsetFramesBitmaps = [1];
Cfg.nBitmaps = length(Cfg.onsetFramesBitmaps);

%WE WILL USE 16 VIDEOS THAT CONTAIN 50 FRAMES EACH
Cfg.nVideos = 16;
Cfg.nFramesPerVideo = 50;
Cfg.onsetFramesVideos = (0:(Cfg.nVideos-1))*Cfg.nFramesPerVideo +...
    1 + Cfg.nBitmaps;
Cfg.fixationPage = 1;
Cfg.fixationDuration =  5; %5 seconds


%--------------------------------------------------------------------------
%DESIGN
%--------------------------------------------------------------------------
Cfg.defaultFrameDuration = 3;   %EACH VIDEOFRAME WILL BE PRESENTED FOR 3
                                %REFRESH CYCLES, THAT IS FOR 50MS ASSUMING
                                %60 Hz; THIS LEADS TO AN OVERALL DURATION
                                %OF 2.5s PER CLIP
Cfg.nMoviesPerBlock = 8;    %8MOVIES MAKE ONE BLOCK LEADING TO BLOCK-
                            %DURATION OF 20s

Cfg.nRepetitionsPerCondition = 3;   %EACH CONDITION IS SHOWN 3 TIMES

%CREATE AN ABABAB DESIGN WITH INTERVENING NULL-PERIODS
blockOrder = [0, repmat([1, 0, 2, 0], [1, Cfg.nRepetitionsPerCondition])];


%MAKE BLOCKS
nextOnsetTime = 0;
for iBlock = 1:length(blockOrder)
    blockType = blockOrder(iBlock);
    [trial(iBlock), nextOnsetTime] =...
        createBlock(blockType, nextOnsetTime, Cfg);
end

%WRITE TRIAL-DEFINITION FILE
writeTRD(trial)
return

function [trial, nextOnsetTime] = createBlock(iMovieType, tOnset, Cfg)
nextOnsetTime = tOnset;
correctResponse = -1; %PASSIVE VIEWING


switch iMovieType
    case 0
        %FIXATION
        trial = createFixationTrial(Cfg.fixationPage);
        trial.tOnset = tOnset;
        nextOnsetTime = nextOnsetTime + Cfg.fixationDuration;
    case {1, 2}
        %MOVIE
        %RANDOMIZED ORDER FOR nMoviesPerBlock MOVIES
        idx = randperm(Cfg.nMoviesPerBlock);
        %CLIPS 1-8, or 9-16
        idx = idx + (iMovieType - 1)*Cfg.nMoviesPerBlock; 

        trial.code = iMovieType;
        trial.tOnset = tOnset;
        trial.pageNo = [];
        trial.dur = [];
        for iClip = 1:Cfg.nMoviesPerBlock
            thisClip = createClip(idx(iClip), Cfg);
            trial.pageNo = [trial.pageNo, thisClip.pageNo];
            trial.dur = [trial.dur, thisClip.dur];
        end
        trial.startRTpage = length(trial.pageNo)+1; %NO RESPONSE WILL BE COLLECTED DURING THIS TRIAL
        trial.endRTpage = trial.startRTpage;
        trial.correctResponse = -1; %USE AN INVALID RESPONSE CODE

        nextOnsetTime = nextOnsetTime +...
            Cfg.nMoviesPerBlock*Cfg.nFramesPerVideo*Cfg.defaultFrameDuration/60;
end


function clip = createClip(stimulusNumber, Cfg)
idxStart = Cfg.onsetFramesVideos(stimulusNumber);
idxEnd = idxStart +  Cfg.nFramesPerVideo - 1;
clip.pageNo = idxStart:idxEnd;
clip.dur = ones(1, Cfg.nFramesPerVideo)*Cfg.defaultFrameDuration;


function trial = createFixationTrial(fixationPage)
trial.code = 0;    %USE INVALID TRIAL CODE
trial.tOnset = -1;  %USE INVALID ONSET TIME, TO BE POPULATED LATER
trial.pageNo = [fixationPage, fixationPage];
trial.dur = [1, 1];          %ONE FRAME DURATION
trial.startRTpage = 3;  %THIS TRIAL ONLY HASE ONE PAGE, SETTING THE START
trial.endRTpage = 3;
%PAGE FOR RESPONSE COLLECTION TO 2 MEANS THAT
%NO RESPONSE WILL BE COLLECTED DURING THIS TRIAL
trial.correctResponse = -1; %USE AN INVALID RESPONSE CODE

function writeTRD(trial)
%fid = 1;
fid = fopen('ASF_movieDemo.trd', 'wt');
fprintf(fid, '%5d\n', length(trial));
for iTrial = 1:length(trial)
    %FORMAT OF A SINGLE TRIAL IN A TRD FILE
    %CODE TONSET    p1 d1 p2 d2 ... pn dn  startRTonPage correctResponse
    fprintf(fid, '%4d\t', trial(iTrial).code);
    fprintf(fid, '%8.2f\t', trial(iTrial).tOnset);
    %TWO ENTRIES PER PAGE TO DISPLAY: pageNumber, pageDuration
    for iPage = 1:length(trial(iTrial).pageNo)
        fprintf(fid, '%4d %4d      ',...
            trial(iTrial).pageNo(iPage), trial(iTrial).dur(iPage));
    end
    fprintf(fid, '%4d %4d\t',...
        trial(iTrial).startRTpage, trial(iTrial).endRTpage);
    fprintf(fid, '%4d', trial(iTrial).correctResponse);
    fprintf(fid, '\n');
end
if (fid > 1)
    fclose(fid);
end

```

### Running the program ###
```
Cfg.useTrialOnsetTimes = 1;
ExpInfo = ASF('VideoTutorialLocalizer.std', 'ASF_movieDemo.trd', 'ASF_movieDemo', Cfg)
```

actually, in order to run it in the MR, the program would be run with the following Cfg-settings

```
Cfg.useTrialOnsetTimes = 1;
Cfg.synchToScanner = 1;
Cfg.synchToScannerPort = 'SERIAL';
Cfg.responseDevice = 'LUMINASERIAL';
Cfg.timeOutWaitSerial = inf;

ExpInfo = ASF('VideoTutorialLocalizer.std', 'ASF_movieDemo.trd', 'ASF_movieDemo', Cfg)
```

# References #

Lingnau, A., Gesierich, B., & Caramazza, A. (2009). Asymmetric fMRI adaptation reveals no evidence for mirror neurons in humans. _Proc Natl Acad Sci U S A_, **106**(24), 9925-9930.