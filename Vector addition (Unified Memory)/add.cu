#include <iostream>
#include <cuda_runtime.h>

__global__ void add(int *a, int* b, int* c, int n){
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    if (index < n){
        c[index] = a[index] + b[index];
    }
}

int main(void){

    int* a, *b, *c;
    int n;

    std::cout << "Enter the size of the arrays: ";
    std::cin>>n;

    size_t size = n*sizeof(int);

    cudaMallocManaged(&a, size);
    cudaMallocManaged(&b, size);
    cudaMallocManaged(&c, size);

    for (int i = 0; i < n; i++){
        a[i] = rand() % 100;
        b[i] = rand() % 100;
    }

    int blockSize = 256;
    int blockCount = (n + blockSize -1) /blockSize;
    add<<<blockCount, blockSize>>>(a, b, c, n);
    cudaDeviceSynchronize();
    printf("Result of addition:\n");

    for (int i = 0; i < n; i++){
        printf("%d + %d = %d\n", a[i], b[i], c[i]);
    }   

    cudaFree(&a);
    cudaFree(&b);
    cudaFree(&c);
    return 0;
}