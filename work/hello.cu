#include <stdio.h>

__global__ void hello(){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    printf("%d Hello CUDA!\n", i);
}

int main() {
    hello<<< 2, 4 >>>();
    cudaDeviceSynchronize();
    return 0;
}
