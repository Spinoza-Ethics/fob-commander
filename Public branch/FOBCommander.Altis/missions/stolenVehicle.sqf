//==========General Settings ==========//

private _markerNameText = "Stolen NATO Vehicle";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 2; //Default 2
private _staticGroupSizeMax = 7; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 1; //Default 1
private _patrolSizeMax = 3; //Default 6
private _patrolGroupCountMin = 0; //Default 0
private _patrolGroupCountMax = 1; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.2; //Default 0.2
private _staticWeaponChance = 0.3; //Default 0.3

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
        ["Land_BagFence_Long_F", [1.636, 2.637, 0], 0],
        ["Land_BagFence_Round_F", [-0.984, 3.041, 0], 45],
        ["MapBoard_seismic_F", [-2.411, 2.783, 0], 39.84],
        ["Land_CampingChair_V1_F", [4.031, 1.658, 0], 347.8],
        ["Land_BagFence_Short_F", [3.879, 2.623, 0], 0],
        ["Land_CampingChair_V1_F", [-5.218, 1.102, 0], 199.988],
        ["Land_CampingTable_white_F", [-5.1, 2.291, 0], 0],
        ["Land_BagFence_Long_F", [-1.345, 5.625, 0], 90],
        ["MetalBarrel_burning_F", [1.39, 6.871, 0], 89.996],
        ["Land_BagFence_Short_F", [7.775, 2.494, 0], 180],
        ["Land_BagFence_Long_F", [-1.345, 8.5, 0], 90],
        ["Land_WaterTank_F", [1.64, 8.871, 0], 90.001],
        ["Land_Cargo_House_V3_F", [-5.43, 6.744, 0], 90.789],
        ["Land_BagFence_Round_F", [9.719, 2.871, 0], 315],
        ["Land_BarrelSand_F", [0.265, 10.246, 0], 0],
        ["Land_BagFence_Round_F", [-0.814, 11.246, 0], 135],
        ["Land_BagFence_Long_F", [10.28, 5.375, 0], 90],
        ["Land_Cargo_Patrol_V3_F", [3.393, 11.242, 0], 180],
        ["Land_HBarrier_3_F", [3.129, 11.52, 0], 180],
        ["Land_HBarrier_3_F", [6.379, 11.52, 0], 180],
        ["Land_HBarrier_3_F", [10.241, 9.609, 0], 90],
        ["Land_Pallet_MilBoxes_F", [2.262, 13.256, 0], 180],
        ["Land_BagFence_Long_F", [1.155, 13.625, 0], 90],
        ["Land_WaterBarrel_F", [11.89, 7.746, 0], 0],
        ["Land_CratesWooden_F", [12.015, 9.746, 0], 270],
        ["Land_HBarrier_3_F", [10.241, 12.859, 0], 90],
        ["Land_BagFence_Round_F", [1.686, 16.371, 0], 135],
        ["Land_MetalBarrel_F", [11.64, 11.371, 0], 89.996],
        ["Land_MetalBarrel_F", [11.64, 12.121, 0], 300.012],
        ["Land_MetalBarrel_F", [12.265, 11.621, 0], 225.016],
        ["Land_BagFence_Long_F", [4.515, 16.785, 0], 0],
        ["Land_BagFence_Short_F", [10.266, 14.131, 0], 90],
        ["Land_BagFence_Long_F", [7.386, 16.762, 0], 0],
        ["Land_BagFence_Round_F", [9.889, 16.201, 0], 225],
        ["Snake_random_F", [44.101, 21.23, 0], 246.212],
        ["Snake_random_F", [49.63, 0.727, 0], 198.165]
    ],
    // Second emplacement
    [
        ["Land_BagFence_Long_F", [-1.008, 0.842, 0], 0],
        ["Land_BagFence_Long_F", [1.742, 0.842, 0], 0],
        ["Land_BarrelTrash_grey_F", [-0.004, 3.076, 0], 359.995],
        ["Land_BagFence_Round_F", [-3.628, 1.246, 0], 45],
        ["Land_BagFence_Round_F", [4.075, 1.201, 0], 315],
        ["Land_GarbageBags_F", [-2.294, 2.936, 0], 0],
        ["Land_BagFence_Long_F", [-3.988, 3.83, 0], 90],
        ["Land_BagFence_Long_F", [4.512, 3.83, 0], 90],
        ["Land_Cargo_Patrol_V2_F", [-0.001, 6.072, 0], 180],
        ["Land_CratesWooden_F", [-1.879, 7.076, 0], 285],
        ["Land_Sacks_heap_F", [2.621, 7.326, 0], 255],
        ["Land_HBarrier_3_F", [4.02, 5.713, 0], 270],
        ["Land_HBarrier_3_F", [-4.027, 8.189, 0], 90],
        ["Land_CargoBox_V1_F", [6.733, 5.281, 0.031], 130.731],
        ["Land_BagFence_Short_F", [0.757, 9.324, 0], 180],
        ["Land_BagFence_Short_F", [-0.765, 9.328, 0], 0],
        ["Land_HBarrier_3_F", [4.235, 9.1, 0], 180],
        ["Land_HBarrier_3_F", [-2.015, 9.35, 0], 180],
        ["Land_CargoBox_V1_F", [6.507, 8.148, 0.031], 294.483]
    ],
    // Third emplacement
    [
        ["Land_IRMaskingCover_02_F", [2.628, 4.441, 0], 0],
        ["Land_HBarrier_3_F", [-0.586, 9.717, 0], 0],
        ["Land_HBarrier_3_F", [-3.835, 9.718, 0], 0],
        ["Land_HBarrier_3_F", [2.541, 9.753, 0], 0],
        ["Land_BagFence_Short_F", [5.143, 9.616, 0], 0],
        ["Land_PaperBox_open_full_F", [0.537, 11.49, 0], 270],
        ["Land_PaperBox_closed_F", [2.275, 11.502, 0], 0],
        ["Land_MetalBarrel_F", [4.111, 11.086, 0], 15.005],
        ["Land_BagFence_Long_F", [7.149, 9.631, 0], 0],
        ["Land_MetalBarrel_F", [4.903, 10.967, 0], 90.003],
        ["Land_PaperBox_open_empty_F", [-1.347, 11.99, 0], 315],
        ["Land_MetalBarrel_F", [4.528, 11.615, 0], 239.99],
        ["Land_HBarrier_3_F", [-3.62, 13.229, 0], 90],
        ["Land_BagFence_Short_F", [9.393, 9.616, 0], 0],
        ["Land_Cargo_Patrol_V3_F", [0.406, 14.861, 0], 180],
        ["Land_BagFence_Round_F", [11.482, 9.99, 0], 315],
        ["Land_Pallet_MilBoxes_F", [-1.494, 15.49, 0], 255],
        ["Land_HBarrier_3_F", [-3.62, 16.604, 0], 90],
        ["Land_WheelieBin_01_F", [5.991, 14.90, 0.023], 29.357],
        ["Land_BagFence_Short_F", [11.904, 11.875, 0], 90],
        ["Land_HBarrier_3_F", [-1.607, 17.514, 0], 180],
        ["Land_GarbagePallet_F", [5.742, 17.09, 0], 90],
        ["Land_BagFence_Short_F", [11.904, 13.5, 0], 90],
        ["Land_BagFence_Long_F", [9.024, 16.131, 0], 0],
        ["Land_HBarrier_3_F", [-0.323, 17.377, 0], 270],
        ["Land_HBarrier_3_F", [7.552, 16.002, 0], 270],
        ["Land_BagFence_Round_F", [11.527, 15.57, 0], 225],
        ["Land_HBarrier_3_F", [7.768, 19.389, 0], 180],
        ["Land_BagFence_Round_F", [0.074, 21.365, 0], 135],
        ["Land_BagFence_Round_F", [5.277, 21.195, 0], 225],
        ["Land_BagFence_Long_F", [2.649, 21.756, 0], 0],
        ["Snake_random_F", [-16.195, -19.268, 0], 113.568],
        ["Snake_random_F", [20.785, 16.947, 0], 276.145]
    ],
    // Fourth emplacement
    [
        ["Land_Sleeping_bag_brown_F", [-1.399, 4.643, 0], 359.138],
        ["Land_Pallets_F", [5.535, 2.489, 0], 267.491],
        ["CamoNet_INDP_open_F", [0.12, 4.861, 0], 0],
        ["Land_Sleeping_bag_F", [0.785, 5.932, 0], 305.312],
        ["Land_Ammobox_rounds_F", [-3.139, 5.509, 0], 36.755],
        ["Land_DuctTape_F", [-2.877, 5.828, 0], 33.558],
        ["Land_Ammobox_rounds_F", [-3.531, 5.557, 0], 80.323],
        ["Land_Canteen_F", [-3.205, 5.865, 0], 73.533],
        ["Land_Campfire_F", [-1.248, 6.772, 0.028], 311.909],
        ["Land_Pallets_stack_F", [6.647, 2.975, 0], 274.231],
        ["Land_Sleeping_bag_F", [-3.434, 6.626, 0], 91.105],
        ["Land_Camping_Light_F", [-3.334, 7.58, 0], 27.41],
        ["Land_Canteen_F", [-1.906, 8.806, 0], 43.092],
        ["Land_PainKillers_F", [-2.033, 9.063, 0], 5.051],
        ["Land_Sleeping_bag_F", [-2.676, 8.717, 0], 135.534],
        ["Land_PaperBox_open_full_F", [7.013, 6.85, 0], 92.926],
        ["Land_PaperBox_open_full_F", [7.117, 8.376, 0], 272.987],
        ["Land_PaperBox_open_empty_F", [-1.854, 13.724, 0], 251.154],
        ["Land_Cargo_Patrol_V1_F", [4.399, 14.096, 0], 180],
        ["Land_PaperBox_closed_F", [0.012, 14.466, 0], 242.345],
        ["Land_BagFence_Long_F", [-0.1, 16.833, 0], 180],
        ["Land_Pallets_F", [5.479, 17.511, 0], 169.016],
        ["Land_BagFence_Round_F", [1.781, 18.168, 0], 135],
        ["Land_BagFence_Long_F", [4.525, 18.583, 0], 180],
        ["Land_BagFence_Round_F", [7.271, 18.178, 0], 225],
        ["Snake_random_F", [-22.852, -21.942, 0], 128.878]
    ],
    // Fifth emplacement
    [
        ["Land_PaperBox_closed_F", [4.743, 1.247, 0], 0],
        ["Land_HBarrier_3_F", [4.146, 2.872, 0], 270],
        ["Land_PaperBox_open_empty_F", [6.621, 1.234, 0], 75],
        ["Land_HBarrier_3_F", [5.257, 3.087, 0], 0],
        ["Land_HBarrier_3_F", [4.073, 5.53, 0], 240],
        ["Land_PaperBox_closed_F", [5.868, 4.747, 0], 0],
        ["Land_Pallet_MilBoxes_F", [7.953, 4.739, 0], 105],
        ["Land_HBarrier_3_F", [2.186, 10.18, 0], 75],
        ["Land_BagFence_Long_F", [9.114, 3.021, 0], 180],
        ["Land_HBarrier_Big_F", [-8.547, 5.324, 0], 270],
        ["Land_PaperBox_open_full_F", [3.619, 11.118, 0], 165],
        ["Land_BagFence_Round_F", [11.825, 3.485, 0], 315],
        ["Land_HBarrier_3_F", [7.757, 8.961, 0], 0],
        ["Land_PaperBox_closed_F", [1.986, 12.602, 0], 240],
        ["Land_Razorwire_F", [-10.812, 9.463, 0], 90],
        ["Land_HBarrier_3_F", [7.895, 9.745, 0], 270],
        ["Land_BagFence_Long_F", [12.262, 5.863, 0], 90],
        ["Land_IRMaskingCover_02_F", [2.079, -13.443, 0], 0],
        ["Land_BagFence_Round_F", [11.798, 8.574, 0], 225],
        ["Land_Cargo_Patrol_V3_F", [3.499, 14.856, 0], 180],
        ["Land_HBarrier_Big_F", [-8.672, 13.574, 0], 270],
        ["Land_CargoBox_V1_F", [-5.897, 15.672, 0.031], 294.482],
        ["Land_HBarrier_Big_F", [7.953, 15.324, 0], 270],
        ["Land_Razorwire_F", [9.929, 14.006, 0], 270],
        ["Land_HBarrier_Big_F", [2.836, 18.527, 0], 0],
        ["Land_Razorwire_F", [-10.562, 17.588, 0], 90],
        ["Land_HBarrier_Big_F", [-5.414, 18.652, 0], 0],
        ["Land_Razorwire_F", [6.225, 20.542, 0.01], 180],
        ["Land_Razorwire_F", [-3.651, 20.541, 0.004], 180],
        ["Snake_random_F", [15.101, 23.272, 0], 260.791]
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
		_objectData set ["veh1", ["B_APC_Wheeled_01_cannon_F", "Secure NATO Vehicle", [5, 25]]];
		_objectData set ["veh2", ["B_Truck_01_ammo_F", "Secure NATO Vehicle", [5, 25]]];
		_objectData set ["veh3", ["B_Truck_01_box_F", "Secure NATO Vehicle", [5, 25]]];
		_objectData set ["veh4", ["B_MRAP_01_hmg_F", "Secure NATO Vehicle", [5, 25]]];

		private _basePosition = _campPos; // Assuming _campPos is defined elsewhere in your script.

		// Min and max number of objects to spawn
		private _minObjectsToSpawn = 1;
		private _maxObjectsToSpawn = 1;
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
					
					for "_j" from 1 to 20 do { // Attempt to find a suitable spawn position 20 times
						private _minDist = _spawnRadius select 0;
						private _maxDist = _spawnRadius select 1;
						private _distance = _minDist + random (_maxDist - _minDist);
						private _angle = random 360;
						private _tryPos = _basePosition getPos [_distance, _angle];
						
						// Check if the position is flat and empty enough for the vehicle
						if (count (_tryPos isFlatEmpty [2, -1, 0.3, 5, 0, false]) > 0) then {
							_finalPos = _tryPos;
							_found = true;
							break; // Position found, exit loop
						};
					};
					
					if (_found) then {
						private _obj = createVehicle [_classname, _finalPos, [], 0, "CAN_COLLIDE"];
						_obj setDir (random 360);
						
						if (_hasAction) then {
							// We need to store the action ID to remove it later.
							// The action ID is returned by addAction.
							private _actionId = _obj addAction [
								format ["<t color='#00ff00' size='1.2'>%1</t>", _actionText],
								{
									params ["_target", "_caller", "_actionId", "_arguments"]; // _arguments will contain actionText if passed
									
									private _actionText = _target getVariable ["actionText", "Item"]; // Still good for initial display/data
									_caller sideChat format ["Objective Complete: Vehicle Retrieved", _actionText];
									nul = [] execVM "missionCompleteScreen.sqf";
									
									//add xp/coins
									[100] execVM "addXP.sqf";
									[2] execVM "addCredits.sqf";

									//-1 side mission from fobSystems.sqf
									private _currentActiveMissions = missionNamespace getVariable ["activeSideMissions", 0];
									missionNamespace setVariable ["activeSideMissions", _currentActiveMissions - 1, true];
									
									// Remove the action using the stored actionId
									_target removeAction _actionId;
								},
								nil, // No arguments directly passed to the script for now, but we use the actionId
								101,
								true,
								true,
								"",
								"true"
							];
							
							// Store the action ID on the object, though we're now passing it directly in the script arguments.
							// This line can be removed if you only rely on the direct passing to the script.
							// However, keeping it makes the action ID easily retrievable if you need to remove it from elsewhere later.
							_obj setVariable ["actionId", _actionId, true]; 
							_obj setVariable ["actionText", _actionText, true]; // Still useful for the sideChat message
						};
					};
				};
			};
		};
		// === End Object Spawn System === //

		//==========End New Systems Here==========//

		_spawned = true;
		player sideChat "New Objective: Locate high-value asset";
		nul = [] execVM "missionBriefings\stolenVehicleBrief.sqf";
	};
};