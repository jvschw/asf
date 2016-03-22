# Stimulus Definition File #

The stimulus-file is a text file with the default extension .std (stimulus-definition) that contains the names of all image files that will be displayed during the experiment. Each line contains one filename, either a filename alone, a relative or a full path.

## Example ##
Suppose your experiment needs five different images: a bottle, a pitcher, a brush, a comb, and a fixation cross.

If the images reside in the current working directory of Matlab it is sufficient just to put the filenames into the stimulus-file, for example the file test.std could have the following content:

`bottle.gif`

`pitcher.gif`

`brush.gif`

`comb.gif`

`fixation.gif`



You can also write absolute path names into the stimulus-file:

`c:\experiments\experiment1\images\bottle.gif`

`c:\experiments\experiment1\images\pitcher.gif`

`c:\experiments\experiment1\images\brush.gif`

`c:\experiments\experiment1\images\comb.gif`

`c:\experiments\experiment1\images\fixation.gif`




The recommended option is to use relative path-descriptions. If the images reside in a subdirectory of the current working directory with the name 'images', then you can put a relative path-description to each file into the stimulus-file, for example:

`.\images\bottle.gif`

`.\images\pitcher.gif`

`.\images\brush.gif`

`.\images\comb.gif`

`.\images\fixation.gif`


or if you are working under OSX


`./images/bottle.gif`

`./images/pitcher.gif`

`./images/brush.gif`

`./images/comb.gif`

`./images/fixation.gif`


continue with setting up a trial definition or [trd-file](TrdFile.md)