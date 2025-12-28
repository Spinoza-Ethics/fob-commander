//==========General Settings ==========//

private _markerNameText = "F.O.B.";
private _markerType = "o_Ordnance";


//Static Groups
private _staticGroupSizeMin = 4; //Default 2
private _staticGroupSizeMax = 8; //Default 8
private _staticGroupCountMin = 2; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 3; //Default 1
private _patrolSizeMax = 6; //Default 6
private _patrolGroupCountMin = 2; //Default 0
private _patrolGroupCountMax = 2; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.8; //Default 0.2
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
//edit with caution, easily breaks location finding
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
_maxAttempts = 300;

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
        ["Land_Sacks_heap_F", [2.54, -1.63, 0], 269.51],
        ["Land_BagFence_Long_F", [3.84, -2.14, 0], 90.66],
        ["Land_BarrelTrash_grey_F", [3.13, -3.11, 0], 359.998],
        ["MapBoard_stratis_F", [-5.05, -1.84, 0], 58.75],
        ["Land_CncShelter_F", [5.31, -1.24, 0], 0],
        ["Land_Garbage_square5_F", [-3.73, -4.72, 0], 243.48],
        ["Land_CncShelter_F", [5.31, -2.88, 0], 0],
        ["Land_BagFence_Long_F", [3.82, -5.12, 0], 90.66],
        ["Land_CncShelter_F", [5.24, -4.51, 0], 0],
        ["Land_BagFence_Long_F", [6.74, -2.07, 0], 88.64],
        ["Land_Garbage_square5_F", [5.45, 4.44, 0], 243.48],
        ["Land_CncShelter_F", [5.25, -6.15, 0], 0],
        ["Land_BagFence_Long_F", [6.74, -4.92, 0], 90.66],
        ["Land_TentA_F", [-9.63, -3.55, 0], 282.40],
        ["Land_GarbageBags_F", [9.04, -2.54, 0], 54.96],
        ["CamoNet_INDP_F", [9.91, -3.05, 0.12], 265.69],
        ["Land_WaterBarrel_F", [-9.21, 6.63, 0], 110.46],
        ["Land_PaperBox_closed_F", [0.23, -11.43, 0], 261.09],
        ["Land_Cargo_House_V3_F", [-11.97, 3.25, 0], 301.01],
        ["Land_PaperBox_closed_F", [-1.65, -11.41, 0], 277.18],
        ["Land_BagFence_Round_F", [-8.23, 8.51, 0], 45],
        ["Land_GarbageBags_F", [12.78, -0.60, 0], 259.05],
        ["Land_MetalBarrel_F", [9.64, -6.89, 0], 218.13],
        ["Land_TentA_F", [-10.13, -6.67, 0], 267.40],
        ["Land_BagFence_Round_F", [-6.03, 10.62, 0], 225],
        ["Land_PaperBox_open_empty_F", [-3.89, -12.10, 0], 302.54],
        ["Land_BagFence_Long_F", [1.05, -12.68, 0], 0],
        ["Land_JunkPile_F", [11.85, 4.98, 0], 229.05],
        ["Land_BagFence_Round_F", [-8.18, 10.67, 0], 135],
        ["Land_Pallets_F", [-9.64, 7.86, 0], 244.71],
        ["Land_GarbageBags_F", [13.00, -5.56, 0], 259.05],
        ["Land_BagFence_Round_F", [-1.65, -13.07, 0], 135],
        ["Land_FieldToilet_F", [3.25, 13.26, 0], 86.85],
        ["Land_PortableLight_double_F", [-9.97, 9.63, 0], 99.06],
        ["Land_Razorwire_F", [-13.00, -2.62, 0], 100.71],
        ["B_HMG_01_high_F", [-5.38, -14.05, -0.09], 180],
        ["Land_HBarrier_Big_F", [15.33, 0.47, 0], 270],
        ["Land_Wreck_Car_F", [-9.54, -12.21, 0], 165],
        ["Land_BagFence_Round_F", [-2.62, -15.56, 0], 315],
        ["Land_HBarrierTower_F", [8.12, 13.35, 0], 176.32],
        ["Land_CratesShabby_F", [-7.76, -13.80, 0], 163.39],
        ["Land_FieldToilet_F", [2.94, 15.54, 0], 70.07],
        ["Land_HBarrier_5_F", [15.08, 4.96, 0], 255],
        ["Land_HBarrier_3_F", [12.07, 11.40, 0], 45],
        ["Land_BagFence_Long_F", [-5.26, -15.91, 0], 0],
        ["Land_Razorwire_F", [17.12, 2.13, 0], 90],
        ["Land_BagFence_Round_F", [-7.88, -15.51, 0], 45],
        ["Land_Razorwire_F", [-13.27, -10.40, 0], 70.71],
        ["Land_HBarrier_Big_F", [15.44, -8.11, 0], 88.95],
        ["Land_MetalBarrel_F", [13.06, -12.33, 0], 304.93],
        ["Land_Razorwire_F", [15.54, 10.46, 0], 75],
        ["Land_MetalBarrel_F", [12.73, -13.10, 0], 349.93],
        ["Land_MetalBarrel_F", [13.74, -13.08, 0], 214.93],
        ["Land_CampingChair_V1_F", [10.19, -16.16, 0], 279.92],
        ["Land_CampingChair_V1_F", [12.05, -14.87, 0], 40.11],
        ["Land_CampingTable_F", [11.07, -16.31, 0], 235.51],
        ["Land_CampingTable_F", [11.79, -15.81, 0], 55.12],
        ["Land_Razorwire_F", [18.14, -6.63, 0], 88.95],
        ["Land_PortableLight_double_F", [5.95, -19.43, 0], 161.38],
        ["Land_CampingChair_V1_F", [10.64, -17.22, 0], 10.11],
        ["Land_GarbagePallet_F", [14.00, 15.01, 0], 15],
        ["Land_CampingChair_V1_F", [12.76, -15.90, 0], 85.09],
        ["Land_HBarrier_5_F", [15.69, -12.71, 0], 103.95],
        ["Land_HBarrier_5_F", [7.73, -19.41, 0], 358.95],
        ["Land_Razorwire_F", [9.81, -20.83, 0], 178.95],
        ["Land_HBarrier_3_F", [14.35, -17.61, 0], 133.95],
        ["Land_Razorwire_F", [17.60, -14.71, 0], 103.95],
        ["Land_Razorwire_F", [14.06, -21.00, 0], 178.95],
        ["Rabbit_F", [27.58, 12.72, 0], 97.83],
        ["Rabbit_F", [-9.88, 41.97, 0], 0.48],
        ["Rabbit_F", [-46.10, 14.98, 0], 195.91]
    ],

    // Second emplacement
    [
        ["Land_BagFence_Long_F", [2.55, -3.04, 0], 90.66],
        ["Land_CncShelter_F", [4.02, -2.14, 0], 0],
        ["Land_CncShelter_F", [4.02, -3.78, 0], 0],
        ["Land_BagFence_Long_F", [5.45, -2.97, 0], 88.64],
        ["Land_Cargo10_grey_F", [-6.09, 1.48, 0], 240],
        ["Land_BagFence_Long_F", [2.53, -6.02, 0], 90.66],
        ["Land_CncShelter_F", [3.95, -5.41, 0], 0],
        ["Land_Sacks_heap_F", [6.77, -3.43, 0], 282.54],
        ["Land_Pallet_vertical_F", [-2.86, 7.14, 0], 23.69],
        ["Land_BagFence_Long_F", [5.45, -5.82, 0], 90.66],
        ["Land_CncShelter_F", [3.96, -7.05, 0], 0],
        ["Land_PaperBox_closed_F", [6.64, -5.00, 0], 106.82],
        ["Land_CratesWooden_F", [-2.36, 8.14, 0], 23.70],
        ["Land_Pipes_small_F", [-6.83, -6.07, 0.26], 279.03],
        ["Land_MetalBarrel_F", [-4.10, 8.62, 0], 45.39],
        ["Land_Pallets_stack_F", [-9.09, 3.98, 0], 165],
        ["Land_MetalBarrel_F", [-4.63, 9.15, 0], 255.36],
        ["Land_Pallets_stack_F", [-8.92, 5.84, 0], 255.00],
        ["Land_Cargo20_white_F", [-2.34, 10.73, 0], 210],
        ["Land_HBarrier_Big_F", [-11.01, 4.44, 0], 270],
        ["Land_Pallet_F", [-11.02, -6.43, 0], 266.81],
        ["Land_PaperBox_open_empty_F", [-4.59, -12.52, 0], 315],
        ["Land_Pipes_small_F", [-7.61, -11.17, 0], 300.00],
        ["Land_HBarrier_Big_F", [-8.56, 11.14, 0], 315],
        ["Land_Pallets_F", [-9.08, -9.86, 0], 165],
        ["Land_PaperBox_closed_F", [-3.59, -13.76, 0], 45],
        ["Land_Cargo10_blue_F", [-2.09, 14.23, 0], 195],
        ["Land_PaperBox_closed_F", [-5.86, -14.27, 0], 300],
        ["Land_MetalBarrel_F", [14.12, -7.44, 0], 85.56],
        ["Land_GarbageBarrel_01_F", [15.95, -0.81, 0], 284.40],
        ["Land_HBarrierTower_F", [-15.75, -3.90, 0], 90.30],
        ["Land_MetalBarrel_F", [15.53, -5.87, 0], 339.51],
        ["Land_HBarrier_Big_F", [-11.43, -12.24, 0], 90],
        ["Land_JunkPile_F", [17.03, 0.51, 0], 260.40],
        ["Land_Garbage_square5_F", [17.06, 0.40, 0], 260.40],
        ["Land_Sleeping_bag_brown_F", [16.78, 5.25, 0], 135.53],
        ["CamoNet_BLUFOR_open_F", [17.04, 2.88, 0], 90],
        ["Land_CampingChair_V1_F", [0.83, -18.05, 0], 315.01],
        ["Land_CanisterPlastic_F", [17.69, 3.97, 0], 69.86],
        ["Land_PainKillers_F", [17.42, 5.60, 0], 5.04],
        ["Land_Canteen_F", [17.55, 5.34, 0], 43.27],
        ["Land_CanisterPlastic_F", [18.44, 4.10, 0], 204.85],
        ["Land_Garbage_square5_F", [0.02, -18.98, 0], 198.82],
        ["Land_PaperBox_closed_F", [5.14, 18.22, 0], 270],
        ["WaterPump_01_forest_F", [-6.01, -18.12, 0], 125.87],
        ["Land_Sleeping_bag_F", [18.61, 7.62, 0], 91.11],
        ["Land_CampingChair_V1_F", [4.92, -18.98, 0], 74.99],
        ["Land_Ammobox_rounds_F", [18.51, 6.55, 0], 80.32],
        ["StorageBladder_02_water_forest_F", [17.66, -9.03, 0], 0],
        ["Campfire_burning_F", [2.58, -19.80, 0.03], 311.91],
        ["Land_Ammobox_rounds_F", [18.90, 6.51, 0], 36.75],
        ["Land_Canteen_F", [18.84, 6.87, 0], 73.48],
        ["Land_CampingChair_V1_F", [-0.30, -20.17, 0], 285.00],
        ["Land_DuctTape_F", [19.16, 6.83, 0], 33.56],
        ["Land_Camping_Light_F", [18.71, 8.58, 0], 27.40],
        ["Land_PaperBox_open_empty_F", [5.10, 19.97, 0], 180],
        ["Land_HBarrier_Big_F", [-9.25, -19.26, 0], 240],
        ["CamoNet_BLUFOR_open_F", [18.26, -12.87, 0], 265],
        ["Land_HBarrier_Big_F", [22.57, -1.74, 0], 90],
        ["Land_Cargo_House_V3_F", [12.05, 20.63, 0], 0],
        ["Land_HBarrier_Big_F", [7.24, 21.94, 0], 270],
        ["Land_HBarrier_Big_F", [22.32, 6.51, 0], 90],
        ["Land_HBarrier_Big_F", [-3.54, -23.45, 0], 195],
        ["StorageBladder_02_water_forest_F", [17.66, -17.03, 0], 0],
        ["Land_HBarrier_Big_F", [4.44, -24.19, 0], 180],
        ["Land_HBarrier_Big_F", [22.82, -9.99, 0], 90],
        ["Land_PortableLight_double_F", [12.99, -22.57, 0], 143.35],
        ["Land_Cargo20_yellow_F", [22.98, 14.88, 0], 5.84],
        ["Land_HBarrier_Big_F", [25.62, 11.64, 0], 0],
        ["Land_HBarrier_Big_F", [12.12, 25.39, 0], 0],
        ["Land_HBarrier_Big_F", [18.12, -21.86, 0], 0],
        ["Land_HBarrier_Big_F", [23.07, -18.49, 0], 90],
        ["Land_Cargo20_yellow_F", [11.62, 27.88, 0], 358.52],
        ["Land_Cargo10_grey_F", [24.11, 18.55, 0], 240],
        ["Snake_random_F", [-31.10, 2.31, 0], 328.69],
        ["Land_HBarrier_Big_F", [28.82, 16.76, 0], 90],
        ["Land_PortableLight_double_F", [27.40, 23.03, 0], 66.44],
        ["Land_PortableLight_double_F", [28.07, 23.60, 0], 206.19],
        ["Snake_random_F", [-38.50, -5.00, 0], 193.54],
        ["Snake_random_F", [8.14, -38.46, 0], 116.38]
    ],

    // Third emplacement
    [
        ["Land_BagFence_Long_F", [-2.27, 2.35, 0], 0],
        ["Snake_random_F", [2.71, 2.14, 0], 335.51],
        ["Land_BagFence_Long_F", [-0.87, 3.71, 0], 90],
        ["Land_ToolTrolley_01_F", [-3.77, 3.50, 0], 124.97],
        ["Land_BagFence_End_F", [-0.46, 5.93, 0], 300],
        ["Land_BagFence_Round_F", [-4.90, 2.90, 0], 50],
        ["Land_BagFence_Long_F", [-5.73, -2.88, 0], 88.64],
        ["Land_FoodSacks_01_cargo_white_idap_F", [-4.26, -5.07, 0], 93.21],
        ["Land_Garbage_square5_F", [7.05, 2.18, 0], 232.33],
        ["Land_CncShelter_F", [-7.17, -2.05, 0], 0],
        ["Land_HBarrier_3_F", [-5.16, 7.32, 0], 90],
        ["Land_BagFence_Long_F", [-5.73, -5.73, 0], 90.66],
        ["Land_CncShelter_F", [-7.16, -3.69, 0], 0],
        ["Land_FoodSacks_01_large_white_idap_F", [-4.46, -6.91, 0], 142.72],
        ["Land_HBarrier_3_F", [-2.26, 7.64, -0.74], 180],
        ["Land_HBarrierTower_F", [6.14, -5.34, 0], 269.99],
        ["Land_ToolTrolley_02_F", [2.32, 7.98, 0], 268.87],
        ["Land_WeldingTrolley_01_F", [4.07, 7.60, 0], 20.25],
        ["Land_PaperBox_01_open_water_F", [8.80, -0.37, 0], 316.33],
        ["Land_CncShelter_F", [-7.23, -5.32, 0], 0],
        ["Land_BagFence_Long_F", [-8.64, -2.95, 0], 90.66],
        ["Land_WoodenLog_F", [8.46, 4.05, 0], 65.74],
        ["Land_GarbagePallet_F", [-3.83, 8.91, 0], 90],
        ["Land_CncShelter_F", [-7.23, -6.96, 0], 0],
        ["Land_BagFence_Long_F", [-8.66, -5.93, 0], 90.66],
        ["Land_PaperBox_01_open_empty_F", [1.21, -10.70, 0], 253.64],
        ["Land_BagFence_Long_F", [-10.37, 3.09, 0], 90],
        ["Land_BagFence_Round_F", [-10.91, 0.58, 0], 320],
        ["Land_Pallet_vertical_F", [-9.05, 6.84, 0], 74.33],
        ["Land_Garbage_square5_F", [-7.44, 8.54, 0], 90],
        ["Land_CampingChair_V2_F", [-8.26, 8.33, 0], 90.05],
        ["Land_HBarrier_Big_F", [3.22, -11.34, 0], 90.14],
        ["Land_PlasticCase_01_small_F", [-8.89, 7.96, 0], 247],
        ["Land_HBarrier_3_F", [-10.29, 7.20, 0], 90],
        ["Land_Cargo_House_V3_F", [2.76, 11.46, 0], 270.12],
        ["Land_PaperBox_01_small_stacked_F", [-12.00, 1.64, 0], 217.34],
        ["Land_HBarrier_Big_F", [-2.34, 11.99, 0], 90],
        ["Land_CampingChair_V2_F", [-8.26, 9.21, 0], 90.03],
        ["Land_WoodenTable_large_F", [-8.85, 8.96, 0], 180.03],
        ["Land_Sacks_goods_F", [-4.14, 12.19, 0], 180],
        ["CamoNet_INDP_F", [-5.19, 11.98, -1.13], 90],
        ["Land_GarbageBags_F", [0.06, -14.20, 0], 0],
        ["Land_BagFence_Round_F", [-13.60, 0.59, 0], 35],
        ["Land_PortableLight_double_F", [-12.33, 5.90, 0], 68.92],
        ["Land_PortableLight_double_F", [-2.40, -14.32, 0], 161.38],
        ["Land_PaperBox_open_empty_F", [-4.39, 14.58, 0], 82],
        ["Land_GasTank_02_F", [-15.00, 2.95, 0], 0],
        ["Land_Tyre_F", [-5.63, 14.33, 0], 89.99],
        ["Land_BagFence_Long_F", [-15.63, 1.82, 0], 180],
        ["Land_FoodSacks_01_cargo_brown_idap_F", [0.45, 15.81, 0], 57.73],
        ["Land_GasTank_01_yellow_F", [-16.04, 2.46, 0], 359.98],
        ["Land_GasTank_01_khaki_F", [-16.05, 3.25, 0], 359.98],
        ["Land_Razorwire_F", [14.87, -5.48, 0], 90],
        ["Land_HBarrier_Big_F", [0.25, -16.54, 0], 180.49],
        ["Land_Pipes_small_F", [-7.16, 15.45, 0], 180],
        ["Land_HBarrier_5_F", [-6.51, 16.58, 0], 0],
        ["Land_BagFence_Long_F", [-17.00, 3.21, 0], 90],
        ["Land_Ammobox_rounds_F", [-17.55, -2.49, 0], 163.82],
        ["Land_Ammobox_rounds_F", [-17.55, -2.89, 0], 120.23],
        ["Land_Camping_Light_F", [-17.77, -1.46, 0], 110.94],
        ["Land_BagFence_End_F", [-17.40, 5.46, 0], 240],
        ["Land_CanisterPlastic_F", [-17.95, -2.11, 0], 108.34],
        ["Land_BagBunker_Large_F", [-14.09, 12.09, 0], 90],
        ["Land_CanisterPlastic_F", [-18.50, -1.57, 0], 258.35],
        ["CamoNet_INDP_open_F", [-14.04, 11.47, -1.05], 0],
        ["Land_HBarrier_3_F", [-9.75, 16.56, 0], 0],
        ["Land_HBarrier_Big_F", [-8.45, -16.77, 0], 180.49],
        ["Land_WoodenBox_F", [-19.19, -2.25, 0], 263.69],
        ["Land_PaperBox_01_open_empty_F", [-15.09, -13.93, 0], 304.68],
        ["Land_PaperBox_01_open_empty_F", [-16.47, -12.44, 0], 354.15],
        ["Land_Razorwire_F", [-10.62, 18.90, 0], 0],
        ["Land_FoodSacks_01_cargo_brown_F", [-18.22, -10.94, 0], 59.20],
        ["Land_HBarrierTower_F", [-21.64, -4.35, 0], 90.61],
        ["Land_PaperBox_01_open_empty_F", [-17.78, -14.24, 0], 39.59],
        ["Land_HBarrier_Big_F", [-20.74, -11.87, 0], 88.81],
        ["Land_HBarrier_Big_F", [-17.01, -16.87, 0], 180.49],
        ["Land_CanisterFuel_F", [-22.98, -9.07, 0], 339.78],
        ["Land_CanisterFuel_F", [-23.25, -8.74, 0], 9.73],
        ["Land_Razorwire_F", [-21.07, 15.81, 0], 90],
        ["Land_Razorwire_F", [-18.99, 18.78, 0], 0],
        ["Land_Pallet_F", [-23.37, -10.63, 0], 151.83],
        ["Land_Pallets_stack_F", [-24.36, -9.00, 0], 155.06],
        ["Snake_random_F", [17.45, -22.87, 0], 79.01],
        ["Land_Razorwire_F", [-28.66, -3.05, 0], 90],
        ["Rabbit_F", [29.20, 0.52, 0], 137.84]
    ],
	 [
        // First emplacement variant
        ["Land_CncBarrier_F",[-4.34375,-0.171875,0],354.609],
        ["RoadCone_F",[-5.39844,-0.837891,-3.8147e-06],135.005],
        ["Land_ButaneCanister_F",[-5.52148,0.107422,1.35899e-05],302.6],
        ["Land_ButaneTorch_F",[-5.66602,0.269531,3.24249e-05],122.485],
        ["RoadCone_F",[-5.77539,-1.09766,-3.8147e-06],119.996],
        ["Land_GasTank_01_khaki_F",[-5.97266,0.0976563,7.62939e-06],302.455],
        ["Land_HBarrier_1_F",[1.92969,-6.67773,0],58.4917],
        ["Land_CncBarrier_F",[-6.96289,-0.982422,0],335.533],
        ["Land_Garbage_square5_F",[-7.42969,-1.86523,0],0],
        ["Land_CampingChair_V1_folded_F",[-3.20703,7.19727,0],123.162],
        ["Land_HBarrier_1_F",[5.66602,-5.63086,0],273.335],
        ["Land_BottlePlastic_V2_F",[4.12109,-7.70898,-0.000151157],0.243076],
        ["Land_BarrelSand_F",[4.62305,-7.46094,2.14577e-06],359.987],
        ["Land_CampingChair_V1_F",[-3.43555,8.26367,0.0282679],83.4689],
        ["Land_CampingTable_F",[-4.13672,7.99219,-0.0162771],87.669],
        ["Land_BottlePlastic_V2_F",[4.36133,-7.88086,-0.000100374],1.02476],
        ["Land_BottlePlastic_V2_F",[4.22266,-7.9707,-0.000137329],0.264141],
        ["Land_CanisterFuel_F",[3.87305,-8.21094,1.95503e-05],359.906],
        ["Land_PortableLight_double_F",[7.17383,-6.25781,0],261.737],
        ["Land_CncBarrier_F",[-9.68164,-1.46875,0],0],
        ["Land_PaperBox_closed_F",[4.36523,-8.95117,0],330],
        ["Land_Razorwire_F",[3.93359,10.3164,-2.86102e-06],60],
        ["Oil_Spill_F",[-1.58398,10.0762,0],207.847],
        ["Land_CanisterOil_F",[-2.55078,9.75781,1.90735e-05],222.827],
        ["Land_BagFence_End_F",[0.455078,9.62109,-0.00100017],60],
        ["Land_TinContainer_F",[-10.0801,-1.77734,0.00120544],285.367],
        ["Land_Cargo_House_V3_F",[-7.67773,8.34375,0],2.90822],
        ["Land_CanisterFuel_F",[-10.6973,-1.91211,2.09808e-05],134.903],
        ["B_G_Quadbike_01_F",[6.875,-8.46289,-0.0102396],345],
        ["Land_ToolTrolley_01_F",[-3.44727,10.4805,1.90735e-06],282.846],
        ["Land_BagFence_Long_F",[-1.13477,11.0527,-0.000999928],30],
        ["Land_Timbers_F",[8.75195,7.13672,0.0232067],345],
        ["Land_HBarrierTower_F",[-1.53906,-11.4336,0],321.471],
        ["Land_PaperBox_open_empty_F",[5.12305,-11.2109,0],30],
        ["Land_BagFence_Long_F",[-3.76367,12.1777,-0.000999928],15],
        ["Land_Pallets_F",[-10.1777,-9.29883,0],121.541],
        ["Land_PortableLight_double_F",[-11.8887,7.15625,0],43.1881],
        ["Land_BagFence_Long_F",[-6.51758,12.5508,-0.000999928],0],
        ["Land_Razorwire_F",[-2.22266,15.207,-2.86102e-06],30],
        ["Land_HBarrier_1_F",[-6.87305,-13.0762,0],83.2207],
        ["Land_BagFence_Short_F",[-8.51758,12.5371,-0.0010004],0],
        ["Land_WoodPile_large_F",[-6.01172,14.0996,0.0232067],274.454],
        ["Land_CratesWooden_F",[-9.92383,-11.7754,0],10.4276],
        ["Land_CncBarrier_stripes_F",[15.0234,-4.5957,0],305.013],
        ["Land_BagFence_Long_F",[-10.627,12.5195,-0.000999928],180],
        ["Land_CncBarrier_stripes_F",[16.5645,-0.365234,0],290.013],
        ["Land_Cargo10_white_F",[-12.8555,-10.5938,-1.90735e-06],285.003],
        ["Land_HBarrier_1_F",[-11.25,-13.4043,0],82.2661],
        ["Land_BagFence_Long_F",[-17.3496,-2.44922,-0.000999928],88.6361],
        ["Land_BagFence_Long_F",[-13.373,12.1465,-0.000999928],165],
        ["Land_BagFence_Long_F",[-17.3496,-5.29883,-0.000999928],90.6617],
        ["WaterPump_01_forest_F",[-11.8887,14.0918,0.000851154],270.002],
        ["Land_Pipes_small_F",[-16.9883,-7.27148,-2.38419e-07],309.159],
        ["Land_Razorwire_F",[-10.2383,16.4766,-2.86102e-06],0],
        ["Land_CncShelter_F",[-18.7852,-1.61719,0],0],
        ["Land_CncShelter_F",[-18.7793,-3.25977,0],0],
        ["Land_BagFence_Long_F",[-15.9961,11.0254,-0.000999928],150],
        ["Land_FieldToilet_F",[-18.6133,5.51758,2.38419e-06],297.569],
        ["Land_CncShelter_F",[-18.8496,-4.88672,0],0],
        ["Land_CncShelter_F",[-18.8438,-6.5293,0],0],
        ["Land_BagFence_End_F",[-17.7227,9.73828,-0.00100017],135],
        ["Land_BagFence_Long_F",[-20.2539,-2.51367,-0.000999928],90.6617],
        ["Land_BagFence_Long_F",[-20.2754,-5.5,-0.000999928],90.6617],
        ["Land_HBarrier_3_F",[-15.0879,-13.5039,0],180],
        ["Land_Razorwire_F",[-17.541,13.6035,-2.86102e-06],330],
        ["Land_PortableLight_double_F",[-15.2324,-15.7246,0],334.92],
        ["Land_Razorwire_F",[-21.0234,6.88281,-2.86102e-06],285],
        ["Land_BagFence_Long_F",[-18.209,-13.293,-0.000999928],180],
        ["Land_BagFence_Round_F",[-20.8262,-13.0781,-0.00130081],30],
        ["Land_BagFence_End_F",[-21.4902,-11.0039,-0.00100017],270],
        ["Land_HBarrier_1_F",[-24.0605,4.54883,0],299.714],
        ["Land_HBarrier_1_F",[-24.1563,-14.2852,0],262.898],
        ["Land_Pallet_MilBoxes_F",[-27.2012,-7.59375,0],53.3611],
        ["Land_Pallet_MilBoxes_F",[-28.3418,-0.226563,0],15],
        ["CamoNet_BLUFOR_big_F",[-28.2578,-5.00586,0],277.843],
        ["Land_PaperBox_closed_F",[-28.4824,-5.77539,0],147.892],
        ["Land_Bucket_painted_F",[-29.3809,-1.11133,-0.000999212],352.437],
        ["Snake_random_F",[-26.0605,13.6641,0.0083878],42.6462],
        ["Land_PaperBox_open_empty_F",[-28.3184,-9.97461,0],126.587],
        ["Land_HBarrier_1_F",[-29.6797,5.20117,0],81.4335],
        ["Land_PaperBox_closed_F",[-29.7891,-8.18555,0],15.4901],
        ["Box_NATO_AmmoVeh_F",[-31.3652,-0.591797,0.0305417],53.7978],
        ["Land_PaperBox_closed_F",[-31.4414,-5.69336,0],148.368],
        ["Land_HBarrier_5_F",[-31.9414,5.13672,4.76837e-07],155.59],
        ["Land_HBarrier_1_F",[-32.123,-14.7168,0],117.693],
        ["Land_HBarrier_5_F",[-37.0996,2.23047,0],111.259],
        ["Land_HBarrier_5_F",[-39.082,-3.30078,1.43051e-06],92.5686],
        ["Rabbit_F",[-33.3906,31.9297,0.00223756],296.237]
    ],
    [
        // Second emplacement variant
        ["Land_Sacks_heap_F",[2.57813,-0.75,4.76837e-07],28.2135],
        ["Land_Sacks_heap_F",[2.14453,-1.87305,4.76837e-07],298.214],
        ["Land_WoodenBox_F",[3.44141,-1.87695,-7.15256e-07],296.277],
        ["Land_HBarrier_3_F",[-5.26172,1.6582,0],12.5083],
        ["Land_CratesWooden_F",[-4.75586,-0.660156,0],181.495],
        ["MetalBarrel_burning_F",[-5.17578,-2.40039,0],309.495],
        ["Land_CratesWooden_F",[-4.76953,3.50977,0],23.3879],
        ["Land_PaperBox_closed_F",[-7.35742,0.296875,0],16.4946],
        ["CargoNet_01_barrels_F",[-1.68359,7.3457,-4.76837e-07],265.926],
        ["Land_HBarrier_3_F",[-8.48438,2.41602,0],12.5083],
        ["Land_BagFence_Long_F",[1.81641,8.00391,-0.000999451],10.3777],
        ["Land_BagFence_Long_F",[-5.01563,-6.90625,-0.000999928],192.508],
        ["Land_Pallet_MilBoxes_F",[-7.50977,4.01172,0],102.508],
        ["Land_BagFence_Long_F",[-1.125,8.5293,-0.000999451],10.3777],
        ["CargoNet_01_barrels_F",[9.0293,1.46875,0],265.926],
        ["Land_CratesShabby_F",[-8.94336,-1.93359,0],204.203],
        ["Land_MetalBarrel_F",[8.875,3.66992,1.66893e-06],25.9266],
        ["Land_CncShelter_F",[1.45313,9.51367,4.76837e-07],279.716],
        ["Land_GarbageBags_F",[-9.64648,-3.28125,0],102.508],
        ["Land_CncShelter_F",[3.07227,9.24219,4.76837e-07],279.716],
        ["Land_HBarrier_3_F",[-9.68555,1.5625,0],282.508],
        ["Land_CncShelter_F",[-0.138672,9.85742,4.76837e-07],279.716],
        ["Land_BagFence_Long_F",[-7.86133,-6.29492,-0.000999928],192.508],
        ["Land_HBarrier_3_F",[-10.3359,-1.36719,0],282.508],
        ["Land_HBarrier_3_F",[-9.19922,3.75781,0],282.508],
        ["Land_PortableLight_double_F",[-7.05664,7.56445,0],279.723],
        ["Land_CncShelter_F",[-1.75781,10.1289,4.76837e-07],279.716],
        ["Land_MetalBarrel_F",[9.83594,3.74414,1.66893e-06],295.929],
        ["Land_PowerGenerator_F",[9.88086,-3.7207,0],10.9099],
        ["Land_HBarrier_3_F",[7.79102,5.92578,4.76837e-07],10.4591],
        ["Land_Portable_generator_F",[10.6289,0.697266,-0.000810146],130.941],
        ["Land_PaperBox_open_empty_F",[10.8262,2.13281,0],100.926],
        ["Land_BagFence_Long_F",[2.11133,10.9219,-0.000999451],10.3777],
        ["Land_HBarrier_3_F",[-11.0117,-4.41797,0],282.508],
        ["Land_BagFence_Long_F",[-0.697266,11.4023,-0.000999451],8.35214],
        ["Land_HBarrier_3_F",[-11.5195,-5.49023,0],12.5083],
        ["Land_HBarrier_3_F",[11.7285,-2.20508,4.76837e-07],282.676],
        ["Land_HBarrier_3_F",[11.043,-5.25391,4.76837e-07],282.676],
        ["Land_HBarrier_3_F",[-9.43555,8.91406,2.38419e-07],72.6677],
        ["Land_HBarrier_3_F",[10,5.51758,4.76837e-07],10.4591],
        ["Land_HBarrier_3_F",[12.3867,0.722656,4.76837e-07],282.676],
        ["Land_PaperBox_open_empty_F",[0.181641,-13.0723,0],122.857],
        ["Land_HBarrier_3_F",[12.8789,2.91602,4.76837e-07],282.676],
        ["Land_MetalBarrel_F",[6.86133,11.9238,1.43051e-06],194.982],
        ["Land_GarbageWashingMachine_F",[11.7168,-7.48633,0],44.0669],
        ["CamoNet_BLUFOR_open_F",[3.56055,-12.8184,4.76837e-07],166.123],
        ["Land_MetalBarrel_F",[6.26758,12.502,1.43051e-06],300.004],
        ["Land_Razorwire_F",[-13.6055,5.91016,-2.86102e-06],85.776],
        ["Land_HBarrier_Big_F",[9.93945,10.5527,4.76837e-07],101.374],
        ["Land_MetalBarrel_F",[7.03516,12.8262,1.43051e-06],359.983],
        ["Land_Razorwire_F",[-13.75,-2.48047,-2.86102e-06],98.9181],
        ["Land_CampingTable_F",[7.55859,-13.3047,-0.00259185],154.814],
        ["Land_PaperBox_closed_F",[-0.0371094,-15.3926,0],90],
        ["Land_PaperBox_open_empty_F",[1.70117,-15.3945,0],90],
        ["Land_HBarrier_Big_F",[5.35547,14.7148,4.76837e-07],189.003],
        ["Land_Garbage_square5_F",[7.88477,-13.6133,0],19.8145],
        ["Land_HBarrierTower_F",[-9.4043,12.8457,0],101.971],
        ["Land_CampingChair_V1_F",[7.31055,-14.25,0.00308943],184.813],
        ["Land_CampingChair_V1_F",[8.44336,-13.7188,0.00308776],139.815],
        ["Land_WoodenPlanks_01_messy_pine_F",[14.8457,-6.29297,0],180],
        ["Land_HBarrier_Big_F",[-3.13281,16.0488,4.76837e-07],11.4947],
        ["Land_Razorwire_F",[-12.791,-10.3652,-2.86102e-06],48.5702],
        ["Land_Cargo_House_V3_F",[16.2734,-1.69531,0],281.457],
        ["Land_PortableLight_double_F",[15.6152,-8.70313,0],11.1917],
        ["Land_Wreck_Ural_F",[15.623,9.01758,0.00151062],339.58],
        ["Land_Mil_WallBig_debris_F",[18.5137,5.03125,-7.62939e-06],42.7876],
        ["Land_CzechHedgehog_01_F",[-5.58984,-19.3047,0],21.6071],
        ["Land_CzechHedgehog_01_F",[14.3066,-14.2773,0],141.607],
        ["Land_CzechHedgehog_01_F",[10.0508,-19.8711,4.76837e-07],336.607],
        ["Land_CzechHedgehog_01_F",[2.48828,-22.5059,4.76837e-07],306.607],
        ["Snake_random_F",[-44.5352,-16.5332,0.0083878],154.494]
    ],
    [
        // Third emplacement variant
        ["Land_Garbage_square5_F",[6.08594,1.31445,0],260.055],
        ["Land_CinderBlocks_F",[6.50586,3.43945,1.26362e-05],260.043],
        ["Land_CinderBlocks_F",[7.29688,1.27148,4.76837e-07],245.052],
        ["Land_HBarrier_Big_F",[2.79297,-6.95508,0],0],
        ["Land_CinderBlocks_F",[7.65039,4.14648,4.76837e-07],155.041],
        ["Land_BagFence_Long_F",[8.91016,1.2207,-0.000999928],90.6617],
        ["Land_BagFence_Long_F",[8.93164,4.20703,-0.000999928],90.6617],
        ["Land_WoodenBox_F",[-1.41016,-10.2988,0],86.4858],
        ["Land_CncShelter_F",[10.3418,0.191406,0],0],
        ["Land_Grinder_F",[-4.02344,-9.66016,-0.00592303],176.467],
        ["Land_CncShelter_F",[10.3359,1.83398,0],0],
        ["Land_PortableLight_double_F",[4.19141,-9.57617,0],301.029],
        ["Land_Cargo_House_V3_F",[-11.6484,1.33984,0],270.118],
        ["Land_HBarrier_Big_F",[1.49609,-10.5879,0],90],
        ["Land_WoodenBox_F",[-0.441406,-10.8574,-2.38419e-07],101.486],
        ["Land_CncShelter_F",[10.4063,3.46094,0],0],
        ["Land_WorkStand_F",[-5.54688,-9.65039,0],326.488],
        ["Land_CratesShabby_F",[-10.9238,-3.0293,0],357.215],
        ["Land_Portable_generator_F",[-4.47266,-10.4922,-0.000812054],56.3849],
        ["Land_CncShelter_F",[10.4004,5.10352,0],0],
        ["Land_BagFence_Long_F",[11.8359,1.42188,-0.000999928],90.6617],
        ["Land_HBarrier_3_F",[-0.140625,12.0332,0],180],
        ["Land_Garbage_square5_F",[-4.49219,-11.3633,0],206.486],
        ["Land_BagFence_Long_F",[11.8359,4.27148,-0.000999928],88.6361],
        ["Land_PortableLight_double_F",[12.0703,-4.07422,0],123.671],
        ["Land_Wall_IndCnc_2deco_F",[-10.5762,-7.16406,0],351.139],
        ["Land_Garbage_square5_F",[-12.4414,-3.41602,0],267.215],
        ["Land_Pallet_vertical_F",[-12.7402,-1.85938,-0.000625372],176.057],
        ["Land_CratesWooden_F",[-12.5781,-2.95313,0],356.15],
        ["Land_HBarrierTower_F",[3.85352,12.6855,0],182.42],
        ["Land_HBarrier_Big_F",[11.293,-6.95508,0],1.36604e-05],
        ["Land_BagFence_Long_F",[-2.66992,14.2891,-0.000999928],270],
        ["Land_HBarrier_Big_F",[14.5352,-1.6582,0],270],
        ["Land_Wall_IndCnc_2deco_F",[-13.5566,-6.93945,0],195],
        ["Land_PaperBox_open_full_F",[8.15234,-12.9961,0],151.478],
        ["Land_Sacks_heap_F",[-13.6094,-8.12109,0],202.968],
        ["Land_HBarrier_Big_F",[14.4961,6.78711,0],90],
        ["Land_HBarrier_Big_F",[-16.2266,-0.5625,0],270],
        ["Land_HBarrier_Big_F",[11.3633,11.834,0],180],
        ["Land_CampingChair_V2_F",[10.6133,-12.4883,-1.90735e-06],329.999],
        ["Land_HBarrier_5_F",[-4.54492,-16.377,0],0],
        ["Land_CampingChair_V2_F",[11.5156,-11.9883,-1.90735e-06],270.004],
        ["Land_Bricks_V3_F",[16.6797,-2.33594,-4.76837e-07],139.915],
        ["Land_Basket_F",[7.15039,-15.6445,7.15256e-07],134.97],
        ["Land_WoodenTable_large_F",[11.2891,-13.0723,0],254.735],
        ["Land_IronPipes_F",[-13.8359,10.957,0],90],
        ["Land_Coil_F",[17.4902,1.33008,0],0.000297251],
        ["Land_CampingChair_V2_F",[11.002,-13.9375,-1.66893e-06],149.999],
        ["Land_HBarrier_Big_F",[-16.2656,7.88281,0],90],
        ["Land_CampingChair_V2_F",[11.9668,-13.668,-1.66893e-06],164.977],
        ["Land_GarbageBags_F",[8.74805,14.8164,0],0],
        ["Land_CampingChair_V1_F",[-6.37109,17.6172,0.0030899],167.692],
        ["Land_CampingChair_V1_F",[-7.43359,17.3887,0.00308943],211.556],
        ["Land_cargo_addon02_V1_F",[-7.40039,17.5,0],181.552],
        ["Land_GarbageBags_F",[14.5977,-12.7988,0],0],
        ["Land_HBarrier_Big_F",[1.37109,-19.0879,0],90],
        ["Land_CampingTable_F",[-6.78906,18.1152,-0.00259304],176.425],
        ["CamoNet_OPFOR_big_F",[11.625,-16.4004,0],0],
        ["Land_Cargo20_orange_F",[-20.0078,0.28125,0],285],
        ["Land_HBarrier_Big_F",[-19.2559,-5.7793,0],180],
        ["I_Quadbike_01_F",[-2.21094,-20.334,-0.010263],241.867],
        ["Land_BagFence_Long_F",[-16.1992,13.2188,-0.000999928],270],
        ["Land_WaterTank_F",[7.57617,-19.7441,1.81198e-05],59.9991],
        ["Land_HBarrier_3_F",[-16.457,-12.4141,0],90],
        ["Land_Cargo40_yellow_F",[20.7012,4.86133,4.76837e-07],65.5708],
        ["Land_BagFence_Long_F",[-16.1992,16.0938,-0.000999928],270],
        ["Land_BagFence_Long_F",[-14.8125,17.6133,-0.000999928],0],
        ["Land_BagFence_Long_F",[-0.890625,-23.168,-0.000999928],180],
        ["Land_PaperBox_closed_F",[4.46484,-23.0371,0],170.684],
        ["Land_PortableLight_double_F",[-22.1973,-8.02539,0],298.145],
        ["Land_HBarrier_3_F",[-17.5703,-14.5039,0],180],
        ["Land_MetalBarrel_F",[-17.9375,-15.9219,1.66893e-06],134.998],
        ["Land_PaperBox_closed_F",[16.6973,-17.7207,0],0],
        ["Land_Cargo20_orange_F",[-24.0117,3.94141,0],73.853],
        ["Land_MetalBarrel_F",[-18.793,-16.0625,1.43051e-06],359.991],
        ["Land_Pallets_F",[4.19531,-25.0527,0],279.076],
        ["Land_Sack_F",[16.1953,-18.8574,0],330],
        ["Snake_random_F",[-12.4141,21.957,0.0083878],311.462],
        ["Land_BagFence_Long_F",[-14.0625,-21.0117,-0.000999928],0],
        ["Land_Pallet_F",[5.96484,-24.9043,-2.38419e-07],127.688],
        ["Land_FieldToilet_F",[-21.1836,-15.1523,2.52724e-05],359.998],
        ["Land_HBarrier_Big_F",[-24.2266,-9.4375,0],270],
        ["Land_PaperBox_closed_F",[17.4277,-19.5195,0],150],
        ["Land_FieldToilet_F",[-22.4336,-15.1523,9.53674e-07],0.000130744],
        ["Snake_random_F",[-12.5059,-24.707,0.0083878],177.684],
        ["Land_Sign_WarningMilAreaSmall_F",[-15.1816,-23.4023,0],0],
        ["RoadBarrier_F",[-4.17383,-27.7188,-0.00400114],150.172],
        ["Land_HBarrier_Big_F",[-19.2188,-20.9844,0],0],
        ["Land_PowerGenerator_F",[17.3789,-23.9492,0],54.3286],
        ["Land_HBarrier_Big_F",[-24.2266,-17.8125,0],270],
        ["RoadBarrier_small_F",[-9.54492,-29.5,0.0708125],184.832],
        ["RoadBarrier_F",[-13.5664,-28.5957,-0.00399995],30.1447],
        ["Land_ConcretePipe_F",[-21,-24.3633,-0.0534215],282.337],
        ["Rabbit_F",[-26.9063,-39.584,0.00223756],348.953],
        ["Snake_random_F",[8.70508,-47.7695,0.0083878],21.9868]
    ],
	
	  [
        ["Land_DeskChair_01_sand_F",[3.48,1.27,-0.0587],74.12],
        ["Land_DeskChair_01_sand_F",[3.76,-0.26,-2.38e-06],300],
        ["CBRNContainer_01_closed_yellow_F",[3.76,-1.39,4.53e-06],134.98],
        ["Land_Tablet_02_sand_F",[3.97,1.24,-0.000271],254.99],
        ["Land_PortableDesk_01_sand_F",[4.2,0.416,0.0475],272.18],
        ["Land_PortableCabinet_01_7drawers_sand_F",[4.27,-0.262,0.000642],91.74],
        ["CBRNContainer_01_closed_yellow_F",[4.26,-1.14,3.58e-06],195.02],
        ["Land_PortableCabinet_01_4drawers_sand_F",[4.26,2.24,1.14e-05],104.99],
        ["Land_Pallet_MilBoxes_F",[2.97,-4.69,0],158.45],
        ["Land_BagFence_Long_F",[1.14,6.08,-0.001],0.787],
        ["Land_HBarrier_Big_F",[5.81,-1.6,0],90],
        ["Land_PaperBox_closed_F",[-4.63,-4.3,0],61.44],
        ["Land_BagFence_Long_F",[-1.84,6.11,-0.001],0.787],
        ["Land_BagFence_Short_F",[0.391,-6.38,-0.001],90],
        ["Land_PaperBox_open_empty_F",[2.15,-7.04,0],330],
        ["Land_CncShelter_F",[0.533,7.51,0],270.13],
        ["Land_CncShelter_F",[-1.09,7.58,0],270.13],
        ["Land_CncShelter_F",[2.18,7.51,0],270.13],
        ["Land_CratesWooden_F",[-6.71,-4.19,0],89.12],
        ["Land_Pallet_MilBoxes_F",[4.29,-6.9,0],108.91],
        ["Land_BagFence_Round_F",[0.764,-8.22,-0.0013],45],
        ["Land_CncShelter_F",[-2.74,7.58,0],270.13],
        ["Land_CanisterFuel_F",[7.86,-2.68,6.44e-06],318.17],
        ["Land_PaperBox_closed_F",[-5.55,-6.28,0],61.44],
        ["Land_HBarrier_3_F",[7.15,1.84,0],0],
        ["Land_CratesWooden_F",[8.53,-0.748,0],328.49],
        ["Land_CanisterFuel_F",[8.28,-2.64,2.36e-05],284.43],
        ["Land_BagFence_Long_F",[0.949,9.01,-0.001],0.787],
        ["Land_BagFence_Short_F",[2.65,-8.76,-0.001],180],
        ["Land_BagFence_Long_F",[-1.9,9.01,-0.001],358.76],
        ["Land_BagFence_Short_F",[6.64,-6.63,-0.001],90],
        ["LayFlatHose_01_CurveLong_F",[-8.76,-0.422,0],330],
        ["Land_BagFence_Short_F",[4.25,-8.88,-0.001],0],
        ["Land_BagFence_Round_F",[6.09,-8.51,-0.0013],315],
        ["Land_MetalBarrel_F",[-10.11,0.988,1.67e-06],120],
        ["Broom_01_yellow_F",[-10.61,-0.137,-0.000511],15],
        ["Land_MetalBarrel_F",[-10.67,1.5,1.67e-06],300],
        ["MedicalGarbage_01_Gloves_F",[-10.49,-2.63,0],165],
        ["Land_Bodybag_01_folded_white_F",[-10.86,-1.39,-0.0146],225],
        ["Land_Bodybag_01_folded_white_F",[-10.86,-1.76,-0.0192],270],
        ["TrashBagHolder_01_F",[-10.86,-2.51,6.2e-06],74.98],
        ["Land_BarrelTrash_grey_F",[-10.74,-3.14,1.91e-06],180],
        ["Land_WoodenBox_F",[-12.96,0.367,0],282],
        ["Land_FoodSacks_01_large_brown_F",[-13.11,-1.64,-4.76e-07],270],
        ["Land_WoodenBox_F",[-13.71,1.12,-2.38e-07],297],
        ["Box_IND_AmmoVeh_F",[-12.83,5.1,0.0305],45.15],
        ["Box_IND_AmmoVeh_F",[-13.61,3.11,0.0305],270],
        ["Land_FoodSacks_01_small_brown_F",[-14.24,-1.39,-2.38e-07],270],
        ["Land_FoodSacks_01_small_brown_idap_F",[-14.24,-2.14,0],0.000124],
        ["Land_HBarrier_3_F",[6.99,14.1,0],90],
        ["Land_FoodSack_01_full_brown_idap_F",[-14.49,-3.01,-2.38e-07],150],
        ["Land_FoodSacks_01_small_brown_idap_F",[-14.99,-1.39,0],90],
        ["Land_FoodSack_01_empty_brown_F",[-15.24,-2.76,0],210],
        ["Land_Pallets_F",[3.67,15.3,0],279.08],
        ["Land_MedicalTent_01_floor_dark_F",[-16.12,1.19,0],0],
        ["Land_PlasticCase_01_large_CBRN_F",[-9.23,-13.34,-7.15e-07],196.71],
        ["Land_PaperBox_open_full_F",[0.973,16.42,0],199.55],
        ["Land_Pallet_F",[5.04,15.97,0.0647],153.25],
        ["Land_PlasticCase_01_small_CBRN_F",[-9.12,-14.29,-4.77e-07],241.7],
        ["Land_BagFence_Short_F",[-10.03,-14.17,-0.001],90],
        ["Land_Pallets_stack_F",[3,17.44,0.00852],184.55],
        ["Land_PalletTrolley_01_khaki_F",[4.46,17.14,2.62e-06],87.13],
        ["Land_Cargo_House_V3_F",[-13.75,-12.57,0],179.39],
        ["Land_WoodenPlanks_01_messy_pine_F",[-18.51,1.96,0],90],
        ["Land_PaperBox_closed_F",[-18.45,-3.46,0],15.93],
        ["Land_HBarrier_5_F",[7.01,19.74,0],90],
        ["Land_Razorwire_F",[9.33,18.34,-2.86e-06],90],
        ["Land_DisinfectantSpray_F",[-11.53,15.35,-0.116],279.8],
        ["Land_BagFence_Round_F",[-10.58,-16.18,-0.0013],315],
        ["Land_FoodContainer_01_White_F",[-18.86,4.92,7.15e-07],252],
        ["CamoNet_INDP_open_F",[5.49,-18.19,0],132.89],
        ["Land_PaperBox_closed_F",[-19.66,-1.37,0],52.2],
        ["Land_HBarrier_5_F",[5.76,19.49,0],180],
        ["Land_FoodSack_01_full_white_idap_F",[-19.11,5.36,0],272.01],
        ["Land_WaterBottle_01_pack_F",[-19.09,5.77,1.91e-06],254.94],
        ["Snake_random_F",[-19.56,-4.07,0.00839],343.85],
        ["Land_Razorwire_F",[-8.76,-19.16,-2.86e-06],347.25],
        ["Land_PaperBox_01_small_closed_brown_food_F",[-19.59,4.73,-4.77e-07],261],
        ["Land_WoodenBox_02_F",[-9.87,17.83,0],193.48],
        ["Land_EmergencyBlanket_01_F",[-19.74,5.5,-2.38e-07],113.45],
        ["Land_HBarrierTower_F",[-2.59,20.59,0],182.42],
        ["Land_Sacks_heap_F",[2.52,-20.59,0],105],
        ["Land_WoodenTable_small_F",[5.99,-19.99,-1.19e-06],0],
        ["Land_CampingChair_V2_F",[7.06,-19.69,-2.15e-06],60],
        ["Land_BagFence_Long_F",[-13.03,-16.57,-0.001],180],
        ["Land_WoodenCrate_01_stack_x5_F",[3.92,-20.72,0],270],
        ["Brush_01_yellow_F",[-12.52,17.14,0.000372],194.48],
        ["HazmatBag_01_roll_F",[-13.9,16.11,3.19e-05],329.55],
        ["HazmatBag_01_roll_F",[-14.12,15.96,3.17e-05],164.62],
        ["Land_PlasticCase_01_medium_gray_F",[-12.71,17.11,0.102],52.37],
        ["Land_CampingTable_white_F",[-13.12,16.94,-0.365],329.86],
        ["Land_Bodybag_01_folded_white_F",[-13.34,16.81,-0.0192],59.77],
        ["Land_PaperBox_closed_F",[-21.15,-3.62,0],119.53],
        ["Brush_01_yellow_F",[-12.71,17.38,0.000185],60.69],
        ["Land_HBarrier_5_F",[-6.63,19.67,0],180],
        ["LayFlatHose_01_Roll_F",[-12.04,17.92,0],119.77],
        ["Land_Bodybag_01_folded_white_F",[-13.62,16.79,-0.0131],14.77],
        ["Land_BagFence_Short_F",[-17.75,-12.46,-0.001],90],
        ["MedicalGarbage_01_1x1_v1_F",[-13.88,16.96,0],119.77],
        ["Land_PlasticCase_01_small_gray_F",[-19.61,9.99,-2.38e-07],343],
        ["BloodSplatter_01_Medium_New_F",[-20.74,8.11,0],43],
        ["Land_Sacks_heap_F",[5.39,-21.71,0],45],
        ["Land_PortableLight_double_F",[-21.16,-7.59,0],221.38],
        ["Land_Stretcher_01_sand_F",[-20.86,8.24,4.77e-07],90],
        ["MedicalGarbage_01_5x5_v1_F",[-20.56,9.08,0],0],
        ["Land_PaperBox_open_empty_F",[2.89,-22.34,0],285],
        ["Land_BagFence_Short_F",[-15.46,-16.54,-0.001],180],
        ["Land_BagFence_Short_F",[-17.72,-14.15,-0.001],90],
        ["Land_Razorwire_F",[3.7,22.1,-2.86e-06],0],
        ["Land_EmergencyBlanket_02_discarded_F",[-20.86,8.99,-2.38e-07],276],
        ["Land_PortableLight_double_F",[-7.2,21.68,0],140.27],
        ["Land_Stretcher_01_sand_F",[-20.86,9.74,4.77e-07],90],
        ["Land_HBarrier_5_F",[-23.11,-3.13,0],270],
        ["Land_HBarrier_5_F",[-12.01,19.54,0],151.66],
        ["Land_BagFence_Round_F",[-17.34,-15.99,-0.0013],45],
        ["Land_HBarrier_5_F",[-23.11,2.37,0],270],
        ["Land_HBarrier_5_F",[-23.11,-8.63,0],270],
        ["Land_Razorwire_F",[-16.79,-18.93,-2.38e-06],3.25],
        ["Land_HBarrier_5_F",[-22.85,-9.71,0],57.19],
        ["Land_Razorwire_F",[-24.93,-0.615,-2.86e-06],270],
        ["Land_HBarrier_5_F",[-23.13,7.69,0],270],
        ["Land_Razorwire_F",[-24.68,-8.74,-2.86e-06],270],
        ["Land_WoodenBox_02_F",[-22.36,14.01,0],164.77],
        ["Land_Razorwire_F",[-24.95,7.59,-2.86e-06],270],
        ["Land_Razorwire_F",[-22.94,-13.8,-2.86e-06],52.46],
        ["Land_WoodenBox_02_F",[-22.41,15.4,0],179.77],
        ["Land_Razorwire_F",[-11.99,26.7,-2.86e-06],166.3],
        ["Land_Razorwire_F",[-24.83,15.71,-2.86e-06],270],
        ["Land_Razorwire_F",[-19.68,24.34,-2.86e-06],155.07],
        ["Land_Pallets_F",[-19.47,26.6,0],53.24],
        ["Land_PalletTrolley_01_khaki_F",[-17.43,27.91,0.0217],55.98],
        ["Land_GarbageWashingMachine_F",[-20.8,27.07,0],150.63],
        ["Land_WoodenBox_F",[-20.03,28.76,-0.000999],183.71],
        ["Snake_random_F",[9.75,39.4,0.00839],165.02]
    ],
    // Second emplacement
    [
        ["Land_Cargo_House_V3_F",[5.34,-3.21,0],88.72],
        ["Land_PaperBox_closed_F",[1.05,-6.24,0],0],
        ["Land_PowerGenerator_F",[6.21,1.29,0],86.38],
        ["Land_PaperBox_closed_F",[-1.1,-6.71,0],308.63],
        ["Land_PortableLight_double_F",[8.12,0.408,0],144.62],
        ["Land_Cargo10_sand_F",[-7.38,3.4,3.81e-06],21.7],
        ["Land_HBarrier_5_F",[-1.84,-8.79,0],359.32],
        ["Land_Garbage_square5_F",[3.85,8.4,0],319.82],
        ["Land_HBarrier_5_F",[9.75,-3.22,4.77e-07],270.15],
        ["Land_CncShelter_F",[-1.64,9.76,0],357.25],
        ["Land_HBarrier_3_F",[-3.06,-10.64,0],303.76],
        ["Land_MetalBarrel_empty_F",[0.443,10.55,0],15.5],
        ["Land_HBarrierWall6_F",[-11.6,1.17,0],269.41],
        ["Land_HBarrier_5_F",[3.82,-8.69,4.77e-07],359.32],
        ["Land_MetalBarrel_empty_F",[1.19,10.55,0],15.5],
        ["Land_BagFence_Long_F",[-0.207,11.06,-0.001],87.91],
        ["Land_BagFence_Long_F",[-3.12,10.72,-0.001],87.91],
        ["Land_MetalBarrel_F",[0.449,11.3,1.43e-06],90.47],
        ["Land_MetalBarrel_F",[1.199,11.3,1.43e-06],270.47],
        ["Land_CncShelter_F",[-1.73,11.4,0],357.25],
        ["Land_HBarrier_5_F",[9.76,-8.84,0],270.15],
        ["Land_MetalBarrel_F",[0.457,12.05,1.67e-06],135.48],
        ["Land_Pallets_stack_F",[11.16,4.7,-4.77e-07],63.09],
        ["Land_HBarrierWall6_F",[-11.24,-7.19,0],269.41],
        ["Land_MetalBarrel_F",[1.56,12.12,1.67e-06],135.48],
        ["Land_CratesWooden_F",[11.39,-4.74,0],267.87],
        ["Land_CncBarrier_F",[12.15,3.04,0],304.7],
        ["Land_Pallet_MilBoxes_F",[12.61,-2.62,0],46.64],
        ["Land_MetalBarrel_F",[8.41,-10.01,1.67e-06],300],
        ["Land_CncShelter_F",[-1.73,13.03,0],357.25],
        ["Land_Garbage_square3_F",[11.99,5.85,0],120.36],
        ["Land_PaperBox_closed_F",[0.957,13.55,0],270.5],
        ["Land_HBarrier_1_F",[7.06,11.65,0],180],
        ["Land_CratesShabby_F",[12.33,5.75,0],30.36],
        ["Land_CratesShabby_F",[11.82,-6.78,0],297.83],
        ["Land_MetalBarrel_F",[9.04,-10.51,1.67e-06],224.98],
        ["Land_BagFence_Long_F",[-0.346,13.91,-0.001],85.88],
        ["Land_PaperBox_closed_F",[12.89,-5.47,0],87.83],
        ["Land_BagFence_Long_F",[-3.24,13.7,0.001],87.91],
        ["Land_HBarrierTower_F",[-6.3,-12.71,0],0],
        ["Land_PaperBox_closed_F",[11.7,8.49,0],204.89],
        ["Land_MetalBarrel_F",[0.518,14.81,1.67e-06],44.35],
        ["Land_CncShelter_F",[-1.82,14.67,0],357.25],
        ["Land_PaperBox_closed_F",[10.61,10.43,0],98.12],
        ["Land_BagFence_Short_F",[6.94,13.26,-0.001],270],
        ["Land_CncBarrier_F",[13.72,7.13,0],255.29],
        ["Land_Cargo20_brick_red_F",[-15.82,0.891,4.77e-07],289.6],
        ["Land_MetalBarrel_F",[-10.6,12.05,1.67e-06],26.66],
        ["Land_GarbagePallet_F",[9.61,13.49,0],75.94],
        ["Land_HBarrier_1_F",[12.69,10.9,0],180],
        ["Land_BagFence_Round_F",[7.05,15.33,-0.0013],120],
        ["Land_HBarrier_1_F",[-11.76,12.62,4.77e-07],176.66],
        ["Land_Pallets_F",[13.3,10.51,0],60],
        ["Land_BagFence_End_F",[-11.39,14.03,-0.001],116.66],
        ["Land_HBarrier_3_F",[14.93,12.42,0],180],
        ["Land_BagFence_Long_F",[9.81,16.16,-0.001],0],
        ["Land_HBarrier_1_F",[11.19,15.53,0],180],
        ["Land_BagFence_Long_F",[-10.95,16.17,-0.001],86.66],
        ["Land_Pallets_F",[-13.44,13.63,4.77e-07],326.66],
        ["Land_HBarrier_3_F",[-15.26,14.4,4.77e-07],86.66],
        ["Land_HBarrier_1_F",[14.94,13.78,0],180],
        ["Land_HBarrier_1_F",[14.94,15.28,0],180],
        ["Land_BagFence_Round_F",[-11.8,18.76,-0.0013],206.66],
        ["Land_Garbage_square5_F",[-6.68,20.92,0],174.31],
        ["Land_BagFence_Short_F",[-13.88,18.75,-0.001],356.66],
        ["Land_BarrelTrash_F",[-4.41,23.74,2.38e-06],174.26],
        ["Land_Sacks_goods_F",[-6.41,23.34,0],174.31],
        ["Land_HBarrier_1_F",[-15.5,18.65,4.77e-07],86.66],
        ["Land_CncBarrier_F",[12.55,21.3,0],241.59],
        ["Land_HBarrierWall6_F",[2.18,26.12,0],359.17],
        ["Land_HBarrierWall6_F",[-6,25.78,0],359.17],
        ["Land_PortableLight_double_F",[8.56,24.48,0],221.53],
        ["Land_CncBarrier_F",[-13.71,22.5,0],304.7],
        ["Land_PortableLight_double_F",[-11.44,24.25,0],123.42],
        ["Land_Sacks_heap_F",[-5.28,28.49,0],180],
        ["Snake_random_F",[4.64,29.71,0.00839],17.14],
        ["FlexibleTank_01_sand_F",[-4.28,29.99,-1.14e-05],180],
        ["Box_NATO_AmmoVeh_F",[-1.41,30.3,0.0305],324.2],
        ["Land_Garbage_square5_F",[1.77,30.9,0],123.5],
        ["Land_PaperBox_closed_F",[-6.73,30.34,0],265.04],
        ["Box_NATO_AmmoVeh_F",[-4.26,31.24,0.0305],299],
        ["CamoNet_BLUFOR_open_F",[-2.52,32.42,0],180],
        ["Land_CratesShabby_F",[0.279,31.94,0],198.5],
        ["Land_Sack_F",[1.25,32.13,-0.358],228.5],
        ["Land_MetalBarrel_F",[1.15,32.71,2.86e-06],348.79],
        ["Land_MetalBarrel_F",[0.445,32.98,1.67e-06],168.46],
        ["Box_NATO_AmmoVeh_F",[-2.21,33.06,0.0305],299],
        ["Land_MetalBarrel_F",[1.09,33.47,1.67e-06],213.47]
    ],
	[
	   ["Land_Garbage_square5_F",[-4.02, -1.93, 0],147.03],
        ["Land_CncShelter_F",[-3.13, 3.38, 0],0],
        ["Land_WaterBarrel_F",[-0.49, 4.81, 0],29.6],
        ["Land_BagFence_Long_F",[-1.64, 4.61, 0],90.66],
        ["Land_CncShelter_F",[-3.14, 5.02, 0],0],
        ["Land_CratesShabby_F",[-5.45, 2.69, 0],338.79],
        ["Land_BagFence_Long_F",[-4.56, 4.41, 0],90.66],
        ["Land_WoodenBox_F",[-0.93, 6.79, 0],89.61],
        ["Land_CncShelter_F",[-3.07, 6.65, 0],0],
        ["Land_BagFence_Long_F",[-1.64, 7.46, 0],88.64],
        ["Land_BagFence_Long_F",[-4.54, 7.39, 0],90.66],
        ["Land_CncShelter_F",[-3.07, 8.29, 0],0],
        ["Land_GasTank_02_F",[2.09, -8.79, 0],265.46],
        ["Land_GasTank_02_F",[1.61, -9.08, 0],235.45],
        ["Land_Tyre_F",[5.21, 8.04, 0],138.95],
        ["Land_HBarrierWall6_F",[9.1, 6.42, 0],92],
        ["Land_PaperBox_open_empty_F",[-10.17, 0.68, 0],202.48],
        ["Land_WeldingTrolley_01_F",[2.44, -10.02, 0],10.47],
        ["Land_PaperBox_open_empty_F",[-10.37, -1.5, 0],78.63],
        ["Land_Cages_F",[4.93, 9.48, 0],48.94],
        ["Land_HBarrierTower_F",[-1.58, -11.62, 0],0],
        ["Land_ToiletBox_F",[-10.26, -6.56, 0],259.22],
        ["Land_HBarrierWall6_F",[-13.52, -0.58, 0],272],
        ["Land_CanisterFuel_F",[2.48, -12.14, 0],265.35],
        ["Land_WaterTank_04_F",[12.24, 4.34, 0],138.31],
        ["Land_CanisterOil_F",[2.8, -12.75, 0],205.41],
        ["Land_HBarrierWall6_F",[8.97, -10.08, 0],92],
        ["Land_PaperBox_open_empty_F",[-10.73, -8.54, 0],10.2],
        ["Land_HBarrierWall6_F",[-8.53, -11.57, 0],182],
        ["Land_HBarrierWall6_F",[-13.39, 7.67, 0],272],
        ["Land_Cargo20_military_green_F",[5.51, 13.7, 0],90],
        ["Land_PortableLight_double_F",[-10.64, 10.49, 0],314.4],
        ["Land_HBarrierWall6_F",[-13.52, -8.83, 0],272],
        ["Land_HBarrierWall6_F",[6.22, -14.95, 0],182],
        ["Land_GarbageBags_F",[-7.38, -14.91, 0],11.05],
        ["Land_PortableLight_double_F",[-10.55, 11.82, 0],223.18],
        ["Land_Garbage_square5_F",[0.37, 15.98, 0],147.03],
        ["Land_HBarrierWall6_F",[9.1, 14.67, 0],92],
        ["Land_Cargo10_light_blue_F",[-16.49, 0.55, 0],270],
        ["Land_Cargo_House_V3_F",[13.71, 9.79, 0],270.12],
        ["Land_Cargo20_red_F",[-17.98, 4.94, 0],140.05],
        ["Land_HBarrierTower_F",[-13.47, 15.57, 0],90],
        ["MapBoard_altis_F",[1.43, 22.66, 0],89.99],
        ["Land_CampingChair_V1_F",[-4.66, 22.58, 0],166.77],
        ["Land_CampingChair_V1_F",[-5.63, 22.58, 0],151.53],
        ["Land_HBarrierWall6_F",[12.1, 19.18, 0],182],
        ["CamoNet_INDP_open_F",[-1.53, 22.89, 0],0],
        ["Land_CampingTable_F",[-5.31, 23.25, 0],151.48],
        ["Land_PaperBox_closed_F",[8, 22.7, 0],133.98],
        ["Land_TripodScreen_01_dual_v1_F",[-6.39, 24.22, 0],166.76],
        ["Land_PortableGenerator_01_F",[-3.78, 24.91, 0],256.78],
        ["Land_TripodScreen_01_dual_v2_F",[-5.07, 24.93, 0],151.76],
        ["Land_MetalBarrel_F",[12.48, 22.29, 0],146.98],
        ["Land_CratesWooden_F",[11.46, 22.98, 0],312.94],
        ["Land_SatelliteAntenna_01_F",[-10.16, 24.18, 0],310.69],
        ["Land_PaperBox_closed_F",[7.06, 25.6, 0],64.34],
        ["Land_PaperBox_closed_F",[9.98, 24.9, 0],55.11],
        ["Land_MetalBarrel_F",[14.01, 23.88, 0],60],
        ["Land_Garbage_square5_F",[12.12, 25.11, 0],75],
        ["Land_CratesWooden_F",[14.39, 25.26, 0],210],
        ["Land_PaperBox_closed_F",[9.38, 27.65, 0],0],
        ["Land_GarbagePallet_F",[11.29, 27.6, 0],0],
        ["Land_HBarrierWall6_F",[3.24, 28.64, 0],182],
        ["Land_HBarrierWall6_F",[-5.17, 28.57, 0],182],
        ["Land_BagFence_Long_F",[13.38, 28.9, 0],0],
        ["Land_Cargo40_military_green_F",[17.87, 28.42, 0],46.37],
        ["Snake_random_F",[43.67, -6.96, 0],349.77]
    ],

    // Second emplacement
    [
        ["Land_Garbage_square5_F",[-1.42, 2.07, 0],86.95],
        ["Land_HBarrier_1_F",[2.82, -4.86, 0],150],
        ["Land_PaperBox_closed_F",[1.09, -5.75, 0],135],
        ["Land_BagFence_Long_F",[1.49, 6.32, 0],357.96],
        ["Land_BagFence_Round_F",[-1.17, 6.79, 0],47.96],
        ["Land_PowerGenerator_F",[0.96, 8.13, 0],210],
        ["Land_BagFence_Long_F",[2.83, 7.74, 0],87.96],
        ["Land_HBarrier_5_F",[2.88, -5.66, 0],78.74],
        ["Land_BagFence_Round_F",[-7.09, 4.25, 0],317.96],
        ["Land_Pallet_MilBoxes_F",[1.57, -9.04, 0],15],
        ["Land_BagFence_Long_F",[-6.64, 6.77, 0],87.96],
        ["Land_BagFence_End_F",[3.16, 9.97, 0],297.96],
        ["Land_Garbage_square5_F",[-3.51, -9.42, 0],0],
        ["Land_HBarrier_3_F",[-1.58, 11.19, 0],87.96],
        ["Land_MetalBarrel_F",[2.45, -10.12, 0],360],
        ["Land_BagFence_Round_F",[-9.78, 4.16, 0],32.96],
        ["Land_CampingTable_F",[-8.6, 6.17, 0],314.99],
        ["Land_HBarrier_Big_F",[8.84, -6.61, 0],87.96],
        ["Land_CampingChair_V1_F",[-8.73, 7.17, 0],240],
        ["Land_MetalBarrel_F",[2.83, -10.99, 0],60],
        ["Land_PaperBox_open_empty_F",[-8.3, -7.87, 0],150],
        ["Land_CampingChair_V1_F",[-9.59, 6.37, 0],344.98],
        ["Land_HBarrier_3_F",[1.3, 11.61, -0.74],177.96],
        ["Land_HBarrier_3_F",[-6.7, 10.88, 0],87.96],
        ["Land_Pallet_vertical_F",[-5.49, 10.57, 0],73.81],
        ["CamoNet_OPFOR_big_F",[-3, -11.11, 0],180],
        ["Land_CanisterFuel_F",[11.42, 3.66, 0],265.35],
        ["Land_CanisterOil_F",[11.74, 3.05, 0],205.41],
        ["Land_GasTank_02_F",[10.55, 6.73, 0],235.45],
        ["Land_CampingChair_V1_F",[-2.06, -12.51, 0],315.36],
        ["Land_WeldingTrolley_01_F",[11.38, 5.79, 0],10.47],
        ["Land_PlasticCase_01_small_F",[-5.33, 11.7, 0],244.96],
        ["Land_GarbagePallet_F",[-0.31, 12.82, 0],87.96],
        ["Land_ChairPlastic_F",[12.66, 2.25, 0],310.45],
        ["Land_HBarrier_5_F",[-10.75, -6.64, 0],61.52],
        ["Land_CampingChair_V2_F",[-4.72, 12.09, 0],87.95],
        ["Land_Garbage_square5_F",[-3.9, 12.33, 0],87.96],
        ["Land_BagFence_Long_F",[-11.85, 5.32, 0],177.96],
        ["Land_GasTank_02_F",[11.03, 7.02, 0],265.46],
        ["Land_CampingTable_F",[-1.9, -13.12, 0],311.6],
        ["Land_ChairPlastic_F",[9.27, 9.55, 0],104.96],
        ["Land_CampingChair_V1_F",[-3.02, -13.19, 0],285.11],
        ["Land_Sacks_heap_F",[-12.62, -5.28, 0],345.95],
        ["Land_WoodenTable_large_F",[-5.33, 12.7, 0],177.95],
        ["Land_SatelliteAntenna_01_F",[-11.95, 6.79, 0],237.81],
        ["Land_CncBarrier_F",[13.4, -3.33, 0],339.2],
        ["Land_CampingChair_V2_F",[-4.75, 12.97, 0],87.95],
        ["Land_Workbench_01_F",[10.47, 9.35, 0],265.21],
        ["Land_MetalBarrel_empty_F",[-8.92, -10.99, 0],45],
        ["Land_PaperBox_closed_F",[-11.93, -7.86, 0],330],
        ["Land_BagFence_Long_F",[-13.27, 6.66, 0],87.96],
        ["Box_East_AmmoOrd_F",[0.45, -15.24, 0],224.98],
        ["Land_BarrelTrash_F",[1.08, -15.37, -0.05],360],
        ["Land_BagFence_End_F",[-13.75, 8.89, 0],237.96],
        ["CamoNet_INDP_F",[-1.78, 15.85, 0],87.96],
        ["Oil_Spill_F",[15.31, 5.39, 0],265.46],
        ["Land_HBarrier_Big_F",[1.06, 15.96, 0],87.96],
        ["Land_Sacks_goods_F",[-0.74, 16.1, 0],177.96],
        ["Land_HBarrier_1_F",[0.82, -16.61, 0],165],
        ["Land_EngineCrane_01_F",[16.32, 3.55, 0],130.46],
        ["Land_CncBarrier_F",[17.24, -0.67, 0],300.72],
        ["Land_Cargo_House_V3_F",[5.9, 15.95, 0],266.97],
        ["Land_HBarrier_3_F",[-2.94, -17.02, 0],176.05],
        ["Land_BagFence_End_F",[1.19, -17.54, 0],345],
        ["Land_BagFence_Long_F",[-0.93, -17.73, 0],0],
        ["Land_HBarrier_Big_F",[9.37, -15.22, 0],87.96],
        ["Land_BagFence_End_F",[-3.3, -17.76, 0],180],
        ["Land_Tyre_F",[-2.31, 18.18, 0],87.94],
        ["Land_PaperBox_open_empty_F",[-1.07, 18.48, 0],79.96],
        ["Land_CncBarrier_F",[18.16, 3.95, 0],85.46],
        ["Land_BagFence_Long_F",[-7.23, -17.3, 0],180],
        ["Land_HBarrier_1_F",[-8.74, -17.03, 0],120],
        ["Land_BagFence_Long_F",[-15.7, -11.71, 0],265.44],
        ["Land_HBarrierTower_F",[-10.62, 16.5, 0],179.22],
        ["Land_Pipes_small_F",[-3.87, 19.24, 0],177.96],
        ["Snake_random_F",[5.26, -18.95, 0],2.49],
        ["Land_CncBarrier_F",[17.86, 9.31, 0],85.46],
        ["Land_GarbageHeap_04_F",[2.49, 19.96, 0],74.88],
        ["Land_CncBarrier_F",[16.32, 12.14, 0],38.28],
        ["Land_CncShelter_F",[-17.21, -10.81, 0],174.78],
        ["Land_HBarrier_5_F",[-3.26, 20.39, 0],357.96],
        ["Land_WaterBarrel_F",[-14.55, -14.52, 0],105],
        ["Land_Sacks_heap_F",[6.32, 19.8, 0],255],
        ["Land_HBarrier_3_F",[-6.5, 20.26, 0],357.96],
        ["Land_FieldToilet_F",[-20.8, 3.14, 0],267.48],
        ["Land_CncShelter_F",[-17.06, -12.45, 0],174.78],
        ["Land_BagFence_Long_F",[-15.45, -14.68, 0],265.44],
        ["Land_MetalBarrel_F",[-20.3, -6.78, 0],55.87],
        ["Land_HBarrier_Big_F",[-2.08, -21.41, 0],177.6],
        ["Land_FieldToilet_F",[-21, 5.2, 0],293.2],
        ["Land_WoodenCrate_01_stack_x5_F",[-10.94, -18.78, 0],121],
        ["Land_MetalBarrel_F",[-20.95, -6.18, 0],25.88],
        ["Land_HBarrier_Big_F",[6.36, -20.91, 0],177.6],
        ["Land_CncShelter_F",[-16.98, -14.07, 0],174.78],
        ["Land_MetalBarrel_F",[-21.01, -7.12, 0],261.02],
        ["Land_BagFence_Long_F",[-18.59, -12.17, 0],265.44],
        ["Land_MetalBarrel_F",[-20.86, -8.21, 0],231.03],
        ["Land_Razorwire_F",[0.79, 22.75, 0],0],
        ["Land_CncShelter_F",[-16.82, -15.71, 0],174.78],
        ["Land_WoodenCrate_01_F",[-12.97, -19.31, 0],31],
        ["Land_Razorwire_F",[-7.45, 22.57, 0],357.96],
        ["Land_HBarrier_Big_F",[-20.65, 11.18, 0],177.6],
        ["Land_PortableLight_double_F",[-22.03, 8.64, 0],328.61],
        ["Land_BagFence_Long_F",[-18.33, -15.01, 0],263.42],
        ["Land_HBarrierTower_F",[-24.21, -1.95, 0],87.43],
        ["Land_HBarrier_Big_F",[-10.44, -21.82, 0],177.6],
        ["Land_HBarrier_Big_F",[-17.86, 16.66, 0],87.96],
        ["Land_HBarrier_Big_F",[-23.75, 5.9, 0],87.96],
        ["Land_HBarrier_Big_F",[-22.9, -9.41, 0],87.96],
        ["Land_HBarrier_3_F",[-16.74, 20.18, 0],357.96],
        ["Land_Razorwire_F",[-15.81, 22.14, 0],357.96],
        ["Land_PortableLight_double_F",[-20.43, -19.55, 0],221.21],
        ["Land_HBarrier_Big_F",[-22.45, -17.65, 0],87.96],
        ["Land_HBarrier_Big_F",[-18.8, -22.46, 0],177.6]
    ]
];



	//==========END Composition Objects==========//
	
