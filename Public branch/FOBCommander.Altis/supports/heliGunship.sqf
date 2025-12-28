// Check if player has enough Field Credits
private _currentCredits = player getVariable ["FieldCredits", 0];
if (_currentCredits < 5) exitWith {
    player sideChat "Insufficient Field Credits. Need 5 FC.";
};

// Check cooldown (20 minutes = 1200 seconds)
private _lastCASTime = missionNamespace getVariable ["lastCASTime", -9999];
private _now = time;
if (_now - _lastCASTime < 1200) exitWith {
    private _remaining = 1200 - (_now - _lastCASTime);
    player sideChat format ["CAS cooldown: %1 seconds remaining.", ceil _remaining];
};

// Deduct credits and set cooldown
[-5] execVM "addCredits.sqf";
missionNamespace setVariable ["lastCASTime", _now, true];

"Select attack zone on the map.";
openMap [true, false];

private _ehID = addMissionEventHandler ["MapSingleClick", {
	params ["_map", "_pos", "_alt"];
	
	openMap [false, false];
	removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
	
	private _targetPosition = [_pos select 0, _pos select 1, 0];
	private _helicopterType = "B_Heli_Attack_01_dynamicLoadout_F";
	private _flyHeight = 250; // Lower for better accuracy
	private _engagementRadius = 1200; // Larger detection radius
	private _spawnDistance = 3000;
	
	private _angle = random 360;
	private _spawnOffset = [
		_spawnDistance * cos (_angle),
		_spawnDistance * sin (_angle),
		_flyHeight
	];
	
	private _spawnPos = _targetPosition vectorAdd _spawnOffset;

	["High Command", "CAS Helo incoming! ETA 60 seconds."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
	playsound "supportConfirmed";
	hint "";
	
	private _helicopter = createVehicle [_helicopterType, _spawnPos, [], 0, "FLY"];
	
	
	private _pilotGroup = createGroup west;
	private _pilot = _pilotGroup createUnit ["B_Pilot_F", _spawnPos, [], 0, "CAN_COLLIDE"];
	
	_pilot setSkill ["aimingAccuracy", 0.95];
	_pilot setSkill ["aimingShake", 0.95];
	_pilot setSkill ["aimingSpeed", 0.9];
	_pilot setSkill ["spotDistance", 0.9];
	_pilot setSkill ["spotTime", 0.9];
	_pilot setSkill ["courage", 1.0];
	_pilot setSkill ["commanding", 0.95];
	_pilot moveInDriver _helicopter;
	
	_helicopter flyInHeight _flyHeight;
	_helicopter setBehaviour "COMBAT";
	_helicopter setCombatMode "RED";
	_helicopter setSpeedMode "FULL";

	// TERMINATOR GUNNER - Max stats
	private _gunner = _pilotGroup createUnit ["B_Soldier_SL_F", _spawnPos, [], 0, "CAN_COLLIDE"];
	_gunner setSkill ["aimingAccuracy", 0.8];  // Perfect accuracy
	_gunner setSkill ["aimingShake", 0.3];	  // No shake
	_gunner setSkill ["aimingSpeed", 1.0];	  // Instant aim
	_gunner setSkill ["spotDistance", 1.0];	 // Eagle eyes
	_gunner setSkill ["spotTime", 1.0];		 // Instant spot
	_gunner setSkill ["courage", 1.0];		  // Fearless
	_gunner setSkill ["reloadSpeed", 1.0];	  // Fast reload
	_gunner moveInGunner _helicopter;
	
	// Make gunner night vision capable
	_gunner setUnitTrait ["nightVision", true];

	private _strafePositions = [];
	for "_i" from 0 to 7 do { // More strafe positions
		private _strafeAngle = _i * 45;
		private _strafeOffset = [
			750 * cos (_strafeAngle), // Waypoints 3x farther
			750 * sin (_strafeAngle),
			0
		];
		_strafePositions pushBack (_targetPosition vectorAdd _strafeOffset);
	};
	
	{
		private _wp = _pilotGroup addWaypoint [_x, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed "NORMAL";
		_wp setWaypointBehaviour "COMBAT";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointCompletionRadius 80; // Tighter radius for precision
		if (_forEachIndex == (count _strafePositions - 1)) then {
			_wp setWaypointStatements ["true", "group this setCurrentWaypoint [group this, 1];"];
		};
	} forEach _strafePositions;

	private _cleanupTime = time + 240; // More time to wreck havoc
	
	[_helicopter, _cleanupTime, _pilotGroup, _targetPosition, _engagementRadius] spawn {
		params ["_heli", "_timeToCleanup", "_group", "_targetPos", "_radius"];
		
		private _exitTriggered = false;
		private _exitReason = "";
		private _lastTargetScanTime = 0;
		
		waitUntil {
			sleep 1; // Faster scan rate
			
			if (!alive _heli) exitWith {
				_exitReason = "destroyed";
				true
			};
			
			if (time > _timeToCleanup) exitWith {
				_exitReason = "timeout";
				_exitTriggered = true;
				true
			};
			
			if (alive _heli) then {
				// TERMINATOR TARGET ACQUISITION - More aggressive
				private _nearEnemies = _targetPos nearEntities [["Man", "Car", "Tank", "StaticWeapon", "Air"], _radius] select {
					side _x getFriend west < 0.6 && alive _x
				};
				
				// Sort by priority: Infantry first, then vehicles, then aircraft
				_nearEnemies = [_nearEnemies, [], {
					private _priority = 0;
					if (_x isKindOf "Man") then { _priority = 100; };
					if (_x isKindOf "Car") then { _priority = 80; };
					if (_x isKindOf "Tank") then { _priority = 90; };
					if (_x isKindOf "StaticWeapon") then { _priority = 85; };
					if (_x isKindOf "Air") then { _priority = 95; };
					-_priority // Negative for descending sort
				}] call BIS_fnc_sortBy;
				
				// TERMINATOR ENGAGEMENT - Reveal and target aggressively
				{
					_group reveal [_x, 4];
					_heli doTarget _x;
					
					// Force immediate engagement
					if (gunner _heli == (crew _heli select 1)) then {
						(gunner _heli) doTarget _x;
						(gunner _heli) doFire _x;
					};
					
					// Multiple targeting for overwhelming firepower
					if (_forEachIndex < 3) then { // Target top 3 threats simultaneously
						_heli doTarget _x;
					};
				} forEach _nearEnemies;
				
				// Auto-engage nearby targets even without orders
				if (count _nearEnemies > 0 && time > _lastTargetScanTime + 2) then {
					private _closestEnemy = _nearEnemies select 0;
					_heli doTarget _closestEnemy;
					if (gunner _heli == (crew _heli select 1)) then {
						(gunner _heli) doTarget _closestEnemy;
						(gunner _heli) doFire _closestEnemy;
					};
					_lastTargetScanTime = time;
				};
				
				// Check ammo
				private _weapons = weapons _heli;
				if (count _weapons > 0) then {
					private _primaryWeapon = _weapons select 0;
					private _ammo = _heli ammo _primaryWeapon;
					
					if (_ammo == 0) exitWith {
						_exitReason = "ammo_depleted";
						_exitTriggered = true;
						true
					};
				};
				
				// TERMINATOR PERSISTENCE - Keep hunting
				if (count _nearEnemies == 0) then {
					// Scan wider area for more targets
					private _wideAreaEnemies = _targetPos nearEntities [["Man", "Car", "Tank", "StaticWeapon"], _radius * 1.5] select {
						side _x getFriend west < 0.6 && alive _x
					};
					
					if (count _wideAreaEnemies > 0) then {
						private _newTarget = _wideAreaEnemies select 0;
						_group reveal [_newTarget, 4];
						_heli doTarget _newTarget;
					};
				};
			};
			
			false
		};
		
		if (_exitReason == "destroyed") then {
			if (!isNull _group) then {
				{
					if (!isNull _x && {alive _x}) then {
						deleteVehicle _x;
					};
				} forEach units _group;
				deleteGroup _group;
			};
			["High Command", "CAS Helo destroyed!"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
			playsound "supportDeployed";
		} else {
			if (!isNull _heli && {alive _heli}) then {
				private _exitAngle = random 360;
				private _exitOffset = [
					2000 * cos (_exitAngle),
					2000 * sin (_exitAngle),
					0
				];
				private _exitPosition = _targetPos vectorAdd _exitOffset;
				
				if (!isNull _group) then {
					private _waypoints = waypoints _group;
					for "_i" from (count _waypoints - 1) to 0 step -1 do {
						deleteWaypoint [_group, _i];
					};
					
					private _exitWP = _group addWaypoint [_exitPosition, 0];
					_exitWP setWaypointType "MOVE";
					_exitWP setWaypointSpeed "FULL";
					_exitWP setWaypointBehaviour "CARELESS";
					_exitWP setWaypointCombatMode "BLUE";
				};
				
				if (_exitReason == "ammo_depleted") then {
					["High Command", "CAS Helo returning to base."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
				} else {
					["High Command", "CAS Helo mission complete, returning to base."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
				};
				playsound "supportLanded";
				
				waitUntil {
					sleep 2;
					(isNull _heli || !alive _heli) || 
					(_heli distance2D _targetPos > 1900)
				};
				
				if (!isNull _heli) then {
					private _crewMembers = crew _heli;
					{
						if (!isNull _x && {alive _x}) then {
							deleteVehicle _x;
						};
					} forEach _crewMembers;
					
					if (alive _heli) then {
						deleteVehicle _heli;
					};
				};
				
				if (!isNull _group) then {
					deleteGroup _group;
				};
			};
		};
	};
}];