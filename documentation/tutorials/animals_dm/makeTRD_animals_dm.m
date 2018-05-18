function makeTRD_animals_dm(trdName)
%function makeTRD_animals_dm(trdName)
%jens.schwarzbach@ukr.de
%
%%Example call:
%makeTRD_animals_dm('trialdefs_full.trd')

%SOMETHING ABOUT THE HARDWARE
Cfg.Screen.Resolution.hz = 60;
Cfg.userDefinedSTMcolumns = 0;
Cfg.randomize = 1;
Cfg.jitterTrialOnsets = 0;

Info.factorialStructure = 2; %one factor

Info.factorLevels = [0, 1]; %same cetegory, different category
Info.nFactorLevels = numel(Info.factorLevels);
Info.nReps = 1; %number of replications per valid stimulus-configuration

Info.blankPic = 1;
Info.fixPic = 2;
Info.fac(1).pictures = [3, 4];
Info.fac(2).pictures = [5, 6];

%MAKE TRIALS
TrialDefinitions = makeTrialDefs(Info);

% RANDOMIZE TRIALS
if Cfg.randomize
    TrialDefinitions = shuffleTrials(TrialDefinitions);
end
% JITTER: TRIAL ONSET OF TRIAL N is ONSET OF TRIAL N-1 + SOME JITTER
if Cfg.jitterTrialOnsets
    TrialDefinitions = addJitter(TrialDefinitions, Cfg);
end

% ADD BLANK TRIALS TO START AND END
%TrialDefinitions = addBlankTrials(Info, TrialDefinitions, Cfg);

% WRITE OUT TRD TO DISK
writeTRD(TrialDefinitions, Info, trdName, Cfg)



function TrialDefinitions = makeTrialDefs(Info)
items = horzcat(Info.fac.pictures);

% Begin looping through factors to build trials
trialCounter = 0;
for i = 1:numel(items)
    item1 = items(i);
    %WHICH CATEGORY DOES ITEM 1 BELONG TO?
    for x = 1:Info.nFactorLevels
        if ismember(item1, Info.fac(x).pictures)
            catItem1 = x;
        end
    end
    
    for j = 1:numel(items)
        item2 = items(j);
        %WHICH CATEGORY DOES ITEM 1 BELONG TO?
        for y = 1:Info.nFactorLevels
            if ismember(item2, Info.fac(y).pictures)
                catItem2 = y;
            end
        end
        %DO THE TWO CRITICAL PICTURES (ITEMS) BELONG TO THE SAME CATEGORY?
        isSameCat = catItem1 == catItem2;
        
        %--------------------------
        % CODE
        %--------------------------
        thisTrial.code = ASF_encode(isSameCat, Info.factorialStructure);
        
        %--------------------------
        % TONSET
        %--------------------------
        thisTrial.tOnset = 0;
        
        %--------------------------
        % PAGES AND DURATIONS:
        %the only variable thing is the content of page 3
        %--------------------------
        thisTrial.page =...
            [Info.fixPic item1 Info.fixPic item2 Info.blankPic];
        thisTrial.durations = [18 18 18 18 90];
        
        %--------------------------
        % START RESPONSE PAGE
        %--------------------------
        thisTrial.startRTonPage = 5;
        
        %--------------------------
        % END RESPONSE PAGE
        %--------------------------
        thisTrial.endRTonPage = 5;
        
        %--------------------------
        % CORRECT RESPONSE
        %--------------------------
        if isSameCat
            thisTrial.correctResponse = 1; %LEFT MOUSE
        else
            thisTrial.correctResponse = 2; %RIGHT MOUSE
        end
        
        % Loop through each repetition of the given condition
        for iRep = 1:Info.nReps
            % Increment counter
            trialCounter = trialCounter + 1;
            %--------------------------
            % COPY INTO ARRAY OF TRIAL DEFINITIONS
            %--------------------------
            TrialDefinitions(trialCounter) = thisTrial;            
        end %End rep
        
    end %End item2
end %End item1

function shuffledTrialDefinitions = shuffleTrials(TrialDefinitions)
% This subfunction randomizes the trials. The randomization process can be
% simple or very sophisticated
nTrials = length(TrialDefinitions);

% This is a simple randomization
shuffledTrialDefinitions = TrialDefinitions(randperm(nTrials));

function TrialDefinitions = addJitter(TrialDefinitions, Cfg)
% This subfunction fills in the trial onset times based on some desired
% intertrial interval. We will use 1-2 seconds, in steps of 0.5 second
%
% Onset of trial n is duration of trial n-1 + the jitter value

nTrials = length(TrialDefinitions);
% Maybe pass this ITI vector into the function, too
jitvec = 1:0.5:2;

