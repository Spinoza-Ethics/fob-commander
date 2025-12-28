//==========General Settings ==========//

private _markerNameText = "Outpost";
private _markerType = "o_Ordnance";


//Static Groups
private _staticGroupSizeMin = 4; //Default 2
private _staticGroupSizeMax = 7; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 3; //Default 1
private _patrolSizeMax = 6; //Default 6
private _patrolGroupCountMin = 2; //Default 0
private _patrolGroupCountMax = 2; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.3; //Default 0.2
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
_maxAttempts = 600;

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
        ["Land_PaperBox_open_empty_F", [3.50195, -0.660156, 0], 185.427],
        ["Land_BagFence_Long_F", [-2.1582, -3.22656, -0.000999928], 185.427],
        ["Land_HBarrier_3_F", [0.203125, 3.57031, 0], 0],
        ["Land_HBarrier_3_F", [-2.92188, 3.57031, 0], 0],
        ["Land_BagFence_Round_F", [0.429688, -3.92578, -0.00130081], 230.427],
        ["Land_BarrelTrash_grey_F", [4.49023, 0.501953, 2.14577e-06], 185.426],
        ["Land_PaperBox_open_full_F", [4.06641, -2.72656, 0], 305.427],
        ["Land_PaperBox_open_empty_F", [0.0664063, 5.21875, 0], 270],
        ["Land_WoodenBox_F", [2.21484, 5.09766, -2.38419e-07], 15.0001],
        ["Land_Sacks_heap_F", [5.63672, -0.0683594, 0], 290.427],
        ["Land_HBarrier_3_F", [3.32813, 3.57031, 0], 0],
        ["Land_CratesWooden_F", [5.69336, -1.36914, 0], 185.427],
        ["Land_Ammobox_rounds_F", [3.44141, 4.84375, -0.000167847], 239.993],
        ["Land_BagFence_Round_F", [0.921875, -6.64844, -0.00130081], 50.4272],
        ["Land_Sacks_heap_F", [6.82031, -0.0957031, 0], 185.427],
        ["CamoNet_INDP_F", [0.964844, 7.01953, 0], 180],
        ["Land_Garbage_square5_F", [1.35352, 7.66602, 0], 0],
        ["Land_BagFence_Long_F", [3.61914, -7.31055, -0.000999928], 5.42718],
        ["Land_HBarrier_1_F", [-1.17578, 8.84375, 0], 270],
        ["Land_CzechHedgehog_01_F", [-8.86914, -1.83594, 0], 165],
        ["Land_BagBunker_Small_F", [-4.20117, 8.86133, 0], 135],
        ["Land_BagFence_Short_F", [5.72656, -7.52148, -0.0010004], 5.42718],
        ["Land_Razorwire_F", [0.046875, -8.98242, -2.86102e-06], 20.4272],
        ["Land_HBarrier_1_F", [3.19922, 9.46875, 0], 270],
        ["Land_CzechHedgehog_01_F", [-9.15625, 4.66992, 0], 0],
        ["Land_BagBunker_Small_F", [6.04688, 8.87109, 0], 240],
        ["Land_BagBunker_Small_F", [8.48633, -6.33594, 0], 5.42718],
        ["Land_BagFence_Round_F", [12.1973, 0.498047, -0.00130081], 230.427],
        ["Land_BagFence_End_F", [5.13086, 11.0703, -0.00100017], 0],
        ["Land_BagFence_Short_F", [3.55859, 11.4746, -0.0010004], 30],
        ["Land_BagFence_Short_F", [-2.17383, 11.8457, -0.0010004], 165],
        ["Land_BagFence_End_F", [-3.72266, 11.8867, -0.00100017], 195],
        ["Land_BagFence_Round_F", [11.5996, -4.82031, -0.00130081], 320.427],
        ["Land_BagFence_Long_F", [12.2988, -2.23242, -0.000999928], 275.427],
        ["Land_BagFence_Round_F", [-0.554688, 13.1426, -0.00130081], 150],
        ["Land_BagFence_Round_F", [2.12891, 13.1055, -0.00130081], 210],
        ["Land_Razorwire_F", [7.65234, -10.4785, -2.86102e-06], 350.427],
        ["Land_CzechHedgehog_01_F", [-13.9551, 1.26953, 0], 165],
        ["Land_CzechHedgehog_01_F", [12.127, 7.21875, 0], 165],
        ["Land_CzechHedgehog_01_F", [16.4453, 2.875, 0], 165],
        ["Snake_random_F", [19.4355, 31.4551, 0.0083878], 188.73]
    ],
    // Second emplacement
    [
        ["Land_BagFence_Corner_F", [4, 1.88086, -0.000999928], 180],
        ["Land_BagFence_Short_F", [4.01172, 3.25, -0.0010004], 90],
        ["Land_SandbagBarricade_01_F", [-4.43945, -3.04688, 0], 267.043],
        ["Land_BagFence_Short_F", [5.74805, 1.86719, -0.0010004], 0],
        ["Land_CampingChair_V2_F", [5.77148, -2.35547, -4.76837e-07], 357.813],
        ["Land_BarrelWater_F", [6.25977, 1.36523, 1.90735e-06], 179.997],
        ["Land_SandbagBarricade_01_F", [-5.86719, -2.70898, 0], 177.043],
        ["Land_WoodenTable_large_F", [5.84766, -3.28711, -1.19209e-06], 297.816],
        ["Land_BagFence_01_end_green_F", [4.86328, -5.35547, -0.00100017], 105],
        ["Land_BagBunker_Small_F", [5.88477, 5.41992, 0], 180],
        ["Land_SandbagBarricade_01_F", [-7.74023, -2.80664, 0], 177.043],
        ["Land_CratesWooden_F", [-2.56836, -8.45703, 0], 267.043],
        ["Land_GarbageHeap_02_F", [5.94336, -7.30664, 3.33786e-06], 60],
        ["CamoNet_INDP_open_F", [5.79102, -7.18164, -0.0443139], 268.151],
        ["Land_SandbagBarricade_01_F", [-4.17578, -8.16602, 0], 267.043],
        ["Land_BagFence_Short_F", [8.64453, 4.11328, -0.0010004], 180],
        ["Land_BarrelTrash_grey_F", [-1.38086, -9.64648, 1.33514e-05], 267.059],
        ["Land_SandbagBarricade_01_F", [-9.62891, -2.59766, 0], 357.043],
        ["Land_Pallets_F", [4.13867, -8.83594, 0], 75],
        ["Land_BagBunker_Tower_F", [-6.90234, -7.2832, 0], 357.043],
        ["Land_Wreck_Truck_dropside_F", [10.0352, 0.341797, 0], 60],
        ["Land_BagFence_Corner_F", [10.3945, 4.10156, -0.000999928], 0],
        ["Land_BagFence_Short_F", [10.3828, 2.73047, -0.0010004], 270],
        ["Land_SandbagBarricade_01_F", [-4.07813, -10.0391, 0], 267.043],
        ["Land_SandbagBarricade_01_F", [-10.0957, -3.96289, 0], 87.0427],
        ["Land_SandbagBarricade_01_hole_F", [-10.0391, -5.72266, 0], 87.0427],
        ["Land_Barricade_01_4m_F", [-2.26367, -11.9453, 0], 102.043],
        ["Land_SandbagBarricade_01_F", [-3.98828, -11.7852, 0], 267.043],
        ["Land_SandbagBarricade_01_F", [-9.9082, -7.58398, 0], 87.0427],
        ["Land_CampingChair_V2_F", [7.4668, -10.6289, 1.09673e-05], 285.004],
        ["Land_SandbagBarricade_01_F", [-9.81055, -9.45508, 0], 87.0427],
        ["Land_SandbagBarricade_01_F", [-5.47656, -12.7031, 0], 177.043],
        ["Land_SandbagBarricade_01_F", [-7.375, -12.3711, 0], 357.043],
        ["Land_SandbagBarricade_01_F", [-10.0195, -11.3457, 0], 267.043],
        ["Land_SandbagBarricade_01_F", [-9.11914, -12.4609, 0], 357.043],
        ["Land_BagFence_Corner_F", [10.6855, -12.7129, -0.000999928], 309.802],
        ["Land_BagFence_Short_F", [11.7305, -13.5996, -0.0010004], 219.802],
        ["Land_BagBunker_Small_F", [12.1992, -16.4277, 0], 309.802],
        ["Land_BagFence_Short_F", [9.42773, -17.7129, -0.0010004], 309.802],
        ["Land_BagFence_Corner_F", [8.29883, -19.0488, -0.000999928], 129.802],
        ["Snake_random_F", [18.7773, -36.9551, 0.0083878], 68.4768]
    ],
    // Third emplacement
    [
        ["MetalBarrel_burning_F", [3.29492, 2.50586, 0], 116.115],
        ["Land_Wreck_Car_F", [-0.689453, 4.14258, 0], 300],
        ["Land_Garbage_square5_F", [-4.20898, 3.33984, 0], 315],
        ["Land_Garbage_square5_F", [5.2168, -1.6875, 0], 71.1152],
        ["Land_Wreck_Car2_F", [2.68555, -4.91211, 0], 146.115],
        ["Land_Barricade_01_4m_F", [4.9375, -3.77148, 0], 206.115],
        ["Land_Barricade_01_4m_F", [-3.70117, 5.51172, 0], 30],
        ["Land_PaperBox_open_full_F", [-6.87109, 1.42578, 0], 90],
        ["Land_GarbageBags_F", [4.16992, -4.73828, 0], 116.115],
        ["Land_Sacks_heap_F", [7.81836, -0.451172, 0], 281.115],
        ["Land_PaperBox_closed_F", [-7.86719, -0.210938, 0], 210],
        ["Land_PaperBox_open_empty_F", [8.19922, 0.894531, 0], 116.115],
        ["Land_CratesWooden_F", [-9.11328, 1.30078, 0], 315],
        ["Land_BarrelTrash_grey_F", [-9.36328, -0.449219, 1.90735e-06], 0.0026434],
        ["Land_Pallet_MilBoxes_F", [8.95703, 2.4668, 0], 116.115],
        ["Land_BagBunker_Small_F", [-7.57617, 7.06641, 0], 180],
        ["Land_BagBunker_Tower_F", [10.6973, -2.85742, 0], 206.115],
        ["Land_CzechHedgehog_01_F", [1.38672, 11.5508, 0], 240],
        ["Land_Barricade_01_4m_F", [-11.0762, 4.63672, 0], 180],
        ["Land_Wreck_BRDM2_F", [-3.0957, -12.1289, 0.020782], 192.445],
        ["Land_Barricade_01_4m_F", [12.3125, 3.88867, 0], 296.115],
        ["Land_BarrelWater_grey_F", [-4.80273, -12.5664, -0.000997782], 117.445],
        ["Land_BagBunker_Small_F", [-9.7832, -9.55664, 0], 117.445],
        ["Land_BagFence_Short_F", [-4.82617, -13.6934, -0.0010004], 297.445],
        ["Land_Barricade_01_10m_F", [14.3379, -4.75977, 0], 116.115],
        ["Land_Wreck_Skodovka_F", [13.5977, 7.41016, 0.00288773], 11.1152],
        ["Land_CzechHedgehog_01_F", [-7.34961, 14.0664, 0], 0],
        ["Land_BagFence_Round_F", [-9.82617, -13.2871, -0.00130081], 72.4446],
        ["Land_BagFence_Round_F", [-6.2832, -15.3184, -0.00130081], 342.445],
        ["Land_BagFence_Short_F", [-8.3125, -14.6855, -0.0010004], 27.4446],
        ["Land_Tyres_F", [12.9902, 11.123, 0.00659728], 246.501],
        ["Land_CzechHedgehog_01_F", [-14.8809, 11.3086, 0], 165],
        ["Snake_random_F", [32.6621, 6.77734, 0], 116.081],
        ["Snake_random_F", [9.83203, -39.248, 0.0083878], 41.5515],
        ["Snake_random_F", [-6.20703, -44.6719, 0.0083878], 0.519221]
    ],
    // Fourth emplacement
    [
        ["Land_BagFence_End_F", [-2.84375, -1.77734, -0.00100017], 59.6911],
        ["Land_BagFence_Round_F", [-3.61719, 0.298828, -0.00130081], 224.691],
        ["Land_BagFence_Round_F", [1.70898, 4.54883, -0.00130081], 17.5277],
        ["Land_WoodenTable_small_F", [-4.8418, -3.20508, 0.334591], 45.3654],
        ["Land_Tyre_F", [-5.98828, 1.53906, -0.00430298], 269.696],
        ["Land_BagFence_Long_F", [-6.125, 0.84375, -0.000999928], 359.691],
        ["Land_BagFence_Short_F", [3.91992, 4.92969, -0.0010004], 344.331],
        ["Land_BagFence_Round_F", [-0.224609, 6.63477, -0.00130081], 197.528],
        ["Land_HBarrier_3_F", [6.50586, -3.45898, 0], 180],
        ["Land_BagFence_End_F", [-5.16992, -3.43945, -0.00100017], 299.691],
        ["Land_Garbage_square5_F", [-7.05469, -1.63867, 0], 269.691],
        ["Land_BagFence_Round_F", [-2.875, 6.35156, -0.00130081], 17.5277],
        ["Land_PaperBox_open_empty_F", [0.898438, 7.58789, 0], 20],
        ["Land_BagFence_End_F", [-6.62109, 3.20117, -0.00100017], 59.6911],
        ["Land_CampingChair_V2_F", [-7.08594, -3.55273, -2.14577e-06], 104.739],
        ["Land_BagFence_Long_F", [-5.57031, -5.66406, -0.000999928], 89.6911],
        ["Land_HBarrier_1_F", [4.52344, -6.85742, 0], 270],
        ["Land_CncBarrierMedium_F", [-0.460938, 8.20508, 0], 115],
        ["Land_Pallets_F", [5.63281, -5.24023, 0], 60],
        ["Land_CzechHedgehog_01_F", [-2.21289, -8.4375, 0], 0],
        ["Land_BagBunker_Small_F", [8.64063, -1.30078, 0], 180],
        ["Land_MetalBarrel_F", [3.89063, -7.98242, 1.66893e-06], 120.003],
        ["Land_BagFence_Short_F", [-7.77344, 4.45117, -0.0010004], 29.6911],
        ["CamoNet_INDP_open_F", [1.30859, 9.45703, 0], 200.133],
        ["Land_BagFence_Short_F", [-4.25977, 8.15234, -0.0010004], 239.331],
        ["Land_HBarrier_3_F", [-10.3594, 0.783203, 0], 359.691],
        ["Land_BagFence_End_F", [5.91406, -7.30469, -0.00100017], 210],
        ["Land_BagFence_Long_F", [-7.08203, -7.03516, -0.000999928], 359.691],
        ["Land_CncBarrierMedium_F", [0.337891, 10.1484, 0], 95],
        ["Land_HBarrier_1_F", [-10.2383, -0.701172, 0], 359.691],
        ["Land_HBarrier_3_F", [-11.2109, -3.59766, 0], 359.691],
        ["Land_HBarrier_3_F", [-9.18164, -7.05078, 0], 269.691],
        ["Land_BagFence_Long_F", [-9.89063, 4.91797, -0.000999928], 179.691],
        ["Land_BagFence_Long_F", [8.01953, -7.87109, -0.000999928], 180],
        ["Land_CzechHedgehog_01_F", [2.11133, -11.0898, 0], 0],
        ["Land_HBarrier_1_F", [10.7656, -3.47461, 0], 180],
        ["Land_HBarrier_3_F", [-11.3477, 0.5625, 0], 269.691],
        ["Land_BagFence_Short_F", [6.02148, 9.83203, -0.0010004], 64.331],
        ["Land_BagFence_Short_F", [10.7676, -5.0957, -0.0010004], 90],
        ["Land_BagFence_Short_F", [-11.2656, 4.16602, -0.0010004], 269.691],
        ["Land_BagFence_Round_F", [2.13672, 11.6973, -0.00130081], 22.528],
        ["Land_BagFence_Round_F", [4.80078, 11.748, -0.00130081], 202.528],
        ["Land_BagFence_Round_F", [10.6523, -7.16992, -0.00130081], 300],
        ["Land_BagBunker_Small_F", [-13.4141, -1.46094, 0], 89.6911],
        ["Land_BagFence_Round_F", [0.390625, 13.9414, -0.00130081], 202.528],
        ["Land_BagFence_Short_F", [-1.84375, 13.7559, -0.0010004], 169.331],
        ["Land_CzechHedgehog_01_F", [-1.44922, -14.6094, 0], 165],
        ["Land_CzechHedgehog_01_F", [-5.41992, -13.8477, 0], 165],
        ["Rabbit_F", [-34.6758, -13.7832, 0.00223756], 26.0956]
    ],
    // Fifth emplacement
    [
        ["Land_Garbage_square5_F", [-2.79492, -0.291016, 0], 314.966],
        ["Land_BagFence_Short_F", [-2.23242, 4.05469, -0.0010004], 149.966],
        ["Land_Wreck_Truck_dropside_F", [-3.71094, 2.07031, 0], 240.966],
        ["Land_GarbagePallet_F", [-4.93555, -0.644531, 0], 314.966],
        ["Land_BagFence_Short_F", [4.75586, 1.29297, -0.0010004], 180],
        ["Land_GarbageBags_F", [-5.22852, 2.53906, 0], 359.966],
        ["Land_CanisterPlastic_F", [5.62109, 2.54492, 6.19888e-06], 0.00516321],
        ["Land_HBarrier_3_F", [3.47266, 6.1582, 0], 90],
        ["Land_Garbage_square5_F", [5.6582, 3.86719, 0], 0],
        ["Land_CratesWooden_F", [7.24609, 3.04492, 0], 0],
        ["Land_cargo_addon02_V2_F", [7.39063, 3.4707, 0], 0],
        ["Land_BagFence_Short_F", [3.37305, 7.55469, -0.0010004], 90],
        ["Land_HBarrier_5_F", [6.12305, 1.29102, 0], 0],
        ["Land_Garbage_square5_F", [-0.699219, 8.75391, 0], 314.966],
        ["MetalBarrel_burning_F", [-8.98242, 3.85742, 0], 359.966],
        ["Land_Garbage_square5_F", [6.7832, 7.61719, 0], 0],
        ["Land_BagFence_Round_F", [3.91602, 9.66797, -0.00130081], 135],
        ["Land_GarbageBags_F", [-1.77148, 11.3965, 0], 164.966],
        ["Land_HBarrier_1_F", [10.3789, 2.54492, 0], 270],
        ["Land_Sacks_goods_F", [8.98828, 6.1582, 0], 210],
        ["Land_HBarrier_3_F", [10.3477, 6.0332, 0], 90],
        ["Land_Garbage_square5_F", [-9.33789, 7.25391, 0], 314.966],
        ["Land_BagFence_Short_F", [6.11133, 10.0469, -0.0010004], 0],
        ["Land_Garbage_square5_F", [-1.71289, 12.4316, 0], 314.966],
        ["CamoNet_BLUFOR_open_F", [-12.8145, 1.49023, 0], 164.966],
        ["Land_BagBunker_Small_F", [8.99609, 9.59961, 0], 180],
        ["Land_BagFence_Short_F", [10.748, 7.30469, -0.0010004], 90],
        ["Land_Garbage_square5_F", [-12.4609, 5.00195, 0], 314.966],
        ["Land_Wreck_Car_F", [-13.2988, -0.445313, 0], 299.966],
        ["Land_GarbageWashingMachine_F", [-11.5527, 7.58789, 0], 14.9661],
        ["Land_BagBunker_Tower_F", [-7.54688, 11.5703, 0], 89.9661],
        ["Land_GarbageBags_F", [-13.5625, 7.04102, 0], 164.966],
        ["Land_GarbagePallet_F", [-15.0898, -2.36523, 0], 344.966],
        ["Land_Tyre_F", [-15.7656, 4.48828, -0.00430274], 164.969],
        ["Land_JunkPile_F", [-13.6758, 10.2754, 0], 299.966],
        ["Land_Barricade_01_10m_F", [-7.31836, 15.4277, 0], 359.966],
        ["Land_Wreck_Ural_F", [-16, 8.11719, -0.674454], 74.9661],
        ["Land_Cargo20_china_color_V1_ruins_F", [-17.7207, 6.625, 0], 164.966],
        ["Snake_random_F", [28.0547, 16.0488, 0.0083878], 116.437]
    ],


 [
    ["Land_Pallets_F", [-0.310547, 5.04883, 0], 149.758],
    ["Land_Garbage_square5_F", [-4.14648, -1.9043, 0], 167.315],
    ["Land_HBarrier_1_F", [2.96484, 3.42969, 0], 269.758],
    ["Land_HBarrier_3_F", [1.60547, 3.43555, 0], 269.758],
    ["Land_HBarrier_1_F", [4.46484, 3.43555, 0], 269.758],
    ["Land_HBarrier_1_F", [0.0800781, 5.66797, 0], 269.758],
    ["Land_HBarrier_3_F", [3.8418, -6.04102, 0], 180],
    ["Land_BagBunker_Small_F", [5.97656, -3.88281, 0], 180],
    ["Land_BagBunker_Small_F", [6.62891, 5.57031, 0], 269.758],
    ["Land_Pallets_F", [2.96875, -7.82227, 0], 60],
    ["Land_HBarrier_1_F", [4.69922, 7.1875, 0], 269.758],
    ["Land_CratesShabby_F", [-9.00391, 0.462891, 0], 358.386],
    ["Land_WoodenBox_F", [-8.94727, -1.52734, -7.15256e-07], 250.201],
    ["Land_Pallets_F", [-9.14844, 4.39063, 0], 153.234],
    ["Land_HBarrier_1_F", [1.85938, -9.43945, 0], 270],
    ["Land_BagFence_Long_F", [5.32617, 8.56836, -0.000999928], 89.7582],
    ["Land_HBarrier_1_F", [8.10156, -6.05664, 0], 180],
    ["Land_Sacks_heap_F", [-10.5195, 0.53125, 0], 27.137],
    ["Land_WoodenBox_F", [-10.2617, -2.53125, 0], 290.31],
    ["Land_MetalBarrel_F", [1.22656, -10.5645, 1.66893e-06], 120.003],
    ["Land_BagFence_End_F", [3.25, -9.88672, -0.00100017], 210],
    ["Land_Axe_fire_F", [-9.94531, -4.36133, -0.00336075], 186.516],
    ["Land_Sleeping_bag_brown_F", [-6.41211, 9.07031, 0], 242.707],
    ["Land_BagFence_Short_F", [8.10352, -7.67773, -0.0010004], 90],
    ["Land_HBarrier_1_F", [0.806641, 11.2969, 0], 269.758],
    ["Land_WoodPile_F", [-10.1836, -5.22266, 0], 299.698],
    ["Land_CratesWooden_F", [-11.207, 3.17773, 0], 359.327],
    ["Land_BagFence_Short_F", [2.41406, 11.4297, -0.0010004], 359.758],
    ["Land_BagFence_Long_F", [5.35547, -10.4531, -0.000999928], 180],
    ["Land_BagFence_Round_F", [4.48828, 11.3242, -0.00130081], 209.758],
    ["Land_Campfire_F", [-9.30469, 7.44922, 0.0299993], 171.145],
    ["Land_Garbage_square5_F", [-8.6582, 8.41016, 0], 150.663],
    ["Land_Razorwire_F", [-5.48828, -10.7109, -2.86102e-06], 205.582],
    ["Land_BagFence_Round_F", [7.98828, -9.75195, -0.00130081], 300],
    ["Land_Gloves_F", [-7.74219, 9.58203, 9.29832e-05], 242.297],
    ["Land_Axe_F", [-7.64648, 9.76367, -0.00312448], 346.122],
    ["Land_BagFence_Round_F", [-12.5605, 1.69531, -0.00130081], 133.494],
    ["Land_BakedBeans_F", [-8.34375, 9.32031, 9.53674e-07], 227.779],
    ["Land_BagFence_Round_F", [-12.3926, -3.81836, -0.00130081], 43.4938],
    ["Land_BagFence_Long_F", [-12.8926, -1.06055, -0.000999928], 88.4938],
    ["Land_CampingChair_V1_F", [-11.4082, 6.20313, 0.00309086], 241.612],
    ["Land_WoodPile_F", [-7.1582, 10.8359, 0], 238.979],
    ["Land_Camping_Light_F", [-11.4023, 7.03125, -0.0012126], 139.902],
    ["Land_CratesShabby_F", [-13.2461, 3.28711, 0], 133.494],
    ["Land_MetalWire_F", [-8.87305, 11.0234, 0], 168.458],
    ["Land_CampingChair_V1_F", [-11.2383, 9.24023, 0.00308919], 307.939],
    ["Land_TentDome_F", [-5.08398, 14.7227, 0], 198.855],
    ["Land_Can_V1_F", [-11.8047, 11.3379, 3.33786e-06], 213.784],
    ["Land_BakedBeans_F", [-11.6914, 11.4766, 1.90735e-06], 290.176],
    ["Land_Can_V2_F", [-11.875, 11.4375, 3.09944e-06], 148.245],
    ["Land_Canteen_F", [-11.7891, 11.6094, 1.74046e-05], 2.31619],
    ["Land_BakedBeans_F", [-11.6445, 12.3594, 3.57628e-06], 57.5022],
    ["Land_CerealsBox_F", [-11.6074, 12.5234, 2.86102e-06], 173.441],
    ["Land_Bucket_F", [-7.61523, 15.7148, 2.07424e-05], 207.536],
    ["Land_TentDome_F", [-10.7754, 14.8047, 0], 285.142],
    ["Land_TentDome_F", [-5.57617, 18.5371, 0], 59.4971],
    ["Land_TentDome_F", [-15.8555, 12.5918, 4.76837e-07], 71.7282],
    ["Land_TentDome_F", [-10.7617, 19.7676, 4.76837e-07], 206.771],
    ["Land_Sleeping_bag_F", [-14.0391, 17.7168, 2.38419e-07], 165.304],
    ["Land_Sleeping_bag_brown_F", [-15.9805, 16.332, 2.38419e-07], 118.294],
    ["Land_Ammobox_rounds_F", [-15.5664, 17.6328, -0.000167847], 19.524],
    ["Land_Ammobox_rounds_F", [-15.9551, 17.5605, -0.000167847], 63.0838],
    ["Snake_random_F", [30.2207, 20.9648, 0.0083878], 216.299]
  ],
  // Second emplacement
  [
    ["Land_PaperBox_closed_F", [0.978516, -2.52148, 0], 330],
    ["Land_BarrelWater_F", [0.619141, 3.67773, 1.90735e-06], 359.997],
    ["Land_PaperBox_open_empty_F", [2.73828, -2.53125, 0], 90],
    ["Land_BagFence_End_F", [-1.13477, -3.35547, -0.00100017], 255],
    ["Land_HBarrier_1_F", [-3.56836, 2.14844, 0], 165.616],
    ["Land_Sack_F", [-1.63477, -3.90234, 0], 75],
    ["Land_Sacks_heap_F", [1.87109, 3.92773, 0], 135],
    ["Land_BagFence_Round_F", [-2.20117, -4.51953, -0.00130081], 139],
    ["Land_CncBarrierMedium4_F", [2.83789, -4.26367, 0], 0],
    ["Land_BagFence_Long_F", [-5.3125, -0.59375, -0.000999928], 120.616],
    ["Land_SandbagBarricade_01_hole_F", [0.849609, 5.27148, 0], 270],
    ["Land_WoodPile_F", [-5.54883, 1.625, 0], 338.34],
    ["Land_CampingChair_V2_F", [5.46875, -2.24609, -1.43051e-06], 345.276],
    ["Land_WoodenTable_small_F", [5.35938, -2.98242, 0.0871804], 103.297],
    ["Land_CanisterFuel_F", [5.73828, -3.1582, 2.07424e-05], 59.9489],
    ["Land_BagBunker_Small_F", [3.40625, 6.31836, 0], 180],
    ["Land_CanisterFuel_F", [6.10938, -3.18945, 2.0504e-05], 84.9563],
    ["Land_Garbage_square5_F", [3.18359, -6.19531, 0], 90],
    ["Land_Axe_F", [-6.52734, 2.2793, -0.00336075], 85.493],
    ["Land_BagFence_End_F", [6.87109, -0.396484, -0.00100017], 242],
    ["Land_BagFence_Long_F", [-4.9082, 5.2793, -0.000999928], 30.616],
    ["Land_BottlePlastic_V1_F", [1.14844, -7.14453, 3.40939e-05], 87.951],
    ["Land_SandbagBarricade_01_F", [0.816406, 7.13672, 0], 270],
    ["Land_BottlePlastic_V1_F", [1.24414, -7.2168, 3.26633e-05], 89.9554],
    ["Land_PortableLongRangeRadio_F", [0.863281, -7.28125, -2.38419e-07], 40.0014],
    ["Land_BagFence_Long_F", [-6.71484, -2.96094, -0.000999928], 120.616],
    ["Land_Ammobox_rounds_F", [6.61328, -3.28125, -0.00016737], 345.004],
    ["Land_BagFence_Round_F", [-2.68164, -7.16406, -0.00130081], 60],
    ["Land_Ammobox_rounds_F", [1.5, -7.375, -0.000167847], 249.996],
    ["Land_Ammobox_rounds_F", [1.11328, -7.53125, -0.000167847], 39.9952],
    ["Land_SandbagBarricade_01_hole_F", [5.71484, 5.37891, 0], 90],
    ["Land_PlasticCase_01_small_F", [6.90039, -3.9082, -0.0010004], 177.018],
    ["Land_TinContainer_F", [-7.5, -2.7832, 0.0012114], 209.815],
    ["Land_CanisterPlastic_F", [-7.60742, -3.125, -7.15256e-07], 19.0532],
    ["Land_BagFence_End_F", [-1.00586, -8.57227, -0.00100017], 45],
    ["Land_CncBarrierMedium_F", [-0.136719, -8.26367, 0], 0],
    ["Land_SandbagBarricade_01_F", [1.6582, 8.17383, 0], 180],
    ["Land_BagFence_Long_F", [8.61523, -1.76563, -0.000999928], 25],
    ["Land_CanisterPlastic_F", [-8.26953, -3.13672, 1.43051e-06], 149.653],
    ["Land_SandbagBarricade_01_hole_F", [3.39844, 8.20508, 0], 180],
    ["Land_SandbagBarricade_01_F", [5.74609, 7.13867, 0], 90],
    ["Land_BagBunker_Small_F", [3.04297, -9.49023, 0], 0],
    ["Land_Garbage_square5_F", [-1.31055, -9.57031, 0], 188],
    ["Land_SandbagBarricade_01_F", [5.0332, 8.17383, 0], 180],
    ["Land_Garbage_square5_F", [-9.73828, 0.904297, 0], 130.024],
    ["CamoNet_INDP_open_F", [-9.17383, 0.0546875, 0], 300.616],
    ["Land_BagFence_Long_F", [-7.27539, 6.67969, -0.000999928], 30.616],
    ["Land_BagFence_Long_F", [5.98438, -8.01563, -0.000999928], 0],
    ["FirePlace_burning_F", [-10.1074, -0.814453, -9.53674e-07], 300.616],
    ["Land_CanisterFuel_F", [6.98828, -7.5332, 2.36034e-05], 319.956],
    ["Land_HBarrier_1_F", [-8.12695, -6.78711, 0], 60.616],
    ["Land_BarrelWater_F", [10.1836, 3.44922, 2.14577e-06], 62.4775],
    ["Land_BagFence_Long_F", [10.2246, -3.78906, -0.000999928], 255],
    ["Land_CncBarrierMedium_F", [8.23242, -7.38867, 0], 345],
    ["Land_Sacks_heap_F", [10.9844, 2.45508, 0], 197.478],
    ["Land_BarrelWater_F", [-9.82422, 5.55469, 2.14577e-06], 300.609],
    ["Land_Garbage_square5_F", [-11.1152, -2.89063, 0], 130.024],
    ["Land_TentDome_F", [-11.0508, 3.85547, 0], 240.616],
    ["Land_BagFence_Round_F", [10.6406, -6.57227, -0.00130081], 295],
    ["Land_BagFence_End_F", [9.29883, -8.18945, -0.00100017], 107],
    ["Land_HBarrier_1_F", [-10.4883, 6.38867, 0], 255.616],
    ["Land_SandbagBarricade_01_hole_F", [11.7012, 3.98047, 0], 332.478],
    ["Land_WoodenLog_F", [-12.5039, -2.62109, 8.34465e-06], 300.617],
    ["Land_TentDome_F", [-13.3184, 0.628906, 0], 195.616],
    ["Land_BagBunker_Small_F", [13.8145, 2.19727, 0], 242.478],
    ["Land_BagFence_Round_F", [-11.2637, -7.82813, -0.00130081], 345.616],
    ["Land_Pallet_F", [-12.2949, 6.28906, -2.38419e-07], 270.269],
    ["Land_SandbagBarricade_01_hole_F", [14.0488, -0.283203, 0], 152.478],
    ["Land_SandbagBarricade_01_F", [13.3457, 4.87305, 0], 332.478],
    ["Land_MetalBarrel_F", [-14.1406, -3.94727, 1.43051e-06], 120.611],
    ["Land_CratesWooden_F", [-14.5801, -2.23438, 0], 270.616],
    ["Land_BagFence_Round_F", [-13.8008, -7.06055, -0.00130081], 45.616],
    ["Land_BagFence_End_F", [-14.5469, -4.9707, -0.00100017], 240.616],
    ["Land_SandbagBarricade_01_F", [14.6504, 4.60742, 0], 242.478],
    ["Land_SandbagBarricade_01_F", [15.6211, 0.5, 0], 152.478],
    ["Land_SandbagBarricade_01_hole_F", [15.4844, 3.07422, 0], 242.478],
    ["Land_HBarrier_1_F", [-15.9961, -2.40625, 0], 165.616],
    ["Land_SandbagBarricade_01_F", [16.209, 1.61523, 0], 242.478],
    ["Snake_random_F", [24.5273, -36.8477, 0], 9.297],
    ["Snake_random_F", [-22.4023, 38.6504, 0.0083878], 12.2749]
  ],
  // Third emplacement
  [
    ["Land_PaperBox_closed_F", [0.125, 3.01367, 0], 270.651],
    ["Land_CampingChair_V1_F", [-3.86328, 0.515625, 0.0030911], 164.995],
    ["Land_Wreck_Truck_dropside_F", [2.58984, -3.74609, 0], 237.94],
    ["Land_PaperBox_closed_F", [0.191406, 4.64648, 0], 182.667],
    ["Land_PaperBox_open_empty_F", [2.13672, 4.76563, 0], 281.154],
    ["Land_CampingChair_V1_F", [-5.86328, 0.640625, 0.00309443], 194.997],
    ["Campfire_burning_F", [-4.86328, 3.51563, 0.0299993], 311.909],
    ["Land_Barricade_01_4m_F", [1.44922, -6.06641, 0], 297.94],
    ["Land_Pallets_F", [1.17383, 5.89844, 0], 288.686],
    ["Land_GarbageBags_F", [-4.8457, -6.01953, 0], 327.94],
    ["Land_GarbageBags_F", [-6.89453, -4.71875, 0], 327.94],
    ["Land_CampingChair_V1_F", [-7.73828, 3.14063, 0.00308895], 284.997],
    ["Land_CampingChair_V1_F", [-6.61328, 5.26563, 0.00309086], 314.989],
    ["Land_Garbage_square5_F", [-7.42188, 4.33594, 0], 198.821],
    ["Land_SandbagBarricade_01_hole_F", [1.08398, -8.92188, 0], 297.94],
    ["Land_BagFence_Round_F", [0.591797, 9.76758, -0.00130081], 315],
    ["Land_Wreck_Ural_F", [-8.85742, -5.46484, 0.00151062], 267.94],
    ["Land_Ammobox_rounds_F", [-0.0234375, 10.5508, -0.000167847], 36.7558],
    ["Land_Ammobox_rounds_F", [-0.416016, 10.5977, -0.000167847], 80.3211],
    ["Land_Tyres_F", [-8.0918, -6.96289, 0.00659728], 327.94],
    ["Land_DuctTape_F", [0.238281, 10.8711, 0], 33.5592],
    ["Land_Canteen_F", [-0.0898438, 10.9082, 1.88351e-05], 73.3638],
    ["Land_SandbagBarricade_01_half_F", [0.263672, -10.9297, 0], 117.94],
    ["Land_Sleeping_bag_F", [-0.318359, 11.668, 0], 91.105],
    ["Land_Pallet_MilBoxes_F", [-3.31641, -11.7676, 0], 177.94],
    ["Land_BagFence_Long_F", [0.996094, 12.3867, -0.000999928], 270],
    ["CamoNet_BLUFOR_open_F", [-7.62695, -9.32227, 0], 177.94],
    ["Land_SandbagBarricade_01_hole_F", [-1.11133, -12.4805, 0], 147.94],
    ["Land_BarrelTrash_grey_F", [-9.17969, -8.61328, 2.14577e-06], 177.937],
    ["Land_Camping_Light_F", [-0.21875, 12.6211, -0.00121665], 27.4177],
    ["Land_PaperBox_open_full_F", [-11.2324, 5.89844, 0], 222.039],
    ["Land_Barricade_01_10m_F", [-11.9844, -4.67188, 0], 177.94],
    ["Land_SandbagBarricade_01_F", [-3.04492, -13.1973, 0], 177.94],
    ["Land_CratesWooden_F", [-11.334, -7.81445, 0], 177.94],
    ["Land_BagFence_Round_F", [-10.1133, 9.81055, -0.00130081], 45],
    ["Land_Sleeping_bag_F", [-8.85547, 10.9863, 0], 226.105],
    ["Land_Sleeping_bag_brown_F", [-0.703125, 14.1563, 0], 105.534],
    ["Land_Canteen_F", [-0.0820313, 14.6172, 1.7643e-05], 13.1056],
    ["Land_PainKillers_F", [-0.320313, 14.7773, -4.76837e-07], 335.04],
    ["Land_DuctTape_F", [-9.22656, 11.9609, 0], 33.5592],
    ["Land_BagFence_Long_F", [0.996094, 15.1367, -0.000999928], 270],
    ["Land_Canteen_F", [-9.55469, 11.9961, 1.88351e-05], 73.3638],
    ["Land_BagBunker_Small_F", [-5.60938, -15.0059, 0], 357.94],
    ["Land_SandbagBarricade_01_hole_F", [-8.29492, -13.1133, 0], 357.94],
    ["CamoNet_INDP_big_F", [-5.0332, 14.627, 0], 0],
    ["Land_JunkPile_F", [0.476563, -15.7715, 0], 252.94],
    ["Land_Barricade_01_4m_F", [-1.69336, -16.0605, 0], 12.9399],
    ["Land_Sleeping_bag_brown_F", [-9.1582, 13.7324, 0], 270.534],
    ["Land_BagFence_Long_F", [-10.4727, 12.5195, -0.000999928], 90],
    ["Land_Sleeping_bag_F", [-0.529297, 17.0625, 0], 61.105],
    ["Land_SandbagBarricade_01_half_F", [-10.4453, -13.4063, 0], 177.94],
    ["Land_BagFence_Round_F", [0.636719, 17.8457, -0.00130081], 225],
    ["Land_SandbagBarricade_01_hole_F", [-12.4727, -12.9902, 0], 207.94],
    ["Land_SandbagBarricade_01_half_F", [-14.0313, -11.6211, 0], 237.94],
    ["Land_BagFence_Long_F", [-10.4727, 15.2695, -0.000999928], 90],
    ["Land_Sleeping_bag_F", [-9.29883, 16.1621, 0], 256.105],
    ["Land_Canteen_F", [-9.5, 16.8555, 1.7643e-05], 13.1056],
    ["Land_PainKillers_F", [-9.73828, 17.0156, -4.76837e-07], 335.04],
    ["Land_Ammobox_rounds_F", [-9.36328, 17.2656, -0.000167847], 36.7558],
    ["Land_Ammobox_rounds_F", [-9.75586, 17.3125, -0.000167847], 80.3211],
    ["Land_Wreck_Skodovka_F", [-16.6484, -10.875, 0.00288773], 132.94],
    ["Land_BagFence_Round_F", [-10.0684, 17.8887, -0.00130081], 135],
    ["Land_CzechHedgehog_01_F", [6.81641, -19.0625, 0], 147.94],
    ["Land_Razorwire_F", [3.04492, -20.8848, -2.86102e-06], 162.94],
    ["Land_CzechHedgehog_01_F", [-3.25781, -22.666, 0], 192.94],
    ["Land_CzechHedgehog_01_F", [-9.13477, -22.7539, 0], 177.94],
    ["Land_Razorwire_F", [-12.1641, -21.6094, -2.86102e-06], 207.94],
    ["Snake_random_F", [-4.91797, -24.7617, 0.0083878], 8.43637],
    ["Land_CzechHedgehog_01_F", [-19.2715, -17.9551, 0], 357.94]
  ],
  // Fourth emplacement
  [
    ["Land_BagFence_Round_F", [3.70898, -0.21875, -0.00130081], 225],
    ["Land_CampingChair_V1_F", [1.37695, -4.19531, 0.00309181], 124.475],
    ["Land_CampingTable_small_F", [-0.306641, -4.50977, 0.00260305], 154.131],
    ["Land_Canteen_F", [0.296875, -4.96289, 1.90735e-05], 10.0504],
    ["Land_Bucket_F", [-1.54883, -4.76367, 2.19345e-05], 55.3004],
    ["Land_BagFence_Long_F", [4.07031, -2.92773, -0.000999928], 270],
    ["Land_CampingChair_V1_F", [-0.0800781, -5.11719, 0.00308943], 155.807],
    ["Land_BagFence_Short_F", [-3.63867, 3.79883, -0.0010004], 359.887],
    ["Land_Sacks_heap_F", [-2.54297, -4.63477, 0], 262.242],
    ["Land_Portable_generator_F", [3.15625, -4.58398, -0.000804663], 179.214],
    ["Land_WoodenBox_F", [-4.89063, -3.16992, 0], 30.0001],
    ["Land_BagFence_Corner_F", [1.00195, 6.04297, -0.000999928], 359.887],
    ["Land_PortableLight_single_F", [2.52539, -5.33203, 0], 134.132],
    ["Land_Garbage_square5_F", [-5.98438, -0.115234, 0], 15],
    ["Land_BagFence_Short_F", [-0.75, 6.05273, -0.0010004], 179.887],
    ["Land_BagFence_Long_F", [1.08203, -6.0332, -0.000999928], 0],
    ["Land_BagFence_Long_F", [-1.78516, -6.06445, -0.000999928], 180],
    ["Land_BagFence_Round_F", [3.66602, -5.67188, -0.00130081], 315],
    ["Land_BagFence_Corner_F", [-5.39063, 3.8125, -0.000999928], 179.887],
    ["Land_BagFence_Round_F", [-6.54102, -0.34375, -0.00130081], 225],
    ["Land_BagFence_Long_F", [-6.17969, -2.92773, -0.000999928], 270],
    ["Land_MetalBarrel_F", [-6.78906, -2.92383, 1.66893e-06], 59.993],
    ["Land_BagFence_Short_F", [-5.38086, 5.17969, -0.0010004], 89.887],
    ["Land_Wreck_HMMWV_F", [-5.37109, -5.35742, 0.0207825], 315],
    ["Land_BagBunker_Small_F", [-3.51172, 7.35352, 0], 179.887],
    ["Land_BagFence_Long_F", [-9.28516, 0.185547, -0.000999928], 180],
    ["Land_Sleeping_bag_F", [1.36133, -9.97461, 0], 5.312],
    ["Land_Sleeping_bag_brown_F", [-1.57422, -10.252, 0], 345.534],
    ["Land_Sleeping_bag_F", [3.55273, -9.97461, 0], 359.138],
    ["Land_Razorwire_F", [11.3086, 2.42383, -2.86102e-06], 88.3768],
    ["CamoNet_INDP_F", [2.57422, -10.8203, 0], 0],
    ["Land_Pallet_F", [-5.52734, -10.6445, -2.38419e-07], 354.292],
    ["Land_CzechHedgehog_01_F", [10.8105, 5.62305, 0], 58.3767],
    ["Land_Sacks_heap_F", [6.34766, -10.8945, 0], 282.137],
    ["Land_CzechHedgehog_01_F", [11.6367, -5.5625, 0], 238.377],
    ["Land_Cages_F", [-12.6641, -4.37695, 0], 27.5906],
    ["Land_CratesPlastic_F", [6.15234, -11.9824, 0], 195],
    ["Land_BagFence_End_F", [-9.73828, -8.67578, -0.00100017], 345],
    ["Land_CratesWooden_F", [-12.6758, -6.30664, 0], 347.591],
    ["Land_BagFence_Round_F", [9.41797, -10.9043, -0.00130081], 225],
    ["Land_BagFence_End_F", [-13.6934, -2.79492, -0.00100017], 330],
    ["Land_BagFence_Round_F", [-5.23242, -13.3965, -0.00130081], 135],
    ["Land_WoodenBox_F", [-12.4297, -7.97266, 9.53674e-07], 162.592],
    ["Land_Pallets_F", [-7.26563, -14.1035, 0], 357.166],
    ["Land_BagFence_Round_F", [-11.6113, -9.74219, -0.00130081], 345],
    ["Land_CratesWooden_F", [-4.27734, -14.7695, 0], 105],
    ["Land_BagFence_Long_F", [-15.1309, -4.39648, -0.000999928], 300],
    ["Land_BagFence_Long_F", [-14.0293, -8.76172, -0.000999928], 30],
    ["Land_BagFence_Long_F", [9.83203, -13.6484, -0.000999928], 270],
    ["Land_BagFence_Round_F", [-16.2051, -7.03906, -0.00130081], 75],
    ["Land_ChairWood_F", [1.60938, -17.3711, 5.00679e-06], 44.9872],
    ["Land_BagFence_Long_F", [6.72656, -16.7852, -0.000999928], 180],
    ["Land_CzechHedgehog_01_F", [-12.9688, -12.9121, 0], 43.1878],
    ["Land_BagFence_Round_F", [9.42773, -16.3926, -0.00130081], 315],
    ["Land_Pallets_stack_F", [6.17969, -17.8633, -0.00100017], 91.3138],
    ["Land_Pallet_MilBoxes_F", [7.97461, -18.166, 0], 5.08639],
    ["Land_TentDome_F", [-4.05664, -19.7305, 0], 151.936],
    ["Land_TentDome_F", [0.873047, -20.6445, 0], 345.268],
    ["Land_Razorwire_F", [-11.6484, -15.8691, -2.86102e-06], 73.1878],
    ["Land_TentDome_F", [5.78711, -20.7598, 0], 333.953],
    ["Snake_random_F", [-12.0664, 21.4297, 0.0083878], 211.456],
    ["Land_CzechHedgehog_01_F", [-9.24023, -23.4883, 0], 223.188]
  ],
  // Fifth emplacement
  [
    ["Land_Barricade_01_4m_F", [0.580078, 2.71484, 0], 195],
    ["Land_Cargo40_china_color_V1_ruins_F", [2.01563, 2.48633, 0], 15],
    ["Land_Wreck_Truck_dropside_F", [-6.41016, 5.86133, 0], 120],
    ["Land_Garbage_square5_F", [-7.57422, 3.53125, -0.049659], 306.816],
    ["Land_Sleeping_bag_F", [-0.728516, -8.29297, 0], 102.976],
    ["CamoNet_INDP_open_F", [2.32031, -7.68555, 0], 178.838],
    ["Land_BagFence_End_F", [-7.23828, -4.89453, -0.00100017], 39.9384],
    ["Land_BagFence_Long_F", [-8.36523, -3.04492, -0.000999928], 67.9384],
    ["Land_Ammobox_rounds_F", [5.4668, -7.29102, -0.000167847], 215.599],
    ["Land_DuctTape_F", [5.21094, -7.61523, 0], 212.398],
    ["Land_BagFence_Short_F", [-9.2207, -0.978516, -0.0010004], 247.938],
    ["Land_Ammobox_rounds_F", [5.85938, -7.33008, -0.000167847], 259.159],
    ["Land_Canteen_F", [5.54102, -7.64453, 1.93119e-05], 252.199],
    ["Land_GarbageBags_F", [-8.62305, 4.25977, 0], 15],
    ["Land_BagFence_End_F", [-9.35938, 0.554688, -0.00100017], 279.938],
    ["Land_BagFence_End_F", [-6.79883, -6.5332, -0.00100017], 354.938],
    ["MetalBarrel_burning_F", [1.26367, 10.3691, 0], 0],
    ["Land_Sleeping_bag_F", [5.7832, -8.40039, 0], 269.943],
    ["Land_CratesShabby_F", [-3.0293, -10.0254, 0], 192.224],
    ["Land_BarrelTrash_grey_F", [-0.544922, 10.7148, 1.90735e-06], 359.997],
    ["Land_BagFence_End_F", [-10.1953, 1.66211, -0.00100017], 9.93845],
    ["Land_Camping_Light_F", [5.70313, -9.35742, -0.00121665], 206.231],
    ["Land_Garbage_square5_F", [-10.709, -3.15039, 0], 247.938],
    ["Land_WoodenBox_F", [-3.97656, -10.3535, -2.38419e-07], 102.949],
    ["Land_Sleeping_bag_F", [-0.00195313, -10.7207, 0], 49.1503],
    ["Land_Canteen_F", [4.30078, -10.6113, 1.83582e-05], 221.891],
    ["I_Quadbike_01_F", [11.1836, -2.12109, -0.0102472], 28.8442],
    ["Land_BagFence_Long_F", [-9.02344, -7.10742, -0.000999928], 157.938],
    ["Land_Sacks_heap_F", [-3.00781, -11.2832, 0], 205.975],
    ["Land_PainKillers_F", [4.43359, -10.8672, -4.76837e-07], 183.874],
    ["Land_CratesWooden_F", [0.705078, 11.8398, 0], 0],
    ["Land_Sleeping_bag_F", [5.07031, -10.5098, 0], 314.372],
    ["Land_PaperBox_open_empty_F", [-1.79492, 12.0898, 0], 150],
    ["Land_Ammobox_rounds_F", [-12.1914, -1.63281, -0.000167608], 134.924],
    ["Land_Ammobox_rounds_F", [-12.332, -1.28516, -0.000167847], 359.942],
    ["Land_BagFence_Long_F", [-12.4023, 1.23242, -0.000999928], 157.938],
    ["Land_BagFence_Long_F", [-10.8125, -6.32813, -0.000999928], 67.9384],
    ["Land_Garbage_square5_F", [-9.43945, 9.16602, 0], 315],
    ["Land_BagFence_Long_F", [-13.1348, -0.671875, -0.000999928], 247.938],
    ["Land_JunkPile_F", [10.1797, 9.01563, 0], 270],
    ["Land_BagBunker_Small_F", [-13.3926, -4.14258, 0], 67.9384],
    ["Land_GarbageBags_F", [-7.7793, 10.5488, 0], 270],
    ["Land_Barricade_01_4m_F", [9.58008, 11.0898, 0], 75],
    ["I_Quadbike_01_F", [13.7422, -4.94531, -0.0102324], 58.8386],
    ["Land_Pallet_vertical_F", [10.4766, -10.3867, 9.53674e-07], 178.848],
    ["Land_Tyres_F", [-5.35742, 14.1563, 0.00659728], 270],
    ["Land_Wreck_Skodovka_F", [12.8848, 8.35547, 0.00288773], 105],
    ["Land_CratesWooden_F", [10.4375, -11.5, 0], 178.838],
    ["Land_WoodPile_large_F", [10.5176, 11.6309, 0.0232067], 150],
    ["Land_Wreck_Ural_F", [-7.03516, 14.3008, 0.00151062], 210],
    ["Land_CratesShabby_F", [10.6211, -12.9727, 0], 73.8384],
    ["Land_BagBunker_Large_F", [3.58398, 17.166, 0], 180],
    ["Land_Razorwire_F", [0.855469, -17.9004, -2.86102e-06], 178.838],
    ["Land_Razorwire_F", [8.6582, -16.291, -2.86102e-06], 163.838],
    ["Land_BagFence_Round_F", [17.4023, -10.7305, -0.00130081], 237.555],
    ["Land_BagFence_Round_F", [16.8145, -13.291, -0.00130081], 325.147],
    ["Land_Barricade_01_10m_F", [3.83008, 22.9648, 0], 0],
    ["Snake_random_F", [-23.9473, -7.65625, 0], 203.806]
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
		private _groupDistanceFromCampMax = 100;

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
			private _patrolRadius = 160 + random (400 - 80);
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
		_objectData set ["veh1", ["Box_NATO_WpsSpecial_F", "", [5, 30]]];
		_objectData set ["veh2", ["Box_NATO_AmmoOrd_F", "", [5, 30]]];
		_objectData set ["veh3", ["Box_NATO_WpsLaunch_F", "", [5, 30]]];
		_objectData set ["veh4", ["Box_NATO_Wps_F", "", [5, 30]]];
		_objectData set ["veh5", ["Box_NATO_Equip_F", "", [5, 30]]];
		_objectData set ["veh6", ["Box_NATO_Grenades_F", "", [5, 30]]];
		_objectData set ["veh7", ["B_supplyCrate_F", "", [5, 30]]];
		_objectData set ["veh8", ["Box_NATO_Uniforms_F", "", [5, 30]]];
		_objectData set ["veh9", ["B_CargoNet_01_ammo_F", "", [5, 30]]];

		private _basePosition = _campPos; 

		// Min and max number of objects to spawn
		private _minObjectsToSpawn = 2;
		private _maxObjectsToSpawn = 3;
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
		
		// === Start Object Spawn System === //
		private _objectData = createHashMap;
			
		//script ref(needed), obj file name, add action(leave empty to remove), spawn range min,max
		_objectData set ["veh10", ["RuggedTerminal_01_communications_F", "Capture Outpost", [5, 30]]];

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
									_caller sideChat format ["Objective Complete: Outpost Captured", _actionText];
									nul = [] execVM "missionCompleteScreen.sqf";
									
									//add xp/coins
									[200] execVM "addXP.sqf";
									[5] execVM "addCredits.sqf";

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

		//==========End New Systems Here==========//

		_spawned = true;
		player sideChat "New Objective: Capture the Outpost";
		nul = [] execVM "missionBriefings\outpostMissionBrief.sqf";
		
			};
};