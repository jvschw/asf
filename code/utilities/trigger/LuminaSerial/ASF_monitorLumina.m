function ASF_monitorLumina
s = serial('COM4', 'baudRate', 9600);
fopen(s);

t0 = GetSecs;
timeoutMilliSeconds = 2000;
for i = 1:10
    WaitForScannerSynchSerial(s, timeoutMilliSeconds)
    fprintf(1, '%8.3f\n', GetSecs - t0);
end
fclose(s);
delete(s)

% function WaitForScannerSynchSerial(hSerial, timeoutMilliSeconds)
% 
% contflag = 1;
% tStart = GetSecs;
% while contflag
%     if hSerial.BytesAvailable
%         sbuttons = fscanf(hSerial, '%d', 1); %#ok<ST2NM>
%         %CLEAN UP IN CASE MONKEY GOES WILD
%         while hSerial.BytesAvailable
%             junk = fscanf(hSerial, '%d', 1) %#ok<NASGU>
%         end
%         if sbuttons == 5
%             contflag = 0;
%         end
%     else
%         %NOTHING AVAILABLE, CHECK TIMEOUT
%         if (GetSecs - tStart) > timeoutMilliSeconds/1000
%             return;
%         end
%     end
% end

function WaitForScannerSynchSerial(hSerial, timeoutMilliSeconds)

contflag = 1;
tStart = GetSecs;
while contflag
    if hSerial.BytesAvailable
        sbuttons = str2num(fscanf(hSerial)); %#ok<ST2NM>
        %CLEAN UP IN CASE MONKEY GOES WILD
        while hSerial.BytesAvailable
            junk = fscanf(hSerial); %#ok<NASGU>
        end
        if sbuttons == 5
            contflag = 0;
        end
    else
        %NOTHING AVAILABLE, CHECK TIMEOUT
        if (GetSecs - tStart) > timeoutMilliSeconds/1000
            return;
        end
    end
end