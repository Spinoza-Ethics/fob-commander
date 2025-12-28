//==========General Settings ==========//

private _markerNameText = "Crash Site";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 2; //Default 2
private _staticGroupSizeMax = 5; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 2; //Default 1
private _patrolSizeMax = 5; //Default 6
private _patrolGroupCountMin = 1; //Default 0
private _patrolGroupCountMax = 1; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.3; //Default 0.2
private _staticWeaponChance = 0; //Default 0.3

//==========Enemy Faction==========//

//Load Enemy Faction From File (enemyFaction.sqf)
private _config = call compile preprocessFileLineNumbers "factions\enemyFaction.sqf";

private _infantryTypes = _config get "infantryTypes";
private _armoredVehicleTypes = _config get "armoredVehicleTypes";
private _vehicleTypes = _config get "vehicleTypes";
private _staticATTypes = _config get "staticATTypes";
private _staticMGTypes = _config get "staticMGTypes";
private _mortarTypes = _config get "mortarTypes";
private _defaultDriverType = _config get "defaultDriverType";
private _defaultGunnerType = _config get "defaultGunnerType";
private _defaultCommanderType = _config get "defaultCommanderType";

//==========Main Script Logic==========//

// Zone Creation Settings (Changeable)
private _addMapMarker = true;
private _inlandSpawnWeight = 0.8;
private _minDistanceFromCoast = 800;
private _centerBiasStrength = 0.6;
private _centerBiasRadius = 5000;

// Zone Creation Settings (NOT Changeable)
_logic = param [0, objNull, [objNull]];
_activated = param [2, true, [true]];
private _On = true;
_safezone = synchronizedObjects _logic;

_spawnAttempts = 0;
_maxAttempts = 200;

private _worldSize = worldSize;
private _mapCenterX = _worldSize / 2;
private _mapCenterY = _worldSize / 2;
private _mapCenter = [_mapCenterX, _mapCenterY, 0];

