function ASF_shutDownEyelink(status, edfFile)
%shuts down Eyelink connection and closes edf file at the end of the
%experiment
%created by Angelika Lingnau, 2008-01-26
%------------------------------
Eyelink('stoprecording');
%Screen('CloseAll');
%ShowCursor;
%Priority(oldPriority);
%if createFile
status=Eyelink('closefile');
if status ~=0
    disp(sprintf('closefile error, status: %d',status))
end
status=Eyelink('ReceiveFile',edfFile,pwd,1);
%status=Eyelink('ReceiveFile',edfFile);
if status~=0
    fprintf('problem: ReceiveFile status: %d\n', status);
end
if 2==exist(edfFile, 'file')
    fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
else
    disp('unknown where data file went')
end
%end
Eyelink('shutdown');
%------------------------------