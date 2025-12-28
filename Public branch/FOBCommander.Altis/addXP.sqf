//========================================//
//                 Add XP                 //
//========================================//

// Usage: [amount] execVM "addXP.sqf";
//can use a negative [-amount]  to subtract xp
params ["_amount"];

if (isNil "_amount") exitWith {
    systemChat "Error: No XP amount specified!";
};

private _currentXP = player getVariable ["XP", 0];
private _currentRank = player getVariable ["Rank", "Private"];
private _newXP = _currentXP + _amount;

player setVariable ["XP", _newXP, true];

if (_amount > 0) then {
    systemChat format ["XP Gained: %1 | Total XP: %2", _amount, _newXP];
} else {
    systemChat format ["XP Lost: %1 | Total XP: %2", (abs _amount), _newXP];
};

private _rankThresholds = missionNamespace getVariable ["RankThresholds", []];
private _newRank = _currentRank;

// Check if the player earned a new rank
{
    _x params ["_rank", "_threshold"];
    if (_newXP >= _threshold) then {
        _newRank = _rank;
    };
} forEach _rankThresholds;

// If the rank changed, announce the promotion
if (_newRank != _currentRank) then {
    player setVariable ["Rank", _newRank, true];
    player sideChat format ["PROMOTED! New rank: %1", _newRank];
    playMusic "EventTrack01_F_Curator";
};