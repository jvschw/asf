function ASF_soundTestPlot(fname, tReq)
%function ASF_soundTestPlot(fname, tReq)
% ASF_soundTestPlot('audio_del500.csv', 500)
% ASF_soundTestPlot('audio_del600.csv', 600)
% ASF_soundTestPlot('audio_del700.csv', 700)



dat = importdata(fname);

t = dat.data(:, 1)*1000;
ch1 = dat.data(:, 2);
ch2 = dat.data(:, 3);


idxTriggerOn = min(find(ch2 > 0.2))
tTrigger = t(idxTriggerOn)

idxSoundOn = min(find(abs(ch1) > 0.2))
tSoundOn = t(idxSoundOn)

dt = tSoundOn - tReq
ylim = [-2.5, 2.5];
plot([tTrigger, tTrigger], ylim, 'k', 'LineWidth', 3)
hold on
plot([tReq, tReq], ylim, 'k', 'LineWidth', 3)
patch([tReq, tReq, tSoundOn, tSoundOn], [ylim(1), ylim(2), ylim(2), ylim(1)], [.6 .6 .6]) 
ph = plot(t, [ch1, ch2], 'LineWidth', 2);
legend(ph, 'Sound', 'Trigger')
xlabel('Time [ms]')
ylabel('Voltage')
%ylim = get(gca, 'ylim');
plot([tSoundOn, tSoundOn], ylim, 'r', 'LineWidth', 1)

hold off