//==========ZONE CREATION LOGIC==========//
//never edit this section
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
			_finalTerrainCheck = _safePos isFlatEmpty [40, -1, 0.5, 15, 0, false];
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
							_testFlat = _testPos isFlatEmpty [30, -1, 0.4, 10, 0, false];
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
					private _veryRelaxedCheck = _safePos isFlatEmpty [20, -1, 0.8, 5, 0, false];
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

		private _numVehicles = 2 + floor random ((3 - 1) + 1);

		for "_v" from 1 to _numVehicles do {
			private _vehClass = selectRandom _vehicleTypes;
			private _vehPos = [];
			private _vehFound = false;
			private _vehDir = random 360;

			for "_t" from 1 to 20 do {
				private _dist = if (_vehClass isKindOf "Helicopter") then { 60 + random 40 } else { 35 + random 40 };
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
			private _patrolRadius = 10 + random (200 - 80);
			private _numPatrolWaypoints = 3 + floor random ((4 - 2) + 1);

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
		_objectData set ["veh10", ["RuggedTerminal_01_communications_F", "Capture F.O.B.", [5, 30]]];

		private _basePosition = _campPos; 

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
									_caller sideChat format ["Objective Complete: F.O.B. Captured", _actionText];
									nul = [] execVM "missionCompleteScreen.sqf";
									
									//add xp/coins
									[500] execVM "addXP.sqf";
									[10] execVM "addCredits.sqf";

									//-1 side mission from fobSystems.sqf
									private _currentActiveMissions = missionNamespace getVariable ["activeSideMissions", 0];
									missionNamespace setVariable ["activeSideMissions", _currentActiveMissions - 1, true];
									
									// Remove the action using the stored actionId
									_target removeAction _actionId;
								},
								nil,
								101,
								true,
								true,
								"",
								"true"
							];
							
							_obj setVariable ["actionId", _actionId, true]; 
							_obj setVariable ["actionText", _actionText, true]; // Still useful for the sideChat message
						};
					};
				};
			};
		};
		
		// === End Object Spawn System === //
		

		//ARSENAL BOX SPAWNER - SIMPLIFIED VERSION
		// Make sure _campPos is defined before running this script
		// If not defined, uncomment the line below and set your position
		// _campPos = getPos player; // or your desired position

		// Define spawn position around camp
		private _spawnDistance = 15; // meters from camp position
		private _spawnAngle = random 360;
		private _spawnPos = _campPos getPos [_spawnDistance, _spawnAngle];

		// Create the box
		private _arsenalBox = createVehicle ["B_CargoNet_01_ammo_F", _spawnPos, [], 0, "NONE"];

		// Make sure the box is on the ground
		_arsenalBox setPosATL [getPosATL _arsenalBox select 0, getPosATL _arsenalBox select 1, 0];

		// Set random direction
		_arsenalBox setDir (random 360);

		// Make the box indestructible (optional)
		_arsenalBox allowDamage true;

		// Add Virtual Arsenal action
		_arsenalBox addAction [
			"<t color='#FF0000' size='1.2'>Virtual Arsenal</t>",
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				["Open", [true]] call BIS_fnc_arsenal;
			},
			nil,
			150,
			true,
			true,
			"",
			"true",
			3
		];


		// Store the box in a variable for later reference (optional)
		arsenalBox = _arsenalBox;
		
			// === Start Crewed Vehicle Spawn System === //
		private _objectData = createHashMap;

		//script ref(needed), obj file name, add action(leave empty to remove), spawn range min,max
		_objectData set ["aa1", ["I_LT_01_AA_F", "", [30, 60]]];
		private _basePosition = _campPos;

		// Min and max number of objects to spawn
		private _minObjectsToSpawn = 0;
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
		// === End Crewed Vehicle Spawn System === //



		//==========End New Systems Here==========//

		_spawned = true;
		player sideChat "New Objective: Capture the F.O.B.";
		nul = [] execVM "missionBriefings\fobMissionBrief.sqf";
		
			};
};