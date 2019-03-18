#include<stdio.h>
typedef struct masternode
{
     char mastername[10];
     struct usernode
     {
         char username[100];
         int filecount;
         struct filenode
         {
            char filename[100];
         }file[10];

     }user;
 //struct node* next;
}masternode;
int main(void)
{
     int mastercount, i, j, temp, choice, flag=0;
     char key[100], tempkey[100];

     printf("\nEnter the number of masters: ");
     scanf("%d", &mastercount);

     masternode master[mastercount];
     printf("\nEnter the names of the %d masters: ",mastercount);

     for(i=0; i<mastercount; i++)
        scanf("%s", &master[i].mastername);

     printf("\nThe masters are: ");
     for(i=0; i<mastercount; i++)
        printf("%s ", master[i].mastername);

     printf("\nEnter the names of the %d users: ",mastercount);

     for(i=0; i<mastercount; i++)
     {
     /* j=0;
     do
     {
     scanf("%c", &master[i].user.username[j]);
     temp = j;
     j++;
     }while(master[i].user.username[temp] != '\0');*/
     scanf("%s", &master[i].user.username);
     printf("\nUser %d entered!\n", i);
     }
     printf("\nStructure:\n");
     for(i=0; i<mastercount; i++)
     {
         printf("%s -> %s\n", master[i].mastername,
        master[i].user.username);
     }
     for(i=0; i<mastercount; i++)
      {
         printf("\nEnter the number of files you want for user %s: ", master[i].user.username);
         scanf("%d", &master[i].user.filecount);
         temp = master[i].user.filecount;
         printf("Enter the names of the files allocated for the user: ");
         for(j=0; j<temp; j++)
         {
             scanf("%s", &master[i].user.file[j].filename);
             printf("file[%d] name inputted!\n", j);
         }
     }

     printf("STRUCTURE:\n");
     for(i=0; i<mastercount; i++)
     {
         temp = master[i].user.filecount;
         for(j=0; j<temp; j++)
         {
             printf("%s -> %s -> %s\n", master[i].mastername,
            master[i].user.username, master[i].user.file[j].filename);
         }
     }


     repeat:
     flag = 0;
     printf("\nEnter the name of the file you want to get the path for: ");
     scanf("%s", &key);

     for(i=0; i<mastercount; i++)
     {
         temp = master[i].user.filecount;
         for(j=0; j<temp; j++)
         {
             if(strcmpi(key,master[i].user.file[j].filename) == 0)
             {
                 flag = 1;
                 printf("\nFile is found in the path %s -> %s -> %s\n", master[i].mastername, master[i].user.username,
                master[i].user.file[j].filename);
             }
         }
     }
     if(flag == 0)
        printf("\nFile not found!");

     printf("\nDo you want to search for more file paths?(1/0)");
     scanf("%d", &choice);

     if(choice)
        goto repeat;
     return 0;
}
