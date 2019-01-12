#include <stdio.h>
int main(){

	int hr, min;
	scanf("%d %d", &hr, &min);
	
	min = min - 45;

	if(min < 0){
		min = min + 60;
		hr = hr - 1;
		if( hr < 0){
			hr = hr + 24;
		}
	}
	printf("%d %d\n", hr, min);
	return 0;
}
