//==========General Settings ==========//

private _markerNameText = "Fuel Depot";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 3; //Default 2
private _staticGroupSizeMax = 8; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 1; //Default 1
private _patrolSizeMax = 6; //Default 6
private _patrolGroupCountMin = 0; //Default 0
private _patrolGroupCountMax = 2; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.4; //Default 0.2
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
				["Land_Pallets_stack_F", [-0.49, 4.66, -0.001], 82.75],
				["Land_MetalBarrel_F", [-1.97, 4.93, 0.000], 262.16],
				["Land_MetalBarrel_F", [0.76, 5.28, 0.000], 262.16],
				["Land_BagFence_Round_F", [-3.76, -3.51, -0.001], 225],
				["Land_MetalBarrel_F", [-2.80, 4.70, 0.000], 110.48],
				["Land_BagFence_Long_F", [4.92, 3.03, -0.001], 90],
				["Land_BagFence_Long_F", [1.76, 6.39, -0.001], 180],
				["Land_HBarrier_5_F", [-4.62, 6.36, 0], 0],
				["Land_BagFence_Round_F", [4.51, 5.86, -0.001], 225],
				["Land_BagFence_Long_F", [-6.51, -2.98, -0.001], 180],
				["Land_BagFence_Long_F", [-3.35, -6.34, -0.001], 90],
				["Land_Basket_F", [-1.10, -8.21, 0.000], 179.98],
				["Land_Basket_F", [-0.21, -8.31, 0.000], 314.98],
				["Land_Sacks_goods_F", [-2.37, -8.31, 0], 65.94],
				["Land_CratesWooden_F", [-0.87, -9.47, 0], 180],
				["Land_BagFence_Long_F", [-3.37, -9.21, -0.001], 90],
				["Land_MetalBarrel_empty_F", [-8.74, 5.03, 0], 0],
				["Land_MetalBarrel_empty_F", [-9.24, 4.16, 0], 300],
				["Land_HBarrier_5_F", [-10.12, 6.36, 0], 0],
				["Land_MetalBarrel_empty_F", [-9.56, 4.98, 0], 120],
				["Land_Pallets_stack_F", [-10.49, 3.66, -0.000], 236.09],
				["Land_HBarrier_5_F", [-4.62, -11.14, 0], 0],
				["Land_Tank_rust_F", [-11.21, -2.39, 0], 270],
				["Land_MetalBarrel_F", [-8.94, -7.85, 0.000], 285.01],
				["Land_MetalBarrel_F", [-10.29, -7.10, 0.000], 179.96],
				["Land_MetalBarrel_F", [-8.74, -8.97, 0.000], 30.00],
				["Land_MetalBarrel_F", [-10.04, -8.07, 0.000], 194.99],
				["Land_MetalBarrel_F", [-9.47, -8.79, 0.000], 314.97],
				["Land_HBarrier_5_F", [-10.53, 6.21, 0], 135],
				["Land_MetalBarrel_F", [-8.80, -9.68, 0.000], 179.96],
				["Land_MetalBarrel_F", [-9.72, -9.51, 0.000], 134.97],
				["Land_HBarrier_5_F", [-10.12, -11.14, 0], 0],
				["Land_MetalBarrel_F", [-10.50, -8.85, 0.000], 285.01],
				["Land_PaperBox_open_full_F", [-11.37, -7.71, 0], 135],
				["Land_HBarrier_5_F", [-13.87, 2.61, 0], 90],
				["Land_HBarrier_5_F", [-13.87, -2.89, 0], 90],
				["Land_HBarrier_5_F", [-13.71, -7.80, 0], 45]
			],

			// Second emplacement
			[
				["Land_HBarrier_5_F", [3.39, -0.66, 0], 270],
				["MetalBarrel_burning_F", [-3.79, 0.02, 0.000], 90.00],
				["Land_BarrelSand_grey_F", [2.13, 3.84, 0.000], 269.99],
				["Land_BagFence_End_F", [-3.16, -2.93, -0.001], 30],
				["Snake_random_F", [2.97, -3.44, 0.008], 82.97],
				["Land_MetalBarrel_empty_F", [4.76, 1.59, 0], 255],
				["Land_MetalBarrel_empty_F", [4.56, 2.31, 0], 0],
				["CargoNet_01_barrels_F", [-2.74, 4.71, 0.000], 345.00],
				["Land_BagFence_Long_F", [-5.25, -2.40, -0.003], 0],
				["Land_MetalBarrel_F", [-4.49, 3.71, 0.000], 90.02],
				["Land_CanisterFuel_F", [-4.03, 4.25, 0.000], 164.91],
				["Land_CanisterFuel_F", [-4.14, 4.63, 0.000], 29.89],
				["Land_BagFence_Long_F", [-6.63, -1.04, -0.003], 270],
				["Land_MetalBarrel_F", [-4.24, 5.21, 0.000], 135.00],
				["Land_BagFence_End_F", [-6.83, 1.19, -0.000], 255],
				["Land_HBarrier_5_F", [9.01, -0.41, 0.002], 180],
				["Land_PaperBox_closed_F", [-5.51, 4.71, -0.000], 270],
				["Land_CanisterFuel_F", [0.01, 7.46, 0.000], 119.94],
				["Land_MetalBarrel_F", [1.01, 7.59, 0.000], 360.00],
				["Land_CanisterFuel_F", [0.24, 7.96, 0.000], 359.91],
				["Land_HBarrier_3_F", [-5.86, 6.44, 0], 0],
				["Land_CampingChair_V1_F", [7.94, 1.67, 0.011], 345.01],
				["Land_MetalBarrel_empty_F", [1.76, 8.34, 0], 210],
				["Land_CampingTable_F", [8.45, 1.24, 0.007], 356.43],
				["CamoNet_INDP_open_F", [8.48, 2.47, 0.001], 0],
				["Land_CampingChair_V1_F", [9.02, 2.45, -0.252], 180.05],
				["Land_Tank_rust_F", [-1.49, 9.25, 0], 180],
				["Land_CratesPlastic_F", [3.20, 10.39, -0.000], 270],
				["Land_Pallets_F", [4.27, 11.25, -0.004], 165],
				["Land_HBarrier_5_F", [-5.74, 7.84, 0], 270],
				["Land_HBarrier_5_F", [-4.62, 12.08, 0.006], 0],
				["Land_Tank_rust_F", [8.01, 9.37, 0.000], 180],
				["Land_HBarrier_5_F", [1.01, 12.09, -0.003], 0],
				["CargoNet_01_barrels_F", [10.51, 7.21, 0.000], 195.00],
				["Land_HBarrier_5_F", [6.63, 12.08, 0.000], 0],
				["Land_HBarrier_5_F", [12.38, 12.34, 0.003], 90],
				["Rabbit_F", [-9.07, 20.53, 0.002], 274.62],
				["Snake_random_F", [-34.83, -2.37, 0.008], 43.19]
			],

			// Third emplacement
			[
				["Land_MetalBarrel_F", [-0.68, -2.60, 0.000], 29.97],
				["Land_MetalBarrel_F", [-1.66, -2.35, 0.000], 210.03],
				["Land_CanisterFuel_F", [0.84, 2.79, 0.000], 239.95],
				["Land_CanisterFuel_F", [1.34, 2.65, 0.000], 299.98],
				["Land_MetalBarrel_F", [-0.43, 3.08, 0.000], 299.99],
				["Land_MetalBarrel_F", [-0.66, -3.35, 0], 105.00],
				["Land_MetalBarrel_F", [0.22, 3.72, 0.000], 209.98],
				["Land_MetalBarrel_F", [-1.37, -3.48, 0], 255.01],
				["Land_MetalBarrel_F", [1.34, 3.65, 0.000], 299.99],
				["Land_MetalBarrel_F", [0.23, 4.72, 0.000], 194.99],
				["Land_MetalBarrel_empty_F", [1.27, 4.98, 0], 60],
				["Land_MetalBarrel_empty_F", [2.14, 4.85, 0], 240],
				["Land_Tank_rust_F", [-5.66, 0.69, 0.000], 180],
				["Land_MetalBarrel_empty_F", [1.63, 5.72, 0], 300],
				["Land_MetalBarrel_F", [6.32, -0.60, 0.000], 30.00],
				["Land_MetalBarrel_F", [6.34, -1.35, 0.000], 105.01],
				["Land_Tank_rust_F", [-5.66, -3.31, 0.000], 180],
				["Land_Tank_rust_F", [-5.66, 4.69, 0], 180],
				["Land_PaperBox_closed_F", [-5.65, -5.34, 0.000], 75],
				["Land_Pallet_F", [-7.38, -6.09, 0.000], 105],
				["Snake_random_F", [-19.06, -12.28, 0.008], 247.73],
				["Rabbit_F", [44.45, 12.71, 0.002], 358.56]
			],

			// Fourth emplacement
			[
				["Land_Sacks_heap_F", [-1.64, -3.99, 0], 45],
				["Land_CratesShabby_F", [-3.02, -3.99, 0], 75],
				["Land_Wall_IndCnc_2deco_F", [-1.07, -4.89, 0], 135],
				["Land_MetalBarrel_F", [-0.95, 5.23, 0], 360.00],
				["Land_Pallet_F", [-5.82, -0.02, -0.000], 210],
				["Land_Sacks_goods_F", [-2.75, -5.12, 0], 105],
				["Land_MetalBarrel_F", [-1.45, 6.23, 0], 270.00],
				["Land_PaperBox_closed_F", [-4.46, -4.65, 0], 270],
				["Land_MetalBarrel_F", [-0.57, 6.73, 0], 255.01],
				["Land_MetalBarrel_F", [-2.32, 6.48, 0], 360.00],
				["Land_Wall_IndCnc_2deco_F", [-3.70, -6.02, 0], 180],
				["Land_Net_Fence_8m_F", [-4.06, 7.19, -0.003], 180],
				["Land_MetalBarrel_F", [-6.09, -4.45, 0.000], 30.00],
				["Land_MetalBarrel_F", [-6.15, -5.16, 0], 179.96],
				["Land_MetalBarrel_F", [-6.82, -4.27, 0], 315.01],
				["Land_Razorwire_F", [-3.55, 8.38, -0.001], 0],
				["Land_MetalBarrel_empty_F", [-7.95, 3.36, 0], 0],
				["Land_MetalBarrel_F", [-7.07, -4.99, 0], 134.97],
				["Land_MetalBarrel_empty_F", [-8.45, 2.48, 0], 300],
				["Land_Wall_IndCnc_2deco_F", [-6.70, -5.77, 0], 15],
				["Land_MetalBarrel_F", [7.66, -5.39, 0.000], 30.00],
				["Land_MetalBarrel_empty_F", [-8.76, 3.30, 0], 120],
				["Land_MetalBarrel_F", [7.68, -6.14, 0], 105.01],
				["Land_Razorwire_F", [4.45, 8.38, -0.008], 0],
				["Land_PaperBox_closed_F", [8.91, -5.27, 0], 285],
				["Land_Tank_rust_F", [-10.42, 0.31, 0], 270],
				["Land_Net_Fence_8m_F", [-4.09, -6.81, 0], 0],
				["Land_Net_Fence_8m_F", [3.94, 7.19, -0.018], 180],
				["Land_Net_FenceD_8m_F", [-12.06, 7.18, 0], 180],
				["Land_CanisterFuel_F", [10.05, -4.52, 0.000], 239.95],
				["Land_CanisterFuel_F", [10.55, -4.66, 0.000], 299.98],
				["Land_Razorwire_F", [-10.30, -7.87, -0.000], 0],
				["Land_Net_Fence_Gate_F", [11.92, 5.19, 0.013], 270],
				["Land_PaperBox_closed_F", [10.66, -5.77, 0], 270],
				["Land_Net_Fence_8m_F", [-12.08, -6.80, 0], 90],
				["Land_Net_Fence_8m_F", [-12.08, -0.80, 0], 90],
				["Land_Net_Fence_4m_F", [11.92, -2.83, 0], 270],
				["Land_Net_Fence_4m_F", [11.92, 3.20, -0.004], 90],
				["Land_Razorwire_F", [-12.63, -2.34, -0.000], 90],
				["Land_Razorwire_F", [-12.76, 5.79, -0.000], 90],
				["Snake_random_F", [-23.45, 6.06, 0.008], 321.14]
			],

			// Fifth emplacement
			[
				["Land_Shed_Big_F", [-0.93, -9.13, 0.018], 0],
				["Land_Pallet_F", [1.32, -4.93, 0.000], 120],
				["Land_Bricks_V2_F", [4.73, -3.93, 0], 0.00],
				["Land_Bricks_V4_F", [3.84, -5.06, -0.000], 45.00],
				["Land_Garbage_square5_F", [3.86, -6.11, -0.000], 0],
				["Land_Pallets_stack_F", [1.32, -7.18, 0.000], 60.00],
				["Land_Wall_Tin_4", [-7.42, 2.01, 0.001], 77.08],
				["Land_Tank_rust_F", [0.11, 7.89, -0.000], 270],
				["Land_Wall_Tin_4", [-8.29, -2.24, -0.001], 79.97],
				["Land_Tank_rust_F", [-4.89, 7.89, -0.000], 270],
				["Land_WorkStand_F", [6.28, -7.08, 0], 300],
				["Land_Tank_rust_F", [5.11, 7.89, -0.000], 270],
				["Land_Wall_Tin_4", [-7.92, 5.88, 0.006], 90],
				["Land_Wall_Tin_4", [-7.92, -6.12, 0.003], 90],
				["Land_WheelCart_F", [3.69, -10.05, 0.001], 315.01],
				["Land_WoodenBox_F", [-6.68, -9.69, 0.000], 348.70],
				["Land_Wall_Tin_4", [-1.94, 11.88, 0.003], 180],
				["Land_Wall_Tin_4", [2.06, 11.88, 0.003], 180],
				["Land_Garbage_square5_F", [-6.40, -10.53, -0.000], 90.00],
				["Land_Sacks_goods_F", [-5.79, -11.05, -0.000], 30],
				["Land_Wall_Tin_4", [-7.92, 9.88, 0.006], 90],
				["Land_Wall_Tin_4", [-7.92, -9.99, 0.003], 90],
				["Land_Sacks_heap_F", [-7.03, -11.00, 0.000], 90.00],
				["Land_Wall_Tin_4", [-5.94, 11.88, 0.002], 180],
				["Land_Wall_Tin_4", [-5.92, -11.97, -0.003], 0],
				["Snake_random_F", [9.95, 39.13, 0.008], 179.83]
			],

			// Sixth emplacement
			[
				["Land_Shed_Small_F", [-9.02, 6.35, -0.016], 90],
				["Land_CratesWooden_F", [5.91, 5.27, 0], 0],
				["Land_Pallets_F", [-9.28, 4.83, 0], 120],
				["Land_Sack_F", [-9.26, 5.35, -0.358], 180],
				["Land_Garbage_square5_F", [-9.81, 4.44, 0], 210],
				["Land_MetalBarrel_F", [9.71, 5.20, -0.000], 152.45],
				["Land_MetalBarrel_F", [10.11, 4.43, -0.000], 257.45],
				["Land_Pallets_stack_F", [-10.38, 5.17, 0.006], 89.94],
				["Land_Pallet_vertical_F", [10.04, 5.80, -0.000], 182.47],
				["Land_MetalBarrel_F", [10.77, 4.77, -0.000], 182.50],
				["Land_Pallet_vertical_F", [10.91, 5.51, -0.000], 167.48],
				["Land_Pallet_F", [15.16, -3.36, 0.000], 301.09],
				["Land_Tank_rust_F", [17.15, 1.65, 0.000], 270],
				["Land_Wall_IndCnc_4_F", [15.15, 6.13, -0.008], 0],
				["Land_CratesPlastic_F", [17.41, -1.74, -0.000], 48.54],
				["Land_CratesShabby_F", [18.54, -1.85, 0.000], 183.54],
				["Land_Wall_IndCnc_4_D_F", [19.35, -3.87, -0.006], 270],
				["Land_Wall_IndCnc_Pole_F", [19.34, 0.21, -0.000], 90],
				["Land_Wall_IndCnc_4_F", [19.28, 4.28, 0.000], 90]
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
		_objectData set ["truck1", ["C_Truck_02_fuel_F", "", [2, 20]]];
		_objectData set ["truck2", ["C_Van_01_fuel_F", "", [2, 20]]];
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
        "C_Van_01_fuel_F",
        "C_Truck_02_fuel_F"
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
                    player sideChat "Objective Complete: Fuel Truck(s) Disabled";
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

		player sideChat "New Objective: Disrupt enemy fuel supply";
		nul = [] execVM "missionBriefings\fuelDepotBrief.sqf";
		
	};
};