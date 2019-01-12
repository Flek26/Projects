#include <stdio.h>

int main(){

	int max;
	int months;

	scanf("%d", &max);
	scanf("%d", &months);

	int start;
	int total;

	int k;
	int end;
	total = max;
	for( k = 0 ; k < months ; k++){
		scanf("%d", &start);
		total = total - start;
		total = total + max; 
	}	

	printf("%d\n", total);

	return 0;
}
