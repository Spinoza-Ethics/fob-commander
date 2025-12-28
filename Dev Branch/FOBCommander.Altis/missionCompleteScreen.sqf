//========================================//
//             Mission Completion         //
//========================================//

private _musicTracks = [
    "AmbientTrack01_F",
    "AmbientTrack01a_F",
    "AmbientTrack01b_F",
    "AmbientTrack03_F",
    "AmbientTrack04a_F",
    "BackgroundTrack01_F",
    "AmbientTrack01a_F",
    "LeadTrack01_F_EPA",
    "EventTrack02a_F_EPB",
    "EventTrack03_F_EPB",
    "EventTrack04_F_EPB",
    "BackgroundTrack01_F_EPB",
    "BackgroundTrack02_F_EPC",
    "EventTrack03_F_EPC"
];

private _missionNames = [
    "Eagle Strike",
    "Whispering Sands",
    "Crimson Dawn",
    "Nightingale",
    "Shadowfall Gambit",
    "Desert Serpent",
    "Ghost Protocol",
    "Thunderclap Offensive",
    "Ironclad Retrieval",
    "Viper's Nest",
    "Arctic Apex",
    "Red Horizon",
    "Silent Blade",
    "Firestorm Pact",
    "Crossbow Gambit",
    "Starlight Cadence",
    "Black Mamba",
    "Emerald Forge",
    "Broken Arrow",
    "Serpent's Coil",
    "Dragon's Breath",
    "Phantom Reach",
    "Steel Rain",
    "Cobalt Strike",
    "Winter's Grasp",
    "Sunfall Protocol",
    "Desert Wraith",
    "Hydra's Head",
    "Stone Aegis",
    "Vanguard Push",
    "Overlord",
    "Desert Storm",
    "Urgent Fury",
    "Rolling Thunder",
    "Red Dawn",
    "Eagle Claw",
    "Anaconda",
    "Market Garden",
    "Just Cause",
    "Enduring Freedom"
];

private _randomMissionName = "Operation " + (selectRandom _missionNames);
private _playerGridCoords = mapGridPosition player;
private _currentDateTime = date;

private _year = _currentDateTime select 0;
private _month = _currentDateTime select 1;
private _day = _currentDateTime select 2;
private _hour = _currentDateTime select 3;
private _minute = _currentDateTime select 4;

private _formattedMonth = str _month;
if (count _formattedMonth == 1) then {
    _formattedMonth = "0" + _formattedMonth;
};

private _formattedDay = str _day;
if (count _formattedDay == 1) then {
    _formattedDay = "0" + _formattedDay;
};

private _formattedHour = str _hour;
if (count _formattedHour == 1) then {
    _formattedHour = "0" + _formattedHour;
};

private _formattedMinute = str _minute;
if (count _formattedMinute == 1) then {
    _formattedMinute = "0" + _formattedMinute;
};

private _displayDate = format ["%1/%2/%3", _formattedMonth, _formattedDay, _year];
private _displayTime = format ["%1:%2", _formattedHour, _formattedMinute];
private _displayGrid = str _playerGridCoords;

