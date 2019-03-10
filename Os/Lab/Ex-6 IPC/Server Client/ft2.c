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
	char *a,dest[30];
	int id,len;
	FILE *fp;
	
	id=shmget(111,50,IPC_CREAT|0666);
	a=shmat(id,NULL,0);

	char *start=a;
	printf("\nFIle to be sent");
	scanf("%s",a);
	
	sleep(5);
	
	printf("\nEnter the destination:");
	scanf("%s",dest);
	fp=fopen(dest,"w");
	
	if(fp==NULL)
	{
		printf("The file cannot be opened or created");
		exit(0);
	}
	
	printf("%s",a);
	fprintf(fp,"%s",a);
	
	fclose(fp);
	shmdt(a);
	
	return 0;
	
}//emg
