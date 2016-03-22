# Eyetracking with asf #
With a few changes to the Cfg structure the [simple masked priming experiment](Tutorials.md) can be changed into an eyetracking experiment. If your system is hooked up to an EyeLink system


the necessary changes are:
```
Cfg.Eyetracking.useEyelink = 1;
Cfg.Eyetracking.doCalibration = 1;
Cfg.Eyetracking.edfName = 'someName.edf'
```

## Running the eyetracking experiment ##
You can find the altered masked priming experiment in the folder _asf\documentation\ASFdemos\brm\maskedPrimingCentralPresentation_

The caller function is runExampleCentralEL.m

```
function ExpInfo = runExampleCentralEL

%SETTINGS FOR EYETRACKING
Cfg.Eyetracking.useEyelink = 1; 
Cfg.Eyetracking.doCalibration = 1;

projectName = 'exampleCentralEL';
stdName = 'example.std';
logName = projectName;
Cfg.Eyetracking.edfName = [projectName, '.edf'];

%MAKE TRD FILE
trdName = makeExampleCentralTrd(projectName);

%RUN EXPERIMENT
ExpInfo = ASF(stdName, trdName, logName, Cfg);

ASF_timingDiagnosis(ExpInfo); %CONTROL TIMING 
```

After you start the experiment there will be a blank screen.

Press C for calibration.

Press V for validation.

Finally, press ESC to start.

The participant's task is to make a horizontal eyemovement to the left or right, depending on the orientation of the mask-arrow, and to return the gaze after a brief fixation to the center. The experiment consists of 80 trials and lasts less than 5 minutes. At the end of the experiment, asf stores the log file under the name 'exampleCentralEL.mat', and retrieves the eyetracking data ('exampleCentralEL.edf') from the eyetracker. This file needs to be converted to ASCII format ('exampleCentralEL.asc') using the program edf2asc provided by SR Research.

## Analyzing the eyetracking experiment ##
### Parsing ###

The program [ASF\_eyeParseAscii](https://asf.googlecode.com/hg/code/utilities/EyeTracking/ASF_eyeParseAscii.m) segments eyetracking data from an EyeLink? system recorded during an asf-experiment into trials.

```
[tokenResults, trialInfo] = ASF_eyeParseAscii('exampleCentralEL.asc', {'MSG', 'EFIX', 'ESACC', 'EBLINK'})

tokenResults = 

1x4 struct array with fields:
    token
    nFound
    lines


trialInfo = 

1x80 struct array with fields:
    sacEvents
    blinkEvents
    fixEvents
    trialStart
    pagVec
    pageOnset
    trialEnd
    samples
    pupilArea


```

### Inspecting ###
You can now look at the content of each trial
```
>> trialNo = 3; trialInfo(trialNo)

ans = 

      sacEvents: [1x4 struct]
    blinkEvents: []
      fixEvents: [1x4 struct]
     trialStart: 6691938
         pagVec: [2 3 2 6 2]
      pageOnset: [6691953 6692166 6692180 6692206 6692286]
       trialEnd: 6693483
        samples: [1546x3 double]
      pupilArea: [1546x1 double]
```

and also plot the gaze traces easily

```
%VISUAL INSPECTION
trialNo = 3;
 
%WE RETRIEVE TIMING INFO FROM THE SAMPLES' TIMESTAMPS
t0 = trialInfo(trialNo).samples(1, 1);
t = trialInfo(trialNo).samples(:, 1) - t0;
 
%ASSIGN THE SAMPLES TO A VARIABLE xy
xy = trialInfo(trialNo).samples(:, 2:3);
 
%PLOT TRIAL
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from trial-onset [ms]')
ylabel('Gaze Position [pixels]')

```
![https://asf.googlecode.com/hg/documentation/wiki/EyetrackingTutorial_Trial.gif](https://asf.googlecode.com/hg/documentation/wiki/EyetrackingTutorial_Trial.gif)

### Retrieving oculomotor events and determining saccadic reaction times ###
Below, find some code that shows how to put samples, trial-info, and oculomotor events together for visualization and for computing saccadic reaction times.

```
%VISUAL INSPECTION
trialNo = 3;
 
thisTrial = trialInfo(trialNo);
 
%WE RETRIEVE TIMING INFO FROM THE SAMPLES' TIMESTAMPS
t0 = thisTrial.samples(1, 1);
t = thisTrial.samples(:, 1) - t0;
 
%ASSIGN THE SAMPLES TO A VARIABLE xy
xy = thisTrial.samples(:, 2:3);
 
%PLOT TRIAL (FIGURE 1, and FIGURE 2 PANEL A)
figure
subplot(2, 2, 1)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from trial-onset [ms]')
ylabel('Gaze Position [pixels]')
 
 
%MARKING EXPERIMENTAL EVENTS, AND WE MAKE THE ONSET OF THE MASK t0
pagePrime = 2;
pageMask = 4;
 
t0 = thisTrial.pageOnset(pageMask);
tMask = thisTrial.pageOnset(pageMask) - t0; %SHOULD BE 0
tPrime = thisTrial.pageOnset(pagePrime) - t0;
t = thisTrial.samples(:, 1) - t0;
 
 
%PLOT TRIAL
subplot(2, 2, 2)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from mask-onset [ms]')
ylabel('Gaze Position [pixels]')
yLim = get(gca, 'ylim');
 
hold on
%MARK PRIME AND MASK
plot([tPrime, tPrime], yLim, ':r')
plot([tMask, tMask], yLim, ':g')
hold off
 
 
%IDENTIFY SACCADIC ONSETS
%PLOT TRIAL
subplot(2, 2, 3)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from mask-onset [ms]')
ylabel('Gaze Position [pixels]')
yLim = get(gca, 'ylim');
 
hold on
nSaccades = length(thisTrial.sacEvents);
sacStart = zeros(1, nSaccades);
hold on
for i = 1:nSaccades
    sacStart(i) = thisTrial.sacEvents(i).sacStart - t0;
    plot([sacStart(i), sacStart(i)], yLim, 'color', [.5, .5, .5]);
end
hold off
 
%SACCADIC REACTION TIME IS THE TIME BETWEEN ONSET OF THE MASK AND ONSET OF
%THE FIRST SUBSEQUENT SACCADE
idxFirstValidSaccade = find(sacStart > 0, 1 );
 
srt = sacStart(idxFirstValidSaccade);
 
subplot(2, 2, 4)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from mask-onset [ms]')
ylabel('Gaze Position [pixels]')
yLim = get(gca, 'ylim');
 
arrow([srt, yLim(2)], [srt, yLim(1)]) %arrow.m is available on Matlab Central
```
![https://asf.googlecode.com/hg/documentation/wiki/EyetrackingTutorial_TrialInspection.gif](https://asf.googlecode.com/hg/documentation/wiki/EyetrackingTutorial_TrialInspection.gif)

### Merging the log-file with eyetracking data ###
If we consider the eyetracker as a response device to use eye movements instead of manual responses, it is desirable to extract saccadic reaction times (SRTs) from the eyetracking data and put them as response times in the appropriate field (ExpInfo.TrialInfo.Response.key and ExpInfo.TrialInfo.Response.RT) of the data stored in the [logfile](LogFile.md).

20110227 THIS SECTION IS UNDER CONSTRUCTION