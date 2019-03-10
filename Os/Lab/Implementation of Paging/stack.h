#include<stdio.h>

int top=-1;
int len=0;
int st[100];        //st = freeFrameList
void initfreeFrameList(int size)
{
    for(int i=0;i<size;i++)
    {
        st[i]=0;
    }
    len=size;
}
void push(int val)
{
    if(top==len-1)
    {
        printf("\nEnough memory already available\n");
        return ;
    }
    else
    {
        st[++top]=val;
    }

}//epush

int pop()
{
    if(top==-1)
    {
        printf("\nNot enough memory available...\n");
        return -1;
    }
    else
    {
        return st[top--];
    }
}
