int ledPin = 13; // LED connected to digital pin 13
int inPin[8] = {-1, -1, -1, 3, 4, 5, 6, 7}; //PIN NUMBER
int buttonNo[8] = {-1, -1, -1, 1, 2, 3, 4, 5}; //LUMINA BUTTON  
/*
int inPin1 = 7;   // pushbutton connected to digital pin 1
int inPin2 = 6;   // pushbutton connected to digital pin 2
int inPin3 = 5;   // pushbutton connected to digital pin 3
int inPin4 = 4;   // pushbutton connected to digital pin 4
int inPin5 = 3;   // pushbutton connected to digital pin 5
int inPin6 = 2;   // pushbutton connected to digital pin 6
*/
int val = 0;     // variable to store the read value
int val2 = 0;     // variable to store the read value
int valout = 0;
int i;
void setup()
{
  Serial.begin( 9600 );
  pinMode(ledPin, OUTPUT);      // sets the digital pin 13 as output

  // sets the digital pins as input
  for(i=0;  i < 8; i++)
  {
    if(inPin[i]>0)
    {
      pinMode(inPin[i], INPUT);
    }     
  }
  
  digitalWrite(ledPin, 0);    // sets the LED to the button's value
}

void loop()
{
  /*
  while(digitalRead(inPin) == 0)
  {
  }
  digitalWrite(ledPin, 1);    // sets the LED to the button's value
  while(digitalRead(inPin) == 1)
  {
  }
  digitalWrite(ledPin, 0);    // sets the LED to the button's value
  Serial.println(255);
  */
  
  
  val = 0; val2 = 0;
  //WAIT FOR PUSH
  while(val == 0)
  {
    for(i = 0; i < 8; i++)
    {
      if(inPin[i]>0)
      {
        val = val + digitalRead(inPin[i])*(2^i);
      }     
    }
    //val = digitalRead(inPin1)+2*digitalRead(inPin2)+4*digitalRead(inPin3)+8*digitalRead(inPin4)+16*digitalRead(inPin5);
  }
  digitalWrite(ledPin, 1);    // sets the LED to the button's value
  
  //WAIT FOR RELEASE
  val2 = val;
  while(val2 > 0)
  {
    for(i = 0; i < 8; i++)
    {
      if(inPin[i]>0)
      {
        val2 = val2 + digitalRead(inPin[i])*(2^i);
      }     
    }

    //val2 = digitalRead(inPin1)+2*digitalRead(inPin2)+4*digitalRead(inPin3)+8*digitalRead(inPin4)+16*digitalRead(inPin5);
  }
  digitalWrite(ledPin, 0);    // sets the LED to the button's value
  
  Serial.println(val);
  
  //EMULATE SERIAL OUTPUT OF LUMINA BOX WHICH WRITES ONE BYTE PER BUTTON
  if (val&1)
  {
    valout=1;
  }
  if (val&2)
  {
    valout=valout*10+2;
  }
  if (val&4)
  {
    valout=valout*10+3;
  }
  if (val&8)
  {
    valout=valout*10+4;
  }
  if (val&16)
  {
    valout=valout*10+5;
  }

  // Serial.println(valout);
 
 }


