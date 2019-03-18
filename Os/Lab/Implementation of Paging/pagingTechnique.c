#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include "E:\B.Harish\Sem 4\Os\Lab\Implementation of Paging\stack.h"

typedef struct page
{
    int pageNo;
    int frame;
}page;

typedef struct node
{
    int pno;    //process no.
    int n;      //no. of pages
    page *arr[100];   // a process will contain an array of pages
}process;

typedef struct nodept
{
    process *p;
    int pno;        //Process Number
    struct nodept *next;
}pageTable;

pageTable *pt;     // a pagetable will contain an array of process

void init(int ram[])
{
    double x=3.5;
    int n=ram[0];
    initfreeFrameList(n/2);             //initializing the stack in the stack.h file.

    for(int i=0;i<n/2;i++)
    {
        ram[(int)(x*i)]=0;
        push((x*i));        //pushing the free frames into the stack.
    }

}//einit

process *requestPr(int pno)
{

    int n=0;
    printf("\nEnter the no. of pages: ");
    scanf("%d",&n);

    if(n>top+1)
    {
        printf("\nNot enough memory available...\n");
        return NULL;
    }
    process *new_node=(process *)malloc(sizeof(process));
    new_node->pno=pno;
    new_node->n=n;
    while(n-1>=0)
    {
        page *new_page=(page *)malloc(sizeof(page));
        new_page->frame=pop();
        new_page->pageNo=n;
        new_node->arr[n]=new_page;
        n--;
    }
    return new_node;
}//erequest

pageTable *addProcess(int pno,process *rt)
{
    pageTable *new_node=(pageTable *)malloc(sizeof(pageTable));
    new_node->p=rt;
    new_node->next=NULL;
    new_node->pno=pno;
    if(pt==NULL)
    {
        pt=new_node;
        return pt;
    }
    else
    {
        pageTable *ptr=pt;
        while(ptr->next!=NULL)
        {
            ptr=ptr->next;
        }
        ptr->next=new_node;
        return pt;
    }
}//eaddProcess

pageTable *deallocation(int pno,pageTable *pt)
{
    pageTable *ptr=pt,*preptr=pt;
    while(ptr!=NULL)
    {
        if(ptr->pno!=pno)
        {
            preptr=ptr;
            ptr=ptr->next;
            continue;
        }
        else
        {
            //printf("\nLine Worked\n");
            process *p=ptr->p;    //p is a single process
            int n=p->n;
            while(n>0)
            {
                push(p->arr[n]->frame);     //arr[n] is a page,which contains pageNo & frame to which it is allocated.
                n--;
            }//.....................................Boundary conditions for deleting the linked list.
            if(ptr==pt)
            {
                if(ptr->next!=NULL)
                {
                    pt=ptr->next;
                    free(ptr);
                    return pt;
                }
                if(ptr->next==NULL)
                {
                    free(ptr);
                    return NULL;
                }
            }

            preptr->next=ptr->next;
            free(ptr);
            break;
        }//else

        preptr=ptr;
        ptr=ptr->next;
    }//ewhile
}//edealloc

void pageDisplay(pageTable *pt)
{
    pageTable *ptr=pt;

    while(ptr!=NULL)
    {
        printf("\n-----------Process:  P%d-----------\n",ptr->pno);
        process *p=ptr->p;
        int n=0;
        n=p->n;
        while(n-1>=0)
        {
            printf("PageNo = %d\tFrame No = %d\n",p->arr[n]->pageNo,p->arr[n]->frame);
            n--;
        }
        ptr=ptr->next;
    }
}//epageTableDisplay

void displayFreeFrameList()
{
    printf("\nFree Frame List Below:\n");
    printf("\nFreeFrameListSize = %d\n",len);       //len is from stack.h
    if(top==-1)
    {
        printf("\nAll the frames are utilized...\n");
        return;
    }
    for(int i=top;i>=0;i--)
    {
        printf("%d ",st[i]);
    }
    printf("\n");
}//edisplayFreeFrameList

int main()
{
    int memSize=0;      //Memory is collection of frames
    int pageSize=0;
    //(Note: pagesize is = framesize)
    printf("\nEnter the memory size( in kilo-bytes): ");
    scanf("%d",&memSize);

    printf("\nEnter the page size( in kilo-bytes): ");
    scanf("%d",&pageSize);

    int ram[memSize];
    ram[0]=memSize;
    init(ram);

    process *rt=(process *)malloc(sizeof(process));

    int ch=0;
    while(1==1)
    {
        printf("\nPress:\n1:Request Process\n2:Deallocation\n3:Page Table for all processes\n4:Free Frame List\nAny other no. to exit\n");
        scanf("%d",&ch);

        int pno=0;
        switch(ch)
        {
        case 1:

            printf("\nEnter the process no: ");
            scanf("%d",&pno);
            rt=requestPr(pno);
            if(rt!=NULL)
            {
                pt=addProcess(pno,rt);
            }
            break;

        case 2:
            printf("\nEnter the process no: ");
            scanf("%d",&pno);
            pt=deallocation(pno,pt);
            break;
        case 3:
            pageDisplay(pt);
            break;
        case 4:
            displayFreeFrameList();
            break;
        default:
            exit(0);
        }
    }//eswitch
}//emg
