# Introduction #
The goal of this tutorial is to show how to achieve presentation of auditory and visual signals with precise timing i.e. with precise respective onset asynchronies and precise durations.



# 1. Background Considerations #
Imagine you want to present a flash on the screen simultaneously with a 1000 Hz auditory beep (see Figure 1).

![https://asf.googlecode.com/hg/documentation/wiki/tut_av_boxcar.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_boxcar.gif)

Figure 1. Timing diagram for synchronous audio-visual presentation.

  1. Presentation of visual stimuli occur timelocked to the vertical blank (VBL) of the monitor. The VBL is controlled by the graphics board. It occurs every 1/RefreshRate[Hz](Hz.md). With a refresh rate of 60 Hz the VBL occurs every 16.67 ms.
  1. Stimulus onset with respect to the VBL depends on two factors :
    * The rise-time of the display, and
    * the position of the stimulus on the display.
  1. Onset of the auditory stimulus can be precisely controlled using the method described in the document “ASF sound tutorial” using audio playback at a scheduled future system time.
  1. The requested delay for scheduled future playback depends on:
    * The latency of the audio driver (35 ms on the demaonstration system used here), and
    * the requested stimulus onset asynchrony (SOA) between auditory and visual stimulus (e.g. 0ms for simultaneous presentation).

# 2. Rise time of the display and stimulus-duration #
The system rise time is the time after the VBL (t0) it takes to reach 75% of maximum stimulus intensity (t<sub>1</sub>). We define the duration of the stimulus as the time when the video signal falls below 75% of the maximum intensity (t<sub>2</sub>) minus rise time (t<sub>1</sub>).

![https://asf.googlecode.com/hg/documentation/wiki/tut_av_risetime.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_risetime.gif)

Figure 2. Timing for a visual presentation of a white flash on a black background. The green line represents the voltage of the trigger signal, which has been issued time-locked to a vertical blank of the graphics board. The red line is a correlate of the display’s light intensity measured with a photo-diode in the upper left corner of the display. Note that the display does not respond immediately to the command to present a white flash (at t<sub>0</sub>). We define the rise time of the display  at that point in time at which the display shows 75% of its maximal intensity (t<sub>1</sub>). When display intensity falls below 75% of its maximum again, we define this as the time of stimulus offset (t<sub>2</sub>).

# 3. Audiovisual Synchronization #

For presenting an auditory stimulus synchronously to the visual stimulus, playback must start 14ms after the VBL that corresponds to presenting the visual stimulus. Sound-duration should be 4 ms (unfortunately I used 5ms here).

![https://asf.googlecode.com/hg/documentation/wiki/tut_av_av0big.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_av0big.gif)

The three figures below depict measurements from running ASF\_testSynchAudioVis using SOAaudio-visual of -10, 0, and 10ms (negative SOAs indicate that audio precedes video).
Figure 3. Timing for a visual presentation of a white flash on a black background. The green line represents the voltage of the trigger signal, which has been issued time-locked to a vertical blank of the graphics board. The red line is a correlate of the display’s light intensity measured with a photo-diode in the upper left corner of the display. Note that the display does not respond immediately to the command to present a white flash (at t<sub>0</sub>). We define the rise time of the display  at that point in time at which the display shows 75% of its maximal intensity (t<sub>1</sub>). When display intensity falls below 75% of its maximum again, we define this as the time of stimulus offset (t<sub>2</sub>).


![https://asf.googlecode.com/hg/documentation/wiki/tut_av_av-10.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_av-10.gif)

Figure 4. Timing for a visual presentation of a white flash on a black background preceded by an auditory signal with an SOA of -10ms.

![https://asf.googlecode.com/hg/documentation/wiki/tut_av_av0.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_av0.gif)

Figure 5. Timing for synchronous presentation of a white flash on a black background and an auditory signal (SOA = 0ms).

![https://asf.googlecode.com/hg/documentation/wiki/tut_av_av10.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_av10.gif)

Figure 6. Timing for a visual presentation of a white flash on a black background followed by an auditory signal with an SOA of 10ms.

# 4. Creating experiments using audiovisual stimulation #
In order to present auditory and visual stimuli with a defined stimulus onset asynchrony (SOA<sub>aud-vis</sub>) we have to start a sound presentation timelocked to an empty visual page, delay it by req.delay<sub>aud</sub> and present the visual target stimulus at SOA<sub>soundtrigger-vistrigger</sub> with respect to the first empty visual page.

![https://asf.googlecode.com/hg/documentation/wiki/tut_av_av_SOAnegative.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_av_SOAnegative.gif)

Figure 7. Trialscheme for negative SOAs (audio starts before visual).


![https://asf.googlecode.com/hg/documentation/wiki/tut_av_av_SOApositive.gif](https://asf.googlecode.com/hg/documentation/wiki/tut_av_av_SOApositive.gif)

Figure 8. Trialscheme for positive SOAs (audio starts after visual).

