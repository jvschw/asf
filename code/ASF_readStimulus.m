function [errorFlag, Stimuli, frameCounter] = ASF_readStimulus(stimName, windowPtr, Cfg)
%function [errorFlag, Stimuli] = ASF_readStimulus(stimName, windowPtr, Cfg)
%READ A SINGLE STIMULUS INTO Stimuli-STRUCTURE
%USED FOR ONLINE STIMULUS LOADING AND FOR STIMULUS PREFETCHING
%20101211 jens.schwarzbach@unitn.it

%ALSO ADD A FLAG FOR NOT ACTUALLY READING THE STIMULUS BUT ONLY CHECKING
%WHETHER IT IS THERE
errorFlag = 0;
frameCounter = 0;

if(exist(stimName, 'file'))
    %IF FILE EXISTS...
    fprintf(1, 'OK\n');
    
    [thisDir, thisName, thisExt] = fileparts(stimName);
    switch thisExt
        case {'.bmp', '.jpg'}
            frameCounter = frameCounter + 1;
            
            %CHECK TYPE OF STIMULUS
            %READ IMAGE INTO MATRIX
            [imdata, MAP] = imread(stimName);
            %convert 1 bit to 8 bit
            if(size(MAP, 1) == 2)
                imdata = 255 - 255*imdata;
            end
            %oldclut = Screen('LoadCLUT', windowPtr, MAP);
            
            
            %PUT IMAGE ON A TEXTURE
            Stimuli.tex(frameCounter) = ASF_makeTexture(windowPtr, imdata);
            s = size(imdata);
            Stimuli.size(frameCounter, :) = s(1:2);
            
        case '.avi'
            %VERSION 3
            thisMovieobject = mmreader(stimName);
            thisMovie.info = get(thisMovieobject);
            idx = 1:Cfg.videoIndexStepSize:thisMovie.info.NumberOfFrames;
            nFrames = length(idx);
            
            
            if Cfg.videoIndexStepSize == 1
                %READ ENTIRE VIDEO
                tmpcdata = read(thisMovieobject);
                for iFrame = 1:nFrames
                    frameCounter = frameCounter + 1;
                    Stimuli.tex(frameCounter) =...
                        ASF_makeTexture(windowPtr, tmpcdata(:, :, :, iFrame));
                end
                
            else
                % Read one frame at a time.
                for iFrame = 1:nFrames
                    tmpcdata = read(thisMovieobject, idx(iFrame));
                    frameCounter = frameCounter + 1;
                    Stimuli.tex(frameCounter) =...
                        ASF_makeTexture(windowPtr, tmpcdata);
                end
            end
            
    end
else
    %IF FILE DOES NOT EXIST
    fprintf(1, 'NOT FOUND\n');
    errorFlag = errorFlag + 1;
end
