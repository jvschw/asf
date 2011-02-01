function trdName = makeExampleUpperLowerTrd(strProjectName)
%function trdName = makeExampleUpperLowerTrd(strProjectName)
%%Creates a .trd file for a masked priming experiment in ASF
%%based on makeExampleCentral.m
%%adding user supplied stm columns which indicate the position of the prime
%%and the mask
%%requires a userdefined plugin which interprets these values and shows
%%prime and mask at specified locations (as opposed to always centered on
%%the screen; see ASF_showTrialMaskedPrimingUpperLower.m)
%
%Example call to create 'exampleUpperLower.trd':
%trdName = makeExampleUpperLowerTrd('exampleUpperLower')
%
%%ASF by Jens Schwarzbach

%STIMULUS
%CAN BE MADE MORE FLEXIBLE BY READING IN STIMULI
sizeOfBitmapsXY = [128, 88];
%CAN BE MADE MORE FLEXIBLE BY READING IN SCREEN RESOLUTION
centerOfScreenXY = [1024/2, 768/2]; 

%--------------------------------------------------------------------------
%DESIGN ASPECTS
%--------------------------------------------------------------------------
Design.soaLevels = [3, 6];
Design.nSoaLevels = length(Design.soaLevels);

Design.primeDirectionLevels = [0, 1]; %LEFT, RIGHT
Design.nPrimeDirectionLevels = length(Design.primeDirectionLevels);

Design.maskDirectionLevels = [0, 1]; %LEFT, RIGHT
Design.nMaskDirectionLevels = length(Design.maskDirectionLevels);

Design.verticalOffsetLevels = [-100, 100]; %UVF, LVF
Design.nVerticalOffsetLevels = length(Design.verticalOffsetLevels);

Design.primeDuration = 1; %PRIMES WILL BE SHOWN FOR ONE FRAME
Design.maskDuration = 6; %MASK WILL BE SHOWN FOR SIX FRAMES

Design.responseWindow = 90; %PARTICIPANTS HAVE NINETY FRAMES TO RESPOND

Design.factorNames = {'Congruence', 'SOA', 'Position'};
Design.nFactors = length(Design.factorNames);
Design.factorLevels = [2, Design.nSoaLevels, Design.nVerticalOffsetLevels];
Design.levelNames{1, 1} = 'congruent';
Design.levelNames{1, 2} = 'incongruent';
for i = 1:Design.factorLevels(2)
    Design.levelNames{2, i} = sprintf('SOA%d', Design.soaLevels(i));
end
Design.levelNames{3, 1} = 'UVF';
Design.levelNames{3, 2} = 'LVF';


Design.nReplicationsPerCondition = 5; 

%SIMPLE VARIATION OF TRIAL ONSET ASYNCHRONIES FOR fMRI
%WILL ONLY BECOME EFFECTIVE WHEN CALLING ASF WITH
%Cfg.useTrialOnsetTimes = 1
Design.jitteredTrialOnsetAsynchronies = [2:0.5:7]; %MIN, STEP, MAX

%PICTURE CODES MUST REFLECT ORDER IN STD FILE
PictureCodes.empty = 1;
PictureCodes.fix = 2;
PictureCodes.primeLeft = 3;
PictureCodes.primeRight = 4;
PictureCodes.maskLeft = 5;
PictureCodes.maskRight = 6;

%--------------------------------------------------------------------------
%HARDWARE ASPECTS
%--------------------------------------------------------------------------
ResponseKey.left = 1; %LEFT MOUSE BUTTON
ResponseKey.right = 3; %RIGHT MOUSE BUTTON

%--------------------------------------------------------------------------
%LOOP THROUGH ENTIRE DESIGN TO CREATE A LIST CONTAINING ALL TRIALS
%--------------------------------------------------------------------------
%SAME FOR ALL TRIALS
ThisTrial.tOnset = 0;%UNUSED PARAMETER
ThisTrial.primeDuration = Design.primeDuration;
ThisTrial.maskDuration = Design.maskDuration;
ThisTrial.responseWindow = Design.responseWindow;
ThisTrial.startRTmeasurementOnPage = 4;
ThisTrial.endRTmeasurementOnPage = 5;
ThisTrial.empty = PictureCodes.empty;
ThisTrial.fixPicture = PictureCodes.fix;

counter = 0;
for iPrimeDirection = 1:Design.nPrimeDirectionLevels
    for iMaskDirection = 1:Design.nMaskDirectionLevels
        for iSoa = 1:Design.nSoaLevels
            for iPosition = 1:Design.nVerticalOffsetLevels
                for iReplication = 1:Design.nReplicationsPerCondition
                    %YIELDING 2*2*2*2*5 = 80 trials
                    
                    %FILL STRUCTURE ThisTrial WITH ALL PARAMETERS THAT ARE
                    %RELEVANT FOR THIS TRIAL
                    
                    %USER DEFINED STM COLUMNS
                    ThisTrial.primePage = 2;
                    ThisTrial.maskPage = 4;
                    ThisTrial.primeMaskPosition = CenterRectOnPoint(...
                        [1, 1, sizeOfBitmapsXY],...
                        centerOfScreenXY(1),...
                        centerOfScreenXY(2)+Design.verticalOffsetLevels(iPosition));

                    
                    %VARIABLE PRESTIMULUS PERIOD BETWEEN 15 AND 45 FRAMES
                    ThisTrial.preStimPeriod = round(rand*30)+15;
                    
                    %PRIME
                    if iPrimeDirection == 1
                        ThisTrial.primePicture = PictureCodes.primeLeft;
                    else
                        ThisTrial.primePicture = PictureCodes.primeRight;
                    end
                    
                    %MASK
                    if iMaskDirection == 1
                        ThisTrial.maskPicture = PictureCodes.maskLeft;
                        ThisTrial.correctResponse = ResponseKey.left;
                    else
                        ThisTrial.maskPicture = PictureCodes.maskRight;
                        ThisTrial.correctResponse = ResponseKey.right;
                    end
                    
                    %SOA-prime-mask
                    ThisTrial.Soa = Design.soaLevels( iSoa );
                    
                    
                    %CODING OF CONDITIONS
                    %CONGRUENCE (CONGRUENT = 0, INCONGRUENT = 1)
                    if iPrimeDirection == iMaskDirection
                        ThisTrial.congruence = 0; %congruent
                    else
                        ThisTrial.congruence = 1; %incongruent
                    end
                    
                    %WE CODE CONGRUENCE AND SOA-LEVEL
                    %MAKE SURE THIS HAS THE SAME ORRDER AS FACTORIAL INFO
                    ThisTrial.code = ASF_encode(...
                        [ThisTrial.congruence, iSoa-1, iPosition-1],...
                        [2, Design.nSoaLevels, Design.nVerticalOffsetLevels] );
                    
                    
                    %CREATE A TRIALDEFINITION FOR THIS TRIAL
                    counter = counter + 1;
                    TrialVec( counter ) = ThisTrial;
                end
            end
        end
    end
