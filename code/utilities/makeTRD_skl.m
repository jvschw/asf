function [TRDfileName, Cfg] = makeTRD_skl(subjectID, session, run, STDfileName, Cfg)
%function TRDfileName = makeTRD_skl(subject, session, run, Cfg)
%
% This skeleton function is a template for users to fill in (or delete) 
% certain details in order to generate a TRD file for their experiments.
% The layout of the subfunctions is designed for an event-related fMRI 
% experiment but can be altered or edited for any kind of experiment.
%
%   EXAMPLE CALL
%      TRDfileName = makeTRD_skl('Demo', 1, 1, 'stimuli.std', Cfg)

% Make the experimental design
[TrialDefinitions, Cfg] = makeDesign(session, run, STDfileName, Cfg);

% Randomization
TrialDefinitions = shuffle(TrialDefinitions);

% Add jitter
TrialDefinitions = addIntertrialJitter(TrialDefinitions, Cfg);

%Add blank trials to start and end (mainly for fMRI)
TrialDefinitions = addBlankTrials(TrialDefinitions, Cfg);

fprintf(1, 'The experiment takes %d seconds, i.e. %d volumes at a TR of %5.3f s\n', ceil(TrialDefinitions(end).tOnset+Cfg.Dur.blankTrial), ceil((TrialDefinitions(end).tOnset+Cfg.Dur.blankTrial)/Cfg.TR), Cfg.TR);

%Write out TRD file to disk
TRDfileName = writeTRD(TrialDefinitions, subjectID, session, run, Cfg);

function [TrialDefinitions, Cfg] = makeDesign(STDfile, Cfg)
% Sets up some basic configurations for the trial definitions

% Get stimuli from STD file
stimuli = importdata(STDfile);


% Find the line numbers of the corresponding images in the STD file and
% manipulate them how you need to (including any blank or fixation images)


%-----------------------------------------------------
%BASICS ABOUT THE DESIGN
%-----------------------------------------------------

% Factor one (and its levels)

% Factor two (and its levels)

% ...

% Factor n (and its levels)


% Define the factorial structure of the experiment. Later used to uniquely
% encode each trial


% Start a trial counter
trialCounter = 0;

% Loop through each trial of your experiment, defining all elements of a
% single line of the TRD file in a structure
for iFac1 = 1:nFac1
    for iFac2 = 1:nFac2
        for iFacn = 1:nFacn
        
            % This condition name (ThisTrial.condName)
            
            % This trial code (ThisTrial.code)
            
            % These user-defined columns (ThisTrial.udc(1:n))
            
            % These pages' textures (ThisTrial.pages)
            
            % These pages' durations (ThisTrial.durations)
            
            % This start response collection page (ThisTrial.startRTpage)
            
            % This end response collection page (ThisTrial.endRTpage)

            % This correct response (ThisTrial.correctResponse)
            
            % Save ThisTrial into larger structure of all trials
            % TrialDefinitions(trialCounter) = ThisTrial;

        end
    end
end

function TrialDefinitionsNew = shuffle(TrialDefinitions)
% Perform a trial randomization scheme

TrialDefinitionsNew = TrialDefinitions;
codes = [TrialDefinitions.code];
nTrials = length(codes);

% The following two sections are mutually exclusive. Comment out whichever
% section you don't want to use (or comment out both and write your own!)
%% Vanilla randomization
% No constraints on trial order

randCondIdx = randperm(nTrials);
% Take the successfully shuffled permutation and permute the
% TrialDefinitions before outputting them
TrialDefinitionsNew = TrialDefinitionsNew(randCondIdx);

%% Ensure that no condition is ever repeated 
% (i.e., the code of trial n is different from the code of trial n+1)

doRepeat = 1;
iter = 0;
fprintf(1, 'ITERATION: %05d', iter);
while doRepeat
    iter = iter + 1;
    if mod(iter, 50) == 0
        fprintf(1, '\b\b\b\b\b%05d', iter);
    end
    
    % We don't want conditions to repeat themselves at all, so we 
    % use a brute-force algorithm, in which we randomize the conditions 
    % and then check that no two conditions are next to each other. 
    % Otherwise, we run another iteration
    
    % First randomize
    randCondIdx = randperm(nTrials);
    shuffledCodes = codes(randCondIdx);
    % Check the difference between randomized codes (0's indicate that
    % similar codes are adjacent; thus, 2 adjacent zeros would be bad for
    % us)
    diffVec = diff(shuffledCodes);
    
    % If we find any 0's, iterate again; otherwise, escape the loop!
    if ~any(diffVec==0)
        fprintf(1, '\n');
        doRepeat = 0;
    end
end
% Take the successfully shuffled permutation and permute the
% TrialDefinitions before outputting them
TrialDefinitionsNew = TrialDefinitionsNew(randCondIdx);

function TrialDefinitions = addIntertrialJitter(TrialDefinitions, Cfg)
% Fills in the trial onset times based on some desired
% intertrial interval. 
%
% Onset of trial n = onset of trial n-1 + duration of trial n-1 +  jitter

% Randomly use 6-8 seconds, in steps of 0.5, uniformly distributed
% (change this to your desired range and randomization)
randVec = 6:0.5:8;

