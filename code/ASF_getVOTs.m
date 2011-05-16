function rt = ASF_getVOTs(Cfg)
%%function rt = ASF_getVOTs(Cfg)
%%CALCULATES VOICE ONSET TIMES FOR TRIALS THAT USE ASF's VOICEKEY
%FUNCTIONALITY
%
%%jens.schwarzbach@unitn.it 20110512
%
%%EXMPLE CALL:
%Cfg.thresh = 0.2;
%Cfg.fnames = '*.wav';
%Cfg.verbose = 0;
%Cfg.ShowRTAnalysis = 0;
%Cfg.playWav = 0;
%rt = ASF_getVOTs(Cfg)

if(~isfield(Cfg, 'thresh')), Cfg.thresh = 0.2; end
if(~isfield(Cfg, 'fnames')), Cfg.fnames = '*.wav'; end
if(~isfield(Cfg, 'verbose')), Cfg.verbose = 0; end
if(~isfield(Cfg, 'ShowRTAnalysis')), Cfg.ShowRTAnalysis = 0; end
if(~isfield(Cfg, 'playWav')), Cfg.playWav = 0; end
fig = figure;
dataDir = fileparts(Cfg.fnames);
%Cfg.ShowRTAnalysis = 1;
d = dir(Cfg.fnames);
nFiles = length(d);

if nFiles > 1
    h = waitbar(0,'Please wait...');
    rt(nFiles) = 0;
else
    h = [];
end
for i = 1:nFiles
    if ~isempty(h)
        waitbar(i/nFiles,h)
    end
    fname = d(i).name;
    %    [y, fs, nbits, opts] =   wavread(fname, [22050, 88000]);
    [y, fs, nbits, opts] =   wavread(fullfile(dataDir, fname));
    
    %TREATMENT FOR STEREODATA: AVERAGE CHANNELS
    if size(y, 1) == 2
        y = mean(y);
    end
    t = (0:length(y)-1)/fs;
    
    %REMOVE BEGINNING PERIOD
    cases_to_remove = find(t < 0.15);
    y(:, cases_to_remove) = [];
    t(cases_to_remove) = [];
    
    %     if Cfg.ShowRTAnalysis
    %         figure
    %         plot_wav(t, y)
    %         set(gcf, 'Name', 'Original Signal')
    %     end
    
    %NORMALIZE
    y = y - mean(y);
    if max(abs(y) > 0.2)
        y = y - min(y);
        y = y./max(y)*2-1;
        %     if Cfg.ShowRTAnalysis
        %         figure
        %         plot_wav(t, y)
        %         set(gcf, 'Name', 'Normalized Signal')
        %     end
        
        ey = sqrt(y.^2);
        bl = mean(ey(1:max(find((t-t(1))<0.2))));
        
        
        
        %FILTER OUT LIP-CLICKS
        Cfg.FilterLengthInSamples = 100;
        b = ones(Cfg.FilterLengthInSamples, 1)/Cfg.FilterLengthInSamples;  % Cfg.FilterLengthInSamples point averaging filter
        eyf = filtfilt(b, 1, ey); % Noncausal filtering; smothes data without delay
        
        if Cfg.ShowRTAnalysis
            figure
            plot_wav(t, ey);
            hold on
            plot(t, eyf, 'Color', 'r', 'LineWidth', 3);
            hold off
            set(gcf, 'Name', 'Power')
            ylabel('sqrt(y^2)')
            legend('Power', 'Smoothed Power')
            
        end
        
        current_thresh = Cfg.thresh;
        %     first_sample = [];
        %     %LOOK FOR ONSET, IF NOTHING FOUND DECREASE THRESHOLD
        %     while isempty(first_sample)
        %         first_sample = min(find(eyf-bl >current_thresh));
        %         if isempty(first_sample)
        %             current_thresh = current_thresh*.9;
        %         end
        %
        %     end
        first_sample = min(find(eyf-bl >current_thresh));
        if isempty(first_sample)
            rt(i) = NaN;
        else
            rt(i) = t(first_sample);
        end
        
        figure(fig)
        set(fig, 'name', sprintf('FILE: %s, RT = %5.3f', fname, rt(i)))
        plot_wav(t, eyf);
        ylabel('sqrt(y^2)')
        hold on
        tbl = t(find(t<0.2));
        plot([tbl(1), tbl(end)], [bl, bl], 'Color', [.6 .6 .6], 'LineWidth', 3)
        plot([t(1), t(end)], [bl+current_thresh, bl+current_thresh], ':', 'Color', [.6 .6 .6], 'LineWidth', 3)
        ylim = get(gca, 'ylim');
        plot([rt(i), rt(i)], ylim, 'r', 'LineWidth', 3)
        hold off
        drawnow
        if Cfg.playWav
            wavplay(y, fs)
        end
        
        
        
        if Cfg.ShowRTAnalysis
            figure
            plot_wav(t, eyf)
            set(gcf, 'Name', 'Smoothed Power')
            ylabel('sqrt(y^2)')
            hold on
            tbl = t(find(t<0.2));
            plot([tbl(1), tbl(end)], [bl, bl], 'Color', [.6 .6 .6], 'LineWidth', 3)
            plot([t(1), t(end)], [bl+current_thresh, bl+current_thresh], ':', 'Color', [.6 .6 .6], 'LineWidth', 3)
            ylim = get(gca, 'ylim');
            plot([rt(i), rt(i)], ylim, 'r', 'LineWidth', 3)
            hold off
        end
        
        if Cfg.verbose
            subplot(2,2,1)
            plot(t, [y, ey])
            
            subplot(2,2,2)
            lh = plot(t, [ey, eyf]);
            set(lh(2), 'LineWidth', 2)
            legend('org', 'filt')
            ylim = get(gca, 'ylim');
            hold on
            plot([rt(i), rt(i)], ylim, 'r')
            hold off
            pause
        end
    else
        rt(i) = NaN;
    end
end
if ~isempty(h)
    close(h)
end
if Cfg.verbose
    figure
    plot(rt, 'k.')
    figure
    plot(sort(rt), 'k.')
end

function ph = plot_wav(t, y)
set(gcf, 'DefaultAxesFontSize', 16)
ph = plot(t, y, 'k', 'LineWidth', 2);
xlabel('Time [s]')
ylabel('Signal')
