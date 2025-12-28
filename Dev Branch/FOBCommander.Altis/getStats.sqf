//========================================//
//             Get Player Stats           //
//========================================//

// Usage: execVM "getStats.sqf";
//just gets the players stats. does nothing with them. useful to check if player has enough xp,credit,rank to buy something 
private _xp = player getVariable ["XP", 0];
private _credits = player getVariable ["FieldCredits", 0];
private _rank = player getVariable ["Rank", "Private"];