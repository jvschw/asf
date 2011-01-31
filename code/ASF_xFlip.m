%function [ VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos ] = ASF_xFlip(windowPtr, texture, Cfg, bPreserveBackBuffer)
%% ASF_xFlip (extended Screen('Flip'))
function [ VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos ] = ASF_xFlip(windowPtr, texture, Cfg, bPreserveBackBuffer)
persistent frameCounter
% persistent flipval
%
% if isempty( flipval )
%     flipval = 0;
% end


switch bPreserveBackBuffer
    case 0 %DESTRUCTIVE FLIP
        [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr);
    case 1 %NONDESTRUCTIVE FLIP
        if Cfg.Screen.useBackBuffer
            %FOR A MACHINE THAT HAS AUXILIARY BACKBUFFERS
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr, [], 1);
        else
            %FOR A MACHINE THAT HAS NO BACKBUFFERS
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', windowPtr);
            Screen('DrawTexture', windowPtr, texture);
        end
end


if Cfg.writeVideo
    if isempty(frameCounter)
        frameCounter = 0;
    end
    frameCounter = frameCounter + 1;
    imageArray = Screen('GetImage', windowPtr );
    VideoName = sprintf('frame%06d.bmp', frameCounter);
    imwrite(imageArray, VideoName, 'BMP')
end

%CHECK IF USER WANTS TO QUIT
[bUpDn, T, keyCodeKbCheck] = KbCheck;
if bUpDn % break out of loop
    if find(keyCodeKbCheck) == 81
        fprintf(1, 'USER ABORTED PROGRAM\n');
        ASF_PTBExit(windowPtr, Cfg, 1)
        %FORCE AN ERROR
        error('USERABORT')
        %IF TRY/CATCH IS ON THE FOLLOWING LINE CAN BE COMMENTED OUT
        %PTBExit(windowPtr);
    end
end

