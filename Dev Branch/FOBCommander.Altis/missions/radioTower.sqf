//==========General Settings ==========//

private _markerNameText = "Radio Tower";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 2; //Default 2
private _staticGroupSizeMax = 6; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 1; //Default 1
private _patrolSizeMax = 6; //Default 6
private _patrolGroupCountMin = 0; //Default 0
private _patrolGroupCountMax = 1; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.1; //Default 0.2
private _staticWeaponChance = 0.4; //Default 0.3

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
        ["Land_BagFence_Long_F", [-1.49707, 0.703125, -0.000999451], 180],
        ["Land_BagFence_Long_F", [-0.0263672, 2.40039, 0.273842], 90],
        ["Land_JunkPile_F", [0.970703, 2.66797, 0], 300],
        ["Land_BagFence_Short_F", [0.120117, 4.33398, -0.000999451], 285],
        ["Land_HBarrier_1_F", [0.242188, 5.7168, 0], 75],
        ["Land_Bucket_painted_F", [-4.87598, 3.09375, 0], 0.0114281],
        ["Land_BagFence_Long_F", [-6.50488, 0.859375, -0.000999451], 0],
        ["Land_PaperBox_closed_F", [-5.50391, 4.10547, 0], 0],
        ["Land_Cargo_House_V3_F", [-4.37598, 6.32227, 0], 0],
        ["Land_Garbage_square5_F", [-6.96289, 3.66602, 0], 0],
        ["Land_BagFence_Short_F", [-8.74023, 0.841797, -0.000999451], 180],
        ["Land_HBarrier_5_F", [0.12793, 6.7207, 0], 270],
        ["Land_BagFence_Long_F", [-9.48535, 2.22266, -0.000999451], 90],
        ["Land_BagFence_Short_F", [-9.50195, 4.58398, -0.000999451], 270],
        ["Land_HBarrier_1_F", [-9.49902, 5.35156, 0], 195],
        ["Land_HBarrier_5_F", [-5.5, 10.9648, 0], 0],
        ["Land_PowerGenerator_F", [-9.25098, 8.82813, 0], 180],
        ["Land_HBarrier_5_F", [-10.7549, 9.7168, 0], 90],
        ["Land_HBarrier_5_F", [-11, 10.9648, 0], 0],
        ["Land_Communication_F", [-7.38867, 8.98438, 0], 0],
        ["Snake_random_F", [42.3691, 19.6289, 0.00838852], 125.463],
        ["Snake_random_F", [-42.875, 22.1152, 0.00841904], 256.363]
    ],
    // Second emplacement
    [
        ["Land_TBox_F", [2.27148, 3.62695, 0], 90],
        ["Land_GarbagePallet_F", [-4.57031, 1.06055, 0], 0],
        ["Land_Metal_Shed_F", [-1.2168, 3.47656, 0], 0],
        ["Land_Garbage_square5_F", [-1.30762, 5.79492, 0], 0],
        ["Land_Pallet_vertical_F", [1.4707, 5.7832, 0.00432396], 0.622072],
        ["Land_GarbageBags_F", [3.98926, 3.45703, 0.000572205], 0],
        ["Land_CratesShabby_F", [-3.47852, 5.22461, 0], 90],
        ["Land_GarbageBags_F", [3.69336, 6.95117, -0.00118828], 150],
        ["Land_FoodContainer_01_F", [-3.0957, 7.97266, 9.53674e-06], 60.0016],
        ["Land_Cages_F", [-7.0957, 4.84766, 0], 270],
        ["Land_Tyre_F", [-6.36816, 6.12109, -0.00429344], 0.00493928],
        ["Land_TTowerSmall_2_F", [3.66406, -0.285156, -6.29425e-05], 0],
        ["Land_CampingTable_small_F", [-3.58398, 8.47656, 0.00261307], 29.9998],
        ["Land_Ammobox_rounds_F", [-3.9707, 8.59766, -0.000156403], 14.9985],
        ["Land_CampingChair_V1_F", [-3.3457, 9.09766, 0.00309944], 359.996],
        ["Snake_random_F", [-22.4678, 3.15039, 0.00838852], 87.011],
        ["Snake_random_F", [12.1387, 33.7012, 0.00838661], 280.295]
    ],
    // Third emplacement
    [
        ["Land_MetalBarrel_F", [1.62793, 1.71875, -9.53674e-06], 129.013],
        ["Land_PowerGenerator_F", [0.749023, 2.20313, 0], 194.305],
        ["Land_MetalBarrel_F", [2.00293, 2.36719, -9.53674e-06], 330.001],
        ["Land_BagFence_Round_F", [-2.05078, 2.9375, -0.00130081], 270],
        ["Land_BagFence_Long_F", [0.25293, 3.95313, -0.000999451], 194],
        ["Land_BagFence_Long_F", [4.14355, 1.46875, -0.000999451], 104],
        ["Land_BagFence_Long_F", [3.12793, 3.35938, -0.000999451], 14],
        ["Land_PaperBox_open_full_F", [-1.50391, -4.41211, 0], 45],
        ["Land_BagFence_Round_F", [-3.60938, 4.72852, -0.00130081], 180.265],
        ["Land_BagFence_Round_F", [-5.36328, 3.07813, -0.00130081], 89.65],
        ["Land_Razorwire_F", [5.61426, -0.367188, -1.90735e-06], 276.523],
        ["Land_BagFence_Long_F", [-4.50098, -4.76563, -0.000999451], 359],
        ["Land_Razorwire_F", [3.7832, 6.0918, -1.90735e-06], 194.657],
        ["Land_BagFence_Long_F", [-7.8877, -2.16016, -0.000999451], 269],
        ["Land_BagFence_Round_F", [-7.18359, -4.66992, -0.00130081], 29.65],
        ["Land_Razorwire_F", [-3.81152, 6.86133, -1.90735e-06], 164.657],
        ["Land_TTowerSmall_2_F", [-3.63184, 3.12305, 0], 180],
        ["Land_Razorwire_F", [-6.97656, -8.72461, -1.90735e-06], 359.657],
        ["Land_Razorwire_F", [-10.1787, -6.38477, -1.90735e-06], 269.657]
    ],
    // Fourth emplacement
    [
        ["Land_GarbagePallet_F", [2.61426, -0.964844, -0.000802994], 225],
        ["Land_Net_Fence_pole_F", [-3.15234, 0.697266, 0], 225],
        ["Land_Pipes_small_F", [0.208984, -3.31836, 9.53674e-06], 359.999],
        ["Land_Net_Fence_4m_F", [-3.14648, -1.70508, 0], 240],
        ["Land_Pallet_vertical_F", [-1.77637, 4.44531, 3.8147e-06], 90.0016],
        ["Land_Net_Fence_4m_F", [-1.14063, -5.17773, 0], 180],
        ["Land_Garbage_square5_F", [4.76074, 3.14453, 0.000295639], 0],
        ["Land_Net_Fence_pole_F", [-3.15234, 4.82227, 1.90735e-06], 105],
        ["Land_spp_Transformer_F", [-0.447266, 5.81445, -0.000480652], 180],
        ["Snake_random_F", [-3.29492, -6.05469, 0.00838852], 236.979],
        ["Land_Net_FenceD_8m_F", [-3.14551, 2.7168, -0.0195313], 90],
        ["Land_Net_Fence_8m_F", [2.8623, -5.17578, -0.0124092], 180],
        ["Land_Net_Fence_4m_F", [-3.14063, 10.6973, 0], 180],
        ["Land_IronPipes_F", [8.98633, 6.72656, 0], 255],
        ["Land_Net_FenceD_8m_F", [10.8545, -5.16016, -0.00749397], 90],
        ["Land_Net_Fence_pole_F", [10.8486, -3.17578, 0], 225],
        ["Land_Net_Fence_Gate_F", [8.84766, 10.8223, 0.00488091], 0],
        ["Land_Net_Fence_8m_F", [10.8486, 2.83789, -0.0150681], 90],
        ["Land_Net_Fence_4m_F", [10.8369, 10.8242, 0.0106087], 0],
        ["Land_TTowerBig_2_F", [7.1084, -1.16211, 0.000614166], 0],
        ["Rabbit_F", [8.47852, 24.5547, 0.00223732], 307.241]
    ],
    // Fifth emplacement
    [
        ["Land_Garbage_square5_F", [3.5625, 0.344727, 0.000112534], 45],
        ["Land_GarbagePallet_F", [0.68457, 4.0459, 0], 225],
        ["Land_Garbage_square5_F", [-1.44238, 4.16113, 0], 75],
        ["Land_Garbage_square5_F", [0.0195313, 4.5127, 0], 225],
        ["Land_BarrelTrash_grey_F", [2.85352, 3.55371, -7.62939e-06], 359.991],
        ["Land_MetalBarrel_F", [3.60254, 3.80371, 0.000144958], 29.9891],
        ["Land_MetalBarrel_F", [3.10352, 4.42871, -7.62939e-06], 269.994],
        ["Land_BagFence_Long_F", [-0.275391, -5.55566, -0.000999451], 0],
        ["Land_BagFence_Long_F", [-5.78711, -0.0751953, 0.00199318], 270],
        ["Land_BagFence_Long_F", [1.97461, -5.55566, -0.000999451], 0],
        ["Land_BagFence_Long_F", [-2.40039, -5.55566, -0.000999451], 0],
        ["Land_BagFence_End_F", [-6.02051, 2.22852, -0.00179672], 255],
        ["Land_BagFence_Long_F", [-5.73633, -2.96289, -0.000999451], 90],
        ["Land_BagFence_Long_F", [4.23242, -5.58691, 0.000469208], 180],
        ["Land_BagFence_Round_F", [-5.08496, -5.45801, -0.00130081], 30],
        ["Land_BagFence_End_F", [-6.31543, 4.89063, -0.00129509], 105],
        ["Land_Garbage_square5_F", [4.20117, 7.84473, 0.000160217], 75.0001],
        ["Land_BagFence_Long_F", [7.10742, -5.58691, 0.00102615], 180],
        ["Land_BagFence_Long_F", [-6.00586, 7.05762, 0.00135612], 90],
        ["Land_BagFence_End_F", [10.0225, 0.0917969, -0.00069809], 285],
        ["Land_BagFence_Long_F", [9.71289, -2.0752, -0.00101852], 270],
        ["Land_BagFence_Round_F", [9.61523, -4.88379, -0.00188255], 300],
        ["Land_BagFence_End_F", [10.1025, 2.75293, -0.000762939], 75],
        ["Land_BagFence_Long_F", [9.86914, 5.05762, -0.000974655], 90],
        ["Land_BagFence_Round_F", [-5.9082, 9.86621, -0.00244904], 120],
        ["Land_BagFence_Long_F", [9.81836, 7.94531, -0.00366783], 270],
        ["Land_BagFence_Long_F", [-4.66211, 12.0498, 0.000967026], 270],
        ["Snake_random_F", [-9.2959, -9.06055, 0.00838852], 156.258],
        ["Land_MetalBarrel_F", [3.97754, 12.4277, -1.90735e-06], 60.0059],
        ["Land_BagFence_Round_F", [9.47754, 10.1328, -0.000793457], 225],
        ["Land_Garbage_square5_F", [2.08594, 13.6523, 0.000375748], 75.0001],
        ["Land_BagFence_Long_F", [8.33789, 11.7998, -0.00303841], 270],
        ["Land_CratesWooden_F", [4.35352, 13.8037, 1.90735e-06], 210],
        ["CamoNet_INDP_F", [2.2041, 15.0049, 0.000322342], 0],
        ["Land_BagFence_Long_F", [-4.66211, 14.9248, -0.00447083], 270],
        ["Land_GarbagePallet_F", [1.25293, 16.1426, 0.000133514], 0],
        ["Land_PaperBox_closed_F", [-0.648438, 16.1914, -3.8147e-06], 0],
        ["Land_BagFence_Long_F", [8.33789, 14.5498, -0.0030365], 270],
        ["Land_BagFence_Long_F", [-1.02539, 17.4443, -0.00503159], 0],
        ["Land_BagFence_Long_F", [1.09961, 17.4443, -0.00795174], 0],
        ["Land_BagFence_Round_F", [-3.9043, 17.3477, 0.00147057], 150],
        ["Land_BagFence_Long_F", [3.34961, 17.4443, -0.00528717], 0],
        ["Land_BagFence_Long_F", [5.60742, 17.4131, 0.00100327], 180],
        ["Land_BagFence_Round_F", [7.97754, 17.0078, -0.000799179], 225],
        ["Land_TTowerBig_1_F", [2.10352, 2.68848, 0], 0],
        ["Rabbit_F", [-30.8545, -2.08496, 0.0026989], 284.84]
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

		//==========End New Systems Here==========//

		_spawned = true;
		
		//=== Start Object Destruction Check System ===//	
		if (_spawned) then {

			// What to look for
			_watchClasses = [
				"Land_Communication_F",
				"Land_TTowerSmall_2_F", 
				"Land_TTowerBig_2_F",
				"Land_TTowerBig_1_F"
			];
			
			_objectsToWatch = [];
			{
				_found = nearestObjects [_campPos, [_x], 300];
				_objectsToWatch = _objectsToWatch + _found;
			} forEach _watchClasses;
			
			if (count _objectsToWatch > 0) then {
				
				[_objectsToWatch] spawn {
					params ["_objectsToWatch"];
					while {true} do {
						_stillAlive = _objectsToWatch select {alive _x};
						
						if (count _stillAlive == 0) then {
							player sideChat "Objective Complete: Tower Disabled";
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
		//=== End Object Destruction Check System ===//
		
		player sideChat "New Objective: Sabotage enemy radio capabilities";
		nul = [] execVM "missionBriefings\radioTowerBrief.sqf";
		
	};
};