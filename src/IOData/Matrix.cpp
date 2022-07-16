#include "Matrix.h"
#include "CudaCalc.h"

Matrix::Matrix(int w, int h, int d) {
	Size.width = w;
	Size.height = h;
	Size.depth = d;
	Tensor_Values = std::vector<double>(w * h * d, 0);
}
//Matrix::~Matrix() { Tensor_Values.clear(); }
MatrixSize GetSize(){
    return Size;
}

Matrix::Matrix(const Matrix& MatrixCopy) {
	this->Size.width = MatrixCopy.GetSize().width;
	this->Size.height = MatrixCopy.GetSize().height;
	this->Size.depth = MatrixCopy.GetSize().depth;

	MatrixValues = std::vector<double>(this->Size.width * this->Size.height * this->Size.depth, 0);

	for (int y = 0; y < this->Size.height; y++) {
		for (int x = 0; x < this->Size.width; x++) {
			for (int d = 0; d < this->Size.depth; d++) {
				this->MatrixValues[y * this->Size.depth * this->Size.width + x * this->Size.depth + d] = MatrixCopy(y,x,d);
			}
		}
	}
}

Matrix::Matrix(MatrixSize Size) {
	this->Size.width = Size.width;
	this->Size.height = Size.height;
	this->Size.depth = Size.depth;
	MatrixValues = std::vector<double>(this->Size.width * this->Size.height * this->Size.depth, 0);
}

double& Matrix::operator()(int h_i, int w_j, int d_k) {
	return MatrixValues[h_i * Size.depth * Size.width + w_j * Size.depth + d];
}

double Matrix::operator()(int h_i, int w_j, int d_k) const {
	return MatrixValues[h_i * Size.depth * Size.width + w_j * Size.depth + d];
}

/*
====================вывод данных===========================

std::ostream& operator<<(std::ostream& os, const Tensor& tensor) {
	for (int d = 0; d < tensor.size.depth; d++) {
		for (int i = 0; i < tensor.size.height; i++) {
			for (int j = 0; j < tensor.size.width; j++)
				os << tensor.Tensor_Values[i * (tensor.size.depth * tensor.size.width) + j * tensor.size.depth + d] << " ";
	
		//	os << std::endl;
		}

	//	os << std::endl;
	}
	os << std::endl;
	return os;
}*/