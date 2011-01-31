function ASF_timingDiagnosis(ExpInfo)
%function ASF_timingDiagnosis(ExpInfo)
%ANALYZES FOR EACH TRIAL AND PAGE BY HOW MUCH THE DURATION OF A GIVEN PAGE
%DIFFERED FROM WHAT THE EXPERIMENTER HAD REQUESTED IN THE TRD FILE.
%THIS DEVIATION IS NOT COMPUTED FOR THE LAST PAGE IN A GIVEN TRIAL SINCE
%ITS DURATION DEPENDS ON THE ONSET TIME OF THE FIRST PAGE IN THE NEXT TRIAL.
%ALWAYS LET EACH TRIAL END WITH A DUMMY PAGE (BLANK SCREEN WITH A DURATION
%OF 1 FRAME) IF YOU ARE INTERESTED IN THE TIMING OF ALL PAGES IN A TRIAL.
%
%20110123   jens.schwarzbach@unitn.it
Cfg.criticalDeviation = 8;
Cfg.plottrial = 0; %ADDITIONAL DEBUGGING FEATURE WHICH SHOWS TIMING TRIAL BY TRIAL
Cfg.printTrial = 1; %TRIAL BY TRIAL DUMP OF TIMING INFO
nTrials = length(ExpInfo.TrialInfo);

%MAKE SURE OLDER DATA FILES CAN STILL BE CHECKED
if isfield(ExpInfo.Cfg, 'Screen')
    if not(isfield(ExpInfo.Cfg.Screen, 'monitorFlipInterval'))
        ExpInfo.Cfg.Screen.monitorFlipInterval = ExpInfo.Cfg.MonitorFlipInterval;
    end
else
    ExpInfo.Cfg.Screen.monitorFlipInterval = ExpInfo.Cfg.MonitorFlipInterval;
end


if Cfg.plottrial
    figure
