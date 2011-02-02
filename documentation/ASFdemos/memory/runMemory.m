function ExpInfo = runMemory(subjectID, experimentType)
%function ExpInfo = runMemory(subjectID, experimentType)
%%TUTORIAL ON DEVELOPPING MEMORY EXPERIMENTS
%%Example call:
%%CENTERED PLAYBACK OF 4 IMAGES (handmade trd-file)
%ExpInfo = runMemory('test', 2)
%
%%CENTERED PLAYBACK OF 96 IMAGES (trd-file scripting)
%ExpInfo = runMemory('test', 2)
%
%%CENTERED PLAYBACK OF 96 IMAGES WITH RANDOMIZATION (trd-file scripting)
%ExpInfo = runMemory('test', 3)
%
%%OLD/NEW MEMORY TEST. (trd-file scripting and use of plugin)
%CENTERED PLAYBACK OF 120 IMAGES WITH RANDOMIZATION.
%25% OF THE PICTURES ARE REPEATED.
%PARTICIPANT RESPONDS:
        %"NEW"->LEFT MOUSE BUTTON
        %"OLD"->RIGHT MOUSE BUTTON
%ExpInfo = runMemory('oldnew', 4)


switch experimentType
    case 1
        %CENTERED PLAYBACK OF 4 IMAGES (HANDMADE)
        Cfg = [];
        ExpInfo = ASF('pictures.std', 'oldNew1.trd', subjectID, Cfg);
        ASF_timingDiagnosis(ExpInfo);
        
    case 2
        %CENTERED PLAYBACK OF 96 IMAGES.
        %trial structure: [empty 30 frames] [picture 90 frames] [empty 1 frame]
        makeTRDoldNew2
        Cfg = [];
        ExpInfo = ASF('pictures.std', 'oldNew2.trd', subjectID, Cfg);
        ASF_timingDiagnosis(ExpInfo);
        
    case 3
        %CENTERED PLAYBACK OF 96 IMAGES WITH RANDOMIZATION
        %trial structure: [empty 30 frames] [picture 90 frames] [empty 1 frame]
        makeTRDoldNew3('oldNew3randomized.trd')
        Cfg = [];
        ExpInfo = ASF('pictures.std', 'oldNew3randomized.trd', subjectID, Cfg);
        ASF_timingDiagnosis(ExpInfo);
   
    case 4
        %CENTERED PLAYBACK OF 96 IMAGES.
        %trial structure: [empty 30 frames] [picture 90 frames] [empty 1 frame]
        %25% OF PICTURES ARE REPEATED
        %PARTICIPANT RESPONDS:
        %"NEW"->LEFT MOUSE BUTTON
        %"OLD"->RIGHT MOUSE BUTTON
        Cfg = [];

        makeTRDoldNew4('oldNew4randomizedRepeated.trd')
        
        ExpInfo = ASF('pictures.std', 'oldNew4randomizedRepeated.trd', subjectID, Cfg);
        
        %SIGNAL DETECTION ANALYSIS
        analyzeOldNew(logName, recodeKeys);
       
    case 5
        %THIS INTRODUCES THE USE OF PLUGINS. THE PLUGIN ASFShowTrialPos.m,
        %WHICH IS LOCATED IN THE SUBFOLDER asf\code\ASF_showTrialPlugins
        %IT HAS BEEN DERIVED FROM ASF_showTrialSample.m
        %ADDED FUNCTIONALITY: EACH PAGE CAN BE DISPLAYED AT A DIFFERENT
        %LOCATION
        Cfg.userSuppliedTrialFunction = @ASF_ShowTrialPos;
        Cfg.userDefinedSTMcolumns = 4;
        ExpInfo = ASF('pictures.std', 'wm.trd', subjectID, Cfg);
        
        %FUTURE EXTENSIONS
        %DERIVE NEW PLUGIN FROM ASFShowTrialPos.m FOR EXPERIMENT THAT TESTS 
        %WORKING MEMORY FOR SPACE AND IDENTITY e.g.Courtney, Petit, Maisog,
        %Ungerleider, & Haxby, 1998, Science
end

