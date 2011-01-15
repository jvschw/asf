function TrialInfo = ASF_showTrialSample(atrial, windowPtr, Stimuli, Cfg)
%function TrialInfo = ASF_showTrialSample(atrial, windowPtr, Stimuli, Cfg)
%
%%SAVE A COPY OF THIS FILE UNDER A DIFFERENT NAME E.G. myPlugin.m
%%TO USE IT AS A STARTING POINT FOR YOUR PLUGIN-DEVELOPMENTS
%% written by: jens schwarzbach

%SAVE TIME BY ALLOCATING ALL VARIABLES UPFRONT

%FROM PTB3 DOCUMENTATION
% VBLTimestamp system time (in seconds) when the actual flip has happened
% StimulusOnsetTime An estimate of Stimulus-onset time
% FlipTimestamp is a timestamp taken at the end of Flip's execution
% Missed indicates if the requested presentation deadline for your stimulus
% has been missed. A negative value means that deadlines have been 
% satisfied. Positive values indicate a deadline-miss.
% Beampos is the position of the monitor scanning beam when the time 
% measurement was taken (useful for correctness tests)
VBLTimestamp = 0; StimulusOnsetTime = 0; FlipTimestamp = 0; Missed = 0; 
Beampos = 0;

StartRTMeasurement = 0; EndRTMeasurement = 0;
timing =...
    [0, VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos];
nPages = length(atrial.pageNumber);
timing(nPages, end) = 0;
this_response = [];

tolerance = Cfg.Screen.monitorFlipInterval*0.75; 
%WAS 1/400 BUT THIS SEEMED TO PRODUCE TOO MANY TIMING ERRORS ON PAGES WITH 
%RESPONSE COLLECTION. HOWEVER, THIS MUST NOT BE LONGER THAN ONE FRAME
%DURATION. EXPERIMENTING WITH ONE QUARTER OF A FRAME

responseGiven = 0;
this_response.key = [];
this_response.RT = [];

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%IF YOU WANT TO DO ANY OFFLINE STIMULUS RENDERING 
%(I.E. BEFORE THE TRIAL STARTS), PUT THAT CODE HERE
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%--------------------------------------------------------------------------
%TRIAL PRESENTATION HAS SEVERAL PHASES
% 1) WAIT FOR THE RIGHT TIME TO START TRIAL PRESENTATION. THIS MAY BE 
%    IMMEDIATELY OR USER DEFINED (E.G. IN fMRI EXPERIMENTS)
%
% 2) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION
%
% 3) LOOP THROUGH PAGE PRESENTATIONS WHILE CHECKING FOR USER 
%    INPUT/RESPONSES
%
% 4) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION 
%    (AFTER RESPONSE HAS BEEN GIVEN)
%
% 5) FEEDBACK
%--------------------------------------------------------------------------

%LOG DATE AND TIME OF TRIAL
strDate = datestr(now); %store when trial was presented

%--------------------------------------------------------------------------
% PHASE 1) WAIT FOR THE RIGHT TIME TO START TRIAL PRESENTATION. THIS MAY BE
% IMMEDIATELY OR USER DEFINED (E.G. IN fMRI EXPERIMENTS)
%--------------------------------------------------------------------------
%IF EXTERNAL TIMING REQUESTED (e.g. fMRI JITTERING)
if Cfg.useTrialOnsetTimes
    while((GetSecs- Cfg.experimentStart) < atrial.tOnset)
    end
end

%EYETRACKING: OPTIONAL DRIFT CORRECTION AT THE ONSET OF EACH TRIAL
if Cfg.Eyetracking.doDriftCorrection
    EyelinkDoDriftCorrect(Cfg.el);
end

%--------------------------------------------------------------------------
%END OF PHASE 1
%--------------------------------------------------------------------------


%LOG TIME OF TRIAL ONSET WITH RESPECT TO START OF THE EXPERIMENT
%USEFUL FOR DATA ANALYSIS IN fMRI
tStart = GetSecs - Cfg.experimentStart;
%EYETRACKING: MESSAGE TO EYELINK

Cfg = ASF_sendMessageToEyelink(Cfg, 'TRIALSTART');


