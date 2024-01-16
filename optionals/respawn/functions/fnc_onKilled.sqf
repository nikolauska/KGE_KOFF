/*
 * Author: nikolauska
 *
 * On KGE killed
 *
 * Argument:
 *
 * Return value:
 *
 */

#include "script_component.hpp"

params ["_unit", "_position"];

_unit setVariable [QGVAR(alive), false, true];

_unit allowDamage false;

_unit setPos _position;
_unit hideObjectGlobal true;

// Handle common addon audio
if (["ace_hearing"] call EFUNC(common,classExists)) then {ace_hearing_disableVolumeUpdate = true};
if (["acre_sys_radio"] call EFUNC(common,classExists)) then {[true] call acre_api_fnc_setSpectator};
if (["task_force_radio"] call EFUNC(common,classExists)) then {
    [ACE_PLAYER, true] call TFAR_fnc_forceSpectator;
    ACE_PLAYER setVariable ["tf_unable_to_use_radio", true];
};

// Do full heal if ace medcal is in use
if(ace_medical) then {
    [_unit, _unit] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
};

GVAR(animationLock) = true;
call FUNC(animationLock);

// Publish information about player dying
[QGVAR(onKilled), [_unit]] call CBA_fnc_globalEvent;

KGE_LOGINFO_1("%1 killed",_unit);
