function makeTRDMaskedPrimingFinal(trdName)
%function makeTRDMaskedPrimingFinal(trdName)
%
%%CREATES THE  FILE trdName FOR AN EXPERIMENT IN WHICH
%%ALL PICTURES ARE SHOWN ONCE IN THE ORDER AS THEY ARE REFERENCED
%%IN THE STD FILE
%DESIGN CHANGED TO 3 prime levels, 3 soa levels, 2 mask levels
%nReplications = 10
%this yields 20 replications for each cell of interest (congruence, SOA)
%
%%EXAMPLE CALL:
%makeTRDMaskedPrimingFinal('mp.trd')

% REMEMBER
% .\pictures\stim_01_empty.bmp
% .\pictures\stim_02_fix.bmp
% .\pictures\stim_03_prime_left.bmp
% .\pictures\stim_04_prime_neutral.bmp
% .\pictures\stim_05_prime_right.bmp
% .\pictures\stim_06_mask_left.bmp
% .\pictures\stim_07_mask_right.bmp

%--------------------------------------------------------------------------
%BASICS ABOUT THE DESIGN
%--------------------------------------------------------------------------
info.primeLevels = [1, 2, 3]; %left, neutral, right
info.nPrimeLevels = length(info.primeLevels);
info.primePictures = [3, 4, 5]; %left, neutral, right

info.soaLevels = [2, 4, 6]; %2 or 4 or 6 frames, i.e.33 66 or 100ms
info.nSoaLevels = length(info.soaLevels);

info.maskLevels = [1, 2]; %left, right
info.nMaskLevels = length(info.maskLevels);
info.maskPictures = [6, 7]; %left, right

info.emptyPicture = 1;
info.fixationPicture = 2;

info.fix1Duration = 30;
info.primeDuration = 1;
info.fix2Duration = NaN;
info.maskDuration = 6;
info.emptyDuration = 90;

info.factorialStructure = [info.nPrimeLevels info.nSoaLevels info.nMaskLevels]; %prime(l, n, r), soa(50, 100), mask(l, r)

%HOW MANY TRIALS PER DESIGN CELL DO YOU WANT TO RUN?
%IF YOU ARE INTERESTED IN RT ONLY, >25 IS RECOMMENDED PER PARTICIPANT
%AND CONDITIONS OF INTEREST
%IF YOU ARE INTERESTED IN ERROR RATES, 100 IS RECOMMENDED PER PARTICIPANT
%YOU MAY WANT TO SPAWN THIS NUMBER OVER DIFFERENT SESSIONS IF YOU HAVE A
%BIG DESIGN
info.nReplications = 10;

%--------------------------------------------------------------------------
%DEFINE ALL TRIALS
%--------------------------------------------------------------------------
TrialDefinitions = makeTrialDefinitions(info);

%--------------------------------------------------------------------------
%RANDOMIZE TRIALS
%--------------------------------------------------------------------------
nTrials = length(TrialDefinitions);
TrialDefinitions = TrialDefinitions(randperm(nTrials));

%--------------------------------------------------------------------------
%WRITE RANDOMIZED DEFINITION TO TRD FILE
%--------------------------------------------------------------------------
writeTrialDefinitions(TrialDefinitions, info, trdName)


