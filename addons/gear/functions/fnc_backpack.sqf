/*
  * Author: nikolauska
  *
  * Creates diary text for backpack
  *
  * Argument:
  *
  * Return value:
  * Diary text
  */

#include "..\script_component.hpp"

params [
    ["_unit", objNull, [objNull]]
];

if !(_unit call EFUNC(common,isAlive)) exitWith {"asd"};

private ["_returnText", "_backpack"];
_returnText = "";
_backpack = backpack _unit;

// BACKPACK
if(_backpack != "") then {
   _image = getText(configFile >> "CfgVehicles" >> _backpack >> "picture") call FUNC(imageCheck);
   _name = getText(configFile >> "CfgVehicles" >> _backpack >> "displayName");
   _returnText = format ["<img image='%1' width='32' height='32'/><execute expression='systemChat ""Item: %2""'>*</execute>  ", _image, _name];
};

_returnText