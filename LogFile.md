# Log File #
Running asf returns a structure ExpInfo. Alternatively, loading the logfile puts ExpInfo in the current workspace


```
ExpInfo = 

     stimNames: {6x1 cell}
    factorinfo: [1x1 struct]
           Cfg: [1x1 struct]
     TrialInfo: [1x8 struct]
```

ExpInfo has the following fields:
-	stimNames: a cell-array that contains the filenames of the images shown or in other words the content of the stimulus-file
-	factorInfo: the factorial structure as defined in the first line of the trial-file
-	Cfg: the configuration of the experiment. Contains all the default settings unless overwritten by the user. It contains information about the hardware, software, as well as the settings that the program used for displaying stimuli.
-	TrialInfo: A structure array that contains trial by trial information.

TrialInfo (structure array with nTrials entries)
  * _TrialInfo.trial_: the description for a given trial as read in from the trial-file
  * _TrialInfo.datestr_: date and time when the trial has been shown
  * _TrialInfo.tStart_: temporal offset of start of trial with respect to start of experiment
  * _TrialInfo.Response_: which key has been pressed and respective reaction time of the trial
    * _key_: code for the response key that participant preseed in this trial
    * _RT_: reaction time (i.e. time expired between onset of startRTonPage and actual pressing of the response key)
  * _TrialInfo.timing_: array with dimensions `[nPages, 6]` (see also ASF\_timingDiagnosis())
    * COL 1: requested page duration [frames](frames.md)
    * COL 2: VBLTimestamp (high-precision estimate of the system time [s](s.md) when the actual flip has happened)
    * COL 3: StimulusOnsetTime (estimate of Stimulus-onset time)
    * COL 4: FlipTimestamp (timestamp taken at the end of Flip's execution)
    * COL 5: Missed (indicates if the requested presentation deadline for stimulus has been missed. Negative value means that deadlines have been satisfied. Positive values indicate a deadline-miss)
    * COL 6: Beampos (position of the monitor scanning beam when the time measurement was taken)
  * _TrialInfo.startRTMeasurement_: not yet documented
  * _TrialInfo.endRTMeasurement_: not yet documented

# Examples #
## Retrieving trial onset times from ExpInfo (e.g. for fMRI) ##
For model-based analysis of fMRI data the experimenter needs to know when certain events happened. asf provides a couple of helpfer functions for this task. A very simple one retrieves trial onset times from the log.

```
>> ASF_getTrialOnsetTimes( ExpInfo )

ans =

    0.0026
    2.3098
    4.6171
    7.0246
    9.3486
   11.2713
   13.5450
   15.6517
```
## Retrieving data from ExpInfo for analysis of behavioral data ##
The function ASF\_readExpInfo creates a matrix of dimensions `[nTrials, 5]`, which contains the following information:
  * ROW -> trial
  * COL 1: CODE
  * COL 2: RT
  * COL 3: KEY PRESSED
  * COL 4: CORRECTRESPONSE
  * COL 5: EXPERIMENTAL UNDOCUMENTED


```
>> ASF_readExpInfo (ExpInfo)

ans =

    1.0000  470.1663    3.0000    3.0000         0
    3.0000  320.1263    1.0000    1.0000         0
    4.0000  348.9002    3.0000    3.0000         0
    4.0000  316.1977    1.0000    1.0000         0
    3.0000  284.3466    3.0000    3.0000         0
    2.0000  288.8931    1.0000    1.0000         0
    1.0000  315.2159    1.0000    1.0000         0
    2.0000  260.0271    3.0000    3.0000         0
```


## Retrieving detailed timing information for error checking and exclusion of trials with timing errors by means of ASF\_timingDiagnosis() ##




```
-------------------------------------------------------
TIMING DIAGNOSIS
-------------------------------------------------------
ASF_timingDiagnosis( ExpInfo) shows for each trial and page 
 * COL 1: Current trial number
 * COL 2: Current page number
 * COL 3: which picture is isplayed on the page
 * COL 4: requested page duration in number of frames
 * COL 5: corresponding requested duration in ms
 * COL 6: actually realized duration in ms
 * COL 7: difference in ms between performed and requested duration
 * COL 8: timing evaluation for this page (OK i COL 7 <= 8ms)

 NOTE: THIS DEVIATION IS NOT COMPUTED FOR THE LAST PAGE IN A GIVEN TRIAL SINCE
 ITS DURATION DEPENDS ON THE ONSET TIME OF THE FIRST PAGE IN THE NEXT TRIAL.
 ALWAYS LET EACH TRIAL END WITH A DUMMY PAGE (BLANK SCREEN WITH A DURATION
 OF 1 FRAME) IF YOU ARE INTERESTED IN THE TIMING OF ALL PAGES IN A TRIAL.
 

-------------------------------------------------------
Monitor Flip Interval (measured by PTB):	  16.719 ms
Empirical Refresh Rate:						  59.811 Hz
-------------------------------------------------------
Legend:
[f]		frames
[ms]	milliseconds
eval	OK if |req - perf| < 8 ms
trial	 page	 stim	req[f]	 req[ms]	perf[ms]	diff[ms]	    eval
    1	    1	    2	    39	 652.050	 651.883	  -0.167	      OK
    1	    2	    4	     1	  16.719	  16.731	   0.012	      OK
    1	    3	    2	     2	  33.438	  33.437	  -0.001	      OK
    1	    4	    6	     6	 100.315	 100.310	  -0.005	      OK
    2	    1	    2	    39	 652.050	 651.839	  -0.211	      OK
    2	    2	    4	     1	  16.719	  16.743	   0.024	      OK
    2	    3	    2	     2	  33.438	  33.413	  -0.026	      OK
    2	    4	    5	     6	 100.315	 100.304	  -0.011	      OK
    3	    1	    2	    42	 702.208	 702.065	  -0.143	      OK
    3	    2	    3	     1	  16.719	  16.731	   0.011	      OK
    3	    3	    2	     5	  83.596	  83.579	  -0.018	      OK
    3	    4	    6	     6	 100.315	 100.322	   0.006	      OK
    4	    1	    2	    37	 618.612	 618.384	  -0.228	      OK
    4	    2	    4	     1	  16.719	  16.736	   0.017	      OK
    4	    3	    2	     5	  83.596	  83.570	  -0.026	      OK
    4	    4	    5	     6	 100.315	 100.310	  -0.006	      OK
    5	    1	    2	    16	 267.508	 267.273	  -0.235	      OK
    5	    2	    3	     1	  16.719	  16.748	   0.029	      OK
    5	    3	    2	     2	  33.438	  33.400	  -0.038	      OK
    5	    4	    6	     6	 100.315	 100.317	   0.002	      OK
    6	    1	    2	    34	 568.454	 568.261	  -0.193	      OK
    6	    2	    3	     1	  16.719	  16.757	   0.038	      OK
    6	    3	    2	     5	  83.596	  83.558	  -0.038	      OK
    6	    4	    5	     6	 100.315	 100.312	  -0.003	      OK
    7	    1	    2	    27	 451.419	 451.226	  -0.193	      OK
    7	    2	    3	     1	  16.719	  16.748	   0.029	      OK
    7	    3	    2	     2	  33.438	  33.401	  -0.037	      OK
    7	    4	    5	     6	 100.315	 100.299	  -0.017	      OK
    8	    1	    2	    26	 434.700	 434.451	  -0.249	      OK
    8	    2	    4	     1	  16.719	  16.761	   0.041	      OK
    8	    3	    2	     5	  83.596	  83.578	  -0.018	      OK
    8	    4	    6	     6	 100.315	 100.306	  -0.010	      OK
```

The function also produces a graphical representation of the data:
![https://asf.googlecode.com/hg/documentation/wiki/SimpleTimingDiagnosis.jpg](https://asf.googlecode.com/hg/documentation/wiki/SimpleTimingDiagnosis.jpg)

