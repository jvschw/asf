function analyzeExampleUpperLower(projectName, varargin)
%function analyzeExampleUpperLower(projectName)
%
%%EXAMPLE CALL
%analyzeExampleUpperLower('exampleUpperLower')
%
%%ASF Jens Schwarzbach

%LOAD STORED LOG FILE
load( projectName )

%res contains the following information extracted from the log
%COL 1: CODE
%COL 2: RT
%COL 3: KEY
%COL 4: CORRECTRESPONSE
res = ASF_readExpInfo( ExpInfo );


%--------------------------------------------------------------------------
%TRIAL REMOVAL BASED ON TIMING ERRORS
%--------------------------------------------------------------------------
Cfg.timingTolerance = 8; %every deviation of actual duration from requested
%page duration exceeding this value will result
%in discarding this trial
trialsWithWrongTiming = [];

%OPTIONAL INPUT diagMat from ASF_timingDiagnosis
optargin = size(varargin,2);
if optargin == 1
    diagMat = varargin{1};
    
    %CHECK IF TIMING IS OK FOR THESE PAGES
    crucialPages = [2, 3, 4]; %prime, isi, mask
    
    %ONLY LOOK AT PAGES FOR WHICH TIMING IS CONSIDERED CRUCIAL
    casesCrucialPages = find(ismember(diagMat(:, 2), crucialPages));
    
    %CHECK IN diagMat's last column which of the crucial pages have produced
    %larger than allowed deviations
    idxTimingViolated =...
        find(abs(diagMat(casesCrucialPages, end)) > Cfg.timingTolerance);
    
    %RETRIEVE FROM diagMat THE TRIALNUMBER(s) THAT CORRESPOND TO THESE PAGES
    %SINCE SEVERAL ERRORS CAN OCCUR IN ANY GIVEN TRIAL, ONLY RETURN UNIQUE
    %TRIAL NUMBERS
    trialsWithWrongTiming = unique(diagMat(casesCrucialPages(idxTimingViolated), 1));
    
    fprintf(1, 'The trials with the following trial numbers should be excluded\n')
    fprintf(1, 'because the requested timing of crucial pages\n');
    fprintf(1, '[')
    fprintf(1, ' %d', crucialPages)
    fprintf(1, ' ] has been violated.\n')
    display(trialsWithWrongTiming)
    
    if ~isempty(trialsWithWrongTiming)
        res(trialsWithWrongTiming, :) = [];
        fprintf('Removed %d trial(s).\n', length(trialsWithWrongTiming));
    end
end

%FACTORIAL DATA ANALYSIS
dat.code = ASF_decode(res(:, 1), ExpInfo.factorinfo.factorLevels);
congruenceVec = ExpInfo.factorinfo.levelNames(1,:);
soaVec = ExpInfo.factorinfo.levelNames(2,:);
posVec = ExpInfo.factorinfo.levelNames(3,:); %UNUSED

for iCongruence = 1:2
    for iSoa = 1:2
        %SELECT TRIALS FOR THIS FACTORIAL COMBINATION, IN WHICH
        %THE PARTICIPANT RESPONDED CORRECTLY
        %WE ARE COLLAPSING ACROSS MASK-DIRECTION (LEFT/RIGHT) AND
        %STIMULUS-POSITION (UVF/LVF)
        
        casesCorrect = find(...
            (dat.code(:, 1)+1 == iCongruence) &...
            (dat.code(:, 2)+1 == iSoa) &...
            (res(:, 3) == res(:, 4)) );  %DISCARD ERROR-TRIALS
        
        %CALCULATE MEAN REACTION TIME AND STANDARD ERROR OF THE MEAN
        %FOR THIS FACTORIAL COMBINATION
        meanRT( iCongruence, iSoa ) = mean( res(casesCorrect, 2) );
        seRT( iCongruence, iSoa ) =...
            std( res(casesCorrect, 2) )/sqrt(length(casesCorrect));
        
    end
end

%CREATE A LINEPLOT WITH ERRORBARS (SEM)
figure
ebh = errorbar(meanRT', seRT');
set(ebh, 'LineWidth', 2)
set(gca, 'xtick', [1, 2], 'xlim', [0.5, 2.5], 'xtickLabel', soaVec)
legend(congruenceVec, 'Location', 'NorthWest')
ylabel('RT [ms]')
xlabel('SOA [frames]')


