#include <cstdio>
#include <cstring>
char** text;
void test(int const a)
{
	printf("%d",a);	
	int v;
	scanf("%d",&v);
}
int main(int argc, char** argv)// .txt.008 file, .txt file, size of .txt file
{
	//test(1);
	char score[10][301];
	FILE * pFile;
    pFile = fopen ("score.tmp","r");
    int n=0;
    //test(2);
    while (!feof(pFile)) {	  
      fgets (score[n], 300, pFile);
      n++;
      }
    //test(3);
    fclose (pFile);
    pFile = fopen (argv[2],"r");
    int size;
    sscanf (argv[3],"%d",&size);    
    text=new char*[size];
    //test(-1);
    for (int t=0;t<size;t++)
      {
	  char textstring[7001];
	  fgets (textstring, 7000, pFile);  
	  text[t]=new char[strlen(textstring)+1];
	  strncpy(text[t],textstring,strlen(textstring)-2);	
	  //printf("%s\n%s\n",textstring,text[t]);
	  //test(t);  
      }  
    //test(size+1); 
    fclose (pFile);
    pFile = fopen (argv[1],"r");
    int k=0;
    printf("<add>\n");
    while (!feof(pFile)) {
	  char linebody[2001];
	  int linenum;
	  fscanf(pFile, "%d:", &linenum);
      fgets (linebody, 2000, pFile);
      if (!feof(pFile)){ 
		char * linebody2;
		linebody2=new char[strlen(linebody)+1];
		memset(linebody2, 0, (strlen(linebody)+1)*sizeof(char));
		strncpy(linebody2,linebody,strlen(linebody)-2);		
		if (linenum==1) linenum++;
		if (linenum==0) linenum=2;
		int linenum2=linenum+5<size?linenum+5:size;
		printf("<doc> \n");
		printf("     <field name=\"id\">%s:%d</field>\n" , argv[1],k);
		printf("     <field name=\"text\">%s</field>\n",linebody2); 
		printf("     <field name=\"term\">%s</field>\n",linebody2);    
		printf("     <field name=\"termlength\">%d</field>\n",strlen(linebody)); 
		printf("     <field name=\"preview\">");
		for (int i=linenum-1;i<linenum2;i++)
		{
			printf("%s ",text[i]);
		}
		printf("</field>\n");
		for (int i=0;i<n-1;i++)
		{
			printf("%s",score[i]);
		}
		delete [] linebody2;	 
		printf("</doc>\n");
		k++;
		}
      }
    printf("</add>\n");
    fclose (pFile);
	return 0;
}
