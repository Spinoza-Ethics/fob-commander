//==========General Settings ==========//

private _markerNameText = "Anti-Air";
private _markerType = "o_mortar";


//Static Groups
private _staticGroupSizeMin = 2; //Default 2
private _staticGroupSizeMax = 8; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 1; //Default 2

//Patrol Groups
private _patrolSizeMin = 2; //Default 1
private _patrolSizeMax = 6; //Default 6
private _patrolGroupCountMin = 0; //Default 0
private _patrolGroupCountMax = 1; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.4; //Default 0.2
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
				["Land_Garbage_square5_F", [2.668,1.047,0],75],
				["Land_CanisterFuel_F", [2.331,1.732,0],224.942],
				["Land_BarrelSand_grey_F", [2.831,1.232,0],359.991],
				["Land_CanisterFuel_F", [2.815,1.971,0],179.95],
				["Land_PaperBox_open_empty_F", [4.081,1.732,0],0],
				["Land_FieldToilet_F", [3.831,3.732,0],89.997],
				["Land_FieldToilet_F", [3.831,5.482,0],89.996],
				["Land_HBarrier_5_F", [5.827,5.73,0],90],
				["CamoNet_INDP_open_F", [0.969,6.508,0],90],
				["Land_Garbage_square5_F", [2.16,6.715,0],75],
				["Land_FieldToilet_F", [3.831,7.482,-0.001],89.999],
				["Land_CratesWooden_F", [1.081,9.482,0],180],
				["Land_PaperBox_open_full_F", [3.827,9.115,0],150],
				["Land_PalletTrolley_01_khaki_F", [-0.659,10.467,0],299.474],
				["Land_HBarrier_5_F", [5.827,11.355,0],90],
				["Land_PaperBox_closed_F", [0.818,11.23,0],270],
				["Land_HBarrier_3_F", [2.467,11.209,0],0],
				["Snake_random_F", [-32.179,35.461,0.008],114.612]
			],

			// Second emplacement
			[
				["Land_CncBarrierMedium_F", [2.713,0.256,0],75],
				["Land_FoodContainer_01_F", [3.696,0.502,0],209.968],
				["Land_FoodContainer_01_F", [3.793,-0.016,0],0.106],
				["Land_CncBarrierMedium_F", [3.958,-1.486,0],45],
				["RoadBarrier_F", [4.956,-0.75,0.003],29.983],
				["Land_CratesWooden_F", [2.596,6.281,0],285],
				["Land_DuctTape_F", [1.703,6.691,0],285.009],
				["Land_ButaneCanister_F", [1.596,6.908,0],90.108],
				["Land_ButaneTorch_F", [1.708,6.908,0],29.996],
				["Land_ButaneCanister_F", [1.664,7.053,0],285.195],
				["Land_TinContainer_F", [1.973,7.326,0.001],75.445],
				["Land_Cargo10_military_green_F", [-1.779,7.406,0],126.115],
				["Land_Portable_generator_F", [2.973,8.158,-0.001],314.993],
				["Land_BarrelSand_F", [9.195,0.252,0],359.973],
				["Land_CratesWooden_F", [9.445,-0.748,0],0],
				["Land_CncBarrierMedium4_F", [9.172,-2.23,0],0],
				["Land_MetalWire_F", [9.716,0.182,0],300],
				["CamoNet_INDP_big_F", [9.491,3.766,0],180],
				["Land_Garbage_square5_F", [9.483,4.324,0],0],
				["Land_FireExtinguisher_F", [10.944,-1.289,0],224.992],
				["RoadBarrier_F", [12.303,-0.129,-0.004],191.899],
				["Land_CncBarrierMedium_F", [14.208,-1.76,0],135],
				["Land_CarBattery_02_F", [14.446,5.752,0],314.935],
				["Box_IND_AmmoVeh_F", [15.112,4.477,0.033],345.066],
				["FlexibleTank_01_forest_F", [14.931,6.234,0.001],358.798],
				["Land_CncBarrierMedium_F", [16.679,2.008,0],285],
				["Land_CncBarrierMedium_F", [14.681,8.742,0],240],
				["Land_CncBarrierMedium_F", [15.931,6.492,0],240],
				["Land_CncBarrierMedium_F", [16.679,4.498,0],255],
				["Land_Cargo20_grey_F", [18.971,9.281,0],57.991],
				["Snake_random_F", [-6.91,28.92,0.008],287.194],
				["Snake_random_F", [-31.436,-28.316,0],174.26]
			],

			// Third emplacement
			[
				["Land_CampingChair_V1_F", [-2.611,3.115,0.005],105.784],
				["Land_CampingTable_F", [-3.013,3.602,-0.003],98.347],
				["Land_CampingChair_V1_F", [-2.118,4.184,0.003],74.984],
				["Land_Garbage_square5_F", [-5.791,0.326,0],0],
				["Land_Cargo_House_V1_F", [-5.308,-5.121,0],270],
				["Land_Cargo_House_V1_F", [-5.183,5.254,0],270],
				["Land_HBarrier_3_F", [0.272,-5.633,0],90],
				["Land_ToiletBox_F", [-0.204,7.004,0],15.002],
				["Land_CampingChair_V1_F", [-2.695,-6.832,0.003],75.066],
				["Land_CampingTable_small_F", [-3.205,-6.871,0.003],89.97],
				["Land_PaperBox_open_empty_F", [-7.704,-1.121,0],0],
				["Land_Tyres_F", [-8.165,1.256,0.007],315],
				["Land_HBarrier_3_F", [1.522,9.242,0],90],
				["Land_HBarrier_5_F", [0.42,-9.117,0],180],
				["Land_HBarrier_5_F", [-4.203,9.125,0],0],
				["Land_HBarrier_5_F", [-9.575,-2.244,0],270],
				["Land_HBarrier_5_F", [-9.576,-7.869,0.001],270],
				["Land_HBarrier_5_F", [-9.575,3.381,0],270],
				["Land_HBarrier_5_F", [-5.204,-9.115,0.004],180],
				["Land_HBarrier_5_F", [-9.828,9.125,0],0],
				["Snake_random_F", [-3.077,13.232,0.008],189.134],
				["Rabbit_F", [28.567,-18.145,0.003],26.809],
				["Snake_random_F", [26.607,41.658,0.008],133.361]
			],

			// Fourth emplacement
			[
				["Land_BagFence_Long_F", [-3.039,-0.33,0],75],
				["Land_PowerGenerator_F", [3.194,1.148,0],195],
				["Land_BagFence_Long_F", [-3.412,2.416,0],90],
				["Land_HBarrier_5_F", [-3.427,4.658,0],0],
				["Land_TTowerSmall_1_F", [2.091,1.924,0],0],
				["Land_MetalBarrel_F", [0.481,7.521,0],254.996],
				["Land_BagFence_Long_F", [-3.443,6.908,-0.001],270],
				["Land_MetalBarrel_F", [-0.303,8.162,0],30.002],
				["Land_HBarrier_3_F", [8.3,2.402,0.001],90],
				["Land_BagBunker_Tower_F", [5.845,5.807,0],90],
				["Land_MetalBarrel_F", [0.447,8.537,0],344.992],
				["Land_FieldToilet_F", [10.447,1.286,0],330.002],
				["Land_BagFence_Long_F", [2.83,11.398,0],165],
				["Land_BagFence_Long_F", [5.45,11.771,0],180],
				["Land_BagFence_Long_F", [8.322,11.427,-0.003],15],
				["Snake_random_F", [-23.173,10.07,0.008],2.258],
				["Snake_random_F", [44.569,4.259,0.008],349.256]
			],

			// Fifth emplacement
			[
				["Land_BagFence_End_F", [0.601,2.578,0],225],
				["Land_BagFence_Short_F", [1.993,1.911,0],180],
				["Land_BagFence_Round_F", [-2.69,1.086,-0.001],315],
				["Land_BagFence_Round_F", [4.178,2.24,0],315],
				["Land_BagFence_Round_F", [-5.267,1.208,-0.001],45],
				["Land_BagFence_Short_F", [4.731,4.402,0],270],
				["Land_BagFence_Long_F", [-5.914,3.997,0],260],
				["Land_BagFence_End_F", [4.756,6.102,0],270],
				["Land_CratesWooden_F", [-5.018,7.163,0],75],
				["Land_Garbage_square5_F", [-2.76,8.892,0],0],
				["Land_PaperBox_closed_F", [-1.274,9.152,0],225],
				["Land_HBarrier_5_F", [9.231,6.167,0],180],
				["Land_BarrelTrash_grey_F", [3.982,9.413,0],359.957],
				["Land_HBarrier_5_F", [-7.381,9.972,0],75],
				["Land_WaterBarrel_F", [-2.018,10.413,0],360],
				["CamoNet_INDP_open_F", [-2.38,10.314,0],90],
				["Land_GarbageWashingMachine_F", [8.742,7.895,0],180],
				["Land_Garbage_square5_F", [9.818,7.793,0],0],
				["Land_Cargo_House_V1_F", [5.961,11.663,0],90],
				["Land_HBarrier_5_F", [10.479,10.412,0.003],90],
				["Land_Garbage_square5_F", [3.771,12.985,0],0],
				["Land_GarbagePallet_F", [4.007,13.377,0],0],
				["Land_HBarrier_5_F", [-7.521,15.162,0],90],
				["Land_PaperBox_closed_F", [-2.77,15.176,0],0],
				["Land_HBarrier_5_F", [0.731,17.167,0],180],
				["Land_HBarrier_5_F", [10.486,11.665,-0.003],270],
				["Land_PowerGenerator_F", [8.467,16.038,0],270],
				["Land_CratesPlastic_F", [7.233,17.167,0],255],
				["Land_HBarrier_3_F", [8.368,17.39,0],0],
				["Land_Pallets_stack_F", [7.206,18.688,-0.001],314.902],
				["Land_TTowerSmall_2_F", [9.379,15.27,0],0],
				["Snake_random_F", [-24.392,-8.308,0.008],6.01]
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
		
		// === Start Object Spawn System === //
		private _objectData = createHashMap;

		//script ref(needed), obj file name, add action(leave empty to remove), spawn range min,max
		_objectData set ["aa1", ["O_APC_Tracked_02_AA_F", "", [15, 50]]];
		_objectData set ["aa2", ["O_Radar_System_02_F", "", [10, 30]]];
		_objectData set ["aa3", ["O_SAM_System_04_F", "", [10, 50]]];
		private _basePosition = _campPos;

		// Min and max number of objects to spawn
		private _minObjectsToSpawn = 1;
		private _maxObjectsToSpawn = 2;
		private _numberOfObjectsToSpawn = _minObjectsToSpawn + floor(random (_maxObjectsToSpawn - _minObjectsToSpawn + 1));

		private _availableObjects = keys _objectData;
		if (count _availableObjects > 0) then {
			for "_i" from 1 to _numberOfObjectsToSpawn do {
				private _randomIndex = floor(random (count _availableObjects));
				private _objectType = _availableObjects select _randomIndex;
				
				private _data = _objectData get _objectType;
				if (!isNil "_data") then {
					_data params ["_classname", "_actionText", "_spawnRadius"];
					private _hasAction = _actionText != "";
					
					private _finalPos = [];
					private _found = false;
					for "_j" from 1 to 20 do {
						private _minDist = _spawnRadius select 0;
						private _maxDist = _spawnRadius select 1;
						private _distance = _minDist + random (_maxDist - _minDist);
						private _angle = random 360;
						private _tryPos = _basePosition getPos [_distance, _angle];
						
						if (count (_tryPos isFlatEmpty [2, -1, 0.3, 5, 0, false]) > 0) then {
							_finalPos = _tryPos;
							_found = true;
							break;
						};
					};
					
					if (_found) then {
						private _obj = createVehicle [_classname, _finalPos, [], 0, "CAN_COLLIDE"];
						_obj setDir (random 360);
						
						// --- Start Crew Spawning for Objects ---
						if (_obj isKindOf "LandVehicle" || _obj isKindOf "Air" || _obj isKindOf "Ship") then {
							private _objGroup = createGroup [opfor, true]; // Create a new group for the object's crew

							if (driver _obj isEqualTo objNull) then {
								private _driver = _objGroup createUnit [_defaultDriverType, _finalPos, [], 0, "NONE"];
								_driver moveInDriver _obj;
							};
							if (gunner _obj isEqualTo objNull) then {
								private _gunner = _objGroup createUnit [_defaultGunnerType, _finalPos, [], 0, "NONE"];
								_gunner moveInGunner _obj;
							};
							if (commander _obj isEqualTo objNull) then {
								private _commander = _objGroup createUnit [_defaultCommanderType, _finalPos, [], 0, "NONE"];
								_commander moveInCommander _obj;
							};
						};
						// --- End Crew Spawning for Objects ---

						if (_hasAction) then {
							_obj addAction [
								format ["<t color='#00ff00' size='1.2'>%1</t>", _actionText],
								{
									params ["_target", "_caller"];
									private _actionText = _target getVariable ["actionText", "Item"];
									_caller sideChat format ["%1 Collected!", _actionText];
									deleteVehicle _target;
								},
								nil,
								1.5,
								true,
								true,
								"",
								"true"
							];
							_obj setVariable ["actionText", _actionText, true];
						};
					};
				};
			};
		};
		// === End Object Spawn System === //

		//==========End New Systems Here==========//

		_spawned = true;
		
		//=== Start Object Destruction Check System ===//

		//Must be placed at end of script after... _spawned = true;
		//Make sure object is Destroyable
		if (_spawned) then {
			// objects to watch
			_watchClasses = [
				"O_APC_Tracked_02_AA_F",
				"O_SAM_System_04_F",
				"O_Radar_System_02_F"
			];
			
			_objectsToWatch = [];
			{
				_found = nearestObjects [_campPos, [_x], 300];
				_objectsToWatch = _objectsToWatch + _found;
			} forEach _watchClasses;
			
			if (count _objectsToWatch > 0) then {
				
				// Start the monitoring loop
				[_objectsToWatch] spawn {
					params ["_objectsToWatch"];
					while {true} do {
						_stillAlive = _objectsToWatch select {alive _x};
						
						// If nothing left alive, mission complete
						if (count _stillAlive == 0) then {
							
							//Objective Complete Output
							player sideChat "Objective Complete: AA(s) Disabled";
							nul = [] execVM "missionCompleteScreen.sqf";
							
							//add xp/coins
						    [100] execVM "addXP.sqf";
							[2] execVM "addCredits.sqf";						
							//-1 side mission from fobSystems.sqf
							private _currentActiveMissions = missionNamespace getVariable ["activeSideMissions", 0];
							missionNamespace setVariable ["activeSideMissions", _currentActiveMissions - 1, true];
							break;
						};
						
						sleep 5; 
					};
				};
			};
		};

		//=== END Object Destruction Check System ===//
		player sideChat "New Objective: Immobilize enemy AA assets";
		nul = [] execVM "missionBriefings\antiAirBrief.sqf";
		
		
	};
};