if (_On) then {
	private _spawned = false;

	//==========Composition Objects==========//
	
	//add as many variants as neeeded( use code: [getPos Player, 50] call BIS_fnc_objectsGrabber )
	private _emplacementVariants = [
	// First emplacement
	[
		["Land_Wreck_Heli_02_Wreck_03_F",[-1.14,0.82,0],270],
		["Land_ShellCrater_02_decal_F",[-2.07,2.97,0],270],
		["CraterLong_02_F",[1.96,3.29,-0.04],150],
		["Land_Wreck_Heli_02_Wreck_01_F",[0.55,3.68,-0.52],330],
		["Land_ShellCrater_02_decal_F",[4.42,2.72,0],180],
		["Land_ShellCrater_01_F",[1.13,5.93,0],0],
		["Land_Wreck_Heli_02_Wreck_04_F",[5.9,3.09,0],60],
		["Land_ShellCrater_02_decal_F",[-1.81,9.71,0],0],
		["Land_ShellCrater_02_decal_F",[4.68,9.46,0],90],
		["CraterLong_02_small_F",[-0.24,13.84,0],0],
		["Land_Wreck_Heli_02_Wreck_02_F",[-0.76,12.82,-0.54],0]
	],
	// Second emplacement
	[
		["Land_ShellCrater_02_debris_F",[0.36,-0.63,0],140.69],
		["Land_ShellCrater_02_debris_F",[-2.35,0.99,0],224.85],
		["Land_ShellCrater_02_debris_F",[1.68,-2.45,0],51.84],
		["CraterLong_02_F",[2.87,2.94,0],133.54],
		["Land_ShellCrater_02_debris_F",[-4.92,4.00,0],51.84],
		["CraterLong_02_F",[7.26,-2.11,0],133.54],
		["Land_ShellCrater_02_debris_F",[4.24,-5.46,0],224.85],
		["Land_Wreck_Plane_Transport_01_F",[-1.26,6.25,0],313.17],
		["Land_ShellCrater_02_debris_F",[6.92,6.05,0],140.69],
		["Land_ShellCrater_02_debris_F",[7.8,3.82,0],51.84],
		["Land_ShellCrater_02_debris_F",[-6.58,5.35,0],140.69],
		["Land_ShellCrater_02_debris_F",[4.21,7.67,0],224.85],
		["CraterLong_02_F",[-2.49,7.25,0],133.54],
		["Land_ShellCrater_02_debris_F",[6.96,-7.08,0],140.69],
		["Land_ShellCrater_02_debris_F",[10.37,0.8,0],224.85],
		["Land_ShellCrater_02_debris_F",[1.64,10.68,0],51.84],
		["Land_ShellCrater_02_debris_F",[8.01,-6.13,0],314.13],
		["Land_ShellCrater_02_debris_F",[0.35,12,0],140.69],
		["Land_ShellCrater_02_debris_F",[-9.29,6.96,0],224.85],
		["Land_ShellCrater_02_debris_F",[11.52,-2.72,0],42.97],
		["Land_ShellCrater_02_debris_F",[11.4,-5.34,0],127.14],
		["Land_ShellCrater_02_debris_F",[13.08,-0.81,0],140.69],
		["Land_ShellCrater_02_debris_F",[-2.36,13.61,0],224.85],
		["Land_ShellCrater_02_debris_F",[-11.86,9.98,0],51.84],
		["CraterLong_02_F",[-7.29,11.82,0],133.54],
		["Land_ShellCrater_02_debris_F",[-4.93,16.63,0],51.84],
		["Land_ShellCrater_02_debris_F",[-12.86,12.16,0],140.69],
		["Land_ShellCrater_02_debris_F",[-6.46,18.11,0],169.05],
		["Land_ShellCrater_02_debris_F",[-10.32,17.21,0],342.06],
		["Land_ShellCrater_02_debris_F",[-12.99,15.53,0],257.89],
		["Snake_random_F",[8.33,38.02,0],82.66]
	],
	// Third emplacement
	[
		["Land_ShellCrater_02_debris_F",[-0.19,-0.52,0],263.6],
		["Land_ShellCrater_02_debris_F",[-0.07,-3.75,0],276.67],
		["Land_Wreck_Heli_Attack_01_F",[3.91,1.97,0.31],315.91],
		["Land_ShellCrater_02_debris_F",[-1.96,2.57,0],199.9],
		["Land_ShellCrater_02_debris_F",[2.3,-5.01,0],173.38],
		["Land_ShellCrater_02_debris_F",[-5.84,4.13,0],293.91],
		["Land_ShellCrater_02_debris_F",[3.23,7.56,0],58.43],
		["Land_ShellCrater_02_debris_F",[4.28,-7.16,0],234.46],
		["Land_ShellCrater_02_debris_F",[5.98,5.7,0],72.16],
		["Land_ShellCrater_02_debris_F",[6.49,-4.14,0],89.88],
		["Land_ShellCrater_02_debris_F",[8.4,3.37,0],66.82],
		["Land_ShellCrater_02_debris_F",[1.57,9.43,0],52.88],
		["Land_ShellCrater_02_debris_F",[7.02,-7.8,0],220.32],
		["Land_ShellCrater_02_debris_F",[9.57,-4.48,0],138.97],
		["Land_ShellCrater_02_debris_F",[-7.1,6.9,0],261.71],
		["Land_ShellCrater_02_debris_F",[9.09,-5.91,0],148.97],
		["Land_ShellCrater_02_debris_F",[-1.17,11.26,0],50.75],
		["Land_ShellCrater_02_debris_F",[11.2,1.23,0],86.46],
		["Land_ShellCrater_02_debris_F",[-3.13,10.62,0],194.9],
		["Land_ShellCrater_02_debris_F",[-6.56,10.03,0],348.45],
		["Land_ShellCrater_02_debris_F",[12.26,-4.47,0],177.96],
		["Land_ShellCrater_02_debris_F",[12.61,-1.03,0],89.88]
	],
	// Fourth emplacement
	[
		["Land_ShellCrater_02_debris_F",[1.53,-0.7,0],230.31],
		["Land_ShellCrater_02_debris_F",[-1,2.4,0],195.77],
		["Land_ShellCrater_02_debris_F",[3.43,-2.48,0],214.9],
		["Land_Wreck_Heli_02_Wreck_03_F",[-1.72,3.54,0],347.9],
		["CraterLong",[3.24,3.76,0],315.91],
		["Land_ShellCrater_02_debris_F",[-2.62,4.74,0],272.16],
		["Land_ShellCrater_02_debris_F",[6.73,-2.71,0],207.09],
		["Land_Wreck_Heli_02_Wreck_01_F",[5.59,2.97,-0.72],315.77],
		["CraterLong_small",[0.32,6.94,0],134.73],
		["Land_Wreck_Heli_02_Wreck_04_F",[7.51,3.03,0],342.11],
		["Land_Wreck_Heli_02_Wreck_03_F",[0.71,8.63,0.45],262.16],
		["Land_ShellCrater_02_debris_F",[-4.58,7.84,0],315.91],
		["Land_ShellCrater_02_debris_F",[7.37,5.29,0],214.47],
		["Land_ShellCrater_02_debris_F",[8.9,0.84,0],42.04],
		["Land_ShellCrater_02_debris_F",[8.85,3.84,0],89.88],
		["Land_Wreck_Heli_02_Wreck_02_F",[-2.65,9.26,0],283.62],
		["Land_ShellCrater_02_debris_F",[3.08,9.07,0],165.66],
		["Land_ShellCrater_02_debris_F",[0.67,11.23,0],13.68],
		["Land_ShellCrater_02_debris_F",[-0.39,11.61,0],179.82],
		["Land_ShellCrater_02_debris_F",[-2.57,11.83,0],134.49],
		["Snake_random_F",[-6.7,22.46,0],250.07],
		["Snake_random_F",[-23.88,-9.9,0],56.81],
		["Rabbit_F",[-41.95,2.96,0],314.38]
	],
	// Fifth emplacement
	[
		["Land_ShellCrater_02_debris_F",[1.53,0.79,0],195.77],
		["Land_ShellCrater_02_debris_F",[-0.09,3.13,0],272.16],
		["Land_ShellCrater_02_debris_F",[4.06,-2.31,0],230.31],
		["Land_Wreck_Heli_Attack_02_F",[5.08,0.89,-0.74],319.04],
		["CraterLong_small",[2.85,5.33,0],134.73],
		["Land_ShellCrater_02_debris_F",[5.96,-4.08,0],214.9],
		["Land_ShellCrater_02_debris_F",[-2.05,6.24,0],315.91],
		["CraterLong",[5.77,2.15,0],315.91],
		["Land_ShellCrater_02_debris_F",[5.61,7.47,0],165.66],
		["Land_ShellCrater_02_debris_F",[9.26,-4.31,0],207.09],
		["Land_ShellCrater_02_debris_F",[-0.04,10.23,0],134.49],
		["Land_ShellCrater_02_debris_F",[3.2,9.63,0],13.68],
		["Land_ShellCrater_02_debris_F",[2.14,10,0],179.82],
		["Land_ShellCrater_02_debris_F",[9.9,3.68,0],214.47],
		["Land_ShellCrater_02_debris_F",[11.38,2.24,0],89.88],
		["Land_ShellCrater_02_debris_F",[11.43,-0.76,0],42.04]
	],
	// Sixth emplacement
	[
		["Land_ShellCrater_02_debris_F",[-0.06,1.51,0],195.77],
		["Land_ShellCrater_02_debris_F",[2.47,-1.59,0],230.31],
		["Land_ShellCrater_02_debris_F",[-1.68,3.85,0],272.16],
		["Land_ShellCrater_02_debris_F",[4.37,-3.37,0],214.9],
		["CraterLong",[4.18,2.87,0],315.91],
		["Land_Mi8_wreck_F",[3.26,5.72,-0.03],315.91],
		["CraterLong_small",[1.27,6.05,0],134.73],
		["Land_ShellCrater_02_debris_F",[-3.64,6.96,0],315.91],
		["Land_ShellCrater_02_debris_F",[7.68,-3.6,0],207.09],
		["Land_ShellCrater_02_debris_F",[4.02,8.19,0],165.66],
		["Land_ShellCrater_02_debris_F",[8.31,4.4,0],214.47],
		["Land_ShellCrater_02_debris_F",[9.79,2.96,0],89.88],
		["Land_ShellCrater_02_debris_F",[9.85,-0.04,0],42.04],
		["Land_ShellCrater_02_debris_F",[1.61,10.35,0],13.68],
		["Land_ShellCrater_02_debris_F",[-1.62,10.95,0],134.49],
		["Land_ShellCrater_02_debris_F",[0.55,10.72,0],179.82],
		["Snake_random_F",[-21.57,-35.51,0],333.02]
	],
	
	//spacecraft
	[
		["Land_ShellCrater_02_decal_F",[0.84082,4.38281,3.8147e-06],180], 
		["Land_Wreck_Heli_02_Wreck_04_F",[2.32617,4.75586,7.43866e-05],60], 
		["Land_Wreck_Heli_02_Wreck_03_F",[-4.71484,2.48633,-0.000278473],270], 
		["Land_ShellCrater_02_decal_F",[-5.64844,4.63281,3.8147e-06],270], 
		["Land_ShellCrater_01_F",[-2.44727,7.59766,-4.57764e-05],0], 
		["CraterLong_02_small_F",[2.4834,6.35156,-0.05126],205.002], 
		["SpaceshipCapsule_01_container_F",[-5.61719,7.71875,7.62939e-06],278.344], 
		["Land_ShellCrater_02_decal_F",[-8.71777,4.4707,1.90735e-06],0], 
		["SpaceshipCapsule_01_F",[-0.21582,10.0313,0.00628853],359.934], 
		["Land_ShellCrater_02_decal_F",[1.10938,11.125,1.90735e-06],90], 
		["Land_ShellCrater_02_debris_F",[-8.87402,8.31445,-0.000513077],0], 
		["Land_ShellCrater_02_decal_F",[-5.38086,11.375,1.90735e-06],0], 
		["SpaceshipCapsule_01_debris_F",[4.33008,12.9707,0.00171089],0], 
		["CraterLong_02_small_F",[-3.80957,15.5039,-0.00172043],0]
	]
	
];

	//==========END Composition Objects==========//

//==========ZONE CREATION LOGIC==========//

while { !_spawned && _spawnAttempts < _maxAttempts } do {
	_spawnAttempts = _spawnAttempts + 1;

	private _basePosCandidate = [];
	private _candidateFound = false;
	private _candidateAttempts = 0;
	private _maxCandidateAttempts = 100;

	while {!_candidateFound && _candidateAttempts < _maxCandidateAttempts} do {
		_candidateAttempts = _candidateAttempts + 1;

		private _randomX = random _worldSize;
		private _randomY = random _worldSize;
		private _currentCandidatePos = [_randomX, _randomY, 0];

		// Enhanced terrain validation with error handling
		try {
			if (surfaceIsWater _currentCandidatePos) then { continue; };
			
			// Check if position is on valid terrain
			private _surfaceType = surfaceType _currentCandidatePos;
			if (isNil "_surfaceType" || _surfaceType == "" || _surfaceType in ["#water", "#sea"]) then { continue; };
		} catch {
			// If terrain check fails, skip this position
			continue;
		};

		private _distanceFromCenter = _currentCandidatePos distance _mapCenter;
		private _centerAcceptanceFactor = 1;

		if (_centerBiasStrength > 0) then {
			if (_distanceFromCenter <= _centerBiasRadius) then {
				_centerAcceptanceFactor = 1 - (_centerBiasStrength * (_distanceFromCenter / _centerBiasRadius));
			} else {
				_centerAcceptanceFactor = 1 - _centerBiasStrength;
				_centerAcceptanceFactor = _centerAcceptanceFactor - (_centerBiasStrength * ((_distanceFromCenter - _centerBiasRadius) / (_worldSize / 2 - _centerBiasRadius)));
				_centerAcceptanceFactor = _centerAcceptanceFactor max 0.05;
			};
		};

		// Improved coast detection with error handling
		private _isNearCoast = false;
		try {
			if (!surfaceIsWater _currentCandidatePos) then {
				private _coastCheckPoints = [
					[_minDistanceFromCoast * 0.5, 0], [_minDistanceFromCoast * 0.5, 90], 
					[_minDistanceFromCoast * 0.5, 180], [_minDistanceFromCoast * 0.5, 270],
					[_minDistanceFromCoast * 0.8, 45], [_minDistanceFromCoast * 0.8, 135],
					[_minDistanceFromCoast * 0.8, 225], [_minDistanceFromCoast * 0.8, 315]
				];
				
				{
					private _checkPos = _currentCandidatePos getPos _x;
					if (!isNil "_checkPos" && surfaceIsWater _checkPos) exitWith { _isNearCoast = true; };
				} forEach _coastCheckPoints;
			} else {
				_isNearCoast = true;
			};
		} catch {
			// If coast check fails, assume near coast to be safe
			_isNearCoast = true;
		};

		private _inlandAcceptanceFactor = 1;
		if (_isNearCoast && _inlandSpawnWeight > 0) then {
			_inlandAcceptanceFactor = 1 - _inlandSpawnWeight;
		};

		if (random 1 < _centerAcceptanceFactor && random 1 < _inlandAcceptanceFactor) then {
			_basePosCandidate = _currentCandidatePos;
			_candidateFound = true;
		};
	};

	if (!_candidateFound) then { continue; };

	// Multi-stage safe position finding with progressive relaxation and comprehensive error handling
	private _safePos = [];
	private _searchRadius = 200 + (_spawnAttempts * 15);
	
	try {
		// Validate _basePosCandidate before using it
		if (isNil "_basePosCandidate" || count _basePosCandidate < 2) then { continue; };
		if (surfaceIsWater _basePosCandidate) then { continue; };
		
		// Stage 1: Strict requirements with individual error handling
		try {
			_safePos = [_basePosCandidate, 0, _searchRadius, 15, 0, 0.1, 0, [], _basePosCandidate] call BIS_fnc_findSafePos;
		} catch {
			_safePos = [];
		};
		
		// Stage 2: Relaxed slope requirement
		if (isNil "_safePos" || _safePos isEqualTo [] || _safePos isEqualTo _basePosCandidate) then {
			try {
				_safePos = [_basePosCandidate, 0, _searchRadius * 1.5, 12, 0, 0.3, 0, [], _basePosCandidate] call BIS_fnc_findSafePos;
			} catch {
				_safePos = [];
			};
		};
		
		// Stage 3: Further relaxed requirements
		if (isNil "_safePos" || _safePos isEqualTo [] || _safePos isEqualTo _basePosCandidate) then {
			try {
				_safePos = [_basePosCandidate, 0, _searchRadius * 2, 8, 0, 0.6, 0, [], _basePosCandidate] call BIS_fnc_findSafePos;
			} catch {
				_safePos = [];
			};
		};
		
		// Stage 4: Last resort - minimal requirements
		if (isNil "_safePos" || _safePos isEqualTo [] || _safePos isEqualTo _basePosCandidate) then {
			try {
				_safePos = [_basePosCandidate, 0, _searchRadius * 3, 5, 0, 0.8, 0, [], _basePosCandidate] call BIS_fnc_findSafePos;
			} catch {
				_safePos = [];
			};
		};
	} catch {
		_safePos = [];
	};
	
	// Final validation - ensure we have a valid position
	if (isNil "_safePos" || _safePos isEqualTo [] || _safePos isEqualTo _basePosCandidate) then { 
		// Use original candidate if all else fails, but validate it's not water
		try {
			if (count _basePosCandidate >= 2 && !surfaceIsWater _basePosCandidate) then {
				_safePos = _basePosCandidate;
			} else {
				continue;
			};
		} catch {
			continue;
		};
	};

	// Enhanced location validation with better error handling
	private _skipSpawnAttempt = false;

	// Village check with improved error handling
	try {
		private _nearestVillages = nearestLocations [_safePos, ["NameVillage"], 1500];
		if (!isNil "_nearestVillages" && count _nearestVillages > 0) then {
			private _nearestVillage = _nearestVillages select 0;
			if (!isNil "_nearestVillage") then {
				private _villageSize = size _nearestVillage;
				if (!isNil "_villageSize" && count _villageSize >= 2) then {
					private _villageEdge = ((_villageSize select 0) + (_villageSize select 1)) / 2;
					private _minDistance = (_villageEdge * 1.2) + 120;
					private _villagePos = locationPosition _nearestVillage;
					if (!isNil "_villagePos" && (_safePos distance _villagePos) < _minDistance) then { 
						_skipSpawnAttempt = true; 
					};
				};
			};
		};
	} catch {
		// If village check fails, skip this attempt to be safe
		_skipSpawnAttempt = true;
	};
	if (_skipSpawnAttempt) then { continue; };

	// City check with improved error handling
	try {
		private _nearestCities = nearestLocations [_safePos, ["NameCity"], 2000];
		if (!isNil "_nearestCities" && count _nearestCities > 0) then {
			private _nearestCity = _nearestCities select 0;
			if (!isNil "_nearestCity") then {
				private _citySize = size _nearestCity;
				if (!isNil "_citySize" && count _citySize >= 2) then {
					private _cityEdge = ((_citySize select 0) + (_citySize select 1)) / 2;
					private _minDistance = (_cityEdge * 1.3) + 180;
					private _cityPos = locationPosition _nearestCity;
					if (!isNil "_cityPos" && (_safePos distance _cityPos) < _minDistance) then { 
						_skipSpawnAttempt = true; 
					};
				};
			};
		};
	} catch {
		// If city check fails, skip this attempt to be safe
		_skipSpawnAttempt = true;
	};
	if (_skipSpawnAttempt) then { continue; };

	// Capital check with improved error handling
	try {
		private _nearestCapitals = nearestLocations [_safePos, ["NameCityCapital"], 2500];
		if (!isNil "_nearestCapitals" && count _nearestCapitals > 0) then {
			private _nearestCapital = _nearestCapitals select 0;
			if (!isNil "_nearestCapital") then {
				private _capitalSize = size _nearestCapital;
				if (!isNil "_capitalSize" && count _capitalSize >= 2) then {
					private _capitalEdge = ((_capitalSize select 0) + (_capitalSize select 1)) / 2;
					private _minDistance = (_capitalEdge * 1.4) + 250;
					private _capitalPos = locationPosition _nearestCapital;
					if (!isNil "_capitalPos" && (_safePos distance _capitalPos) < _minDistance) then { 
						_skipSpawnAttempt = true; 
					};
				};
			};
		};
	} catch {
		// If capital check fails, skip this attempt to be safe
		_skipSpawnAttempt = true;
	};
	if (_skipSpawnAttempt) then { continue; };

	// Enhanced safezone check with error handling
	try {
		private _inBase = false;
		if (!isNil "_safezone" && count _safezone > 0) then {
			{
				if (!isNil "_x" && _safePos inArea _x) exitWith { _inBase = true };
			} forEach _safezone;
		};
		if (_inBase) then { continue; };
	} catch {
		// If safezone check fails, skip this attempt to be safe
		continue;
	};

	// Additional validation: Check for existing military installations with error handling
	try {
		private _nearbyObjects = nearestObjects [_safePos, ["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F"], 800];
		if (!isNil "_nearbyObjects" && count _nearbyObjects > 0) then { continue; };
	} catch {
		// If nearbyObjects check fails, continue anyway as this is just an additional check
	};

	// Final terrain validation before camp creation with comprehensive error handling
	try {
		// Validate _safePos before using it
		if (isNil "_safePos" || count _safePos < 2) then { continue; };
		if (surfaceIsWater _safePos) then { continue; };
		
		private _finalTerrainCheck = [];
		try {
			_finalTerrainCheck = _safePos isFlatEmpty [20, -1, 0.5, 15, 0, false];
		} catch {
			_finalTerrainCheck = [];
		};
		
		if (isNil "_finalTerrainCheck" || count _finalTerrainCheck == 0) then {
			// Try to find a suitable nearby position with more error handling
			private _alternativeFound = false;
			for "_i" from 1 to 8 do {
				try {
					private _testPos = _safePos getPos [20 + (random 30), _i * 45];
					if (!isNil "_testPos" && count _testPos >= 2 && !surfaceIsWater _testPos) then {
						private _testFlat = [];
						try {
							_testFlat = _testPos isFlatEmpty [15, -1, 0.4, 10, 0, false];
						} catch {
							_testFlat = [];
						};
						if (!isNil "_testFlat" && count _testFlat > 0) then {
							_safePos = _testPos;
							_alternativeFound = true;
							break;
						};
					};
				} catch {
					// Continue to next iteration if this test position fails
				};
			};
			
			// If no alternative found, try even more relaxed parameters
			if (!_alternativeFound) then {
				try {
					private _veryRelaxedCheck = _safePos isFlatEmpty [10, -1, 0.8, 5, 0, false];
					if (isNil "_veryRelaxedCheck" || count _veryRelaxedCheck == 0) then {
						continue;
					};
				} catch {
					continue;
				};
			};
		};
	} catch {
		// If all terrain validation fails, skip this position entirely
		continue;
	};

	// If we reach here, we have a valid position - continue with camp creation
	private _campArray = selectRandom _emplacementVariants;

	// Remove duplicate city/village/capital checks that were causing conflicts
	// The original duplicate checks have been removed to prevent errors

	// Continue with camp creation logic...
	private _maxY = 0;
	{
		private _y = _x#1#1;
		if (_y > _maxY) then { _maxY = _y };
	} forEach _campArray;

	private _margin = 8 + random 8;
	private _campPos = _safePos;
	private _campDir = random 360;

	// Hide nearby objects with error handling
	try {
		private _nearbyTerrain = nearestTerrainObjects [_campPos, ["HIDE","BUILDING","FENCE","WALL","TREE","SMALL TREE","BUSH","SIGN"], 15];
		if (!isNil "_nearbyTerrain") then {
			{
				if (!isNil "_x") then {
					_x hideObjectGlobal true;
				};
			} forEach _nearbyTerrain;
		};
	} catch {
		// If hiding objects fails, continue anyway
	};

	private _spawnedObjects = [_campPos, _campDir, _campArray] call BIS_fnc_objectsMapper;

	private _marker = "";
	if (_addMapMarker) then {
		private _uniqueMarkerName = format ["%1_%2", _markerNameText, round (random 100000)];
		_marker = createMarker [_uniqueMarkerName, _campPos];
		_marker setMarkerType _markerType;
		_marker setMarkerColor "ColorRed";
		_marker setMarkerText _markerNameText;
	};

	//==========End Zone Logic=========//

		//==========Flag Spawning==========//
		
	private _offsetLocal = [0, (_maxY + _margin) max 0, 0];
	private _angleRad = _campDir * (pi / 180);
	if (isNil "_angleRad" || {!(_angleRad isEqualType 0)}) then { _angleRad = 0 };

	private _offsetRotated = [
		_offsetLocal#0 * cos _angleRad - _offsetLocal#1 * sin _angleRad,
		_offsetLocal#0 * sin _angleRad + _offsetLocal#1 * cos _angleRad,
		0
	];
	private _flagPos = _campPos vectorAdd _offsetRotated;
	private _flag = createVehicle ["Flag_Red_F", _flagPos, [], 0, "NONE"];
	_flag setDir _campDir;

	_flag addAction [
		"<t color='#00FF00' size='1.2'>Lower Enemy Flag</t>",
		{
			params ["_flagObject", "_caller", "_actionId", "_args"];
			private _markerId = _args#0;
			private _flagPos = getPos _flagObject;
			private _clearRadius = 500;
			
			_caller sideChat "Territory Cleared by Friendly Forces";
			
			// Clear area of hostile objects
			private _objectsInArea = nearestObjects [_flagPos, [], _clearRadius];
			{
				if (!(_x isKindOf "Man") && !(_x isKindOf "LandVehicle") && !(_x isKindOf "Air") && !(_x isKindOf "Ship") && (_x != _flagObject)) then {
					deleteVehicle _x;
				};
			} forEach _objectsInArea;
			
			// Delete map marker
			if (_markerId != "") then {
				deleteMarker _markerId;
			};
			
			// Delete the flag
			deleteVehicle _flagObject;
			
		},
		[_marker],101
	];

		//==========Static Infantry Group Spawning==========//

		private _groupDistanceFromCampMin = 10;
		private _groupDistanceFromCampMax = 80;

		private _numGroupsToSpawn = _staticGroupCountMin + floor random ((_staticGroupCountMax - _staticGroupCountMin) + 1);

		for "_groupIdx" from 1 to _numGroupsToSpawn do {
			private _groupBasePositionFound = false;
			private _groupBasePos = _campPos;

			for "_attempt" from 1 to 20 do {
				private _groupDist = _groupDistanceFromCampMin + random (_groupDistanceFromCampMax - _groupDistanceFromCampMin);
				private _tryGroupPos = _campPos getPos [_groupDist, random 360];

				if (count (_tryGroupPos isFlatEmpty [5, -1, 0.3, 10, 0, false]) > 0) then {
					_groupBasePos = _tryGroupPos;
					_groupBasePositionFound = true;
					break;
				};
			};

			if (_groupBasePositionFound) then {
				private _enemyGroup = createGroup [opfor, true];

				private _numUnits = _staticGroupSizeMin + floor random ((_staticGroupSizeMax - _staticGroupSizeMin) + 1);

				for "_i" from 1 to _numUnits do {
					private _type = selectRandom _infantryTypes;
					private _unitPos = [];
					private _found = false;

					for "_j" from 1 to 20 do {
						private _tryPos = _groupBasePos getPos [(random 10), random 360];
						if (count (_tryPos isFlatEmpty [1, -1, 0.3, 3, 0, false]) > 0) then {
							_unitPos = _tryPos;
							_found = true;
							break;
						};
					};

					if (_found) then {
						private _unit = _enemyGroup createUnit [_type, _unitPos, [], 0, "NONE"];
						_unit setDir random 360;
						_unit setSkill ["aimingAccuracy", 0.4];
					};
				};
				_enemyGroup setFormation "DIAMOND";
			};
		};

		//==========Static Vehicle Spawning==========//

		private _numVehicles = 1 + floor random ((3 - 1) + 1);

		for "_v" from 1 to _numVehicles do {
			private _vehClass = selectRandom _vehicleTypes;
			private _vehPos = [];
			private _vehFound = false;
			private _vehDir = random 360;

			for "_t" from 1 to 20 do {
				private _dist = if (_vehClass isKindOf "Helicopter") then { 60 + random 40 } else { 10 + random 20 };
				private _currentTryPos = _campPos getPos [_dist, random 360];

				if (count (_currentTryPos isFlatEmpty [3, -1, 0.3, 5, 0, false]) > 0) then {
					_vehPos = _currentTryPos;
					_vehFound = true;
					break;
				};
			};

			if (_vehFound) then {
				if (_vehClass isKindOf "Helicopter") then {
					private _pad = createVehicle ["Land_HelipadSquare_F", _vehPos, [], 0, "NONE"];
					_pad setDir _vehDir;

					private _vehicle = createVehicle [_vehClass, _vehPos, [], 0, "NONE"];
					_vehicle setDir _vehDir;
					if (random 1 < 0.4) then { _vehicle setVehicleLock "LOCKED"; };
				} else {
					private _vehicle = createVehicle [_vehClass, _vehPos, [], 0, "NONE"];
					_vehicle setDir _vehDir;
					if (random 1 < 0.4) then { _vehicle setVehicleLock "LOCKED"; };
				};
			};
		};

		//==========Armored Vehicle Spawning==========//
		
		if (random 1 < _armoredSpawnChance) then {

			private _spawnedArmoredVehicle = false;

			if (!_spawnedArmoredVehicle) then {
				private _vehClass = selectRandom _armoredVehicleTypes;
				private _vehPos = [];
				private _vehFound = false;
				private _vehDir = random 360;

				for "_t" from 1 to 20 do {
					private _dist = 30 + random 40;
					private _currentTryPos = _campPos getPos [_dist, random 360];

					if (count (_currentTryPos isFlatEmpty [5, -1, 0.3, 10, 0, false]) > 0) then {
						_vehPos = _currentTryPos;
						_vehFound = true;
						break;
					};
				};

				if (_vehFound) then {
					private _vehicle = createVehicle [_vehClass, _vehPos, [], 0, "CAN_COLLIDE"];
					_vehicle setDir _vehDir;

					private _crewGroup = createGroup [opfor, true];

					private _vehCrewTypes = getArray (configFile >> "CfgVehicles" >> _vehClass >> "Crew");
					private _spawnedCrew = [];

					{
						private _crewman = _crewGroup createUnit [_x, _vehPos, [], 0, "NONE"];
						_spawnedCrew pushBack _crewman;
					} forEach _vehCrewTypes;

					private _crewIndex = 0;

					if (driver _vehicle isEqualTo objNull) then {
						private _driver = if (_crewIndex < count _spawnedCrew) then {
							_spawnedCrew select _crewIndex;
						} else {
							private _driverType = _defaultDriverType;
							_crewGroup createUnit [_driverType, _vehPos, [], 0, "NONE"];
						};
						_driver moveInDriver _vehicle;
						_crewIndex = _crewIndex + 1;
					};

					if (gunner _vehicle isEqualTo objNull) then {
						private _gunner = if (_crewIndex < count _spawnedCrew) then {
							_spawnedCrew select _crewIndex;
						} else {
							private _gunnerType = _defaultGunnerType;
							_crewGroup createUnit [_gunnerType, _vehPos, [], 0, "NONE"];
						};
						_gunner moveInGunner _vehicle;
						_crewIndex = _crewIndex + 1;
					};

					if (commander _vehicle isEqualTo objNull) then {
						private _commander = if (_crewIndex < count _spawnedCrew) then {
							_spawnedCrew select _crewIndex;
						} else {
							private _commanderType = _defaultCommanderType;
							_crewGroup createUnit [_commanderType, _vehPos, [], 0, "NONE"];
						};
						_commander moveInCommander _vehicle;
						_crewIndex = _crewIndex + 1;
					};

					for "_i" from _crewIndex to (count _spawnedCrew - 1) do {
						(_spawnedCrew select _i) moveInCargo _vehicle;
					};

					_spawnedArmoredVehicle = true;
				};
			};
		};

		//==========Static Weapon Spawning==========//
		private _staticWeaponsSpawnedCount = 0;
		private _maxStaticWeaponsHardcoded = 2;

		if (_staticWeaponsSpawnedCount < _maxStaticWeaponsHardcoded && random 1 < _staticWeaponChance) then {

			private _staticATClass = selectRandom _staticATTypes;
			private _staticATPos = [];
			private _staticATFound = false;
			private _staticATDir = random 360;

			for "_t" from 1 to 10 do {
				private _dist = 10 + random 15;
				private _currentTryPos = _campPos getPos [_dist, random 360];
				if (count (_currentTryPos isFlatEmpty [2, -1, 0.3, 5, 0, false]) > 0) then {
					_staticATPos = _currentTryPos;
					_staticATFound = true;
					break;
				};
			};

			if (_staticATFound) then {
				private _staticAT = createVehicle [_staticATClass, _staticATPos, [], 0, "NONE"];
				_staticAT setDir _staticATDir;
				private _gunnerGroup = createGroup [opfor, true];
				_gunnerGroup createUnit [selectRandom _infantryTypes, _staticATPos, [], 0, "NONE"] moveInGunner _staticAT;
				_staticWeaponsSpawnedCount = _staticWeaponsSpawnedCount + 1;
			};
		};

		if (_staticWeaponsSpawnedCount < _maxStaticWeaponsHardcoded && random 1 < _staticWeaponChance) then {

			private _staticMGClass = selectRandom _staticMGTypes;
			private _staticMGPos = [];
			private _staticMGFound = false;
			private _staticMGDir = random 360;

			for "_t" from 1 to 10 do {
				private _dist = 15 + random 20;
				private _currentTryPos = _campPos getPos [_dist, random 360];
				if (count (_currentTryPos isFlatEmpty [2, -1, 0.3, 5, 0, false]) > 0) then {
					_staticMGPos = _currentTryPos;
					_staticMGFound = true;
					break;
				};
			};

			if (_staticMGFound) then {
				private _staticMG = createVehicle [_staticMGClass, _staticMGPos, [], 0, "NONE"];
				_staticMG setDir _staticMGDir;
				private _gunnerGroup = createGroup [opfor, true];
				_gunnerGroup createUnit [selectRandom _infantryTypes, _staticMGPos, [], 0, "NONE"] moveInGunner _staticMG;
				_staticWeaponsSpawnedCount = _staticWeaponsSpawnedCount + 1;
			};
		};

		if (_staticWeaponsSpawnedCount < _maxStaticWeaponsHardcoded && random 1 < _staticWeaponChance) then {

			private _mortarClass = selectRandom _mortarTypes;
			private _mortarPos = [];
			private _mortarFound = false;
			private _mortarDir = random 360;

			for "_t" from 1 to 10 do {
				private _dist = 15 + random 20;
				private _currentTryPos = _campPos getPos [_dist, random 360];
				if (count (_currentTryPos isFlatEmpty [3, -1, 0.3, 7, 0, false]) > 0) then {
					_mortarPos = _currentTryPos;
					_mortarFound = true;
					break;
				};
			};

			if (_mortarFound) then {
				private _mortar = createVehicle [_mortarClass, _mortarPos, [], 0, "NONE"];
				_mortar setDir _mortarDir;
				private _gunnerGroup = createGroup [opfor, true];
				_gunnerGroup createUnit [selectRandom _infantryTypes, _mortarPos, [], 0, "NONE"] moveInGunner _mortar;
				_staticWeaponsSpawnedCount = _staticWeaponsSpawnedCount + 1;
			};
		};

		//==========Patrol Spawning==========//
		private _numPatrolGroupsToSpawn = _patrolGroupCountMin + floor random ((_patrolGroupCountMax - _patrolGroupCountMin) + 1);

		for "_patrolGroupIdx" from 1 to _numPatrolGroupsToSpawn do {
			private _numPatrolUnits = _patrolSizeMin + floor random ((_patrolSizeMax - _patrolSizeMin) + 1);
			private _patrolRadius = 80 + random (400 - 80);
			private _numPatrolWaypoints = 2 + floor random ((4 - 2) + 1);

			if (_numPatrolUnits > 0) then {
				private _patrolGroup = createGroup [opfor, true];
				private _patrolUnits = [];

				for "_i" from 1 to _numPatrolUnits do {
					private _type = selectRandom _infantryTypes;
					private _unitPos = [];
					private _found = false;

					for "_j" from 1 to 20 do {
						private _tryPos = _campPos getPos [random (_patrolRadius / 2), random 360];
						if (count (_tryPos isFlatEmpty [1, -1, 0.3, 3, 0, false]) > 0) then {
							_unitPos = _tryPos;
							_found = true;
							break;
						};
					};

					if (_found) then {
						private _unit = _patrolGroup createUnit [_type, _unitPos, [], 0, "NONE"];
						_unit setDir random 360;
						_unit setSkill ["aimingAccuracy", 0.4];
						_patrolUnits pushBack _unit;
					};
				};

				if (count _patrolUnits > 0) then {
					private _startWaypoint = _patrolGroup addWaypoint [_campPos, 0];
					_startWaypoint setWaypointType "MOVE";
					_startWaypoint setWaypointSpeed "LIMITED";
					_startWaypoint setWaypointFormation "COLUMN";
					_startWaypoint setWaypointStatements ["true", ""];

					for "_i" from 1 to _numPatrolWaypoints do {
						private _waypointPos = [];
						private _waypointFound = false;
						for "_j" from 1 to 20 do {
							private _tryPos = _campPos getPos [random _patrolRadius, random 360];
							if (count (_tryPos isFlatEmpty [5, -1, 0.3, 10, 0, false]) > 0) then {
								_waypointPos = _tryPos;
								_waypointFound = true;
								break;
							};
						};

						if (_waypointFound) then {
							private _waypoint = _patrolGroup addWaypoint [_waypointPos, 0];
							_waypoint setWaypointType "MOVE";
							_waypoint setWaypointSpeed "LIMITED";
							_waypoint setWaypointFormation "COLUMN";
							_waypoint setWaypointStatements ["true", ""];
						};
					};

					private _finalWaypoint = _patrolGroup addWaypoint [_campPos, 0];
					_finalWaypoint setWaypointType "CYCLE";
					_finalWaypoint setWaypointSpeed "LIMITED";
					_finalWaypoint setWaypointFormation "COLUMN";
					_finalWaypoint setWaypointStatements ["true", ""];
				};

				[_patrolGroup] spawn {
					params ["_group"];
					sleep 5;
					_group setBehaviourStrong "SAFE";
					_group setSpeedMode "LIMITED";
				};
			};
		};

		//==========Add New Systems Here==========//
		
				// === Smoke Spawning ==== //
		{
			private _obj = _x;
			private _classname = typeOf _obj;
			
			if (_classname in [
				"Land_Wreck_Heli_02_Wreck_01_F",
				"Land_Wreck_Heli_02_Wreck_02_F",	
				"Land_Wreck_Heli_02_Wreck_03_F",
				"Land_Wreck_Heli_02_Wreck_04_F",
				"Land_Wreck_Heli_Attack_01_F",
				"Land_Wreck_Heli_Attack_02_F",
				"Land_Mi8_wreck_F",
				"Land_Wreck_Plane_Transport_01_F",
				"SpaceshipCapsule_01_F"
			]) then {
				
				_obj setVariable ["smokeSource", objNull, true];
				_obj setVariable ["smokingActive", false, true];
				
				private _smokePos = getPosATL _obj;
				_smokePos set [2, (_smokePos select 2) + 2];
				
				private _smoke = createVehicle ["test_EmptyObjectForSmoke", _smokePos, [], 0, "CAN_COLLIDE"];
				_smoke enableSimulation false;
				_obj setVariable ["smokeSource", _smoke, true];
				
				[_obj, _smoke] spawn {
					params ["_wreck", "_smokeObj"];
					
					while {!isNull _wreck && !isNull _smokeObj} do {
						private _playerNear = false;
						
						{
							if (alive _x && isPlayer _x && (_wreck distance _x) <= 1000) then {
								_playerNear = true;
							};
						} forEach allUnits;
						
						private _currentlyActive = _wreck getVariable ["smokingActive", false];
						
						if (_playerNear && !_currentlyActive) then {
							_smokeObj enableSimulation true;
							_wreck setVariable ["smokingActive", true, true];
						} else {
							if (!_playerNear && _currentlyActive) then {
								_smokeObj enableSimulation false;
								_wreck setVariable ["smokingActive", false, true];
							};
						};
						
						sleep 10;
					};
					
					if (!isNull _smokeObj) then {
						deleteVehicle _smokeObj;
					};
				};
			};
		} forEach _spawnedObjects;
		
		
		// === CIVILIAN SPAWNING === //
				private _civilianTypes = ["B_Soldier_unarmed_F", "C_man_pilot_F" ];
				private _numCivilians = 1 + floor random 4;


				if (_numCivilians > 0) then {
					private _civilianGroup = createGroup [civilian, true];

					for "_i" from 1 to _numCivilians do {
						private _civilianType = selectRandom _civilianTypes;
						private _civilianPos = [];
						private _foundCivPos = false;

						for "_k" from 1 to 40 do {
							private _tryPos = _campPos getPos [(random 15), random 360];
							if (count (_tryPos isFlatEmpty [1, -1, 0.3, 3, 0, false]) > 0) then {
								_civilianPos = _tryPos;
								_foundCivPos = true;
								break;
							};
						};

						if (_foundCivPos) then {
							private _civilian = _civilianGroup createUnit [_civilianType, _civilianPos, [], 0, "CAN_COLLIDE"];
							_civilian setDir random 360;
							_civilian setCaptive true;
							_civilian disableAI "MOVE";

							_civilian setVariable ["isPotentialcrashSurvivor", true, true];

							private _checkCivilian = _civilian; // Reference to the civilian for the spawned script
							private _proximityCheckScript = _checkCivilian spawn {
								
								params ["_civ"];

								
								while {true} do {
									
									if (isNull _civ || !(_civ getVariable ["isPotentialcrashSurvivor", false])) exitWith {};

									private _playerNear = false;
									
									{
										if (alive _x && (_civ distance _x) <= 2) then {
											_playerNear = true;
										};
									} forEach allPlayers;

									if (_playerNear) then {
										_civ setCaptive false;
										_civ enableAI "MOVE";

										
										_civ setVariable ["isPotentialcrashSurvivor", false, true];

										
										{ _x sideChat "Crash Survivor Found!"; } forEach allPlayers;

										
										private _crashSurvivorsLeft = 0;
										{
											
											if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialcrashSurvivor", false])) then {
												_crashSurvivorsLeft = _crashSurvivorsLeft + 1;
											};
										} forEach allUnits;

										
										{ _x sideChat format ["Crash Survivors left: %1", _crashSurvivorsLeft]; } forEach allPlayers;

										if (_crashSurvivorsLeft == 0) then {
										
											player sideChat "Objective Complete: All Crash Survivors Found";
											nul = [] execVM "missionCompleteScreen.sqf";
											
											//add xp/coins
											[100] execVM "addXP.sqf";
											[2] execVM "addCredits.sqf";
											
											//-1 side mission from fobSystems.sqf
											private _currentActiveMissions = missionNamespace getVariable ["activeSideMissions", 0];
											missionNamespace setVariable ["activeSideMissions", _currentActiveMissions - 1, true];
										};

										break;
								   };
									sleep 2;
								};
							};
						};
					};

			private _totalInitialcrashSurvivors = 0;
			{
				
				if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialcrashSurvivor", false])) then {
					_totalInitialcrashSurvivors = _totalInitialcrashSurvivors + 1;
				};
			} forEach allUnits;
			{ _x sideChat format ["Total potential Crash Survivors in mission: %1", _totalInitialcrashSurvivors]; } forEach allPlayers;
		};

		// === MAGAZINE SPAWNING === //
		private _magPos = [];
		private _magFound = false;
		private _spawnPos = _campPos;

		if (_numCivilians > 0) then {
			private _nearbyCivilians = [];
			{
				if (alive _x && (side _x == civilian) && (_x distance _campPos) < 20) then {
					_nearbyCivilians pushBack _x;
				};
			} forEach allUnits; // Changed to allUnits to correctly find newly spawned civilians
			
			if (count _nearbyCivilians > 0) then {
				private _targetCivilian = selectRandom _nearbyCivilians;
				_spawnPos = getPos _targetCivilian;
			};
		};

		private _searchRadiusMagazine = if (_spawnPos isEqualTo _campPos) then { 15 } else { 3 }; // 15m from camp, 3m from civilian
		for "_m" from 1 to 15 do {
			private _distance = if (_spawnPos isEqualTo _campPos) then { 5 + random 10 } else { 1 + random 2 };
			private _tryPos = _spawnPos getPos [_distance, random 360];
			if (count (_tryPos isFlatEmpty [0.5, -1, 0.2, 2, 0, false]) > 0) then {
				_magPos = _tryPos;
				_magFound = true;
				break;
			};
		};

		if (_magFound) then {
			private _magazine = createVehicle ["vn_magazine_lmg_m63a_100", _magPos, [], 0, "CAN_COLLIDE"];
			
			_magazine setObjectTexture [0, "#(rgb,1,1,1)color(0,0.5,0,1)"];
			_magazine addAction [
				"<t color='#00ff00' size='1.2'>Pick up Black Box</t>",
				{
					params ["_target", "_caller", "_actionId", "_arguments"];
					
					_caller sideChat "Black Box Recovered";
					
					[50] execVM "addXP.sqf";
					[0] execVM "addCredits.sqf";
					player sideChat "XP: +50  | Field Credits: +0 ";
					
					deleteVehicle _target;
				},
				nil,
				101,
				true,
				true,
				"",
				"true"
			];
		};

		//==========End New Systems Here==========//

		_spawned = true;
		player sideChat "New Objective: Conduct search for survivors at crash zone";
		nul = [] execVM "missionBriefings\downedChopperBrief.sqf";
	};
};