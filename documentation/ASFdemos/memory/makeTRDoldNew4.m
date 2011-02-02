function makeTRDoldNew4(outputName)
%function makeTRDoldNew4(outputName)
%
%%CREATES THE  FILE outputName.trd FOR AN EXPERIMENT IN WHICH
%%ALL PICTURES ARE SHOWN, ONE FOURTH OF THE PICTURES IS REPEATED ONCE
%%PARTICIPANT RESPONDS:
%"NEW"->LEFT MOUSE BUTTON
%"OLD"->RIGHT MOUSE BUTTON
%
%%EXAMPLE CALL:
%makeTRDoldNew4('oldNewRandomizedRepeat.trd')

Design.factorNames = {'Repeated', 'PictureNumber'};
Design.nFactors = length(Design.factorNames);
Design.factorLevels = [ 2, 96]; 

trialCodes = 1:96;
targetPicture = 1:96;
pictureDurations = [30, 90];
emptyPicture = 98;
nTrials = length(targetPicture);


for iTrial = 1:nTrials
    %CODE PICTURE NUMBER, NON-REPEATED
    ThisTrial.code = ASF_encode( [0, iTrial-1], Design.factorLevels);
    ThisTrial.tOnset = 0;
    ThisTrial.pictures = [emptyPicture, targetPicture(iTrial)];
    ThisTrial.durations = pictureDurations;
    ThisTrial.nPages = length(ThisTrial.pictures);
    ThisTrial.startRTonPage = 2;
    ThisTrial.endRTonPage = 2;
    ThisTrial.correctResponse = 1;
    TrialDef(iTrial) = ThisTrial; 
end

%PICTURES TO REPEAT
idx = randperm(nTrials);
idxToRepeat = idx(1:nTrials/4);
TrialDefRepeat = TrialDef(idxToRepeat);


TrialDef = [TrialDef, TrialDefRepeat];
nTrials = length(TrialDef);


%RANDOMIZE HERE
idx = randperm(nTrials);
TrialDef = TrialDef(idx);


%NOW CHECK WHO HAS BEEN REPEATED
hasBeenShownAlready = zeros(nTrials, 1);
for iTrial = 1:nTrials
    if(hasBeenShownAlready(TrialDef(iTrial).code))
        TrialDef(iTrial).code = ASF_encode( [1, TrialDef(iTrial).code-1], Design.factorLevels);
        TrialDef(iTrial).correctResponse = 3;
    end
    hasBeenShownAlready(TrialDef(iTrial).code) = 1;
end

%THIS OPENS A TEXT FILE FOR WRITING
fid = fopen(outputName, 'w'); 
%DESIGN
fprintf(fid, '%3d ', Design.factorLevels);
fprintf(fid, '%s ', Design.factorNames{:});
for iTrial = 1:nTrials
    %STORE TRIALDEFINITION IN FILE
    fprintf(fid, '\n'); %New line for new trial
    fprintf(fid, '%4d', TrialDef(iTrial).code);
    fprintf(fid, '\t%4d', TrialDef(iTrial).tOnset);
    for iPage = 1:TrialDef(iTrial).nPages
        %TWO ENTRIES PER PAGE: 1) Picture, 2) Duration
        fprintf(fid, '\t%4d %4d', TrialDef(iTrial).pictures(iPage), TrialDef(iTrial).durations(iPage));
    end
    %ADD A DUMMY EMPTY PICTURE WITH DURATION OF 1 FRAME
    fprintf(fid, '\t%4d %4d', emptyPicture, 1);

    fprintf(fid, '\t%4d', TrialDef(iTrial).startRTonPage);
    fprintf(fid, '\t%4d', TrialDef(iTrial).endRTonPage);
    fprintf(fid, '\t%4d', TrialDef(iTrial).correctResponse);
end
if fid > 1
    fclose(fid);
end
fprintf(1, '\n'); %JUST FOR THE COMMAND WINDOW
    
    
