# Introduction #
Synchronizing the presentation of sound with other events is less easy than one might imagine. Matlab offers several functions for the playback of sound (wavplay.m, audioplayer.m). Also PTB offers different methods, the depreciated method Snd() and the new method PsychPortAudio http://docs.psychtoolbox.org/PsychPortAudio for high precision timing of audio capture and playback. This library needs special drivers and special hardware. PTB’s command help PsychPortAudio provides help for finding and installing drivers. If PTB’s command InitializePsychSound yields the message
> _Detected an ASIO enhanced PortAudio driver. Good!
Found at least one ASIO enabled soundcard in your system. Good, will use that in low-latency mode!_

then you may find the following particularly helpful.

# ASF\_soundTest #
The function ASF\_soundTest.m performs a series of tests in order to assess delays the precision of timed sound presentation. The underlying logic is to:
  * Take a start time t0 (in ms).
  * Issue a command to present a sound of tDur (e.g. 100ms) duration after a certain delay tReqDelay (with tReqDelay = 0 indicating a request to play the sound immediately).
  * Wait until playing the sound is finished.
  * Take an end time t1 (in ms).
  * Calculate a time deltat = t1 - t0 - tDur - tReqDelay.
  * Time deltat represents the temporal difference between the actual onset and the requested onset of the sound.

## Testing the accuracy of Legacy methods ##
First, ASF\_soundTest tests the accuracy of sound functions provided by Matlab and PsychToolbox. Figure 1 shows the delay between actual sound output and requested sound output for three different methods (blue -> wavplay, green -> audioplayer, and red -> Snd), each of which has been tested 200 times (repetition). The results reveal two serious problems: One problem is that each method produces substantial delays between requested and realized times, the other problem is that **these numbers can vary when repeating the test, even using the same system**.

A) ![https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestLegacy_A.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestLegacy_A.gif)
B) ![https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestLegacy_B.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestLegacy_B.gif)


Figure 1. A) Delay between actual sound output and requested sound output for three different methods (blue -> wavplay, green -> audioplayer, and red -> Snd), each of which has been tested 200 times.  Tests have been perfomed on a DELL PRECISION M70 laptop with a builtin SigmaTel C-Major Audio system, sound chip running MATLAB Version 7.5.0.342 (R2007b) on Windows XP 32 bit SP3. B) Mean delay between actual sound output and requested sound output and respective standard deviation for three different methods (wavplay, audioplayer, and Snd). While wavplay and audioplayer methods have comparable delays of around 40ms, PTB’s Snd() method has the shortest average delay with 20ms. However, the audioplayer method appears to be much more reliable with a substantially smaller variability of delays of roughly 1 ms. Wavplay and snd show much more variability with 10 and 22ms, respectively. Note: Repeating the test most likely leads to (even qualitatively) different results.


| | **Wavplay** | **audioplayer** | **PTBsnd** | **PPA**|
|:|:------------|:----------------|:-----------|:-------|
| mean(delay) | 41.6        | 39.96           | 20.25      | 34.79  |
| std(delay) | 10.15       | 0.92            | 22.16      | 2.05   |
| N | 200         | 200             | 200        | 200    |

Table 1. Mean delay between actual sound output and requested sound output and respective standard deviation for three different methods of sound presentation (wavplay, audioplayer, and Snd), each of which has been tested 200 times.


### Intermediate Conclusion ###
The above-tested methods wavplay(), audioplayer, and Snd() yield unsatisfactory results because they show substantial delays and high variability. Even worse, replications of the same test lead to other delays and other vairiability. PTB offers a way out of this by using PsychPortAudio.


## Testing the accuracy of PsychPortAudio ##
### Immediate Playback ###

