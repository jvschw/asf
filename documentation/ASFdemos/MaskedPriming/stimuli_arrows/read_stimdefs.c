#include <stdlib.h>
#include <stdio.h>
#include "definitions.h"

// READ TEXTFILE WITH STIMULUS DEFINITIONS
// DYNAMICALLY ALLOCATE SPACE FOR STIMULUS-DEFINITION-ARRAY
//FILE FORMAT
//NUMBER OF DEFINITIONS
// NUMPAGES[FIRSTDEFINITION] NUMPOINTS[FIRSTPAGE] ... NUMPOINTS[LASTPAGE]
//...
// NUMPAGES[LASTDEFINITION] NUMPOINTS[FIRSTPAGE] ... NUMPOINTS[LASTPAGE]
//EXAMPLE: stimuli.dat
// 7
// 1 7
// 1 7
// 1 7
// 1 7
// 2 5 11
// 2 6 6
// 2 6 6

struct STIMDEF * read_stimdefs_dyna(char *szFileName)
{
	FILE *in;
	int iNumStim, i, j, k;
	struct STIMDEF *SDStimDef;

	if((in = fopen(szFileName, "r")) == NULL)
	{
		//MSGBOX ERR
		exit(-1) ;
	}
	else
	{
		//READ NUMBER OF STIMULUS DEFINITIONS
		fscanf(in, "%d", &iNumStim);

		//ALLOCATE MEMORY FOR GLOBAL VARIABLE STIMDEF
		SDStimDef = malloc(sizeof(struct STIMDEF)*iNumStim);

		//READ DEFINITIONS
		for(i = 0; i < iNumStim; i++)
		{
			//HOW MANY PAGES?
			fscanf(in, "%d", &SDStimDef[i].iNumPages);

			//NUMBER OF POINTS FOR EACH PAGE
			for(j = 0; j < SDStimDef[i].iNumPages; j++)
				fscanf(in, "%d", &SDStimDef[i].iNumPoints[j]);
		
			//FILLCOLOR FOR EACH PAGE
			for(k = 0; k < SDStimDef[i].iNumPages; k++)
				fscanf(in, "%d", &SDStimDef[i].fcolor[k]);
		

		}

	}
	fclose(in);
	return SDStimDef;


}