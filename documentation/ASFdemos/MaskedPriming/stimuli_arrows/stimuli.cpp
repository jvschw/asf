/*-----------------------------------------
   STIMULI.C -- Draws stimuli to screen
                 (c) Angelika, 12-2001
  -----------------------------------------*/

#include "stdlib.h"
#include "math.h"
#include "definitions.h"

#include <windows.h>


void Show (HWND hwnd, int x_mid, int y_mid, int x_mid_off, int y_mid_off, int offset_x[NUM_POINTS][NUM_PAGES], int offset_y[NUM_POINTS][NUM_PAGES]);


LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM) ;

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,
                    PSTR szCmdLine, int iCmdShow)
{
	 static TCHAR szAppName[] = TEXT ("Stimuli") ;
     HWND         hwnd ;
     MSG          msg ;
     WNDCLASS     wndclass ;
     
     wndclass.style         = CS_HREDRAW | CS_VREDRAW ;
     wndclass.lpfnWndProc   = WndProc ;
     wndclass.cbClsExtra    = 0 ;
     wndclass.cbWndExtra    = 0 ;
     wndclass.hInstance     = hInstance ;
     wndclass.hIcon         = LoadIcon (NULL, IDI_APPLICATION) ;
     wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW) ;
     wndclass.hbrBackground = (HBRUSH) GetStockObject (WHITE_BRUSH) ;
     wndclass.lpszMenuName  = NULL ;
     wndclass.lpszClassName = szAppName ;
          
     if (!RegisterClass (&wndclass))
     {
          MessageBox (NULL, TEXT ("Program requires Windows NT!"), 
                      szAppName, MB_ICONERROR) ;
          return 0 ;
     }
     
     hwnd = CreateWindow (szAppName, TEXT ("Draw stimuli"),
                          WS_OVERLAPPEDWINDOW,
                          CW_USEDEFAULT, CW_USEDEFAULT,
                          BITMAP_X, BITMAP_Y,
                          NULL, NULL, hInstance, NULL) ;
     
     ShowWindow (hwnd, iCmdShow) ;
     UpdateWindow (hwnd) ;
     
     while (GetMessage (&msg, NULL, 0, 0))
     {
          TranslateMessage (&msg) ;
          DispatchMessage (&msg) ;
     }
     return msg.wParam ;
}