%--------------------------------------------------------------------------
%function TrialDefinitions = makeTrialDefinitions(info)
%CREATES  AN ARRAY OF TRIAL DEFINITIONS
%TAKES INTO ACCOUNT THE FACTRIAL INFORMATION PROVIDED ABOVE
%THIS IS THE MAIN PART YOU WOULD HAVE TO CHANGE FOR A DIFFERENT KIND OF
%EXPERIMENT
%--------------------------------------------------------------------------
function TrialDefinitions = makeTrialDefinitions(info)
trialCounter = 0;
for iPrime = 1:info.nPrimeLevels
    for iSoa = 1:info.nSoaLevels
        for iMask = 1:info.nMaskLevels
            for iReplication = 1:info.nReplications
                %ENCODING OF FACTOR LEVELS (FACTOR LEVELS MUST START AT 0)
                ThisTrial.code = ASF_encode([iPrime-1 iSoa-1 iMask-1], info.factorialStructure);
                ThisTrial.tOnset = 0;

                %WHICH PICTURES WILL BE SHOWN IN THIS TRIAL? ONLY TWO OF
                %THEM ARE TRIAL-DEPENDENT
                ThisTrial.primePicture = info.primePictures(iPrime);
                ThisTrial.maskPicture = info.maskPictures(iMask);
                %THE STRUCTURE IS ALWAYS THE SAME
                ThisTrial.pictures = [...
                    info.fixationPicture,...
                    ThisTrial.primePicture,...
                    info.fixationPicture,...
                    ThisTrial.maskPicture,...
                    info.emptyPicture];

                %FOR HOW LONG WILL EACH PICTURE BE PRESENTED? ONLY ONE DURATION
                %IS TRIAL-DEPENDENT
                ThisTrial.interStimulusInterval = info.soaLevels(iSoa) - info.primeDuration;
                %THE STRUCTURE IS ALWAYS THE SAME
                ThisTrial.durations = [...
                    round(rand*15)+30,... %WAS: info.fix1Duration,... %NOW VARIES BETWEEN 30 and 45 frames
                    info.primeDuration,...
                    ThisTrial.interStimulusInterval,...
                    info.maskDuration,...
                    info.emptyDuration];

                %WE START MEASURING THE RT AS SOON AS THE MASK IS PRESENTED,
                %i.e. PAGE 4
                ThisTrial.startRTonPage = 4;

                %WE PROVIDE WHAT SHOULd BE A CORRET RESPONSE
                %THIS CANBE USED FOR ONLINE FEEDBACK, BUT ALSO FOR DATA
                %ANALYSIS
                switch iMask
                    case 1
                        %LEFT
                        ThisTrial.correctResponse = 1; %LEFT MOUSE BUTTON
                    case 2
                        %RIGHT
                        ThisTrial.correctResponse = 3; %RIGHT MOUSE BUTTON
                end

                %NOW WE STORE THIS TRIAL DEFIBITION IN AN ARRAY OF TRIAL
                %DEFINITIONS
                trialCounter = trialCounter + 1;
                TrialDefinitions(trialCounter) = ThisTrial;
            end %end replications
        end %end maskLevels
    end %end soaLevels
end %end primeLevels

%--------------------------------------------------------------------------
%function writeTrialDefinitions(TrialDefinitions, info, fileName)
%WRITES FACTORIAL INFO AND ARRAY OF TRIAL DEFINITIONS TO A FILE
%IF YOU DO NOT USE USER-SUPPLIED TRD-COLUMNS, THIS WORKS FOR ALL
%EXPERIMENTS AND DOES NOT NEED TO BE CHANGED
%--------------------------------------------------------------------------
function writeTrialDefinitions(TrialDefinitions, info, fileName)
if isempty(fileName)
    fid = 1;
else
    %THIS OPENS A TEXT FILE FOR WRITING
    fid = fopen(fileName, 'w');
    fprintf(1, 'Creating file %s ...', fileName);
end

%WRITE DESIGN INFO
fprintf(fid, '%4d', info.factorialStructure );

nTrials = length(TrialDefinitions);
for iTrial = 1:nTrials
    nPages = length(TrialDefinitions(iTrial).pictures);

    %STORE TRIALDEFINITION IN FILE
    fprintf(fid, '\n'); %New line for new trial
    fprintf(fid, '%4d', TrialDefinitions(iTrial).code);
    fprintf(fid, '\t%4d', TrialDefinitions(iTrial).tOnset);
    for iPage = 1:nPages
        %TWO ENTRIES PER PAGE: 1) Picture, 2) Duration
        fprintf(fid, '\t%4d %4d', TrialDefinitions(iTrial).pictures(iPage), TrialDefinitions(iTrial).durations(iPage));
    end
    fprintf(fid, '\t%4d', TrialDefinitions(iTrial).startRTonPage);
    fprintf(fid, '\t%4d', TrialDefinitions(iTrial).correctResponse);

end
if fid > 1
    fclose(fid);
end

fprintf(1, '\nDONE\n'); %JUST FOR THE COMMAND WINDOW