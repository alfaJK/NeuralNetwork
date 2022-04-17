#include "iostream"
#include "vector"
#include "Module.h"
#include "NeuralSetting.h"
#include "string"

class NeuralControl{
    private:
        std::vector <Module*> ModCollection;
        NeuralSetting* Neur_Set;
    public: 
        NeuralControl(NeuralSetting* Neur_Set, ModuleSetting* ModCollection);
        NeuralControl(std::string NS_Path , std::string Mod_Path);
        ~NeuralControl();
};