LRESULT CALLBACK WndProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{

	 int temp;
	 temp=STIM_TYPE;
	
	 int x_mid=BITMAP_X /2;					         /*calculate midpoint (x)*/
	 int y_mid=BITMAP_Y /2;				             /*calculate midpoint (y)*/
	  
	 int x_mid_off=x_mid+MIDOFF_X;           /*calculate changed midpoint (x);*/               
	 int y_mid_off=y_mid+MIDOFF_Y;           /*calculate changed midpoint (y):*/
	 
	 int stim_xy[NUM_POINTS][NUM_PAGES];
	 
	 int A[NUM_PAGES];
	 int B[NUM_PAGES];

	 int offset_x[NUM_POINTS][NUM_PAGES];	 /*array that specifies offset of each point from midpoint (x) */		
	 int offset_y[NUM_POINTS][NUM_PAGES];    /*array that specifies offset of each point from midpoint (y) */

	 
	 switch (temp)
	 {
		
		case 1:
		case 2:
			/******************/
			/* fix            */
			/* [dummies]      */ 
			/******************/
			
			stim_xy[0][0]=14;
			stim_xy[1][0]=2;
			stim_xy[2][0]=6;
			stim_xy[3][0]=18;
			stim_xy[4][0]=34;
			stim_xy[5][0]=30;
			stim_xy[6][0]=14;
			
			A[0]=40;
			B[0]=30;
			break;	 


        case 3:
			/******************/
			/* prime left     */
			/******************/
			
			stim_xy[0][0]=14;
			stim_xy[1][0]=2;
			stim_xy[2][0]=6;
			stim_xy[3][0]=18;
			stim_xy[4][0]=34;
			stim_xy[5][0]=30;
			stim_xy[6][0]=14;
			
			A[0]=40;
			B[0]=30;
			break;


		case 4:
            /******************/
			/* prime right    */
			/******************/

			stim_xy[0][0]=20;
			stim_xy[1][0]=32;
			stim_xy[2][0]=28;
			stim_xy[3][0]=16;
			stim_xy[4][0]=0;
			stim_xy[5][0]=4;
			stim_xy[6][0]=20;


			A[0]=40;
			B[0]=30;
			break;

		case 5:
			/******************/
			/* mask           */
			/******************/
			
			/*outer contours*/
			stim_xy[0][0]=1;
			stim_xy[1][0]=2;
			stim_xy[2][0]=4;
			stim_xy[3][0]=5;
			stim_xy[4][0]=19;
			stim_xy[5][0]=33;
			stim_xy[6][0]=31;
			stim_xy[7][0]=30;
			stim_xy[8][0]=29;
			stim_xy[9][0]=15;
			stim_xy[10][0]=1;

			A[0]=60;
			B[0]=40;
			
			/*inner contours*/
			stim_xy[0][1]=1;
			stim_xy[1][1]=5;
			stim_xy[2][1]=11;
			stim_xy[3][1]=19;
			stim_xy[4][1]=25;
			stim_xy[5][1]=33;
			stim_xy[6][1]=29;
			stim_xy[7][1]=23;
			stim_xy[8][1]=15;
			stim_xy[9][1]=9;
			stim_xy[10][1]=1;

			A[1]=50;
			B[1]=30;
			break;
		

		case 6:
			/******************/
			/* target left    */
			/******************/

			/*outer contours*/
			stim_xy[0][0]=14;
			stim_xy[1][0]=2;
			stim_xy[2][0]=5;
			stim_xy[3][0]=33;
			stim_xy[4][0]=30;
			stim_xy[5][0]=14;

			A[0]=50;
			B[0]=40;
			
			/*inner contours*/
			stim_xy[0][1]=14;
			stim_xy[1][1]=2;
			stim_xy[2][1]=5;
			stim_xy[3][1]=33;
			stim_xy[4][1]=30;
			stim_xy[5][1]=14;
		
			A[1]=40;
			B[1]=30;
			break;


		case 7:
	 		/******************/
			/* target right   */
			/******************/

			/*outer contours*/
			stim_xy[0][0]=1;
			stim_xy[1][0]=4;
			stim_xy[2][0]=20;
			stim_xy[3][0]=32;
			stim_xy[4][0]=29;
			stim_xy[5][0]=1;

			A[0]=50;
			B[0]=40;
			
			/*inner contours*/
			stim_xy[0][1]=1;
			stim_xy[1][1]=4;
			stim_xy[2][1]=20;
			stim_xy[3][1]=32;
			stim_xy[4][1]=29;
			stim_xy[5][1]=1;

			A[1]=40;
			B[1]=30;
			break;
	 
	 }
	
	  
	 
	 /**********************************************************/
	 /*in this loop, the points of the stimulus are calculated */
	 /*from the stimulus parameters given in stim_xy           */
     /*                                                        */   
	 /* if STIM_TYPE is blank, fix, or prime,                  */
	 /* the outer loop is calculated only once (NUM_PAGE=1)    */
	 /* (for outer contours);                                  */
	 /* if STIM_TYPE is mask or target,                        */
	 /* the next loop is calculated twice (NUM_PAGE=2)         */
	 /* (for outer and inner contours);                        */
	 /**********************************************************/
	 	


	 for (int k=0; k<NUM_PAGES; k++) 
	 {
		 for (int i=0; i<NUM_POINTS; i++) 
		 {
	 		 offset_x[i][k]=(stim_xy[i][k]%7)-3;
			 offset_y[i][k]=(stim_xy[i][k]/7)-2;
		
			 switch(abs(offset_x[i][k]))
			 {
			 case 1:
				 offset_x[i][k]=A[k]*offset_x[i][k];
				 break;
		
			 case 2:
				 offset_x[i][k]=(A[k]+B[k]/2)*offset_x[i][k]/2;
				 break;
		
			 case 3:
				 offset_x[i][k]=(A[k]+B[k])*offset_x[i][k]/3;
				 break;
 			 }
		
			 offset_y[i][k]=B[k]*offset_y[i][k]/2;
		 } 
     }


     switch (message)
     {
   
	 /*case WM_CREATE:
		 Show (hwnd, x_mid, y_mid, x_mid_off, y_mid_off, offset_x, offset_y);

		 return 0;
     */
	 
	 
     case WM_KEYDOWN:
		 Show (hwnd, x_mid, y_mid, x_mid_off, y_mid_off, offset_x, offset_y);
  		 return 0 ;
      
	 
	 case WM_DESTROY:
          PostQuitMessage (0) ;
          return 0 ;
     }
     return DefWindowProc (hwnd, message, wParam, lParam) ;
}




