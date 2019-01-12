//C++ program that makes a graph and then implements many sorting algorithms.

#include <iostream>
#include <fstream>
#include <queue>
#include <stack>
#include <climits>
#include <chrono>
using namespace std;
using namespace std::chrono;
class graph
{
	public:
		graph();
		graph( int x );
		void bfs( int x );
		void bfssp( int x );
		void dfs( int x );
		void dfssp( int x );
		void mprint();
		void fill( ifstream& file );
		void dijkstra(int x);
		void prim(int x);
		void kruskal();
		void floyd();
	private:
	//D is a stack for DFS put on stack in back order
	//D is a queue for BFS
		int **matrix;
		int nodes;
		int **barr;
};

void graph::floyd(){
	int dist[nodes+1][nodes+1], i, j, k;
	for( i = 1; i <= nodes ; i++){
		for(j = 1; j <= nodes ; j++){
			dist[i][j] = matrix[i][j];
		}
	}
	
	for(k = 1; k <= nodes ; k++){
		for(i = 1; i <= nodes ; i++){
			for(j = 1 ; j<=nodes ; j++){
				if(dist[i][k] * dist[k][j] != 0 && i != j){
					if(dist[i][k] + dist[k][j] < dist[i][j] || dist[i][j] == 0)
						dist[i][j] = dist[i][k] + dist[k][j];
				}
			}
		}
	}
	printf("\nFloyd Warshal: \n");
	printf("      ");
	for(i = 1 ; i <= nodes; i++){
		printf("%2d ", i);
	}
	cout << endl << endl;

	for( i = 1 ; i <= nodes ; i++){
		printf("%2d    ", i);
		for(j = 1; j <= nodes ; j++){
				printf("%2d ", dist[i][j]);
		}
		printf("\n");
	}
}

void graph::kruskal(){
	printf("\nKruskal: \n");
	int totsum = 0;
	int list[nodes+1];
	int no_edge = 0;
	int min = INT_MAX;
	int a,x, ua;
	int b,y, ub;
	for(int i = 1; i <= nodes; i++){
		list[i] = i;
	}
	
	while(no_edge < nodes-1){
		min = INT_MAX;
		a = -1;
		b = -1;
		for(int i = 1; i <= nodes ; i++){
			for(int j = 1; j <= nodes ; j++){
				x = i;
				y = j;
				while(list[x] != x)
					x = list[x];
				while(list[y] != y)
					y = list[y];
				if(x != y && matrix[i][j] != 0 && matrix[i][j] < min){
					min = matrix[i][j];
					a = i;
					b = j;
				}
			}
		}
		ua = a;
		ub = b;
		while(list[ua] != ua)
			ua = list[ua];
		while(list[ub] != ub)
			ub = list[ub];
		list[ua] = ub;
		printf("%d -> %d     Weight: %d\n", a, b, min);
		totsum += min;
		no_edge++;
	}
	printf("\nTotal Cost - %d\n\n", totsum);

}

void graph::prim(int x){
	printf("\nPrims: \n");
	int totsum=0;
	int no_edge = 0;
	int used[nodes+1] = {0};
	used[x] = 1;
	int z;
	int y;
	printf("Edge : Weight\n");
	while(no_edge < nodes-1){
		int min = INT_MAX;
		z = 0;
		y = 0;
		for(int i = 1; i <= nodes ; i++){
			if(used[i]){
				for(int j = 1 ; j <= nodes ; j++){
					if(!used[j] && matrix[i][j]){
						if(min > matrix[i][j]){
							min = matrix[i][j];
							z = i;
							y = j;
						}
					}
				}
			}
		}
		if(x > 0){
			printf("%2d - %2d   :   %2d\n", z, y, matrix[z][y]);
			totsum += matrix[z][y];
		}
		used[y] = 1;
		no_edge++;
	}
	printf("\nTotal Weight - %3d\n\n", totsum);
}

void graph::dijkstra(int x){
	printf("\nDijkstras: \n");
	int i, j, min = INT_MAX, minIndex;
	int distance[nodes+1] = {0};
	int used[nodes+1] = {0};

	for(i = 1; i <= nodes; i++){
		distance[i] = INT_MAX;
	}

	distance[x] = 0;

	for(i = 0 ; i < nodes-1; i++){
			min = INT_MAX;
		for(j = 1; j <= nodes ; j++){
			if(used[j] == 0 && distance[j] <= min){
				min = distance[j];
				minIndex = j;
			}
		}
		used[minIndex] = 1;
		for(j = 1 ; j <= nodes ; j++){
			if(used[j] == 0 && matrix[minIndex][j] != 0 && distance[minIndex] != INT_MAX && ((distance[minIndex]+ matrix[minIndex][j]) < distance[j])){
				distance[j] = distance[minIndex] + matrix[minIndex][j];
			}
		}
	}

	for(i = 1; i <= nodes; i ++){
		if( i != x)
			printf("%2d - %2d\n", i, distance[i]);
	}

}

graph::graph(){
	int k, j;
	nodes = 10;
	matrix = new int*[nodes+1];
	for(k = 0; k <=11 ; k++){
		matrix[k] = new int[nodes+1];
	}
	for(k = 1 ; k <= nodes ; k++){
		for(j = 1 ; j <= nodes ; j++){
			matrix[k][j] = 0;
		}
	}
}

