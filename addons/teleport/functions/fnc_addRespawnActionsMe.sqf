/*
  * Author: nikolauska
  *
  * Create ace action menu for teleporting single unit to map position
  *
  * Argument:
  *
  * Return value:
  * Action children array
  */

#include "script_component.hpp"

private _actions = [];

{
    if (!(alive _x) || !(_x getVariable [QEGVAR(respawn,alive), true])) then {
        // Stage for removal
        GVAR(respawned) set [_forEachIndex, nil];
    } else {
        if !(local _x) then {
            _actions pushBack
                [
                    [
                        str(_x),
                        name _x,
                        "",
                        {(_this select 2) call FUNC(toBehind)},
                        {true},
                        {},
                        [_x, ACE_PLAYER]
                    ] call ace_interact_menu_fnc_createAction,
                    [],
                    _x
                ];
        };
    };
} forEach GVAR(respawned);

// Remove nils
GVAR(respawned) = GVAR(respawned) arrayIntersect GVAR(respawned);

_actions
