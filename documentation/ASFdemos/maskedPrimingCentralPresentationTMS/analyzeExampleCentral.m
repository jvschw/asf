function analyzeExampleCentral(projectName)
%function analyzeExampleCentral(projectName)
%
%%EXAMPLE CALL
%analyzeExampleCentral('exampleCentral')
%
%%ASF (C) Jens Schwarzbach

%LOAD STORED LOG FILE
load( projectName )

%res contains the following information extracted from the log
%COL 1: CODE
%COL 2: RT
%COL 3: KEY
%COL 4: CORRECTRESPONSE
res = ASF_readExpInfo( ExpInfo );

dat.code = ASF_decode(res(:, 1), [2, 2]);
congruenceVec = ExpInfo.factorinfo.levelNames(1,:);
soaVec = ExpInfo.factorinfo.levelNames(2,:);

for iCongruence = 1:2
    for iSoa = 1:2
        %SELECT TRIALS FOR THIS FACTORIAL COMBINATION, IN WHICH
        %THE PARTICIPANT RESPONDED CORRECTLY
        casesCorrect = find(...
            (dat.code(:, 1)+1 == iCongruence) &...
            (dat.code(:, 2)+1 == iSoa) &...
            (res(:, 3) == res(:, 4)) );

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