end

Design.nTrials = counter;

%--------------------------------------------------------------------------
%RANDOMIZE TRIALS (NO RESTRICTIONS)
%--------------------------------------------------------------------------
TrialVec = TrialVec(randperm(Design.nTrials));

%--------------------------------------------------------------------------
%JITTER TRIAL ONSET TIMES (for fMRI DEMO)
%--------------------------------------------------------------------------
TrialVec(1).tOnset = 12; %WAIT FOR MR-SIGNAL TO RELAX BEFORE STARTING
jitterVec = Design.jitteredTrialOnsetAsynchronies;
for iTrial = 2:Design.nTrials
    %PERMUTE
    jitterVec = jitterVec( randperm( length( jitterVec ) ) );
    %PICK FIRST ELEMENT OF PERMUTED JITTERVEC AS THIS TRIAL'S JITTER
    jitter = jitterVec( 1 );
    %NEW ONSET TIME IS ONSET TIME OF PREVIOUS TRIAL PLUS JITTER
    TrialVec(iTrial).tOnset =  TrialVec( iTrial-1 ).tOnset + jitter;
end
%YOU MAY WANT TO ADD AN EMPTY TRIAL AT THE VERY END OF YOUR EXPERIMENT
%IN ORDER TO LET THE BOLD RESPONSE RELAX. NOT COVERED HERE.

%--------------------------------------------------------------------------
%WRITE TRD FILE
%--------------------------------------------------------------------------
trdName = writeTrdFile( strProjectName, Design, TrialVec);


function fName = writeTrdFile( strProjectName, Design, TrialVec)
%function fName = writeTrdFile( strProjectName, Design, TrialVec)
%PUTS TOGETHER ALL INFORMATION IN TRIALDEFINITION TO GENERATE A TRD FILE
%RETURNS NAME OF TRD FILE
fName = [strProjectName, '.trd'];
fid = fopen( fName, 'w');
if fid
    fprintf( 1, 'WRITING %s ...', fName);
else
    error( 'Error: %s cannot be created.', fName);
end

%WRITE DESIGN INFO
fprintf(fid, '%3d ', Design.factorLevels);
fprintf(fid, '%s ', Design.factorNames{:});
for i = 1:Design.nFactors
    for j = 1:Design.factorLevels(i)
        fprintf(fid, '%s ', Design.levelNames{i, j});
    end
end
%WRITE TRIAL INFO, ONE LINE PER TRIAL
for i = 1:length( TrialVec )
    ThisTrial = TrialVec( i ); %PICK CURRENT TRIAL
    fprintf( fid, '\n' ); %NEW LINE
    
    %CODE
    fprintf( fid, '%3d\t', ThisTrial.code );
    
    %ONSET
    fprintf( fid, '%8.3f\t', ThisTrial.tOnset );
    
    %USERDEFINED COLUMNS
    fprintf( fid, '%3d ', ThisTrial.primePage);
    fprintf( fid, '%3d ', ThisTrial.maskPage);
    fprintf( fid, '%3d ',  ThisTrial.primeMaskPosition);
    fprintf( fid, '\t');

    %PAIRS OF PICTURENUMBERS AND DURATIONS
    fprintf( fid, '%3d %3d\t\t', ThisTrial.fixPicture, ThisTrial.preStimPeriod );
    fprintf( fid, '%3d %3d\t\t', ThisTrial.primePicture, ThisTrial.primeDuration);
    interStimulusInterval = ThisTrial.Soa - ThisTrial.primeDuration;
    fprintf( fid, '%3d %3d\t\t', ThisTrial.fixPicture, interStimulusInterval );
    fprintf( fid, '%3d %3d\t\t', ThisTrial.maskPicture, ThisTrial.maskDuration );
    fprintf( fid, '%3d %3d\t\t', ThisTrial.fixPicture, ThisTrial.responseWindow );
    %ADDING A DUMMY PICTURE WITH DURATION OF 1 FRAME
    fprintf( fid, '%3d %3d\t\t', ThisTrial.fixPicture, 1);
    
    %RESPONSE COLLECTION
    fprintf( fid, '%3d\t', ThisTrial.startRTmeasurementOnPage );
    fprintf( fid, '%3d\t', ThisTrial.endRTmeasurementOnPage );
    fprintf( fid, '%3d', ThisTrial.correctResponse );
    
end
fclose(fid);
