#include <stdio.h>
int main(){
    int numStones;
    scanf("%d", &numStones);
    if(numStones % 2 == 1)
        printf("Alice\n");
    else
        printf("Bob\n");
}
