#include "IOData.h"
#include "vector"

struct MatrixSize{
    int height;
    int width;
    int depth;
}


class Matrix{
    private:
        MatrixSize Size;
        std::vector<double> MatrixValues;
    public: 
        Matrix(const Matrix& MatrixCopy);
        Matrix(int w , int h , int d);
        MatrixSize GetSize();
        double& operator()(int h_i, int w_j, int d_k);
	    double operator()(int h_i, int w_j, int d_k) const;
	   // friend std::ostream& operator<<(std::ostream& os, const Tensor& tensor);
    //Matrix operator+(const Matrix* SecondMatrix);
    //Matrix operator*(const float* AnyNum);
};