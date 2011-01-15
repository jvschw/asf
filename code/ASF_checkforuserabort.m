function ASF_checkforuserabort(windowPtr, Cfg)

[bUpDn, T, keyCodeKbCheck] = KbCheck;
if bUpDn % break out of loop
    if find(keyCodeKbCheck) == 81
        fprintf(1, 'USER ABORTED PROGRAM\n');
        ASF_PTBExit(windowPtr, Cfg, 1)
        %FORCE AN ERROR
        error('USERABORT')
    end
end
