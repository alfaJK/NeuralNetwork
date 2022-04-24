#include "NeuralController.h"


NeuralControl::NeuralControl(NeuralSetting* Neur_Set, Module* ModCollection){
    this->Neur_Set = new NeuralSetting(Neur_Set);
    //===== РЕАЛИЗОВАТЬ ИНИЦИАЛИЗАЦИЮ МОДУЛЕЙ =======


    
    for (int i = 0; i < Neural_setting->Count_Module; i++) {

        switch (Neur_Set->CountModules)
        {
            case 0: continue;
            case 1: continue;
            case 2: continue;
            case 3: continue;

        }
    }

    // this->ModCollection = new Module(ModCollection);

    //===============================================
    
}

NeuralControl::NeuralControl(std::string NS_Path , std::string Mod_Path){
    Neur_Set = new NeuralSetting(NS_Path);
    
    //===== РЕАЛИЗОВАТЬ ИНИЦИАЛИЗАЦИЮ МОДУЛЕЙ =======


    //===============================================


}

NeuralControl::~NeuralControl(){

}