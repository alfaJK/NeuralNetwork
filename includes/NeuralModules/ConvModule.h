#include "Module.h"


class ConvModule : public Module{
    private:
        std::default_random_engine Generator;
        std::normal_distribution<double> Distribution;
    public:
        Matrix();
        ~Matrix();
        Matrix DirectDist(Matrix* InputData) override;
        Matrix BackDist(Matrix* InputData , Matrix Deltas) override;
        Matrix GetData() override;
        Matrix SetData() override;
};