nTrials = length(TrialDefinitions);

% Define the first onset, since it is currently NaN;
TrialDefinitions(1).tOnset = 0;
for iTrial = 2:nTrials
    %Calculate onset and duration of previous trial
    onsetPrevious = TrialDefinitions(iTrial-1).tOnset;
    durationPreviousFrames = sum(TrialDefinitions(iTrial-1).durations);
    durationPreviousSecs = (1/Cfg.Screen.Resolution.hz)*durationPreviousFrames;
   
    % Randomize the randVec
    randIdx = randperm(length(randVec));
    jitter = randVec(randIdx);

    %Assign new onset time using the first element of the jitter vector
    TrialDefinitions(iTrial).tOnset = onsetPrevious + durationPreviousSecs + jitter(1);
end

function TrialDefinitionsNew = addBlankTrials(TrialDefinitions, Cfg)
%------------------------
%GENERIC BLANK TRIAL
%------------------------
blankTrial.code = 0;
blankTrial.tOnset = 0;
%blankTrial.UDC = 0; % This will be variable, of course
blankTrial.pages = Cfg.blankPic; % Whatever number refers to the blank pic
blankTrial.durations = 1;
blankTrial.startRTonPage = 2;
blankTrial.endRTonPage = 2;
blankTrial.correctResponse = 0;
blankTrial.condName = 'BLANK';
%------------------------

%SHIFT ALL TRIAL ONSETS BY Cfg.Dur.blankTrial (defined elsewhere) SECONDS
nTrials = length(TrialDefinitions);
for iTrial = 1:nTrials
    TrialDefinitions(iTrial).tOnset = TrialDefinitions(iTrial).tOnset + Cfg.Dur.blankTrial;
end

%ADD BLANK TRIALS TO START AND END
TrialDefinitionsNew(1) = blankTrial;
for iTrial = 1:nTrials
    TrialDefinitionsNew(iTrial+1) = TrialDefinitions(iTrial);
end
TrialDefinitionsNew(end+1) = blankTrial;

% Assign trial onset time to the last blank trial, which is just the
% duration of the previous trial + the previous trial's onset time (no
% jitter here)
onsetPrevious = TrialDefinitionsNew(end-1).tOnset;
durationPreviousFrames = sum(TrialDefinitionsNew(end-1).durations);
durationPreviousSecs = (1/Cfg.Screen.Resolution.hz)*durationPreviousFrames;
TrialDefinitionsNew(end).tOnset = onsetPrevious + durationPreviousSecs;

% Last blank trial needs to last Cfg.Dur.blankTrial seconds
% So the last blank trial does NOT have a duration of 1 frame, but rather
% Cfg.Dur.blankTrial*Cfg.Screen.Resolution.hz
TrialDefinitionsNew(end).durations = Cfg.Dur.blankTrial*Cfg.Screen.Resolution.hz;

function TRDfileName = writeTRD(TrialDefinitions, subjectID, session, run, Cfg)
%function TRDfileName = DMCt_writeTRD(TrialDefinitions, subject, session, run, Cfg)
% This function writes out a trd-file (a text file) based on the information
% stored in the TrialDefinitions and info structures for the behavioral
% Spatial Frequeny experiment
%
% Last edit: 2013 Mar 28 Seth Levine
%
%   EXAMPLE CALL
%       writeTRDtoFile_DMCt_fMRI(TrialDefinitions, info, 'Seth', 1, 1, Cfg)

%Create a string that is the name of the TRD file given the subjectID,
%session number, and run number (and anything else necessary to make this
%file unique)
TRDfileName = sprintf('%s-%s-%s-%s', Cfg.expID, subjectID, session, run);
fprintf(1, 'WRITING %s\n', TRDfileName);

%Open the text file for writing
fid = fopen(TRDfileName, 'w');

%--------------------------------------------------------------------------
%FIRST LINE OF THE TRD FILE

%Write out the factoral structure onto the first line of the text file
fprintf(fid,'%d\t', Cfg.factorialStructure);

%Write out the names of the factors onto the first line of the text file
fprintf(fid,'%s ', Cfg.factorNames{:});


%Then write out the names of the levels of each factor
fprintf(fid,'%s ', Cfg.levelNames{:});
%--------------------------------------------------------------------------

%Loop through every element of the structure TrialDefinitions (this is the
%number of trials in the experiment

nTrials = length(TrialDefinitions);

for i=1:nTrials
    fprintf(fid,'\n');  %Jump to the next line in the text file
    
    %CODE
    fprintf(fid, '%4d\t', TrialDefinitions(i).code);
    
    %TONSET
    fprintf(fid, '%8.3f\t', TrialDefinitions(i).tOnset);
    
    % UDC
    fprintf(fid, '%4d\t', TrialDefinitions(i).UDC);

    %PAGES AND DURATIONS
    fprintf(fid, '%3g %3g \t', [TrialDefinitions(i).pages(:), TrialDefinitions(i).durations(:)]');
    
    %RESPONSE PARAMS
    fprintf(fid, '%3d ', TrialDefinitions(i).startRTonPage,...
        TrialDefinitions(i).endRTonPage,...
        TrialDefinitions(i).correctResponse);
end
fclose(fid);