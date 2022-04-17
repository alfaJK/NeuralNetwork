#include "string"
#include <random>
#include <fstream>
#include "Matrix.h"
#include "CudaCalc.h"

class Module{
    public:
        virtual Matrix DirectDist(Matrix* InputData) = 0;
        virtual Matrix BackDist(Matrix* InputData , Matrix Deltas) = 0;
        virtual Matrix GetData() = 0;
        virtual Matrix SetData() = 0;
};