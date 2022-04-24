#include "CudaFullCon.h"

__device__ void d_FullConDirectDist();

__device__ void d_FullConBackDist();

__global__ void FullConDirectDist_global();

__global__ void FullConBackDist_global();

DECLSPEC Matrix CudaFullConDirectDist();

DECLSPEC Matrix CudaFullConBackDist();