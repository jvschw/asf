# What is asf? #
ASF stands for A Simple Framework for presenting visual and auditory stimuli in behavioral experiments. It is based on the Psychophysics Toolbox for Matlab www.psychtoolbox.org, which needs to be installed for ASF to run. The idea is to write a program that reduces the experimenter’s task of programming behavioral experiments to generating tables of stimulus- and trial descriptions while accurate timing of stimuli, collecting responses from different devices such as voice-keys, button boxes or a computer mouse, generating triggers for EEG/MEG equipment and synchronization with MR-scanners and response-logging is dealt with in the background.

## asf is a realtime slideshow player ##
Let's start with looking at asf as if it were a slideshow player with  precise timing. An experimental trial consists of showing a set of slides, each with its own specified duration, and a time-window within which you check for responses by the participant.

![https://asf.googlecode.com/hg/documentation/wiki/simple.gif](https://asf.googlecode.com/hg/documentation/wiki/simple.gif)

You can control the slideshow by means of three things:
  1. a stimulus definition file (.std), which holds the names of the slides that you want to show
```
./images/bottle.gif 
./images/pitcher.gif 
./images/brush.gif 
./images/comb.gif 
./images/fixation.gif
```

> 2. a trial definition file, with one line per trial. Each line contains the order in which you want to present the slides in this given trial, and their respective durations. Furthermore you specify at which slide you start response collection and at which slide you want to stop it.
```
4 PictureNumber 
1 0 5 30 1 90 2 2 3 
2 0 5 30 2 90 2 2 3 
3 0 5 30 3 90 2 2 3 
4 0 5 30 4 90 2 2 3 
```

> 3. a variable Cfg, which allows you to configure many aspects of your slideshow (e.g. screen resolution, type of response device and much more)

You can run fully-fledged serious experiments like this, without any programming. All you have to do is write the .std file (easy, just a list of names, [explained here](StdFile.md)) and the trd file [explained here](TrdFile.md)(use a text editor or a spreadsheet program).

Once, you advance a little bit you may find it more convenient (and powerful) to write a program, which creates the trd file for you. This becomes important if you want to randomize trials (in particular with restrictions such as 'do not repeat the same conditin within the next n trials'). For this, you may want to use Matlab, and you find some examples in the [tutorial section](Tutorials.md).

asf is dumb on purpose: The power lies in the design, which is under your control. The tutorials are meant to help you with writing trd files that contain the design you want. Precise timing and interfacing with other devices (MRI, eye tracker, MEG, TMS) are left to asf, you do not have to bother.


## asf is a realtime slideshow player with drawing capabilities of its own ##
However, the slideshow aproach is limited. Sometimes an experiment would require too many slides to be prepared. This is not only tedious, but it can also lead to technical problems because fast graphics memory is limited, and having to load too many images can jeopardize all efforts of good timing because the computer has to move images between the graphics memory and standard memory.
An example would be a visual search experiment. There are simply too many locations at which a target can appear, and you also want to vary the appearance of all distractors.
For situations like this, asf allows you to plug-in your own code, which takes care of rendering the stimuli under program-control. The idea is that you still have a simple slideshow going, but that your program adds items to each slide.
Although this requires programming from the user, you are not left alone. asf comes with a template function, which is easy to enhance for your purposes. The [tutorial section](Tutorials.md) also contains examples for this.


## asf scales with expertise ##
Finally, you can program some intelligence into your plugin-code. For example you want to program a gaze contingent window or you want to extinguish a stimulus if a participant makes a saccade. All of this is possible without having to start from scratch, and we hopefully will be able to put some example code about this on the webpage. Users are invited to contribute code, too.

After this intro, maybe you want to look at this presentation [asfIntro](https://asf.googlecode.com/hg/documentation/wiki/Lecture%200%20ASF%20short%20intro.ppt) for an overview.