// Debrief messages
private _debriefMessages = [
    "Mission accomplished! Another threat neutralized.",
    "Excellent work, soldier. The objective is secure.",
    "A job well done. Your efforts ensured success.",
    "Objective complete. The enemy is in disarray.",
    "Threat eliminated. Area secured. Proceed to next assignment.",
    "Outstanding performance. The mission is a resounding success.",
    "Target neutralized. Your tactical execution was flawless.",
    "Another victory. Your contribution was critical.",
    "Objective complete. Well done, team.",
    "Situation stable. Threat assessed and contained.",
    "Strategic objective achieved. Impact minimal, results maximum.",
    "Perimeter secure. Threat assessment: low. Good work.",
    "Objective fully acquired. No significant resistance encountered.",
    "Analysis complete. Data confirms mission success.",
    "Command acknowledges your success. Well executed.",
    "Another piece of the puzzle. Progress is steady.",
    "And just like that, the bad guys are less bad. Or just gone.",
    "Well, that escalated quickly... and then de-escalated even quicker. Nice!",
    "Pretty sure that was worth at least, like, three high-fives.",
    "Congrats! You've officially earned your coffee break.",
    "Pretty sure someone's getting a medal. Probably you.",
    "Looks like someone forgot to tell the enemy you were good at this.",
    "Did we just win? I think we just won.",
    "That was... surprisingly efficient. Did you even break a sweat?",
    "Just another day at the office, right? (Except with more explosions).",
    "Enemies defeated. High scores achieved. Time for snacks.",
    "They'll never see us coming. Because, well, they're not seeing anything anymore.",
    "Consider that problem... solved with extreme prejudice.",
    "If only real life was this easy. Great job!",
    "Looks like you brought a gun to a knife fight. And won.",
    "Another day, another victory. Your legend grows... probably.",
    "Mission accomplished! Minor international law infringements noted.",
    "Objectives mostly hit. Now, about the 'collateral'...",
    "Congrats! You turned a problem into 'future us' problem.",
    "Objective done. We'll just sweep the rest under the rug.",
    "Good work! Enemy's confused, as planned.",
    "Mission success! Paperwork mountain awaits.",
    "Survived! High five for not making a new crater. Objective's done too.",
    "Chaos contained, mostly. Your tax dollars are... somewhere.",
    "Less bad than before. That's a win, right?",
    "That was a mission. It's over. Time for pizza."
];
private _customDebriefMessage = selectRandom _debriefMessages;

private _completionData = [
    _randomMissionName,
    _displayTime,
    _displayDate,
    _displayGrid,
    _customDebriefMessage
];

hintSilent parseText format [
    "<t color='#FFA500' size='1.2' font='PuristaBold'>====================</t><br/>" +
    "<t color='#FFA500' size='1.2' font='PuristaBold'>%1</t><br/>" +
    "<t color='#FFA500' size='1.2' font='PuristaBold'>====================</t><br/>" +
    "<t color='#00ff00' size='1.0' font='PuristaBold'>Success</t><br/><br/>" +
    "<t color='#ADD8E6' size='1.1'>Debrief:</t><t color='#ffffff' size='1.1'> %5</t>", // Light blue prefix, white text
    (_completionData select 0),
    (_completionData select 1),
    (_completionData select 2),
    (_completionData select 3),
    (_completionData select 4)
];

playMusic "EventTrack03_F_Curator";

// Mission complete sequence
[_musicTracks] spawn {
    params ["_tracks"];
    sleep 12;
    hintSilent "";
    sleep 2;
    
    private _selectedTrack = selectRandom _tracks;
    playMusic _selectedTrack;
    
    // Subtitle phrases
    private _phrases = [
        "Objective secured, regroup at base.",
        "Mission complete, return to base.",
        "Good work. All units RTB.",
        "Area clear. Proceed to extraction.",
        "Objective achieved. Stand by for next tasking.",
        "Well done. Prepare to redeploy.",
        "Target neutralized. RTB when ready.",
        "Zone secure. Await further orders.",
        "All clear. Moving to next position.",
        "Task complete. Regroup and resupply.",
        "Position cleared. Return to staging.",
        "Mission success. Prepare to exfil.",
        "Good job team. Await new orders.",
        "Sector secured. Pull back to rally point.",
        "Primary task done. Stand by.",
        "Orders complete. Holding for new task.",
        "Mission accomplished. Regroup and hold.",
        "RTB. Await further instructions.",
        "All objectives cleared. Move to fallback.",
        "Unit is clear. Extraction is green.",
        "Site is secure. RTB when able.",
        "You’ve done well. Return to base.",
        "Exfil route is clear. Move out.",
        "Area is pacified. Return to base.",
        "You're done here. Stand by for tasking.",
        "Job’s done. Fall back to HQ.",
        "Primary is handled. Await command.",
        "Situation normal. Regroup and wait.",
        "Tactical objectives fulfilled. RTB.",
        "You're clear to move out.",
        "Clear the area and regroup.",
        "Return to safe zone immediately.",
        "Route is clear. Begin fallback.",
        "Enemy forces neutralized. RTB.",
        "Clear skies. Return to command.",
        "All teams accounted for. Pull back."
    ];

    private _index = floor (random (count _phrases));
    private _selected = _phrases select _index;
    ["High Command", _selected] remoteExec ["BIS_fnc_showSubtitle", 0, true];
    playSound "MissionComplete";
};