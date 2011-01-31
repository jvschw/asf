%function [x, y, buttons, t0, t1] = ASF_waitForResponse(Cfg, timeout)
%% ***RESPONSE COLLECTION***
%% WaitForResponse Wrapper
%WRAPPER FUNCTION THAT CHECKS FOR A RESPONSE USING:
%MOUSE
%LUMINA
%CRS RESPONSE BOX - NOT YET IMPLEMENTED
%KEYBOARD 
%20071024 JS FIXED BUG THAT NOT PRESSING A RESPONSE BTTEN COULD LEAD TO PROGRAM STOP
%20081126 JS FIXED BUG THAT RT WAS NOT RECORDED USING THE LUMINA BOX
function [x, y, buttons, t0, t1] = ASF_waitForResponse(Cfg, timeout)
switch Cfg.responseDevice
    case 'MOUSE'
        [x, y, buttons, t0, t1] = WaitForMousePress(timeout);
        
    case 'LUMINAPARALLEL'
        [x, y, buttons, t0, t1] = WaitForLuminaPress(Cfg.hardware.parallel.mydio_in, timeout);

    case 'LUMINASERIAL'
        x = [];
        y = [];
        [buttons, t0, t1] = WaitForSerialBoxPress(Cfg, timeout);

    case 'KEYBOARD'
        x = [];
        y = [];
        [buttons, t0, t1] = WaitForKeyboard(Cfg, timeout);

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


%% WaitForKeyboard
function [keyCode, t0, t1] = WaitForKeyboard(Cfg, timeout)
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
end


%% WaitForSerialBoxPress
function [buttons, t0, t1] = WaitForSerialBoxPress(Cfg, timeout)
buttons(4) = 0;
t0 = GetSecs;
t1 = t0;
% while ((~Cfg.hardware.serial.oSerial.BytesAvailable) && (t1 - t0)<timeout) % wait for press
%     buttons = fgets(Cfg.hardware.serial.oSerial);
%     
%     t1 = GetSecs;
% end

while ((t1 - t0) < timeout) % wait for press
    if Cfg.hardware.serial.oSerial.BytesAvailable
        
        sbuttons = str2num(fscanf(Cfg.hardware.serial.oSerial)); %#ok<ST2NM>
        
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
%         while Cfg.hardware.serial.oSerial.BytesAvailable
%             junk = fscanf(Cfg.hardware.serial.oSerial);
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
function [x, y, buttons, t0, t1] = WaitForMousePress(timeout)
buttons = 0;
t0 = GetSecs;
t1 = t0;
x = NaN; y = NaN;

while (~any(buttons) && (t1 - t0)<timeout) % wait for press
    [x, y, buttons] = GetMouse;
    t1 = GetSecs;
    % Wait 1 ms before checking the mouse again to prevent
    % overload of the machine at elevated Priority()
    %JS: I REMOVED THIS BECAUSE IT SEEMS TO INVITE FOR GARBAGE COLLECTION
    %AND MAY PRODUCE FRAME DROPS
    %WaitSecs(0.001);
end


%% WaitForLuminaPress
%LUMINA RESPONSE BOX
%needs a handle to a digital IO port hDIO
%returns dio line status
%x and y are unused dummies to keep compatibility with mouse
function [x, y, buttons, t0, t1] = WaitForLuminaPress(hDIO, timeout)
%function [x, y, buttons] = WaitForLuminaPress(hDIO, timeout)
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

