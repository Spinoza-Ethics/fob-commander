//========================================//
//             Add/Remove Credits         //
//========================================//

// Usage: [amount] execVM "addCredits.sqf";
//can use a negative [-amount]  to subtract credits
params ["_amount"];

if (isNil "_amount") exitWith {
    systemChat "Error: No credit amount specified!";
};

private _currentCredits = player getVariable ["FieldCredits", 0];
private _newCredits = _currentCredits + _amount;

// Ensure credits don't go below zero
if (_newCredits < 0) then {
    _newCredits = 0;
    systemChat "Warning: Cannot go below 0 Field Credits!";
};

player setVariable ["FieldCredits", _newCredits, true];

// Inform the player about the credit change
if (_amount > 0) then {
    systemChat format ["Fc Gained: %1 | Total Fc: %2", _amount, _newCredits];
} else {
    systemChat format ["Fc Spent: %1 | Total Fc: %2", (abs _amount), _newCredits];
};