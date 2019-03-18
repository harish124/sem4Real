#include<stdio.h>
#include<stdlib.h>

typedef struct directoryNode
{

     int directoryName;
     int filecount;

    char fileName[100];

}directoryNode;

int main(void)
{
     int directoryCount, i, n, flag, c;
     char temp, key[100];
     printf("\nEnter the number of files: ");
     scanf("%d", &directoryCount);

     directoryNode directory[directoryCount];

     for(i=0; i<directoryCount; i++)
     {
        directory[i].directoryName = i;
     }

     printf("\nEnter the file names: ");
     for(i=0; i<directoryCount; i++)
     {
         printf("\nFile[%d]: ", i+1);
         scanf("%s", directory[i].fileName);
     }
     printf("STRUCTURE:\n");
     for(i=0; i<directoryCount; i++)
     {
         printf("Dir[%d] -> %s\n", directory[i].directoryName +1,
        directory[i].fileName);
     }
     repeat:
         flag = 0;
         printf("\nEnter the file you want to get the path of:");
         scanf("%s", &key);

         for(i=0; i<directoryCount; i++)
         {
             if(strcmpi(key, directory[i].fileName) ==0)
             {
                 flag = 1;
                 printf("Dir[%d] -> %s\n",
                directory[i].directoryName+1, directory[i].fileName);
             }
         }

         if(flag == 0)
            printf("\nFile not found!");

         printf("\nDo you want to get more file locations?(1/0): ");
         scanf("%d", &c);

         if(c)
            goto repeat;
     return 0;
}
