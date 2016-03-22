function ASF_arduinoTrigger(s, value, triggerType)
%function ASF_arduinoTrigger(s, value, triggerType)
%TRIGGER TYPES CAN BE
%'pulse': emit a pulse
%'state': just change the trigger level
%'burst': emit a series of pulses (probably need varargin fur burst
%parameters
%
%TRIGGER TYPE NOT YET IMPLEMENTED. CURRENTLY THIS CODE ONLY KNOWS 'pulse',
%WHICH SENDS CODE 55 THROUGH SERIAL PORT TO CONNECTED ARDUINO
%THIS CODE MAKES ARDUINO ISSUE A 10MS PULSE ON DIG11 DURING WHICH
%THE ONBOARD LED IS ACTIVE
%
%FUTURE VERSIONS WILL ALLOW SENDING A VALUE NOT JUST AN ON OR OFF STATE
switch triggerType
    case 'pulse'
        fprintf(s, '%c', value);
    case 'state'
        fprintf(s, '%c', 56);
        fprintf(1, 'ASF_arduinoTrigger: Trigger type ''state'' not (yet) implemented.\');
    case 'train'
        fprintf(s, '%c', 57);
    otherwise
        fprintf(1, 'ASF_arduinoTrigger: Trigger type %s not (yet) implemented.\', triggerType);
end
        

%MAKE SURE THAT THE FOLLOWING CODE IS ACTIVE ON ARDUINO
% // Issue a trigger of 1ms duration on digital 0 upon receiving code 55 on serial port 
% int digitalPin = 11; //13 for internal LED
% int ledPin = 13; //13 for internal LED
% int speakerPin = 10;
% byte startbyte;
% 
% void setup()
% {
% //  tone( speakerPin, 1000, 500);
%   Serial.begin( 9600 );
%   pinMode( digitalPin, OUTPUT );
%   pinMode( ledPin, OUTPUT );
% }
% 
% 
% void loop()
% {
% 
%   startbyte = Serial.read();
%   switch( startbyte )
%   {
%     case 55:
%//   PULSE
%     digitalWrite( digitalPin, HIGH );
%     digitalWrite( ledPin, HIGH );
%     delay( 10 );
%     digitalWrite( digitalPin, LOW );
%     digitalWrite( ledPin, LOW );
%     break;
%     
%     case 56: 
%//   STATE
%     break;
%
%     case 57: 
%//   TRAIN
%     digitalWrite( digitalPin, HIGH );
%     digitalWrite( ledPin, HIGH );
%     delay( 10 );
%     digitalWrite( digitalPin, LOW );
%     digitalWrite( ledPin, LOW );
%     delay( 10 );
%     digitalWrite( digitalPin, HIGH );
%     digitalWrite( ledPin, HIGH );
%     delay( 10 );
%     digitalWrite( digitalPin, LOW );
%     digitalWrite( ledPin, LOW );
%     delay( 10 );
%     digitalWrite( digitalPin, HIGH );
%     digitalWrite( ledPin, HIGH );
%     delay( 10 );
%     digitalWrite( digitalPin, LOW );
%     digitalWrite( ledPin, LOW );
%     break;
%
%     case 255:
%     //tone( speakerPin, 1000, 5);
%     //delay( 100 );
%     break;
%   }
%   
%   Serial.flush();
% }
% 
