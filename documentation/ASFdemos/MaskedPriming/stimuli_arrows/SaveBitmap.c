#include <windows.h>
#include "DibHelp.h"
#include "Definitions.h"
extern HBITMAP hBitMap;
void SaveBitmap(HWND hWnd, HBITMAP hbm, TCHAR *szFileName)
{
	//HWND hWnd;
	HDC hDC, hDCMemSource, hDCMemTarget;
	HDIB hMyDIB;
	HBITMAP hMyDIBBitmap;

	//hWnd = GetActiveWindow();
	hDC = GetDC(hWnd);
	hDCMemSource = CreateCompatibleDC(hDC);
	hDCMemTarget = CreateCompatibleDC(hDC);

	hMyDIB = DibCreate(BITMAP_X, BITMAP_Y, 1, 0);
	hMyDIBBitmap = DibBitmapHandle(hMyDIB);
	
	SelectObject(hDCMemSource, hbm);
	SelectObject(hDCMemTarget, hMyDIBBitmap);
	
	PatBlt(hDCMemTarget, 0, 0, BITMAP_X, BITMAP_Y, WHITENESS);
	
	
	BitBlt(hDCMemTarget, 0, 0, BITMAP_X, BITMAP_Y, hDCMemSource, 0, 0, SRCCOPY);
	DibFileSave(hMyDIB, szFileName);	

	ReleaseDC(hWnd, hDC);
	DeleteDC(hDCMemSource);
	DeleteDC(hDCMemTarget);

	
}