function ExpInfo = runMaskedPriming(subjectID)
%function ExpInfo = runMaskedPriming(subjectID)
%%Example call:
%ExpInfo = runMaskedPriming('TEST')


Cfg = [];
%%UNCOMMENT FOR ISSUING MARKERS TO EEG, MEG, fNIRS
Cfg.issueTriggers = 1;
Cfg.validTriggerValues = 1:32;
Cfg.digitalOutputDevice = 'ARDUINO';
Cfg.hardware.Arduino.comPort.port = 'COM9';%THIS WILL VARY FROM COMPUTER TO COMPUTER, PLEASE ADJUST
ExpInfo = ASF('MaskedPriming.std', 'mp.trd', subjectID, Cfg);