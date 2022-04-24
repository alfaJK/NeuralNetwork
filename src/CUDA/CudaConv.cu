#include "CudaConv.h"

__device__ void d_ConvDirectDist(Matrix& InputMatrix , Matrix& OutputMatrix){



}

__global__ void ConvDirectDist_global(Matrix& InputMatrix , Matrix& OutputMatrix){

}

__device__ void d_ConvBackDist(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix){

    int index_x = blockIdx.x * blockDim.x + threadIdx.x;
    int index_y = blockIdx.y * blockDim.y + threadIdx.y;
    int sum = 0;
    int Padding = (Filter->width - 1) / 2;
    int* OutSubM = OutputMatrix->GetSubMatrix(blockIdx.x, blockIdx.y);

    for (int m = 0; m < (InputMatrix->width / BLOCK_SIZE); ++m) {

        int* SubM = InputMatrix->GetSubMatrix(m, blockIdx.y);
        __shared__ int InputSubMatrix[BLOCK_SIZE][BLOCK_SIZE];
        InputSubMatrix[threadIdx.x][threadIdx.y] = SubM[BLOCK_SIZE * threadIdx.y + threadIdx.x];

        __syncthreads();

        for (int i = 0; i < Filter->height; i++) {
            for (int j = 0; j < Filter->width; j++) {
                int i0 = index_x + i - Padding;
                int j0 = index_y + j - Padding;
                if (i0 < 0 || i0 >= BLOCK_SIZE || j0 < 0 || j0 >= BLOCK_SIZE)
                    continue;
                sum += InputSubMatrix[i0][j0] * Filter->GetElement(i, j);
            }
           // __syncthreads();
        }

        __syncthreads();

}

__global__ void ConvBackDist_global(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix){

}

DECLSPEC Matrix CudaConvDirectDist(Matrix& InputMatrix){
    
    dim3 gridSize = dim3(W / BLOCK_SIZE, W / BLOCK_SIZE, 1);
    dim3 blockSize = dim3(BLOCK_SIZE, BLOCK_SIZE, 1);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);
    ConvDirectDist_global <<<gridSize, blockSize >>> (InputMatrix, OutputMatrix);
    cudaEventRecord(stop);

 //   cudaDeviceSynchronize(); cudaGetLastError();

}

DECLSPEC Matrix CudaConvBackDist(Matrix& InputMatrix , Matrix& Filter){

    dim3 gridSize = dim3(W / BLOCK_SIZE, W / BLOCK_SIZE, 1);
    dim3 blockSize = dim3(BLOCK_SIZE, BLOCK_SIZE, 1);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);
    ConvBackDist_global <<<gridSize, blockSize >>> (InputMatrix, Filter, OutputMatrix);
    cudaEventRecord(stop);

}