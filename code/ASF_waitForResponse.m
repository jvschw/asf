%function [x, y, buttons, t0, t1] = ASF_waitForResponse(Cfg, timeout)
%% ***RESPONSE COLLECTION***
%% WaitForResponse Wrapper
%WRAPPER FUNCTION THAT CHECKS FOR A RESPONSE USING:
%MOUSE
%LUMINA
%CRS RESPONSE BOX - NOT YET IMPLEMENTED
%KEYBOARD 
%20071024 JS FIXED BUG THAT NOT PRESSING A RESPONSE BUTTON COULD LEAD TO PROGRAM STOP
%20081126 JS FIXED BUG THAT RT WAS NOT RECORDED USING THE LUMINA BOX
function [x, y, buttons, t0, t1, extraKey] = ASF_waitForResponse(Cfg, timeout)
if~isfield(Cfg, 'responseType'), Cfg.responseType = 'buttonDown'; else end;
extraKey = NaN;
switch Cfg.responseDevice
    case 'MOUSE'
        switch Cfg.responseType
            case 'buttonDown'
                [x, y, buttons, t0, t1, extraKey] = WaitForMousePress(timeout, Cfg.responseSettings.allowTrialRepeat); %NEW 2nd arg
            otherwise
                error('MOUSE Unknown response type %s', Cfg.responseType);
        end
        
    case 'LUMINAPARALLEL'
        [x, y, buttons, t0, t1] = WaitForLuminaPress(Cfg.Hardware.parallel.mydio_in, timeout);

    case {'LUMINASERIAL', 'ARDUINOSERIAL'}
        x = [];
        y = [];
        switch Cfg.responseType
            case 'buttonDown'
                [buttons, t0, t1] = WaitForSerialBoxPress(Cfg, timeout);
            case 'buttonUp'
                [buttons, t0, t1] = WaitForSerialBoxButtonUp(Cfg, timeout);
            otherwise
                error('LUMINASERIAL Unknown response type %s', Cfg.responseType);
        end

    case 'KEYBOARD'
        x = [];
        y = [];
        [buttons, t0, t1] = WaitForKeyboard(Cfg, timeout);
    
    case 'VOICEKEY'
        x = [];
        y = [];
        [buttons, t0, t1] = WaitForVoiceKey(Cfg, timeout);

    case 'VOICEKEYPPA'
        x = [];
        y = [];
        [buttons, t0, t1] = WaitForVoiceKeyPPA(Cfg, timeout);

    otherwise
        error(sprintf('Unknown response device %s', Cfg.responseDevice)) %#ok<SPERR>

end

%DISCARD SIMULTANEOUS BUTTON PRESSES (LUMINASERIAL CODE AUTOMATICALLY
%DISCARDS DOUBLE PRESSES)
if sum(buttons) > 1
    buttons = zeros(1, 4);
    t1 = t0 + timeout;
    x = [];
    y = [];
end

function [buttons, t0, t1] = WaitForVoiceKeyPPA(Cfg, timeout)
buttons = [0, 0, 0, 0, 0, 1]; %BUTTON 6
t0 = GetSecs;

% x = NaN; y = NaN;
% keyCode = NaN;

%VOICEKEY
% %START ACQUISITION
% PsychPortAudio('Start', Cfg.Audio.pahandle, 0, 0, 1); 
% %THE THIRD PARAMETER (waitForStart) IS SET TO 1, THIS MEANS THAT THIS
% %FUNCTION ONLY RETURNS AFTER ACQUISITION HAS REALLY STARTED, WHICH ALLOWS
% %ASSESSING THE DELAY OF THE ACQUISITION. WE RETURN THE ACTUAL START TIME AS REACTION TIME
% t1 = GetSecs;

%START ACQUISITION
PsychPortAudio('Start', Cfg.Audio.pahandle, 0, 0, 0); 
%THE THIRD PARAMETER (waitForStart) IS SET TO 0, THIS MEANS THAT THIS
%FUNCTION IMMEDIATELY RETURNS. WE RETRIEVE THE ACTUAL START TIME OF THE FIRST SAMPLE WHEN WE CALL PsychPort('GetAudio')
t1 = GetSecs;



