#include <time.h> 
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "iostream"
#include <stdio.h>

#define BLOCK_SIZE 32

class Unified {
public:
    void* operator new(size_t len) {
        void* ptr;
        cudaMallocManaged(&ptr, len);
        return ptr;
    }
    void operator delete(void* ptr) {
        cudaFree(ptr);
    }
    void* operator new[](std::size_t size) {
        void* ptr;
        cudaMallocManaged(&ptr, size);
        return ptr;
    }
        void operator delete[](void* ptr) {
        cudaFree(ptr);
    }
};


class Matrix:public Unified {
private:
    int* Data;
public:
    int height;
    int width;
    __host__  __device__ Matrix(int w, int h, int* data) {
        height = h;
        width = w;
        cudaMallocManaged(&Data, width * height * sizeof(int));
        cudaMemcpy(Data, data, width * height * sizeof(int), cudaMemcpyHostToDevice);
    }
    __host__  __device__ int GetElement(int x,int y);
    __host__  __device__ int* GetSubMatrix(int x, int y);
    __host__  __device__ void SetElement(int x, int y,int data);
    __host__  __device__ void PrintMatrix();
};

__host__ __device__ int Matrix::GetElement(int x, int y) {
    return Data[width * y + x];
}
__host__  __device__ int* Matrix::GetSubMatrix(int x, int y) {

   // Matrix *Asub = new Matrix(BLOCK_SIZE, BLOCK_SIZE,&Data[width * BLOCK_SIZE * y + BLOCK_SIZE * x]);
    return &Data[width * BLOCK_SIZE * y + BLOCK_SIZE * x];
}
__host__ __device__ void Matrix::SetElement(int x, int y, int data) {
    Data[width * y + x] = data;
}

__host__ __device__ void Matrix::PrintMatrix() {
  //  int* Data2 = (int*)malloc(width * height * sizeof(int));
  //  cudaMemcpy(Data2, Data, width * height * sizeof(int), cudaMemcpyDeviceToHost);
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            printf(" %d", Data[width * y + x]);
   //         std::cout << Data2[width * y + x] << " ";
        }
        printf("\n");
    }
   // delete Data2;
}




int H =900;
int W = 900;
int F_W = 17;
int SIZE = W * H;




/*__device__ int CalcElement(int a, int b) {
    return a + b;
}




 void AddMatrix(int* a, int* b, int* c, int ww)
{
     clock_t start = clock();
   
     for (int i = 0; i < ww; i++) {
         for (int j = 0; j < ww; j++) {
             c[ww * i + j] = a[ww * i + j]+ b[ww * i + j];
         }
    }
     clock_t end = clock();
     double seconds = (double)(end - start);
     printf("The time: %f ms\n", seconds);


}


__global__ void AdditionMatrix( int *a,  int *b, int *c,int ww)
{

    int index_x = blockIdx.x * blockDim.x + threadIdx.x;
    int index_y = blockIdx.y * blockDim.y + threadIdx.y;

    __shared__ int AResMatrix[BLOCK_SIZE][BLOCK_SIZE];

    AResMatrix[threadIdx.x][threadIdx.y] = a[ww * index_y + index_x]+ b[ww * index_y + index_x];

    __syncthreads();

    c[ww * index_y + index_x] = AResMatrix[threadIdx.x][threadIdx.y];
    __syncthreads();
}

void printMatrix(int* c, int ww) {
    for (int x = 0; x < ww;x++) {
        for (int y = 0; y < ww; y++) {
            std::cout << c[ww * y + x]<<" ";
        }
        std::cout << std::endl;
    }
}
*/




void AddMatrix(Matrix* InputMatrix, Matrix* Filter, Matrix* OutputMatrix)
{
    clock_t start = clock();

    for (int y = 0; y < InputMatrix->height; y++) {
        for (int x = 0; x < InputMatrix->width; x++) {
            int sum = 0;
            int Padding = (Filter->width - 1) / 2;
            for (int i = 0; i < Filter->height; i++) {
                for (int j = 0; j < Filter->width; j++) {
                    int i0 = y + i - Padding;
                    int j0 = x + j - Padding;
                    if (i0 < 0 || i0 >= InputMatrix->height || j0 < 0 || j0 >= InputMatrix->width)
                        continue;
                    sum += InputMatrix->GetElement(i0, j0) * Filter->GetElement(i, j);
                }
            }
            OutputMatrix->SetElement(y, x, sum);
        }
    }

    clock_t end = clock();
    double seconds = (double)(end - start);
    printf("The time: %f ms\n", seconds);
   /* for (int i = 0; i < ww; i++) {
        for (int j = 0; j < ww; j++) {
            c->SetElement(i, j, a->GetElement(i, j) + b->GetElement(i, j));
        }
    }
    clock_t end = clock();
    double seconds = (double)(end - start);
    printf("The time: %f ms\n", seconds);

    */
}

__device__ int calc(int index_x, int index_y , Matrix *input , Matrix* filter) {

    int sum = 0;
    int Padding = (filter->width - 1) / 2;

    for (int i = 0; i < filter->height; i++) {
        for (int j = 0; j < filter->width; j++) {
            int i0 = index_x + i - Padding;
            int j0 = index_y + j - Padding;
            if (i0 < 0 || i0 >= input->height || j0 < 0 || j0 >= input->width)
                continue;
            sum += input->GetElement(i0, j0) * filter->GetElement(i, j);
        }
    }
    return sum;
}

