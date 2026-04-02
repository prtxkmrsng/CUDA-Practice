#include <iostream>
#include <cuda_runtime.h>

__global__ void helloFromGPU(float *data){
    printf("Hello World from GPU thread %f!\n", data[threadIdx.x]);
}

int main(){

    float *d_data;

    size_t size = 10* sizeof(float);
    cudaMalloc(&d_data, size);

    float h_data[10] = {1,2,3,4,5,6,7,8,9,10};
    cudaMemcpy(d_data, h_data, size, cudaMemcpyHostToDevice);

    printf("Hello World from CPU!\n");

    helloFromGPU<<<1, 10>>>(d_data);
    cudaDeviceSynchronize();

    return 0;
}