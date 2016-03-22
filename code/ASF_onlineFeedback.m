function ASFonlineFeedback(ExpInfo, trial, TrialInfo, iCurrentTrial)

persistent hFigFeedback codes nConditions cases nTrials

if isempty(hFigFeedback)

    %VECTOR THAT CONTAINS TRIAL BY TRIAL THE CODE NUMBER
    trialcodes = [trial.code];
    nTrials = length(trialcodes);
    %VECTOR OR MATRIX THAT CONTAINS TRIAL BY TRIAL THE FACTORIAL
    %COMBINATION
    factorialCombination = ASF_decode(trialcodes, ExpInfo.factorinfo);
    
    %VECTOR THAT CONTAINS THE CODE NUMBERS FOR REALIZED CONDITIONS
    codevec = unique(trialcodes);
    nConditions = prod(ExpInfo.factorinfo);
    
    for i = 1:nConditions
        %FIND TRIAL NUMBERS THAT BELONG TO CERTAIN CONDITIONS
        cases{i} = find(trialcodes == codevec(i));
    end

    %IF IT DOES NOT YET EXIST: CREATE FIGURE
    hFigFeedback = figure;

else
    %OTHERWISE: BRING FEEDBACK WINDOW TO THE FOREGROUND
    figure(hFigFeedback)
end
if iCurrentTrial == 0
    return
end

%DATA ANALYSIS
for iCondition = 1:nConditions
    tmpCases = cases{iCondition};
    tmpSelected = find(tmpCases <= iCurrentTrial);
    n = length(tmpSelected);

    tmprt = zeros(1, n);
    for j = 1:n
        tmprt(j) = TrialInfo(tmpCases(tmpSelected(j))).Response.RT;
        tmpcor(j) = TrialInfo(tmpCases(tmpSelected(j))).Response.key == TrialInfo(tmpCases(tmpSelected(j))).trial.correctResponse;
    end
    matrt{iCondition} = tmprt;
    %tmprt = [TrialInfo(tmpCases(tmpSelected)).Response.RT];
    m(iCondition) = nanmean(tmprt);
    s(iCondition) = nanstd(tmprt)/sqrt(n);
    pc(iCondition) = nanmean(tmpcor);
    pcs(iCondition) = nanstd(tmpcor)/sqrt(n);
    
end

subplot(3,1,1)
hold on
plot(iCurrentTrial, TrialInfo(iCurrentTrial).Response.RT, '-+')
hold off
xlabel('Trial Number')
ylabel('RT [ms]')
set(gca, 'xlim', [0, nTrials+1])
drawnow

subplot(3,2,3)
bar(1:nConditions, m)
hold on
ebh = errorbar(1:nConditions, m, s);
hold off
kids = get(ebh, 'Children');
set(kids(1), 'LineStyle', 'none')
set(kids(2), 'Color', 'r')
set(gca, 'xlim', [0, nConditions + 1], 'xtick', 1:nConditions)
xlabel('Condition')
ylabel('Mean RT [ms]')
drawnow

subplot(3,2,4)
bar(1:nConditions, pc*100)
hold on
ebh = errorbar(1:nConditions, pc*100, pcs*100);
hold off
kids = get(ebh, 'Children');
set(kids(1), 'LineStyle', 'none')
set(kids(2), 'Color', 'r')
set(gca, 'xlim', [0, nConditions + 1], 'xtick', 1:nConditions)
xlabel('Condition')
ylabel('PercentCorrect')
drawnow
if iCurrentTrial == nTrials
    h = []; p=[]; ci = [];
    for i = 1:nConditions
        for j = 1:nConditions
            if i==j
                h(i, j) = NaN;
                p(i, j) = NaN;
                ci(i, j).ci = NaN;
            else
                [h(i, j), p(i, j), ci(i, j).ci] = ttest(matrt{i}, matrt{j});
            end
        end
    end
    subplot(3,1,3)
    imagesc(1-p)
    set(gca, 'clim', [0.95, 1]);
    colorbar('location', 'EastOutside')
    set(gca, 'xtick', 1:nConditions, 'ytick', 1:nConditions)
    xlabel('Condition')
    ylabel('Condition')
    title('Pairwise Comparisons for RT [1-p]')
    drawnow

    h
    p
    ci
end
return