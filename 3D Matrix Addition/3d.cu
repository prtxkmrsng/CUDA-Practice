#include <iostream>
#include <cuda_runtime.h>

__global__ void add(long* a, long* b, long* c, int n){
    long row = blockDim.x * blockIdx.x + threadIdx.x;
    long col = blockDim.y * blockIdx.y + threadIdx.y;
    long dep = blockDim.z * blockIdx.z + threadIdx.z;

    if (row < n && col < n && dep < n){
        long idx = row*n*n + col*n + dep;
        a[idx] = idx*2;
        b[idx] = idx*3;

        c[idx] = a[idx] + b[idx];
    }
}

int main(void){
    unsigned long n, k;
    std::cout << "Enter matrix dimension (n): ";
    std::cin >> n;
    if (n>10){
        k=10;
    }else{
        k=n;
    }
    dim3 threadCount(k, k, k);

    dim3 numBlocks((n + threadCount.x - 1)/threadCount.x, (n + threadCount.y - 1)/threadCount.y, (n + threadCount.z - 1)/threadCount.z);

    long* a, *b, *c;
    
    size_t size = n*n*n*sizeof(long);

    cudaMallocManaged(&a, size);
    cudaMallocManaged(&b, size);
    cudaMallocManaged(&c, size);

    add<<<numBlocks, threadCount>>>(a, b, c, n);

    cudaDeviceSynchronize();

    printf("The first sum is: %li + %li = %li\n", a[0], b[0], c[0]);
    printf("The second sum is: %li + %li = %li\n", a[1], b[1], c[1]);
    printf("The third sum is: %li + %li = %li\n", a[2], b[2], c[2]);
    printf("The fourth sum is: %li + %li = %li\n", a[3], b[3], c[3]);
    printf("The fifth sum is: %li + %li = %li\n", a[4], b[4], c[4]);
    printf("The sums are: ");
    for (long i = 0; i<n*n*n; i++){
        printf("%li, ", c[i]);
    }

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}