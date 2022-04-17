#include "InitCuda.h"
#include "Matrix.h"

__device__ void d_CalcConvModule();

__device__ void d_CalcPoolingModule();

__device__ void d_CalcFullConModule();

__device__ void d_CalcActivationModule();


__global__ void CalcConvModule_global();

__global__ void CalcPoolingModule_global();

__global__ void CalcFullConModule_global();

__global__ void CalcActivationModule_global();


DECLSPEC Matrix CalcConvModule();

DECLSPEC Matrix CalcPoolingModule();

DECLSPEC Matrix CalcFullConModule();

DECLSPEC Matrix CalcActivationModule();

