//==========General Settings ==========//

private _markerNameText = "Wreck Site";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 3; //Default 2
private _staticGroupSizeMax = 8; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 1; //Default 2

//Patrol Groups
private _patrolSizeMin = 2; //Default 1
private _patrolSizeMax = 5; //Default 6
private _patrolGroupCountMin = 0; //Default 0
private _patrolGroupCountMax = 1; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.7; //Default 0.2
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
	
		private _emplacementVariants = [
			// First emplacement
			[
				["Land_ShellCrater_02_decal_F",[-0.682617,0.970703,0],161.294], 
				["Land_ShellCrater_02_debris_F",[-0.879883,0.757813,0],152.777], 
				["Land_Decal_ScorchMark_01_large_F",[0.354492,3.33203,0],74.8732], 
				["Land_Decal_ScorchMark_01_large_F",[-3.2168,-0.228516,0],74.8732], 
				["Land_ShellCrater_02_debris_F",[-3.85059,2.24023,0],0], 
				["Land_ShellCrater_02_debris_F",[-3.99219,0.236328,0.0992908],219.931], 
				["Land_ShellCrater_02_debris_F",[-2.42285,4.98047,0],59.5838], 
				["Land_Wreck_Hunter_F",[-4.17676,1.14258,0.0585384],61.341], 
				["Land_ShellCrater_02_decal_F",[-0.964844,5.62109,0],85.7938], 
				["Land_ShellCrater_01_F",[-5.01172,2.63672,0.158569],259.577], 
				["Land_ShellCrater_02_debris_F",[-6.05566,0.105469,0],219.461], 
				["Land_Decal_ScorchMark_01_large_F",[-6.20801,-1.06836,0],74.8732], 
				["Land_ShellCrater_02_decal_F",[-6.55566,-0.0878906,0],260.747], 
				["Land_ShellCrater_02_debris_F",[-5.91895,4.12109,0.106012],0], 
				["Land_ShellCrater_02_debris_F",[-3.44629,6.77148,0],89.3885], 
				["Land_ShellCrater_02_debris_F",[-6.53516,2.69727,0],153.278], 
				["Land_ShellCrater_02_decal_F",[-6.3418,5.68164,0],5.36961], 
				["Snake_random_F",[23.1963,34.2246,0.00838852],356.743]
			],
			// Second emplacement
			[
				["Land_ShellCrater_02_debris_F",[-0.666992,0.232422,0],0], 
				["Land_ShellCrater_02_debris_F",[-0.808594,-1.77148,0],219.931], 
				["Land_ShellCrater_02_debris_F",[2.30371,-1.25,-0.000810623],152.777], 
				["Land_ShellCrater_02_debris_F",[1.49316,2.46094,0],152.777], 
				["Land_ShellCrater_02_decal_F",[2.50098,-1.03711,0],161.294], 
				["Land_Wreck_BRDM2_F",[2.26953,1.61328,0.0223007],0], 
				["Land_ShellCrater_02_debris_F",[-2.73535,2.11328,0.0601349],0], 
				["Land_Decal_ScorchMark_01_large_F",[3.53809,1.32422,0],74.8732], 
				["Land_ShellCrater_02_debris_F",[0.15332,4.26953,0],152.777], 
				["Land_ShellCrater_02_decal_F",[2.21875,3.61328,0],85.7938], 
				["Snake_random_F",[-2.19043,19.3359,0.00839043],209.487], 
				["Snake_random_F",[-1.46289,22.4297,0.0083847],300.257], 
				["Snake_random_F",[-22.9902,-3.3457,0.00838852],206.479], 
				["Rabbit_F",[-14.501,35.9727,0.00320816],100.661]
			],
			// Third emplacement
			[
				["Land_ShellCrater_01_decal_F",[2.30859,0.875,0],270.205], 
				["Land_ShellCrater_02_debris_F",[1.36914,1.55469,0],287.441], 
				["Land_Decal_ScorchMark_01_large_F",[3.17773,1.99219,1.90735e-06],110.644], 
				["Land_ShellCrater_02_debris_F",[3.2334,-0.736328,0],287.441], 
				["Land_ShellCrater_01_decal_F",[1.16895,3.75781,0],313.464], 
				["Land_ShellCrater_01_decal_F",[4.81055,-0.375,0],223.28], 
				["Land_Decal_ScorchMark_01_large_F",[2.46387,4.37109,0],74.8732], 
				["Land_ShellCrater_01_F",[4.24414,2.52344,0],205.309], 
				["Land_ShellCrater_02_debris_F",[1.14258,4.26758,0.0605888],286.207], 
				["Land_Wreck_HMMWV_F",[5.16992,2.24219,-0.260138],0], 
				["Land_ShellCrater_02_debris_F",[5.73633,-1.13672,0],287.441], 
				["Land_ShellCrater_01_F",[3.8877,4.83398,0],152.882], 
				["Land_ShellCrater_01_decal_F",[2.59473,6.07227,0],28.4051], 
				["Land_ShellCrater_01_decal_F",[6.58008,1.35547,0],154.009], 
				["Land_ShellCrater_01_F",[6.0293,3.22266,0],327.663], 
				["Land_ShellCrater_02_debris_F",[3.44727,6.05273,0],340.915], 
				["Land_Decal_ScorchMark_01_large_F",[3.93555,6.11719,0],274.425], 
				["Land_ShellCrater_01_decal_F",[6.96289,3.46094,0],106.222], 
				["Land_ShellCrater_01_decal_F",[5.29688,5.88281,0],67.771], 
				["Land_ShellCrater_02_debris_F",[6.14746,4.45313,0],287.441], 
				["Snake_random_F",[-22.9141,-12.6309,0.00838661],116.489], 
				["Snake_random_F",[-18.9873,-45.375,0.00838852],345.175]
			],
			// Fourth emplacement
			[
				["Land_ShellCrater_02_debris_F",[-0.0761719,1.00586,0],287.441], 
				["Land_ShellCrater_01_decal_F",[-0.888672,1.38867,0],232.736], 
				["Land_ShellCrater_02_debris_F",[-2.5791,1.40625,-0.00114441],287.441], 
				["Land_ShellCrater_02_debris_F",[2.19141,2.97266,0],110.55], 
				["Land_ShellCrater_01_decal_F",[2.13477,2.80273,0],164.202], 
				["Land_ShellCrater_01_decal_F",[-3.50391,3.01758,0],270.205], 
				["Land_Decal_ScorchMark_01_large_F",[3.87793,3.00195,0],111.978], 
				["Land_Wreck_Slammer_turret_F",[-0.970703,4.5957,-0.328753],148.503], 
				["CraterLong_02_small_F",[-0.771484,4.35742,0],141.494], 
				["Land_ShellCrater_02_debris_F",[2.22168,5.8457,0],53.8946], 
				["Land_ShellCrater_02_debris_F",[-4.44336,3.69727,-0.00114441],287.441], 
				["Land_ShellCrater_01_decal_F",[2.01172,6.04297,0],102.086], 
				["Land_Decal_ScorchMark_01_large_F",[3.3418,6.05469,0],268.512], 
				["Land_ShellCrater_02_debris_F",[0.334961,6.5957,0],287.441], 
				["Land_Wreck_Slammer_hull_F",[6.28027,4.13867,0],347.641], 
				["Land_ShellCrater_01_decal_F",[-4.64355,5.90039,0],313.464], 
				["Land_Decal_ScorchMark_01_large_F",[5.17773,6.28711,0],101.538], 
				["Land_ShellCrater_01_decal_F",[-0.515625,8.02539,0],67.771], 
				["Land_ShellCrater_01_F",[3.28516,7.41406,0],259.577], 
				["Land_ShellCrater_02_debris_F",[-4.66992,6.41016,0],286.207], 
				["Land_ShellCrater_02_debris_F",[-2.36523,8.19531,0],340.915], 
				["Land_ShellCrater_01_decal_F",[-3.21777,8.21484,0],33.201], 
				["Land_ShellCrater_01_F",[5.83887,7.68164,0],259.577], 
				["Land_ShellCrater_02_debris_F",[4.53711,8.46875,0],219.931], 
				["Snake_random_F",[-28.2744,-16.0527,0],299.462]
			],
			// Fifth emplacement
			[
				["Land_Decal_ScorchMark_01_large_F",[4.00293,2.50586,0],110.644], 
				["Land_Decal_ScorchMark_01_large_F",[3.28906,4.88477,1.90735e-06],74.8732], 
				["Land_Wreck_Slammer_F",[6.17773,3.49707,0],0], 
				["Land_Decal_ScorchMark_01_large_F",[4.76074,6.62891,0],274.425], 
				["Snake_random_F",[4.15332,-9.58691,0.00838852],241.934], 
				["Snake_random_F",[27.4727,22.5449,0.00839043],28.2345]
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
				"Land_Wreck_Slammer_F",
				"Land_Wreck_Slammer_hull_F",
				"Land_Wreck_HMMWV_F",
				"Land_Wreck_BRDM2_F",
				"Land_Wreck_Hunter_F"

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

							_civilian setVariable ["isPotentialwreckSurvivor", true, true];

							private _checkCivilian = _civilian; // Reference to the civilian for the spawned script
							private _proximityCheckScript = _checkCivilian spawn {
								
								params ["_civ"];

								
								while {true} do {
									
									if (isNull _civ || !(_civ getVariable ["isPotentialwreckSurvivor", false])) exitWith {};

									private _playerNear = false;
									
									{
										if (alive _x && (_civ distance _x) <= 2) then {
											_playerNear = true;
										};
									} forEach allPlayers;

									if (_playerNear) then {
										_civ setCaptive false;
										_civ enableAI "MOVE";

										
										_civ setVariable ["isPotentialwreckSurvivor", false, true];

										
										{ _x sideChat "Wreck Survivor Found!"; } forEach allPlayers;

										
										private _wreckSurvivorsLeft = 0;
										{
											
											if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialwreckSurvivor", false])) then {
												_wreckSurvivorsLeft = _wreckSurvivorsLeft + 1;
											};
										} forEach allUnits;

										
										{ _x sideChat format ["Wreck Survivors left: %1", _wreckSurvivorsLeft]; } forEach allPlayers;

										if (_wreckSurvivorsLeft == 0) then {
										
											player sideChat "Objective Complete: All Wreck Survivors Found";
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

			private _totalInitialwreckSurvivors = 0;
			{
				
				if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialwreckSurvivor", false])) then {
					_totalInitialwreckSurvivors = _totalInitialwreckSurvivors + 1;
				};
			} forEach allUnits;
			{ _x sideChat format ["Total potential Wreck Survivors in mission: %1", _totalInitialwreckSurvivors]; } forEach allPlayers;
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
				"<t color='#00ff00' size='1.2'>Pick up Dash Cam Footage</t>",
				{
					params ["_target", "_caller", "_actionId", "_arguments"];
					
					_caller sideChat "Dash Cam Footage Recovered";
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
		player sideChat "New Objective: Meet with immobilized crew";
		nul = [] execVM "missionBriefings\vehicleWreckBrief.sqf";
	};
};