void Show (HWND hwnd, int x_mid, int y_mid, int x_mid_off, int y_mid_off, int offset_x[NUM_POINTS][NUM_PAGES], int offset_y[NUM_POINTS][NUM_PAGES])
{
    
	HDC hdc;
	hdc = GetDC (hwnd);
	
	
	int index;
	int temp;
	temp=STIM_TYPE;

	POINT apt [NUM_POINTS];
	
		
	/* draw outer AND inner contours if STIM_TYPE is target;  */	
	/* if STIM_TYPE is mask, outer and inner contours differ; */
	/* draw outer contours only if STIM_TYPE is prime;	      */

	
	switch (temp)
	{
		case 1:
			 break;		

		case 2:
						
			  /***********************************************************/
			  /*draw fixation cross                                      */
			  /***********************************************************/
			  			  	
			  SelectObject (hdc, GetStockObject (BLACK_BRUSH));
			   
			  MoveToEx(hdc,x_mid,  y_mid-CROSS_SIZE, NULL);
			  LineTo  (hdc,x_mid,  y_mid+CROSS_SIZE);
				
			  MoveToEx(hdc,x_mid-CROSS_SIZE,y_mid  , NULL);
			  LineTo  (hdc,x_mid+CROSS_SIZE,y_mid);
			  	
			  break;

		
		case 3:
		case 4:
		
			  /***********************************************************/
			  /*draw outer contours of stimulus                          */
			  /***********************************************************/
			  
			  SelectObject (hdc, GetStockObject (BLACK_BRUSH));
	  			  
			  for (index=0; index<NUM_POINTS; index++)
			  {
				  apt[index].x=x_mid_off+offset_x[index][0]*SCALE_OUT;
				  apt[index].y=y_mid_off+offset_y[index][0]*SCALE_OUT;
			  }    

			  Polygon(hdc, apt, NUM_POINTS);
			
			  break;
		

		case 5:
		case 6:
		case 7:
			  /***********************************************************/
			  /*draw outer contours of stimulus                          */
			  /***********************************************************/
			  
			  SelectObject (hdc, GetStockObject (BLACK_BRUSH));
	  			  
			  for (index=0; index<NUM_POINTS; index++)
			  {
				  apt[index].x=x_mid_off+offset_x[index][0]*SCALE_OUT;
				  apt[index].y=y_mid_off+offset_y[index][0]*SCALE_OUT;
			  }    

			  Polygon(hdc, apt, NUM_POINTS);
			  
              
			  /***********************************************************/
			  /*draw inner contours of stimulus                          */
			  /***********************************************************/
			  
			  SelectObject (hdc, GetStockObject (WHITE_BRUSH));

			  for (index=0; index<NUM_POINTS; index++)
			  {
				  apt[index].x=x_mid_off+offset_x[index][1]*SCALE_IN;
				  apt[index].y=y_mid_off+offset_y[index][1]*SCALE_IN;
			  }    


			  Polygon(hdc, apt, NUM_POINTS); 
			  
			  break;
              
	}

      
      ReleaseDC(hwnd, hdc);


}
