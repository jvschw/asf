#ifndef _DEFINITIONSH
#define _DEFINITIONSH


//#define SCALE_OUT 1	// scales size of outer contour 
//#define SCALE_IN  1    // scales size of inner contour 

#define MIDOFF_X  0		// offset from midpoint, direction x 
#define MIDOFF_Y  -100 	// offset from midpoint, direction y 
//small
//#define CROSS_SIZE 6	// cross size (pixel offset from midpoint)
#define CROSS_SIZE 9	// cross size (pixel offset from midpoint)
 

#define BITMAP_X 1024
#define BITMAP_Y 768
//#define BITMAP_X 800
//#define BITMAP_Y 600
#define X_MID (BITMAP_X/2)
#define Y_MID (BITMAP_Y/2)

//#define STIM_TYPE 6     // see table 	
//#define NUM_PAGES 2		// number of pages of the stimulus; see table 
//#define NUM_POINTS 6	// number of points specifying the stimulus; see table 
#define MAXPOINTS 12
#define MAXPAGES 5					


//large
//#define A_PRIME 38		//pay attention to A_MASK_IN !
//#define B_PRIME 30		//pay attention to B_MASK_IN !      

//medium
//#define A_PRIME 28			//pay attention to A_MASK_IN !
//#define B_PRIME 21			//pay attention to B_MASK_IN !      


//small (original)
#define A_PRIME 18			//pay attention to A_MASK_IN !
#define B_PRIME 14			//pay attention to B_MASK_IN !      



//large
//#define A_MASK_OUT 46
//#define B_MASK_OUT 44

//medium
#define A_MASK_OUT 35
#define B_MASK_OUT 33


//small (original)
//#define A_MASK_OUT 23
//#define B_MASK_OUT 22



//large
//#define A_MASK_IN 39		//pay attention to A_PRIME !
//#define B_MASK_IN 30		//pay attention to B_PRIME !

//medium
#define A_MASK_IN 29		//pay attention to A_PRIME !
#define B_MASK_IN 21		//pay attention to B_PRIME !

//small (original)
//#define A_MASK_IN 19		//pay attention to A_PRIME !
//#define B_MASK_IN 14		//pay attention to B_PRIME !



//large
//#define A_TARGET_OUT 98
//#define B_TARGET_OUT 78

//medium
#define A_TARGET_OUT 74
#define B_TARGET_OUT 59


//small
//#define A_TARGET_OUT 49
//#define B_TARGET_OUT 39


//large
//#define A_TARGET_IN 90
//#define B_TARGET_IN 64

//medium
#define A_TARGET_IN 68
#define B_TARGET_IN 48


//small (original)
//#define A_TARGET_IN 45
//#define B_TARGET_IN 32



#define FILLMODE 1			//0: without filling
							//1: filled

						
//////////////////////////////////////////////////////////////////////////
//STIM_TYPE				iNumPages	iNumPoints	fcolor(0=white, 1=black)
//blank					1			1			0
//fix					1			6			1	
//prime left			1			7			1
//prime right			1			7			1
//prime neutral			1			7			1
//mask					2			5 11		1 0
//target left			2			6 6			1 0
//target right			2			6 6			1 0
//target left  & mask	4			6 6 5 11	1 0 1 0
//target right & mask 	4			6 6 5 11	1 0 1 0
//test: mask & primes	4			5 11 7 7	1 0 1 1
//////////////////////////////////////////////////////////////////////////	

typedef struct STIMDEF
{
	int iNumPages;
	int iNumPoints[MAXPAGES];
	int fcolor[MAXPAGES];
};

#endif



