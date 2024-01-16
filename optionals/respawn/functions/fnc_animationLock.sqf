/*
 * Author: nikolauska
 *
 * Starts player animation lock loop wher player can only move head
 *
 * Argument:
 *
 * Return value:
 *
 */

#include "script_component.hpp"

[{
    params ["_params", "_pfh"];

    if !((animationState ACE_PLAYER) isEqualTo "HubSpectator_stand") then {
        // Switch player animation to lock movement
        ACE_PLAYER playMove "HubSpectator_stand";
    };

    if !(GVAR(animationLock)) then {
        // Free player from animation lock
        ACE_PLAYER switchMove "AmovPercMstpSlowWrflDnon";

        // Delete this PFH
        [_pfh] call cba_fnc_removePerFrameHandler;
    };
}, 1, []] call cba_fnc_addPerFrameHandler;
