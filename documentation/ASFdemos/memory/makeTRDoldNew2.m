function makeTRDoldNew2
%function makeTRDoldNew2
%
%%CREATES THE  FILE oldNew2.trd FOR AN EXPERIMENT IN WHICH
%%ALL PICTURES ARE SHOWN ONCE IN THE ORDER AS THEY ARE REFERENCED
%%IN THE STD FILE
%
%%EXAMPLE CALL:
%makeTRDoldNew2

outputName = 'oldNew2.trd';

factorialStructure = 96; %one factor with 96 levels
trialCodes = 1:96;
targetPicture = 1:96;
pictureDurations = [30, 90];
emptyPicture = 98;
nTrials = length(targetPicture);

%fid = 1;
%THIS OPENS A TEXT FILE FOR WRITING
fid = fopen(outputName, 'w');
%DESIGN
fprintf(fid, '%4d', factorialStructure);

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
    
    %STORE TRIALDEFINITION IN FILE
    fprintf(fid, '\n'); %New line for new trial
    fprintf(fid, '%4d', ThisTrial.code);
    fprintf(fid, '\t%4d', ThisTrial.tOnset);
    for iPage = 1:ThisTrial.nPages
        %TWO ENTRIES PER PAGE: 1) Picture, 2) Duration
        fprintf(fid, '\t%4d %4d', ThisTrial.pictures(iPage), ThisTrial.durations(iPage));
    end
    %ADD A DUMMY EMPTY PICTURE WITH DURATION OF 1 FRAME
    fprintf(fid, '\t%4d %4d', emptyPicture, 1);

    fprintf(fid, '\t%4d', ThisTrial.startRTonPage);
    fprintf(fid, '\t%4d', ThisTrial.endRTonPage);
    fprintf(fid, '\t%4d', ThisTrial.correctResponse);
    
end
if fid > 1
    fclose(fid);
end
fprintf(1, '\n'); %JUST FOR THE COMMAND WINDOW


