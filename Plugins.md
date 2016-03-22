#A brief overview on writing an using plugins.

# Introduction #
Plugins are a way to give users flexibility to create their own powerful experiments by either enhancing the standard slideshow player (e.g. by adding code that triggers a device whenever a new page is presented) or by even leaving the slideshow paradigm entirely (e.g. creating an online-rendered animation based on an algorithm rather than playing back prefabricated slides).
This section will expand in the future. Here is just a brief outline.


# Details #
ASF's slideshow player is implemented in an internal function  called ASF\_showTrial. It is a good idea to start with a copy of that function that you save under a new name in your experiment's directory. Then you add functionality to that new piece of program.
If you want ASF to use your showTrial function, you have to inform ASF of this by means of the Cfg variable when you call ASF.

## Getting Started with plugins: Step by Step Instruction ##
  * Copy C:\Applications\asf\code\ASF\_showTrial\_plugins\ASF\_showTrialSample.m to the directory containing the code for your experiment and save it under a different name such as myExp\_showTrial.m
  * add the desired functionality to myExp\_showTrial.m
  * tell ASF about it: Cfg.userSuppliedTrialFunction = @myExp\_showTrial;

## Passing additional parameters to plugins ##
If you want to use extra parameters in your plugin myExp\_showTrial.m you just have to add columns to your trd file. Make ASF aware of this by means of Cfg:
For example if you want to submit two additional parameter values to your showtrial function add this Cfg setting before calling ASF
Cfg.userDefinedSTMcolumns = 2;

(don’t forget to actually add two columns of values in your trd-file)

### How to access these additional parameters within your plugin? ###
They are in an array called atrial.userDefined. This means, the nth  user defined parameter parameter is in atrial.userDefined(n)


Examples will be provided. But, for now I hope this can get you started. If this does not work, send a note to the forum.