% Define the first onset, since it is currently NaN;
TrialDefinitions(1).tOnset = 0;
for iTrial = 2:nTrials
    %CALCULATE ONSET AND DURATION OF PREVIOUS TRIAL
    onsetPrevious = TrialDefinitions(iTrial-1).tOnset;
    durationPreviousFrames = sum(TrialDefinitions(iTrial-1).durations)-1; %SUBTRACT ONE FRAME SINCE LAST PAGE IS A DUMMY PAGE OF DURATION 1
    durationPreviousSecs = (1/Cfg.Screen.Resolution.hz)*durationPreviousFrames;
    
    % SHUFFLE JITTER VECTOR
    jitvecTemp = jitvec(randperm(length(jitvec)));
    % PICK THE FIRST ELEMENT AS JITTER
    jitter = jitvecTemp(1);
    
    %ASSIGN NEW ONSET TIME
    TrialDefinitions(iTrial).tOnset = onsetPrevious + durationPreviousSecs + jitter;
end


function TrialDefinitionsNew = addBlankTrials(Info, TrialDefinitions, Cfg)
% This subfunction attaches blank trials to the beginning and end of the
% TrialDefinitions structure

%------------------------
%GENERIC BLANK TRIAL
%------------------------
% CODE
blankTrial.code = 0;
% TONSET
blankTrial.tOnset = 0;
% USER DEFINED COLUMNS
%blankTrial.userDefined = zeros(1, Cfg.userDefinedSTMcolumns);
% PAGES AND DURATIONS
blankTrial.page = Info.blankPic;
blankTrial.durations = 1;
%RESPONSE PARAMETERS
blankTrial.startRTonPage = 2;
blankTrial.endRTonPage = 2;
blankTrial.correctResponse = 0;
% CONDITION NAME
%blankTrial.condName = 'BLANK';
%------------------------

% SHIFT ALL TRIAL ONSETS BY 16s (pass this value into function, too)
nTrials = length(TrialDefinitions);
for iTrial = 1:nTrials
    TrialDefinitions(iTrial).tOnset = TrialDefinitions(iTrial).tOnset + 16;
end

%ADD BLANK TRIALS TO START AND END
TrialDefinitionsNew(1) = blankTrial;
for iTrial = 1:nTrials
    TrialDefinitionsNew(iTrial+1) = TrialDefinitions(iTrial);
end
TrialDefinitionsNew(end+1) = blankTrial;

% Calculate trial onset time for the last blank trial
onsetPrevious = TrialDefinitionsNew(end-1).tOnset;
durationPreviousFrames = sum(TrialDefinitionsNew(end-1).durations)-1; %SUBTRACT ONE FRAME SINCE LAST PAGE IS A DUMMY PAGE OF DURATION 1
durationPreviousSecs = 1/Cfg.Screen.Resolution.hz*durationPreviousFrames;
TrialDefinitionsNew(end).tOnset = onsetPrevious + durationPreviousSecs + 16;

function TRDfileName = writeTRD(TrialDefinitions, Info, trdName, Cfg)
% This subfunction writes out the trd-file to a text file
fprintf(1, 'WRITING %s\n', trdName);

%Open the text file for writing
fid = fopen(trdName, 'wt');

%--------------------------------------------------------------------------
%FIRST LINE OF THE TRD FILE
%Write out the factoral structure onto the first line of the text file
fprintf(fid,'%d   ', Info.factorialStructure);
if isfield(Info, 'factorNames')
    %Write out the names of the factors onto the first line of the text file
    fprintf(fid,'%s   ', Info.factorNames{:});
end

if isfield(Info, 'levelNames')
    %Then write out the names of the levels of each factor
    fprintf(fid,'%s   ', Info.levelNames{:});
end

nTrials = length(TrialDefinitions);

%--------------------------------------------------------------------------
%Loop through TrialDefinitions
for i = 1:nTrials
    
    % Jump to the next line in the text file
    fprintf(fid,'\n');
    
    % CODE
    fprintf(fid, '%d  ', TrialDefinitions(i).code);
    
    % TONSET
    fprintf(fid, '%8.3f    ', TrialDefinitions(i).tOnset);
    
    % USER DEFINED COLUMNS CONTAIN STIMULUS PARAMETERS
    if isfield(TrialDefinitions(i), 'userDefined')
        if numel(TrialDefinitions(i).userDefined) > 0
            fprintf(fid, '%4d ', TrialDefinitions(i).userDefined);
            fprintf(fid, '  ');
        end
    end
    
    % PAGES AND DURATIONS
    fprintf(fid, '%2d %3d   ', [TrialDefinitions(i).page(:),...
        TrialDefinitions(i).durations(:)]');
    fprintf(fid, '  ');
    
    % RESPONSE PARAMS
    fprintf(fid, '%d  ', TrialDefinitions(i).startRTonPage,...
        TrialDefinitions(i).endRTonPage,...
        TrialDefinitions(i).correctResponse);
end
fclose(fid);