end
for iTrial = 1:nTrials
    ti = ExpInfo.TrialInfo(iTrial).timing;
    %TI CONTAINS THE LOGGED TIMING-INFO OF A GIVEN TRIAL. IT HAS AS MANY 
    %ROWS AS THE TRIAL HAD PAGES.
    %IT ALWAYS HAS 6 COLUMNS
    %COL 1: requested page duration [frames]
    %COL 2: VBLTimestamp (high-precision estimate of the system time [s]
    %       when the actual flip has happened)
    %COL 3: StimulusOnsetTime (estimate of Stimulus-onset time)
    %COL 4: FlipTimestamp (timestamp taken at the end of Flip's execution)
    %COL 5: Missed (indicates if the requested presentation deadline for
    %       stimulus has been missed. Negative value means that deadlines
    %       have been satisfied. Positive values indicate a deadline-miss)
    %COL 6: Beampos (position of the monitor scanning beam when the time
    %       measurement was taken)
    
    if size(ti, 1) > 1
        thisTrial.nFramesRequested = ti(:, 1);
        thisTrial.VBLTimestamp = ti(:, 2);
        thisTrial.StimulusOnsetTime = ti(:, 3);
        thisTrial.FlipTimestamp = ti(:, 4);
        thisTrial.Missed = ti(:, 5);
        thisTrial.Beampos = ti(:, 6);
    
        %THIS CODE ANALYSES BY HOW MUCH PAGE DURATION DIFFERS FROM WHAT THE
        %EXPERIMENTER REQUESTED. THIS IS ONLY DONE FOR PAGES 1 TO nPages-1,
        %BECAUSE THE DURATION OF THE LAST PAGE IS DETERMINED BY THE ONSET OF
        %THE FIRST PAGE OF THE SUBSEQUENT TRIAL.
        
        %THIS REFERS TO NOMINAL FRAMERATE
        %perf = diff(ti(:, 2))*ExpInfo.Cfg.FrameRate;
        %THIS REFERS TO ACTUAL FRAMERATE
        pageDurationPerformed_ms =...
            diff(thisTrial.FlipTimestamp-thisTrial.FlipTimestamp(1)) *1000;
        pageDurationRequested_ms =...
            thisTrial.nFramesRequested(1:end-1)*ExpInfo.Cfg.Screen.monitorFlipInterval*1000;
        
        %THIS IS EITHER A BUG IN LOGGING OR IN THE EXPERIMENT, CHECK IT!
        %pageDurationPerformed_ms(end) = pageDurationPerformed_ms(end) + pageDurationRequested_ms(end-1); %DON'T KNOW WHY, LOGGING SEEMS TO FORGET THE STIMULUS DURATION
        
        deltams = pageDurationPerformed_ms - pageDurationRequested_ms;
        
        
        deltamat(iTrial, 1:length(deltams)) = deltams(:)';
        x = [pageDurationRequested_ms(:), pageDurationPerformed_ms(:), pageDurationPerformed_ms(:) - pageDurationRequested_ms(:), deltams];
        
        if Cfg.printTrial
            %fprintf(1, 'TRIAL %4d\n', iTrial)
            pageNumbers = ExpInfo.TrialInfo(iTrial).trial.pageNumber(1:end-1);
            pageDurations = ExpInfo.TrialInfo(iTrial).trial.pageDuration(1:end-1);
            nPages = length(pageNumbers);
            
            deviation_ms = pageDurationPerformed_ms-pageDurationRequested_ms;
            if (iTrial == 1)
                fprintf(1, '%5s\t%5s\t%5s\t%6s\t%8s\t%8s\t%8s\t%8s\n',...
                    'trial', 'page', 'stim', 'req[f]', 'req[ms]', 'perf[ms]', 'diff[ms]', 'eval');
            end
            for iPage = 1:nPages
                if abs(deviation_ms(iPage)) > Cfg.criticalDeviation
                    pageEval = 'ERR';
                else
                    pageEval = 'OK';
                end
                fprintf(1, '%5d\t%5d\t%5d\t%6d\t%8.3f\t%8.3f\t%8.3f\t%8s\n',...
                    iTrial, iPage, pageNumbers(iPage), pageDurations(iPage),...
                    pageDurationRequested_ms(iPage),...
                    pageDurationPerformed_ms(iPage), deviation_ms(iPage),...
                    pageEval);
            end
        end
        if Cfg.plottrial
            %PLOT
            set(gcf, 'Name', sprintf('Trial %04d', iTrial))
            subplot(1,2,1)
            bar(x(:, 1:3))
            title('Timing of Pages')
            xlabel('Page')
            ylabel('Frames')
            legend('requested', 'performed', 'deviation')
            subplot(1,2,2)
            plot(x(:, 4), 'LineWidth', 2)
            xlabel('Page')
            ylabel('ms')
            if max(deltams) < 5
                set(gca, 'ylim', [-5 5])
            end
            title('Timing of Pages: Deviation in ms')
            set(gcf, 'name', 'Press any key to advance to next trial')
            
            pause
        end
    end
    
end


figure
%mysurf(deltamat)
mybar3(deltamat)


function mysurf(deltamat)
if size(deltamat, 2) > 1
    surf(deltamat)
    shading interp
    xlabel('Page Number')
    ylabel('Trial Number')
    zlabel('Deviation [ms]')
    title('Timing Accuracy of Experiment')
    %set(gca, 'zlim', [-20 20])
    %set(gca, 'xtick', 1:size(deltamat, 2))
else
    bar(deltamat)
    xlabel('Trial Number')
    ylabel('Deviation [ms]')
    title('Timing Accuracy of Experiment')
end


function mybar3(tmpr)

Z = tmpr;
[nRows, nCols] = size(tmpr); %ROWS ARE TRIALS, cols are pages
h = bar3(Z); %nPages barseries, each series one color
for i = 1:nCols
    zdata = ones(6*nRows,4);
    k = 1;
    for j = 0:6:(6*nRows-6) %6surfaces; j might be the starting index
        zdata(j+1:j+6,:) = Z(k,i);
        k = k+1;
    end
    set(h(i),'Cdata',zdata)
end
colormap cool
colorbar


shading interp
for i = 1:length(h)
    zdata = get(h(i),'Zdata');
    set(h(i),'Cdata',zdata)
    set(h,'EdgeColor','k')
end

xlabel('Page Number')
ylabel('Trial Number')
zlabel('Deviation [ms]')
title('Timing Accuracy of Experiment')
