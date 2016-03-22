%VISUAL INSPECTION
trialNo = 3;

thisTrial = trialInfo(trialNo);

%WE RETRIEVE TIMING INFO FROM THE SAMPLES' TIMESTAMPS
t0 = thisTrial.samples(1, 1);
t = thisTrial.samples(:, 1) - t0;

%ASSIGN THE SAMPLES TO A VARIABLE xy
xy = thisTrial.samples(:, 2:3);

%PLOT TRIAL (FIGURE 1, and FIGURE 2 PANEL A)
figure
subplot(2, 2, 1)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from trial-onset [ms]')
ylabel('Gaze Position [pixels]')


%MARKING EXPERIMENTAL EVENTS, AND WE MAKE THE ONSET OF THE MASK t0
pagePrime = 2;
pageMask = 4;

t0 = thisTrial.pageOnset(pageMask);
tMask = thisTrial.pageOnset(pageMask) - t0; %SHOULD BE 0
tPrime = thisTrial.pageOnset(pagePrime) - t0;
t = thisTrial.samples(:, 1) - t0;


%PLOT TRIAL
subplot(2, 2, 2)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from mask-onset [ms]')
ylabel('Gaze Position [pixels]')
yLim = get(gca, 'ylim');

hold on
%MARK PRIME AND MASK
plot([tPrime, tPrime], yLim, ':r')
plot([tMask, tMask], yLim, ':g')
hold off


%IDENTIFY SACCADIC ONSETS
%PLOT TRIAL
subplot(2, 2, 3)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from mask-onset [ms]')
ylabel('Gaze Position [pixels]')
yLim = get(gca, 'ylim');

hold on
nSaccades = length(thisTrial.sacEvents);
sacStart = zeros(1, nSaccades);
hold on
for i = 1:nSaccades
    sacStart(i) = thisTrial.sacEvents(i).sacStart - t0;
    plot([sacStart(i), sacStart(i)], yLim, 'color', [.5, .5, .5]);
end
hold off

%SACCADIC REACTION TIME IS THE TIME BETWEEN ONSET OF THE MASK AND ONSET OF
%THE FIRST SUBSEQUENT SACCADE
idxFirstValidSaccade = find(sacStart > 0, 1 );

srt = sacStart(idxFirstValidSaccade);

subplot(2, 2, 4)
plot(t, xy, 'LineWidth', 2);
legend('x', 'y')
box off
xlabel('Time from mask-onset [ms]')
ylabel('Gaze Position [pixels]')
yLim = get(gca, 'ylim');

arrow([srt, yLim(2)], [srt, yLim(1)])