graph::graph(int x){
	int k, j;
	nodes = x;
	matrix = new int*[nodes+1];
	barr = new int*[500];
	for(k = 0; k <=nodes+1 ; k++){
		matrix[k] = new int[nodes+1];
		barr[k] = new int[4];
	}
	for(k = 1 ; k <= nodes ; k++){
		for(j = 1 ; j <= nodes ; j++){
			matrix[k][j] = 0;
			if (j < 4){
				barr[k][j] = 0;
			}
		}
	}
}


void graph::bfs(int x){

	queue<int> q;
	int used[nodes+1] = {0};
	int next, i;
	int a = 1;
	used[x] = 1;
	printf("BFS --- %d", x);
	for( i = 1; i <= nodes ; i++){
		if(matrix[x][i] > 0){
			q.push(i);
			barr[a][1] = x;
			barr[a][2] = i;
			used[i] = 1;
			a++;
		}
	}
	while (!q.empty()){
		next = q.front();
		q.pop();
		printf(" %2d", next);
		for( i = 1; i <= nodes ; i++){
			if(matrix[next][i] > 0 && used[i] != 1){
				q.push(i);
				barr[a][1] = next;
				barr[a][2] = i;
				used[i] = 1;
				a++;
			}
		}
	}
	barr[0][0] = a;
}

void graph::bfssp(int x){
	int k;
	int len = barr[0][0];
	for(k = 1 ; k < len ; k++){
		if(barr[k][1] != 0){
			printf("%d->%d  ", barr[k][1], barr[k][2]);
		}
	}
}

void graph::dfs(int x){

	stack<int> s;
	int used[nodes+1] = {0};
	int next, i;
	printf("DFS --- %d", x);
	used[x] = 1;
	for( i = nodes ; i >= 1 ; i--){
		if(matrix[x][i] != 0){
			s.push(i);
		}
	}
	while (!s.empty()){
		next = s.top();
		s.pop();
		if(used[next] != 1){
			printf(" %2d", next);
			used[next] = 1;
			for(i = nodes ; i >= 1 ; i--){
				if(matrix[next][i] > 0 && !used[i]){
					s.push(i);
				}
			}
		}
	}
}

void graph::dfssp(int x){
	int k, next;
	stack<int> front;
	stack<int> back;
	int used[nodes+1] = {0};
	front.push(x);
	used[x] = 1;

	for(k = nodes ; k > 0 ; k--){
		if(matrix[x][k] != 0)
			back.push(k);
	}
	while(!back.empty()){
		if(used[back.top()] == 1)
			back.pop();
		else{
				if(matrix[front.top()][back.top()] == 0)
					front.pop();
				else{
					printf("%d->%d  ", front.top(), back.top());
					next = back.top();
					back.pop();
					front.push(next);
					used[next] = 1;
					for(k = nodes ; k >= 1 ; k--){
						if(matrix[front.top()][k] > 0 && used[k] != 1)
							back.push(k);
					}
				}
			
		}
	}
}


void graph::mprint(){
	printf("      ");
	for( int i = 1 ; i <= nodes; i++){
		printf("%2d ", i);
	}
	cout << endl << endl;
 		for(int i = 1; i <= nodes ; i++){
     			printf("%2d    ", i);
	 			for(int u = 1; u <= nodes ; u++){
                        printf("%2d ", matrix[i][u]);
                }
                printf("\n");
        }

}

void graph::fill(ifstream& file){

        int k,j;
        file >> k ;

        int a, b, weight;
        for(int i = 0; i < k; i++){
				file >> a;
				file >> b;
				file >> weight;
                matrix[a][b] = weight;
                matrix[b][a] = weight;
        }

}


int main( int argc, char *argv[] )
{
	int size;
	int location;
	ifstream ifp;



//checking to see if file was entered on command line
	if ( argc != 2 )
	{
		cout << "File was not entered\n";
		return 2;
	}

	ifp.open( argv[1] );

	// checking to see if file was opened successfully
	if( ! ifp.is_open() )
	{
		cout << "File could not be opened\n";
		return 3;
	}


	// reading in number of nodes
	ifp >> size;

	

	//create graph with an an adjadceny matrix of 
    // size = num of nodes x num of nodes
	graph g( size );


	g.fill(ifp);
	//ask for starting location
	cout << "Enter the starting location: ";
	cin >> location;

	//print the matrix
	g.mprint();
	cout << endl << endl;

	// calculate DFS
	g.dfs( location );
	cout << endl << endl;

	//calculate DFS-SP
	g.dfssp( location );
	cout << endl << endl;

	//calculate BFS
	g.bfs( location );
	cout << endl << endl;

	//calculate BFS-SP
	g.bfssp( location );
	cout << endl << endl;
	auto start = high_resolution_clock::now();
	//for( int k = 1 ; k <= size; k++){
		g.dijkstra(location);
	//}
	auto stop = high_resolution_clock::now();
	auto duration = duration_cast<microseconds>(stop-start);
	cout << endl;
	printf("Time in Microseconds for all nodes: %d\n", duration.count());
	
	g.prim(location);
	g.kruskal();
	
	auto start2 = high_resolution_clock::now();
	g.floyd();
	auto stop2 = high_resolution_clock::now();
	auto duration2 = duration_cast<microseconds>(stop2-start2);
	cout << endl;
	printf("Time in Microseconds: %d\n", duration2.count()); 

	return 0;
}
