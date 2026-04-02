#include <iostream>

using namespace std;

int main() {
    cout << "Enter the size of the vectors: ";
    int n;
    if (!(cin >> n)) return 1;

    // Use long long to handle much larger results
    long long* c = new long long[n];

    for (int i = 0; i < n; i++) {
        // Cast i to long long so the multiplication happens in 64-bit space
        long long val = (long long)i; 
        c[i] = (val * val) + (val * val * val);
    }

    cout << "Result of vector addition: " << endl;
    for (int i = 0; i < n; i++) {
        cout << c[i] << " ";
    }
    cout << endl;

    // Correct way to free memory allocated with 'new[]'
    delete[] c; 
    
    return 0;
}