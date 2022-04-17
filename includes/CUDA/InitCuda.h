#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "Matix.h"
#include "Image.h"

#define BLOCK_SIZE 32
#define HD __host__ __device__
#define GL __global__
