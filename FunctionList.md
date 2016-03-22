# List of asf functions #

**Core**
  * [ASF](https://asf.googlecode.com/hg/code/ASF.m)	the core program for running an experiment (reads stimulus- and trial definition; manages playback and logging; communicates with devices)
**For creating trd-files**
  * [ASF\_encode](https://asf.googlecode.com/hg/code/ASF_encode.m)	encode factorial information to single number code
**For plugins**
  * [ASF\_showTrialSample](https://asf.googlecode.com/hg/code/ASF_showTrial_plugins/ASF_showTrialSample.m)	copy and make your own experiment with online rendering, adaptive testing, etc.
  * [ASF\_xFlip](https://asf.googlecode.com/hg/code/ASF_xFlip.m)	flip display synchronized with vertical retrace (and much more). One of the most important functions of ASF
  * [ASF\_playSound](https://asf.googlecode.com/hg/code/ASF_playSound.m) 	wrapper function for different methods to play sound
  * [ASF\_sendMessageToEyelink](https://asf.googlecode.com/hg/code/ASF_sendMessageToEyelink.m)	for logging stimulus or other events in the stream of eyetracking data
  * [ASF\_checkforuserabort](https://asf.googlecode.com/hg/code/ASF_checkforuserabort.m)	checks whether somebody has pressed the q key to quit program
  * [ASF\_playSound](https://asf.googlecode.com/hg/code/ASF_playSound.m)	wrapper function for different methods to play sound
  * [ASF\_setTrigger](https://asf.googlecode.com/hg/code/ASF_setTrigger.m)	send signals to parallel port or an Arduino board (useful for TMS, EEG, MEG)
  * [ASF\_waitForMousePressBenign](https://asf.googlecode.com/hg/code/ASF_waitForMousePressBenign.m)	just waits for a mouse press
  * [ASF\_waitForResponse](https://asf.googlecode.com/hg/code/ASF_waitForResponse.m)	waits for a response. Can handle many different response devices (mouse, lumina parallel, lumina serial, voicekey, keyboard)
  * [ASF\_waitForScannerSynch](https://asf.googlecode.com/hg/code/ASF_waitForScannerSynch.m)	pauses until an MR-scanner trigger arrives
**For data analysis**
  * [ASF\_timingDiagnosis](https://asf.googlecode.com/hg/code/ASF_timingDiagnosis.m)	to check whether everything happened when it was supposed to
  * [ASF\_readExpInfo](https://asf.googlecode.com/hg/code/ASF_readExpInfo.m)	reads log-files created by an ASF experiment
  * [ASF\_getTrialOnsetTimes](https://asf.googlecode.com/hg/code/ASF_getTrialOnsetTimes.m)	returns a vector for trial onset times
  * [ASF\_decode](https://asf.googlecode.com/hg/code/ASF_decode.m)	decoding codes to factorial information
  * [ASF\_eyeParseAscii](https://asf.googlecode.com/hg/code/utilities/EyeTracking/ASF_eyeParseAscii.m)  segments eyetracking data from an EyeLink system recorded during an asf-experiment into trials
**Internal helper functions**
  * _ASF\_initEyelinkConnection_	establishes initialization of an EyeLink eyetracker
  * _ASF\_shutdownEyelink_	closes connection with EyeLink eyetracker
  * _ASF\_initParallelPortInput_	initializes the parallel port using the data acquisition toolbox
  * _ASF\_initResponseDevice_	initializes response device (mouse,  voicekey,  Lumina-parallel,  Lumina-serial, keyboard)
  * _ASF\_arduinoTrigger_  	function for triggering using an Arduino board
  * _ASF\_readTrialDefs_	reads trd-files into a structure
  * _ASF\_readStimulus_	reads bitmaps and avi files
  * _ASF\_makeTexture_	internal function for mapping bitmaps onto textures
  * _ASF\_PTBExit_	generate a graceful exit (save logs, shut down hardware, remove objects from memory)
**Experimental**
  * _ASF\_checkTrials_	Matlab visualization of trial-scheme
  * _ASF\_onlineFeedback_	on dual screen setups, this shows the current cumulative info on errors and reaction time (even for factorial experiments)
  * _ASF\_pulseTrainNI_	can create pulse trains on a national instruments card for rTMS