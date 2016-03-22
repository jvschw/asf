function ASF_checkTrials(fname_std, fname_trd, Cfg, varargin)
%function ASF_checkTrials(fname_stim, stmFileName, Cfg, varargin)
%EXAMPLE CALL:
%ASF_checkTrials('C:\Program Files\MATLAB71\work\myRTS\stimuli\large_1024_768\stimdef.txt', 'masked priming_JS_onefinger_05.stm')
if ~isfield(Cfg, 'userDefinedSTMcolumns'), Cfg.userDefinedSTMcolumns = 0; else end;
if ~isfield(Cfg, 'randomizeTrials'), Cfg.randomizeTrials = 0; else end;

%READ NAMES OF BITMAP FILES
stimnames  = importdata(fname_std);
expinfo.stimnames = stimnames;
if exist(expinfo.stimnames{1}) ~= 2
    fprintf(1, 'Program aborted!\n')
    return
end


%[trial, expinfo.factorinfo] = read_trialdefs(stmFileName);
[trial, expinfo.factorinfo, errorflag, factorNames] = ASF_readTrialDefs(fname_trd, Cfg);

if ~isempty(varargin)
    selectedTrials = varargin{1};
    bSelectSubset = 1;
else
    bSelectSubset = 0;
    selectedTrials = 1:length(trial);
end

if bSelectSubset
    trial = trial(selectedTrials);
end


%{trial(:).pageNumber}
figure
nImages = size(expinfo.stimnames, 1);
nTrials = size(trial, 2);
for i = 1:nImages
    [X{i},MAP{i}] = imread(expinfo.stimnames{i}, 'bmp');
end

for i = 1:nTrials
    nPages(i) = length(trial(i).pageNumber);
end
nRows = ceil(sqrt(max(nPages)));
nCols = ceil(max(nPages)/nRows);

for i = 1:nTrials
    subplot(1,1,1)
    this_trial = trial(i);
    for p = 1:nPages(i)
        subplot(nRows, nCols, p)
        tmpI = X{this_trial.pageNumber(p)};
        image(tmpI(193:576, 256:768, :))
        colormap(MAP{p})
        set(gca, 'xtick', [], 'ytick', [])
        axis image
        th(p) = title(sprintf('img: %d, dur: %d', this_trial.pageNumber(p), this_trial.pageDuration(p)));
    end
    set(th(this_trial.startRTonPage), 'Color', 'r')
    
    faclevelstr = '';
    if isempty(expinfo.factorinfo)
        %NOP
    else
        tmpCode = ASF_decode(this_trial.code, expinfo.factorinfo);
        for j = 1:length(tmpCode)
            faclevelstr = horzcat(faclevelstr, sprintf('%s %d ', factorNames{j}, tmpCode(j)));
        end
        %faclevelstr = num2str(ASF_decode(this_trial.code, expinfo.factorinfo));
    end
    set(gcf, 'name', sprintf('TRIAL %d/%d(%d), code: %d, fac: %s', i, nTrials, selectedTrials(i), this_trial.code, faclevelstr))
    pause
end
