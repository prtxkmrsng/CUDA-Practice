#include <iostream>
#include <cuda_runtime.h>

using namespace std;

__global__ void mult(int* a, int*b, int*c, int n){
    long row = blockDim.y * blockIdx.y + threadIdx.y;
    long col = blockDim.x * blockIdx.x + threadIdx.x;
    if(row < n && col< n){
        int sum = 0;
        for (int i = 0; i<n; i++){
            sum += a[row*n + i] * b[col + n*i];
        }
        c[row*n + col] = sum;
    }


}


int main(void){

    int* a, *b , *c;
    int n;

    cout << "Enter dimension of tensor: ";
    cin >> n;
    size_t size = sizeof(int) * n * n;
    cudaMallocManaged(&a, size);
    cudaMallocManaged(&b, size);
    cudaMallocManaged(&c, size);

    for (int i = 0; i < n*n; i++){
        a[i] = rand() % 100;
        b[i] = rand() % 100; 
    }
    
    dim3 threadcount(16, 16);
    dim3 blocksiz((n + threadcount.x - 1)/threadcount.x, (n + threadcount.y - 1)/threadcount.y);

    mult<<<blocksiz, threadcount>>>(a, b, c, n);
    cudaDeviceSynchronize();
    for (int j = 0; j<n; j++){
        for (int i = 0; i<n; i++){
            cout << a[i + n*j] << " ";  
        }
    }
    cout << endl;  
    for (int j = 0; j<n; j++){
        for (int i = 0; i<n; i++){
            cout << b[i + n*j] << " ";  
        }
    }
    cout << endl;
    for (int j = 0; j<n; j++){
        for (int i = 0; i<n; i++){
            cout << c[i + n*j] << " ";  
        }
    }
    
    
    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}