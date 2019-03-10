#include<stdio.h>
#include<sys/stat.h>
#include"E:\B.Harish\Sem 4\Os\Lab\Header files for ipc,shm\ipc.h"
#include<unistd.h>
#include<stdlib.h>

int main()
{
    int pid;
    char *a,*b,c;
    int id,n,i;

    id=shmget(111,50,IPC_CREAT|0666);
}//emg
