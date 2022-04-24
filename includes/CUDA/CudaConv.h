#include "InitCuda.h"
#include "Matrix.h"

__device__ int d_ConvDirectDist(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix);

__global__ void ConvDirectDist_global(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix);

__device__ void d_ConvBackDist(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix);

__global__ void ConvBackDist_global(Matrix& InputMatrix , Matrix& Filter , Matrix& OutputMatrix);

DECLSPEC Matrix CudaConvDirectDist(Matrix& InputMatrix , Matrix& Filter);

DECLSPEC Matrix CudaConvBackDist(Matrix& InputMatrix , Matrix& Filter);