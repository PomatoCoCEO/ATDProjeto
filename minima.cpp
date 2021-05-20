#include <bits/stdc++.h>
#define nao !
using namespace std;

int main(int argc, char** argv){
    if(argc < 3) {
        cout<<"Usage: ./minima <no_experiment> <no_window>"<<endl;
    }
    vector<int> labels=vector<int>();
    int a,b, act, beg, end;
    // int window = 110;
    int no_exp=atoi(argv[1]);
    int window = atoi(argv[2]);
    int k = 0;
    
    while( cin>> a>>b>>act>> beg>>end){
        if(a<no_exp) continue;
        if(a>no_exp) break;
        
        while(window <= end) {
            if (  window < beg ) cout<<-1<<endl;   
                // labels.push_back(-1);
            else cout<<act<<endl;
                // labels.push_back(act);
            window+= ceil(110.0/10.0);
        }
    }

    /* for (int i : labels)
        cout<< i<< endl;
*/
    
    return 0;
}