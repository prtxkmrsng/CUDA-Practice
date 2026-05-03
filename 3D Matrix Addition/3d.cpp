#include <iostream>

int main(void){
    unsigned long n;
    std::cout << "Enter matrix dimension (n): ";
    std::cin >> n;
    
    size_t size = n*n*n*sizeof(long);

    long*a = (long*)malloc(size);
    long*b = (long*)malloc(size);
    long*c = (long*)malloc(size);

    for (long i = 0; i<n*n*n; i++){
        a[i] = i*2;
        b[i] = i*3;
        c[i] = a[i] + b[i]; 
    }

    printf("The first sum is: %li + %li = %li\n", a[0], b[0], c[0]);
    printf("The second sum is: %li + %li = %li\n", a[1], b[1], c[1]);
    printf("The third sum is: %li + %li = %li\n", a[2], b[2], c[2]);
    printf("The fourth sum is: %li + %li = %li\n", a[3], b[3], c[3]);
    printf("The fifth sum is: %li + %li = %li\n", a[4], b[4], c[4]);
    printf("The sums are: ");

    for (long i = 0; i<n*n*n; i++){
        printf("%li, ", c[i]);
    }

    delete(a);
    delete(b);
    delete(c);
}