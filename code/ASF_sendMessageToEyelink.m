function Cfg = ASF_sendMessageToEyelink(Cfg, strMsg)
%function Cfg = ASF_sendMessageToEyelink(Cfg, strMsg)
%SEND MESSAGE TO EYELINK
%20101214 jens.schwarzbach@unitn.it

if Cfg.Eyetracking.useEyelink
    % Check recording status, stop display if error
    Cfg.Eyetracking.err = Eyelink('checkrecording');
    Cfg.Eyetracking.status = Eyelink('message', strMsg);
    
    %PUT SOME ERROR HANDLING HERE
end