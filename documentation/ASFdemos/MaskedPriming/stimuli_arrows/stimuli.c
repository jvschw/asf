//-----------------------------------------
//STIMULI.C -- Draws stimuli to screen
//(c) Angelika, 12-2001
//-----------------------------------------

#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "definitions.h"
#include "calc_stim.h"
#include "SaveBitmap.h"
#include "read_stimdefs.h"



#define WM_SAVE_BITMAP WM_USER+2


//void Show (HWND hwnd, int x_mid, int y_mid, int x_mid_off, int y_mid_off, int offset_x[NUM_POINTS][NUM_PAGES], int offset_y[NUM_POINTS][NUM_PAGES]);
//void Show (HWND hwnd, HBITMAP hBitMap, int x_mid, int y_mid, int x_mid_off, int y_mid_off, int offset_x[NUM_POINTS][NUM_PAGES], int offset_y[NUM_POINTS][NUM_PAGES]);
//void Show (int iStimulus, HWND hwnd, HBITMAP hBitMap, int x_mid, int y_mid, int x_mid_off, int y_mid_off, int offset_x[NUM_POINTS][NUM_PAGES], int offset_y[NUM_POINTS][NUM_PAGES]);
void Show (int iStimulus, struct STIMDEF SDsd, HWND hwnd, HBITMAP hBitMap, int x_mid, int y_mid, int x_mid_off, int y_mid_off, int offset_x[MAXPOINTS][MAXPAGES], int offset_y[MAXPOINTS][MAXPAGES]);


LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM) ;



int offset_x[MAXPOINTS][MAXPAGES];	 //array that specifies offset of each point from midpoint (x) 		
int offset_y[MAXPOINTS][MAXPAGES];    //array that specifies offset of each point from midpoint (y) 
int x_mid=X_MID;				         //calculate midpoint (x)
int y_mid=Y_MID;				             //calculate midpoint (y)

int x_mid_off=X_MID+MIDOFF_X;           //calculate changed midpoint (x);               
int y_mid_off=Y_MID+MIDOFF_Y;           //calculate changed midpoint (y):



/*
struct STIMDEF SDStimDef[7] = {
	    1, 7, 0, 
		1, 7, 0,
		1, 7, 0,
		1, 7, 0,
		2, 5, 11, 
		2, 6, 6,
		2, 6, 6};
*/

//GLOBAL POINTER TO STIMULUS DEFINITIONS
struct STIMDEF *SDStimDef;
	
	HBITMAP hBitMap;
	HDC hdc;
	
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
		//static BITMAPFILEHEADER * pbmfh ;
		//static BITMAPINFO       * pbmi ;
		//static BYTE             * pBits, *pBitsNew ;
		static int                cxClient, cyClient, cxDib, cyDib ;
		static TCHAR              szFileName [MAX_PATH], szTitleName [MAX_PATH] ;
//		BOOL                      bSuccess ;
		static iStimulus = -1;
		
		
		switch (message)
		{
			
		case WM_CREATE:
			SDStimDef = read_stimdefs_dyna("stimuli.dat");
			//read_stimdefs("stimuli.dat");
			return 0;
			
			
			//case WM_UP:
			
			return 0 ;
			
		case WM_SAVE_BITMAP:
			return 0 ;
			
		case WM_KEYDOWN:
			if(++iStimulus > 10)    //!!!!!!!!!!!!!!!!!!calculate iNumStimulus
				iStimulus = 0;
			hdc = GetDC(hwnd);
			
			hBitMap = CreateCompatibleBitmap(hdc, BITMAP_X, BITMAP_Y);//CreateBitmap(1024, 768, 1, 1, 0);
			
			calc_stim(iStimulus, SDStimDef[iStimulus]); 
			Show (iStimulus, SDStimDef[iStimulus], hwnd, hBitMap, x_mid, y_mid, x_mid_off, y_mid_off, offset_x, offset_y);
			sprintf(szFileName, "stim_%02d.bmp", iStimulus);
			SaveBitmap(hwnd, hBitMap, szFileName);			
			ReleaseDC(hwnd, hdc);
			DeleteObject(hBitMap);
			return 0 ;
			
			
		case WM_DESTROY:
			//DEALLOCATE STIMULUS DEFINITION SPACE
			free(SDStimDef);

			PostQuitMessage (0) ;
			return 0 ;
		}
		return DefWindowProc (hwnd, message, wParam, lParam) ;
	}
	
	
	
	
	void Show (int iStimulus, struct STIMDEF SDsd, HWND hwnd, HBITMAP hBitMap, int x_mid, int y_mid, int x_mid_off, int y_mid_off, int offset_x[MAXPOINTS][MAXPAGES], int offset_y[MAXPOINTS][MAXPAGES])
	{
		
		HDC hdc, hdcMem;
		int iPoint;
		int iPage;
		
		POINT apt [MAXPOINTS];
		
		hdc = GetDC (hwnd);

		
		
		hdcMem = CreateCompatibleDC(hdc);
		SelectObject(hdcMem, hBitMap);
		//BitBlt(hdcMem, 0, 0, 1024, 768, hdcMem, 0, 0, WHITENESS); //ERASE BITMAP
		PatBlt(hdcMem, 0, 0, BITMAP_X, BITMAP_Y, WHITENESS);
		
		

		//draw each page for each stimulus
		for (iPage=0; iPage<SDsd.iNumPages; iPage++)
		{
			//if outer contours:
			//SelectObject (hdcMem, GetStockObject (BLACK_BRUSH));
			//if inner contours:
			//SelectObject (hdcMem, GetStockObject (WHITE_BRUSH));
			
			if(FILLMODE==1)
			{
				switch(SDsd.fcolor[iPage])			
				{
				case 0:
					SelectObject (hdcMem, GetStockObject (WHITE_BRUSH));
					break;
				case 1:
					SelectObject (hdcMem, GetStockObject (BLACK_BRUSH));
					break;
				}
			}

			for (iPoint=0; iPoint<SDsd.iNumPoints[iPage]; iPoint++)
			{
				apt[iPoint].x=x_mid_off+offset_x[iPoint][iPage];
				apt[iPoint].y=y_mid_off+offset_y[iPoint][iPage];
			}    
			
			Polygon(hdcMem, apt, SDsd.iNumPoints[iPage]);
			
		}
		

		
		BitBlt(hdc, 0, 0, BITMAP_X, BITMAP_Y, hdcMem, 0, 0, SRCCOPY);

	
		
		//ReleaseDC(hwnd, hdcMem);
		ReleaseDC(hwnd, hdc); 
		
		DeleteDC(hdcMem);		
}
