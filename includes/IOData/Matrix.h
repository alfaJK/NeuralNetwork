#include "IOData.h"
#include "vector"
class Matrix:public IOData{
    private:
        int height;
        int width;
        int depth;
    public: 
        Matrix(const Matrix& MatrixCopy);
        Matrix(int w , int h , int d);
        void SplotMatrix(Matrix* Filter);
    //Matrix operator+(const Matrix* SecondMatrix);
    //Matrix operator*(const float* AnyNum);
};