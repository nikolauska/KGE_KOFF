/*
 * Author: nikolauska
 *
 * Check if unit is alive
 *
 * Argument:
 * 0: Unit <Object>
 *
 * Return value:
 * Boolean
 */

#include "script_component.hpp"

params [
    ["_unit", ACE_PLAYER, [objNull]]
];

_unit call CBA_fnc_isAlive || _unit getVariable [QEGVAR(respawn,alive), true]
