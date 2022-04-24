#include "CudaActivation.h"

__device__ void d_ActivationDirectDist();

__device__ void d_ActivationBackDist();

__global__ void ActivationDirectDist_global();

__global__ void ActivationBackDist_global();

DECLSPEC Matrix CudaActivationDirectDist();

DECLSPEC Matrix CudaActivationBackDist();