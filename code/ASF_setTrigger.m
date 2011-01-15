function Cfg = ASF_setTrigger(Cfg, triggerVal)
%function ASF_setTrigger(Cfg, triggerVal)
if Cfg.issueTriggers
    if ~isempty(Cfg.validTriggerValues)
        if ismember(triggerVal, Cfg.validTriggerValues)
            switch Cfg.digitalOutputDevice
                case 'ARDUINO'
                    ASF_arduinoTrigger(Cfg.hardware.Arduino.hSerial)
                case 'PARALLEL'
                    %TRIGGER ON PARALLEL PORT
                    putvalue(Cfg.hardware.DigitalOutput.mydio.TriggerPort, triggerVal);
                case 'NIDAQ2'
            end
        end
    end
end

%TRIGGER FOR EYELINK
Cfg = ASF_sendMessageToEyelink(Cfg, sprintf('PAGE %04d', triggerVal));