#include "Matrix.h"
#include "CudaCalc.h"

Matrix::Matrix(const Matrix& MatrixCopy){

}

Matrix::Matrix(int w , int h , int d): width(w), height(h), depth(d){
    MatrixData = std::vector<double>(w * h * d, 0);
}

void Matrix::SplotMatrix(Matrix* Filter){
    gridSize = dim3(W / BLOCK_SIZE, W / BLOCK_SIZE, 1);
    blockSize = dim3(BLOCK_SIZE, BLOCK_SIZE, 1);
    cudaEventCreate(&Start);
    cudaEventCreate(&Stop);
    double* CudaData
    cudaMallocManaged(&CudaData, width * height * depth * sizeof(int));
    cudaMemcpy(Data, MatrixData, width * height * depth * sizeof(int), cudaMemcpyHostToDevice);
    cudaEventRecord(Start);

    

    // NotOptAdditionMatrix <<<gridSize, blockSize >>> (InputMatrix, Filter, OutputMatrix);
    //AdditionMatrix << <gridSize, blockSize >>> (InputMatrix, Filter, OutputMatrix);

    cudaEventRecord(Stop);
    cudaDeviceSynchronize();
    cudaGetLastError();
    cudaMemcpy(Data2, Data, width * height * sizeof(int), cudaMemcpyDeviceToHost);
}

//Matrix operator+(const Matrix* SecondMatrix);
//Matrix operator*(const float* AnyNum);