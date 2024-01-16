/*
 * Author: nikolauska
 *
 * Get player animation based on weapon and autorun mode
 *
 * Argument:
 * 0: Unit <Object>
 *
 * Return value:
 *
 */

#include "script_component.hpp"

params ["_mode"];

private _weapon = currentWeapon ACE_PLAYER;

call {
    if(_mode == SPRINT) exitWith {
        if(_weapon == "")                         exitWith {"amovpercmevasnonwnondf"};
        if(_weapon == handgunWeapon ACE_PLAYER)   exitWith {"amovpercmevaslowwpstdf"};
        if(_weapon == primaryWeapon ACE_PLAYER)   exitWith {"amovpercmevaslowwrfldf"};
        if(_weapon == secondaryWeapon ACE_PLAYER) exitWith {"amovpercmevaslowwlnrdf"};
        if(_weapon == binocular ACE_PLAYER)       exitWith {"amovpercmevasnonwbindf"};
    };
    if(_mode == WALK) exitWith {
        if(_weapon == "")                         exitWith {"amovpercmwlksnonwnondf"};
        if(_weapon == handgunWeapon ACE_PLAYER)   exitWith {"amovpercmwlkslowwpstdf"};
        if(_weapon == primaryWeapon ACE_PLAYER)   exitWith {"amovpercmwlkslowwrfldf"};
        if(_weapon == secondaryWeapon ACE_PLAYER) exitWith {"amovpercmwlksraswlnrdf"};
        if(_weapon == binocular ACE_PLAYER)       exitWith {"amovpercmwlksoptwbindf"};
    };
    if(_mode == JOG) exitWith {
        if(_weapon == "")                         exitWith {"amovpercmrunsnonwnondf"};
        if(_weapon == handgunWeapon ACE_PLAYER)   exitWith {"amovpercmrunslowwpstdf"};
        if(_weapon == primaryWeapon ACE_PLAYER)   exitWith {"amovpercmrunslowwrfldf"};
        if(_weapon == secondaryWeapon ACE_PLAYER) exitWith {"amovpercmrunsraswlnrdf"};
        if(_weapon == binocular ACE_PLAYER)       exitWith {"amovpercmrunsnonwbindf"};
    };
};
