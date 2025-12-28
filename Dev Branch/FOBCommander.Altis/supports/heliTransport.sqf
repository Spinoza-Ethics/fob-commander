// Elite Transport - Finalized Failsafe System
// Author: Gemini AI

// =================================================================
// Configuration Section
// =================================================================
private _transportConfig = createHashMapFromArray [
	["cooldownTime", 300], // Cooldown in seconds
	["spawnDistance", 3000],
	["spawnHeight", 150],
	["playerTimeout", 60], // Dialog timeout
	["boardTimeout", 180], // Boarding timeout
	["rtbDistance", 2000],
	["rtbTime", 120] // RTB timeout
];

// Helicopter types
private _vehicles = [
	["B_Heli_Light_01_F", "Little Bird", "B_Pilot_F"],
	["B_Heli_Transport_01_F", "Ghost Hawk", "B_Pilot_F"],
	["B_Heli_Transport_03_F", "Huron", "B_Pilot_F"],
	["B_T_VTOL_01_infantry_F", "Blackfish", "B_T_Pilot_F"]
];

// =================================================================
// Main Transport Function
// =================================================================
// Checks for active transport and cooldown.
if (!isNil "transportActive" && {transportActive}) exitWith {
	["Pilot", "Transport active"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
};

private _cooldown = missionNamespace getVariable ["transportCD", (_transportConfig get "cooldownTime") * -1];
private _remaining = (_transportConfig get "cooldownTime") - (time - _cooldown);
if (_remaining > 0) exitWith {
	player sideChat format ["Transport cooldown: %1 seconds remaining.", ceil _remaining];
};

// =================================================================
// Dialog and Map Interaction (Unchanged)
// =================================================================
private _dialog = (findDisplay 46) createDisplay "RscDisplayEmpty";

private _bg = _dialog ctrlCreate ["RscFrame", 1000];
_bg ctrlSetPosition [0.3, 0.25, 0.4, 0.5];
_bg ctrlSetBackgroundColor [0, 0, 0, 0.85];
_bg ctrlCommit 0;

private _title = _dialog ctrlCreate ["RscText", 1001];
_title ctrlSetText "TRANSPORT REQUEST";
_title ctrlSetPosition [0.32, 0.28, 0.36, 0.04];
_title ctrlSetBackgroundColor [0.2, 0.6, 0.2, 0.9];
_title ctrlSetTextColor [1, 1, 1, 1];
_title ctrlCommit 0;

transportChoice = -1;
{
	private _btn = _dialog ctrlCreate ["RscButton", 2000 + _forEachIndex];
	_btn ctrlSetText (_x select 1);
	_btn ctrlSetPosition [0.32, 0.34 + (_forEachIndex * 0.06), 0.36, 0.05];
	_btn ctrlSetBackgroundColor [0.1, 0.4, 0.1, 0.8];
	_btn ctrlAddEventHandler ["ButtonClick", format ["transportChoice = %1", _forEachIndex]];
	_btn ctrlCommit 0;
} forEach _vehicles;

private _mapBtn = _dialog ctrlCreate ["RscButton", 3000];
_mapBtn ctrlSetText "SELECT LZ ON MAP";
_mapBtn ctrlSetPosition [0.32, 0.58, 0.36, 0.08];
_mapBtn ctrlSetBackgroundColor [0.2, 0.2, 0.6, 0.8];
_mapBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_ctrl"];
	if (transportChoice == -1) exitWith { ["Pilot", "Select helicopter first"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
	(ctrlParent _ctrl) closeDisplay 0;
	transportMapOpen = true;
}];
_mapBtn ctrlCommit 0;

transportMapOpen = false;
private _dialogOpenTime = time;
waitUntil {transportMapOpen || time > (_dialogOpenTime + (_transportConfig get "playerTimeout"))};

if (transportChoice < 0) exitWith {
	transportChoice = nil;
	transportMapOpen = nil;
	["Pilot", "Transport request timed out."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
};

private _vehData = _vehicles select transportChoice;
["Pilot", "Click map for pickup LZ."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
sleep 0.2;
openMap true;

transportLZ = nil;
private _mapEH = addMissionEventHandler ["MapSingleClick", {
	params ["", "_pos"];
	transportLZ = _pos;
	removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
	closeMap;
}];

waitUntil {!isNil "transportLZ" || !visibleMap};
if (isNil "transportLZ") exitWith {
	removeMissionEventHandler ["MapSingleClick", _mapEH];
	transportChoice = nil;
	transportMapOpen = nil;
	["Pilot", "Pickup LZ selection cancelled."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
};

private _lz = transportLZ;
transportLZ = nil;
transportChoice = nil;
transportMapOpen = nil;

missionNamespace setVariable ["transportCD", time, true];
transportActive = true;
["Pilot", format ["%1 inbound to pickup LZ %2", _vehData select 1, mapGridPosition _lz]] remoteExec ["BIS_fnc_showSubtitle", 0, true];

// =================================================================
// Spawn Block
// All variables passed via config object to maintain strict scope control.
// =================================================================
private _config = createHashMapFromArray [
	["type", _vehData select 0],
	["name", _vehData select 1],
	["pilot", _vehData select 2],
	["lz", _lz],
    ["transportConfig", _transportConfig] // Passed the config object for sub-spawns
];

[_config] spawn {
	params ["_cfg"];
	
	private _type = _cfg get "type";
	private _name = _cfg get "name";
	private _pilot = _cfg get "pilot";
	private _lz = _cfg get "lz";
    private _transportConfig = _cfg get "transportConfig";

	private _fnc_cleanup = {
		params ["_heli", "_grp", "_markers"];
		transportActive = false;
		{ if (_x != "" && getMarkerType _x != "") then { deleteMarker _x; }; } forEach _markers;
		if (!isNull _heli) then {
			{ if (!isNull _x) then { deleteVehicle _x; }; } forEach (crew _heli);
			deleteVehicle _heli;
		};
		if (!isNull _grp) then { deleteGroup _grp; };
		transportChoice = nil;
		transportMapOpen = nil;
		transportLZ = nil;
		transportDest = nil;
		transportWP1 = nil;
		transportWP2 = nil;
	};
	
	private _angle = random 360;
	private _spawnPos = _lz vectorAdd [(_transportConfig get "spawnDistance") * cos _angle, (_transportConfig get "spawnDistance") * sin _angle, (_transportConfig get "spawnHeight")];
	
	private _heli = createVehicle [_type, _spawnPos, [], 0, "FLY"];
	if (isNull _heli) exitWith { transportActive = false; ["Pilot", "Transport helicopter spawn failed"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
	
	private _grp = createGroup west;
	if (isNull _grp) exitWith { deleteVehicle _heli; transportActive = false; ["Pilot", "Transport crew spawn failed"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
	
	private _crew = _grp createUnit [_pilot, _spawnPos, [], 0, "NONE"];
	if (isNull _crew) exitWith { [_heli, _grp, []] call _fnc_cleanup; ["Pilot", "Transport pilot spawn failed"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
	
	_crew moveInDriver _heli;
	_crew setSkill 1;
	_crew allowFleeing 0;
	
	private _allMarkers = [];
	private _turretPaths = allTurrets [_heli, false];
	{
		private _turretPath = _x;
		if (count _turretPath > 0) then {
			private _gunner = _grp createUnit [_pilot, _spawnPos, [], 0, "NONE"];
			if (!isNull _gunner) then {
				_gunner moveInTurret [_heli, _turretPath];
				_gunner setSkill 1;
				_gunner allowFleeing 0;
			};
		};
	} forEach _turretPaths;
	
	private _originalCrew = crew _heli;

	_heli flyInHeight 150;
	_heli setSpeedMode "FULL";
	_heli setFuel 1;
	_heli engineOn true;
	_grp setBehaviour "AWARE";
	_grp setCombatMode "RED";
	_grp setFormation "COLUMN";
	
	{
		_x setSkill ["aimingAccuracy", 0.8];
		_x setSkill ["aimingShake", 0.7];
		_x setSkill ["aimingSpeed", 0.9];
		_x setSkill ["courage", 1.0];
		_x setSkill ["reloadSpeed", 0.8];
		_x setSkill ["spotDistance", 0.9];
		_x setSkill ["spotTime", 0.8];
	} forEach (units _grp);
	
	private _markerPickup = createMarker [format ["lz_pickup_%1", time], _lz];
	_markerPickup setMarkerType "hd_pickup";
	_markerPickup setMarkerColor "ColorOrange";
	_markerPickup setMarkerText format ["%1 Pickup LZ", _name];
	_allMarkers pushBack _markerPickup;
	
	private _wp = _grp addWaypoint [_lz, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointStatements ["true", "vehicle this land 'GET IN'"];
	
	private _distance = _heli distance2D _lz;
	private _speed = 60;
	private _etaSeconds = (_distance / _speed) + 30;
	private _etaMinutes = _etaSeconds / 60;
	["Pilot", format ["ETA %1 minutes", ceil _etaMinutes]] remoteExec ["BIS_fnc_showSubtitle", 0, true];
	
	private _healthMonitor = [_heli, _grp, _allMarkers, _fnc_cleanup, _originalCrew, _transportConfig] spawn {
		params ["_heli", "_grp", "_markers", "_cleanup", "_originalCrew", "_transportConfig"];
		
		while {alive _heli && transportActive} do {
			sleep 1;
			if (damage _heli > 0.9) exitWith {
				["Pilot", "MAYDAY! Helicopter critically damaged - emergency landing!"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
				_heli setDamage 0.95;
				_heli land "LAND";
				_heli setSpeedMode "LIMITED";
				private _emergencyLZ = getPos _heli;
				{deleteWaypoint [_grp, _forEachIndex]} forEach waypoints _grp;
				_grp addWaypoint [_emergencyLZ, 0] setWaypointType "LAND";
				waitUntil { sleep 1; (getPos _heli select 2) < 5 || !alive _heli || damage _heli >= 1 };
				if (alive _heli) then {
					["Pilot", "Emergency landing complete - helicopter damaged beyond repair"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
					sleep 5;
					{ if (isPlayer _x && vehicle _x == _heli) then { _x action ["GetOut", _heli]; }; } forEach allUnits;
					sleep 3;
					_heli setFuel 0;
					_heli engineOn false;
					sleep 60;
					_heli setDamage 1;
				} else { ["Pilot", "Helicopter crashed!"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
				[_heli, _grp, _markers] call _cleanup;
			};
			if (!alive (driver _heli) || isNull (driver _heli)) exitWith { ["Pilot", "Transport pilot KIA - helicopter going down"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; [_heli, _grp, _markers] call _cleanup; };
			if (fuel _heli < 0.1) exitWith { ["Pilot", "Transport helicopter out of fuel - emergency landing"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; _heli setFuel 0; _heli land "LAND"; sleep 10; [_heli, _grp, _markers] call _cleanup; };
		};
	};
	
	waitUntil { sleep 0.5; (_heli distance2D _lz) < 200 || !alive _heli || !transportActive || damage _heli > 0.9 || !alive (driver _heli) };
	terminate _healthMonitor;
	if (!alive _heli || !transportActive || damage _heli > 0.9 || !alive (driver _heli)) exitWith { [_heli, _grp, _allMarkers] call _fnc_cleanup; };
	
	["Pilot", "Landing at pickup LZ"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
	_heli land "GET IN";
	waitUntil { sleep 0.5; (getPos _heli select 2) < 3 || !alive _heli || damage _heli > 0.9 || !alive (driver _heli) };
	if (!alive _heli || damage _heli > 0.9 || !alive (driver _heli)) exitWith { [_heli, _grp, _allMarkers] call _fnc_cleanup; };
	_heli engineOn false;
	["Pilot", "Ready for boarding - Departing in 3 minutes"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
	
	private _timeout = time + (_transportConfig get "boardTimeout");
	private _boarded = false;
	private _warningGiven = false;
	private _boardedPlayers = [];
	
	while {!_boarded && time < _timeout && alive _heli && transportActive} do {
		sleep 2;
		if (damage _heli > 0.9 || !alive (driver _heli)) exitWith { [_heli, _grp, _allMarkers] call _fnc_cleanup; };
		_boardedPlayers = [];
		{ if (isPlayer _x && vehicle _x == _heli && _x != driver _heli) then { _boardedPlayers pushBack _x; _boarded = true; }; } forEach allUnits;
		if (!_warningGiven && (_timeout - time) <= 30) then { _warningGiven = true; ["Pilot", "Departing in 30 seconds"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
	};
	
	if (!alive _heli || damage _heli > 0.9 || !alive (driver _heli)) exitWith { [_heli, _grp, _allMarkers] call _fnc_cleanup; };
	_heli engineOn true;
	
	if (_boarded && count _boardedPlayers > 0) then {
		deleteMarker _markerPickup;
		_allMarkers deleteAt (_allMarkers find _markerPickup);
		
		["Pilot", format ["%1 players aboard - select destination", count _boardedPlayers]] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		
		["Pilot", "Select destination LZ on map."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		openMap true;
		
		transportDest = nil;
		private _destEH = addMissionEventHandler ["MapSingleClick", {
			params ["", "_pos"];
			transportDest = _pos;
			removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
			closeMap;
		}];
		
		waitUntil { sleep 0.5; !isNil "transportDest" || !alive _heli || damage _heli > 0.9 || !alive (driver _heli) };
		
		if (!alive _heli || damage _heli > 0.9 || !alive (driver _heli)) exitWith {
			removeMissionEventHandler ["MapSingleClick", _destEH];
			[_heli, _grp, _allMarkers] call _fnc_cleanup;
		};
		
		private _dest = transportDest;
		transportDest = nil;
		
		private _flightMonitor = [_heli, _grp, _allMarkers, _fnc_cleanup, _originalCrew, _transportConfig] spawn {
			params ["_heli", "_grp", "_markers", "_cleanup", "_originalCrew", "_transportConfig"];
			
			while {alive _heli && transportActive && (_heli distance2D (getPos _heli)) < 100} do {
				sleep 2;
				if (damage _heli > 0.9 || !alive (driver _heli)) exitWith {
					["Pilot", "MAYDAY! Emergency situation!"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
					if (alive _heli && damage _heli < 1) then {
						["Pilot", "Attempting emergency landing!"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
						_heli land "LAND";
						_heli setSpeedMode "LIMITED";
						waitUntil { sleep 1; (getPos _heli select 2) < 5 || !alive _heli || damage _heli >= 1 };
						if (alive _heli) then {
							["Pilot", "Emergency landing - evacuate immediately!"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
							{ if (isPlayer _x && vehicle _x == _heli) then { _x action ["GetOut", _heli]; }; } forEach allUnits;
							sleep 5;
							sleep 60;
							_heli setDamage 1;
						};
					} else { ["Pilot", "Helicopter going down! Brace for impact!"] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
					[_heli, _grp, _markers] call _cleanup;
				};
			};
		};
		
		private _markerDest = createMarker [format ["lz_dropoff_%1", time], _dest];
		_markerDest setMarkerType "hd_pickup";
		_markerDest setMarkerColor "ColorOrange";
		_markerDest setMarkerText format ["%1 Drop-off LZ", _name];
		_allMarkers pushBack _markerDest;
		
		["Pilot", "Select first waypoint"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		openMap true;
		
		transportWP1 = nil;
		private _wp1EH = addMissionEventHandler ["MapSingleClick", { params ["", "_pos"]; transportWP1 = _pos; removeMissionEventHandler ["MapSingleClick", _thisEventHandler]; }];
		waitUntil {!isNil "transportWP1" || !alive _heli || damage _heli > 0.9};
		
		private _wp1Pos = _dest;
		private _markerWP1 = "";
		if (!isNil "transportWP1" && alive _heli) then {
			_wp1Pos = transportWP1;
			transportWP1 = nil;
			_markerWP1 = createMarker [format ["wp1_%1", time], _wp1Pos];
			_markerWP1 setMarkerType "mil_dot";
			_markerWP1 setMarkerColor "ColorBlue";
			_markerWP1 setMarkerText "WP1";
			_allMarkers pushBack _markerWP1;
		};
		
		["Pilot", "Select second waypoint"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		transportWP2 = nil;
		private _wp2EH = addMissionEventHandler ["MapSingleClick", { params ["", "_pos"]; transportWP2 = _pos; removeMissionEventHandler ["MapSingleClick", _thisEventHandler]; closeMap; }];
		waitUntil {!isNil "transportWP2" || !alive _heli || damage _heli > 0.9};
		
		private _wp2Pos = _dest;
		private _markerWP2 = "";
		if (!isNil "transportWP2" && alive _heli) then {
			_wp2Pos = transportWP2;
			transportWP2 = nil;
			_markerWP2 = createMarker [format ["wp2_%1", time], _wp2Pos];
			_markerWP2 setMarkerType "mil_dot";
			_markerWP2 setMarkerColor "ColorBlue";
			_markerWP2 setMarkerText "WP2";
			_allMarkers pushBack _markerWP2;
		};

		if (!alive _heli || damage _heli > 0.9) exitWith { terminate _flightMonitor; [_heli, _grp, _allMarkers] call _fnc_cleanup; };

		{deleteWaypoint [_grp, _forEachIndex]} forEach waypoints _grp;
		
		private _wp1 = _grp addWaypoint [_wp1Pos, 0];
		_wp1 setWaypointType "MOVE";
		_wp1 setWaypointSpeed "FULL";
		
		private _wp2 = _grp addWaypoint [_wp2Pos, 0];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointSpeed "NORMAL";
		
		private _destWP = _grp addWaypoint [_dest, 0];
		_destWP setWaypointType "TR UNLOAD";
		_destWP setWaypointSpeed "NORMAL";

		["Pilot", format ["En route to drop-off LZ %1", mapGridPosition _dest]] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		
		private _destDistance = _heli distance2D _dest;
		private _heliSpeed = 60;
		private _etaSeconds = (_destDistance / _heliSpeed) + 45;
		private _etaMinutes = _etaSeconds / 60;
		
		if (_etaMinutes >= 1) then { ["Pilot", format ["ETA %1 minutes", ceil _etaMinutes]] remoteExec ["BIS_fnc_showSubtitle", 0, true]; } else { ["Pilot", format ["ETA %1 seconds", ceil _etaSeconds]] remoteExec ["BIS_fnc_showSubtitle", 0, true]; };
		
		waitUntil { sleep 1; (_heli distance2D _dest) < 100 || !alive _heli || damage _heli > 0.9 || !alive (driver _heli) || !transportActive };
		terminate _flightMonitor;
		if (!alive _heli || damage _heli > 0.9 || !alive (driver _heli) || !transportActive) exitWith { [_heli, _grp, _allMarkers] call _fnc_cleanup; };
		
		["Pilot", "Approaching drop-off LZ"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		_heli land "LAND";
		waitUntil { sleep 0.5; (getPos _heli select 2) < 3 || !alive _heli || damage _heli > 0.9 };		
		if (!alive _heli || damage _heli > 0.9) exitWith { [_heli, _grp, _allMarkers] call _fnc_cleanup; };
		
		["Pilot", "Landing complete - disembarking passengers"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		
		private _fnc_ejectPassengers = {
			params ["_heli", "_originalCrew"];
			private _ejected = [];
			{
				if (vehicle _x == _heli && !(_x in _originalCrew)) then {
					_x action ["GetOut", _heli];
					if (!isPlayer _x) then { _x leaveVehicle _heli; _x action ["Eject", _heli]; _x moveOut _heli; };
					_ejected pushBack _x;
				};
			} forEach allUnits;
			_ejected
		};
		
		while {true} do {
			private _ejectedUnits = [_heli, _originalCrew] call _fnc_ejectPassengers;
			if (count _ejectedUnits == 0) exitWith {};
			["Pilot", "Disembarking passengers..."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
			sleep 2;
		};
		
		["Pilot", "All passengers safely disembarked"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		
		sleep 5;
		
		if (!alive _heli || damage _heli > 0.9 || !alive (driver _heli)) exitWith {
			[_heli, _grp, _allMarkers] call _fnc_cleanup;
		};
		
		_heli engineOn true;
		["Pilot", "Transport complete - RTB"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		
	} else {
		["Pilot", format ["%1 departing - no players boarded", _name]] remoteExec ["BIS_fnc_showSubtitle", 0, true];
	};
	
	if (alive _heli) then {
		private _exit = (getPos _heli) vectorAdd [(_transportConfig get "rtbDistance") * cos (random 360), (_transportConfig get "rtbDistance") * sin (random 360), 0];
		{deleteWaypoint [_grp, _forEachIndex]} forEach waypoints _grp;
		private _exitWP = _grp addWaypoint [_exit, 0];
		_exitWP setWaypointType "MOVE";
		_exitWP setWaypointSpeed "FULL";
		
		private _cleanupTimeout = time + (_transportConfig get "rtbTime");
		waitUntil {
			sleep 2;
			(_heli distance2D (getPos _heli)) > (_transportConfig get "rtbDistance") ||	!alive _heli ||	 time > _cleanupTimeout ||
			damage _heli > 0.9
		};
	};
	
	[_heli, _grp, _allMarkers] call _fnc_cleanup;
	["Pilot", "Transport mission complete"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
};