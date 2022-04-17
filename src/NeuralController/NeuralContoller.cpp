#include "NeuralController.h"


NeuralControl::NeuralControl(NeuralSetting* Neur_Set, Module* ModCollection){
    this->Neur_Set = new NeuralSetting(Neur_Set);
    //===== РЕАЛИЗОВАТЬ ИНИЦИАЛИЗАЦИЮ МОДУЛЕЙ =======

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