#include "CudaPooling.h"

__device__ void d_PoolingDirectDist();

__device__ void d_PoolingBackDist();

__global__ void PoolingDirectDist_global();

__global__ void PoolingBackDist_global();

DECLSPEC Matrix CudaPoolingDirectDist();

DECLSPEC Matrix CudaPoolingBackDist();