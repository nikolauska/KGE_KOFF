#include "script_component.hpp"

if(hasInterface) exitWith {
    ["KGE_adminChanged", {
        EXPLODE_1_PVT(_this,_isAdmin);

        if(_isAdmin) then {
            call FUNC(activate);
        };
    }] call cba_fnc_addEventHandler;
};
if(!isServer) exitWith {};

GVAR(sideLogic) = createCenter sideLogic;

GVAR(curatorModule) = (createGroup KGE_Zeus_SideLogic) createUnit ["ModuleCurator_F",[0,0,0] , [], 0, ""];
GVAR(curatorModule) setVariable ["Addons",3,true];

// Add all addons to zeus
private ["_addons", "_cfgPatches", "_class"];
_addons = [];
_cfgPatches = configFile >> "cfgpatches";
for "_i" from 0 to (count _cfgPatches - 1) do {
    _class = _cfgPatches select _i;

    if (isclass _class) then {
        _addons pushBack (configName _class);
    };
};
_addons call BIS_fnc_activateAddons;
GVAR(curatorModule) addcuratoraddons _addons;

[QGVAR(activateEvent), {
    // Remove old curator
    if !(isNil QGVAR(assignedCurator)) then {
        unassignCurator GVAR(curatorModule);
    };

    // Assign new curator
    GVAR(assignedCurator) = _this;
    _this assignCurator GVAR(curatorModule);

    {
        _curator = _x;

        //Add all object in mission to editable
        _curator addCuratorEditableObjects [vehicles,true];
        _curator addCuratorEditableObjects [allUnits, true];
        _curator addCuratorEditableObjects [(allMissionObjects "Man"),false];
        _curator addCuratorEditableObjects [(allMissionObjects "Air"),true];
        _curator addCuratorEditableObjects [(allMissionObjects "Ammo"),false];

        // Reduce costs for all actions
        _curator setCuratorWaypointCost 0;
        {_curator setCuratorCoef [_x,0];} forEach ["place","edit","delete","destroy","group","synchronize"];
    } forEach allCurators;
}] call cba_fnc_addEventHandler;