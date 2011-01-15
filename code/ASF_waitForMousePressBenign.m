%% WaitForMousePressBenign
%**************************************************************************
%WAIT FOR MOUSE BUTTON PRESS UNTIL TIMEOUT HAS BEEN REACHED OR A BUTTON
%HAS BEEN PRESSED
%RETURNS
%   X, Y:       CURSOR POSITION
%   BUTTONS:    A VECTOR WITH LENGTH OF NUMBER OF MUSE BUTTONS,
%               THE PRESSED BUTTON(S) HAS/HAVE A 1
%   T0, T1:     TIME WHEN THE FUNCTION IS ENTERED AND LEFT
%**************************************************************************
function [x, y, buttons, t0, t1] = ASF_waitForMousePressBenign(timeout)
buttons = 0;
t0 = GetSecs;
t1 = t0;
while (~any(buttons) && (t1 - t0)<timeout) % wait for press
    [x, y, buttons] = GetMouse;
    t1 = GetSecs;
    % Wait 10 ms before checking the mouse again to prevent
    % overload of the machine at elevated Priority()
    WaitSecs(0.01);
end
