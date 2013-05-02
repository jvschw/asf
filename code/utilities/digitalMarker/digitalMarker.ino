
//DIGITAL MARKER
//THIS SKETCH RECEIVES A BYTE AND GENERATES an 8-BIT DIGITAL OUTPUT
//PURPOSE: PUTTING MARKERS INTO AN EEG, MEG, OR FNIRS STREAM
//jens.schwarzbach@unitn.it 20130501

char triggerVal;
char valD;
char valB;
void setup() {
  //INITIALIZE DIGITAL OUTPUT PORTS
  DDRD = DDRD | B11111100;  // this is safer as it sets pins 2 to 7 as outputs
  // without changing the value of pins 0 & 1, which are RX & TX 
  DDRB = DDRD | B00000011;  // 

  Serial.begin(9600); 
}

void loop()
{
  if(Serial.available()){
    triggerVal = Serial.read();
    Serial.println(triggerVal);

    //WE WANT TO USE 8 DIGITAL OUTPUTS, 
    //HOWEVER WE DO NOT WANT TO USE DOUT0 and DOUT1 BECAUSE WE NEED THEM FOR SERIAL COMMUNICATION
    //SOLUTION WE WILL USE THE LOWER TWO BITS OF PORTB (DOUT9, DOUT8)
    // AND THE UPPER 6 BITS (DOUT7, DOUT6, DOUT5, DOUT4, DOUT3, DOUT2) OF PORT D
    valD = triggerVal << 2;
    valB = triggerVal >> 6;

    //WE FIRST WRITE TO PORT D (DOUT7, DOUT6, DOUT5, DOUT4, DOUT3, DOUT2) 
    //THEN WE WRITE TO PORT B (DOUT9, DOUT8))
    //THIS MEANS THAT OUR TRIGGERS ARE SLIGHTLY OUT OF SYNCH BUT I HOPE THIS IS NEGLIGIBLE
    PORTD = valD; 
    PORTB = valB;
    
    //WAIT A BIT BEFORE RESETTING THHE DIGITAL OUTPUT
    delayMicroseconds(10000); //1000 gives a 1ms impulse
    PORTD = 0; 
    PORTB = 0;
    
  } 

}

