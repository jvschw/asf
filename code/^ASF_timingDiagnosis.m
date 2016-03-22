function ASF_timingDiagnosis(ExpInfo)
nTrials = length(ExpInfo.TrialInfo);
Cfg.plottrial = 0;


%MAKE SURE OLDER DATA FILES CAN STILL BE CHECKED
if isfield(ExpInfo.Cfg, 'Screen')
    if not(isfield(ExpInfo.Cfg.Screen, 'monitorFlipInterval'))
        ExpInfo.Cfg.Screen.monitorFlipInterval  = ExpInfo.Cfg.MonitorFlipInterval;
    end
else
    ExpInfo.Cfg.Screen.monitorFlipInterval  = ExpInfo.Cfg.MonitorFlipInterval;
end



if Cfg.plottrial
    figure
end
for i = 1:nTrials

    %WAS
    %ti = ExpInfo.TrialInfo(i).timing(1:end-1, :);
    %req = ti(1:end-1, 1);
    ti = ExpInfo.TrialInfo(i).timing;
    if size(ti, 1) > 1
        req = ti(1:end-1, 1);

        %THIS REFERS TO NOMINAL FRAMERATE
        %perf = diff(ti(:, 2))*ExpInfo.Cfg.FrameRate;
        %THIS REFERS TO ACTUAL FRAMERATE
        pageDurationPerformed_ms = diff(ti(:, 2)-ti(1, 2)) *1000;
        pageDurationRequested_ms = ti(1:end-1, 1)*ExpInfo.Cfg.Screen.monitorFlipInterval*1000;

        %THIS IS EITHER A BUG IN LOGGING OR IN THE EXPERIMENT, CHECK IT!
        %pageDurationPerformed_ms(end) = pageDurationPerformed_ms(end) + pageDurationRequested_ms(end-1); %DON'T KNOW WHY, LOGGING SEEMS TO FORGET THE STIMULUS DURATION

        deltams = pageDurationPerformed_ms - pageDurationRequested_ms;


        deltamat(i, 1:length(deltams)) = deltams(:)';
        x = [pageDurationRequested_ms(:), pageDurationPerformed_ms(:), pageDurationPerformed_ms(:) - pageDurationRequested_ms(:), deltams];

        if Cfg.plottrial
            %PLOT
            set(gcf, 'Name', sprintf('Trial %04d', i))
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

            pause
        end
    end

end


figure
if size(deltamat, 2) > 1
surf(deltamat)
%mybar3(deltamat)
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
bh = bar3(tmpr');
Z = tmpr';
view(-145, 34)
%     set(gca, 'CameraPosition', [-12, -58,  3])
xlabel('x')
ylabel('y')
%set(gca, 'ytick', 1:nRows, 'yticklabel', 1:Rows )
%set(gca, 'xtick', 1:5, 'xticklabel', (5:-1:1)-3 )

%SHADED COLORS
for i2 = 1:length(bh)
    zdata = ones(6*length(bh),4);
    k2 = 1;
    for j2 = 0:6:(6*length(bh)-6)
        zdata(j2+1:j2+6,:) = Z(k2,i2);
        k2 = k2+1;
    end
    set(bh(i2),'Cdata',zdata)
end

%colorbar

shading interp
for i2 = 1:length(bh)
    zdata = get(bh(i2),'Zdata');
    set(bh(i2),'Cdata',zdata)
    set(bh,'EdgeColor','k')
end