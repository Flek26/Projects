#include <stdio.h>

int sum(int x) {
    int num = 0;
	while (x > 0) {
		num += x % 10;
	    x = x / 10;
    }
	return num;
}

int main(){

	int num1, num2, end;

	scanf("%d %d %d", &num1, &num2, &end);

	for(int i = num1 ; i <= num2 ; i++){
		int s = sum(i);
		if(s == end){
			printf("%d\n", i);
			break;
		}
	}
	for(int i = num2 ; i >= num1 ; i--){
		int s = sum(i);
		if(s == end){
			printf("%d\n", i);
			break;
		}
	}

	return 0;
}
