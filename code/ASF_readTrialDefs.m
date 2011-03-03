function [trialdefs, factorStruct, errorflag] = ASF_readTrialDefs(fname, Cfg)
%function [trialdefs, factorStruct, errorflag] = ASF_readTrialDefs(fname, Cfg)
%each line is composed of a list of entries, one line per trial
%<code> [pageNumber_1, pageDuration_1]...[pageNumber_n, pageDuration_n] <startRTonPage>
if ~isfield(Cfg, 'randomizeTrials'), Cfg.randomizeTrials = 0; else end;
if ~isfield(Cfg, 'userDefinedSTMcolumns'), Cfg.userDefinedSTMcolumns = 0; else end;

%CREATE AN EMPTY DESCRIPTION OF FACTORIAL STRUCTURE
factorStruct.nFactors = [];
factorStruct.factorLevels = [];
factorStruct.factorNames = [];
factorStruct.levelNames = [];

errorflag = 0;
if exist(fname, 'file') == 2
    %FILE EXISTS
    fid = fopen(fname);
    
    %GET FACTOR LEVELS
    aline = fgetl(fid);
    tmpfactorinfo = textscan(aline, '%d');
    factorStruct.factorLevels = double(tmpfactorinfo{:})';
    factorStruct.nFactors = length(factorStruct.factorLevels);
    
    %CONVERT THE ENTIRE FACTORIAL INFO INTO A CELL 
    tmpfactorinfoX = textscan(aline, '%s');
    tmpfactorinfoX = tmpfactorinfoX{:};
    nEntries = length(tmpfactorinfoX);
    %ERROR CHECKING
    if (nEntries == 2*factorStruct.nFactors + sum(factorStruct.factorLevels))
        %OK, WE HAVE A SITUATION LIKE THIS
        % 2 2 congruence targetside congruent incongruent left right
        %THE NUMERICAL DEsIGN-INFO [2, 2]
        %THE FACTOR NAMES {'congruence', 'targetside'}
        %NAMES FOR EACH LEVEL (PER FACTOR) 
        %{congruent incongruent left right'}
        %WE CAN PROCEED EXTRACTING RESPECTIVE NAMES
        counter = 0;
        for i = 1:factorStruct.nFactors
            factorStruct.factorNames{i} = tmpfactorinfoX{factorStruct.nFactors+i};
            for j = 1:factorStruct.factorLevels(i)
                counter = counter + 1;
%                 factorStruct.levelNames{i, j} =...
%                     tmpfactorinfoX{2*factorStruct.nFactors + (i-1)*factorStruct.factorLevels(i) + j};
                factorStruct.levelNames{i, j} =...
                    tmpfactorinfoX{2*factorStruct.nFactors + counter};

            end
        end
        %WE END UP WITH SOMETHING LIKE THIS
        %         factorStruct =
        %
        %          design: [2 2]
        %        nFactors: 2
        %     factorNames: {'congruence'  'targetside'}
        %      levelNames: {2x2 cell}
        
    else
        if (nEntries == factorStruct.nFactors)
            %WE JUST HAVE THE INFO ABOUT NUMBER OF FACTORS AND RESPECTIVE
            %LEVELS, WE CAN PROCEED (MAYBE WARN THE USER)
        else
            if (nEntries == factorStruct.nFactors*2)
                %WE JUST HAVE THE INFO ABOUT NUMBER OF FACTORS AND THEIR
                %RESPECTIVE NAMES (NO NAMES FOR FACTOR-LEVELS)
                for i = 1:factorStruct.nFactors
                    factorStruct.factorNames{i} =...
                        tmpfactorinfoX{factorStruct.nFactors+i};
                end
                
            else
                %PRODUCE ERROR MESSAGE
                errorflag = 1;
            end
        end
    end
    display(factorStruct)
    
    %READ IN TRIAL DEFINITIONS, ONE BY ONE
    counter = 0;
    while 1
        counter = counter + 1;
        aline = fgetl(fid);
        if ~ischar(aline), break, end
        %fprintf(1, '%s\n', aline)
        aline = str2num(aline); %#ok<ST2NM>
        trialdefs(counter).code = aline(1); %#ok<AGROW>
        trialdefs(counter).tOnset = aline(2); %#ok<AGROW>
        
        %SPACE FOR USER DEFINED TRIAL DEFINITIONS
        if Cfg.userDefinedSTMcolumns
            for c = 1:Cfg.userDefinedSTMcolumns
                trialdefs(counter).userDefined(c) = aline(2+c); %#ok<AGROW>
            end
        end
        
        %THIS WILL ONLY STAY IN FOR A BRIEF PERIOD TO PROVIDE BACKWARD
        %COMPATIBILITY WITH OLDER TRD FILES
        if(Cfg.hasEndRTonPageInfo)
            %VERSION THAT HAS endRTonPage
            trialdefs(counter).pageNumber = aline(Cfg.userDefinedSTMcolumns+3:2:(end-3)); %#ok<AGROW>
            trialdefs(counter).pageDuration = aline(Cfg.userDefinedSTMcolumns+4:2:(end-3)); %#ok<AGROW>
            trialdefs(counter).startRTonPage = aline(end-2); %#ok<AGROW>
            trialdefs(counter).endRTonPage = aline(end-1); %#ok<AGROW>
            trialdefs(counter).correctResponse = aline(end); %#ok<AGROW>
            
        else
            %VERSION THAT DOES NOT HAVE endRTonPage
            trialdefs(counter).pageNumber = aline(Cfg.userDefinedSTMcolumns+3:2:(end-2)); %#ok<AGROW>
            trialdefs(counter).pageDuration = aline(Cfg.userDefinedSTMcolumns+4:2:(end-2)); %#ok<AGROW>
            trialdefs(counter).startRTonPage = aline(end-1); %#ok<AGROW>
            trialdefs(counter).endRTonPage  = trialdefs(counter).startRTonPage;
            trialdefs(counter).correctResponse = aline(end); %#ok<AGROW>
        end
        
    end
    fclose(fid);
else
    %FILE DOES NOT EXIST
    errorflag = 1;
    error('FILE %s NOT FOUND', fname) 
end

%A LITTLE RANDOMIZATION PROCEDURE WHICH SHUFFLES TRIALS, ALLOWING FOR THE
%RESTRICTION OF NO IMMEDIATE REPETITION OF THE SAME CONDITION
%CONSIDER OUTSOURCING INTO ITS OWN FUNCTION
if Cfg.randomizeTrials
    fprintf(1, 'RANDOMIZING TRIALS ... ');
    %RANDOMIZE ORDER OF TRIALS BUT NOT THE TRIAL ONSET VECTOR
    tOnset = [trialdefs.tOnset];
    if Cfg.randomizeTrialsNoImmediateRepeat
        doRepeat = 1;
        i = 0;
        fprintf(1, 'PASS %05d', i);
        while doRepeat
            i = i + 1;
            idx = randperm(counter-1);
            doRepeat = any(diff(idx) == 0);
            if (mod(i, 10) == 0)
                fprintf(1, '\b\b\b\b\b%05d', i);
            end
        end
        trialdefs = trialdefs(idx);
        fprintf(1, ' ');
    else
        trialdefs = trialdefs(randperm(counter-1));
    end
    for iTrial = 1:(counter - 1)
        trialdefs(iTrial).tOnset = tOnset(iTrial); 
    end
    fprintf(1, 'DONE\n')
end

