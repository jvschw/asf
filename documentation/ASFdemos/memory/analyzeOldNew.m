function [dprime, criterion] = analyzeOldNew(logName, recodeKeys)
%function analyzeOldNew(logName, recodeKeys)
%%Example call:
%[dprime, criterion] = analyzeOldNew('memtest_4sample', 1)
%
%%ASF Jens Schwarzbach
load(logName) %LOADS ExpInfo

%REPLACE MISSING RESPONSES WITH 0, AND RECODE IF REQUESTED
for i = 1:length(ExpInfo.TrialInfo)
    if isempty(ExpInfo.TrialInfo(i).Response.key)
        ExpInfo.TrialInfo(i).Response.key = 0;
    else
        if recodeKeys
            switch ExpInfo.TrialInfo(i).Response.key
                case 1
                    ExpInfo.TrialInfo(i).Response.key = 3;
                case 3
                    ExpInfo.TrialInfo(i).Response.key = 1;
            end
        end
    end
end

%EXTRACT DATA FROM LOGFILE
%ROW -> trial
%COL 1: CODE
%COL 2: RT
%COL 3: KEY
%COL 4: CORRECTRESPONSE
res = ASF_readExpInfo(ExpInfo);

%CONFUSION MATRIX
isNew = 1; %LEFT MOUSE "NEW"
isOld = 3; %RIGHT MOUSE "OLD"
givenResponse = 3; %COLUMN IN MATRIX RES
requestedResponse = 4; %COLUMN IN MATRIX RES

%FIND INDICES OF "OLD" AND OF "NEW" TRIALS
casesPresentOld = find(res(:, requestedResponse) == isOld);
casesPresentNew = find(res(:, requestedResponse) == isNew);

%HIT
nHits = sum(res(casesPresentOld, givenResponse) ==  isOld);

%MISS
nMiss = sum(res(casesPresentOld, givenResponse) ==  isNew);

%CORRECT REJECTION
nCorrectRejections = sum(res(casesPresentNew, givenResponse) ==  isNew);

%FALSE ALARMS
nFalseAlarms = sum(res(casesPresentNew, givenResponse) ==  isOld);

%SIGNAL DETECTION ANALYSIS
[dprime, criterion] = ASF_calcdprime(nHits, nMiss, nCorrectRejections, nFalseAlarms);
