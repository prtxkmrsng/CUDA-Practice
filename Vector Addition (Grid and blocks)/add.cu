#include <iostream>
#include <cuda_runtime.h>

__global__ void vectorAdd(long* a, long* b, long* c, long N){
    long i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < N){
    a[i] = a[i]*a[i];
    b[i] = b[i]*b[i]*b[i];
    c[i] = a[i] + b[i];}
}

int main(){

    std::cout << "Enter the size of the vectors: ";
    
    long N;
    std::cin >> N;
    long* d_a, *d_b, *d_c;
    long* h_a, *h_b, *h_c;

    // Allocate memory on the host
    h_a = (long*)malloc(N * sizeof(long));
    h_b = (long*)malloc(N * sizeof(long));
    h_c = (long*)malloc(N * sizeof(long));

    // Initialize the host vectors
    for (long i = 0; i < N; i++) {
        h_a[i] = i;
        h_b[i] = i; 
    }

    // Allocate memory on the device
    size_t size = N * sizeof(long);

    cudaMalloc(&d_a, size);
    cudaMalloc(&d_b, size);
    cudaMalloc(&d_c, size);

    long threadsPerBlock = 256;
    long blocksPerGrid = (N + threadsPerBlock -1) /threadsPerBlock;
    
    // Copy the host vectors to the device
    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

    // Launch the kernel
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, N);
    // Copy the result back to the host
    cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);
    // Prlong the result
    std::cout << "Result of vector addition: " << std::endl;
    for (long i = 0; i < N; i++) {
        std::cout << h_c[i] << " ";
    }
    std::cout << std::endl;
}