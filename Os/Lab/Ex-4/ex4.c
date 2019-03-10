#include <stdio.h>
#include <string.h>
#include<stdlib.h>

int main()
{
    int n=0;
    printf("\nEnter the no. of process: ");
    scanf("%d",&n);
    int bt[100]; //used to hold the burst time of the processes
    int arrival[100];//denotes arrival time
    int service[100];//denotes the service time
    int wt[100];//denotes waiting time
    int tat[100];//denotes turnAroundTime
    double avtat=0.0;//denotes avg. tat
    double avwt=0.0;// denotes avg. wt

    int btCopy[100];
    //Input the burst time
    for (int i=0;i<n;i++)
    {   printf("\nEnter the Burst/Execution time for the process %d\n",i);
        scanf("%d",&bt[i]);
        btCopy[i]=bt[i];
        arrival[i]=i;
    }

    int sml=bt[0];//to find the process with min bt time , this is used for sjf algorithm
    int pos=0;
    int firstTimeRunning=0;//used for sjf algorithm
    int prevPos=0;//used for sjf algorithm

    printf("\nPress:\n1:FCFS (FIRST COME FIRST SERVE)\n2:SJF (SHORTEST JOB FIRST)\nAny other no. to exit.\n");
    int ch=0;
    scanf("%d",&ch);

    switch(ch)
    {
    case 1:
        //Calculating service time below
        service[0]=0; //st for process p[0] = 0

        for(int i=1;i<n;i++)
        {
            service[i]=bt[i-1]+service[i-1];
        }


        break;
    case 2:

        FIND_MIN:       pos=0;
                        for(int i=1;i<n;i++)
                        {
                            sml=btCopy[0];
                            if(sml>btCopy[i])
                            {
                                sml=btCopy[i];
                                pos=i;
                            }
                        }
                        firstTimeRunning++;

        if(firstTimeRunning==1)
        {
            printf("\nEntered\n");
            service[pos]=0;
            prevPos=pos;

        }
        else
        {
            service[pos]=service[prevPos]+bt[prevPos];
            prevPos=pos;
        }

        btCopy[pos]=9999;
        if(firstTimeRunning<n)
        {
            goto FIND_MIN;
        }
    break;
    default:exit(0);

    }//eswitch

    //Calculating wait time = (service time - arrival time) & turnAroundTime = bt[i]+wt[i]
    wt[0]=0;
    tat[0]=bt[0]+wt[0];
    avtat+=tat[0];
    avwt+=wt[0];
    for(int i=0;i<n;i++)
    {
        if(service[i]==0)
        {
            wt[i]=0;
            continue;
        }
        wt[i]=service[i]-arrival[i];
        tat[i]=bt[i]+wt[i];
        avtat+=tat[i];
        avwt+=wt[i];
    }

    avtat/=n;
    avwt/=n;

    //Printing the details below:

    printf("\nProcess Name:\tArrival Time\tBurst/Execution Time\tService Time\t\n");
    for(int i=0;i<n;i++)
    {
        printf("P[%d]\t\t\t%d\t\t\t%d\t\t%d\t\n",i,arrival[i],bt[i],service[i]);
    }

    printf("\nAvg.TurnAroundTime = %.2f",avtat);
    printf("\nAvg.Waiting time = %.2f",avwt);


}//emg
