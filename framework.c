/*Project Name: johnsey_program2										*/
/*File Name:	framework.c												*/
/*Modifications to Original Program made by Hayley Johnsey				*/
/*Date:			10-26-18												*/

#include <windows.h>
#include <stdio.h>

/*disables warning for strcpy use*/
#pragma warning(disable : 4996)

void getInput(char* inputPrompt, char* result, int maxChars)
{
	// use a "C" text input call
	puts(inputPrompt);
	gets(result);
}

void showOutput(char* outputLabel, char* outputString)
{
	printf("%s %s\n", outputLabel, outputString);
}

int sieve();

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
	LPSTR lpCmdLine, int nCmdShow)
{
	AllocConsole();
	freopen("CONIN$", "rb", stdin);
	freopen("CONOUT$", "wb", stdout);

	return sieve();
}