%--------------------------------------------------------------------------
% PHASE 2) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION
%--------------------------------------------------------------------------
%CYCLE THROUGH PAGES FOR THIS TRIAL
for i = 1:atrial.startRTonPage-1

    %PUT THE APPROPRIATE TEXTURE ON THE BACK BUFFER
    Screen('DrawTexture', windowPtr, Stimuli.tex(atrial.pageNumber(i)));

    %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN
    %AT THE NEXT FLIP
    bPreserveBackBuffer = atrial.pageDuration(i) > 1;

    %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
    %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = ...
        ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)),...
        Cfg, bPreserveBackBuffer);
    
    %SET TRIGGER (PARALLEL PORT AND EYELINK)
    ASF_setTrigger(Cfg, atrial.pageNumber(i));
    
    %LOG WHEN THIS PAGE APPEARED
    timing(i, 1:6) = [atrial.pageDuration(i), VBLTimestamp,...
        StimulusOnsetTime, FlipTimestamp Missed Beampos];

    
    %WAIT OUT STIMULUS DURATION IN FRAMES. WE USE PAGE FLIPPING RATHER THAN
    %A TIMER WHENEVER POSSIBLE BECAUSE GRAPHICS BOARDS PROVIDE EXCELLENT
    %TIMING; THIS IS THE REASON WHY WE MAY WANT TO KEEP A STIMULUS IN THE
    %BACKBUFFER (NONDESTRUCTIVE PAGE FLIPPING)
    %NOT ALL GRAPHICS CARDS CAN DO THIS. FOR CARDS WITHOUT AUXILIARY
    %BACKBUFFERS WE COPY THE TEXTURE EXPLICITLY ON THE BACKBUFFER AFTER IT
    %HAS BEEN DESTROYED BY FLIPPING
    nFlips = atrial.pageDuration(i) - 1; %WE ALREADY FLIPPED ONCE
    for FlipNumber = 1:nFlips
        %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN AT THE
        %NEXT FLIP
        bPreserveBackBuffer = FlipNumber < nFlips;

        %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN
        %THE BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO
        %THE SCREEN
        ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg,...
            bPreserveBackBuffer);
    end
end
%--------------------------------------------------------------------------
%END OF PHASE 2
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% PHASE 3) LOOP THROUGH PAGE PRESENTATIONS WHILE CHECKING FOR USER 
% INPUT/RESPONSES
%--------------------------------------------------------------------------
%SPECIAL TREATMENT FOR THE DISPLAY PAGE ON WHICH WE ALLOW REACTIONS
%RT PAGE
for i = atrial.startRTonPage:atrial.startRTonPage
    %PUT THE APPROPRIATE TEXTURE ON THE BACK BUFFER
    Screen('DrawTexture', windowPtr, Stimuli.tex(atrial.pageNumber(i)));

    %DO NOT PUT THIS PAGE AGAIN ON THE BACKBUFFER, WE WILL WAIT IT OUT
    %USING THE TIMER NOT FLIPPING
    bPreserveBackBuffer = 0;

    %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
    %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] =...
        ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg,...
        bPreserveBackBuffer);

    %SET TRIGGER (PARALLEL PORT AND EYELINK)
    ASF_setTrigger(Cfg, atrial.pageNumber(i));

    StartRTMeasurement = VBLTimestamp;

    %STORE TIME OF PAGE FLIPPING FOR DIAGNOSTIC PURPOSES
    timing(i, 1:6) = [atrial.pageDuration(i), VBLTimestamp,...
        StimulusOnsetTime, FlipTimestamp, Missed, Beampos];

    pageDuration_in_sec =...
        atrial.pageDuration(i)*Cfg.Screen.monitorFlipInterval;
    [~, ~, buttons, ~, t1] =...
        ASF_waitForResponse(Cfg, pageDuration_in_sec - tolerance);
    if any(buttons)
        responseGiven = 1;
        %a button has been pressed before timeout
        if Cfg.responseTerminatesTrial
            Snd('Play','Quack')
        else
            %wait out the remainder of the stimulus duration 5ms margin
            WaitSecs(...
                pageDuration_in_sec-(t1-StartRTMeasurement)-tolerance...
                ); 
        end
        this_response.key = find(buttons); %find which button it was
        %compute response time
        this_response.RT = (t1 - StartRTMeasurement)*1000; 
    end
