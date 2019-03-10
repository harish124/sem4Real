#include<stdio.h>
#include<stdlib.h>

int main()
{
    int n=0;
    printf("\nEnter the no. of resources: ");
    scanf("%d",&n);

    int resource[n];
    for(int i=0;i<n;i++)
    {
        printf("\nEnter the no. of instances of Resource R%d: ",i+1);
        scanf("%d",&resource[i]);
    }

    int p=0;
    printf("\nEnter the no. of processes: ");
    scanf("%d",&p);

    int avail[n];
    int max[p][n];
    int alloc[p][n];
    max[0][0]=p;
    alloc[0][0]=n;

    /*max[0][0]=7;max[0][1]=5;max[0][2]=3;
    max[1][0]=3;max[1][1]=2;max[1][2]=2;
    max[2][0]=9;max[2][1]=0;max[2][2]=2;
    max[3][0]=2;max[3][1]=2;max[3][2]=2;
    max[4][0]=4;max[4][1]=3;max[4][2]=3;

    alloc[0][0]=0;alloc[0][2]=0;alloc[0][1]=1;
    alloc[1][0]=2;alloc[1][2]=0;alloc[1][1]=0;
    alloc[2][0]=3;alloc[2][2]=2;alloc[2][1]=0;
    alloc[3][0]=2;alloc[3][2]=1;alloc[3][1]=1;
    alloc[4][0]=0;alloc[4][2]=2;alloc[4][1]=0;*/

    //*************************************************
    printf("\nInput the values for Max Matrix:\n");
    for(int i=0;i<p;i++)
    {
        for(int j=0;j<n;j++)
        {
            printf("\nEnter the val for max[%d][%d] :",i,j);
            scanf("%d",&max[i][j]);
        }
    }
    printf("\nInput the values for Alloc. Matrix:\n");
    for(int i=0;i<p;i++)
    {
        for(int j=0;j<n;j++)
        {
            printf("\nEnter the val for alloc[%d][%d] :",i,j);
            scanf("%d",&alloc[i][j]);
        }
    }
    //*************************************************

    int need[p][n];
    printf("\nComputing the Need Matrix\n");
    for(int i=0;i<p;i++)
    {
        for(int j=0;j<n;j++)
        {
            need[i][j]=max[i][j]-alloc[i][j];
        }
    }

    //***********************************

    printf("\nPrinting Alloc. , Max & Need matrices below:\n");

    printf("\n  \tAllocation\tMax\t\tNeed");
    printf("\n  \tA B C\t\tA B C\t\tA B C");
    for(int i=0;i<p;i++)
    {

        printf("\nP%d\t",i);
        for(int j=0;j<n;j++)
        {
            printf("%d ",alloc[i][j]);
        }
        printf("    \t");
        for(int j=0;j<n;j++)
        {
            printf("%d ",max[i][j]);
        }
        printf("    \t");
        for(int j=0;j<n;j++)
        {
            printf("%d ",need[i][j]);
        }
    }
    printf("\n");
    //************************************
    //Calculating Available below:

    for(int i=0;i<n;i++)
    {
        int s=0;
        for(int j=0;j<p;j++)
        {
            s+=alloc[j][i];
        }
        avail[i]=resource[i]-s;
    }

    printf("\nPrinting Avail. Sequence Below:\n");
    for(int i=0;i<n;i++)
    {
        printf("%d ",avail[i]);
    }
    printf("\n");
    //Forming Safety Seq. below
    int index=0;
    int safety[p];
    int itr=0;
    int count=0;
    while(index<=n)
    {
        for(int i=0;i<p;i++)
        {
            count=0;
            for(int j=0;j<n;j++)
            {
                if(need[i][j]<=avail[j])
                {
                    count++;
                }
            }

            if(count==n)
            {
                need[i][0]=999;
                printf("\nS--->%d",i);
                safety[index++]=i;
                for(int x=0;x<n;x++)
                {
                    avail[x]+=alloc[i][x];
                }
                printf("\nPrinting Avail. Sequence Below:\n");
                for(int i=0;i<n;i++)
                {
                    printf("%d ",avail[i]);
                }
                printf("\n");
            }
        }
        itr++;
        if(itr>50)      //just stopping after some 50 iterations...
        {
            break;
        }
    }


    printf("\nPrinting Safety Sequence Below:\n");
    if(index==p)
    {
        int i=0;
        printf("< ");
        for(i=0;i<p-1;i++)
        {
            printf("P%d , ",safety[i]);
        }
        printf("P%d  ",safety[i]);
        printf(" >\n");
    }
    else
    {
        printf("\nNo safety sequence available...\n");
    }


}//emg
