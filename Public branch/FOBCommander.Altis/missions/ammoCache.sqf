//==========General Settings ==========//

private _markerNameText = "Ammo Cache";
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
private _patrolGroupCountMax = 2; //Default 2

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
    [
        // First emplacement
        ["Land_CampingChair_V2_F",[-0.424805,4.41602,0],165.001],
        ["Land_WoodenTable_small_F",[-0.794922,5.20313,0],239.995],
        ["Land_Shovel_F",[-4.80176,3.33789,0.0252075],15.384],
        ["Land_Garbage_square5_F",[-3.66211,4.61719,0],97.7588],
        ["Land_CanisterPlastic_F",[-4.29297,4.21094,0],270.424],
        ["CamoNet_INDP_open_F",[-1.52637,6.82617,0],180],
        ["Land_Basket_F",[1.07227,6.58789,0],359.958],
        ["Land_Bucket_clean_F",[1.82227,6.71289,0],359.95],
        ["Land_Pipes_small_F",[2.80859,6.44727,0],155],
        ["Land_WoodenBox_F",[-4.25195,5.68359,0],130.201],
        ["Land_CratesWooden_F",[-6.05273,3.83789,0],90],
        ["Land_WaterTank_03_F",[-7.55371,2.34375,0],0],
        ["Land_CratesWooden_F",[1.94727,7.83789,0],0],
        ["Land_WoodenBox_F",[-4.6543,6.7168,0],300.31],
        ["Land_Pallets_F",[5.90625,4.97266,0],75],
        ["Land_WoodenCrate_01_stack_x5_F",[-7.67969,3.93359,0],0],
        ["Land_CratesShabby_F",[3.44629,7.95508,0],358.386],
        ["Land_Garbage_square5_F",[4.51367,7.79102,0],97.7588],
        ["Land_Garbage_square5_F",[-7.26074,6.1543,0],97.7588],
        ["Land_WoodenCrate_01_stack_x3_F",[1.5791,9.51758,0],90],
        ["Land_PaperBox_closed_F",[3.32031,9.47656,0],2.88207],
        ["Land_Sacks_heap_F",[5.82227,9.83789,0],27.137]
    ],
    [
        // Second emplacement
        ["Land_CratesShabby_F",[0.204102,2.99219,3.8147e-06],315],
        ["Land_WoodenCrate_01_F",[-3.55078,0.623047,-0.00100517],44.9993],
        ["Land_WoodenCrate_01_stack_x5_F",[-3.52051,2.62109,-3.43323e-05],270],
        ["Land_CratesWooden_F",[1.19922,4.49805,5.72205e-06],90.0001],
        ["Land_HBarrier_01_line_1_green_F",[-4.91895,1.00195,-1.52588e-05],240],
        ["CamoNet_INDP_open_F",[-0.524414,5.73633,-1.05174],180],
        ["Land_HBarrier_01_line_5_green_F",[4.45313,3.35352,2.28882e-05],270],
        ["Land_CargoBox_V1_F",[-0.478516,6.11328,0.0295544],255.417],
        ["Land_HBarrier_01_line_5_green_F",[-5.05469,3.89258,-1.52588e-05],90.0001],
        ["Land_Sacks_heap_F",[-6.55078,1.49805,0],15],
        ["Land_Garbage_square5_F",[-2.36719,6.44141,0.000310898],180],
        ["Land_WoodenCrate_01_stack_x3_F",[-6.66895,3.05273,-7.82013e-05],90.0001],
        ["Land_HBarrier_01_line_3_green_F",[3.57813,6.77148,-3.43323e-05],180],
        ["Land_HBarrier_01_line_3_green_F",[1.17578,7.75195,3.05176e-05],90.0001],
        ["Land_FieldToilet_F",[-0.831055,8.39453,1.33514e-05],84.2046],
        ["Land_Basket_F",[-6.55078,6.74805,5.72205e-06],254.969],
        ["Land_CanisterFuel_F",[-1.92578,9.37305,3.43323e-05],254.879],
        ["Land_PaperBox_open_full_F",[2.82422,9.23828,1.52588e-05],0],
        ["Land_CanisterFuel_F",[-2.17676,9.87305,2.86102e-05],134.897],
        ["Land_HBarrier_01_line_3_green_F",[0.195313,10.0996,3.8147e-05],2.73208e-05],
        ["Land_MetalBarrel_empty_F",[-2.17578,10.498,0],285],
        ["Land_MetalBarrel_F",[-0.924805,11.248,7.62939e-06],299.989],
        ["Land_Garbage_square5_F",[-4.85742,10.291,-0.000116348],30],
        ["Land_MetalBarrel_F",[-1.6748,11.248,7.62939e-06],119.989],
        ["Land_CampingChair_V2_F",[-5.12988,10.6602,5.72205e-06],179.988],
        ["Land_CampingChair_V2_F",[-6.16113,10.6777,0.000253677],120.02],
        ["Land_WoodenTable_large_F",[-5.43945,11.4844,0.0213871],101.761],
        ["Land_CampingChair_V2_F",[-4.74219,12.1094,3.8147e-06],359.994],
        ["Land_CampingChair_V2_F",[-5.77148,12.1289,0.00192451],14.9276]
    ],
    [
        // Third emplacement
        ["Land_WoodenCrate_01_stack_x5_F",[1.60547,3.31836,0],150],
        ["Land_CanisterFuel_F",[2.98535,2.38086,9.53674e-06],17.914],
        ["Land_CanisterFuel_F",[3.61914,2.41602,1.14441e-05],149.89],
        ["Land_Pallet_MilBoxes_F",[3.49316,3.64258,0],165],
        ["Land_MetalBarrel_empty_F",[4.61914,2.29102,0],285],
        ["CamoNet_INDP_open_F",[2.27051,6.1543,0],180],
        ["Land_GarbageHeap_03_F",[2.49219,8.53125,-7.62939e-06],0],
        ["Land_Garbage_square5_F",[6.90723,5.48828,0],0],
        ["Land_Garbage_square5_F",[-0.591797,8.83789,0],0],
        ["Land_PaperBox_closed_F",[0.608398,9.92383,0],315],
        ["Land_WoodenCrate_01_stack_x3_F",[7.26563,6.86523,0],240],
        ["Land_PaperBox_open_empty_F",[3.99414,9.79102,0],285],
        ["Land_Garbage_square5_F",[5.15723,9.73828,0],0],
        ["Land_GarbageHeap_02_F",[7.77734,7.87305,3.8147e-06],240],
        ["Land_WoodenCrate_01_stack_x3_F",[-20.2354,4.8418,-2.47955e-05],105],
        ["Land_BagFence_01_long_green_F",[-21.2402,6.54883,-0.000999451],90],
        ["Land_BagFence_01_long_green_F",[-22.2393,4.16016,-0.000999451],135],
        ["Snake_random_F",[-6.62598,22.1641,0.00838852],337.285],
        ["Land_BagFence_01_long_green_F",[-21.2402,9.29883,-0.000999451],90],
        ["Snake_random_F",[-34.7139,-2.91602,0.00838852],9.26597],
        ["Snake_random_F",[-37.7939,-9.01953,0.00839424],316.205],
        ["Rabbit_F",[28.3398,39.5605,0.00223732],119.77]
    ],
    [
        // Fourth emplacement
        ["CamoNet_INDP_F",[0.100586,4.12891,0],0],
        ["Box_Syndicate_Ammo_F",[-2.91602,3.80078,5.72205e-06],155.197],
        ["Box_Syndicate_WpsLaunch_F",[2.58398,4.05078,7.62939e-06],150],
        ["Box_Syndicate_WpsLaunch_F",[3.70898,3.42578,7.62939e-06],300.001],
        ["Land_PaperBox_closed_F",[-2.03223,5.04102,0],150],
        ["Land_PaperBox_open_empty_F",[2.08398,5.42578,0],0],
        ["Land_WoodenBox_F",[-3.76758,5.05273,7.62939e-06],45.0014],
        ["Land_PaperBox_open_full_F",[4.12109,5.32617,0],105],
        ["Snake_random_F",[20.9619,4.91406,0.00838852],75.9494],
        ["Snake_random_F",[27.3896,14.6426,0.00838852],93.4505]
    ],
    [
        // Fifth emplacement
        ["Box_Syndicate_Ammo_F",[-0.248047,2.6543,7.62939e-06],65.198],
        ["Land_PaperBox_open_empty_F",[0.894531,3.52148,0],0],
        ["Land_PaperBox_closed_F",[-0.829102,4.50293,0],210],
        ["Box_Syndicate_Ammo_F",[0.751953,5.2793,7.62939e-06],5.19588],
        ["Snake_random_F",[-4.70801,2.89844,0.00839233],3.87531],
        ["CamoNet_INDP_open_F",[2.97559,5.54102,0],0],
        ["Land_WoodenBox_F",[4.39941,7.78223,9.53674e-06],45.0008],
        ["Box_Syndicate_WpsLaunch_F",[5.87695,6.7793,9.53674e-06],150],
        ["Box_Syndicate_WpsLaunch_F",[7.00195,6.1543,7.62939e-06],300],
        ["Land_CargoBox_V1_F",[5.37598,8.90332,0.0309868],120.002],
        ["Land_PaperBox_closed_F",[7.25879,8.23438,0],150],
        ["Snake_random_F",[-5.52246,-30.6865,0.0083828],208.367],
        ["Rabbit_F",[14.8145,46.4395,0],138.297]
    ],
    [
        // Sixth emplacement
        ["Land_CratesShabby_F",[4.28418,5.67773,1.71661e-05],60.0111],
        ["Land_HBarrier_3_F",[3.67188,6.55859,-0.000581741],210],
        ["Land_CratesShabby_F",[4.91992,6.41113,-5.72205e-06],150.011],
        ["Land_HBarrier_1_F",[0.958008,8.10449,5.72205e-06],330],
        ["Land_BarrelTrash_grey_F",[3.99609,7.84668,-7.62939e-06],60.02],
        ["Land_CncBarrier_F",[8.54102,3.68848,1.90735e-06],165],
        ["Land_Pallet_MilBoxes_F",[3.07031,8.90137,-1.90735e-05],225],
        ["Land_Camping_Light_off_F",[2.35156,10.71,0.119114],0.0838145],
        ["Land_Sleeping_bag_folded_F",[2.07031,11.0059,0.113827],104.899],
        ["CamoNet_OPFOR_open_F",[6.13965,8.81738,0.000684738],0],
        ["Land_Sleeping_bag_blue_folded_F",[1.79102,11.1797,-9.53674e-06],89.9984],
        ["Land_Pillow_camouflage_F",[2.46094,11.0596,-1.33514e-05],359.982],
        ["Land_HBarrier_5_F",[0.105469,9.22559,0.00298691],270],
        ["Land_Ground_sheet_folded_OPFOR_F",[2.19141,11.4502,1.52588e-05],149.905],
        ["Land_PaperBox_open_empty_F",[3.04395,12.4922,1.90735e-06],90.0001],
        ["Land_WheelCart_F",[6.03418,11.6797,0.000802994],254.955],
        ["Land_Pallets_stack_F",[11.3242,7.37988,7.62939e-06],105.17],
        ["Land_Sacks_heap_F",[4.93457,12.7178,3.8147e-06],60.0001],
        ["Land_Sacks_goods_F",[10.792,8.94238,-1.14441e-05],0.0110102],
        ["Land_Sacks_heap_F",[6.05078,12.7852,1.90735e-06],180],
        ["Land_CncBarrier_F",[13.2861,6.43555,2.47955e-05],120],
        ["Land_Garbage_square5_F",[9.14258,12.0371,-0.00097084],0],
        ["Land_Timbers_F",[-0.291016,16.0576,0.0173969],0],
        ["Land_MetalBarrel_F",[6.94238,14.7451,2.86102e-05],269.976],
        ["Land_MetalBarrel_F",[6.78418,15.5195,2.86102e-05],14.9698],
        ["Land_HBarrier_5_F",[0.327148,14.708,0.00298882],270],
        ["Land_Cargo_House_V3_F",[5.0625,16.4297,0.00391006],270],
        ["Land_CncBarrier_F",[13.2842,12.1758,7.43866e-05],45.0004],
        ["Land_CncBarrier_F",[11.2051,16.3223,6.48499e-05],75.001],
        ["Land_HBarrier_5_F",[0.542969,20.4258,0.00905609],2.7321e-05],
        ["Land_Pallets_F",[5.75098,20.4404,0.00412178],75.0122],
        ["Land_WoodPile_large_F",[3.59082,21.75,0.0306168],270.001],
        ["Land_CncBarrier_F",[10.8457,20.4678,5.53131e-05],90.0016],
        ["Snake_random_F",[33.292,29.4951,0],29.665]
    ],
    [
        // Seventh emplacement
        ["Land_Garbage_square5_F",[-2.38281,-1.54199,0.000295639],0],
        ["Land_MetalBarrel_F",[-3.17188,-1.36426,3.8147e-06],269.973],
        ["Land_Sacks_heap_F",[-4.1709,-0.863281,0],315],
        ["Land_MetalBarrel_F",[-4.92188,0.135742,1.90735e-06],209.99],
        ["Land_Sacks_heap_F",[-4.58984,-2.36133,0],345],
        ["Land_Pallets_stack_F",[-2.92188,4.63574,-1.52588e-05],105.012],
        ["Land_PaperBox_open_empty_F",[-6.1709,-0.363281,0],90],
        ["Land_Sacks_goods_F",[-6.91016,-2.37012,0],120.011],
        ["Land_cargo_addon02_V2_F",[-5.84668,-4.46875,0],270],
        ["Land_Pallets_F",[-5.21191,-6.85352,0],75.011],
        ["Land_BarrelTrash_grey_F",[-7.4209,-3.61328,7.62939e-06],60.0114],
        ["Land_Pallet_MilBoxes_F",[-6.00391,-6.01563,0],225],
        ["Land_HBarrier_5_F",[-8.98145,5.34668,-0.00299072],2.73208e-05],
        ["Land_CratesShabby_F",[-7.66992,-4.60547,0],180.011],
        ["Land_HBarrier_5_F",[-8.76074,-0.379883,0],270],
        ["Land_Cargo_Patrol_V1_F",[-8.66797,1.38965,-0.000267029],90],
        ["Land_CratesShabby_F",[-7.67188,-5.12109,0],0.0110103],
        ["Land_HBarrier_5_F",[-8.7666,-5.86816,0],270],
        ["Land_HBarrier_3_F",[-5.85254,-8.52051,0],210],
        ["Land_HBarrier_1_F",[-8.56641,-6.97461,0],330],
        ["Snake_random_F",[-6.83691,-20.2656,0.00839233],259.719],
        ["Snake_random_F",[3.81641,29.748,0],209.492]
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
		_objectData set ["cache", ["Box_FIA_Wps_F", "", [3, 20]]];
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
						private _obj = createVehicle [_classname, _finalPos, [], 0, "NONE"]; // Changed "CAN_COLLIDE" to "NONE"
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

		if (_spawned) then {
			// objects to watch
			_watchClasses = [
				"Box_FIA_Wps_F"
			];
			
			_objectsToWatch = [];
			{
				_found = nearestObjects [_campPos, [_x], 50];
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
							player sideChat "Objective Complete: Ammo Cache(s) Destroyed";
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
		
		player sideChat "New Objective: Detonate enemy ammunition stockpiles";
		nul = [] execVM "missionBriefings\ammoCacheBrief.sqf";
		
		
	};
};