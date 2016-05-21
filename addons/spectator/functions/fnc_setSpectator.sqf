/*
 * Author: SilentSpike
 * Sets local client to the given spectator state (virtually)
 * To physically handle a spectator see ace_spectator_fnc_stageSpectator
 *
 * Client will be able to communicate in ACRE/TFAR as appropriate
 * The spectator interface will be opened/closed
 *
 * Arguments:
 * 0: Spectator state of local client <BOOL> (default: true)
 * 1: Force interface <BOOL> (default: true)
 *
 * Return Value:
 * None <NIL>
 *
 * Example:
 * [true] call ace_spectator_fnc_setSpectator
 *
 * Public: Yes
 */

#include "script_component.hpp"

params [["_set",true,[true]], ["_force",true,[true]]];

// Only clients can be spectators
if (!hasInterface) exitWith {};

// Only dead can open spectator
if (_set && {GVAR(alive)}) exitWith {};

// Exit if no change
if (_set isEqualTo GVAR(isSet)) exitWith {};

if (_set) then {
    // Initalize camera variables
    GVAR(camBoom) = 0;
    GVAR(camDolly) = [0,0];
    GVAR(camGun) = false;

    // Initalize display variables
    GVAR(ctrlKey) = false;
    GVAR(heldKeys) = [];
    GVAR(heldKeys) resize 255;
    GVAR(mouse) = [false,false];
    GVAR(mousePos) = [0.5,0.5];

    // Update units before opening to support pre-set camera unit
    [] call FUNC(updateUnits);

    GVAR(camPos) params ["_camX", "_camY", "_camZ"];
    if(_camX == 0 && {_camY == 0} && {_camZ == 0}) then {
        if(!isNull KGE_Player) then {
            GVAR(camPos) = getPosASL KGE_Player;
        } else {
            GVAR(camPos) = ATLtoASL [worldSize * 0.5, worldSize * 0.5, 20]
        };
    };

    // Initalize the camera objects
    GVAR(freeCamera) = "Camera" camCreate (ASLtoATL GVAR(camPos));
    GVAR(unitCamera) = "Camera" camCreate [0,0,0];
    GVAR(targetCamera) = "Camera" camCreate [0,0,0];

    // Initalize view
    GVAR(unitCamera) camSetTarget GVAR(targetCamera);
    GVAR(unitCamera) camCommit 0;
    [] call FUNC(transitionCamera);

    // Close map and clear radio
    openMap [false,false];
    clearRadio;

    // Disable BI damage effects
    BIS_fnc_feedback_allowPP = false;

    // Close any open dialogs
    while {dialog} do {
        closeDialog 0;
    };

    [{
        // Create the display
        (findDisplay 46) createDisplay QGVAR(interface);

        // If not forced, make esc end spectator
        if (_this) then {
            (findDisplay 12249) displayAddEventHandler ["KeyDown", {
                if (_this select 1 == 1) then {
                    [false] call ace_spectator_fnc_setSpectator;
                    true
                };
            }];
        };
    }, !_force] call AFUNC(common,execNextFrame);

    // Cache and disable nametag settings
    if (["ace_nametags"] call AFUNC(common,isModLoaded)) then {
        GVAR(nametagSettingCache) = [EGVAR(nametags,showPlayerNames), EGVAR(nametags,showNamesForAI)];
        EGVAR(nametags,showPlayerNames) = 0;
        EGVAR(nametags,showNamesForAI) = false;
    };
} else {
    // Close any open dialogs (could be interrupts)
    while {dialog} do {
        closeDialog 0;
    };

    // Kill the display
    (findDisplay 12249) closeDisplay 0;

    // Terminate camera
    GVAR(freeCamera) cameraEffect ["terminate", "back"];
    camDestroy GVAR(freeCamera);
    camDestroy GVAR(unitCamera);
    camDestroy GVAR(targetCamera);

    clearRadio;

    // Return to player view
    player switchCamera "internal";

    // Enable BI damage effects
    BIS_fnc_feedback_allowPP = true;

    // Cleanup camera variables
    GVAR(camBoom) = nil;
    GVAR(camDolly) = nil;
    GVAR(camGun) = nil;
    GVAR(freeCamera) = nil;
    GVAR(unitCamera) = nil;
    GVAR(targetCamera) = nil;

    // Cleanup display variables
    GVAR(ctrlKey) = nil;
    GVAR(heldKeys) = nil;
    GVAR(mouse) = nil;
    GVAR(mousePos) = nil;

    // Reset nametag settings
    if (["ace_nametags"] call AFUNC(common,isModLoaded)) then {
        EGVAR(nametags,showPlayerNames) = GVAR(nametagSettingCache) select 0;
        EGVAR(nametags,showNamesForAI) = GVAR(nametagSettingCache) select 1;
        GVAR(nametagSettingCache) = nil;
    };

    // Incase unload doesn't happen automatically
    if(!isNil QGVAR(iconHandler)) {
        removeMissionEventHandler ["Draw3D",GVAR(iconHandler)];
        GVAR(iconHandler) = nil;
    }
};

// Reset interruptions
GVAR(interrupts) = [];

// Mark spectator state for reference
GVAR(isSet) = _set;

["spectatorSet",[_set]] call AFUNC(common,localEvent);
