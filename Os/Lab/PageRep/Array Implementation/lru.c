#include <stdio.h>

int findLru(int arrivalTime[],int size)
{
    int pos=0;
    int min=arrivalTime[0];

    for(int i=0;i<size;i++)
    {
        if(arrivalTime[i]<min)
        {
            min=arrivalTime[i];
            pos=i;
        }
    }

    return pos;
}//efindLru

int main()
{
    int pageRefSize=0,pageRef[20];
    int no_frames=0,frames[20];
    int arrivalTime[20],counter;
    int pagefaults=0;

    printf("\nEnter the pageRefString size: ");
    scanf("%d",&pageRefSize);
    printf("\nEnter the no. of frames to be allocated: ");
    scanf("%d",&no_frames);

    printf("\nEnter the page ref. string: ");
    for(int i=0;i<pageRefSize;i++)
    {
        scanf("%d",&pageRef[i]);
    }

    //Initializing the frames with -1
    for(int i=0;i<no_frames;i++)
    {
        frames[i]=-1;
    }

    int empty=0,found=0;     //empty means frames are there and pages can be placed without replacement
                            //full means
    for(int i=0;i<pageRefSize;i++)
    {
        found=0;
        for(int j=0;j<no_frames;j++)
        {
            if(frames[j]==pageRef[i])
            {
                counter++;
                arrivalTime[j]=counter;
                found=1;
                break;
            }
        }
        if(found)
        {
            continue;       //continue with the next i value
        }
        if(empty!=no_frames)
        {
            for(int j=0;j<no_frames;j++)
            {
                if(frames[j]==-1)       //allocate the pages to the empty frames
                {
                    empty++;
                    frames[j]=pageRef[i];
                    counter++;
                    pagefaults++;
                    arrivalTime[j]=counter;
                    break;
                }
            }
        }
        else        //no empty frames are available so replacement has to be done
        {
            int pos=findLru(arrivalTime,no_frames);
            counter++;
            pagefaults++;
            frames[pos]=pageRef[i];
            arrivalTime[pos]=counter;

        }

        printf("\n");

    	for(int j = 0; j < no_frames; j++){
    		printf("%d\t", frames[j]);
    	}
    }

    printf("\n\nTotal Page Faults = %d", pagefaults);
}//emg
