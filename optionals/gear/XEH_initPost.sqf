#include "script_component.hpp"

[{
    ACE_PLAYER createDiarySubject [QGVAR(diarySubject), "Group Gear"];

    // Update gear text
    call FUNC(diary);
}, [], {!(isNull ACE_PLAYER)}] call EFUNC(common,waitUntil);

KGE_LOGINFO("Gear Module Initialized.");
