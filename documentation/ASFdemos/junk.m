function junk
while 1
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    if keyIsDown
        fprintf(1, '%3d\n', find(keyCode));
    end
end
