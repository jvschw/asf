function Cfg = ASF_setTrigger(Cfg, triggerVal)
%function ASF_setTrigger(Cfg, triggerVal)
if Cfg.issueTriggers
    if ~isempty(Cfg.validTriggerValues)
        if ismember(triggerVal, Cfg.validTriggerValues)
            switch Cfg.digitalOutputDevice
                case 'ARDUINO'
                    ASF_arduinoTrigger(Cfg.Hardware.Arduino.hSerial, triggerVal, Cfg.Trigger.triggerType)
                    %DEBUGGING
                    %fprintf(1, 'MARKER %d\n', triggerVal);
                case 'PARALLEL'
                    %TRIGGER ON PARALLEL PORT
                    putvalue(Cfg.Hardware.DigitalOutput.mydio.TriggerPort, triggerVal);
                    switch Cfg.Trigger.triggerType
                        case 'state'
                            %DO NOTHING ELSE
                        case 'pulse'
                            %SWITCH BACK TO 0 AFTER 5ms
                            %THIS PRODUCES A BOXCAR FUNCTION AT THE TRIGGER
                            %CHANNEL; THE DISADVANTAGE IS THAT THE
                            %EXPERIMENT IS HELD UP BY 5ms
                            WaitSecs(0.005);
                            putvalue(Cfg.Hardware.DigitalOutput.mydio.TriggerPort, 0);
                    end
                case 'PARALLEL32'
                    lptwrite(888, triggerVal)
                    WaitSecs(0.004)
                    lptwrite(888, 0)
                            
                case 'NIDAQ2'
            end
        end
    end
end

if Cfg.issueDebugTriggers
    tNow = GetSecs;
    fprintf(1, 'TRIGGER CODE %3d AT T = %8.3f\n', triggerVal, tNow - Cfg.experimentStart);
end
