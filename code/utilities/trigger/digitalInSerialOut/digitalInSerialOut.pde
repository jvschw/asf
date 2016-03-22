#define VERBOSE 0
int ledPin = 13; // LED connected to digital pin 13
//int inPin = 7;   // pushbutton connected to digital pin 7
int luminaChannel1 = 2;   // pushbutton1 connected to digital pin 2
int luminaChannel2 = 3;   // pushbutton2 connected to digital pin 3
int luminaChannel3 = 4;   // pushbutton3 connected to digital pin 4
int luminaChannel4 = 5;   // pushbutton4 connected to digital pin 5
int luminaChannel5 = 6;   // pushbutton5 connected to digital pin 6
int luminaChannel6 = 7;   // pushbutton6 connected to digital pin 7
int lumiChan[] = {1, 2, 3, 4, 5, 6};
int inPin[] =    {2, 3, 4, 5, 6, 7};

int nInputs = 6;
int i = 0;
int val = 0;     // variable to store the read value
int val2 = 0;     // variable to store the read value
int valout = 0;

void setup()
{
  Serial.begin( 9600 );
  pinMode(ledPin, OUTPUT);      // sets the digital pin 13 as output

  //pinMode(inPin, INPUT);      // sets the digital pin 7 as input
  for(i = 0; i < nInputs; i++)
  {
    pinMode(inPin[i], INPUT);      // sets the digital pin as input
  }
  /*
  pinMode(luminaChannel1, INPUT);      // sets the digital pin as input
  pinMode(luminaChannel2, INPUT);      // sets the digital pin as input
  pinMode(luminaChannel3, INPUT);      // sets the digital pin as input
  pinMode(luminaChannel4, INPUT);      // sets the digital pin as input
  pinMode(luminaChannel5, INPUT);      // sets the digital pin as input
  pinMode(luminaChannel6, INPUT);      // sets the digital pin as input
  */
  digitalWrite(ledPin, 0);    // sets the LED to the button's value
}

void loop()
{
  org();
 }


void org()
{
   val = 0; val2 = 0;
  //WAIT FOR PUSH

  while(val == 0)
  {
    val = digitalRead(luminaChannel1)+2*digitalRead(luminaChannel2)+4*digitalRead(luminaChannel3)+8*digitalRead(luminaChannel4)+16*digitalRead(luminaChannel5);
  }
 
  digitalWrite(ledPin, 1);    // sets the LED to the button's value
  
  //WAIT FOR RELEASE
  val2 = val;
 
  while(val2 > 0)
  {
    val2 = digitalRead(luminaChannel1)+2*digitalRead(luminaChannel2)+4*digitalRead(luminaChannel3)+8*digitalRead(luminaChannel4)+16*digitalRead(luminaChannel5);
  }
  
  digitalWrite(ledPin, 0);    // sets the LED to the button's value
  
  //Serial.println(val);
  
  //EMULATE SERIAL OUTPUT OF LUMINA BOX WHICH WRITES ONE BYTE PER BUTTON
  valout = 0;
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
   if (val&32)
  {
    valout=valout*10+6;
  }

   Serial.println(valout);
 
 }

//NONWORKING SOPHISTICATED VERSION
void alt()
{
   val = 0; val2 = 0;
  //WAIT FOR PUSH

   while(val == 0)
  {
    for(i = 0; i < nInputs; i++)
    {
      val =  val + digitalRead(inPin[i])*pow(2,i);      // read input
    }
  }

  digitalWrite(ledPin, 1);    // sets the LED to the button's value
  
  //WAIT FOR RELEASE
  val2 = val;
  while(val2 == 0)
  {
    for(i = 0; i < nInputs; i++)
    {
      val2 =  val2 + digitalRead(inPin[i])*pow(2,i);      // sets the digital pin as input
    }
  }

  digitalWrite(ledPin, 0);    // sets the LED to the button's value
  
  //Serial.println(val);
  
  //EMULATE SERIAL OUTPUT OF LUMINA BOX WHICH WRITES ONE BYTE PER BUTTON
  valout = 0;
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
   if (val&32)
  {
    valout=valout*10+6;
  }

   Serial.println(valout);
 
 }

