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
global editX

if(~isfield(Cfg, 'thresh')), Cfg.thresh = 0.2; end
if(~isfield(Cfg, 'fnames')), Cfg.fnames = '*.wav'; end
if(~isfield(Cfg, 'verbose')), Cfg.verbose = 0; end
if(~isfield(Cfg, 'ShowRTAnalysis')), Cfg.ShowRTAnalysis = 1; end
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
    [y, fs, nbits, opts] = wavread(fullfile(dataDir, fname));
    
    %TREATMENT FOR STEREODATA: AVERAGE CHANNELS
    if opts.fmt.nChannels == 2
        y = mean(y, 2);
    end
    t = (0:length(y)-1)/fs;
    
    %REMOVE BEGINNING PERIOD
    cases_to_remove = find(t < 0.15);
    y(cases_to_remove) = [];
    t(cases_to_remove) = [];
    
    %     if Cfg.ShowRTAnalysis
    %         figure
    %         plot_wav(t, y)
    %         set(gcf, 'Name', 'Original Signal')
    %     end
    
    %     yorg = y;
    %     figure
    %     subplot(2,1,1)
    %     [spec_s, spec_f, spec_t, spec_p]= spectrogram(yorg, 512, [], [], fs/1000 , 'yaxis')
    %     subplot(2,1,2)
    %     plot(t, yorg)
    
    %NORMALIZE
    y = y - mean(y);
    if max(abs(y) > Cfg.thresh)
        y = y - min(y);
        y = y./max(y)*2-1;
        %     if Cfg.ShowRTAnalysis
        %         figure
        %         plot_wav(t, y)
        %         set(gcf, 'Name', 'Normalized Signal')
        %     end
        
        ey = sqrt(y.^2);
        bl = mean(ey(1:max(find((t-t(1))<0.3)))); %300ms BASELINE
        
        
        
        %FILTER OUT LIP-CLICKS
        Cfg.FilterLengthInSamples = 500;
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
        samplesAboveThresh = find(eyf-bl > current_thresh);
        first_sample = samplesAboveThresh(min(find(t(samplesAboveThresh) > 0.4)));%RT MUST BE LONGER THAN 400ms
        %first_sample = min(find(eyf-bl > current_thresh));
        if isempty(first_sample)
            rt(i) = NaN;
        else
            rt(i) = t(first_sample);
        end
%         if rt(i) > 1.75
%             rt(i) = NaN;
%         end
        if isnan(rt(i))
            rt(i) = 0.75;
            fprintf(1, 'ARBITRARY RT\n');
        end
        previouslySuggestedRT = Cfg.ExpInfo.TrialInfo(i).Response.RT;
        rt(i) = plotAndEdit(fig, fname, rt(i), previouslySuggestedRT, t, eyf, bl, current_thresh, y, fs);
        %         figure(fig)
        %         set(fig, 'name', sprintf('FILE: %s, RT = %5.3f', fname, rt(i)))
        %         subplot(2,1,1)
        %         plot_wav(t, eyf);
        %         ylabel('sqrt(y^2)')
        %         hold on
        %         tbl = t(find(t<0.3));%BASELINE PERIOD
        %         plot([tbl(1), tbl(end)], [bl, bl], 'Color', [.6 .6 .6], 'LineWidth', 3)
        %         plot([t(1), t(end)], [bl+current_thresh, bl+current_thresh], ':', 'Color', [.6 .6 .6], 'LineWidth', 3)
        %         aH = gca;
        %         ylim = get(gca, 'ylim');
        %         phVOT = plot([rt(i), rt(i)], ylim, 'r', 'LineWidth', 3);
        %         hold off
        %         subplot(2,1,2)
        %         plot_wav(t, y);
        %         hold on
        %         ylim = get(gca, 'ylim');
        %         plot([rt(i), rt(i)], ylim, 'r', 'LineWidth', 3)
        %         hold off
        %
        %         function startDragFcn(varargin)
        %         set(fig, 'WindowButtonMotionFcn', @draggingFcn)
        %         end
        %
        %         function draggingFcn(varargin)
        %         pt = get(aH, 'CurrentPoint');
        %         set(phVOT, 'XData', pt(1)*[1 1]);
        %         end
        %
        %         function stopDragFcn(varargin)
        %         set(fig, 'WindowButtonMotionFcn', '');
        %         end
        
        %         pbh1 = uicontrol(gcf,'Style','pushbutton','String','Play',...
        %             'Units','normalized',...
        %             'Position',[.0 0 .2 .075]);
        %         pbh2 = uicontrol(gcf,'Style','pushbutton','String','Edit',...
        %             'Units','normalized',...
        %             'Position',[.2 0 .2 .075]);
        %         pbh3 = uicontrol(gcf,'Style','pushbutton','String','OK',...
        %             'Units','normalized',...
        %             'Position',[.8 0 .2 .075]);
        %         set(phVOT, 'ButtonDownFcn', @startDragFunction)
        %         set(gcf, 'WindowButtonUpFcn', @stopDragFunction)
        
        drawnow
        %keyboard
        %         wavplay(y(first_sample:end), fs)
        %         pause
        if Cfg.playWav
            wavplay(y(first_sample:end), fs)
            % wavplay(filtfilt(ones(1,10), 10, y), fs)
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


function  newRT = plotAndEdit(fig, fname, thisRT, previouslySuggestedRT, t, eyf, bl, current_thresh, y, fs)
global editX glob_t glob_y glob_fs

glob_y = y;
glob_fs = fs;
glob_t = t;
figure(fig)
set(fig, 'name', sprintf('FILE: %s, RT = %5.3f', fname, thisRT))
subplot(2,1,1)
plot_wav(t, eyf);
ylabel('sqrt(y^2)')
hold on
tbl = t(find(t<0.3));%BASELINE PERIOD
plot([tbl(1), tbl(end)], [bl, bl], 'Color', [.6 .6 .6], 'LineWidth', 3)
plot([t(1), t(end)], [bl+current_thresh, bl+current_thresh], ':', 'Color', [.6 .6 .6], 'LineWidth', 3)
aH = gca;
ylim = get(gca, 'ylim');
phprevSug = plot([previouslySuggestedRT, previouslySuggestedRT], ylim, 'y', 'LineWidth', 6);

phVOT = plot([thisRT, thisRT], ylim, 'r', 'LineWidth', 3);
hold off
subplot(2,1,2)
plot_wav(t, y);
hold on
ylim = get(gca, 'ylim');
editX = thisRT;
plot([thisRT, thisRT], ylim, 'r', 'LineWidth', 3, 'ButtonDownFcn', @startDragFcn, 'tag', 'myVOTline')
hold off
set(gcf, 'WindowButtonUpFcn', @stopDragFcn);
idxStart = min(find(t>thisRT));
drawnow
wavplay(y(idxStart:end), fs)

waitfor(gcf)
editX
newRT = editX;

function startDragFcn(varargin)
set(gcf, 'WindowButtonMotionFcn', @draggingFcn)

function draggingFcn(varargin)
global editX
pt = get(gca, 'CurrentPoint');
hMyline = findobj('tag', 'myVOTline');
set(hMyline, 'XData', pt(1)*[1 1]);
editX = pt(1);


function stopDragFcn(varargin)
global editX glob_t glob_y glob_fs
set(gcf, 'WindowButtonMotionFcn', '');
idxStart = min(find(glob_t > editX));
wavplay(glob_y(idxStart:end), glob_fs)
