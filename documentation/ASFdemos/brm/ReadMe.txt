Here you find two experiments that demonstrate the basic behavior of ASF

maskedPrimingCentralPresentation:
Simple masked priming experiment. Each trial consists of a small prime arrow followed by a bigger mask arrow. Both, prime and mask can either point to the left or to the right leading to congruence or incongruence between prime and mask. You will see that the visibility of the prime arrow is strongly reduced by the mask arrow (which actually works by means of metacontrast masking). The participant's task is to press the left mouse button with the left index finger if the mask is pointing to the left, and to press the right mouse button with the right index finger if the mask is pointing to the right. Congruence will affect reaction times, and the effect will increase with SOA between prime and mask (see Vorberg, Heinecke, Mattler, Schmidt, & Schwarzbach, 2003, PNAS).
Inside the directory maskedPrimingCentralPresentation type runExampleCentral to run stimulus presentation, the experiment, and a simple data analysis.

 
maskedPrimingUpperLowerPresentation:
The experiment above is extended in several ways.
1. Primes and masks are now presented above or below fixation. The trial-generation program has been adapted from above. Furthermore this experiment introduces userSupplied plugins (ASF_showTrialMaskedPrimingUpperLower.m). With some small changes based on the template ASF_showTrialSample.m (which you can find in the directory .\asf\code\ASF_showTrial_plugins) you can add flexibility that goes beyond showing prefabricated slideshows.
2. An extension of the timing analysis allows you to discard trials in which your criteria of timing precision have not been met  

smallArrows: This directory contains the stimulus material used by both experiments