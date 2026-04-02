#include <iostream>
#include <cuda_runtime.h>

__global__ void sort(int * arr, int* reversedArr, int n) {
    extern __shared__ int temp[];

    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < n){
    temp[idx] = arr[idx];
    __syncthreads();   
    reversedArr[idx] = temp[n-(idx)-1];
}
}


int main(void){

    int n;
    std::cout << "Enter the number of elements: ";
    std::cin >> n;

    int* h_arr = new int[n];
    int* d_arr;

    size_t size = n * sizeof(int);
    cudaMalloc(&d_arr, size);  

    for (int i = 0; i < n; i++) {
        h_arr[i] = rand() % 100; // Fill the array with random numbers  
    }

    cudaMemcpy(d_arr, h_arr, size, cudaMemcpyHostToDevice);
    int* d_reversedArr;
    int* h_reversedArr = new int[n];

    cudaMalloc(&d_reversedArr, size);

    int blockSize = n;
    int numBlocks = 1;
    int sharedMemSize = n * sizeof(int);

    sort<<<numBlocks, blockSize, sharedMemSize>>>(d_arr, d_reversedArr, n);

    cudaMemcpy(h_reversedArr, d_reversedArr, size, cudaMemcpyDeviceToHost);
    std::cout << "Actual array: ";
    for (int i = 0; i < n; i++) {           
        std::cout << h_arr[i] << " ";
    }
    std::cout << std::endl;
    std::cout << "Reversed array: ";
    for (int i = 0; i < n; i++) {           
        std::cout << h_reversedArr[i] << " ";
    }
    std::cout << std::endl;
    delete[] h_arr;
    delete[] h_reversedArr;
    cudaFree(d_arr);
    cudaFree(d_reversedArr);

    cudaDeviceSynchronize();

    return 0;
}