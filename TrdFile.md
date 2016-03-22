# Introduction #

The trial-file is a textfile with the extension .trd (trial-definition) that consists of two sections:
  * The first line contains the factorial information for your experiment. If you want to code your experiment e.g. as a 2 by 3 by 4 design this line would read '2 3 4'.
  * The remainder of the file contains one entry per trial. It starts with a trial-code (see below for encoding and decoding), trial onset time with respect to experiment-start (by default not used, but can be switched on with Cfg.useTrialOnsetTimes = 1), followed by pairs of entries that describe a picture-event or **page** (picture number, picture duration in frames). The next two entries contain the page-number at which reaction time measurement in a given trial should start and when it should end. The last entry contains a number for the correct response.

`Factor_1_NumLevels … Factor_n_NumLevels`

`Code tOnset PicNum_1 PicDur_1 … … PicNum_n PicDur_n StartRTonPage EndRTonPage CorrectResponse`

…

`Code tOnset PicNum_1 PicDur_1 … … PicNum_n PicDur_n StartRTonPage EndRTonPage CorrectResponse`


## Example ##
Suppose your std file contains the names of five bitmaps.

`bottle.gif`

`pitcher.gif`

`brush.gif`

`comb.gif`

`fixation.gif`




The following trd file defines the trials

`4 PictureNumber`

`1   0     5  30     1  90        2  2    3`

`2   0     5  30     2  90        2  2    3`

`3   0     5  30     3  90        2 2    3`

`4   0     5  30     4  90        2 2    3`






Line 1 declares that there is an experiment with one factor which has _four_ levels, and which is called _PictureNumber_.

Lines 2-5 descibe one trial, respectively.
The first trial is described in line 2.
  * The desciption starts with the trial-code 1, which in more complex experiments helps with the data analysis.
  * The second entry is the trial onset time with respect to the start of the experiment. If you set it to 0, trials will be played back to back.
  * Entries three and four refer to the first picture to be shown in this trial, namely the picture-number (here picture 5, which is fixation.gif) and its duration in frames (here 30, which amounts to 500ms if your monitor is operated at 60 Hz; 1000/60\*30 = 500).
  * Entries five and six refer to the second picture to be shown in this trial, namely the picture-number (here picture 1, which is bottle.gif) and its duration in frames (here 90, which at 60 Hz amounts to 1500ms).
  * The last three entries (here six to eight) describe settings about response collection. Entry six defines at which page to start response collection. Here the entry 2 means that response collection starts on the presentation of the second page, i.e. the onset of presenting the bottle. Entry seven of value 2 means that response collection ends when the second page, the bottle, expires. The last entry of value three defines what counts as a correct response for data analysis or feedback. These numbers depend on your task and the resonse device. If you are using a 3-button mouse, then a 1 stands for the left mouse button and a 3 for the right mouse button. In our simple example here, the number does not matter.

The other trials in lines 3-5 are coded in the same way.


If you save your std-file under the name simple.std and the trd-file under the name simple.trd, all you have to do is call ASF:

`ExpInfo = ASF('simple.std', 'simple.trd', 'simpledata', [])`


You will see the following (actually only once and not in a loop like here):
Four trials will be presented back to back, each starting with a 500ms presentation of a central fixation cross, followed by a 1.5s presentation of an object.

![https://asf.googlecode.com/hg/documentation/wiki/simple.gif](https://asf.googlecode.com/hg/documentation/wiki/simple.gif)


## Notes ##
### Backward Compatibility of TRD files ###
Older asf versions did not have the EndRTonPage parameter. They were always assuming that response collection started and ended on the page indicated by StartRTonPage. Using such old trd files generates an error at startup of asf unless you provide the following configuration setting for backward compatibility.
`Cfg.hasEndRTonPageInfo = 0;`