__global__ void NotOptAdditionMatrix(Matrix* InputMatrix, Matrix* Filter, Matrix* OutputMatrix )
{
   // int block_x = blockIdx.x;
   // int block_y = blockIdx.y;

    int index_x = blockIdx.x * blockDim.x + threadIdx.x;
    int index_y = blockIdx.y * blockDim.y + threadIdx.y;


    int sum = calc(index_x, index_y, InputMatrix, Filter);
    __syncthreads();

    OutputMatrix->SetElement(index_x, index_y, sum);


    __syncthreads();



    // cudaDeviceSynchronize();
   // c->SetElement(index_x , index_y, a->GetElement(index_x, index_y)+ b->GetElement(index_x, index_y));

}


__global__ void AdditionMatrix(Matrix* InputMatrix, Matrix* Filter, Matrix* OutputMatrix)
{

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

    OutSubM[BLOCK_SIZE * threadIdx.y + threadIdx.x] = sum;




}

__host__ int main()
{
    int* h_A = (int*)malloc(SIZE * sizeof(int));
    int* h_filter = (int*)malloc(F_W * F_W * sizeof(int));
    int* h_C = (int*)malloc(SIZE * sizeof(int));

    for (int i = 0; i < F_W; i++) {
        for (int j = 0; j < F_W; j++) {
            h_filter[i * F_W + j] =1;
        }
    }


    for (int i = 0; i < W; i++) {
        for (int j = 0; j < H; j++) {
            h_A[i * W + j] = 1;
        }
    }

    Matrix* InputMatrix = new Matrix(W, W, h_A);
  //  InputMatrix->PrintMatrix();
    Matrix* Filter = new Matrix(F_W, F_W, h_filter);
   // Filter->PrintMatrix();
    Matrix* OutputMatrix = new Matrix(W, W, h_A);

    AddMatrix(InputMatrix, Filter, OutputMatrix);

   // OutputMatrix->PrintMatrix();


    dim3 gridSize = dim3(W / BLOCK_SIZE, W / BLOCK_SIZE, 1);
    dim3 blockSize = dim3(BLOCK_SIZE, BLOCK_SIZE, 1);




    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

 /*   cudaEventRecord(start);
    AdditionMatrix << <gridSize, blockSize >>> (InputMatrix, Filter, OutputMatrix);
  //  NotOptAdditionMatrix <<<gridSize, blockSize >>> (InputMatrix, Filter, OutputMatrix);
    cudaEventRecord(stop);
    cudaDeviceSynchronize(); cudaGetLastError();
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "CUDA  fast time simple (ms): " << milliseconds << std::endl;
    OutputMatrix->PrintMatrix();
    */

    cudaEventRecord(start);
      NotOptAdditionMatrix <<<gridSize, blockSize >>> (InputMatrix, Filter, OutputMatrix);
    //AdditionMatrix << <gridSize, blockSize >>> (InputMatrix, Filter, OutputMatrix);
    cudaEventRecord(stop);
    cudaDeviceSynchronize(); cudaGetLastError();
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "CUDA not fast time simple (ms): " << milliseconds << std::endl;
  //  OutputMatrix->PrintMatrix();




  /*  cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    NotOptAdditionMatrix <<<gridSize, blockSize >>> (A, B, C, W);
    cudaEventRecord(stop);
    cudaDeviceSynchronize(); cudaGetLastError();
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "CUDA not fast time simple (ms): " << milliseconds << std::endl;

    cudaEventRecord(start);
    AdditionMatrix <<<gridSize, blockSize >>> (A, B, C, W);
    cudaEventRecord(stop);
    cudaDeviceSynchronize(); cudaGetLastError();
    milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "CUDA fast time simple (ms): " << milliseconds << std::endl;
    */



  //  C->PrintMatrix();
  //  C->PrintMatrix();
    






  //  AddMatrix(h_A, h_B, h_C, W);

  /*  int* MatrixA;
    int* MatrixB;
    int* MatrixC;
    float milliseconds = 0;
    cudaMalloc(&MatrixA, SIZE * sizeof(int));
    cudaMalloc(&MatrixB, SIZE * sizeof(int));
    cudaMalloc(&MatrixC, SIZE * sizeof(int));

    cudaMemcpy(MatrixA, h_A, SIZE * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(MatrixB, h_B, SIZE * sizeof(int), cudaMemcpyHostToDevice);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    dim3 gridSize = dim3(W / BLOCK_SIZE, W / BLOCK_SIZE, 1);
    dim3 blockSize = dim3(BLOCK_SIZE, BLOCK_SIZE, 1);

    cudaEventRecord(start);
        AdditionMatrix <<<gridSize, blockSize >>>(MatrixA, MatrixB, MatrixC,W);
    cudaEventRecord(stop);
    cudaDeviceSynchronize(); cudaGetLastError();
    milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "CUDA fast time simple (ms): " << milliseconds << std::endl;
    
    cudaEventRecord(start);
    NotOptAdditionMatrix <<<gridSize, blockSize >>> (MatrixA, MatrixB, MatrixC, W);
    cudaEventRecord(stop);
    cudaDeviceSynchronize(); cudaGetLastError();
    milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "CUDA not fast time simple (ms): " << milliseconds << std::endl;
    cudaMemcpy(h_C, MatrixC, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
    printMatrix(h_C, W);*/
    return 0;
}
