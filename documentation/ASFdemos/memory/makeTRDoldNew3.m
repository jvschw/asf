function makeTRDoldNew3(outputName)
%function makeTRDoldNew3(outputName)
%
%%CREATES THE  FILE oldNew2.trd FOR AN EXPERIMENT IN WHICH
%%ALL PICTURES ARE SHOWN ONCE IN THE ORDER AS THEY ARE REFERENCED
%%IN THE STD FILE
%
%%EXAMPLE CALL:
%makeTRDoldNew3('oldNewRandomized.trd')


factorialStructure = 96; %one factor with 96 levels
trialCodes = 1:96;
targetPicture = 1:96;
pictureDurations = [30, 90];
emptyPicture = 98;
nTrials = length(targetPicture);


for iTrial = 1:nTrials
    %DEFINE
    ThisTrial.code = trialCodes(iTrial);
    ThisTrial.tOnset = 0;
    ThisTrial.pictures = [emptyPicture, targetPicture(iTrial)];
    ThisTrial.durations = pictureDurations;
    ThisTrial.nPages = length(ThisTrial.pictures);
    ThisTrial.startRTonPage = 2;
    ThisTrial.endRTonPage = 2;
    ThisTrial.correctResponse = 1;
    TrialDef(iTrial) = ThisTrial;
end

%RANDOMIZE HERE
TrialDef = TrialDef(randperm(nTrials));

%THIS OPENS A TEXT FILE FOR WRITING
fid = fopen(outputName, 'w');
%DESIGN
fprintf(fid, '%4d', factorialStructure);
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


