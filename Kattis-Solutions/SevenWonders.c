#include <stdio.h>

int main(){
	char C[50];
	int t = 0;
	int c = 0;
	int g = 0;

	scanf("%s", C);
	int k = 0;
	while( C[k] >= 'A' && C[k] <= 'Z' ){
		if(C[k] == 'T')
			t++;
		else if( C[k] == 'C')
			c++;
		else if( C[k] == 'G')
			g++;
		k++;
	}
	printf("Hello\n");
	int sum =0;
	if( t >= 3)
		sum += 7;
	if (t >= 3)
		sum += 7;
	if (t >= 3)
		sum += 7;
	
	int junk;
	
	junk = t^2;
	t = junk;
	junk = c^2;
	c = junk;
	junk = g^2;
	g = junk;

	int cards;
	cards = t + c + g;
	sum = sum + cards;
	printf("%d\n", sum);

	return 0;
}
