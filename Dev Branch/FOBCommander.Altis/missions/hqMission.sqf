//==========General Settings ==========//

private _markerNameText = "H.Q.";
private _markerType = "o_hq";


//Static Groups
private _staticGroupSizeMin = 6; //Default 2
private _staticGroupSizeMax = 10; //Default 8
private _staticGroupCountMin = 2; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 4; //Default 1
private _patrolSizeMax = 8; //Default 6
private _patrolGroupCountMin = 2; //Default 0
private _patrolGroupCountMax = 2; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 1; //Default 0.2
private _staticWeaponChance = 1; //Default 0.3

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
    // First emplacement variant
    [
        ["MapBoard_altis_F", [2.55, 4.51, 0], 8.09],
        ["Item_ToolKit", [5.10, 3.54, 0], 105.54],
        ["Headgear_H_Construction_basic_white_F", [5.63, 3.24, 0.82], 136.54],
        ["Headgear_H_Construction_basic_orange_F", [5.88, 3.35, 0.82], 358.54],
        ["Land_WaterBottle_01_stack_F", [-2.13, -6.52, 0.01], 305.61],
        ["Land_CampingTable_white_F", [6.24, 3.27, 0], 20.54],
        ["Land_Sacks_heap_F", [-6.34, 3.72, 0], 301.63],
        ["Vest_V_EOD_IDAP_blue_F", [6.75, 2.95, 0], 133.54],
        ["Land_CampingChair_V2_white_F", [6.13, 4.38, 0], 6.53],
        ["Item_MineDetector", [7.01, 3.28, 0], 163.54],
        ["Land_FirstAidKit_01_closed_F", [7.30, 2.88, 0], 284.53],
        ["Item_FirstAidKit", [7.39, 3.21, 0], 80.54],
        ["Land_CampingChair_V2_white_F", [7.07, 3.94, 0], 36.53],
        ["Land_PaperBox_01_open_water_F", [-4.06, -7.06, 0], 0.00],
        ["Land_Sacks_heap_F", [-7.13, 4.35, 0], 211.63],
        ["Land_IntravenStand_01_1bag_F", [5.88, 5.98, 0], 90.00],
        ["Land_CratesPlastic_F", [-7.76, 3.56, 0], 31.63],
        ["Land_DisinfectantSpray_F", [6.06, 6.26, 0], 224.89],
        ["Land_Stretcher_01_olive_F", [5.10, 7.19, 0], 180.00],
        ["MedicalGarbage_01_1x1_v1_F", [6.06, 6.65, 0], 90.00],
        ["BloodSplatter_01_Medium_New_F", [6.26, 6.68, 0], 90.00],
        ["MedicalGarbage_01_5x5_v1_F", [5.89, 6.99, 0], 90.00],
        ["Land_Bodybag_01_folded_white_F", [6.48, 6.74, -0.02], 240.00],
        ["MedicalGarbage_01_1x1_v3_F", [5.45, 8.01, 0], 300.00],
        ["Land_Stretcher_01_olive_F", [6.45, 7.21, 0], 180.00],
        ["Land_BarrelWater_grey_F", [-6.13, -7.92, 0], 360.00],
        ["Land_CampingChair_V2_F", [-7.00, -7.53, 0.01], 1.15],
        ["Land_PencilBlue_F", [-6.93, -7.74, 0], 119.93],
        ["Land_HBarrier_Big_F", [-4.09, -9.38, 0], 178.92],
        ["Land_PencilRed_F", [-6.94, -7.79, 0], 134.95],
        ["Land_Cargo10_military_green_F", [10.31, -1.27, 0], 320.58],
        ["Land_IntravenStand_01_1bag_F", [9.00, 5.59, 0], 127.71],
        ["Newspaper_01_F", [-7.13, -7.92, 0], 120.19],
        ["Land_PaperBox_open_empty_F", [10.65, 1.71, 0], 299.84],
        ["Land_CampingChair_V2_F", [-8.01, -7.40, 0], 345.31],
        ["Land_DisinfectantSpray_F", [9.31, 5.71, 0], 262.71],
        ["Land_CampingTable_F", [-7.50, -7.93, 0], 1.19],
        ["Land_Ammobox_rounds_F", [-7.90, -7.87, 0], 45.44],
        ["MedicalGarbage_01_1x1_v1_F", [9.55, 6.00, 0], 127.73],
        ["BloodSplatter_01_Medium_New_F", [9.72, 5.91, 0], 127.73],
        ["Land_Ammobox_rounds_F", [-8.18, -8.02, 0], 255.00],
        ["Land_Stretcher_01_olive_F", [9.12, 7.02, 0], 217.73],
        ["Land_Bodybag_01_folded_white_F", [9.94, 5.82, -0.02], 277.73],
        ["MedicalGarbage_01_5x5_v1_F", [9.63, 6.38, 0], 127.73],
        ["Land_BagFence_Long_F", [0.00, -11.57, 0], 84.96],
        ["Land_Cargo_HQ_V3_F", [-4.85, 10.91, 0], 265.60],
        ["Land_Cargo20_grey_F", [10.37, -5.34, 0], 0.00],
        ["Land_Stretcher_01_olive_F", [10.20, 6.21, 0], 217.73],
        ["Land_PaperBox_closed_F", [-2.93, -11.66, 0], 312.07],
        ["MedicalGarbage_01_1x1_v3_F", [9.89, 7.46, 0], 337.73],
        ["Land_HBarrierWall6_F", [6.41, 11.71, 0], 0.00],
        ["Land_PaperBox_open_empty_F", [12.65, 2.84, 0], 177.07],
        ["Land_PaperBox_open_empty_F", [-10.86, -7.47, 0], 335.48],
        ["Land_CratesWooden_F", [-5.27, -12.28, 0], 12.07],
        ["Land_Pallet_MilBoxes_F", [-12.10, 7.53, 0], 328.85],
        ["Land_FieldToilet_F", [-14.29, 1.75, 0], 282.25],
        ["Land_BagFence_Long_F", [9.37, -11.23, 0], 84.96],
        ["Land_PaperBox_closed_F", [-12.77, -7.56, 0], 275.48],
        ["Land_FieldToilet_F", [-14.22, 4.31, 0], 266.65],
        ["Land_PlasticBucket_01_open_F", [-8.66, -12.16, 0], 180.00],
        ["Land_HBarrierWall6_F", [15.77, -2.91, 0], 90.17],
        ["Land_CanisterFuel_F", [-9.91, -11.41, 0], 344.96],
        ["Land_HBarrierWall6_F", [15.46, 5.41, 0], 90.17],
        ["Land_ToolTrolley_02_F", [-9.54, -12.04, 0], 285.00],
        ["Land_Rope_01_F", [-9.04, -12.54, 0], 135.00],
        ["Land_HBarrier_Big_F", [13.12, -8.60, 0], 178.92],
        ["Land_Pallet_MilBoxes_F", [-14.17, 6.77, 0], 55.66],
        ["Land_MetalWire_F", [-10.16, -12.16, 0], 315.00],
        ["Land_Wrench_F", [-9.73, -12.52, 0], 60.00],
        ["Land_HBarrier_Big_F", [-12.77, -9.79, 0], 178.92],
        ["Land_PaperBox_open_empty_F", [5.83, 16.24, 0], 201.20],
        ["Land_HBarrier_Big_F", [-16.94, 4.13, 0], 88.88],
        ["Land_GarbageContainer_open_F", [-11.94, 12.74, 0.34], 264.03],
        ["Land_HBarrier_Big_F", [-14.29, 10.09, 0], 175.43],
        ["Land_HBarrierWall_corner_F", [13.67, 10.98, 0], 0.00],
        ["Oil_Spill_F", [-11.95, -14.03, 0], 180.00],
        ["Land_MetalCase_01_small_F", [-10.91, -15.41, 0], 45.00],
        ["Land_PaperBox_open_full_F", [8.83, 16.70, 0], 285.00],
        ["Land_PaperBox_01_small_stacked_F", [-0.48, -19.23, 0], 13.69],
        ["Land_PaperBox_closed_F", [5.99, 18.34, 0], 270.00],
        ["Land_Tyres_F", [-13.17, 14.41, 0.01], 255.00],
        ["Land_Garbage_square5_F", [-13.83, 14.68, 0], 0.00],
        ["CamoNet_OPFOR_open_F", [9.76, 18.21, 0], 181.17],
        ["Land_Cargo_Patrol_V3_F", [-20.56, -5.13, 0], 86.72],
        ["Land_PaperBox_open_empty_F", [9.46, 18.35, 0], 30.00],
        ["Land_MetalBarrel_F", [6.25, 19.72, 0], 360.00],
        ["Land_MetalBarrel_F", [8.45, 19.20, 0], 360.00],
        ["Land_Sacks_heap_F", [15.61, -14.14, 0], 138.84],
        ["Land_Bucket_clean_F", [-9.04, -19.18, 0], 180.00],
        ["Land_CanisterFuel_F", [-8.66, -19.68, 0], 164.97],
        ["Land_Tyre_F", [-14.00, 16.48, 0], 0.01],
        ["Land_Hammer_F", [-9.42, -19.55, -0.01], 135.04],
        ["Land_DuctTape_F", [-9.76, -19.61, 0], 180.01],
        ["Land_HBarrier_Big_F", [-21.85, 0.58, 0], 178.92],
        ["Land_JunkPile_F", [18.38, 12.07, 0], 258.52],
        ["Land_CampingChair_V2_F", [13.52, 17.26, 0], 225.00],
        ["Land_CinderBlocks_F", [17.68, -12.97, 0], 79.12],
        ["Land_MetalBarrel_F", [7.16, 20.73, 0], 353.28],
        ["Land_CanisterPlastic_F", [-9.17, -20.18, 0], 150.00],
        ["Land_Wrench_F", [-9.79, -19.93, 0], 15.00],
        ["Land_Sacks_heap_F", [17.05, -14.37, -0.35], 213.84, 1],
        ["Land_WoodenTable_large_F", [13.52, 18.08, 0], 300.00],
        ["Land_CampingChair_V2_F", [13.40, 19.06, 0], 360.00],
        ["Land_CinderBlocks_F", [19.20, -14.22, 0], 19.15],
        ["Land_LampHalogen_F", [19.21, -12.88, 0], 40.57],
        ["Land_CanisterFuel_F", [18.30, -15.37, 0], 184.09],
        ["Land_Razorwire_F", [20.02, -9.74, 0], 44.63],
        ["Land_HBarrier_Big_F", [-21.54, -10.16, 0], 178.92],
        ["Land_LampHalogen_F", [-18.46, 14.12, 0], 224.68],
        ["Land_CanisterFuel_F", [18.41, -15.78, 0], 214.09],
        ["Land_HBarrierWall6_F", [-25.16, -5.54, 0], 268.92],
        ["Land_Tank_rust_F", [18.48, 16.49, 0], 99.90],
        ["Land_Pallet_vertical_F", [19.84, -14.98, 0], 289.16],
        ["Land_BagBunker_Large_F", [-3.02, -25.26, 0], 358.68],
        ["Land_CratesPlastic_F", [-11.52, -22.46, 0], 90.11],
        ["CamoNet_OPFOR_big_F", [25.50, 0.91, -0.73], 268.68],
        ["Land_GarbagePallet_F", [-9.89, -23.86, 0], 60.11],
        ["Land_Razorwire_F", [-20.29, -16.58, 0], 222.58],
        ["Land_PaperBox_closed_F", [26.29, 5.92, 0], 0.00],
        ["Land_Garbage_square5_F", [-11.27, -24.75, 0], 60.11],
        ["Land_Pallets_F", [-10.76, -25.30, 0], 105.11],
        ["Land_Razorwire_F", [-15.73, -23.88, 0], 241.96],
        ["Land_Bricks_V2_F", [22.50, 16.70, 0], 277.08],
        ["Land_Pallet_F", [28.03, -3.19, 0], 105.00],
        ["Land_Bricks_V4_F", [23.50, 15.68, 0], 322.08],
        ["Land_BagBunker_Large_F", [15.17, -24.53, 0], 357.31],
        ["Land_Pallets_stack_F", [25.30, 12.93, 0], 337.08],
        ["Land_Pallets_stack_F", [27.44, 7.68, 0], 60.00],
        ["Land_WaterBarrel_F", [28.39, 5.64, 0], 360.00],
        ["Land_Garbage_square5_F", [24.54, 15.58, 0], 277.08],
        ["Land_Cargo_House_V3_F", [28.13, 1.37, 0], 267.31],
        ["Land_Razorwire_F", [24.16, -17.13, 0], 84.35],
        ["Land_Razorwire_F", [-9.87, -30.56, 0], 224.05],
        ["Land_WorkStand_F", [25.77, 17.88, 0], 217.08],
        ["Land_WheelCart_F", [28.44, 14.93, 0.00], 232.10],
        ["Land_GarbageContainer_closed_F", [-24.15, 21.92, -0.22], 342.12],
        ["Land_Razorwire_F", [-4.48, -32.60, 0], 0.00],
        ["Snake_random_F", [32.38, 7.06, 0.01], 284.61],
        ["Land_Garbage_square5_F", [33.93, 7.22, 0], 0.00],
        ["Land_Razorwire_F", [23.76, -25.84, 0], 109.76],
        ["Land_Razorwire_F", [18.67, -32.29, 0], 174.35],
        ["Snake_random_F", [35.92, -19.52, 0.01], 163.12],
        ["Snake_random_F", [38.17, -15.92, 0.01], 185.62],
        ["Rabbit_F", [38.66, 25.62, 0], 85.79]
    ],
    // Second emplacement variant
    [
        ["Land_Cargo_House_V3_F", [-5.99, 2.57, 0], 356.81],
        ["Land_CampingChair_V2_F", [7.38, 0.80, 0], 266.08],
        ["CBRNContainer_01_closed_olive_F", [7.68, -0.23, 0], 44.36],
        ["Land_DuctTape_F", [7.85, 0.32, 0], 296.32],
        ["Land_CargoBox_V1_F", [-7.97, -0.38, 0.03], 138.14],
        ["Land_CampingChair_V2_F", [7.83, 1.70, 0.00], 311.42],
        ["Land_DisinfectantSpray_F", [8.04, 0.79, 0], 71.24],
        ["Land_DuctTape_F", [8.07, 0.57, 0], 311.32],
        ["Land_CampingTable_F", [8.08, 0.99, 0], 293.39],
        ["Land_PlasticCase_01_small_idap_F", [8.39, 1.42, 0], 26.31],
        ["Land_Sack_F", [8.53, -0.62, 0], 284.40],
        ["Land_FireExtinguisher_F", [8.67, 1.98, 0], 356.31],
        ["Land_CampingTable_F", [9.02, 0.58, 0], 119.40],
        ["CBRNContainer_01_closed_olive_F", [9.15, 0.78, 0.02], 119.52],
        ["Land_EmergencyBlanket_01_F", [9.21, 0.91, 0.00], 14.29],
        ["MedicalGarbage_01_Gloves_F", [9.29, 0.15, 0], 344.40],
        ["Land_Bucket_F", [9.29, 1.30, 0], 119.37],
        ["Land_HBarrier_Big_F", [-5.90, 7.40, 0], 178.92],
        ["Land_Sack_F", [8.23, 5.26, 0], 136.50],
        ["Land_Sack_F", [7.68, 6.18, 0], 226.35],
        ["Land_CratesShabby_F", [-7.08, -6.91, 0], 180.69],
        ["Land_PaperBox_closed_F", [-8.28, -5.66, 0], 0.69],
        ["Land_PaperBox_open_full_F", [-2.80, 10.09, 0], 285.79],
        ["Land_Sack_F", [8.64, 6.03, 0], 190.87],
        ["Land_CratesShabby_F", [-7.22, -7.93, 0], 0.69],
        ["Land_Sack_F", [10.43, 3.86, 0], 348.08],
        ["MedicalGarbage_01_Gloves_F", [9.57, 5.82, 0], 48.08],
        ["Land_Pallet_MilBoxes_F", [-5.13, 10.09, 0], 291.70],
        ["Land_Sack_F", [10.24, 4.96, 0], 118.89],
        ["Land_HBarrier_Big_F", [-11.03, 2.94, 0], 87.20],
        ["Land_CratesWooden_F", [-8.29, -7.84, 0], 90.69],
        ["Land_CanisterFuel_F", [-2.21, 11.31, 0], 24.23],
        ["Land_CampingChair_V2_F", [11.07, 3.35, 0], 198.07],
        ["Land_HBarrier_Big_F", [-10.43, -5.58, 0], 87.20],
        ["Land_MetalBarrel_F", [-2.99, 11.50, 0], 69.35],
        ["Land_CanisterFuel_F", [-2.17, 11.74, 0], 54.26],
        ["Land_MetalBarrel_F", [-3.77, 11.33, 0], 354.35],
        ["Land_DuctTape_F", [10.98, 4.88, 0], 0.00],
        ["Land_DuctTape_F", [11.29, 4.79, 0], 15.00],
        ["Land_CampingTable_F", [11.73, 3.94, 0], 183.12],
        ["Land_CampingChair_V2_F", [11.20, 5.50, 0], 330.09],
        ["Land_DisinfectantSpray_F", [11.48, 4.92, 0], 134.71],
        ["CBRNContainer_01_closed_olive_F", [11.86, 4.09, 0.01], 178.66],
        ["Land_CampingTable_F", [11.68, 4.96, 0], 356.92],
        ["Land_EmergencyBlanket_01_F", [12.11, 3.92, 0.00], 77.94],
        ["MedicalGarbage_01_Gloves_F", [12.35, 3.24, 0], 48.08],
        ["CBRNContainer_01_closed_olive_F", [12.24, 3.69, 0.02], 114.23],
        ["Land_GarbageHeap_04_F", [-12.79, 0.61, -0.17], 71.52],
        ["Land_Pallet_MilBoxes_F", [-8.06, 10.31, 0], 287.37],
        ["Land_Bucket_F", [12.48, 4.02, 0], 183.05],
        ["Land_Pallet_F", [-12.91, -2.33, 0], 294.29],
        ["Land_PlasticCase_01_small_idap_F", [12.20, 4.88, 0], 90.00],
        ["Land_Cargo_HQ_V3_F", [9.13, -8.83, 0], 357.43],
        ["Land_Pallet_MilBoxes_F", [-4.35, 12.47, 0], 55.66],
        ["Land_CampingChair_V2_F", [12.20, 5.51, 0], 14.83],
        ["Land_Pallet_MilBoxes_F", [-6.45, 11.93, 0], 55.66],
        ["Land_HBarrier_Big_F", [11.14, 8.04, 0], 178.92],
        ["Land_PalletTrolley_01_khaki_F", [-13.05, -4.68, 0], 216.31],
        ["Land_Garbage_square3_F", [-13.64, 2.46, 0], 71.52],
        ["Land_GarbagePallet_F", [-14.46, 0.36, 0], 9.49],
        ["Snake_random_F", [6.01, 13.33, 0], 32.71],
        ["Land_GarbageBags_F", [15.68, 2.37, 0], 203.95],
        ["Land_GarbageBags_F", [14.63, -1.75, 0], 0.00],
        ["Land_Pallets_F", [-7.49, 12.07, 0], 279.08],
        ["Land_Pallets_stack_F", [-6.85, 13.96, 0.01], 138.61],
        ["Land_Pallets_F", [-11.54, -11.15, 0], 330.00],
        ["Land_Pallet_MilBoxes_F", [-4.78, 14.84, 0], 173.09],
        ["Land_HBarrier_Big_F", [-11.58, 11.44, 0], 87.20],
        ["Land_Pallets_stack_F", [-8.83, 14.29, 0.01], 94.98],
        ["Land_Garbage_square3_F", [-16.85, 1.17, 0], 71.52],
        ["Land_HBarrierWall6_F", [0.82, 18.17, 0], 357.31],
        ["Land_HBarrierWall6_F", [18.25, 1.48, 0], 82.86],
        ["Land_HBarrierWall6_F", [-7.49, 17.49, 0], 357.31],
        ["Land_Cargo_Patrol_V3_F", [12.43, 14.23, 0], 259.72],
        ["Land_HBarrier_Big_F", [-2.50, -18.44, 0], 178.92],
        ["Land_HBarrier_Big_F", [16.54, 9.37, 0], 87.20],
        ["Land_HBarrier_Big_F", [6.03, -18.09, 0], 178.92],
        ["Land_HBarrierWall6_F", [19.58, -6.92, 0], 87.63],
        ["Land_BagBunker_Large_F", [-17.25, 10.72, 0], 177.19],
        ["Land_WoodenBox_F", [-19.96, 5.47, 0], 178.18],
        ["Land_HBarrierWall6_F", [9.01, 19.88, 0], 344.34],
        ["Land_HBarrier_Big_F", [-11.06, -18.85, 0], 178.92],
        ["Land_Razorwire_F", [1.28, 22.20, 0], 174.42],
        ["Land_Razorwire_F", [-7.43, 21.07, 0], 167.30],
        ["MapBoard_altis_F", [-0.25, -22.68, 0], 52.49],
        ["Land_Pallet_MilBoxes_F", [-3.96, -22.87, 0], 55.66],
        ["Land_PaperBox_closed_F", [-18.59, -13.79, 0], 285.07],
        ["Land_HBarrier_Big_F", [14.41, -18.31, 0], 7.65],
        ["Land_BagFence_Long_F", [-9.54, -21.47, 0], 92.00],
        ["Land_HBarrier_Big_F", [15.30, 18.01, 0], 77.49],
        ["Land_Cargo40_light_blue_F", [23.25, -5.54, 0], 76.28],
        ["Land_Cargo40_white_F", [24.10, 2.47, 0], 230.18],
        ["Land_Sacks_goods_F", [8.06, -22.95, 0], 278.16],
        ["Land_HBarrierWall6_F", [20.05, -15.26, 0], 100.35],
        ["Land_MetalBarrel_F", [-22.17, -11.09, 0], 105.13],
        ["CamoNet_OPFOR_open_F", [-2.33, -24.10, 0], 181.17],
        ["Land_Cages_F", [-21.00, -13.32, 0], 345.00],
        ["Land_MetalBarrel_F", [-22.09, -12.06, 0], 360.00],
        ["Land_Razorwire_F", [-16.09, 17.90, 0], 174.42],
        ["Land_MetalBarrel_F", [-22.84, -11.18, 0], 30.00],
        ["Land_HBarrier_Big_F", [-19.05, -17.00, 0], 29.41],
        ["Land_Razorwire_F", [7.11, 23.70, 0], 351.61],
        ["Land_Pipes_small_F", [-6.39, -24.89, 0], 75.00],
        ["Land_MetalBarrel_F", [-22.34, -12.81, 0], 360.00],
        ["Land_MetalBarrel_F", [-22.79, -12.04, 0], 239.28],
        ["Land_BagFence_Long_F", [-9.65, -24.27, 0], 92.00],
        ["Land_Sacks_goods_F", [7.42, -25.09, 0], 143.69],
        ["Land_WoodenBox_F", [14.88, -22.08, 0], 155.87],
        ["Land_Pallet_vertical_F", [10.92, -24.30, 0.00], 159.16],
        ["Land_WoodenBox_F", [2.16, -26.87, 0], 105.00],
        ["Land_WoodenBox_F", [1.04, -26.99, 0], 300.00],
        ["Land_HBarrier_Big_F", [-24.75, -11.24, 0], 65.96],
        ["Land_Pallet_vertical_F", [10.04, -25.20, 0], 263.90],
        ["CamoNet_OPFOR_open_F", [11.98, -23.75, -0.73], 181.17],
        ["Land_CratesWooden_F", [11.43, -24.95, 0], 339.70],
        ["Land_IronPipes_F", [-11.85, -25.03, 0], 90.00],
        ["Land_Sacks_goods_F", [8.41, -26.27, 0], 85.86],
        ["Land_HBarrier_Big_F", [-27.49, -3.11, 0], 80.75],
        ["Land_PaperBox_closed_F", [14.96, -23.62, 0], 0.00],
        ["Land_Garbage_square5_F", [15.15, -23.95, 0], 135.00],
        ["Land_Razorwire_F", [-18.91, -20.57, 0], 210.16],
        ["Land_Pallet_vertical_F", [16.14, -23.31, 0], 85.49],
        ["Land_Tyre_F", [10.25, -26.46, 0], 249.78],
        ["Land_CratesPlastic_F", [11.00, -26.31, 0], 339.70],
        ["Land_BagFence_Long_F", [-9.72, -27.24, 0], 92.00],
        ["Land_BagFence_Long_F", [19.66, -21.34, 0], 92.00],
        ["Land_MobileScafolding_01_F", [-14.14, -25.66, 0], 75.00],
        ["Land_Coil_F", [-27.02, 11.79, 0], 0.00],
        ["Land_Razorwire_F", [-26.34, -13.87, 0], 237.73],
        ["Land_PaperBox_closed_F", [13.45, -26.78, 0], 205.14],
        ["Snake_random_F", [29.95, -3.25, 0.01], 214.12],
        ["Land_Razorwire_F", [-29.79, -5.27, -0.68], 255.94, 1],
        ["Land_LampHalogen_F", [15.67, 25.72, 0], 289.36],
        ["Land_PaperBox_closed_F", [15.77, -26.72, 0], 75.00],
        ["Land_BagFence_Long_F", [19.54, -24.15, 0], 92.00],
        ["Land_WorkStand_F", [-5.03, -30.68, 0], 195.00],
        ["Land_ConcretePipe_F", [-26.72, 15.92, -0.05], 235.04],
        ["Land_LampHalogen_F", [-18.53, -25.06, 0], 123.19],
        ["Land_CargoBox_V1_F", [-31.61, -6.09, 0.03], 198.97],
        ["Land_CargoBox_V1_F", [-32.71, -3.79, 0.03], 138.14],
        ["Land_BagFence_Long_F", [-27.23, 19.01, 0], 164.92],
        ["Land_BagFence_Long_F", [19.48, -27.11, 0], 92.00],
        ["Land_LampHalogen_F", [25.54, -21.55, 0], 33.11],
        ["Land_BagFence_Long_F", [-29.79, 17.63, 0], 137.28],
        ["Land_BagFence_Long_F", [-31.83, 15.47, 0], 127.26],
        ["Land_BagFence_Long_F", [-34.07, 9.77, 0], 98.26],
        ["Land_BagFence_Long_F", [-33.34, 12.76, 0], 112.65],
        ["Rabbit_F", [13.67, 33.42, 0], 292.91]
    ],
	 [
        ["Land_Suitcase_F",[-1.42773,5.24805,2.47955e-05],89.9796],
        ["Land_CampingTable_F",[-2.55469,5.12305,-0.000718117],359.905],
        ["Land_PlasticCase_01_small_black_CBRN_F",[-2.92773,4.99805,0],75],
        ["Land_CampingChair_V2_F",[-2.17773,5.74805,-2.38419e-06],314.997],
        ["Land_CampingChair_V2_F",[-3.05273,5.625,0.000328541],345.049],
        ["Land_Pallets_F",[-5.5,-7.08203,0],40.5019],
        ["Land_CampingChair_V2_F",[-8.38281,3.11133,3.33786e-06],95.0942],
        ["Land_CampingChair_V2_F",[-8.91602,1.55273,4.05312e-06],121.437],
        ["Land_Pallets_stack_F",[-3.49023,-8.43164,-2.38419e-07],36.9034],
        ["Land_CampingChair_V2_F",[-8.96875,4.04883,-1.90735e-06],86.8729],
        ["Land_Pallets_stack_F",[-6.375,-7.95117,0],178.493],
        ["Land_CampingChair_V2_F",[-8.73438,5.41797,-2.14577e-06],53.7419],
        ["Land_CampingChair_V2_F",[-10.0684,2.79492,-2.38419e-06],102.764],
        ["Land_WeldingTrolley_01_F",[0.544922,-11.1406,9.53674e-07],321.431],
        ["Land_CampingChair_V2_F",[-10.5078,4.75195,2.14577e-06],76.2371],
        ["Land_FoodSacks_01_cargo_white_idap_F",[9.70117,6.53125,0],281.942],
        ["Land_Sacks_heap_F",[-8.51758,-8.06055,0],150],
        ["Land_BagBunker_Large_F",[12.6055,-1.96875,4.76837e-07],266.036],
        ["Land_HBarrier_Big_F",[12.0039,3.8418,0],178.923],
        ["Land_FoodSacks_01_cargo_white_idap_F",[11.5234,5.82227,-4.76837e-07],360],
        ["Land_GasTank_01_yellow_F",[0.193359,-13.1367,5.96046e-06],0.0110545],
        ["Land_Cargo_HQ_V3_F",[-0.488281,13.4219,0],266.101],
        ["Land_PaperBox_01_open_water_F",[-13.4453,0.527344,0.000929594],171.639],
        ["Land_Cargo20_brick_red_F",[-1.82227,-13.3301,4.76837e-07],98.2688],
        ["Land_GasTank_01_khaki_F",[0.853516,-13.4902,5.96046e-06],0.0110634],
        ["Land_GasTank_01_blue_F",[0.179688,-13.8691,7.15256e-06],0.012355],
        ["Land_FoodSacks_01_cargo_white_idap_F",[11.625,7.67383,-2.38419e-07],360],
        ["MapBoard_altis_F",[-13.8105,3.79688,-0.00223589],273.371],
        ["Land_ToolTrolley_01_F",[12.7695,-7.69727,1.43051e-06],80.9311],
        ["Land_PaperBox_01_open_empty_F",[11.5156,9.58008,0.000931978],257.874],
        ["Land_BagBunker_Large_F",[-9.0957,-13.6387,0],358.677],
        ["Land_ToolTrolley_02_F",[0.482422,-16.2305,-2.38419e-07],93.5618],
        ["Land_HBarrierWall6_F",[14.6582,9.53516,0],90.1658],
        ["Land_Bodybag_01_empty_black_F",[-8.49414,13.9219,-0.0141294],28.1165],
        ["Land_Cargo_House_V3_F",[-16.3262,5.84961,4.76837e-07],265.18],
        ["Land_GasTank_02_F",[-0.804688,-16.834,3.67165e-05],0],
        ["Land_CinderBlocks_F",[15.3047,-7.49414,5.24521e-06],284.986],
        ["Land_Cargo_Patrol_V3_F",[-16.8672,-5.00586,0],87.6193],
        ["Land_WoodenBox_F",[14.3086,-9.74023,0],90],
        ["Land_BagFence_Long_F",[-0.0410156,-17.4551,-0.000999928],174.596],
        ["Land_Stretcher_01_sand_F",[9.54297,14.752,4.76837e-07],346.534],
        ["Land_CinderBlocks_F",[15.3047,-9.11914,8.82149e-06],254.984],
        ["Land_Pallet_MilBoxes_F",[-11.3691,13.7832,0],104.365],
        ["Land_BagFence_Long_F",[-2.99414,-17.7461,-0.000999451],174.596],
        ["Land_Stretcher_01_sand_F",[10.9492,14.916,2.38419e-07],360],
        ["Land_HBarrier_Big_F",[-18.6602,0.160156,0],178.923],
        ["Land_BagFence_Long_F",[17.3066,-7.60742,-0.000999451],85.2344],
        ["Land_Razorwire_F",[18.5,3.14063,-2.86102e-06],76.123],
        ["Land_PaperBox_01_small_stacked_F",[-9.95703,16.1328,0],245.109],
        ["Land_Bricks_V4_F",[16.0508,-10.748,-2.38419e-07],60],
        ["Land_Pallets_stack_F",[-14.7559,-12.5078,0],56.702],
        ["Land_WheelCart_F",[14.8711,-12.6777,0.000812054],210.005],
        ["Land_Razorwire_F",[-0.115234,-19.752,-2.86102e-06],174.348],
        ["Land_PaperBox_01_open_boxes_F",[9.91797,17.9141,0.000931263],360],
        ["Land_BagFence_Long_F",[17.5625,-10.584,-0.000999928],85.2344],
        ["Land_HBarrier_Big_F",[-17.8672,-10.3105,0],178.923],
        ["Land_Pallet_MilBoxes_F",[-13.3809,15.9531,0],269.367],
        ["Land_HBarrierWall6_F",[-21.4883,-5.69336,0],268.921],
        ["Land_Razorwire_F",[19.4219,-6.09766,-2.86102e-06],84.3475],
        ["Land_WaterBottle_01_stack_F",[7.76953,19.6074,0.00514555],54.4623],
        ["Land_Tyres_F",[17.6543,11.543,0.00659728],298.651],
        ["Land_CratesShabby_F",[-17.4395,-12.7031,-0.683854],74.499],
        ["Land_HBarrierWall6_F",[-22.2813,4.77734,0],268.921],
        ["Land_PaperBox_01_small_stacked_F",[-15.3926,15.4434,-2.38419e-07],127.711],
        ["Land_HBarrierWall6_F",[14.3438,17.8555,0],90.1658],
        ["Land_HBarrier_Big_F",[-18.9668,10.9004,0],178.923],
        ["Land_Sacks_heap_F",[17.4473,13.3125,0],313.651],
        ["Land_JunkPile_F",[21.7988,-4.7207,0],0],
        ["CamoNet_OPFOR_open_F",[-15.0508,16.1777,0],355.403],
        ["Land_WaterBottle_01_stack_F",[10.002,20.3711,0.00514555],298.678],
        ["Land_PaperBox_01_small_stacked_F",[-17.6113,14.373,-1.90735e-06],62.5185],
        ["Land_Pallet_MilBoxes_F",[-12.8145,18.7402,0],55.6619],
        ["Land_FoodSacks_01_cargo_brown_idap_F",[11.0586,-20.2871,-4.76837e-07],150.977],
        ["Land_Razorwire_F",[-12.8184,-20.2266,-2.86102e-06],0],
        ["Land_GarbageBags_F",[-19.5215,-14.0469,0],0],
        ["Land_WoodenBox_F",[16.5703,16.2754,-2.38419e-07],283.65],
        ["Land_HBarrier_Big_F",[-2.82813,23.2656,0],178.923],
        ["Land_CratesShabby_F",[-18.2227,-14.7578,4.76837e-07],154.704],
        ["Land_Tank_rust_F",[19.6699,12.9922,0],88.6506],
        ["Land_HBarrierWall6_F",[5.30078,24.1602,0],0],
        ["Land_FoodSacks_01_large_brown_idap_F",[13.0273,-19.9746,-4.76837e-07],140],
        ["Land_PaperBox_01_small_stacked_F",[-15.6152,18.041,-4.76837e-07],188.245],
        ["Land_WoodenBox_F",[17.6289,16.1914,-2.38419e-07],298.651],
        ["Land_WheelieBin_01_F",[23.1543,-6.16016,2.07424e-05],22.0646],
        ["Land_BagFence_Long_F",[9.14453,-22.4434,-0.000999928],164.551],
        ["Land_PaperBox_01_small_stacked_F",[-17.7676,16.6621,1.43051e-06],127.709],
        ["Land_LampHalogen_F",[23.7656,1.0332,0],40.5689],
        ["Land_BagFence_Long_F",[12.0215,-21.6406,-0.000999928],164.551],
        ["Land_Garbage_square5_F",[23.6348,-7.22461,0.007406],195],
        ["Land_BagFence_Long_F",[16.8398,-18.2383,-0.000999928],130.45],
        ["Land_BagFence_Long_F",[14.6211,-20.3086,-0.000999928],142.001],
        ["Land_Razorwire_F",[-18.3105,-17.6621,-2.86102e-06],222.577],
        ["Land_HBarrier_Big_F",[-11.5078,22.8496,0],178.923],
        ["Land_WheelieBin_01_F",[24.7383,-6.56445,2.38419e-06],332.595],
        ["Land_ToiletBox_F",[23.1953,12.5234,-4.76837e-07],223.649],
        ["Land_PaperBox_01_open_empty_F",[19.7402,17.7695,0.000932217],239.404],
        ["Land_HBarrierWall_corner_F",[12.5547,23.4258,0],0],
        ["Land_ToiletBox_F",[22.8047,14.0645,1.90735e-06],253.649],
        ["Land_Razorwire_F",[10.1836,-24.8496,-2.86102e-06],346.291],
        ["Land_HBarrier_Big_F",[-22.6855,16.1523,4.76837e-07],88.8817],
        ["Land_Razorwire_F",[20.2754,-19.2012,-2.86102e-06],136.203],
        ["Land_HBarrier_Big_F",[-20.041,22.1113,4.76837e-07],175.434],
        ["Land_LampHalogen_F",[-25.627,-21.5371,0],132.72],
        ["Land_LampHalogen_F",[-24.2109,26.1367,9.53674e-07],224.675],
        ["Snake_random_F",[26.7734,-25.8711,0.0083878],35.5596]
    ],
    // Second Emplacement
    [
        ["Land_CampingChair_V2_F",[-3.90039,-0.560547,-1.90735e-06],90.0046],
        ["Land_CampingChair_V2_F",[-4.02539,1.52539,-1.90735e-06],90.0046],
        ["Land_CampingChair_V2_F",[-3.90039,2.68945,-2.38419e-06],105.002],
        ["Land_WoodenTable_large_F",[-4.64258,1.01172,0],180.086],
        ["Land_WoodenTable_large_F",[-4.65039,-1.20117,-4.76837e-07],0.0262967],
        ["Land_Pallet_MilBoxes_F",[4.6543,-1.91406,0],287.84],
        ["Land_CampingChair_V2_F",[-3.8457,3.63086,-2.38419e-06],119.995],
        ["Land_CampingChair_V2_F",[-5.33398,-0.779297,-2.14577e-06],285.001],
        ["Land_CampingChair_V2_F",[-5.58984,0.8125,-2.38419e-06],300.001],
        ["Land_WoodenTable_large_F",[-4.64063,3.23242,-4.76837e-07],359.423],
        ["Land_CampingChair_V2_F",[-5.27539,2.56445,-1.90735e-06],269.734],
        ["Land_Pallet_MilBoxes_F",[5.16406,-3.98633,0],69.7617],
        ["Land_CampingChair_V2_F",[-5.47266,3.45313,-1.90735e-06],270.005],
        ["Land_TripodScreen_01_large_sand_F",[-4.44336,-5.15234,6.34193e-05],359.992],
        ["Land_PortableLight_02_single_olive_F",[-2.06641,6.74219,0],42.643],
        ["Land_Cargo_House_V3_F",[7.94531,2.27344,4.76837e-07],87.5518],
        ["Land_PortableGenerator_01_sand_F",[-5.40234,-5.5918,2.38419e-07],126.36],
        ["Land_CampingChair_V2_F",[-7.94922,0.376953,7.15256e-06],345.006],
        ["Land_CampingChair_V2_F",[-8.54883,-2.29297,2.38419e-06],120.008],
        ["Land_CampingChair_V2_F",[-9.02344,-0.601563,-1.90735e-06],89.9148],
        ["Land_CampingChair_V2_F",[-9.14844,1.48633,-1.90735e-06],90.004],
        ["Land_PortableServer_01_sand_F",[-7.7207,-5.41992,-4.76837e-07],360],
        ["Land_WoodenTable_large_F",[-9.76758,0.988281,0.00178742],180.305],
        ["Land_CampingChair_V2_F",[-9.14844,3.65039,-1.90735e-06],90.004],
        ["Land_WoodenTable_large_F",[-9.77344,-1.30469,0],0.00535875],
        ["Land_WoodenTable_large_F",[-9.76953,3.19922,0.0028286],359.852],
        ["Land_CampingChair_V2_F",[-10.3984,0.400391,-2.14577e-06],269.976],
        ["Land_PortableGenerator_01_sand_F",[-8.88086,-5.5,-4.76837e-07],0.00172741],
        ["Land_CampingChair_V2_F",[-10.3984,-1.76367,-1.90735e-06],270.005],
        ["Land_CampingChair_V2_F",[-10.3984,2.5332,0.000497103],269.561],
        ["Land_CampingChair_V2_F",[-10.6484,1.23633,-2.38419e-06],224.999],
        ["Land_HBarrier_Big_F",[10.8613,-2.42383,0],178.923],
        ["Land_TripodScreen_01_large_sand_F",[-10.0645,-5.23242,6.34193e-05],359.992],
        ["Land_CampingChair_V2_F",[-10.7734,3.86133,2.6226e-06],300.005],
        ["Land_DeskChair_01_olive_F",[7.37695,-9.39258,1.43051e-06],172.04],
        ["MedicalGarbage_01_1x1_v2_F",[-4.21289,-11.3027,0.00254679],270],
        ["Land_VitaminBottle_F",[-4.45898,-11.2539,-0.00197315],270.424],
        ["Land_Bricks_V3_F",[9.44727,7.67773,-4.76837e-07],225.001],
        ["Land_MetalCase_01_small_F",[-4.13477,-11.4238,-0.00196171],105.676],
        ["Land_VitaminBottle_F",[-4.54492,-11.3418,-0.00192261],34.8407],
        ["Land_Bandage_F",[-4.80078,-11.2168,0.0177259],319.726],
        ["Land_Bandage_F",[-4.74219,-11.3184,0.0178976],271.52],
        ["Land_CampingTable_white_F",[-4.61719,-11.4375,-0.143046],0.817944],
        ["Land_Bandage_F",[-4.83984,-11.3496,0.0177507],242.806],
        ["MedicalGarbage_01_1x1_v1_F",[-5.21484,-11.2637,0.00256157],0],
        ["Snake_random_F",[2.29102,12.2715,0.0083878],28.3889],
        ["Land_MetalCase_01_medium_F",[-5.11328,-11.4121,-0.0020051],91.1716],
        ["Land_Stretcher_01_folded_F",[-4.91797,-11.623,-2.38419e-07],261.932],
        ["Land_HBarrierWall6_F",[13.5156,3.26953,0],90.1658],
        ["Land_DeskChair_01_olive_F",[6.12695,-11.623,-2.38419e-06],310.297],
        ["Land_MobileScafolding_01_F",[6.64453,11.5547,-0.531844],195.297],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-11.8789,-7.35742,0.0184927],134.402],
        ["Land_Pallets_F",[-9.43164,-11.9336,0],0],
        ["Land_PalletTrolley_01_khaki_F",[-8.91406,-11.1113,-0.208751],184.081],
        ["Land_Pipes_small_F",[7.86914,11.9941,-9.53674e-07],75.0005],
        ["Land_DeskChair_01_olive_F",[5.55859,-13.3105,-2.38419e-06],296.907],
        ["Land_PlasticCase_01_small_gray_F",[-4.36719,-13.834,-2.38419e-07],253.001],
        ["Land_DeskChair_01_olive_F",[10.7773,-9.78906,-1.90735e-06],27.4438],
        ["Land_WoodenBox_F",[10.7383,9.86523,-2.38419e-07],296.748],
        ["Land_DeskChair_01_olive_F",[9.66016,-11.0449,4.76837e-07],314.557],
        ["Land_DeskChair_01_olive_F",[8.88086,-12.1074,-2.38419e-06],296.907],
        ["BloodSplatter_01_Medium_New_F",[-2.48633,-14.9629,0],313],
        ["MedicalGarbage_01_5x5_v1_F",[-3.45898,-14.7852,0],270],
        ["Land_Stretcher_01_sand_F",[-2.61719,-15.084,-9.53674e-07],0.00117921],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-14.4414,-5.22656,-4.76837e-07],95.407],
        ["Land_EmergencyBlanket_02_discarded_F",[-3.36719,-15.084,-4.76837e-07],185.95],
        ["Land_Stretcher_01_sand_F",[-4.11719,-15.084,-7.15256e-07],356.419],
        ["Land_PowerGenerator_F",[3.20898,15.3672,4.76837e-07],268.194],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-15.0137,-5.18359,4.05312e-06],93.4105],
        ["Land_DeskChair_01_olive_F",[8.4375,-13.5703,-2.14577e-06],217.833],
        ["Land_PaperBox_01_open_boxes_F",[-14.668,-6.55859,0.000929594],353.407],
        ["Land_Stretcher_01_olive_F",[-5.60352,-15.0996,2.38419e-07],180.001],
        ["MedicalGarbage_01_3x3_v1_F",[-6.14648,-15.1133,4.76837e-07],90],
        ["Land_EmergencyBlanket_01_discarded_F",[-6.29102,-15.0195,-1.19209e-06],45.4003],
        ["Land_PortableLight_02_single_olive_F",[-13.1895,9.5332,0],328.155],
        ["Land_Pallet_MilBoxes_F",[0.625,-16.4941,0],55.6619],
        ["Land_HBarrierWall6_F",[13.2012,11.5898,0],90.1658],
        ["Land_Pallet_MilBoxes_F",[13.7402,-9.52539,0],55.6619],
        ["Land_Sacks_heap_F",[-16.1543,-4.26953,0],238.523],
        ["Land_Stethoscope_01_F",[-6.03516,-15.6367,0],240],
        ["Land_DeskChair_01_olive_F",[7.95313,-15.0742,-2.38419e-06],301.873],
        ["Land_IntravenStand_01_2bags_F",[-6.55664,-15.832,3.29018e-05],314.99],
        ["Land_IntravenStand_01_empty_F",[-6.14844,-16.1934,3.29018e-05],89.9986],
        ["Land_HBarrierWall6_F",[4.1582,17.8945,0],0],
        ["Land_DeskChair_01_olive_F",[11.1953,-13.5176,-2.38419e-06],313.224],
        ["Land_PaperBox_closed_F",[-16.2266,-6.89063,4.76837e-07],88.4081],
        ["Land_DeskChair_01_olive_F",[13.4746,-11.5117,-1.66893e-06],359.994],
        ["CamoNet_OPFOR_big_F",[10.3965,-13.8867,0],132.234],
        ["Land_Pallet_F",[-15.4707,-8.76172,4.55379e-05],255.435],
        ["Land_PaperBox_01_open_boxes_F",[4.81836,-17.1406,0.000928164],177.882],
        ["Land_DeskChair_01_olive_F",[12.5508,-12.7031,-2.38419e-06],297.311],
        ["Land_Cargo_HQ_V3_F",[-7.10352,17.0938,0],265.603],
        ["Land_CratesPlastic_F",[-16.1699,7.86328,4.76837e-07],273.538],
        ["Land_HBarrierWall6_F",[-3.57031,-18.8223,0],180.407],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-15.8613,-9.69141,0.0431373],346.177],
        ["Land_MetalBarrel_F",[-14.7344,11.5996,1.43051e-06],203.833],
        ["Land_CratesShabby_F",[-17.0469,8.13672,4.76837e-07],93.5378],
        ["Land_HBarrier_Big_F",[18.1953,-5.70117,4.76837e-07],231.766],
        ["Land_Pallets_stack_F",[-16.5254,9.62305,-2.38419e-07],183.537],
        ["Land_MetalBarrel_F",[-14.6191,12.3418,1.43051e-06],128.864],
        ["Land_Cargo_Patrol_V3_F",[-12.832,-14.5605,9.53674e-07],358.406],
        ["Land_DeskChair_01_olive_F",[10.2637,-16.2559,-1.43051e-06],185.132],
        ["Land_MetalBarrel_F",[-15.5996,11.7363,1.43051e-06],98.8605],
        ["Land_Garbage_square5_F",[-19.4648,-1.33398,0],0],
        ["Land_HBarrier_Big_F",[-18.3301,-7.12891,4.76837e-07],88.8817],
        ["Land_PaperBox_01_open_boxes_F",[7.16406,-18.3496,0.000930071],312.43],
        ["Land_Pallet_vertical_F",[-15.1387,12.8887,1.19209e-05],113.856],
        ["Land_Pallet_vertical_F",[-15.8809,12.3652,6.67572e-06],128.85],
        ["Land_HBarrierWall_corner_F",[11.4121,17.1602,0],0],
        ["Land_WoodenBox_F",[-21.0898,-2.33789,0],1.32252],
        ["Land_CratesWooden_F",[-16.3945,13.5918,4.76837e-07],315.034],
        ["MapBoard_altis_F",[15.8516,-14.4941,-0.00223637],92.7537],
        ["Land_HBarrier_Big_F",[-19.1914,10.3105,0],88.8817],
        ["Land_HBarrierWall6_F",[-11.8926,-19.1016,0],180.407],
        ["Land_WoodenBox_F",[0.279297,22.1426,0.4346],276.488],
        ["Land_Can_V1_F",[12.2324,-18.623,-0.0019927],153.276],
        ["Land_Orange_01_F",[12.1426,-18.748,-0.00219607],30.5646],
        ["Land_ExtensionCord_F",[10.5137,-19.7656,0],72.3363],
        ["Land_Map_Malden_F",[11.2168,-19.4004,-0.0019908],53.3305],
        ["Land_CampingTable_white_F",[11.6387,-19.1758,-0.00259304],151.338],
        ["MapBoard_seismic_F",[14.377,-17.3477,-0.00223541],135.671],
        ["Land_MobilePhone_old_F",[12.2734,-19.0137,-0.0019989],124.329],
        ["Land_Notepad_F",[11.9785,-19.207,-0.00199986],79.3298],
        ["Land_HBarrier_Big_F",[2.87305,-22.5762,4.76837e-07],220.687],
        ["Land_HBarrier_Big_F",[-16.5469,16.2695,0],175.434],
        ["Land_CampingChair_V2_white_F",[12.5469,-19.8633,-1.90735e-06],144.333],
        ["Land_HBarrier_Big_F",[-17.9336,-15.8027,4.76837e-07],88.8817],
        ["Land_Bricks_V3_F",[-15.082,18.7344,0],95.7859],
        ["Land_Sacks_goods_F",[-0.0292969,-24.0918,0],0],
        ["Land_CratesShabby_F",[-1.04883,-24.6445,0],330],
        ["Land_Garbage_square5_F",[-1.01172,-24.7852,0],0],
        ["Land_Bricks_V4_F",[-14.627,20.4238,-7.15256e-07],155.784],
        ["Land_BagBunker_Large_F",[-24.1445,-7.6582,0],358.677],
        ["Land_CinderBlocks_F",[-16.1309,19.4922,4.76837e-07],95.7804],
        ["Land_ScrapHeap_1_F",[-5.78125,-24.8965,0],162.974],
        ["Land_HBarrier_Big_F",[21.4668,-13.459,0],88.3634],
        ["Land_Cargo20_IDAP_F",[10.6367,23.1699,-4.76837e-07],360],
        ["Land_WheelCart_F",[-20.7324,-14.8945,0.000799179],19.4617],
        ["Land_PaperBox_closed_F",[-0.0429688,-25.8691,0],165],
        ["Land_Pallet_F",[-2.0293,-26.1055,-7.15256e-07],105],
        ["CamoNet_OPFOR_open_F",[-9.32813,-24.0996,-0.0355334],181.17],
        ["Land_CinderBlocks_F",[-16.377,20.7734,7.39098e-06],185.783],
        ["Land_LampHalogen_F",[15.875,21.5195,0],319.701],
        ["StorageBladder_02_water_forest_F",[-11.2832,-24.9961,0],0],
        ["Land_CargoBox_V1_F",[-17.1992,-21.5137,0.0305405],199.091],
        ["Land_HBarrier_Big_F",[10.9531,-25.2656,4.76837e-07],175.941],
        ["Land_Razorwire_F",[-6.35352,27.4102,-2.86102e-06],359.587],
        ["Land_HBarrier_Big_F",[-27.959,1.29297,0],88.8817],
        ["Land_HBarrier_Big_F",[18.2383,-21.293,4.76837e-07],132.716],
        ["Land_Cargo40_yellow_F",[5.00195,27.9355,-0.088305],357.709],
        ["Land_Razorwire_F",[-20.7246,19.4688,-2.38419e-06],299.768],
        ["Land_SignM_WarningMilitaryVehicles_english_F",[-28.2148,5.90234,0],178.582],
        ["Land_Cargo20_blue_F",[4.25586,-28.5508,0],215.142],
        ["Land_Sacks_heap_F",[-19.375,-21.6602,0],244.304],
        ["Land_Razorwire_F",[-14.6895,25.5371,-2.86102e-06],335.608],
        ["Box_NATO_AmmoVeh_F",[-15.6484,-25.2363,0.0305417],252.189],
        ["Land_Sacks_heap_F",[-20.8047,-21.5293,0],180],
        ["Land_WorkStand_F",[-25.6543,-15.7969,-4.76837e-07],195.002],
        ["Land_Razorwire_F",[-22.4844,-18.9121,-2.86102e-06],193.725],
        ["Land_CratesPlastic_F",[-20.7832,-22.8789,0],237.639],
        ["Land_Razorwire_F",[-30.7344,6.14648,-2.86102e-06],105.513],
        ["Land_Razorwire_F",[-31.8535,-1.92188,-2.38419e-06],87.6431],
        ["Land_LampHalogen_F",[-22.5957,-22.25,0],112.528],
        ["Land_Razorwire_F",[-31.2949,-10.8906,-2.38419e-06],82.0825]
    ],
 [
        ["Land_CampingChair_V1_F",[-3.23,-0.54,0.003],151.59],
        ["Land_CampingChair_V1_F",[-4.04,-1.26,0.003],179.99],
        ["Land_CampingTable_F",[-4.74,0.16,-0.003],181.66],
        ["Land_Garbage_square5_F",[-4.88,0.51,0],3.73],
        ["Land_CampingChair_V1_F",[-3.59,-4.02,0.003],163.10],
        ["Land_CampingChair_V1_F",[-5.46,-0.68,0.003],195.75],
        ["Land_Garbage_square5_F",[-4.94,-2.63,0],3.73],
        ["Land_CampingTable_F",[-4.80,-2.98,-0.003],181.66],
        ["Land_PortableGenerator_01_black_F",[-3.84,4.22,0],0],
        ["Land_Pallet_MilBoxes_F",[-1.43,-6.18,0],6.26],
        ["Land_TripodScreen_01_dual_v1_F",[-4.80,4.49,0],199.04],
        ["Land_CampingChair_V1_F",[-5.25,-4.05,0.003],169.82],
        ["Land_CampingChair_V1_F",[-7.20,-1.00,0.003],179.99],
        ["Land_CampingChair_V1_F",[-6.37,-3.76,0.003],179.99],
        ["Land_CampingTable_F",[-7.65,0.25,-0.003],181.66],
        ["Land_Garbage_square5_F",[-7.79,0.61,0],3.73],
        ["Land_Pallet_MilBoxes_F",[-5.31,-6.01,0],38.99],
        ["Land_PaperBox_01_open_water_F",[8.19,-0.33,0.001],0],
        ["Land_CampingTable_F",[-7.79,-2.71,-0.003],181.66],
        ["Land_Garbage_square5_F",[-7.92,-2.36,0],3.73],
        ["Land_CampingChair_V1_F",[-8.38,-0.58,0.003],195.75],
        ["Land_Pallet_MilBoxes_F",[-1.29,-8.24,0],294.28],
        ["Land_CampingChair_V1_F",[-7.73,-3.46,0.003],186.30],
        ["MapBoard_altis_F",[-6.97,4.75,-0.002],357.53],
        ["Land_PortableCabinet_01_closed_olive_F",[-9.03,0.32,0],91.06],
        ["Land_PalletTrolley_01_khaki_F",[-5.26,-7.56,0],164.15],
        ["SatelliteAntenna_01_Small_Sand_F",[-8.63,4.59,-0.001],291.11],
        ["Land_PortableLight_02_double_yellow_F",[3.19,9.37,0],20.52],
        ["Land_Pallet_F",[-7.22,-7.72,0.008],136.09],
        ["Land_WaterBottle_01_stack_F",[10.62,1.77,0.005],325.72],
        ["Land_Pallets_F",[-6.43,-10.15,0],0],
        ["Land_HBarrier_Big_F",[-3.22,-10.95,0],89.48],
        ["Land_FoodSacks_01_cargo_brown_idap_F",[11.10,3.62,0],0],
        ["Land_Pillow_F",[-0.57,-12.31,0],298.94],
        ["Land_WaterBottle_01_stack_F",[12.79,2.24,0.005],225.87],
        ["Land_GasCanister_F",[-0.10,-13.22,0],271.44],
        ["Land_GasCooker_F",[-0.35,-13.26,0],271.43],
        ["Land_HBarrier_Big_F",[13.44,-0.30,0],178.92],
        ["Land_PaperBox_01_open_boxes_F",[12.77,4.88,0.001],335.56],
        ["Land_CampingChair_V1_F",[1.52,-14.04,0.003],19.59],
        ["Land_Cargo_HQ_V3_F",[-2.98,14.68,0],266.81],
        ["Land_spp_Transformer_F",[5.83,13.42,0],176.11],
        ["Land_BagBunker_Large_F",[14.04,-6.11,0.178],266.04],
        ["Land_CampingTable_F",[0.74,-14.82,-0.002],5.55],
        ["Land_CampingChair_V1_F",[-0.58,-14.86,0.003],281.42],
        ["Land_Garbage_square5_F",[0.85,-15.18,0],187.57],
        ["Land_Can_Dented_F",[-0.40,-15.33,0],187.58],
        ["Land_CampingChair_V1_F",[2.52,-15.17,0.003],124.58],
        ["Land_CampingTable_F",[0.66,-15.63,0.007],185.55],
        ["Land_HBarrierWall6_F",[16.10,5.39,0],90.17],
        ["Land_Can_V3_F",[0.75,-15.96,0],187.58],
        ["Land_CampingChair_V1_F",[0.09,-16.09,0.010],208.01],
        ["Land_PaperBox_01_open_empty_F",[10.51,-12.50,0.001],285.93],
        ["Land_FoodContainer_01_F",[1.75,-16.27,0],301.44],
        ["Land_CampingChair_V1_F",[0.85,-16.56,0.003],120.87],
        ["Land_HBarrier_Big_F",[-10.29,13.09,0],89.48],
        ["Land_dp_transformer_F",[10.50,13.49,0],356.90],
        ["Land_PaperBox_01_small_stacked_F",[12.90,-12.66,0],168.82],
        ["Land_PaperBox_01_small_stacked_F",[10.74,-14.64,0],327.03],
        ["Land_Ammobox_rounds_F",[0.70,-18.16,0],299.76],
        ["Land_FoodContainer_01_F",[0.98,-18.34,0],0],
        ["Land_Ammobox_rounds_F",[0.63,-18.50,0],358.33],
        ["Land_CampingChair_V1_F",[2.11,-18.49,0.003],38.96],
        ["Land_Can_Dented_F",[0.54,-18.65,0],246.13],
        ["Land_Cargo10_grey_F",[-13.77,13.63,0],244.70],
        ["Land_CampingTable_F",[1.56,-19.36,0],63.96],
        ["Land_CampingChair_V1_F",[0.14,-19.46,0.006],266.51],
        ["Land_IronPipes_F",[7.38,-17.94,0],225],
        ["Land_Garbage_square5_F",[1.31,-19.64,0],246.13],
        ["Land_CampingTable_F",[0.84,-19.70,0.011],243.95],
        ["Land_HBarrierWall6_F",[15.78,13.71,0],90.17],
        ["Land_PaperBox_01_small_stacked_F",[15.31,-12.44,0],360],
        ["Land_CampingChair_V1_F",[2.64,-19.61,0.003],78.15],
        ["Land_Cargo_Patrol_V3_F",[-8.09,-18.66,0],358.18],
        ["Land_Camping_Light_F",[-18.14,8.06,-0.001],359.99],
        ["Land_HBarrier_Big_F",[-2.79,-19.71,0],89.48],
        ["Land_Can_V3_F",[0.59,-19.96,0],246.19],
        ["Land_Cargo10_sand_F",[-16.97,10.57,0],199.17],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-13.10,-15.38,0],142.00],
        ["Land_HBarrierWall6_F",[6.74,20.02,0],0],
        ["Land_PlasticCase_01_small_F",[-18.39,8.54,0],303.66],
        ["Land_CampingChair_V1_F",[0.59,-20.39,0.003],241.14],
        ["Land_Razorwire_F",[19.94,-1.00,0],76.12],
        ["Land_Antibiotic_F",[-18.73,8.38,0],133.37],
        ["Land_VitaminBottle_F",[-18.75,8.49,0],360.00],
        ["Land_Bandage_F",[-18.87,8.38,0],108.24],
        ["Land_VitaminBottle_F",[-18.78,8.58,0],360.00],
        ["Land_Bandage_F",[-18.87,8.52,0],229.36],
        ["Land_Cargo20_grey_F",[12.69,-16.38,0],143.13],
        ["Land_Bandage_F",[-18.96,8.47,0],0.01],
        ["Land_GasTank_01_khaki_F",[-18.53,9.42,0],305.94],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-13.85,-15.50,0],232],
        ["Land_Ammobox_rounds_F",[-19.04,8.71,0],360.00],
        ["Land_GasTank_01_blue_F",[-18.89,9.13,0],360.00],
        ["Land_Rope_01_F",[-19.18,9.06,0],97.39],
        ["Land_CampingChair_V1_F",[-20.86,6.55,0.003],315.01],
        ["Land_CampingTable_F",[-20.32,8.30,-0.003],360.00],
        ["Land_HBarrierWall6_F",[-13.84,18.93,0],0],
        ["Land_PaperBox_01_small_open_white_IDAP_F",[-20.80,-8.47,0],65.26],
        ["Snake_random_F",[21.29,7.19,0.008],107.75],
        ["Land_ShellCrater_02_debris_F",[20.29,8.69,0],0],
        ["Land_CampingChair_V1_F",[-20.74,8.80,0.003],359.99],
        ["Land_HBarrier_Big_F",[2.83,-22.64,0],179.30],
        ["Land_HBarrierWall6_F",[-7.45,-23.29,0],179.48],
        ["Land_HBarrier_Big_F",[18.11,-15.04,0],95.78],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-22.01,-9.06,0],94.26],
        ["Land_HBarrierWall_corner_F",[13.99,19.29,0],0],
        ["Land_HBarrier_Big_F",[8.81,-22.06,0],170.01],
        ["Land_Cargo10_cyan_F",[-20.29,12.99,0],139.54],
        ["Land_Razorwire_F",[20.86,-10.24,0],84.35],
        ["Land_HBarrierWall6_F",[-24.81,5.00,0],271.46],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[-22.59,-9.03,0],92.26],
        ["Land_HBarrier_Big_F",[-13.27,-20.40,0],89.48],
        ["Land_PaperBox_01_open_boxes_F",[-22.21,-10.40,0.001],352.26],
        ["Land_HBarrier_Big_F",[14.99,-19.92,0],153.20],
        ["Land_Bodybag_01_white_F",[25.02,-1.39,-0.027],7.48],
        ["Land_ShellCrater_02_decal_F",[22.02,12.62,0],302.78],
        ["Land_PaperBox_closed_F",[-22.20,-12.25,0],87.26],
        ["Land_Cargo_House_V3_F",[-18.94,-18.01,0],175.74],
        ["Land_Bodybag_01_white_F",[26.24,-1.55,-0.027],172.48],
        ["Land_Razorwire_F",[7.65,-25.97,0],176.29],
        ["CraterLong_02_F",[26.08,8.58,0],0],
        ["Land_HBarrier_Big_F",[-24.34,-12.01,0],90.17],
        ["Land_HBarrierWall6_F",[-24.93,13.33,0],271.46],
        ["Land_Razorwire_F",[-1.21,-26.93,0],160.90],
        ["Land_BagFence_Long_F",[-7.98,-26.41,-0.001],54.97],
        ["Land_HBarrierWall6_F",[-22.18,18.51,0],0],
        ["Land_JunkPile_F",[-11.94,-25.34,0],261.60],
        ["BloodTrail_01_New_F",[27.90,-4.53,0],37.48],
        ["Land_Razorwire_F",[21.66,-18.08,0],114.24],
        ["Land_Razorwire_F",[12.89,-25.77,0],329.29],
        ["Land_CampingChair_V1_folded_F",[-26.70,-11.58,0],246.51],
        ["MedicalGarbage_01_3x3_v2_F",[29.34,-1.05,0],142.48],
        ["Land_Stretcher_01_F",[29.26,-0.96,0],52.48],
        ["Land_HBarrierWall6_F",[-17.92,-23.98,0],179.48],
        ["vn_air_ah1g_01_wreck",[26.80,11.99,-0.222],186.41],
        ["BloodSplatter_01_Medium_New_F",[29.43,-2.41,0],127.48],
        ["Land_LampHalogen_F",[19.60,21.26,0],310.89],
        ["Land_GarbagePallet_F",[-13.10,-26.68,0],261.60],
        ["Land_LuggageHeap_02_F",[-27.17,-12.35,0],23.02],
        ["Land_IntravenBag_01_full_F",[30.08,-1.82,0.001],157.43],
        ["CraterLong_02_F",[26.44,16.50,0],0],
        ["Land_Sacks_goods_F",[-28.02,-11.40,0],131.82],
        ["Land_Camera_01_F",[-27.47,-12.93,0],15.73],
        ["Land_IntravenBag_01_full_F",[30.44,-1.48,0.001],307.46],
        ["Land_Stethoscope_01_F",[30.63,-0.07,0],22.48],
        ["Land_GarbagePallet_F",[-16.24,-25.77,0],0],
        ["Land_FirstAidKit_01_open_F",[30.70,-0.97,-0.005],7.47],
        ["BloodSpray_01_New_F",[30.82,-3.40,0],142.48],
        ["Land_HBarrier_Big_F",[-29.64,-8.91,0],179.30],
        ["Land_CampingChair_V1_folded_F",[-29.04,-11.00,0],337.65],
        ["Land_BagBunker_Large_F",[-30.66,5.83,0],177.61],
        ["Land_EmergencyBlanket_01_discarded_F",[31.01,-2.62,0],22.48],
        ["Land_JunkPile_F",[-15.09,-27.12,0],0],
        ["Land_ShellCrater_01_F",[29.14,10.88,0],0],
        ["Land_ShellCrater_02_debris_F",[30.38,5.88,0],0],
        ["Land_HBarrier_Big_F",[-24.02,-20.60,0],89.48],
        ["MedicalGarbage_01_3x3_v1_F",[31.84,-2.76,0],22.48],
        ["Land_Stretcher_01_F",[31.71,-2.71,0],202.48],
        ["Land_Tank_rust_F",[-29.70,12.60,0],180.02],
        ["Land_Stretcher_01_folded_F",[32.93,-2.25,0],262.48],
        ["Land_LampHalogen_F",[18.01,-27.35,0],40.57],
        ["Land_WoodPile_large_F",[-26.22,20.66,0.023],255.02],
        ["Land_GarbageBags_F",[-30.49,-15.76,0],0],
        ["Land_LampHalogen_F",[-24.68,23.65,0],237.93],
        ["Land_ShellCrater_02_debris_F",[30.43,15.84,0],0],
        ["CamoNet_OPFOR_open_F",[-30.50,-18.16,0],85.74],
        ["Land_Razorwire_F",[-29.39,17.29,0],151.28],
        ["Land_CinderBlocks_F",[-28.80,-20.18,0],36.84],
        ["Land_GarbageContainer_closed_F",[-31.00,-17.38,0.005],332.36],
        ["Land_GarbageContainer_open_F",[-32.48,-14.80,0],293.13],
        ["Land_LampHalogen_F",[-24.19,-25.68,0],132.72],
        ["Land_CinderBlocks_F",[-30.23,-19.63,0],126.84],
        ["Land_BagFence_Long_F",[-35.13,-9.21,0],213.45],
        ["Land_Bricks_V2_F",[-29.01,-21.94,0],126.85],
        ["Land_CinderBlocks_F",[-29.90,-21.20,0],126.84],
        ["Land_Pallets_stack_F",[-31.46,-20.84,0],216.85],
        ["Land_BagFence_Long_F",[-37.22,-7.17,0],236.00],
        ["Land_Basket_F",[-30.91,-22.15,0],306.81],
        ["Land_Razorwire_F",[-38.04,8.88,0],294],
        ["Land_BagFence_Long_F",[-38.89,-4.69,0],236.00],
        ["Land_Razorwire_F",[-37.11,-10.12,0],221.91],
        ["Land_BagFence_Long_F",[-39.90,-2.04,0],261.89],
        ["Land_Coil_F",[-39.86,-11.44,0],0],
        ["Land_Razorwire_F",[-41.57,-5.72,0],265.92],
        ["Land_GarbageWashingMachine_F",[-39.10,-15.17,0],60],
        ["Land_Bricks_V2_F",[-41.33,-13.93,0],210.00],
        ["Land_Pallet_F",[-41.41,-16.08,0],87.71],
        ["Land_WheelCart_F",[-44.24,-12.07,0.001],229.44],
        ["Land_Pallets_F",[-42.43,-15.15,0],270]
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
					private _dist = 60 + random 40;
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
				private _dist = 20 + random 25;
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
		_objectData set ["veh10", ["RuggedTerminal_01_communications_F", "Capture H.Q.", [5, 20]]];

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
									_caller sideChat format ["Objective Complete: H.Q. Captured", _actionText];
									nul = [] execVM "missionCompleteScreen.sqf";
									
									//add xp/coins
									[1000] execVM "addXP.sqf";
									[25] execVM "addCredits.sqf";

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
		_objectData set ["aa1", ["I_LT_01_AA_F", "", [40, 90]]];
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
		// === End Crewed Vehicle Spawn System === //



		//==========End New Systems Here==========//

		_spawned = true;
		player sideChat "New Objective: Capture the H.Q.";
		nul = [] execVM "missionBriefings\hqMissionBrief.sqf";
		
			};
};