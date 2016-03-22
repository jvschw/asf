// include the library code:
#include <LiquidCrystal.h>
#include <TimerOne.h>


const char KEY_LEFT = 1;
const char KEY_RIGHT = 2;
const char KEY_UP = 3;
const char KEY_DOWN = 4;
const char KEY_SELECT = 5;

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

typedef struct{
  boolean echoKey;
}
cfg_t;


cfg_t Cfg;

int TR = 1000;
int stepSize = 50;
int xOld;
void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.setCursor(0,0);
  lcd.print("TR=");
  lcd.print(TR);
  lcd.setCursor(0,1);
  lcd.print("Press Key:");

  //CONFIGURATION SETTINGS
  Cfg.echoKey = 1;


  // Initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards
  pinMode(13, OUTPUT);    

  Timer1.initialize(100000); // set a timer of length 100000 microseconds (or 0.1 sec - or 10Hz => the led will blink 5 times, 5 cycles of on-and-off, per second)
  Timer1.attachInterrupt( timerIsr ); // attach the service routine here
}

void loop() {

  if (checkKey() == KEY_SELECT){
    editVals();
  };
}

void editVals()
{
  boolean bCont = 1;
  char currentKey;
  //BY DEFAULT WE EDIT TR
  while(bCont){
     lcd.blink();
    //GET KEY
    currentKey = checkKey();

    //PROCESS KEY
    switch (currentKey){
    case KEY_UP:
      if (TR < 5000){
        TR = TR + 50;
      }

    case KEY_SELECT:
      bCont = 0;
    }

    //UPDATE DISPLAY
    lcd.setCursor(0,0);
    lcd.print("TR=     ");
    lcd.setCursor(3,0);
    lcd.print(TR);
    delay(100);

    //WE ALSO CAN EDIT NVOLS
  }
     lcd.noBlink();
}

char checkKey()
{
  int x;
  int keyCode;
  x = analogRead (0);

  if (x < 100) {
    keyCode = KEY_RIGHT;
  }
  else if (x < 200) {
    keyCode = KEY_UP;
  }
  else if (x < 400){
    keyCode = KEY_DOWN;
  }
  else if (x < 600){
    keyCode = KEY_LEFT;
  }
  else if (x < 800){
    keyCode = KEY_SELECT;
  }

  //IF IN VERBOSE MODE DISPLAY WHICH KEY HAS BEEN PRESSED
  if ((keyCode>0)&&(Cfg.echoKey)){

    lcd.setCursor(10,1);

    switch(keyCode){
    case KEY_LEFT:
      lcd.print ("Left  ");
      break;

    case KEY_RIGHT:
      lcd.print ("Right ");
      break;

    case KEY_UP:
      lcd.print ("Up    ");
      break;

    case KEY_DOWN:
      lcd.print ("Down  ");
      break;

    case KEY_SELECT:
      lcd.print ("Select");
      break;

    default:
      break;
      //DO NOTHING
    }//END SWITCH 
  }//END IF VERBOSE


  return keyCode;
}

void updateDisplay(int x)
{

  lcd.setCursor(12, 0);
  lcd.print( "    " );          //quick hack to blank over default left-justification from lcd.print()
  lcd.setCursor(12, 0);         //note the value will be flickering/faint on the LCD
  lcd.print( x );

  lcd.setCursor(10,1);
  if (x < 100) {
    lcd.print ("Right ");
  }
  else if (x < 200) {
    lcd.print ("Up    ");
    if(TR < 5000){
      TR = TR + stepSize;
    }
  }
  else if (x < 400){
    lcd.print ("Down  ");
    if(TR > stepSize){
      TR = TR - stepSize;
    }
  }
  else if (x < 600){
    lcd.print ("Left  ");
  }
  else if (x < 800){
    lcd.print ("Select");
  }

  lcd.setCursor(0,0);
  lcd.print("TR=     ");
  lcd.setCursor(3,0);
  lcd.print(TR);
  delay(100);
}

/// --------------------------
/// Custom ISR Timer Routine
/// --------------------------
void timerIsr()
{
  // Toggle LED
  digitalWrite( 13, digitalRead( 13 ) ^ 1 );
}













