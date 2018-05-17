function analyze_animals_dm(resultID)
%function analyze_animals_dm(resultID)
%example
%analyze_animals_dm('test3')

%load ExpInfo into workspace
load(resultID)
figure
ASF_timingDiagnosis(ExpInfo)

%extracts results trialwise from ExpInfo 
res = ASF_readExpInfo(ExpInfo);


levels = unique(res(:, 1));
nLevels = numel(levels);

for i = 1:nLevels
    cases = find(res(:, 1) == levels(i));
    m(i) = mean(res(cases, 2));
    s(i) = std(res(cases, 2), 1);
end

figure
errorbar(1:nLevels, m, s)
set(gca, 'ylim', [min(m)-2*max(s), max(m)+2*max(s)],...
    'xlim', [0.5, nLevels+0.5],...
    'xtick', 1:nLevels, 'xticklabel', ExpInfo.factorinfo.levelNames);
box off
xlabel('category')
ylabel({'rt [ms]', ''})
