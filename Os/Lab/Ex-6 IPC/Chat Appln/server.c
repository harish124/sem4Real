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

int find(char *a)
{
    int l=strlen(a);
    if(a[l-1]=='#')
    {
        //printf("\nClient Turn\n");
        return 1;   // '#' is used to identify a client
    }
    //printf("\nServer Turn\n");
    return 0;   // '@' is used to identify a server.
}
void changeTurn(char *a)
{
    int l=strlen(a);
    if(a[l-1]=='#') //if client turn to server
    {
        //printf("\nLine 1");
        a[l-1]='@';
        return ;
    }
    if(a[l-1]=='@') //if server turn to client
    {
        //printf("\nLine 2");
        a[l-1]='#';
        return ;
    }
}

int main()
{
    int id=0;
    char *a;
    char buff[100];

    id=shmget(124,50,IPC_CREAT | 0666);
    a=shmat(id,NULL,0);

    int j=1;
    //Initially its the turn of the client.
    while(1==1)
    {
        if(strcmp(a,"end@")==0)
        {
            printf("\nChat Terminated\n");
            exit(0);
        }

        if(find(a)==0)     //meaning if server turn
        {
            if(a!=NULL)
            {
                puts(a);
            }
            printf("\nServer: ");
            gets(a);
            strcat(a,"@");

            changeTurn(a);
            if(strcmp(a,"end#")==0)
            {
                printf("\nChat Terminated\n");
                exit(0);
            }
            printf("\n(Turn: Client)\n");
        }
    }
}//emg
