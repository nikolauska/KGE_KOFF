/*
 * Author: nikolauska
 *
 * Chack if player can autorun
 *
 * Argument:
 *
 * Return value:
 *
 */

#include "script_component.hpp"

if !(alive ACE_PLAYER) exitWith {false};

// If KGE respawn is used
if !(ACE_PLAYER getVariable [QEGVAR(respawn,alive), true]) exitWith {false};

if(vehicle ACE_PLAYER != ACE_PLAYER) exitWith {false};
if(surfaceIsWater (getPosASL ACE_PLAYER)) exitWith {false};

// No need for fatigue and gradient check for walking
if(GVAR(autoRunMode) isEqualTo WALK) exitWith {true};

// Disable running when weapon is holstered
if((animationState ACE_PLAYER) in GVAR(disablingAnimation)) exitWith {false};

private _fatigue = getFatigue ACE_PLAYER;
if(_fatigue > GVAR(fatigueThreshold)) then { GVAR(lastMode) = GVAR(autoRunMode); GVAR(autoRunMode) = JOG; };

private _gradient = ACE_PLAYER call FUNC(getTerrainGradient);
if(_gradient < GVAR(terrainGradientMaxDecline)) then { GVAR(lastMode) = GVAR(autoRunMode); GVAR(autoRunMode) = WALK };
if(_gradient > GVAR(terrainGradientMaxIncline)) then { GVAR(lastMode) = GVAR(autoRunMode); GVAR(autoRunMode) = WALK };

// If sprint is not allowed, change to jog
if(!isSprintAllowed ACE_PLAYER && GVAR(autoRunMode) == SPRINT) then { GVAR(autoRunMode) = JOG; };

// If forced walk, switch to walk
if(GVAR(forceWalk) && GVAR(autoRunMode) != WALK) then { GVAR(autoRunMode) = WALK; };
if(isForcedWalk ACE_PLAYER && GVAR(autoRunMode) != WALK) then { GVAR(autoRunMode) = WALK; };

true;
