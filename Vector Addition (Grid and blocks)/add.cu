#include <iostream>
#include <cuda_runtime.h>

__global__ void vectorAdd(long long* a, long long* b, long long* c, long long N){
    long long i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < N){
    a[i] = a[i]*a[i];
    b[i] = b[i]*b[i]*b[i];
    c[i] = a[i] + b[i];}
}

int main(){

    std::cout << "Enter the size of the vectors: ";
    
    long long N;
    std::cin >> N;
    long long* d_a, *d_b, *d_c;
    long long* h_a, *h_b, *h_c;

    // Allocate memory on the host
    h_a = (long long*)malloc(N * sizeof(long long));
    h_b = (long long*)malloc(N * sizeof(long long));
    h_c = (long long*)malloc(N * sizeof(long long));

    // Initialize the host vectors
    for (long long i = 0; i < N; i++) {
        h_a[i] = i;
        h_b[i] = i; 
    }

    // Allocate memory on the device
    size_t size = N * sizeof(long long);

    cudaMalloc(&d_a, size);
    cudaMalloc(&d_b, size);
    cudaMalloc(&d_c, size);

    long long threadsPerBlock = 256;
    long long blocksPerGrid = (N + threadsPerBlock -1) /threadsPerBlock;
    
    // Copy the host vectors to the device
    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

    // Launch the kernel
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, N);
    // Copy the result back to the host
    cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    cudaDeviceSynchronize();
    // Print the result
    std::cout << "Result of vector addition: " << std::endl;
    for (long long i = 0; i < N; i++) {
        std::cout << h_c[i] << " ";
    }
    std::cout << std::endl;

    // Free host memory
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}