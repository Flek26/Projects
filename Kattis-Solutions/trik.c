#include <stdio.h>
#include <string.h>
int main(){

	char str[50];
	int a=1, b=0, c=0;
	int tmp;
	int ln;
	scanf("%s", str);
	ln = strlen(str);
	for(int x = 0 ; x <= ln ; x++){
		if(str[x] == 'A'){
			tmp = a;
			a = b;
			b = tmp;
		}
		else if(str[x] == 'B'){
			tmp = b;
			b = c;
			c = tmp;
		}
		else if(str[x] == 'C'){
			tmp = c;
			c = a;
			a = tmp;
		}
	}
	if( a == 1)
		printf("1\n");
	if(b == 1)
		printf("2\n");
	if(c == 1)
		printf("3\n");

	return 0;
}