PsychPortAudio is PTB’s low-latency sounddriver. Among its features there is the capability to start playback at a future system time. ASF\_soundTest performs the above-described steps using the PsychPortAudio method requesting immediate playback, i.e. we measure the time that expires between requesting an immediate sound output and the actual start of the sound. The results are depicted in Figure 3. Here, the average delay between the requested and the actual playback-times was around 35ms with a jitter of 2ms. At first sight this result may look disappointing since there is still a substantial delay at least on the tested system. This may look different on your system. One positive result is already that this delay and its variability are highly reproducible when rerunning the test on the same system. However, using PsychPortAudio’s scheduling feature, i.e. define a start of playback at a scheduled future system time, can enable you to run experiments with submillisecond jitter in synchronization of audio with other events.

![https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestPPA_immediate.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestPPA_immediate.gif)

Figure 2. Delay between actual sound output and requested sound output for PsychPortAudio driver when requesting immediate playback. On the test-system there is an average delay of 35ms with a standard deviation of 2ms.

### Scheduled Playback ###
The third series of tests uses the scheduling-feature of the PsychPortAudio driver. The test checks for three different delays: immediate playback (requested delay = 0ms), playback at average driver-latency (for the tested setup: requested delay = 35ms), playback at average driver-latency plus 50ms (for the tested setup: requested delay = 85ms). The results are depicted in Figure 3. Once a long-enough delay is chosen we can achieve a highly precise and stable timing of a sound.

![https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestPPA_variousDelays.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestPPA_variousDelays.gif)

Figure 3. Delay between actual sound output and requested sound output for PsychPortAudio driver when requesting delayed playback. Left: Requested delay is too short for the driver. Middle: Requested delay is around the driver’s response time. Right: Requested delay is 50 ms longer than the driver’s average response time (right). Delay between requested and realized sound output converges to very small numbers (in sub-millisecond range) once the requested delay is longer than the driver’s response time.

### External Validation ###
All these measurements rely on timestamps provided by the driver or the stimulation computer. In the following the timing is tested independently by issuing a trigger on a digital port (using an ARDUINO 2009 board; see http://arduino.cc/en/) immediately followed by a command that starts a delayed sound presentation. Trigger and sound signal are fed into separate channels of an external oscilloscope (e.g. a DSO1014A by Agilent Technologies). Under optimal conditions measured delay between the onset of the trigger and the onset of the sound should converge to the requested delay.

![https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestPPA_scheduledFuture50.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTestPPA_scheduledFuture50.gif)

Figure 4. Delay between trigger (green) and sound playback (blue) scheduled 50ms in the future. Black vertical lines depict the requested onset of the trigger and requested onset of the sound. Observed delay was 49ms and extremely stable (deviations < .1 ms over hundreds of trials). The fact that sound presentation started reliably one ms too early can be attributed either to internal delays on the trigger board or to the timestamping of PsychPortAudio.

Test measurements yielded highly stable results with a temporal difference of 49ms between trigger and start of sound-playback, when a delay of 50 ms was requested. The jitter in these measurements was below 0.1ms. Thus, scheduled playback of sound using PsychPortAudio can yield “near-perfect” highly reliable timing.

# Conclusions #
Thus, the strategy for programming an experiment in which sounds are to be shown with a precise timing with respect to another event, e.g. a picture, we have to start a scheduled sound presentation way before. Suppose you want to present a picture and a sound simultaneously, you need to start a delayed sound presentation and a delayed picture presentation where the delay depends on the latency of the sound system on your computer. We will capitalize on this in the Audio-Visual tutorial where we implement a delayed sound playback and an immediate visual presentation to achieve defined stimulus onset asynchronies between auditory and visual stimuli (see Figure 5 below).

![https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTest_suggestedScheme.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_a_soundTest_suggestedScheme.gif)

Figure 5. Scheme for presenting sound and visual stimuli at defined stimulus onset asynchronies.

# Code for testing #
[ASF\_soundTest.m](https://asf.googlecode.com/hg/documentation/wiki/ASF_soundTest.m)

[ASF\_soundTestPsychPortAudio.m](https://asf.googlecode.com/hg/documentation/wiki/ASF_soundTestPsychPortAudio.m)


arduino trigger code