end
%--------------------------------------------------------------------------
%END OF PHASE 3
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% PHASE 4) LOOP THROUGH PAGE PRESENTATIONS WITHOUT RESPONSE COLLECTION 
% (AFTER RESPONSE HAS BEEN GIVEN)
%--------------------------------------------------------------------------
%OTHER PICS
for i = atrial.startRTonPage+1:nPages
    %PUT THE APPROPRIATE TEXTURE ON THE BACK BUFFER
    Screen('DrawTexture', windowPtr, Stimuli.tex(atrial.pageNumber(i)));

    %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN AT THE NEXT 
    %FLIP
    bPreserveBackBuffer = atrial.pageDuration(i) > 1;

    %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT IN THE
    %BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED AGAIN TO THE SCREEN
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = ...
        ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg,...
        bPreserveBackBuffer);
    
    %SET TRIGGER (PARALLEL PORT AND EYELINK)
    ASF_setTrigger(Cfg, atrial.pageNumber(i));

    %STORE TIME OF PAGE FLIPPING FOR DIAGNOSTIC PURPOSES
    timing(i, 1:6) = [atrial.pageDuration(i), VBLTimestamp, ...
        StimulusOnsetTime, FlipTimestamp, Missed, Beampos];
    
    if(responseGiven)
        %IF THE RESPONSE HAS ALREADY BEEN GIVEN


        %WAIT OUT STIMULUS DURATION IN FRAMES
        nFlips = atrial.pageDuration(i) - 1; %WE ALREADY FLIPPED ONCE
        for FlipNumber = 1:nFlips
            %PRESERVE BACK BUFFER IF THIS TEXTURE IS TO BE SHOW AGAIN AT
            %THE NEXT FLIP
            bPreserveBackBuffer = FlipNumber < nFlips;

            %FLIP THE CONTENT OF THIS PAGE TO THE DISPLAY AND PRESERVE IT
            %IN THE BACKBUFFER IN CASE THE SAME IMAGE IS TO BE FLIPPED 
            %AGAIN TO THE SCREEN
            ASF_xFlip(windowPtr, Stimuli.tex(atrial.pageNumber(i)), Cfg,...
                bPreserveBackBuffer);
        end
    else
        %THE RESPONSE HAS NOT YET BEEN GIVEN
        pageDuration_in_sec = ...
            atrial.pageDuration(i)*Cfg.Screen.monitorFlipInterval;
        [~, ~, buttons, t0, t1] = ...
            ASF_waitForResponse(Cfg, pageDuration_in_sec - tolerance);
        
        if any(buttons)
            responseGiven = 1;
            %a button has been pressed before timeout
            if Cfg.responseTerminatesTrial
                Snd('Play','Quack')
            else
                %THIS IS DIFFERENT WITH RESPECT TO THE RT PAGE FOR THE
                %PAGES FOLLOWING THE RTPAGE
                %wait out the remainder of the stimulus duration 5ms margin
                WaitSecs(pageDuration_in_sec - (t1-t0) -tolerance); 
            end
            this_response.key = find(buttons); %find which button it was
            %compute response time
            this_response.RT = (t1 - StartRTMeasurement)*1000;
        end

    end
end
%--------------------------------------------------------------------------
%END OF PHASE 4
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% PHASE 5) FEEDBACK
%--------------------------------------------------------------------------
%IF YOU WANT TO FORCE A RESPONSE
if Cfg.waitUntilResponseAfterTrial && ~responseGiven
    %[x, y, buttons, t0, t1] = WaitForMousePress(10);
    [~, ~, buttons, ~, t1] = ASF_waitForResponse(Cfg, 10);

    if any(buttons)
        responseGiven = 1; %#ok<NASGU>
        %a button has been pressed before timeout
        this_response.key = find(buttons); %find which button it was
        %compute response time
        this_response.RT = (t1 - StartRTMeasurement)*1000;
    end
end

%TRIAL BY TRIAL FEEDBACK
if Cfg.feedbackTrialCorrect || Cfg.feedbackTrialError
    %EVALUATE RESPONSE
    if this_response.key == atrial.CorrectResponse
        %CORRECT RESPONSE
        if Cfg.feedbackTrialCorrect
            Snd('Play', Cfg.sndOK)
            Snd('Wait');
        end
    else
        %WRONG RESPONSE
        if Cfg.feedbackTrialError
            Snd('Play', Cfg.sndERR)
            Snd('Wait');
        end
    end
end
%--------------------------------------------------------------------------
%END OF PHASE 5
%--------------------------------------------------------------------------



%PACK INFORMATION ABOUT THIS TRIAL INTO STRUCTURE TrialInfo 
%(THE RETURN ARGUMENT)
%PLEASE MAKE SURE THAT TrialInfo CONTAINS THE FIELDS:
%   trial
%   datestr
%   tStart
%   Response
%   timing
%   StartRTMeasurement
%   EndRTMeasurement
%OTHERWISE DIAGNOSTIC PROCEDURES OR ROUTINES FOR DATAANALYSIS MAIGHT FAIL
TrialInfo.trial = atrial;  %store page numbers and durations
TrialInfo.datestr = strDate;
TrialInfo.tStart = tStart;
TrialInfo.Response = this_response;
TrialInfo.timing = timing;
TrialInfo.startRTMeasurement = StartRTMeasurement;
TrialInfo.endRTMeasurement = EndRTMeasurement;