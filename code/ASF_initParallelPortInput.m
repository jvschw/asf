%% InitParallelPortInput
function Cfg = ASF_initParallelPortInput(Cfg)
if ~isfield(Cfg, 'Hardware'), Cfg.Hardware = []; else end
if ~isfield(Cfg.Hardware, 'parallel'), Cfg.Hardware.parallel = []; else end
if ~isfield(Cfg.Hardware.parallel, 'ON'), Cfg.Hardware.parallel.ON = 0; Cfg.Hardware.parallel.OFF = 1;else end 

fprintf(1, 'INITIALIZING PARALLEL PORT FOR INPUT\n');
% OPEN PARPORT
Cfg.Hardware.parallel.mydio_in = digitalio('parallel');

% SET THE HIGHEST SPEED POSSIBLE
set(Cfg.Hardware.parallel.mydio_in, 'TimerPeriod', 0.001)

% 
% PortID Pins         Description
% 0      2-9          Eight I/O lines, with pin 9 being the most significant bit (MSB).
% 1      10-13,15     Five input lines used for status
% 2      1, 14, 16,17 Four I/O lines used for control

% First Line of Port TWO, i.e. PIN1, has LineID 13
% First Line of Port ZERO, i.e. PIN2, has LineID 1

% SET PIN1 AS AN OUTPUT
% addline(Cfg.Hardware.parallel.mydio, 13, 'out','OutPutLine')

% SET PIN2 AS AN OUTPUT
%addline(Cfg.Hardware.parallel.mydio, 1, 'out','OutPutLine')

% SET PORT AS AN OUTPUT
%addline(Cfg.Hardware.parallel.mydio, 0:7, 'out', 'TriggerPort')

% SET PORT AS AN INPUT AND OUTPUT
addline(Cfg.Hardware.parallel.mydio_in, 0:7, 'In', 'LuminaPort') %MAYBE 8:12 PINS [10:13, 15]

%Cfg.Hardware.parallel.ON=0; Cfg.Hardware.parallel.OFF=1; %Reverse Logic

Cfg.Hardware.parallel.dioinfos = getvalue(Cfg.Hardware.parallel.mydio_in)
fprintf(1, 'DONE\n');

% %% ***TRIGGERING***
% %% setTrigger
% function setTrigger(Cfg, TriggerVal)
% if Cfg.issueTriggers
%     putvalue(Cfg.Hardware.DigitalOutput.mydio.TriggerPort, TriggerVal);
% end