% WaitSecs(timeout);
% 
% % Stop sound capture: End of response period.
% PsychPortAudio('Stop', Cfg.Audio.pahandle);
% 
% % Fetch all about x seconds of audiodata at once:
% [audiodata offset overflow tCaptureStart]= PsychPortAudio('GetAudioData', Cfg.Audio.pahandle);
% 
% this_response.wavname = fullfile(Cfg.Audio.outputPath, sprintf('%s_trial_%05d.wav', Cfg.name, Cfg.currentTrialNumber));
% fprintf(1, 'Writing %s ... ', this_response.wavname);
% %MAKE SURE TO WRITE WAV FILES AS [nSamples, nChannels]
% wavwrite(audiodata', Cfg.Audio.f, Cfg.Audio.nBits, this_response.wavname);
% fprintf(1, 'Done.\n');

function [keyCode, t0, t1] = WaitForVoiceKey(Cfg, timeout)
%buttons = 0;
t0 = GetSecs;
t1 = t0;
%x = NaN; y = NaN;
keyCode = NaN;

%VOICEKEY
record(Cfg.Audio.recorder, timeout);       %RECORD for two seconds
%MAKE SURE WE ARE NOT RECORDING ANYMORE
while(isrecording(Cfg.Audio.recorder))
end
%GET DATA
audioarray = getaudiodata(Cfg.Audio.recorder);
this_response.key = [];
this_response.wavname = sprintf('%s_trial_%05d.wav', Cfg.name, Cfg.currentTrialNumber);
startstim = 0;
t = (0:length(audioarray)-1)./Cfg.Audio.f;
audioarray_stimlocked = audioarray(t >= startstim);
t2 =    (0:length(audioarray_stimlocked)-1)./Cfg.Audio.f;
fprintf(1, 'Writing %s ... ', this_response.wavname);
wavwrite(audioarray_stimlocked, Cfg.Audio.f, Cfg.Audio.nBits, this_response.wavname);
fprintf(1, 'Done.\n');

%rt = handle_audio_data(audioarray, Cfg.Audio, 0, this_response.wavname, Cfg.plotVOT)*1000;
%t1 = t0 + rt;

%% handle_audio_data
% compute voice onset time from audio data
function rt = handle_audio_data(audioarray, cfg_audio, startstim, wavname, plotVOT)
%    wavwrite(audioarray, Audio.f, Audio.nBits, wavname)
%    plot((1:length(audioarray))./Audio.f, [audioarray, sqrt(audioarray.^2)])
%    legend({'data', 'demeaned', 'abs'})
t = (0:length(audioarray)-1)./cfg_audio.f;

audioarray_stimlocked = audioarray(t >= startstim);
t2 =    (0:length(audioarray_stimlocked)-1)./cfg_audio.f;

wavwrite(audioarray_stimlocked, cfg_audio.f, cfg_audio.nBits, wavname);
cfg.fnames = wavname;
rt = get_rts(cfg);

if plotVOT
    subplot(2, 1, 1)
    plot(t, audioarray)
    ylim = get(gca, 'ylim');
    hold on
    plot([startstim, startstim], ylim, 'r')
    hold off

    subplot(2, 1, 2)
    plot(t2, audioarray_stimlocked)

    hold on
    ylim = get(gca, 'ylim');
    plot([rt, rt], ylim, 'g')
    hold off
    set(gcf, 'name', sprintf('%s, RT = %f', wavname, rt))
    drawnow
end

function rt = get_rts(cfg)
%%function rt = get_rts(cfg)
%%EXMPLE CALL:
%cfg.thresh = 0.2;
%cfg.fnames = '*.wav';
%cfg.verbose = 0;
%rt = get_rts(cfg)

if(~isfield(cfg, 'thresh')), cfg.thresh = 0.2; end
if(~isfield(cfg, 'fnames')), cfg.fnames = '*.wav'; end
if(~isfield(cfg, 'verbose')), cfg.verbose = 0; end
if(~isfield(cfg, 'ShowRTAnalysis')), cfg.ShowRTAnalysis = 0; end

%cfg.ShowRTAnalysis = 1;
d = dir(cfg.fnames);
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
    [y, fs, nbits, opts] =   wavread(fname); %#ok<ASGLU>

    t = (0:length(y)-1)/fs;
    
    %REMOVE BEGINNING PERIOD
    cases_to_remove = find(t < 0.15);
    y(cases_to_remove) = [];
    t(cases_to_remove) = [];
    
    if cfg.ShowRTAnalysis
        figure
        plot_wav(t, y)
        set(gcf, 'Name', 'Original Signal')
    end
    y = y - mean(y);
    y = y - min(y);
    y = y./max(y)*2-1;
    if cfg.ShowRTAnalysis
        figure
        plot_wav(t, y)
        set(gcf, 'Name', 'Normalized Signal')
    end

    ey = sqrt(y.^2);
    bl = mean(ey(1:max(find((t-t(1))<0.2))));




    cfg.FilterLengthInSamples = 100;
    b = ones(cfg.FilterLengthInSamples, 1)/cfg.FilterLengthInSamples;  % cfg.FilterLengthInSamples point averaging filter
    eyf = filtfilt(b, 1, ey); % Noncausal filtering; smothes data without delay

    if cfg.ShowRTAnalysis
        figure
        plot_wav(t, ey);
        hold on
        plot(t, eyf, 'Color', 'r', 'LineWidth', 3);
        hold off
        set(gcf, 'Name', 'Power')
        ylabel('sqrt(y^2)')
        legend('Power', 'Smoothed Power')
        
    end

    current_thresh = cfg.thresh;
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

    if cfg.ShowRTAnalysis
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

    if cfg.verbose
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
end
if ~isempty(h)
    close(h)
end
if cfg.verbose
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

%% WaitForKeyboard
function [keyCode, t0, t1, buttonStateChanged] = WaitForKeyboard(Cfg, timeout)
persistent oldKey;
buttonStateChanged = 0;
if isempty(oldKey)
     oldKey = 0;
end
%buttons(4) = 0;
keyIsDown = 0;
t0 = GetSecs;
t1 = t0;
keyCode = NaN;
%CONSIDER FLAG FOR allowMultipleKeys

while (((t1 - t0) < timeout)&&(~keyIsDown)) % wait for press
    [keyIsDown, secs, keyCode] = KbCheck;
    t1 = GetSecs;
end
if keyIsDown
    t1 = secs;
    thisKey = find(keyCode);
    buttonStateChanged = thisKey ~= oldKey;
    if buttonStateChanged
        oldKey = thisKey;
    end

end


%% WaitForSerialBoxPress
function [buttons, t0, t1] = WaitForSerialBoxPress(Cfg, timeout)
persistent oldButtons;

if isempty(oldButtons)
     oldButtons = [0, 0, 0, 0];
end
buttons(4) = 0;
t0 = GetSecs;
t1 = t0;
% while ((~Cfg.Hardware.Serial.oSerial.BytesAvailable) && (t1 - t0)<timeout) % wait for press
%     buttons = fgets(Cfg.Hardware.Serial.oSerial);
%     
%     t1 = GetSecs;
% end

while ((t1 - t0) < timeout) % wait for press
    if Cfg.Hardware.Serial.oSerial.BytesAvailable
        
        sbuttons = str2num(fscanf(Cfg.Hardware.Serial.oSerial)); %#ok<ST2NM>
        
        %IF ONLY A SINGLE BUTTON HAS BEEN PRESSED, sbuttons WILL BE BETWEEN
        %1 AND 4, IF SEVERAL BUTTONS HAVE BEEN PRESSED, E.G. 1 AND 4 THE
        %RESULTING NUMBER WILL BE HIGHER THAN TEN (12, 13, 14, 23, 24, 34, 123, 234)
        %IT MAY EVEN OCCUR THAT A BUTTON HAS BEEN PRESSED SIMULTANEOUSLY
        %WITH A SYNCH PULSE
        switch sbuttons
            case {1, 2, 3, 4}
                %TRANSFORM INTO A 4 ELEMENT VECTOR
                buttons(sbuttons) = 1;
                t1 = GetSecs;
                break; %THIS INTENTIONALLY BREAKS OUT OF THE ENTIRE WHILE LOOP!

            case {15, 25, 35, 45}
                sbuttons = (sbuttons - 5)/10;
                %TRANSFORM INTO A 4 ELEMENT VECTOR
                buttons(sbuttons) = 1;
                t1 = GetSecs;
                break; %THIS INTENTIONALLY BREAKS OUT OF THE ENTIRE WHILE LOOP!
            case 5
                %JUST A SYNCH
        end

%         %CLEAN UP IN CASE MONKEY GOES WILD
%         while Cfg.Hardware.Serial.oSerial.BytesAvailable
%             junk = fscanf(Cfg.Hardware.Serial.oSerial);
%         end
        
    end
    %T1 WILL EQUAL TIMEOUT IF NO BUTTON HAS BEEN PRESSED WITIN TIMEOUT
    t1 = GetSecs;

    buttonStateChanged = any(abs(buttons - oldButtons));
    if buttonStateChanged
        oldButtons = buttons;
    end

end

function [buttons, t0, t1] = WaitForSerialButtonUp(Cfg, timeout)
buttons(4) = 0;
t0 = GetSecs;
t1 = t0;
return
% while ((~Cfg.Hardware.Serial.oSerial.BytesAvailable) && (t1 - t0)<timeout) % wait for press
%     buttons = fgets(Cfg.Hardware.Serial.oSerial);
%     
%     t1 = GetSecs;
% end

while ((t1 - t0) < timeout) % wait for press
    if Cfg.Hardware.Serial.oSerial.BytesAvailable
        
        sbuttons = str2num(fscanf(Cfg.Hardware.Serial.oSerial)); %#ok<ST2NM>
        
        %IF ONLY A SINGLE BUTTON HAS BEEN PRESSED, sbuttons WILL BE BETWEEN
        %1 AND 4, IF SEVERAL BUTTONS HAVE BEEN PRESSED, E.G. 1 AND 4 THE
        %RESULTING NUMBER WILL BE HIGHER THAN TEN (12, 13, 14, 23, 24, 34, 123, 234)
        %IT MAY EVEN OCCUR THAT A BUTTON HAS BEEN PRESSED SIMULTANEOUSLY
        %WITH A SYNCH PULSE
        switch sbuttons
            case {1, 2, 3, 4}
                %TRANSFORM INTO A 4 ELEMENT VECTOR
                buttons(sbuttons) = 1;
                t1 = GetSecs;
                break; %THIS INTENTIONALLY BREAKS OUT OF THE ENTIRE WHILE LOOP!

            case {15, 25, 35, 45}
                sbuttons = (sbuttons - 5)/10;
                %TRANSFORM INTO A 4 ELEMENT VECTOR
                buttons(sbuttons) = 1;
                t1 = GetSecs;
                break; %THIS INTENTIONALLY BREAKS OUT OF THE ENTIRE WHILE LOOP!
            case 5
                %JUST A SYNCH
        end

%         %CLEAN UP IN CASE MONKEY GOES WILD
%         while Cfg.Hardware.Serial.oSerial.BytesAvailable
%             junk = fscanf(Cfg.Hardware.Serial.oSerial);
%         end
        
    end
    %T1 WILL EQUAL TIMEOUT IF NO BUTTON HAS BEEN PRESSED WITIN TIMEOUT
    t1 = GetSecs;
end
%% WaitForMousePress
%**************************************************************************
%WAIT FOR MOUSE BUTTON PRESS UNTIL TIMEOUT HAS BEEN REACHED OR A BUTTON
%HAS BEEN PRESSED
%RETURNS
%   X, Y:       CURSOR POSITION
%   BUTTONS:    A VECTOR WITH LENGTH OF NUMBER OF MUSE BUTTONS,
%               THE PRESSED BUTTON(S) HAS/HAVE A 1
%   T0, T1:     TIME WHEN THE FUNCTION IS ENTERED AND LEFT
%**************************************************************************
function [x, y, buttons, t0, t1, extraKey] = WaitForMousePress(timeout, allowTrialRepeat)
buttons = 0;
t0 = GetSecs;
t1 = t0;
x = NaN; y = NaN;
keyIsDown = 0;
keyCode = NaN;
extraKey = NaN;
buttonStateChanged = 0;
persistent oldButtons;

if isempty(oldButtons)
    oldButtons = zeros(1, 3);
end
%while (~any(buttons) && ((t1 - t0)<timeout) &&(~keyIsDown)) % wait for press

%LOOP UNTIL
%-THE BUTTON STATE CHANGES
%-TIME EXPIRES
%-A KEY IS PRESSED
while (~buttonStateChanged && ((t1 - t0)<timeout) &&(~keyIsDown)) % wait for press
    [x, y, buttons] = GetMouse;
    if numel(buttons) > 3
        buttons = buttons(1:3); %only look at first three buttons
    else
        if numel(buttons) < 3
            buttons(3) = 0;
        end
    end
    buttonStateChanged = any(abs(buttons - oldButtons));
    %buttonStateChanged = any((buttons - oldButtons)>0);%ONLY SIGNAL STATE CHANGE IF A NEW BUTTON IS PUSHED (NOT IF ONE IS RELEASED)
    if buttonStateChanged
        oldButtons = buttons;
    end
    %BETA: WE ALSO ALLOW PARTICIPANTS TO PRESS A KEY ON THE KEYBOARD
    %HERE SPACEBAR, WHICH WILL LEAD TO A TRIAL REPETITION
    if allowTrialRepeat
         [keyIsDown, secs, keyCode] = KbCheck;
    end
    t1 = GetSecs;
    % Wait 1 ms before checking the mouse again to prevent
    % overload of the machine at elevated Priority()
    %JS: I REMOVED THIS BECAUSE IT SEEMS TO INVITE FOR GARBAGE COLLECTION
    %AND MAY PRODUCE FRAME DROPS
    %WaitSecs(0.001);
end
if keyIsDown
    extraKey = keyCode;
end
if ~buttonStateChanged
    %I AM NOT SURE THIS IS GOOD
    buttons = [0, 0, 0];
    oldButtons = [0, 0, 0];
end
oldButtons =[];
% function [x, y, buttons, t0, t1] = WaitForMousePress(timeout)
% buttons = 0;
% t0 = GetSecs;
% t1 = t0;
% x = NaN; y = NaN;
% 
% while (~any(buttons) && (t1 - t0)<timeout) % wait for press
%     [x, y, buttons] = GetMouse;
%     t1 = GetSecs;
%     % Wait 1 ms before checking the mouse again to prevent
%     % overload of the machine at elevated Priority()
%     %JS: I REMOVED THIS BECAUSE IT SEEMS TO INVITE FOR GARBAGE COLLECTION
%     %AND MAY PRODUCE FRAME DROPS
%     %WaitSecs(0.001);
% end

%% WaitForLuminaPress
%LUMINA RESPONSE BOX
%needs a handle to a digital IO port hDIO
%returns dio line status
%x and y are unused dummies to keep compatibility with mouse
function [x, y, buttons, t0, t1, buttonStateChanged] = WaitForLuminaPress(hDIO, timeout)
%function [x, y, buttons] = WaitForLuminaPress(hDIO, timeout)
persistent oldButtons;

if isempty(oldButtons)
     oldButtons = zeros(1, 4);
end
buttons = zeros(1, 8);
t0 = GetSecs;
t1 = t0;
x = NaN;
y = NaN;
while (~any(buttons(1:4)) && (t1 - t0)<timeout) % wait for press
    buttons = getvalue(hDIO);
    t1 = GetSecs;
    % Wait 1 ms before checking the DIO again to prevent
    % overload of the machine at elevated Priority()
    
    %CONSIDER REMOVING !!!!!!!!!!!!!!!!!!!
    WaitSecs(0.001);
end
buttons = buttons(1:4); %ONLY USE FIRST 4 BUTTONS
buttonStateChanged = any(abs(buttons - oldButtons));
if buttonStateChanged
    oldButtons = buttons;
end

