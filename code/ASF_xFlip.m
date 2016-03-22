%function [ VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos ] = ASF_xFlip(windowPtr, texture, Cfg, bPreserveBackBuffer)
%% ASF_xFlip (extended Screen('Flip'))
function [ VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos, bPauseFlag ] = ASF_xFlip(windowPtr, texture, Cfg, bPreserveBackBuffer)
persistent frameCounter
bPauseFlag = 0;
% persistent flipval
%
% if isempty( flipval )
%     flipval = 0;
% end


switch bPreserveBackBuffer
    case 0 %DESTRUCTIVE FLIP
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos] = Screen('Flip', windowPtr);
    case 1 %NONDESTRUCTIVE FLIP
        if Cfg.Screen.useBackBuffer
            %FOR A MACHINE THAT HAS AUXILIARY BACKBUFFERS
            [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos] = Screen('Flip', windowPtr, [], 1);
        else
            %FOR A MACHINE THAT HAS NO BACKBUFFERS
            [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos] = Screen('Flip', windowPtr);
            Screen('DrawTexture', windowPtr, texture);
        end
end


if Cfg.video.writeVideo
    if isempty(frameCounter)
        frameCounter = 0;
    end
    if Cfg.video.saveCurrentFrame 
        %YOU CAN CHANGE THIS FLAG IN YOUR RENDERING CODE IN ORDER TO ONLY
        %SAVE FRAMES OF INTEREST
        frameCounter = frameCounter + 1;
        imageArray = Screen('GetImage', windowPtr );
        VideoName = sprintf('frame%06d.bmp', frameCounter);
        imwrite(imageArray, VideoName, 'BMP')
    end
end

%CHECK IF USER WANTS TO QUIT
[bUpDn, ~, keyCodeKbCheck] = KbCheck;
if bUpDn % break out of loop
    thisKey = find(keyCodeKbCheck);
    if ismember(thisKey, Cfg.specialKeys.quitExperiment) %quit press q 
        fprintf(1, 'USER ABORTED PROGRAM\n');
        ASF_PTBExit(windowPtr, Cfg, 1)
        %FORCE AN ERROR
        error('USERABORT')
        %IF TRY/CATCH IS ON THE FOLLOWING LINE CAN BE COMMENTED OUT
        %PTBExit(windowPtr);
    end
    %PAUSE? press p, only tested on mac
    if ismember(thisKey, Cfg.specialKeys.pauseExperiment)
        %IF USING fNIRS, PAUSE DATA ACQUISITION
        ASF_setTrigger(Cfg, 64) %ISS IMAGENT DATA ACQUISITION TRIGGER
        fprintf(1, 'USER PAUSED PROGRAM\n');
        Screen('Flip', windowPtr);
        Screen('DrawText', windowPtr, 'PAUSE - PRESS SPACE TO CONTINUE', 20, Cfg.Screen.centerY);
        Screen('Flip', windowPtr);
        bPauseFlag = 1;
        pause
        FlushEvents;
        %Screen('DrawTexture', windowPtr, texture);
        %IF USING fNIRS, REENABLE DATA ACQUISITION
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos] = Screen('Flip', windowPtr);
        ASF_setTrigger(Cfg, 64); %ISS IMAGENT DATA ACQUISITION TRIGGER
        bPauseFlag = 0;
    end

end

