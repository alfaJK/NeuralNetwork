#include "Module.h"


class FullConModule : public Module{
    public:
        Matrix DirectDist(Matrix* InputData) override;
        Matrix BackDist(Matrix* InputData , Matrix Deltas) override;
        Matrix GetData() override;
        Matrix SetData() override;

};