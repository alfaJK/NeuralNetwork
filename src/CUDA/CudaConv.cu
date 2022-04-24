#include "CudaConv.h"

__device__ int d_ConvDirectDist(Matrix& InputMatrix , Matrix& Filter){

    int sum = 0;
    int Padding = (Filter.width - 1) / 2;

    for (int i = 0; i < Filter.height; i++) {
        for (int j = 0; j < Filter.width; j++) {
            int i0 = index_x + i - Padding;
            int j0 = index_y + j - Padding;
            if (i0 < 0 || i0 >= InputMatrix.height || j0 < 0 || j0 >= InputMatrix.width) continue;
            sum += InputMatrix.GetElement(i0, j0) * Filter.GetElement(i, j);
        }
    }
    return sum;

}

__global__ void ConvDirectDist_global(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix){

    int index_x = blockIdx.x * blockDim.x + threadIdx.x;
    int index_y = blockIdx.y * blockDim.y + threadIdx.y;
    int sum = d_ConvDirectDist(index_x, index_y, InputMatrix, Filter);
    __syncthreads();

    // ========== РЕАЛИЗОВАТЬ ПЕРЕНОС ДАННЫХ В ВЫХОДНУЮ МАТРИЦУ ==========

   // OutputMatrix->SetElement(index_x, index_y, sum);


    __syncthreads();
}

__device__ void d_ConvBackDist(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix){



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