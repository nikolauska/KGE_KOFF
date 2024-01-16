#include "script_component.hpp"

[{
    ACE_PLAYER createDiarySubject [QGVAR(diarySubject), "Teamroster"];

    [{
      // Update teamroster text
      call FUNC(update);
    }, 600, []] call CBA_fnc_addPerFrameHandler;
}, [], {!(isNull ACE_PLAYER)}] call EFUNC(common,waitUntil);

KGE_LOGINFO("Teamroster Module Initialized.");
