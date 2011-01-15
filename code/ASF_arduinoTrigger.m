function ASF_arduinoTrigger(s)
%function ASF_arduinoTrigger(s)
%SENDS CODE 55 THROUGH SERIAL PORT TO CONNECTED ARDUINO
%THIS CODE MAKES ARDUINO ISSUE A 10MS PULSE ON DIG11 DURING WHICH
%THE ONBOARD LED IS ACTIVE
fprintf(s, '%c', 55);

%MAKE SURE THAT THE FOLLOWING CODE IS ACTIVE ON ARDUINO
% // Franzis Arduino
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
