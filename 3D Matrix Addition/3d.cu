#include <iostream>
#include <cuda_runtime.h>

__global__ void add(int* a, int* b, int* c, int n){
    int row = blockDim.x * blockIdx.x + threadIdx.x;
    int col = blockDim.y * blockIdx.y + threadIdx.y;
    int dep = blockDim.z * blockIdx.z + threadIdx.z;

    if (row < n && col < n && dep < n){
        int idx = row*n*n + col*n + dep;
        a[idx] = idx*2;
        b[idx] = idx*3;

        c[idx] = a[idx] + b[idx];
    }
}

int main(void){
    unsigned int n, k;
    std::cout << "Enter matrix dimension (n): ";
    std::cin >> n;
    if (n>10){
        k=10;
    }else{
        k=n;
    }
    dim3 threadCount(k, k, k);

    dim3 numBlocks((n + threadCount.x - 1)/threadCount.x, (n + threadCount.y - 1)/threadCount.y, (n + threadCount.z - 1)/threadCount.z);

    int* a, *b, *c;
    
    size_t size = n*n*n*sizeof(int);

    cudaMallocManaged(&a, size);
    cudaMallocManaged(&b, size);
    cudaMallocManaged(&c, size);

    add<<<numBlocks, threadCount>>>(a, b, c, n);

    cudaDeviceSynchronize();

    printf("The first sum is: %i + %i = %i\n", a[0], b[0], c[0]);
    printf("The second sum is: %i + %i = %i\n", a[1], b[1], c[1]);
    printf("The third sum is: %i + %i = %i\n", a[2], b[2], c[2]);
    printf("The fourth sum is: %i + %i = %i\n", a[3], b[3], c[3]);
    printf("The fifth sum is: %i + %i = %i\n", a[4], b[4], c[4]);
    printf("The sums are: ");
    for (int i = 0; i<n*n*n; i++){
        printf("%i, ", c[i]);
    }

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}