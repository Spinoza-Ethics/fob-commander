//========================================//
//             SITREP Generation          //
//========================================//

// Position and Time Information
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

// Player Stats
private _rank = player getVariable ["Rank", "Private"];
private _xp = player getVariable ["XP", 0];
private _credits = player getVariable ["FieldCredits", 0];
private _rankThresholds = missionNamespace getVariable ["RankThresholds", []];

// Calculate Next Rank Progression
private _nextRankXP = 10000; // Max rank XP 
private _nextRankName = "FOB Commander";

{
    _x params ["_rank", "_threshold"];
    if (_xp < _threshold) exitWith {
        _nextRankXP = _threshold;
        _nextRankName = _rank;
    };
} forEach _rankThresholds;

// Threat Assessment
private _statusColor = "";
private _statusKeyword = "";
private _statusDescription = "";

private _enemiesNearby = player nearEntities [["CAManBase", "Car", "Tank", "Helicopter", "Plane", "Ship"], 1000] select {
    (side _x == east || side _x == resistance) && (alive _x)
};

private _closestEnemyDistance = -1;
if (count _enemiesNearby > 0) then {
    _closestEnemyDistance = (player distance (selectRandom _enemiesNearby));
    {
        private _dist = player distance _x;
        if (_closestEnemyDistance == -1 || _dist < _closestEnemyDistance) then {
            _closestEnemyDistance = _dist;
        };
    } forEach _enemiesNearby;
};

if (_closestEnemyDistance == -1 || _closestEnemyDistance > 1000) then {
    _statusColor = "#00FF00";
    _statusKeyword = "Safe";
    _statusDescription = ": No Enemy Presence Detected Nearby.";
} else {
    if (_closestEnemyDistance <= 200) then {
        _statusColor = "#FF0000";
        _statusKeyword = "Engaged";
        _statusDescription = ": Hostile Forces Present!";
    } else {
        if (_closestEnemyDistance <= 800) then {
            _statusColor = "#FF8800";
            _statusKeyword = "Aware";
            _statusDescription = ": Possible Enemy Presence Nearby.";
        };
    };
};

//========================================//
//              Squad Sitrep              //
//========================================//

// Squad Status
private _squadMembers = units group player;
private _aliveSquadCount = {alive _x && !isPlayer _x} count _squadMembers;
private _totalSquadCount = {!isPlayer _x} count _squadMembers;
private _squadLeader = leader group player;
private _isSquadLeader = (player == _squadLeader);

// Squad Health Assessment
private _woundedSquad = _squadMembers select {(damage _x > 0.2) && (damage _x < 0.9) && alive _x && !isPlayer _x};
private _criticalSquad = _squadMembers select {(damage _x >= 0.9) && alive _x && !isPlayer _x};
private _squadHealthStatus = "Operational";
private _squadHealthColor = "#00FF00";

if (count _criticalSquad > 0) then {
    _squadHealthStatus = "Critical Casualties";
    _squadHealthColor = "#FF0000";
} else {
    if (count _woundedSquad > 0) then {
        _squadHealthStatus = "Wounded Personnel";
        _squadHealthColor = "#FFAA00";
    };
};

// Vehicle Status
private _nearbyVehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 200];
private _availableVehicles = _nearbyVehicles select {
    alive _x &&
    canMove _x &&
    (crew _x) isEqualTo [] &&
    (damage _x < 0.5)
};
private _vehicleStatus = format ["%1 Available", count _availableVehicles];

// Ammunition Status
private _primaryWeapon = primaryWeapon player;
private _ammoStatus = "No Primary Weapon";
if (_primaryWeapon != "") then {
    private _magCount = {_x in magazines player} count getArray(configFile >> "CfgWeapons" >> _primaryWeapon >> "magazines");
    private _totalMags = {_x in (magazines player)} count (magazines player);
    if (_totalMags == 0) then {
        _ammoStatus = "Out of Ammo";
    } else {
        if (_totalMags <= 2) then {
            _ammoStatus = format ["Low Ammo (%1 mags)", _totalMags];
        } else {
            _ammoStatus = format ["Ammo OK (%1 mags)", _totalMags];
        };
    };
};

// Weather and Visibility
private _weather = overcast;
private _visibility = viewDistance;
private _weatherStatus = "Clear";
if (_weather > 0.7) then {
    _weatherStatus = "Overcast";
} else {
    if (_weather > 0.3) then {
        _weatherStatus = "Partly Cloudy";
    };
};

// Time of Day Assessment
private _timeOfDay = "Day";
private _sunAngle = sunOrMoon;
if (_sunAngle < 0.5) then {
    _timeOfDay = "Night";
} else {
    if (_hour < 7 || _hour > 18) then {
        _timeOfDay = "Twilight";
    };
};

//========================================//
//            Display Format              //
//========================================//

private _completionData = [
    _displayTime,
    _displayDate,
    _displayGrid,
    _rank,
    _xp,
    _nextRankXP,
    _nextRankName,
    _credits,
    _statusKeyword,
    _statusDescription,
    _aliveSquadCount,
    _totalSquadCount,
    _squadHealthStatus,
    _vehicleStatus,
    _ammoStatus,
    _weatherStatus,
    _timeOfDay
];

private _hintText = parseText format [
    "<t color='#0066FF' size='1.2' font='PuristaBold'>-----SITREP-----</t><br/><br/>" +
    "<t color='#ffffff' size='1.0'>Weather: %16</t><br/>" +
    "<t color='#ffffff' size='1.0'>Time: %1 (%17)</t><br/>" +
    "<t color='#ffffff' size='1.0'>Date: %2</t><br/>" +
    "<t color='#ffffff' size='1.0'>Grid: %3</t><br/>" +
    "<t color='#ffffff' size='1.0'>==================================</t><br/>" +
    "<t color='#ffffff' size='1.0'>Squad:</t><t color='#ffffff' size='1.0'> %11/%12 Active</t><br/>" +
    "<t color='#ffffff' size='1.0'>Health:</t><t color='#ffffff' size='1.0'> %13</t><br/>" +
    "<t color='#ffffff' size='1.0'>Vehicles:</t><t color='#ffffff' size='1.0'> %14</t><br/>" +
    "<t color='#ffffff' size='1.0'>Ammo:</t><t color='#ffffff' size='1.0'> %15</t><br/>" +
    "<t color='#ffffff' size='1.0'>==================================</t><br/>" +
    "<t color='#FF0000' size='1.0'>Rank:</t><t color='#ffffff' size='1.0'> %4</t><br/>" +
    "<t color='#0066FF' size='1.0'>XP:</t><t color='#ffffff' size='1.0'> %5/%6 to %7</t><br/>" +
    "<t color='#FFFF00' size='1.0'>Field Credits:</t><t color='#ffffff' size='1.0'> %8</t><br/><br/>" +
    "<t color='%18' size='1.1'>%9</t><t color='#ffffff' size='1.1'>%10</t>",
    (_completionData select 0),
    (_completionData select 1),
    (_completionData select 2),
    (_completionData select 3),
    (_completionData select 4),
    (_completionData select 5),
    (_completionData select 6),
    (_completionData select 7),
    (_completionData select 8),
    (_completionData select 9),
    (_completionData select 10),
    (_completionData select 11),
    (_completionData select 12),
    (_completionData select 13),
    (_completionData select 14),
    (_completionData select 15),
    (_completionData select 16),
    _statusColor
];

hint _hintText;
playSound "sitrepSound";
saveGame;

[
    { hint "" },
    [],
    10
] call CBA_fnc_waitAndExecute;