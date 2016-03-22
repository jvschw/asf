function groupStats
%function groupStats

d = dir('SUB_*.mat');
nSubjects = length(d);

nRows = floor(sqrt(nSubjects));
nCols = ceil(nSubjects/nRows);
figure
for iSubject = 1:nSubjects
    subplot(nRows, nCols, iSubject)
    [M(iSubject, :, :), S(iSubject, :, :)] = calcDescriptiveSubject(d(iSubject).name);
    title(d(iSubject).name, 'INTERPRETER', 'NONE')
    if iSubject > 1
        legend off
    end
end

groupMean = squeeze(mean(M, 1));
groupStd =  squeeze(std(M, 1, 1));
groupSe = groupStd/sqrt(nSubjects);

nCongruenceLevels = size(M, 2);
nSOALevels = size(M, 2);
figure
errorbar(groupMean, groupSe)
legend({'SOA 33ms', 'SOA 66ms', 'SOA 100ms'} )
set(gca, 'xtick', 1:3, 'xticklabel', {'CON', 'NEU', 'INC'})
xlabel('CONGRUENCE')
ylabel('mean RT [ms]')

%EXPORT TO SPSS
exportName = 'MaskedPrimingGroup.dat';
fprintf(1, 'Writing data for SPSS to %s ...', exportName);
fid = fopen(exportName, 'w');

%CREATE VARIABLE NAMES FOR HEADER
congruenceStr ={'CON', 'NEU', 'INC'};
soaStr = {'SOA2', 'SOA4', 'SOA6'}; 
counter = 0;
for iCongruence = 1:nCongruenceLevels
    for iSOA = 1:nSOALevels
        counter = counter + 1;
        vname{counter} = ['"', congruenceStr{iCongruence}, soaStr{iSOA}, '"'];
    end
end
%WRITE VARIABLE NAMES AS HEADER
for i = 1:counter
    fprintf(fid, '%s', vname{i});
    if i < counter
        fprintf(fid, ' '); %AVOID SPACE AFTER LAST VARIABLE
    end
end
fprintf(fid, '\n');

%NOW WRITE DATA IN THE SAME ORDER AS VARIABLE NAMES, ONE LINE PER SUBJECT
for iSubject = 1:nSubjects
    for iCongruence = 1:nCongruenceLevels
        for iSOA = 1:nSOALevels
            fprintf(fid, '%9.2f ', M(iSubject, iCongruence, iSOA));
        end
    end
    fprintf(fid, '\n');
end
fclose(fid);
fprintf(1, 'DONE.\n')
