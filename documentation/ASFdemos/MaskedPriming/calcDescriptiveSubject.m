function [M, S] = calcDescriptiveSubject(fName)
%function [M, S] = calcDescriptiveSubject(fName)
%CALCULATE DESCIPTIVE STATISTICS FOR  A GIVEN SUBJECT.
%RETURNS MATRIX M WITH DIMENSION  [nSOA, nCONGRUENCE]
%
%%EXAMPLE CALL:
%[M, S] = calcDescriptiveSubject('SUB_06.mat')
fprintf(1, 'PROCESSING %s ...', fName)
load(fName) %WILL MAKE TE VARIABE ExpInfo AVAILABLE TO THIS FUNCTION

log = ASF_readExpInfo(ExpInfo);%provides you with a matrix log which contains trial by trial (rows) information needed for data analysis (columns)
%Log contains:  COL1: CODE, COL2: RT, COL3: CORRECTRESPONSE, COL4: ACTUALRESPONSE

evaluation = ( log(:, 3) == log(:, 4) ); %1 for correct, 0 for incorrect responses

codes = ASF_decode(log(:, 1), ExpInfo.factorinfo);
% COL 1: PRIMEDIRECTION (0 left, 1 neutral, 2 right)
% COL 2: SOA (stimulus onset asynchrony between prime and mask; 0 short, 1 intermediate, 2 long)
% COL 3: MASKDIRECTION (0, left, 1, right)


%COMPUTE CONGRUENCE
casesCongruent = find(...
    (codes(:, 1) == 0) &(codes(:, 3) == 0) |...
    (codes(:, 1) == 2) &(codes(:, 3)== 1));
 
casesNeutral = find(codes(:, 1) == 1);
 
casesIncongruent = find(...
    (codes(:, 1) == 0) &(codes(:, 3) == 1) |...
    (codes(:, 1) == 2) &(codes(:, 3)== 0));
 
congruence(casesCongruent) = 1;
congruence(casesNeutral) = 2;
congruence(casesIncongruent) = 3;

%LETS DO THE STATS
congruenceLevels = unique(congruence);
nCongruenceLevels = length(congruenceLevels);

SOALevels = unique(codes(:, 2));
nSOALevels = length(SOALevels);

if (nCongruenceLevels  ~=  3)||(nSOALevels ~=  3)
    msg = sprintf('THERE IS A PROBLEM WITH %s (nSOALevels = %d, nCongruenceLevels = %d)',...
        fName, nCongruenceLevels, nSOALevels);
    error('STOP', msg)
end
%FIND MATCHING CASES, CONDITION BY CONDITION AND CALCULATE DESCRIPTIVE
%STATS
%PUT RESULTS IN APPROPRIATE MATRIX
for iSOA = 1:nSOALevels
    for iCongruence = 1:nCongruenceLevels
        %FIND MATCHING CASES
        cases = find(...
            (evaluation == 1)&...
            (codes(:, 2) == SOALevels(iSOA))&...
            (congruence(:) == congruenceLevels(iCongruence)));
        
%         %CALCULATE MEAN AND PUT IT INTO MATRIX M
%         M(iSOA, iCongruence) = mean(log(cases, 2)); %#ok<FNDSB>
%         S(iSOA, iCongruence) = std(log(cases, 2)); %#ok<FNDSB>
        
        %BUT IF MY PARTICIPANT DID NOT PRESS A BUTTON, THERE WILL BE A NaN
        %THIS REQUIRES SLIGHTLY DIFFERENT FUNCTION CALLS
        M(iCongruence, iSOA) = nanmean(log(cases, 2)); %#ok<FNDSB>
        S(iCongruence, iSOA) = nanstd(log(cases, 2)); %#ok<FNDSB>
        
    end
end

%plot(M')
errorbar(M, S)
legend({'SOA 33ms', 'SOA 66ms', 'SOA 100ms'} )
set(gca, 'xtick', 1:3, 'xticklabel', {'CON', 'NEU', 'INC'})
xlabel('CONGRUENCE')
ylabel('RT [ms]')

fprintf(1, 'DONE\n');
