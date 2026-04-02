#include <iostream>
#include <cuda_runtime.h>

__global__ void add(int *a, int *b, int *c){
    int i = threadIdx.x;
    a[i] = a[i] * a[i];
    b[i] = b[i] * b[i] * b[i];
    c[i] = a[i] + b[i];
}

int main(void){

    int *h_a, *h_b, *h_c;
    int *d_a, *d_b, *d_c;

    int n;
    std::cout << "Enter the number of elements: ";
    std:: cin >> n;

    h_a = (int*)malloc(n * sizeof(int));
    h_b = (int*)malloc(n * sizeof(int));
    h_c = (int*)malloc(n * sizeof(int));

    size_t size = n * sizeof(int);

    cudaMalloc(&d_a, size);
    cudaMalloc(&d_b, size);
    cudaMalloc(&d_c, size);

    for (int i = 0; i<n; i++){
        h_a[i] = i;
        h_b[i] = i;
    }

    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

    add<<<1, n>>>(d_a, d_b, d_c);
    cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaDeviceSynchronize();
    std::cout << "Result: \n";
    for (int i = 0; i<n; i++){
        std::cout << h_c[i] << " ";
    }
    std::cout << std::endl;

}