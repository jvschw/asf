function Cfg = ASF_setTrigger(Cfg, triggerVal)
%function ASF_setTrigger(Cfg, triggerVal)
if Cfg.issueTriggers
    if ~isempty(Cfg.validTriggerValues)
        if ismember(triggerVal, Cfg.validTriggerValues)
            switch Cfg.digitalOutputDevice
                case 'ARDUINO'
                    ASF_arduinoTrigger(Cfg.hardware.Arduino.hSerial, triggerVal, Cfg.Trigger.triggerType)
                case 'PARALLEL'
                    %TRIGGER ON PARALLEL PORT
                    putvalue(Cfg.hardware.DigitalOutput.mydio.TriggerPort, triggerVal);
                    switch Cfg.Trigger.triggerType
                        case 'state'
                            %DO NOTHING ELSE
                        case 'pulse'
                            %SWITCH BACK TO 0 AFTER 5ms
                            %THIS PRODUCES A BOXCAR FUNCTION AT THE TRIGGER
                            %CHANNEL; THE DISADVANTAGE IS THAT THE
                            %EXPERIMENT IS HELD UP BY 5ms
                            WaitSecs(0.005);
                            putvalue(Cfg.hardware.DigitalOutput.mydio.TriggerPort, 0);
                    end
                            
                case 'NIDAQ2'
            end
        end
    end
end

%TRIGGER FOR EYELINK
Cfg = ASF_sendMessageToEyelink(Cfg, sprintf('PAGE %04d', triggerVal));