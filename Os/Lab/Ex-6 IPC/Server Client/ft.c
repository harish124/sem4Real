#include <sys/ipc.h>
# define NULL 0
#include <sys/shm.h>
#include <sys/types.h>
# include<unistd.h>
# include<stdio.h>
# include<stdlib.h>
# include<string.h>
#include <sys/wait.h>
#include <stdio_ext.h>
#include<ctype.h>

int main()
{
	char *b;
	int id;
	char buf[1024];
	FILE * fp;
	sleep(5);
	id=shmget(111,50,IPC_CREAT|0666);
	b=shmat(id,NULL,0);
	
	printf("\nFile received %s\n",b);
	
	fp=fopen(b,"r");
	if(fp!=NULL)
	{
		fscanf(fp,"%[^t]s",buf);
		strcpy(b,buf);
		printf("%s",b);
		fclose(fp);
	}
	else
	{
		printf("\nFile not found");
	}
	shmdt(b);
}//emg
