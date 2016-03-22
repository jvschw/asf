# Tutorials #
## Getting Started Tutorials ##
After having installed asf, you may want to try out these tutorials.

If you have ideas for tutorials that would make things easier for beginners, please send an email with your suggestion to
a.b@location

with
a: jens
b: schwarzbach
c: unitn.it

### 1. Masked Priming ###
_installationDirectory_\asf\documentation\ASFdemos\brm

Here you find two experiments that demonstrate the basic behavior of ASF

#### 1.1 maskedPrimingCentralPresentation ####
_installationDirectory_\asf\documentation\ASFdemos\brm\maskedPrimingCentralPresentation


Simple masked priming experiment. Each trial consists of a small prime arrow followed by a bigger mask arrow. Both, prime and mask can either point to the left or to the right leading to congruence or incongruence between prime and mask. You will see that the visibility of the prime arrow is strongly reduced by the mask arrow (which actually works by means of metacontrast masking). The participant's task is to press the left mouse button with the left index finger if the mask is pointing to the left, and to press the right mouse button with the right index finger if the mask is pointing to the right. Congruence will affect reaction times, and the effect will increase with SOA between prime and mask (see Vorberg, Heinecke, Mattler, Schmidt, & Schwarzbach, 2003, PNAS).
Inside the directory maskedPrimingCentralPresentation type runExampleCentral to run stimulus presentation, the experiment, and a simple data analysis.

look at [runExampleCentral.m](https://asf.googlecode.com/hg/documentation/ASFdemos/brm/maskedPrimingCentralPresentation/runExampleCentral.m) to get started

#### 1.2 maskedPrimingUpperLowerPresentation ####
> _installationDirectory_\asf\documentation\ASFdemos\brm\maskedPrimingUpperLowerPresentation

The experiment above is extended in several ways.
  1. Primes and masks are now presented above or below fixation. The trial-generation program has been adapted from above. Furthermore this experiment introduces userSupplied plugins (ASF\_showTrialMaskedPrimingUpperLower.m). With some small changes based on the template ASF\_showTrialSample.m (which you can find in the directory .\asf\code\ASF\_showTrial\_plugins) you can add flexibility that goes beyond showing prefabricated slideshows.
  1. An extension of the timing analysis allows you to discard trials in which your criteria of timing precision have not been met

Look at [runExampleUpperLower.m](https://asf.googlecode.com/hg/documentation/ASFdemos/brm/maskedPrimingUpperLowerPresentation/runExampleUpperLower.m)
to work through this tutorial.


smallArrows: This directory contains the stimulus material used by both experiments

### 2. From presenting pictures to assessing memory performance ###

_installationDirectory_\asf\documentation\ASFdemos\memory


Open [runMemory.m](https://asf.googlecode.com/hg/documentation/ASFdemos/memory/runMemory.m) in the editor, and try to walk through this.

  1. First you will learn about the structure of a trd-file and just watch some images on the screen.
  1. The "experiment" is the same, but you will see how to script a trd-file
  1. Added ranomization to trd-file scripting
  1. A true old-new memory experiment with fully scripted trd-file generation and signal detection analysis

## Advanced Tutorials ##

### 3. Presenting Videos ###
Learn in the [video tutorial](VideoTutorial.md) how asf can render videos with high temporal accuracy and precision.
Part 1 deals with presenting a series of videoclips.
Part 2 turns this into an fMRI experiment forlocalizing the action observation network.

There will be a presentation with a guided tour, soon.