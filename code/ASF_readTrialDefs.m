function [trialdefs, factorinfo, errorflag, factorNames] = ASF_readTrialDefs(fname, Cfg)
%function [trialdefs, factorinfo, errorflag, factorNames] = ASF_readTrialDefs(fname, Cfg)
%each line is composed of a list of entries, one line per trial
%<code> [pageNumber_1, pageDuration_1]...[pageNumber_n, pageDuration_n] <startRTonPage>
if ~isfield(Cfg, 'randomizeTrials'), Cfg.randomizeTrials = 0; else end;
if ~isfield(Cfg, 'userDefinedSTMcolumns'), Cfg.userDefinedSTMcolumns = 0; else end;
factorNames = {''};
errorflag = 0;
if exist(fname, 'file') == 2
    %FILE EXISTS
    fid = fopen(fname);
    
    %GET FACTOR LEVELS AND IF EXISTS FACTOR NAMES
    aline = fgetl(fid);
    tmpfactorinfo = textscan(aline, '%d');
    nLevels = length(tmpfactorinfo{:});
    factorinfo = double(tmpfactorinfo{:})';
    tmpfactorinfoX = textscan(aline, '%s');
    tmpfactorinfoX = tmpfactorinfoX{:};
    if (length(tmpfactorinfoX)> nLevels)
        %MORE ENTRIES THAN JUST NUMBERS, THUS WE HAVE TEXT CODING FACTOR NAMES
        for i = 1:nLevels
            factorNames{i} = tmpfactorinfoX{i+nLevels}; 
        end
    end

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
        trialdefs(counter).pageNumber = aline(Cfg.userDefinedSTMcolumns+3:2:(end-2)); %#ok<AGROW>
        trialdefs(counter).pageDuration = aline(Cfg.userDefinedSTMcolumns+4:2:(end-2)); %#ok<AGROW>
        trialdefs(counter).startRTonPage = aline(end-1); %#ok<AGROW>
        trialdefs(counter).correctResponse = aline(end); %#ok<AGROW>
    end
    fclose(fid);
else
    %FILE DOES NOT EXIST
    errorflag = 1;
    error('FILE %s NOT FOUND', fname) 
end
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

