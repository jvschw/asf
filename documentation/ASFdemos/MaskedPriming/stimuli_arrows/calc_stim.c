#include <windows.h>
#include "definitions.h"
typedef struct STIM_XY
	{
		int page;
		int loc;
};


extern 	int offset_x[MAXPOINTS][MAXPAGES];//offset_x[12][2];	 //array that specifies offset of each point from midpoint (x) 		
extern	int offset_y[MAXPOINTS][MAXPAGES];    //array that specifies offset of each point from midpoint (y) 


void calc_stim(int iStimType, struct STIMDEF SDsd)
{
	static int                cxClient, cyClient, cxDib, cyDib ;
	static TCHAR              szFileName [MAX_PATH], szTitleName [MAX_PATH] ;
	static HBITMAP hBitMap;// = {1024, 768, 1, 1, NULL};
	
	
	
	int x_mid=X_MID;					         //calculate midpoint (x)
	int y_mid=Y_MID;				             //calculate midpoint (y)
	
	int x_mid_off=X_MID+MIDOFF_X;           //calculate changed midpoint (x);               
	int y_mid_off=Y_MID+MIDOFF_Y;           //calculate changed midpoint (y):
	
	int stim_xy[MAXPOINTS][MAXPAGES];
	//int A[NUM_PAGES];
	//int B[NUM_PAGES];
	int *iPtrA;
	int *iPtrB;
	
	int page, i;
	

	//DYNAMIC MEMORY ALLOCATION
	iPtrA = malloc(sizeof(int)*SDsd.iNumPages);
	iPtrB = malloc(sizeof(int)*SDsd.iNumPages);

	//iPtrstim_xy= malloc(sizeof(int)*SDsd.iNumPoints*SDsd.iNumPages);

	switch (iStimType)
	{
		
	case 0:
		//****************
		// blank (dummy)            
		//****************
		stim_xy[0][0]=0;
		
		iPtrA[0]=0;
		iPtrB[0]=0;
		break;

	case 1:
		//****************
		// fix            
		//****************
		
		stim_xy[0][0]=10;
		stim_xy[1][0]=24;
		stim_xy[2][0]=17;
		stim_xy[3][0]=16;
		stim_xy[4][0]=18;
		stim_xy[5][0]=17;
		
		iPtrA[0]=5;
		iPtrB[0]=10;
		break;	 
				
	case 2:
		//****************
		// prime left     
		//****************
		
		stim_xy[0][0]=14;
		stim_xy[1][0]=2;
		stim_xy[2][0]=6;
		stim_xy[3][0]=18;
		stim_xy[4][0]=34;
		stim_xy[5][0]=30;
		stim_xy[6][0]=14;
		
		iPtrA[0]=A_PRIME;
		iPtrB[0]=B_PRIME;
				
		break;
		
		
	case 3:
		//****************
		// prime right    
		//****************
		
		stim_xy[0][0]=20;
		stim_xy[1][0]=32;
		stim_xy[2][0]=28;
		stim_xy[3][0]=16;
		stim_xy[4][0]=0;
		stim_xy[5][0]=4;
		stim_xy[6][0]=20;
		
		iPtrA[0]=A_PRIME;
		iPtrB[0]=B_PRIME;
		
		break;

		
	case 4:
		//****************
		// prime neutral    
		//****************
		stim_xy[0][0]=0;
		stim_xy[1][0]=6;
		stim_xy[2][0]=18;
		stim_xy[3][0]=34;
		stim_xy[4][0]=28;
		stim_xy[5][0]=16;
		stim_xy[6][0]=0;
		
		iPtrA[0]=A_PRIME;
		iPtrB[0]=B_PRIME;

		break;
		
	case 5:
		//****************
		// mask           
		//****************
		
		//outer contours
		stim_xy[0][0]=0;
		stim_xy[1][0]=6;
		stim_xy[2][0]=34;
		stim_xy[3][0]=28;
		stim_xy[4][0]=0;

		iPtrA[0]=A_MASK_OUT;
		iPtrB[0]=B_MASK_OUT;
		
		//inner contours
		stim_xy[0][1]=0;
		stim_xy[1][1]=6;
		stim_xy[2][1]=12;
		stim_xy[3][1]=20;
		stim_xy[4][1]=26;
		stim_xy[5][1]=34;
		stim_xy[6][1]=28;
		stim_xy[7][1]=22;
		stim_xy[8][1]=14;
		stim_xy[9][1]=8;
		stim_xy[10][1]=0;

		iPtrA[1]=A_MASK_IN;
		iPtrB[1]=B_MASK_IN;
		break;
		
		
	case 6:
		//****************
		// target left    
		//****************
		
		//outer contours
		stim_xy[0][0]=14;
		stim_xy[1][0]=2;
		stim_xy[2][0]=5;
		stim_xy[3][0]=33;
		stim_xy[4][0]=30;
		stim_xy[5][0]=14;
		
		iPtrA[0]=A_TARGET_OUT;
		iPtrB[0]=B_TARGET_OUT;
		
		//inner contours
		stim_xy[0][1]=14;
		stim_xy[1][1]=2;
		stim_xy[2][1]=5;
		stim_xy[3][1]=33;
		stim_xy[4][1]=30;
		stim_xy[5][1]=14;
		
		iPtrA[1]=A_TARGET_IN;
		iPtrB[1]=B_TARGET_IN;

		break;
		
		
	case 7:
		//****************
		// target right   
		//****************
		
		//outer contours
		stim_xy[0][0]=1;
		stim_xy[1][0]=4;
		stim_xy[2][0]=20;
		stim_xy[3][0]=32;
		stim_xy[4][0]=29;
		stim_xy[5][0]=1;
		
		iPtrA[0]=A_TARGET_OUT;
		iPtrB[0]=B_TARGET_OUT;
		
		//inner contours
		stim_xy[0][1]=1;
		stim_xy[1][1]=4;
		stim_xy[2][1]=20;
		stim_xy[3][1]=32;
		stim_xy[4][1]=29;
		stim_xy[5][1]=1;
		
		iPtrA[1]=A_TARGET_IN;
		iPtrB[1]=B_TARGET_IN;
		break;


	case 8:
		//****************
		// target left & mask   
		//****************
		
		//****************
		// target left   
		//****************
		
		//outer contours
		stim_xy[0][0]=14;
		stim_xy[1][0]=2;
		stim_xy[2][0]=5;
		stim_xy[3][0]=33;
		stim_xy[4][0]=30;
		stim_xy[5][0]=14;
		
		iPtrA[0]=A_TARGET_OUT;
		iPtrB[0]=B_TARGET_OUT;
		
		//inner contours
		stim_xy[0][1]=14;
		stim_xy[1][1]=2;
		stim_xy[2][1]=5;
		stim_xy[3][1]=33;
		stim_xy[4][1]=30;
		stim_xy[5][1]=14;
		
		iPtrA[1]=A_TARGET_IN;
		iPtrB[1]=B_TARGET_IN;

		//****************
		// mask           
		//****************
		
		//outer contours
		stim_xy[0][2]=0;
		stim_xy[1][2]=6;
		stim_xy[2][2]=34;
		stim_xy[3][2]=28;
		stim_xy[4][2]=0;
	
		iPtrA[2]=A_MASK_OUT;
		iPtrB[2]=B_MASK_OUT;
		
		//inner contours
		stim_xy[0][3]=0;
		stim_xy[1][3]=6;
		stim_xy[2][3]=12;
		stim_xy[3][3]=20;
		stim_xy[4][3]=26;
		stim_xy[5][3]=34;
		stim_xy[6][3]=28;
		stim_xy[7][3]=22;
		stim_xy[8][3]=14;
		stim_xy[9][3]=8;
		stim_xy[10][3]=0;
		
		iPtrA[3]=A_MASK_IN;
		iPtrB[3]=B_MASK_IN;

		break;

		
	case 9:
		//****************
		// target right & mask  
		//****************

		//****************
		// target right  
		//****************

		//outer contours
		stim_xy[0][0]=1;
		stim_xy[1][0]=4;
		stim_xy[2][0]=20;
		stim_xy[3][0]=32;
		stim_xy[4][0]=29;
		stim_xy[5][0]=1;
		
		iPtrA[0]=A_TARGET_OUT;
		iPtrB[0]=B_TARGET_OUT;
		
		//inner contours
		stim_xy[0][1]=1;
		stim_xy[1][1]=4;
		stim_xy[2][1]=20;
		stim_xy[3][1]=32;
		stim_xy[4][1]=29;
		stim_xy[5][1]=1;
		
		iPtrA[1]=A_TARGET_IN;
		iPtrB[1]=B_TARGET_IN;

		//****************
		// mask           
		//****************
		
		//outer contours
		stim_xy[0][2]=0;
		stim_xy[1][2]=6;
		stim_xy[2][2]=34;
		stim_xy[3][2]=28;
		stim_xy[4][2]=0;
	
		
		//iPtrA[0]=50;
		//iPtrB[0]=40;
		iPtrA[2]=A_MASK_OUT;
		iPtrB[2]=B_MASK_OUT;

		//inner contours
		stim_xy[0][3]=0;
		stim_xy[1][3]=6;
		stim_xy[2][3]=12;
		stim_xy[3][3]=20;
		stim_xy[4][3]=26;
		stim_xy[5][3]=34;
		stim_xy[6][3]=28;
		stim_xy[7][3]=22;
		stim_xy[8][3]=14;
		stim_xy[9][3]=8;
		stim_xy[10][3]=0;

		iPtrA[3]=A_MASK_IN;
		iPtrB[3]=B_MASK_IN;	
		break;
		
		
	case 10:
		//*********************
		// mask & prime     
		//*********************
		
		//****************
		// mask           
		//****************
		
		//outer contours
		stim_xy[0][0]=0;
		stim_xy[1][0]=6;
		stim_xy[2][0]=34;
		stim_xy[3][0]=28;
		stim_xy[4][0]=0;
			
		iPtrA[0]=A_MASK_OUT;
		iPtrB[0]=B_MASK_OUT;

		//inner contours
		stim_xy[0][1]=0;
		stim_xy[1][1]=6;
		stim_xy[2][1]=12;
		stim_xy[3][1]=20;
		stim_xy[4][1]=26;
		stim_xy[5][1]=34;
		stim_xy[6][1]=28;
		stim_xy[7][1]=22;
		stim_xy[8][1]=14;
		stim_xy[9][1]=8;
		stim_xy[10][1]=0;
		
		iPtrA[1]=A_MASK_IN;
		iPtrB[1]=B_MASK_IN;
		
		//*********************
		// prime left     
		//*********************
		
		stim_xy[0][2]=14;
		stim_xy[1][2]=2;
		stim_xy[2][2]=6;
		stim_xy[3][2]=18;
		stim_xy[4][2]=34;
		stim_xy[5][2]=30;
		stim_xy[6][2]=14;
		
		iPtrA[2]=A_PRIME;
		iPtrB[2]=B_PRIME;

		//****************
		// prime right    
		//****************
		
		stim_xy[0][3]=20;
		stim_xy[1][3]=32;
		stim_xy[2][3]=28;
		stim_xy[3][3]=16;
		stim_xy[4][3]=0;
		stim_xy[5][3]=4;
		stim_xy[6][3]=20;
				
		iPtrA[3]=A_PRIME;
		iPtrB[3]=B_PRIME;
		
		break;
		
	

	 }
	 
	 
	 
	 //********************************************************
	 //in this loop, the points of the stimulus are calculated 
	 //from the stimulus parameters given in stim_xy           
     //                                                           
	 // if STIM_TYPE is blank, fix, or prime,                  
	 // the outer loop is calculated only once (NUM_PAGE=1)    
	 // (for outer contours);                                  
	 // if STIM_TYPE is mask or target,                        
	 // the next loop is calculated twice (NUM_PAGE=2)         
	 // (for outer and inner contours);                        
	 //********************************************************
	 
	 
	 
	 for (page = 0; page<SDsd.iNumPages; page++) 
	 {
		 for (i=0; i<SDsd.iNumPoints[page]; i++) 
		 {
			 offset_x[i][page]=(stim_xy[i][page]%7)-3;
			 offset_y[i][page]=(stim_xy[i][page]/7)-2;
			 
			 switch(abs(offset_x[i][page]))
			 {
			 case 1:
				 offset_x[i][page]=iPtrA[page]*offset_x[i][page];
				 break;
				 
			 case 2:
				 offset_x[i][page]=(iPtrA[page]+iPtrB[page]/2)*offset_x[i][page]/2;
				 break;
				 
			 case 3:
				 offset_x[i][page]=(iPtrA[page]+iPtrB[page])*offset_x[i][page]/3;
				 break;
			 }
			 
			 offset_y[i][page]=iPtrB[page]*offset_y[i][page]/2;
		 } 
     }
	 
	 //FREE DYNAMICALLY ALLOCATED MEMORY
	 free(iPtrA);
	 free(iPtrB);
}


