#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "Matix.h"
#include "Image.h"

#ifdef __DLL__
   #define DECLSPEC    __declspec(dllexport)
#else
   #define DECLSPEC    __declspec(dllimport)
#endif 

#define BLOCK_SIZE 32


