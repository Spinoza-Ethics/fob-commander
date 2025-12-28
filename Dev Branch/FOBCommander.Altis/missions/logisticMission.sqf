//==========General Settings ==========//

private _markerNameText = "Logistics";
private _markerType = "o_maint";


//Static Groups
private _staticGroupSizeMin = 3; //Default 2
private _staticGroupSizeMax = 7; //Default 8
private _staticGroupCountMin = 2; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 3; //Default 1
private _patrolSizeMax = 6; //Default 6
private _patrolGroupCountMin = 1; //Default 0
private _patrolGroupCountMax = 2; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.3; //Default 0.2
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
        ["Land_PaperBox_open_full_F", [-2.00586, 3.60156, 0], 90],
        ["Land_BagFence_Long_F", [-4.12305, 0.537109, -0.000999928], 0],
        ["Land_Medevac_house_V1_F", [-0.621094, 5.83008, 0], 0],
        ["Land_Pallets_F", [0.791016, -6.83203, 0], 276.992],
        ["Land_BagFence_Long_F", [3.77148, 5.52539, -0.000999928], 90],
        ["Land_BagFence_End_F", [-4.30078, -6.01953, -0.00100017], 92.9765],
        ["Land_BagFence_Long_F", [-6.99023, 0.505859, -0.000999928], 180],
        ["CamoNet_OPFOR_open_F", [-2.0332, -7.60938, 0], 5.49837],
        ["Land_Sacks_heap_F", [-7.12305, 3.05078, 0], 203.249],
        ["Land_PaperBox_open_full_F", [-2.57422, -7.56641, 0], 45.2475],
        ["Land_PaperBox_open_empty_F", [-6.99609, 4.72656, 0], 0],
        ["Land_PaperBox_closed_F", [-4.91797, -7.25781, 0], 287.977],
        ["Land_MetalBarrel_F", [-1.88672, -8.68555, 1.66893e-06], 152.954],
        ["Land_BagFence_Long_F", [3.77148, 8.40039, -0.000999928], 90],
        ["Land_BagFence_Round_F", [-9.53516, 1.0293, -0.00130081], 45],
        ["Land_Wall_IndCnc_4_D_F", [2.01563, 10.0859, 0], 180],
        ["Land_BagFence_Round_F", [-9.44922, 3.64648, -0.00130081], 135],
        ["Land_Wall_IndCnc_Pole_F", [-2.06836, 10.0723, 0], 0],
        ["Land_Wall_IndCnc_4_F", [-7.98828, 5.88281, 0], 270],
        ["Land_TTowerSmall_1_F", [-5.47461, 7.6582, 0], 0],
        ["Land_PowerGenerator_F", [-7.12109, 8.46094, 0], 180],
        ["Land_Wall_IndCnc_4_F", [-6.13477, 10.0156, 0], 0],
        ["Land_PaperBox_open_empty_F", [7.11133, -11.1445, 0], 223.635],
        ["Land_Medevac_house_V1_F", [4.86523, -14.623, 0], 133.635],
        ["Land_PaperBox_closed_F", [8.39648, -12.2852, 0], 40.0019],
        ["Land_Pallet_MilBoxes_F", [-8.01367, -13.1543, 0], 264.297],
        ["Land_Medevac_house_V1_F", [-3.97461, -16.3203, 0], 208.635],
        ["Land_Pallets_stack_F", [-8.73438, -15.2109, -0.00100017], 299.388],
        ["Land_BagFence_Long_F", [8.79688, -16.2461, -0.000999928], 312.617],
        ["Land_Pallets_stack_F", [2.41406, -18.5508, 0], 347.334],
        ["Land_BagFence_Long_F", [6.88086, -18.3281, -0.000999928], 312.617],
        ["Snake_random_F", [-16.3379, 12.1172, 0.0083878], 179.553],
        ["Land_BagFence_Long_F", [-7.32031, -19.1191, -0.000999451], 210.729],
        ["Land_BagFence_Long_F", [-4.88867, -20.5645, -0.000999451], 210.729],
        ["Snake_random_F", [21.707, 14.4199, 0.0083878], 278.246],
        ["Snake_random_F", [-43.4727, -2.34766, 0.0083878], 91.0538],
        ["Rabbit_F", [30.9863, 32.416, 0.00223756], 310.035]
    ],

    // Second emplacement
    [
        ["Land_Pallets_stack_F", [-5.07813, -0.912109, -2.38419e-07], 2.04762],
        ["Land_PaperBox_closed_F", [-5.25977, -3.34961, 0], 210.651],
        ["Land_Pallet_vertical_F", [-6.00391, -2.58789, 2.26498e-05], 129.027],
        ["Land_Pallet_F", [-7.04297, -1.42188, -2.38419e-07], 153.337],
        ["Land_Cargo20_white_F", [-1.00781, 7.36719, 0], 270],
        ["Land_BagFence_Long_F", [4.61523, 6.55273, -0.000999928], 0],
        ["Land_Pallets_stack_F", [5.68945, -6.24414, -0.00100017], 271.735],
        ["Land_BagFence_Long_F", [3.22852, 7.9082, -0.000999928], 270],
        ["Land_Cargo20_white_F", [-5.25781, 7.49219, 4.76837e-07], 270],
        ["Land_Pallets_F", [7.6543, -4.58008, 0], 177.56],
        ["WaterPump_01_sand_F", [9.05078, -3.24023, 0.000850677], 345.002],
        ["Land_BagFence_Round_F", [9.91992, -0.958984, -0.00130081], 210],
        ["Land_BagFence_Long_F", [5.91797, -7.91406, -0.000999928], 165],
        ["Land_ToiletBox_F", [2.36914, 9.91211, 2.86102e-06], 45.0009],
        ["Land_Medevac_house_V1_F", [6.86914, 8.89063, 0], 0],
        ["Land_BagFence_Long_F", [8.61133, -7.19922, -0.000999928], 345],
        ["Land_HBarrier_Big_F", [-4.86328, -9.97852, 4.76837e-07], 170.538],
        ["Land_BagFence_Long_F", [10.9668, -3.48242, -0.000999928], 255],
        ["Land_BagFence_End_F", [8.92969, 6.81055, -0.00100017], 180],
        ["Land_BagFence_Long_F", [-1.12695, 11.8965, -0.000999928], 180],
        ["Land_BagFence_Long_F", [1.74805, 11.8965, -0.000999928], 180],
        ["Land_LampShabby_F", [9.31836, 7.29492, 0], 165],
        ["Land_HBarrier_Big_F", [-12.2441, -0.136719, 4.76837e-07], 257.272],
        ["Land_BagFence_Round_F", [11.2148, -6.15039, -0.00130081], 300],
        ["Land_BagFence_Long_F", [-3.75195, 11.8965, -0.000999928], 180],
        ["Land_BagFence_Corner_F", [10.4668, 6.78516, -0.000999928], 90],
        ["Land_BagFence_Corner_F", [3.13477, 12.9219, -0.000999928], 270],
        ["Land_HBarrier_Big_F", [-10.209, -8.01758, 4.76837e-07], 257.272],
        ["Land_BagFence_Short_F", [10.4941, 8.55664, -0.0010004], 90],
        ["Land_BagFence_Long_F", [-6.62695, 11.8965, -0.000999928], 180],
        ["Land_BagFence_Long_F", [5.12305, 12.8965, -0.000999928], 180],
        ["Land_HBarrier_Big_F", [-11.6484, 7.75586, 0], 120.34],
        ["Land_PowerGenerator_F", [11.4941, 8.14648, 0], 180],
        ["Land_BagFence_Corner_F", [-8.60742, 11.9238, -0.000999928], 270],
        ["Land_BagFence_Long_F", [10.4766, 10.918, -0.000999928], 270],
        ["Land_BagFence_Long_F", [7.99805, 12.8965, -0.000999928], 180],
        ["Land_TTowerSmall_1_F", [11.3887, 9.92383, 0], 0],
        ["Land_BagFence_Corner_F", [10.5039, 12.8984, -0.000999928], 0]
    ],

    // Third emplacement
    [
        ["Land_ToiletBox_F", [-6.72852, 0.0507813, 1.90735e-06], 270.001],
        ["Land_ToiletBox_F", [-6.60352, 1.67578, 3.8147e-06], 285.002],
        ["C_Van_02_medevac_F", [-3.53125, 7.00977, -0.058928], 183.603],
        ["Land_BagFence_Long_F", [-8.46094, -0.0253906, -0.000999928], 90],
        ["WaterPump_01_forest_F", [8.52148, -1.82422, 0.000851631], 225.001],
        ["C_IDAP_Van_02_medevac_F", [2.79688, 8.62891, -0.0589304], 168.544],
        ["Land_BagFence_Round_F", [-8.81055, 2.5625, -0.00130081], 225],
        ["Land_Pallets_F", [8.66406, -2.99219, 0], 159.076],
        ["Land_PaperBox_closed_F", [6.66016, 7.30273, 0], 92.3801],
        ["Land_Sacks_heap_F", [8.02148, 6.55078, 0], 105],
        ["Land_BagFence_Round_F", [-8.89648, -5.65234, -0.00130081], 315],
        ["Land_BagFence_Long_F", [-0.210938, 10.7246, -0.000999928], 90],
        ["Land_PaperBox_open_empty_F", [10.3965, -2.69922, 0], 220.358],
        ["Land_PortableLight_double_F", [9.25781, 6.24023, 0], 60],
        ["Land_PaperBox_closed_F", [-11.0996, -2.58594, 0], 172.335],
        ["Land_PaperBox_closed_F", [-11.5273, -0.707031, 0], 144.595],
        ["CamoNet_INDP_open_F", [-12.0918, -1.04883, 0], 90],
        ["Land_BagFence_Long_F", [-11.4512, 3.01563, -0.000999928], 180],
        ["Land_BagFence_Long_F", [6.13281, 10.8418, -0.000999928], 270],
        ["Land_BagFence_Long_F", [-6.58594, 10.8496, -0.000999928], 90],
        ["Land_Wreck_Car3_F", [11.9434, -4.25781, 0], 60],
        ["Land_BagFence_Long_F", [-11.6055, -6.01367, -0.000999928], 0],
        ["Land_BagFence_Round_F", [-0.603516, 13.4258, -0.00130081], 225],
        ["Land_Medevac_house_V1_F", [10.6465, 8.9043, 0], 0],
        ["Land_BagFence_Round_F", [0.242188, 13.6172, -0.00130081], 135],
        ["Land_BagFence_Round_F", [-14.1602, 2.65625, -0.00130081], 135],
        ["Land_BagFence_Long_F", [-3.34766, 13.8301, -0.000999928], 180],
        ["Land_BagFence_Long_F", [3.02734, 13.9551, -0.000999928], 180],
        ["Land_BagFence_Round_F", [5.77148, 13.5508, -0.00130081], 225],
        ["Land_BagFence_Round_F", [-6.13281, 13.4922, -0.00130081], 135],
        ["Land_BagFence_Long_F", [-14.5508, 0.0195313, -0.000999928], 90],
        ["Land_BagFence_Long_F", [-14.5859, -2.77539, -0.000999928], 90],
        ["Land_BagFence_Round_F", [6.69336, 13.4707, -0.00130081], 135],
        ["Land_BagFence_Round_F", [-14.248, -5.56055, -0.00130081], 45],
        ["Land_Pallets_F", [15.7168, 4.11719, 0], 279.076],
        ["Land_BagFence_Long_F", [9.47852, 13.8105, -0.000999928], 180],
        ["Land_BagFence_Long_F", [15.4141, 7.97461, -0.000999928], 90],
        ["Land_BagFence_Long_F", [12.2773, 13.8301, -0.000999928], 180],
        ["Land_BagFence_Long_F", [15.4141, 10.7246, -0.000999928], 90],
        ["Rabbit_F", [-14.0879, 13.1895, 0.00223756], 106.646],
        ["Land_BagFence_Round_F", [15.0215, 13.4258, -0.00130081], 225]
    ],

    // Fourth emplacement
    [
        ["Land_PlasticCase_01_small_gray_F", [-1.82813, 3.29492, -2.38419e-07], 270.004],
        ["BloodTrail_01_New_F", [2.66602, 2.8457, 0], 330],
        ["Land_Stethoscope_01_F", [-3.44336, 3.60156, 0], 75],
        ["Land_Stretcher_01_olive_F", [-1.83398, 4.7207, 2.38419e-07], 360],
        ["BloodSplatter_01_Medium_New_F", [1.45313, 4.98828, 0], 120],
        ["MedicalGarbage_01_3x3_v1_F", [1.02344, 5.25586, 0], 300],
        ["Land_Stretcher_01_olive_F", [0.955078, 5.13086, 2.38419e-07], 345],
        ["Land_FirstAidKit_01_open_F", [-3.72266, 4.22266, -0.00488997], 195.042],
        ["Land_VitaminBottle_F", [-4.24023, 3.86719, 2.38419e-05], 134.434],
        ["Land_VitaminBottle_F", [-4.24023, 4.04297, 2.38419e-05], 134.434],
        ["Land_PainKillers_F", [1.6543, 5.63086, -4.76837e-07], 329.977],
        ["BloodPool_01_Medium_New_F", [1.43945, 5.72266, 0], 0],
        ["Land_Bodybag_01_empty_black_F", [4.625, 3.87695, -0.0141292], 345],
        ["Land_Bandage_F", [3.08203, 5.19531, -2.38419e-07], 0.0171236],
        ["Land_Bandage_F", [2.14453, 5.6543, -2.38419e-07], 269.989],
        ["Land_Bandage_F", [2.99219, 5.34766, -4.76837e-07], 150.009],
        ["Land_Bandage_F", [2.31836, 5.70898, -4.76837e-07], 149.958],
        ["Land_Bandage_F", [3.08203, 5.35156, -2.38419e-07], 284.976],
        ["MedicalGarbage_01_3x3_v1_F", [3.25, 5.55859, 0], 30],
        ["Land_FirstAidKit_01_closed_F", [3.375, 5.50195, -1.66893e-06], 314.959],
        ["MedicalGarbage_01_1x1_v1_F", [3.01953, 5.73828, 0], 0],
        ["Land_Stretcher_01_olive_F", [-4.33398, 5.0957, -7.15256e-07], 195],
        ["MedicalGarbage_01_3x3_v1_F", [-4.47656, 5.2168, 0], 180],
        ["Land_Bodybag_01_black_F", [5.75195, 4.87891, -0.0264323], 150.001],
        ["Land_Defibrillator_F", [0.164063, 7.76367, 0], 180],
        ["BloodSplatter_01_Small_New_F", [-5.17969, 5.85352, 0], 0],
        ["Land_DisinfectantSpray_F", [-0.455078, 8.38672, -0.000859737], 89.9122],
        ["Land_Bodybag_01_folded_black_F", [5.51367, 6.91211, -0.0191374], 359.998],
        ["Land_PaperBox_01_small_open_brown_F", [0.667969, 9.0918, 0], 180],
        ["Land_Bodybag_01_folded_black_F", [5.79102, 7.21875, -0.0147929], 45.0029],
        ["MedicalGarbage_01_3x3_v1_F", [4.75391, 7.92773, 0], 150],
        ["CamoNet_INDP_F", [-1.01367, 9.69922, 0], 0],
        ["Land_Stretcher_01_olive_F", [5, 8.25195, 4.76837e-07], 254.999],
        ["Land_PlasticCase_01_small_gray_F", [-2.95313, 9.54492, -2.38419e-07], 270.004],
        ["Land_PaperBox_01_small_closed_brown_F", [-0.708984, 10.0957, -1.19209e-06], 60.0117],
        ["Land_IntravenStand_01_2bags_F", [2.0293, 9.88086, 3.33786e-05], 284.96],
        ["Land_IntravenStand_01_empty_F", [4.625, 9.50195, 3.24249e-05], 255.032],
        ["Land_PaperBox_01_open_boxes_F", [0.541016, 10.7207, 0.000930071], 105],
        ["Land_CampingTable_white_F", [9.1543, 5.63477, -0.00259161], 90.8253],
        ["Land_PlasticCase_01_small_gray_F", [-5.71484, 9.35156, -2.38419e-07], 209.994],
        ["MedicalGarbage_01_3x3_v1_F", [3.85742, 10.498, 0], 180],
        ["Land_Stretcher_01_olive_F", [4, 10.502, -7.15256e-07], 44.9997],
        ["Land_PlasticCase_01_medium_gray_F", [-6.77344, 9.09961, -2.38419e-07], 240.001],
        ["Land_Stretcher_01_olive_F", [-2.95898, 10.9707, 4.76837e-07], 360],
        ["MedicalGarbage_01_1x1_v3_F", [-5.04883, 10.2676, 0], 0],
        ["Land_BarrelWater_F", [-6.33398, 9.9707, 2.14577e-06], 315],
        ["Land_Stretcher_01_folded_olive_F", [-5.77344, 10.5996, -4.76837e-07], 15.0002],
        ["Land_Stretcher_01_folded_olive_F", [-5.14844, 11.5996, -4.76837e-07], 345],
        ["StretcherRollerSystem_01_F", [8.94727, 9.07617, 0.00294828], 0.0556318],
        ["CBRNContainer_01_closed_yellow_F", [13.9336, 4.5332, 0], 262.053],
        ["Land_MedicalTent_01_floor_light_F", [12.1191, 8.62695, 0.0235794], 0],
        ["CBRNContainer_01_closed_yellow_F", [14.8145, 5.13867, 2.38419e-07], 355.833],
        ["CBRNContainer_01_closed_yellow_F", [15.1504, 5.49023, -4.76837e-07], 115.019],
        ["TrashBagHolder_01_F", [15.4355, 6.00195, -0.222741], 11.6866],
        ["Land_CampingTable_small_white_F", [15.2344, 8.38672, 0.00260186], 356.473],
        ["Land_CampingChair_V2_white_F", [15.2949, 9.16211, -2.14577e-06], 29.2379],
        ["Snake_random_F", [8.625, 17.668, 0.0083878], 317.143],
        ["Rabbit_F", [-38.2832, -2.16602, -0.000539303], 90.0498],
        ["Snake_random_F", [31.6738, 23.3398, 0.0083878], 151.032],
        ["Snake_random_F", [-35.625, -28.793, 0.0083878], 293.007],
        ["Rabbit_F", [-38.0918, 31.5586, 0.00223756], 186.794]
    ],

    // Fifth emplacement
    [
        ["CargoNet_01_barrels_F", [3.44727, 0.595703, -7.15256e-07], 0.00222852],
        ["CargoNet_01_barrels_F", [3.07227, 2.5957, -7.15256e-07], 255.002],
        ["Land_BagFence_Long_F", [4.58789, 0.0996094, -0.000999928], 90],
        ["Land_BagFence_Long_F", [4.55664, 2.8418, -0.000999928], 270],
        ["Land_HelipadSquare_F", [-5.55273, 1.5957, 0], 0],
        ["Land_CampingTable_white_F", [7.14648, 0.841797, -0.00259185], 90.3692],
        ["Land_MetalBarrel_F", [3.19727, -6.6543, 1.66893e-06], 300.005],
        ["Land_BagFence_Long_F", [4.55664, -6.0332, -0.000999928], 270],
        ["Land_MetalBarrel_F", [3.19727, -7.4043, 1.43051e-06], 90.0004],
        ["Land_MetalBarrel_F", [3.82227, -7.1543, 1.43051e-06], 225.016],
        ["Land_BagFence_End_F", [0.283203, -8.11133, -0.00100017], 195],
        ["Land_CampingChair_V2_white_F", [6.97656, -4.5332, -2.14577e-06], 314.87],
        ["StretcherRollerSystem_01_F", [7.32813, 4.26172, 0.00295734], 358.837],
        ["HazmatBag_01_roll_F", [7.65234, -4.22852, 3.14713e-05], 252.332],
        ["Land_BagFence_Long_F", [2.45117, -8.41992, -0.000999928], 180],
        ["HazmatBag_01_roll_F", [7.99805, -4.10156, 3.21865e-05], 329.775],
        ["Land_BagFence_End_F", [4.82031, 7.16992, -0.00100017], 75],
        ["Land_BagFence_Corner_F", [4.55859, -8.41406, -0.000999928], 90],
        ["HazmatBag_01_F", [8.40039, -3.58398, -1.19209e-06], 46.3251],
        ["Land_BagFence_Long_F", [-4.18164, -8.51367, -0.000999928], 0],
        ["Broom_01_yellow_F", [8.47656, -4.88281, -0.0211353], 255.01],
        ["HazmatBag_01_empty_F", [8.72656, -5.25781, 6.65188e-05], 224.981],
        ["Land_MedicalTent_01_floor_light_F", [10.2578, -1.60156, 0.0235791], 0],
        ["ContainmentArea_03_yellow_F", [10.2676, -1.55664, 0.0235791], 0],
        ["DeconShower_01_F", [10.2969, 1.30469, -0.00584078], 359.791],
        ["PressureHose_01_Roll_F", [8.06445, 6.94141, 0], 210],
        ["Land_BagFence_Long_F", [4.58789, 9.47461, -0.000999928], 90],
        ["Land_CratesWooden_F", [-4.92773, -9.5293, 0], 0],
        ["Land_MedicalTent_01_floor_light_F", [10.2578, 3.64844, 0.0235791], 0],
        ["Land_HelicopterWheels_01_disassembled_F", [1.69727, 10.8457, -0.000773907], 44.9744],
        ["Land_BagFence_Long_F", [-6.92383, -8.54492, -0.000999928], 180],
        ["Land_HelicopterWheels_01_assembled_F", [2.19727, 10.9707, -0.00152946], 150.007],
        ["SpinalBoard_01_orange_F", [7.75, 8.30859, -2.38419e-07], 318.592],
        ["Land_BagFence_End_F", [0.0722656, 11.209, -0.00100017], 150],
        ["Land_BagFence_Long_F", [2.20117, 11.5801, -0.000999928], 180],
        ["Land_BagFence_Corner_F", [4.58203, 11.582, -0.000999928], 0],
        ["Land_BagFence_Long_F", [-4.18164, 11.7363, -0.000999928], 0],
        ["Land_Pallet_MilBoxes_F", [-7.42578, 10.5859, 0], 0],
        ["TrashBagHolder_01_F", [13.3223, -0.560547, 7.15256e-06], 33.6444],
        ["LayFlatHose_01_Roll_F", [12.6289, -4.39648, 0], 255],
        ["CBRNContainer_01_closed_yellow_F", [13.4102, -1.23047, -2.38419e-07], 27.3427],
        ["CBRNContainer_01_closed_yellow_F", [13.4727, -1.79492, 2.38419e-07], 358.353],
        ["Land_BagFence_Long_F", [-6.92383, 11.7051, -0.000999928], 180],
        ["CBRNContainer_01_closed_yellow_F", [13.5137, -2.40625, 0], 248.432],
        ["Land_CampingTable_small_white_F", [13.334, 3.45703, 0.00260305], 359.993],
        ["Land_CampingChair_V2_white_F", [13.3945, 4.20703, 2.14577e-06], 29.848],
        ["Land_BagFence_End_F", [-11.2012, -8.95703, -0.00100017], 30],
        ["Land_Pallets_stack_F", [-14.6328, 0.480469, 0.290426], 325.265],
        ["Land_BagFence_End_F", [-9.2168, 12.0137, -0.00100017], 195],
        ["Land_PalletTrolley_01_khaki_F", [-15.2754, 2.89648, 0.0594318], 60.8087],
        ["Land_BagFence_Long_F", [-15.6621, 0.0996094, -0.000999928], 90],
        ["Land_BagFence_Long_F", [-13.3066, -8.51367, -0.000999928], 0],
        ["Land_BagFence_Long_F", [-15.6934, 2.8418, -0.000999928], 270],
        ["Land_FieldToilet_F", [13.7715, 8.20117, -7.15256e-06], 104.997],
        ["Land_BagFence_End_F", [-15.9258, 5.14648, -0.00100017], 255],
        ["Land_BagFence_Long_F", [-15.6934, -6.4082, -0.000999928], 270],
        ["Land_PaperBox_open_empty_F", [-14.5527, 8.9707, 0], 0],
        ["Land_BagFence_Corner_F", [-15.6875, -8.51563, -0.000999928], 180],
        ["Land_BarrelTrash_grey_F", [-13.4277, 11.0957, 1.90735e-06], 359.995],
        ["Land_BagFence_End_F", [-15.9707, 7.05664, -0.00100017], 105],
        ["Land_BagFence_Long_F", [-13.5566, 11.7363, -0.000999928], 0],
        ["Land_PaperBox_closed_F", [-14.5547, 10.6074, 0], 0],
        ["Land_BagFence_Long_F", [-15.6621, 9.34961, -0.000999928], 90],
        ["Land_BagFence_Corner_F", [-15.6641, 11.7305, -0.000999928], 270],
        ["Snake_random_F", [24.5391, 1.44336, 0.0083878], 176.007],
        ["Snake_random_F", [11.5703, 29.5508, 0.0083878], 330.714]
    ],

    // Sixth emplacement
    [
        ["Land_HBarrier_5_F", [3.94922, 0.425781, 0], 59],
        ["Box_East_AmmoVeh_F", [6.9707, -0.492188, 0.0295436], 226.43],
        ["Land_HBarrier_5_F", [1.62109, 7.15234, 0], 269],
        ["Land_MetalBarrel_F", [6.24805, 4.45117, 0.00035429], 31.2693],
        ["Land_BagBunker_Large_F", [-3.79883, 7.39453, 0], 90.3651],
        ["Land_Pallets_F", [6.53711, 4.2168, 0], 90],
        ["Land_Garbage_square5_F", [8.61133, 1.65039, 0], 90],
        ["Land_Pipes_small_F", [9.375, -1.05859, -2.38419e-07], 181],
        ["Land_HBarrier_5_F", [10.3242, -2.48047, 0], 179],
        ["Land_Shovel_F", [11.0371, -0.0644531, 0.0241168], 240.152],
        ["Land_MetalWire_F", [11.0391, -0.8125, 0], 300],
        ["Land_TinContainer_F", [11.0781, -0.318359, 0.00121045], 300.343],
        ["Land_FoodContainer_01_F", [11.2852, -1.0625, 0.000974894], 14.9073],
        ["CamoNet_OPFOR_big_F", [10.084, 5.45117, 0], 180],
        ["Land_HBarrier_5_F", [6.62109, 9.40234, 0], 269],
        ["Land_BagBunker_Small_F", [4.03906, 11.7422, 0], 180],
        ["Land_Sacks_heap_F", [12.2891, -0.8125, 0], 0],
        ["O_HMG_01_high_F", [4.03906, 11.9375, -0.0871191], 360],
        ["Land_HBarrier_1_F", [13.7969, -1.0625, 0], 270],
        ["Land_Ammobox_rounds_F", [14.7891, 5.1875, -0.000167847], 164.999],
        ["Land_Ammobox_rounds_F", [15.2891, 4.9375, -0.000167847], 224.995],
        ["Land_CratesWooden_F", [14.7891, 6.6875, 0], 90],
        ["Land_HBarrier_5_F", [7.79297, 12.8281, 0], 357],
        ["Land_HBarrier_5_F", [16.6465, 3.19141, 0], 267],
        ["Land_HBarrier_1_F", [13.2891, 12.9297, 0], 0],
        ["Snake_random_F", [-35.1309, -33.002, 0.0083878], 243.873]
    ],

    // Seventh emplacement
    [
        ["Land_HBarrier_5_F", [2.41211, 6.52734, 0], 75.3196],
        ["Land_BagFence_Long_F", [-2.31445, 4.88672, -0.000999928], 150.32],
        ["Land_BagFence_Long_F", [0.246094, 5.94336, -0.000999928], 165.32],
        ["Land_BagBunker_Tower_F", [5.86914, -2.15039, 0], 165.32],
        ["Land_MetalBarrel_F", [6.17188, 3.4707, 1.43051e-06], 330.31],
        ["Land_CampingChair_V1_F", [-0.697266, -7.84961, 0.00309849], 29.9556],
        ["Land_FieldToilet_F", [2.59766, -7.39648, -0.000998497], 49.0001],
        ["Land_MetalBarrel_F", [6.59375, 4.39258, 1.43051e-06], 105.324],
        ["Land_MetalBarrel_F", [7.14648, 3.76172, 1.43051e-06], 60.3113],
        ["Land_CampingChair_V1_F", [-1.94727, -7.84961, 0.00308967], 344.976],
        ["Land_BagFence_Long_F", [4.58398, 7.11133, -0.000999928], 345.32],
        ["Land_BagFence_Long_F", [2.79492, -8.21094, -0.000999928], 345],
        ["Land_CampingTable_F", [-1.32227, -8.59961, -0.00259185], 0.00153876],
        ["Land_BagFence_Long_F", [5.54492, -7.46094, -0.000999928], 345],
        ["Land_CampingTable_F", [-1.32422, -9.47266, -0.00140953], 180.373],
        ["Land_BagFence_Long_F", [1.81641, -9.8418, -0.000999928], 75],
        ["Land_CampingChair_V1_F", [-1.94922, -10.1035, 0.005229], 225.047],
        ["Land_CampingChair_V1_F", [-0.822266, -10.3496, 0.00308943], 314.99],
        ["Land_BagFence_Long_F", [8.04492, -6.83594, -0.000999928], 345],
        ["Land_BagFence_Long_F", [10.5176, 2.18164, -0.000999928], 240.32],
        ["Land_BagFence_Long_F", [11.543, -0.259766, -0.000999928], 255.32],
        ["Land_BagFence_Short_F", [9.55469, -7.10938, -0.0010004], 255],
        ["CamoNet_INDP_open_F", [-0.0332031, -12.0527, 0], 80],
        ["Land_BagFence_Long_F", [11.9355, -3.125, -0.000999928], 90.3196],
        ["Land_Cargo_House_V1_F", [6.74805, -10.8457, 0], 75],
        ["Land_BagFence_Long_F", [10.0391, -8.85742, -0.000999928], 255],
        ["Land_Garbage_square5_F", [3.27344, -14.4707, 0], 0],
        ["Land_BagFence_Long_F", [7.06055, -14.1133, -0.000999928], 165],
        ["Land_BagFence_Long_F", [10.8164, -11.5918, -0.000999928], 75],
        ["Land_BagFence_Long_F", [9.81055, -13.3633, -0.000999928], 165],
        ["Land_PowerGenerator_F", [7.53711, -14.7285, 0], 255],
        ["Land_PaperBox_closed_F", [9.81055, -14.6094, 0], 150],
        ["Land_TTowerSmall_1_F", [8.69336, -14.959, 0], 345],
        ["Land_PaperBox_closed_F", [12.6895, -13.7637, -0.263005], 298.947],
        ["Land_BagFence_End_F", [-2.99219, -18.1758, -0.00100017], 240],
        ["Land_GarbagePallet_F", [11.7715, -14.8867, 0], 345],
        ["Land_BagFence_End_F", [1.52539, -19.4199, -0.00100017], 330],
        ["Land_BagFence_Round_F", [-2.49023, -20.2324, -0.00130081], 60],
        ["Land_Garbage_square5_F", [12.1426, -16.4961, 0], 150],
        ["Land_BagFence_Round_F", [-0.015625, -20.9414, -0.00130081], 330],
        ["Snake_random_F", [13.3262, 24.9219, 0.0083878], 209.488],
        ["Snake_random_F", [41.3145, -15.9922, 0], 19.2273]
    ],
	
	 [
        // First emplacement
        ["Land_GarbagePallet_F",[-1.50586,5.73828,0],0],
        ["Land_PaperBox_open_full_F",[-8.33008,-0.564453,0],45],
        ["Land_TBox_F",[5.33594,8.30469,0],90],
        ["Snake_random_F",[9.82422,0.712891,0.0083878],188.497],
        ["Land_Metal_Shed_F",[1.84766,8.1543,0],0],
        ["Land_CratesShabby_F",[-0.414063,9.90234,0],90],
        ["Land_Cages_F",[-4.03125,9.52539,0],270],
        ["Land_Garbage_square5_F",[1.75586,10.4727,0],0],
        ["Land_Tyre_F",[-3.30273,10.7988,-0.0043025],0.0136312],
        ["Land_BagFence_Long_F",[-11.3281,-0.917969,-0.000999928],359],
        ["Land_Pallet_vertical_F",[4.08789,10.9023,0.219031],35.3103],
        ["Land_GarbageBags_F",[7.05469,8.13477,0],0],
        ["Land_FoodContainer_01_F",[-0.03125,12.6504,7.15256e-07],60.0011],
        ["Land_GarbageBags_F",[6.75781,11.6289,0],150],
        ["Land_Razorwire_F",[-13.8027,-4.87695,-2.86102e-06],359.657],
        ["Land_CampingTable_small_F",[-0.519531,13.1543,0.0026021],29.9986],
        ["Land_Ammobox_rounds_F",[-0.90625,13.2754,-0.000165462],14.9917],
        ["Land_BagFence_Round_F",[11.4707,-7.4668,-0.00130081],0.745396],
        ["Land_CampingChair_V1_F",[13.5742,-2.17773,0.00308919],255.739],
        ["Land_CampingChair_V1_F",[-0.28125,13.7754,0.00308943],359.999],
        ["Land_BagFence_Round_F",[-14.0098,-0.822266,-0.00130081],29.65],
        ["Land_CampingTable_F",[14.2324,-1.52344,-0.00259161],240.211],
        ["Land_BagFence_Long_F",[-14.7148,1.6875,-0.000999928],269],
        ["Land_BagFence_Long_F",[13.6309,-5.92578,-0.000999928],315.745],
        ["Land_BagFence_Long_F",[15.6895,-3.91992,-0.000999928],315.745],
        ["Land_Razorwire_F",[-17.0059,-2.53711,-2.86102e-06],269.657],
        ["Land_BagFence_End_F",[17.0898,-2.23438,-0.00100017],300.745],
        ["MapBoard_altis_F",[17.002,0.128906,-0.00223589],45.7568],
        ["Land_BagFence_Round_F",[4.54492,18.2871,-0.00130081],89.65],
        ["Land_BagFence_Round_F",[7.85547,18.1465,-0.00130081],270],
        ["Land_PowerGenerator_F",[10.6563,17.4121,0],194.305],
        ["Land_MetalBarrel_F",[11.5352,16.9277,1.66893e-06],129.013],
        ["Land_BagFence_Round_F",[6.29883,19.9375,-0.00130081],180.265],
        ["Land_TTowerSmall_2_F",[6.27539,18.332,0],180],
        ["Land_MetalBarrel_F",[11.9102,17.5762,1.43051e-06],330.001],
        ["Land_BagFence_Long_F",[10.1602,19.1621,-0.000999928],194],
        ["Land_BagFence_Long_F",[14.0508,16.6777,-0.000999928],104],
        ["Land_Razorwire_F",[6.0957,22.0703,-2.86102e-06],164.657],
        ["Land_BagFence_Long_F",[13.0352,18.5684,-0.000999928],14],
        ["Land_Razorwire_F",[15.5215,14.8418,-2.86102e-06],276.523],
        ["Land_Razorwire_F",[13.6914,21.3008,-2.86102e-06],194.657],
        ["Snake_random_F",[26.3711,14.5176,0.0083878],139.83]
    ],

    [
        // Second emplacement
        ["Land_Pallets_stack_F",[3.56055,2.16992,1.43051e-06],193.854],
        ["Land_Garbage_square5_F",[-5.16797,1.51172,0],0],
        ["CamoNet_INDP_F",[-1.72852,5.26367,0],0],
        ["Land_HBarrier_3_F",[3.74609,-5.76367,0],240],
        ["Land_Portable_generator_F",[-5.11133,2.94141,-0.000874043],300.057],
        ["Land_Pallet_MilBoxes_F",[-6.19531,-1.49023,0],150],
        ["Land_HBarrier_Big_F",[5.46289,2.97461,0],90],
        ["Land_PortableLight_double_F",[-6.06641,2.25391,0],300],
        ["Land_CratesWooden_F",[3.04492,6.06445,0],0],
        ["Land_PaperBox_closed_F",[-6.32227,4.30469,0],150],
        ["Land_HBarrier_Big_F",[2.13477,7.98242,0],0],
        ["Land_HBarrier_3_F",[-8.22852,-1.19727,0],90],
        ["Land_PaperBox_closed_F",[-6.33203,5.95117,0],0],
        ["Land_BagFence_End_F",[8.69531,-0.285156,-0.00100017],105],
        ["Land_HBarrier_Big_F",[-8.24805,3.0293,0],270],
        ["Land_BagFence_Short_F",[9.4375,1.06641,-0.0010004],135],
        ["Land_HBarrier_5_F",[3.92383,-10.9336,0],270],
        ["Land_Razorwire_F",[7.35156,4.58594,-2.86102e-06],270],
        ["Land_BagFence_End_F",[8.92578,-2.97266,-0.00100017],180],
        ["Land_Razorwire_F",[3.97266,9.87891,-2.86102e-06],180],
        ["Land_HBarrier_Big_F",[-6.36523,7.85742,0],0],
        ["Land_PaperBox_open_full_F",[-10.3301,-0.445313,0],0],
        ["Land_Radar_Small_F",[-3.68359,-8.61719,0],90],
        ["Land_BagFence_Round_F",[11.2715,2.19922,-0.00130081],180],
        ["Land_BagFence_Round_F",[11.0215,-3.63672,-0.00130081],0],
        ["CamoNet_INDP_F",[-11.2559,1.33789,0],90],
        ["Land_Razorwire_F",[-4.52734,9.75391,-2.86102e-06],180],
        ["Land_Pallet_MilBoxes_F",[-10.4453,5.81641,0],270],
        ["Land_CncBarrier_F",[9.04297,-8.69336,0],0],
        ["Land_Pallet_vertical_F",[-10.7051,-6.93359,4.57764e-05],359.992],
        ["Land_BagFence_Short_F",[12.9258,1.05664,-0.0010004],225],
        ["Land_BagFence_Short_F",[12.8555,-2.50195,-0.0010004],315],
        ["Land_CampingChair_V2_F",[-13.0801,3.06445,-1.43051e-06],149.999],
        ["Land_BagFence_Round_F",[14.0605,-0.777344,-0.00130081],270],
        ["Land_WaterBarrel_F",[-12.3301,-6.68555,-0.000999928],0.000175169],
        ["Land_IronPipes_F",[0.376953,-14.4805,0],0],
        ["MapBoard_altis_F",[-13.3262,5.19727,-0.00222731],24.7905],
        ["Land_CampingChair_V2_F",[-14.7051,2.06445,-1.19209e-06],164.995],
        ["Land_CampingChair_V2_F",[-14.7051,5.18945,-1.43051e-06],359.992],
        ["Land_CncBarrier_F",[13.043,-8.56836,0],0],
        ["Land_Cargo10_grey_F",[-8.45508,-13.8105,-0.00099802],90],
        ["Land_HBarrierTower_F",[8.95313,-13.8867,0],270],
        ["Land_HBarrier_Big_F",[2.95508,-16.2285,0],180],
        ["Land_HBarrier_Big_F",[-14.2949,-8.35352,0],180],
        ["Land_HBarrier_Big_F",[-14.8652,7.73242,0],0],
        ["MapBoard_stratis_F",[-15.9648,5.19531,-0.00223398],292.699],
        ["Land_HBarrier_Big_F",[-10.873,-13.4707,0],270],
        ["Land_HBarrier_Big_F",[-5.54492,-16.3535,0],180],
        ["Land_Razorwire_F",[-13.0273,9.62891,-2.86102e-06],180],
        ["Land_HBarrier_Big_F",[-17.748,2.4043,0],270],
        ["Land_Razorwire_F",[-1.13281,-18.125,-2.86102e-06],0],
        ["Land_Razorwire_F",[-14.3516,-10.0039,-2.86102e-06],180],
        ["Land_Razorwire_F",[-13.1387,-12.707,-2.86102e-06],90],
        ["Land_Razorwire_F",[-9.63281,-18.25,-2.86102e-06],0],
        ["Land_Razorwire_F",[14.3516,-15.5391,-2.86102e-06],270],
        ["Land_Razorwire_F",[-19.6367,5.41797,-2.86102e-06],90],
        ["Land_Razorwire_F",[10.3984,-18.2539,-2.86102e-06],180],
        ["Land_HBarrier_5_F",[-23.3867,-1.00977,0],0],
        ["Land_BagFence_Long_F",[-23.3789,-2.10742,-0.000999928],270],
        ["Land_BagFence_Long_F",[-23.373,-3.25195,-0.000999928],90],
        ["Land_BagFence_Long_F",[-22.9668,-6.14844,-0.000999928],75],
        ["Snake_random_F",[1.08398,38.791,0.0083878],0.116513],
        ["Snake_random_F",[-39.2637,4.71289,0.0083878],147.753]
    ],

    [
        // Third emplacement
        ["Land_HBarrier_5_F",[-0.308594,1.92578,0],180],
        ["Land_Garbage_square5_F",[0.279297,3.55273,0],0],
        ["Land_GarbageWashingMachine_F",[-0.796875,3.6543,0],180],
        ["Land_HBarrier_5_F",[0.939453,6.16992,0],90],
        ["Land_BagFence_Short_F",[-4.80859,0.162109,-0.0010004],270],
        ["Land_BagFence_End_F",[-4.7832,1.86133,-0.00100017],270],
        ["Land_BagFence_Round_F",[-5.36133,-2.00195,-0.00130081],315],
        ["MapBoard_stratis_F",[5.0625,2.78906,-0.00223398],225.138],
        ["MapBoard_altis_F",[3.31836,5.04492,-0.00223589],240.114],
        ["Land_BarrelTrash_grey_F",[-5.55664,5.17188,1.90735e-06],359.957],
        ["Land_BagFence_Short_F",[-7.54688,-2.33008,-0.0010004],180],
        ["Land_Cargo_House_V1_F",[-3.57813,7.42188,0],90],
        ["Land_BagFence_End_F",[-8.93945,-1.66211,-0.00100017],225],
        ["Land_ChairWood_F",[3.47266,8.63672,-1.66893e-06],255.123],
        ["Land_HBarrier_5_F",[0.947266,7.42383,0],270],
        ["Land_WoodenTable_small_F",[4.33594,8.92383,-2.38419e-07],180.007],
        ["Land_WoodenTable_large_F",[7.85742,6.76953,-2.38419e-07],207.248],
        ["Land_Garbage_square5_F",[-5.76953,8.74414,0],0],
        ["Land_GarbagePallet_F",[-5.53125,9.13477,0],0],
        ["CamoNet_INDP_open_F",[8.57031,7.26172,-0.864591],270.145],
        ["Land_CampingChair_V2_F",[9.64453,5.4082,-2.38419e-06],120.142],
        ["Land_CratesShabby_F",[10.6895,3.27734,0],45.1448],
        ["Land_Basket_F",[4.32813,10.3477,7.15256e-07],180.146],
        ["Land_Garbage_square5_F",[10.1797,5.12891,0],330.145],
        ["Land_CampingChair_V2_F",[9.9082,6.36914,-1.66893e-06],135.128],
        ["Land_PowerGenerator_F",[-1.07227,11.7969,0],270],
        ["Land_GarbagePallet_F",[11.668,1.81641,0],180.145],
        ["Land_PaperBox_closed_F",[-10.8145,4.91211,0],225],
        ["Land_BagFence_Round_F",[-12.2285,-3.15625,-0.00130081],315],
        ["Land_WaterBarrel_F",[11.9668,4.51367,0.00288248],269.085],
        ["CamoNet_INDP_open_F",[-11.9199,6.07422,0],90],
        ["Land_WaterBarrel_F",[-11.5566,6.17188,0],360],
        ["Land_CratesPlastic_F",[-2.30469,12.9258,0],255],
        ["Land_Garbage_square5_F",[-12.2988,4.65039,0],0],
        ["Land_HBarrier_3_F",[-1.16992,13.1484,0],0],
        ["Land_WoodenTable_large_F",[9.21289,9.66016,-2.38419e-07],347.096],
        ["Land_CampingChair_V2_F",[9.97266,9.33789,7.15256e-06],90.1445],
        ["Land_Pallets_F",[12.7891,3.51367,0],45.1448],
        ["Land_WoodenTable_large_F",[6.84375,12.541,-1.19209e-06],120.01],
        ["Land_TTowerSmall_2_F",[-0.171875,11.0176,0],0],
        ["Land_Pallets_stack_F",[-2.33203,14.4453,-0.000993967],314.721],
        ["Land_BagFence_Round_F",[-14.8047,-3.0332,-0.00130081],45],
        ["Land_CratesWooden_F",[-14.5566,2.92188,0],75],
        ["Land_CampingChair_V2_F",[6.82813,13.2617,-2.14577e-06],30.1378],
        ["Land_CampingChair_V2_F",[7.71094,13.0391,2.38419e-06],60.141],
        ["Land_BagFence_Long_F",[-15.4531,-0.244141,-0.000999928],260],
        ["Land_PaperBox_closed_F",[-12.3086,10.9355,0],0],
        ["Land_HBarrier_5_F",[-16.9199,5.73047,0],75],
        ["Land_HBarrier_5_F",[-8.80859,12.9258,0],180],
        ["Land_HBarrier_5_F",[-17.0605,10.9199,0],90],
        ["I_Truck_02_transport_F",[-7.31836,18.1777,-0.0154696],285.002],
        ["Snake_random_F",[40.5059,1.76758,0.0083878],205.102],
        ["Snake_random_F",[41.8281,-0.216797,0.0083878],212.167]
    ],

    [
        // Fourth emplacement
        ["Land_BagFence_Short_F",[-3.24023,0.585938,-0.0010004],270],
        ["Land_BagFence_Corner_F",[-3.25391,-1.24219,-0.000999928],90],
        ["Land_BagFence_Corner_F",[-3.27539,2.08008,-0.000999928],0],
        ["Land_BagFence_Short_F",[-4.74805,-1.27734,-0.0010004],0],
        ["Land_BagFence_Short_F",[-5.10352,2.09375,-0.0010004],180],
        ["Land_BagFence_Corner_F",[-6.57617,-1.26367,-0.000999928],180],
        ["Land_BagFence_Corner_F",[-6.59766,2.05859,-0.000999928],270],
        ["Land_BagFence_Short_F",[-6.61133,0.230469,-0.0010004],90],
        ["Land_u_House_Small_02_V1_dam_F",[1.20898,9.02734,0],270],
        ["Land_CampingChair_V1_F",[-3.82422,7.54102,0.00308919],254.98],
        ["Land_CampingTable_F",[-2.96484,8.10938,-0.00339723],272.059],
        ["Land_CampingChair_V1_F",[-3.44336,8.61523,0.00319862],284.796],
        ["Land_PaperBox_open_empty_F",[-8.23828,6.2207,0],315],
        ["Land_Pallet_MilBoxes_F",[-9.51172,4.84766,0],255],
        ["CamoNet_INDP_open_F",[-6.25,9.82031,0],270],
        ["Land_Sacks_heap_F",[-10.2383,6.2207,0],0],
        ["Land_Wreck_Car_F",[-12.2441,0.357422,0],210],
        ["Land_IronPipes_F",[-3.91992,14.0938,0],105],
        ["Land_BagFence_Round_F",[-14.5938,0.640625,-0.00130081],15],
        ["Land_BagFence_Short_F",[-15.9922,2.23047,-0.0010004],60],
        ["Land_PaperBox_closed_F",[-9.87109,12.9805,0],330],
        ["Land_CinderBlocks_F",[0.53125,16.3457,7.15256e-07],89.9931],
        ["Land_CinderBlocks_F",[1.90625,16.3457,-2.38419e-07],104.993],
        ["Land_PaperBox_open_full_F",[-11.7285,11.7188,0],285],
        ["Land_BagFence_Round_F",[-16.5977,4.37109,-0.00130081],105],
        ["Land_Pallets_stack_F",[-11.7383,13.4707,0],105],
        ["Snake_random_F",[-1.03711,21.9492,0.0083878],24.8029],
        ["Land_JunkPile_F",[-8.41602,20.6367,0],75],
        ["Land_BagFence_Round_F",[-10.3848,21.4082,-0.00130081],195],
        ["Land_BagFence_Round_F",[-12.6953,20.1738,-0.00130081],105],
        ["Snake_random_F",[-27.2871,-17.4707,0.0083878],134.729]
    ],

    [
        // Fifth emplacement
        ["Land_GarbagePallet_F",[-2.12109,-3.47852,0],240],
        ["Land_BagFence_Short_F",[0.203125,-9.50781,-0.0010004],90],
        ["CamoNet_INDP_open_F",[-8.19922,-7.25586,0],0],
        ["Land_BagFence_Corner_F",[0.1875,-11.1523,-0.000999928],90],
        ["Land_Pallet_MilBoxes_F",[-6.54688,-8.77734,0],0],
        ["Land_d_House_Small_02_V1_F",[-8.86719,1.16016,0],0],
        ["Land_BagFence_Long_F",[-1.91992,-11.1582,-0.000999928],180],
        ["Land_BagFence_Short_F",[-4.16406,-11.1445,-0.0010004],180],
        ["Land_Sacks_heap_F",[-6.67383,-10.2676,0],0],
        ["Land_HBarrier_3_F",[-8.32227,-8.1543,0],90],
        ["Land_PaperBox_closed_F",[-10.0508,-8.25586,0],0],
        ["Land_HBarrier_5_F",[-10.0469,-11.6465,0],0],
        ["Land_PaperBox_open_empty_F",[-10.0488,-9.89258,0],0],
        ["MetalBarrel_burning_F",[-14.9238,-2.89258,0],0],
        ["Land_CratesWooden_F",[-14.6738,-8.01758,0],0],
        ["Land_Razorwire_F",[-11.0957,14.873,-2.86102e-06],0],
        ["Land_FieldToilet_F",[-17.5156,-1.74805,2.38419e-06],44.9994],
        ["Land_HBarrier_5_F",[-15.6719,-11.6465,0],0],
        ["Land_FieldToilet_F",[-18.0488,-0.142578,9.05991e-06],60.0024],
        ["Land_HBarrier_5_F",[-16.8027,-7.39453,0],90],
        ["Land_WaterTank_F",[-15.6738,-13.1992,-8.58307e-06],0.00724751],
        ["Land_Razorwire_F",[-7.96094,-18.2578,-2.86102e-06],171],
        ["Land_Pallet_F",[-20.9102,-6.12109,0.0262344],17.5225],
        ["Land_Pallets_F",[-21.4316,-8.27734,0],60],
        ["Land_Razorwire_F",[-18.9297,13.4219,-2.86102e-06],345],
        ["Land_Razorwire_F",[-15.9043,-18.8828,-2.86102e-06],186],
        ["I_Quadbike_01_F",[-26.3613,0.0820313,-0.010004],286.781],
        ["Land_BagFence_Round_F",[-26.5605,-2.67773,-0.00130081],136.163],
        ["I_HMG_01_high_F",[-25.6816,-6.44727,-0.0871181],271.162],
        ["Land_BagFence_Long_F",[-27.0176,-5.29102,-0.000999928],91.1634],
        ["Land_BagFence_Round_F",[-26.709,-7.88086,-0.00130081],46.1634],
        ["Snake_random_F",[-28.0098,-26.4629,0.0083878],198.361]
    ],

    [
        // Sixth emplacement
        ["MetalBarrel_burning_F",[-2.74219,7.03711,0],89.4783],
        ["Land_Pallets_stack_F",[-4.27539,6.51367,-2.38419e-07],89.4785],
        ["Land_PaperBox_closed_F",[-3.9043,8.14258,0],89.4783],
        ["Land_d_Stone_HouseBig_V1_F",[-9.07031,-3.39063,0],0],
        ["Land_ToiletBox_F",[-5.96094,-8.12109,-0.000992298],359.996],
        ["Land_HBarrier_Big_F",[-3.91797,-10.7109,0],90],
        ["Land_d_House_Small_02_V1_F",[-8.71875,7.55273,0],89.4783],
        ["Land_BagFence_Round_F",[-13.0215,2.60156,-0.00130081],227.528],
        ["Land_CratesWooden_F",[-11.4609,-7.62109,0],0],
        ["CamoNet_INDP_open_F",[-9.11133,-11.4844,0],0],
        ["Land_PaperBox_closed_F",[-8.84766,-12.002,0],255],
        ["Land_BagFence_Short_F",[-15.2402,3.16797,-0.0010004],180.163],
        ["Land_BagFence_Round_F",[-15.5234,-1.18164,-0.00130081],239.342],
        ["Land_Sacks_heap_F",[-10.4609,-12.3711,0],270],
        ["Land_BagFence_Long_F",[-15.8203,-4.12109,-0.000999928],105],
        ["Land_PaperBox_open_empty_F",[-13.5508,9.17773,0],344.478],
        ["Land_HBarrier_Big_F",[-8.74609,-14.0781,0],0],
        ["Land_PaperBox_open_empty_F",[-16.8359,-1.74609,0],225],
        ["Land_Sacks_heap_F",[-16.7109,-3.49609,0],330],
        ["Land_BagFence_Round_F",[-17.3047,2.93555,-0.00130081],140.141],
        ["Land_BagFence_Round_F",[-17.7383,0.214844,-0.00130081],53.632],
        ["MetalBarrel_burning_F",[-17.9609,-2.62109,0],0],
        ["Land_HBarrier_5_F",[-15.7148,-7.62305,0],90],
        ["Land_PaperBox_open_full_F",[-17.3359,-8.13086,0],0],
        ["Land_Pallets_stack_F",[-17.4609,-9.99609,-2.38419e-07],360],
        ["Land_BagFence_Long_F",[-13.3516,-15.625,-0.000999928],120],
        ["Land_BagFence_Long_F",[-16.3555,-13.6953,-0.000999928],300],
        ["Land_Pallets_F",[-19.5762,-10.7539,0],330],
        ["Land_BagFence_Round_F",[-15.1836,-17.5664,-0.00130081],349.483],
        ["Land_BagFence_Round_F",[-17.3125,-16.0469,-0.00130081],78.854],
        ["Snake_random_F",[13.9043,-35.3066,0.0083878],212.29]
    ],

    [
        // Seventh emplacement
        ["Land_GarbageBags_F",[-0.115234,3.14453,0],0],
        ["Land_BagFence_Long_F",[-2.45313,3.92578,-0.000999928],0],
        ["Land_BagFence_Long_F",[-1.21484,5.28125,-0.000999928],270],
        ["Land_WaterTank_F",[0.671875,6.2168,0.076262],359.996],
        ["Land_BagFence_Long_F",[-5.20313,3.92578,-0.000999928],0],
        ["Land_PaperBox_closed_F",[-5.94727,5.14844,0],180],
        ["Land_Sacks_heap_F",[-1.57422,7.78516,0],90],
        ["Land_BagFence_Long_F",[-8.07031,3.89453,-0.000999928],180],
        ["Land_PaperBox_closed_F",[-7.58594,5.1582,0],270],
        ["Land_CampingTable_small_F",[-1.69531,9.4082,0.00564981],269.751],
        ["Land_CampingChair_V1_F",[-2.19727,9.45703,0.00320816],255],
        ["Land_HBarrier_5_F",[8.05469,2.85156,0],0],
        ["Land_CampingChair_V1_F",[-6.07422,9.28516,0.00308919],74.9811],
        ["Land_d_Stone_HouseBig_V1_F",[3.06641,10.3906,0],0],
        ["Land_Razorwire_F",[10.0742,1.29688,-2.86102e-06],0],
        ["CamoNet_INDP_open_F",[-5.21094,10.5098,0],270],
        ["Land_CampingChair_V1_F",[-6.82422,10.4102,0.00309134],29.981],
        ["Land_MapBoard_F",[-9.20898,8.40234,-0.00223255],239.956],
        ["Land_Sacks_heap_F",[12.0527,4.23047,0],0],
        ["Land_Tyres_F",[8.63086,9.46289,0.00659728],255],
        ["Land_CampingChair_V1_F",[-7.82422,10.6602,0.00308943],14.9734],
        ["Land_Sacks_heap_F",[12.3027,5.48047,0],90],
        ["Land_HBarrier_5_F",[13.7988,7.22852,0],90],
        ["Land_Pallets_stack_F",[-12.0742,8.41016,-2.38419e-07],225.001],
        ["Land_CncBarrierMedium_F",[-1.70898,15.7695,0],210],
        ["Land_Razorwire_F",[15.2363,3.25195,-2.86102e-06],270],
        ["Land_HBarrier_1_F",[13.7949,8.35547,0],90],
        ["Land_CratesWooden_F",[2.05078,16.2852,0],180],
        ["Land_PaperBox_closed_F",[-5.96094,15.4141,0],300],
        ["Land_BagFence_Long_F",[-14.5586,7.91406,-0.000999928],90],
        ["Land_CncBarrierMedium_F",[-3.57422,16.2676,0],180],
        ["Land_CncBarrierMedium_F",[-5.43945,16.8008,0],30],
        ["Land_CampingChair_V1_F",[14.0137,10.8535,0.00308919],239.985],
        ["Land_PaperBox_open_empty_F",[-8.07422,15.9102,0],255],
        ["Land_BagFence_Long_F",[-14.5898,10.7813,-0.000999928],270],
        ["Land_Sacks_heap_F",[-15.4492,9.66016,0],270],
        ["Land_CampingChair_V1_F",[14.1016,11.9922,0.00308895],270.025],
        ["Land_Pallets_stack_F",[17.4277,6.35547,-4.76837e-07],345.001],
        ["Land_CampingTable_F",[14.707,11.6289,-0.00259161],257.543],
        ["Land_CncBarrierMedium_F",[-7.19922,17.3926,0],180],
        ["Land_PaperBox_open_empty_F",[17.5527,8.10547,0],90],
        ["Land_CncBarrierMedium_F",[-10.6875,16.1484,0],135],
        ["Land_CncBarrierMedium_F",[-9.07031,17.1426,0],165],
        ["Land_BagFence_Long_F",[16.3184,14.8594,-0.000999928],90],
        ["Land_BagFence_Long_F",[15.0566,16.4648,-0.000999928],180],
        ["Snake_random_F",[3.35938,35.6367,0.0083878],306.214]
    ],
	
	 // First emplacement
    [
        ["Land_CampingChair_V1_F",[-4.68555,1.16797,0.00308943],74.9849],
        ["Land_ToiletBox_F",[-2.77148,3.98828,-0.000999451],15.0033],
        ["Land_BagFence_Corner_F",[2.56445,3.81836,-0.000999928],181.351],
        ["Land_CampingChair_V1_F",[-5.1875,0.0957031,0.00321722],105.998],
        ["Land_HBarrier_3_F",[-1.04492,6.22656,0],90],
        ["Land_CampingTable_F",[-5.58398,0.580078,-0.00259066],98.9803],
        ["Land_BagFence_Short_F",[4.31445,3.76172,-0.0010004],1.35146],
        ["Land_BagFence_Long_F",[2.63672,5.80469,-0.000999928],91.3515],
        ["RoadCone_F",[3.19922,6.01953,-3.33786e-06],91.3466],
        ["Land_Cargo_House_V1_F",[-7.75,2.23828,0],270],
        ["Land_BagFence_Long_F",[6.32813,3.69727,-0.000999928],181.351],
        ["Land_HBarrier_5_F",[-6.76953,6.10938,0],0],
        ["RoadCone_F",[3.77344,7.08203,-0.00606847],5.8856],
        ["RoadBarrier_F",[4.14258,7.11914,-0.00399971],121.355],
        ["Land_Garbage_square5_F",[-8.35938,-2.68945,0],0],
        ["RoadCone_F",[4.04688,7.89258,1.90735e-06],166.361],
        ["Land_HBarrier_3_F",[2.94727,9.91016,0],91.3515],
        ["Land_WeldingTrolley_01_F",[4.4668,8.77148,1.66893e-06],226.351],
        ["Land_BagFence_Round_F",[9.20898,3.72656,-0.00130081],331.351],
        ["Land_HBarrier_3_F",[-2.29492,-8.64844,0],90],
        ["Land_Cargo_House_V1_F",[-7.875,-8.13672,0],270],
        ["Land_Tyres_F",[-10.7324,-1.75977,0.00659728],315],
        ["Land_GasTank_02_F",[4.61523,9.76758,3.57628e-05],91.3464],
        ["Land_GasTank_02_F",[5.09375,9.74414,3.62396e-05],331.35],
        ["Land_PaperBox_open_empty_F",[-10.2715,-4.13672,0],0],
        ["Land_CampingChair_V1_F",[-5.26367,-9.84766,0.00318909],75.074],
        ["Land_CampingTable_small_F",[-5.77148,-9.88672,0.0034256],89.8781],
        ["Land_Garbage_square5_F",[8.49219,7.75195,0],91.3515],
        ["Land_HBarrier_3_F",[2.75781,11.0273,0],1.35146],
        ["Land_BagFence_Long_F",[10.0215,6.13086,-0.000999928],91.3515],
        ["Land_HBarrier_5_F",[-12.3945,6.10938,0],0],
        ["Land_BarrelEmpty_F",[9.53906,7.51367,2.14577e-06],91.349],
        ["Land_HBarrier_5_F",[-12.1426,0.365234,0],270],
        ["Land_HBarrier_5_F",[-12.1426,-5.25977,0],270],
        ["Land_HBarrier_5_F",[-2.14844,-12.1328,0],180],
        ["Land_Garbage_square5_F",[6.82227,11.166,0],91.3515],
        ["Land_Workbench_01_F",[7.33594,12.1445,3.8147e-06],351.731],
        ["Land_HBarrier_3_F",[4.79883,12.2637,0],271.351],
        ["Land_Saw_F",[6.16602,12.9688,-0.00273991],136.324],
        ["Land_Wrench_F",[6.87891,13.0684,-2.38419e-07],191.31],
        ["Land_HBarrier_5_F",[-12.1426,-10.8848,0],270],
        ["CamoNet_INDP_F",[10.4707,10.9414,0],1.35146],
        ["Land_Screwdriver_V1_F",[8.64648,12.7246,-0.00538445],133.488],
        ["Land_EngineCrane_01_F",[10.2578,11.498,0],331.352],
        ["Land_Screwdriver_V2_F",[8.77148,12.7402,-0.00679684],16.7478],
        ["Land_HBarrier_5_F",[-7.77344,-12.1328,0],180],
        ["Land_HBarrier_3_F",[6.08594,14.3242,0],1.35146],
        ["Land_CarBattery_02_F",[11.2871,12.7246,-7.15256e-07],196.332],
        ["Land_ShelvesWooden_F",[12.041,12.582,-0.00106454],91.3417],
        ["Land_CanisterFuel_F",[12.9082,12.5625,2.02656e-05],196.268],
        ["Land_PlasticCase_01_large_F",[14.3203,11.0098,-9.53674e-07],339.334],
        ["Land_HBarrier_Big_F",[16.1191,9.01953,0],91.3515],
        ["Land_Tyre_F",[14.4883,12.6328,-0.00430322],91.3517],
        ["Land_HBarrier_Big_F",[12.9102,14.1035,0],1.35146],
        ["Snake_random_F",[-23.123,-1.625,0],71.9837],
        ["Snake_random_F",[33.6641,-17.3047,0.0083878],207.457],
        ["Snake_random_F",[-1.9668,45.0781,0.0083878],173.042]
    ],
    // Second emplacement
    [
        ["Land_MetalBarrel_F",[0.607422,2.12695,1.43051e-06],300.008],
        ["Land_MetalBarrel_F",[-0.0585938,2.22266,1.43051e-06],75.0092],
        ["Land_IndFnc_Pole_F",[-0.591797,-3.27734,0],270],
        ["Land_PaperBox_closed_F",[-0.570313,3.3457,0],270],
        ["Land_PaperBox_closed_F",[1.19336,3.33594,0],180],
        ["Land_BarrelSand_F",[2.69141,2.97266,1.90735e-06],0.000494253],
        ["Land_Net_Fence_Gate_F",[-2.68359,-3.15234,0],180],
        ["Land_PaperBox_open_full_F",[-2.44336,3.34766,0],90],
        ["Land_IndFnc_3_F",[-0.556641,-4.77539,0],270],
        ["Land_WoodenTable_small_F",[-3.43359,-3.52734,0],180.004],
        ["Land_PortableLight_double_F",[3.22461,3.8457,0],15],
        ["Land_HBarrier_5_F",[1.68945,4.97656,0],180],
        ["Land_ChairWood_F",[-4.08594,-3.41992,1.19209e-05],301.364],
        ["Land_BagFence_Long_F",[3.5625,5.11328,-0.000999928],0],
        ["Land_BagFence_Long_F",[-4.6875,5.11328,-0.000999928],0],
        ["Land_IndFnc_3_F",[5.31445,-4.6543,0],90],
        ["Land_IndFnc_3_F",[-0.556641,-7.77539,0],270],
        ["Land_BagFence_Long_F",[-7.82422,1.59375,-0.000999928],270],
        ["Land_CratesWooden_F",[-4.43359,-6.77734,0],255],
        ["Land_HBarrier_5_F",[-7.9375,-0.279297,0],90],
        ["Land_BagFence_Long_F",[8.55078,1.84375,-0.000999928],270],
        ["Land_HBarrier_5_F",[8.44531,-4.65039,0],270],
        ["CamoNet_INDP_big_F",[-0.511719,8.68164,0],21.1121],
        ["Land_Cargo10_military_green_F",[-3.87891,8.3457,1.90735e-06],125.452],
        ["Land_IndFnc_3_F",[5.31445,-7.6543,0],90],
        ["Land_Sacks_heap_F",[-5.55859,-7.52734,0],255],
        ["Land_CratesWooden_F",[-4.55859,-8.90234,0],0],
        ["Land_Cargo20_grey_F",[0.310547,10.1621,-4.76837e-07],57.9907],
        ["Land_IndFnc_Corner_F",[-0.556641,-10.6973,0],270],
        ["Land_HBarrier_5_F",[-7.9375,-5.7793,0],90],
        ["Land_HBarrier_5_F",[8.44531,-10.1504,0],270],
        ["Land_IndFnc_3_F",[5.31445,-10.6543,0],90],
        ["Land_IndFnc_3_F",[0.939453,-12.1504,0],180],
        ["Land_IndFnc_Corner_F",[3.86133,-12.1504,0],180],
        ["Land_LampShabby_F",[2.42383,-12.6641,0],0],
        ["Land_BagFence_Long_F",[-7.79297,-12.2734,-0.000999928],90],
        ["Land_BagFence_Long_F",[8.42578,-12.1563,-0.000999928],270],
        ["Land_HBarrier_5_F",[1.81445,-15.3984,0],180],
        ["Land_BagFence_Short_F",[3.05664,-15.2754,-0.0010004],0],
        ["Land_BagFence_Long_F",[-4.6875,-15.3867,-0.000999928],0],
        ["Land_BagFence_Long_F",[5.3125,-15.2617,-0.000999928],0],
        ["Land_BagFence_Round_F",[-7.43359,-14.9824,-0.00130081],45],
        ["Land_BagFence_Round_F",[8.02148,-14.9004,-0.00130081],315]
    ],
    // Third emplacement
    [
        ["Land_BarrelSand_F",[1.26953,-2.05859,2.14577e-06],359.981],
        ["Land_Garbage_square5_F",[1.55664,2.01367,0],0],
        ["Land_MetalWire_F",[1.79102,-2.12891,0],300],
        ["Land_CratesWooden_F",[1.51953,-3.05859,0],0],
        ["RoadBarrier_F",[-2.96875,-3.06445,0.00177598],29.9063],
        ["Land_FoodContainer_01_F",[-4.23047,-1.80859,7.15256e-07],209.968],
        ["Land_FireExtinguisher_F",[3.01953,-3.59961,2.02656e-05],224.975],
        ["Land_FoodContainer_01_F",[-4.13086,-2.32617,-0.000893593],359.901],
        ["I_MRAP_03_hmg_F",[-2.08984,3.84375,-0.000402451],14.9997],
        ["RoadBarrier_F",[4.37891,-2.4375,-0.00399685],191.937],
        ["I_Truck_02_fuel_F",[3.46875,3.62305,-0.00551367],345.029],
        ["Land_CncBarrierMedium_F",[-3.9668,-3.79688,0],45],
        ["Land_CncBarrierMedium_F",[-5.21289,-2.05469,0],75],
        ["Land_CncBarrierMedium4_F",[-0.833984,-5.63477,0],180],
        ["Land_CratesWooden_F",[-5.33008,3.9707,0],285],
        ["Land_CarBattery_02_F",[6.51953,3.44141,-4.76837e-07],314.936],
        ["Land_CncBarrierMedium_F",[6.2832,-4.07227,0],135],
        ["Box_IND_AmmoVeh_F",[7.1875,2.16992,0.0324323],345.029],
        ["Land_DuctTape_F",[-6.22266,4.38086,-2.38419e-07],285.008],
        ["Land_Portable_generator_F",[-4.95313,5.84766,-0.000816107],315.008],
        ["Land_ButaneTorch_F",[-6.21875,4.59766,2.36034e-05],29.9913],
        ["Land_TinContainer_F",[-5.95508,5.01563,0.00113988],75.4796],
        ["Land_ButaneCanister_F",[-6.33008,4.59766,1.40667e-05],90.1077],
        ["Land_ButaneCanister_F",[-6.26172,4.74219,1.33514e-05],285.194],
        ["FlexibleTank_01_forest_F",[7.00195,3.92773,-0.00101924],357.708],
        ["Land_PowerGenerator_F",[-3.25391,-7.70313,0],180],
        ["Land_CncBarrierMedium_F",[8.75391,-0.304688,0],285],
        ["Land_TTowerSmall_1_F",[-2.10938,-7.05078,0],0],
        ["Land_CncBarrierMedium_F",[8.75391,2.18555,0],255],
        ["Land_CncBarrierMedium_F",[8.00391,4.18164,0],240],
        ["Land_CncBarrierMedium_F",[6.75391,6.43164,0],240],
        ["Land_CncBarrierMedium4_F",[-4.71484,-9.21875,0],90],
        ["Land_Research_house_V1_F",[1.24609,-9.83398,0],0],
        ["Land_CncBarrierMedium_F",[8.56836,-7.12109,0],345],
        ["Land_Pallets_stack_F",[-0.607422,-11.9922,-2.38419e-07],176.477],
        ["Land_LampShabby_F",[5.28516,-10.8555,0],180],
        ["Land_Cargo20_grey_F",[12.9766,-3.95703,-9.53674e-07],57.9908],
        ["Land_CanisterFuel_F",[6.42969,-12.752,2.12193e-05],224.886],
        ["Land_CncBarrierMedium_F",[-4.2168,-13.8594,0],60],
        ["Land_CanisterFuel_F",[6.24414,-13.1348,2.12193e-05],254.922],
        ["Land_Pallets_F",[7.24219,-12.8438,0],134.158],
        ["Land_CncBarrierMedium_F",[-3.46484,-15.6133,0],75],
        ["Land_CncBarrierMedium4_F",[13.1543,-9.26953,0],210],
        ["Land_Research_house_V1_F",[10.5059,-12.5195,0],30],
        ["Land_Cargo10_military_green_F",[16.7207,-1.71875,4.76837e-07],126.115],
        ["Land_CncBarrierMedium_F",[-2.7168,-17.3594,0],60],
        ["Land_PaperBox_closed_F",[1.0293,-17.9922,0],97.181],
        ["Land_PaperBox_closed_F",[3.1543,-17.9883,0],81.088],
        ["Land_PaperBox_open_empty_F",[5.01758,-17.9922,0],357.49],
        ["Land_CncBarrierMedium_F",[-1.5957,-18.8555,0],45],
        ["Land_CncBarrierMedium4_F",[2.86914,-19.5996,0],0],
        ["Land_CncBarrierMedium4_F",[13.9902,-14.2539,0],300],
        ["Land_CncShelter_F",[7.77734,-19.4961,0],0],
        ["Land_PaperBox_closed_F",[3.14063,-21.1055,0],2.88349],
        ["Land_MetalBarrel_F",[4.58008,-20.9395,1.66893e-06],324.507],
        ["Land_CncBarrierMedium_F",[11.3809,-18.2305,0],315],
        ["Land_CncBarrierMedium_F",[9.76367,-19.2266,0],345],
        ["Snake_random_F",[-6.49219,-21.752,0],202.148]
    ],
    // Fourth emplacement
    [
        ["Land_PaperBox_open_empty_F",[-2.55273,-3.07031,0],135],
        ["Land_BarrelTrash_grey_F",[-1.67773,-4.07031,1.90735e-06],0.0038035],
        ["Land_BagFence_Short_F",[-3.67188,-3.45313,-0.0010004],225],
        ["Land_BagFence_Short_F",[-2.29492,-4.57617,-0.0010004],210],
        ["Land_BagFence_Short_F",[-0.792969,-5.19922,-0.0010004],195],
        ["Land_BagFence_End_F",[-5.0293,-2.39258,-0.00100017],210],
        ["Land_BagFence_End_F",[0.873047,-5.19727,-0.00100017],345],
        ["Land_HelipadCircle_F",[1.57227,5.55469,0],0],
        ["Land_BagFence_Short_F",[4.0625,-5.19727,-0.0010004],345],
        ["Land_BagFence_Short_F",[5.5625,-4.57422,-0.0010004],330],
        ["Land_BagFence_Short_F",[-7.43359,0.0625,-0.0010004],45],
        ["Land_BagFence_Short_F",[6.93945,-3.57617,-0.0010004],315],
        ["Land_CncBarrier_F",[5.82031,-5.70313,0],0],
        ["Land_BagFence_End_F",[8.38672,-2.96875,-0.00100017],0],
        ["Land_BagFence_Short_F",[-8.43164,1.43945,-0.0010004],60],
        ["Land_CncBarrier_F",[7.19336,-5.32813,0],15],
        ["Land_BagFence_Short_F",[-9.05469,2.93945,-0.0010004],75],
        ["Land_BagFence_End_F",[-8.75,4.53125,-0.00100017],300],
        ["Land_PalletTrolley_01_khaki_F",[10.3125,1.54688,1.43051e-06],314.165],
        ["Land_BagFence_Short_F",[10.4551,0.0605469,-0.0010004],135],
        ["Land_Sacks_heap_F",[-1.91992,-10.2793,0],195],
        ["Land_MetalBarrel_F",[-8.67773,6.67969,1.66893e-06],315],
        ["Land_PaperBox_closed_F",[-7.91406,7.67969,0],105],
        ["Land_Pallets_stack_F",[10.8359,4.11133,0.00586319],305.784],
        ["Land_BagFence_End_F",[-9.96875,6.29688,-0.00100017],135],
        ["Land_BagFence_Short_F",[11.5781,1.4375,-0.0010004],120],
        ["Land_HBarrier_5_F",[2.32813,-11.6504,0],180],
        ["Land_Pallet_MilBoxes_F",[-6.77539,9.72266,0],135],
        ["Land_BagFence_Short_F",[-9.05664,7.79492,-0.0010004],285],
        ["Land_BagFence_End_F",[3.75977,-11.4453,-0.00100017],150],
        ["Land_BagFence_Long_F",[5.88867,-11.0742,-0.000999928],180],
        ["Land_BagFence_Short_F",[12.2012,2.93945,-0.0010004],105],
        ["Land_BagFence_Short_F",[-8.43359,9.29688,-0.0010004],300],
        ["Land_BagFence_Short_F",[-7.31055,10.6738,-0.0010004],315],
        ["Land_BagFence_End_F",[-5.08594,-11.584,-0.00100017],240],
        ["Land_BagFence_End_F",[12.875,4.53125,-0.00100017],300],
        ["Land_WaterBarrel_F",[0.705078,-13.2793,0],359.999],
        ["Land_Garbage_square5_F",[-1.11719,-13.2422,0],270],
        ["Land_Pallets_stack_F",[-0.919922,-13.5293,-0.0010004],149.999],
        ["Land_HelicopterWheels_01_assembled_F",[10.5723,9.05469,-0.00152946],150.004],
        ["Land_HelicopterWheels_01_disassembled_F",[10.5723,9.42969,-0.000773907],44.8743],
        ["Land_MetalBarrel_F",[-3.0918,13.9004,1.43051e-06],30.0071],
        ["Land_BagFence_End_F",[12.9551,6.39063,-0.00100017],45],
        ["Land_BagFence_Round_F",[8.63477,-11.4785,-0.00130081],225],
        ["Land_BagFence_Long_F",[-4.71484,-13.7129,-0.000999928],270],
        ["Land_MetalBarrel_F",[-2.55273,14.3047,1.43051e-06],254.993],
        ["Land_BagFence_Short_F",[12.1992,7.91992,-0.0010004],255],
        ["Land_BagFence_End_F",[-5.22852,13.6816,-0.00100017],165],
        ["Land_CargoBox_V1_F",[3.95508,-14.0293,0.0305393],179.995],
        ["CargoNet_01_barrels_F",[-1.17773,14.8047,-2.38419e-07],165.003],
        ["Land_BagFence_Short_F",[11.5762,9.41992,-0.0010004],240],
        ["Land_BagFence_Short_F",[-3.91992,14.4355,-0.0010004],135],
        ["Land_BagFence_Short_F",[10.5781,10.7969,-0.0010004],225],
        ["Land_HBarrier_5_F",[2.20117,-12.9063,0],90],
        ["Land_MetalBarrel_F",[5.20508,-14.5293,1.43051e-06],359.979],
        ["CamoNet_INDP_open_F",[2.30469,-15.8926,0],0],
        ["Land_BagFence_Short_F",[-2.54297,15.4336,-0.0010004],150],
        ["Land_BagFence_End_F",[8.23633,13.5117,-0.00100017],15],
        ["Land_BagFence_Short_F",[6.81641,14.3125,-0.0010004],45],
        ["Land_BagFence_Short_F",[-1.04297,16.0566,-0.0010004],165],
        ["Land_PaperBox_closed_F",[3.95703,-15.666,0],180],
        ["Land_BagFence_Short_F",[5.43945,15.4355,-0.0010004],30],
        ["Land_BagFence_End_F",[0.572266,16.6914,-0.00100017],330],
        ["Land_Garbage_square5_F",[5.38281,-15.4922,0],270],
        ["Land_BagFence_Short_F",[3.9375,16.0586,-0.0010004],15],
        ["Land_BagFence_Long_F",[8.99414,-14.0625,-0.000999928],270],
        ["Land_BagFence_Long_F",[-4.6543,-16.6504,-0.000999928],90],
        ["Land_Sacks_heap_F",[3.83008,-17.2793,0],195],
        ["Land_BagFence_Long_F",[9.05469,-17,-0.000999928],90],
        ["Land_BagFence_Round_F",[-4.29492,-19.2344,-0.00130081],45],
        ["Land_BagFence_End_F",[0.580078,-19.2676,-0.00100017],330],
        ["Land_BagFence_Long_F",[-1.54883,-19.6387,-0.000999928],0],
        ["Land_BagFence_End_F",[9.42578,-19.1289,-0.00100017],60],
        ["Snake_random_F",[3.11328,23.0391,0.0083878],112.585],
        ["Snake_random_F",[-11.6895,-37.1699,0.0083878],47.8806]
    ],
    // Fifth emplacement
    [
        ["Land_PaperBox_open_full_F",[-2.00586,3.60156,0],90],
        ["Land_BagFence_Long_F",[-4.12305,0.537109,-0.000999928],0],
        ["Land_Medevac_house_V1_F",[-0.621094,5.83008,0],0],
        ["Land_Pallets_F",[0.791016,-6.83203,0],276.992],
        ["Land_BagFence_Long_F",[3.77148,5.52539,-0.000999928],90],
        ["Land_BagFence_End_F",[-4.30078,-6.01953,-0.00100017],92.9765],
        ["Land_BagFence_Long_F",[-6.99023,0.505859,-0.000999928],180],
        ["CamoNet_OPFOR_open_F",[-2.0332,-7.60938,0],5.49837],
        ["Land_Sacks_heap_F",[-7.12305,3.05078,0],203.249],
        ["Land_PaperBox_open_full_F",[-2.57422,-7.56641,0],45.2475],
        ["Land_PaperBox_open_empty_F",[-6.99609,4.72656,0],0],
        ["Land_PaperBox_closed_F",[-4.91797,-7.25781,0],287.977],
        ["Land_MetalBarrel_F",[-1.88672,-8.68555,1.66893e-06],152.954],
        ["Land_BagFence_Long_F",[3.77148,8.40039,-0.000999928],90],
        ["Land_BagFence_Round_F",[-9.53516,1.0293,-0.00130081],45],
        ["Land_Wall_IndCnc_4_D_F",[2.01563,10.0859,0],180],
        ["Land_BagFence_Round_F",[-9.44922,3.64648,-0.00130081],135],
        ["Land_Wall_IndCnc_Pole_F",[-2.06836,10.0723,0],0],
        ["Land_Wall_IndCnc_4_F",[-7.98828,5.88281,0],270],
        ["Land_TTowerSmall_1_F",[-5.47461,7.6582,0],0],
        ["Land_PowerGenerator_F",[-7.12109,8.46094,0],180],
        ["Land_Wall_IndCnc_4_F",[-6.13477,10.0156,0],0],
        ["Land_PaperBox_open_empty_F",[7.11133,-11.1445,0],223.635],
        ["Land_Medevac_house_V1_F",[4.86523,-14.623,0],133.635],
        ["Land_PaperBox_closed_F",[8.39648,-12.2852,0],40.0019],
        ["Land_Pallet_MilBoxes_F",[-8.01367,-13.1543,0],264.297],
        ["Land_Medevac_house_V1_F",[-3.97461,-16.3203,0],208.635],
        ["Land_Pallets_stack_F",[-8.73438,-15.2109,-0.00100017],299.388],
        ["Land_BagFence_Long_F",[8.79688,-16.2461,-0.000999928],312.617],
        ["Land_Pallets_stack_F",[2.41406,-18.5508,0],347.334],
        ["Land_BagFence_Long_F",[6.88086,-18.3281,-0.000999928],312.617],
        ["Snake_random_F",[-16.3379,12.1172,0.0083878],179.553],
        ["Land_BagFence_Long_F",[-7.32031,-19.1191,-0.000999451],210.729],
        ["Land_BagFence_Long_F",[-4.88867,-20.5645,-0.000999451],210.729],
        ["Snake_random_F",[21.707,14.4199,0.0083878],278.246],
        ["Snake_random_F",[-43.4727,-2.34766,0.0083878],91.0538],
        ["Rabbit_F",[30.9863,32.416,0.00223756],310.035]
    ],
    // Sixth emplacement
    [
        ["Land_Pallets_stack_F",[-5.07813,-0.912109,-2.38419e-07],2.04762],
        ["Land_PaperBox_closed_F",[-5.25977,-3.34961,0],210.651],
        ["Land_Pallet_vertical_F",[-6.00391,-2.58789,2.26498e-05],129.027],
        ["Land_Pallet_F",[-7.04297,-1.42188,-2.38419e-07],153.337],
        ["Land_Cargo20_white_F",[-1.00781,7.36719,0],270],
        ["Land_BagFence_Long_F",[4.61523,6.55273,-0.000999928],0],
        ["Land_Pallets_stack_F",[5.68945,-6.24414,-0.00100017],271.735],
        ["Land_BagFence_Long_F",[3.22852,7.9082,-0.000999928],270],
        ["Land_Cargo20_white_F",[-5.25781,7.49219,4.76837e-07],270],
        ["Land_Pallets_F",[7.6543,-4.58008,0],177.56],
        ["WaterPump_01_sand_F",[9.05078,-3.24023,0.000850677],345.002],
        ["Land_BagFence_Round_F",[9.91992,-0.958984,-0.00130081],210],
        ["Land_BagFence_Long_F",[5.91797,-7.91406,-0.000999928],165],
        ["Land_ToiletBox_F",[2.36914,9.91211,2.86102e-06],45.0009],
        ["Land_Medevac_house_V1_F",[6.86914,8.89063,0],0],
        ["Land_BagFence_Long_F",[8.61133,-7.19922,-0.000999928],345],
        ["Land_HBarrier_Big_F",[-4.86328,-9.97852,4.76837e-07],170.538],
        ["Land_BagFence_Long_F",[10.9668,-3.48242,-0.000999928],255],
        ["Land_BagFence_End_F",[8.92969,6.81055,-0.00100017],180],
        ["Land_BagFence_Long_F",[-1.12695,11.8965,-0.000999928],180],
        ["Land_BagFence_Long_F",[1.74805,11.8965,-0.000999928],180],
        ["Land_LampShabby_F",[9.31836,7.29492,0],165],
        ["Land_HBarrier_Big_F",[-12.2441,-0.136719,4.76837e-07],257.272],
        ["Land_BagFence_Round_F",[11.2148,-6.15039,-0.00130081],300],
        ["Land_BagFence_Long_F",[-3.75195,11.8965,-0.000999928],180],
        ["Land_BagFence_Corner_F",[10.4668,6.78516,-0.000999928],90],
        ["Land_BagFence_Corner_F",[3.13477,12.9219,-0.000999928],270],
        ["Land_HBarrier_Big_F",[-10.209,-8.01758,4.76837e-07],257.272],
        ["Land_BagFence_Short_F",[10.4941,8.55664,-0.0010004],90],
        ["Land_BagFence_Long_F",[-6.62695,11.8965,-0.000999928],180],
        ["Land_BagFence_Long_F",[5.12305,12.8965,-0.000999928],180],
        ["Land_HBarrier_Big_F",[-11.6484,7.75586,0],120.34],
        ["Land_PowerGenerator_F",[11.4941,8.14648,0],180],
        ["Land_BagFence_Corner_F",[-8.60742,11.9238,-0.000999928],270],
        ["Land_BagFence_Long_F",[10.4766,10.918,-0.000999928],270],
        ["Land_BagFence_Long_F",[7.99805,12.8965,-0.000999928],180],
        ["Land_TTowerSmall_1_F",[11.3887,9.92383,0],0],
        ["Land_BagFence_Corner_F",[10.5039,12.8984,-0.000999928],0]
    ],
    // Seventh emplacement
    [
        ["Land_ToiletBox_F",[-6.72852,0.0507813,1.90735e-06],270.001],
        ["Land_ToiletBox_F",[-6.60352,1.67578,3.8147e-06],285.002],
        ["C_Van_02_medevac_F",[-3.53125,7.00977,-0.058928],183.603],
        ["Land_BagFence_Long_F",[-8.46094,-0.0253906,-0.000999928],90],
        ["WaterPump_01_forest_F",[8.52148,-1.82422,0.000851631],225.001],
        ["C_IDAP_Van_02_medevac_F",[2.79688,8.62891,-0.0589304],168.544],
        ["Land_BagFence_Round_F",[-8.81055,2.5625,-0.00130081],225],
        ["Land_Pallets_F",[8.66406,-2.99219,0],159.076],
        ["Land_PaperBox_closed_F",[6.66016,7.30273,0],92.3801],
        ["Land_Sacks_heap_F",[8.02148,6.55078,0],105],
        ["Land_BagFence_Round_F",[-8.89648,-5.65234,-0.00130081],315],
        ["Land_BagFence_Long_F",[-0.210938,10.7246,-0.000999928],90],
        ["Land_PaperBox_open_empty_F",[10.3965,-2.69922,0],220.358],
        ["Land_PortableLight_double_F",[9.25781,6.24023,0],60],
        ["Land_PaperBox_closed_F",[-11.0996,-2.58594,0],172.335],
        ["Land_PaperBox_closed_F",[-11.5273,-0.707031,0],144.595],
        ["CamoNet_INDP_open_F",[-12.0918,-1.04883,0],90],
        ["Land_BagFence_Long_F",[-11.4512,3.01563,-0.000999928],180],
        ["Land_BagFence_Long_F",[6.13281,10.8418,-0.000999928],270],
        ["Land_BagFence_Long_F",[-6.58594,10.8496,-0.000999928],90],
        ["Land_Wreck_Car3_F",[11.9434,-4.25781,0],60],
        ["Land_BagFence_Long_F",[-11.6055,-6.01367,-0.000999928],0],
        ["Land_BagFence_Round_F",[-0.603516,13.4258,-0.00130081],225],
        ["Land_Medevac_house_V1_F",[10.6465,8.9043,0],0],
        ["Land_BagFence_Round_F",[0.242188,13.6172,-0.00130081],135],
        ["Land_BagFence_Round_F",[-14.1602,2.65625,-0.00130081],135],
        ["Land_BagFence_Long_F",[-3.34766,13.8301,-0.000999928],180],
        ["Land_BagFence_Long_F",[3.02734,13.9551,-0.000999928],180],
        ["Land_BagFence_Round_F",[5.77148,13.5508,-0.00130081],225],
        ["Land_BagFence_Round_F",[-6.13281,13.4922,-0.00130081],135],
        ["Land_BagFence_Long_F",[-14.5508,0.0195313,-0.000999928],90],
        ["Land_BagFence_Long_F",[-14.5859,-2.77539,-0.000999928],90],
        ["Land_BagFence_Round_F",[6.69336,13.4707,-0.00130081],135]
    ],
	
	[
	// First emplacement
        ["CargoNet_01_barrels_F", [3.44727, 0.595703, -7.15256e-07], 0.00222852],
        ["CargoNet_01_barrels_F", [3.07227, 2.5957, -7.15256e-07], 255.002],
        ["Land_BagFence_Long_F", [4.58789, 0.0996094, -0.000999928], 90],
        ["Land_BagFence_Long_F", [4.55664, 2.8418, -0.000999928], 270],
        ["Land_HelipadSquare_F", [-5.55273, 1.5957, 0], 0],
        ["Land_CampingTable_white_F", [7.14648, 0.841797, -0.00259185], 90.3692],
        ["Land_MetalBarrel_F", [3.19727, -6.6543, 1.66893e-06], 300.005],
        ["Land_BagFence_Long_F", [4.55664, -6.0332, -0.000999928], 270],
        ["Land_MetalBarrel_F", [3.19727, -7.4043, 1.43051e-06], 90.0004],
        ["Land_MetalBarrel_F", [3.82227, -7.1543, 1.43051e-06], 225.016],
        ["Land_BagFence_End_F", [0.283203, -8.11133, -0.00100017], 195],
        ["Land_CampingChair_V2_white_F", [6.97656, -4.5332, -2.14577e-06], 314.87],
        ["StretcherRollerSystem_01_F", [7.32813, 4.26172, 0.00295734], 358.837],
        ["HazmatBag_01_roll_F", [7.65234, -4.22852, 3.14713e-05], 252.332],
        ["Land_BagFence_Long_F", [2.45117, -8.41992, -0.000999928], 180],
        ["HazmatBag_01_roll_F", [7.99805, -4.10156, 3.21865e-05], 329.775],
        ["Land_BagFence_End_F", [4.82031, 7.16992, -0.00100017], 75],
        ["Land_BagFence_Corner_F", [4.55859, -8.41406, -0.000999928], 90],
        ["HazmatBag_01_F", [8.40039, -3.58398, -1.19209e-06], 46.3251],
        ["Land_BagFence_Long_F", [-4.18164, -8.51367, -0.000999928], 0],
        ["Broom_01_yellow_F", [8.47656, -4.88281, -0.0211353], 255.01],
        ["HazmatBag_01_empty_F", [8.72656, -5.25781, 6.65188e-05], 224.981],
        ["Land_MedicalTent_01_floor_light_F", [10.2578, -1.60156, 0.0235791], 0],
        ["ContainmentArea_03_yellow_F", [10.2676, -1.55664, 0.0235791], 0],
        ["DeconShower_01_F", [10.2969, 1.30469, -0.00584078], 359.791],
        ["PressureHose_01_Roll_F", [8.06445, 6.94141, 0], 210],
        ["Land_BagFence_Long_F", [4.58789, 9.47461, -0.000999928], 90],
        ["Land_CratesWooden_F", [-4.92773, -9.5293, 0], 0],
        ["Land_MedicalTent_01_floor_light_F", [10.2578, 3.64844, 0.0235791], 0],
        ["Land_HelicopterWheels_01_disassembled_F", [1.69727, 10.8457, -0.000773907], 44.9744],
        ["Land_BagFence_Long_F", [-6.92383, -8.54492, -0.000999928], 180],
        ["Land_HelicopterWheels_01_assembled_F", [2.19727, 10.9707, -0.00152946], 150.007],
        ["SpinalBoard_01_orange_F", [7.75, 8.30859, -2.38419e-07], 318.592],
        ["Land_BagFence_End_F", [0.0722656, 11.209, -0.00100017], 150],
        ["Land_BagFence_Long_F", [2.20117, 11.5801, -0.000999928], 180],
        ["Land_BagFence_Corner_F", [4.58203, 11.582, -0.000999928], 0],
        ["Land_BagFence_Long_F", [-4.18164, 11.7363, -0.000999928], 0],
        ["Land_Pallet_MilBoxes_F", [-7.42578, 10.5859, 0], 0],
        ["TrashBagHolder_01_F", [13.3223, -0.560547, 7.15256e-06], 33.6444],
        ["LayFlatHose_01_Roll_F", [12.6289, -4.39648, 0], 255],
        ["CBRNContainer_01_closed_yellow_F", [13.4102, -1.23047, -2.38419e-07], 27.3427],
        ["CBRNContainer_01_closed_yellow_F", [13.4727, -1.79492, 2.38419e-07], 358.353],
        ["Land_BagFence_Long_F", [-6.92383, 11.7051, -0.000999928], 180],
        ["CBRNContainer_01_closed_yellow_F", [13.5137, -2.40625, 0], 248.432],
        ["Land_CampingTable_small_white_F", [13.334, 3.45703, 0.00260305], 359.993],
        ["Land_CampingChair_V2_white_F", [13.3945, 4.20703, 2.14577e-06], 29.848],
        ["Land_BagFence_End_F", [-11.2012, -8.95703, -0.00100017], 30],
        ["Land_Pallets_stack_F", [-14.6328, 0.480469, 0.290426], 325.265],
        ["Land_BagFence_End_F", [-9.2168, 12.0137, -0.00100017], 195],
        ["Land_PalletTrolley_01_khaki_F", [-15.2754, 2.89648, 0.0594318], 60.8087],
        ["Land_BagFence_Long_F", [-15.6621, 0.0996094, -0.000999928], 90],
        ["Land_BagFence_Long_F", [-13.3066, -8.51367, -0.000999928], 0],
        ["Land_BagFence_Long_F", [-15.6934, 2.8418, -0.000999928], 270],
        ["Land_FieldToilet_F", [13.7715, 8.20117, -7.15256e-06], 104.997],
        ["Land_BagFence_End_F", [-15.9258, 5.14648, -0.00100017], 255],
        ["Land_BagFence_Long_F", [-15.6934, -6.4082, -0.000999928], 270],
        ["Land_PaperBox_open_empty_F", [-14.5527, 8.9707, 0], 0],
        ["Land_BagFence_Corner_F", [-15.6875, -8.51563, -0.000999928], 180],
        ["Land_BarrelTrash_grey_F", [-13.4277, 11.0957, 1.90735e-06], 359.995],
        ["Land_BagFence_End_F", [-15.9707, 7.05664, -0.00100017], 105],
        ["Land_BagFence_Long_F", [-13.5566, 11.7363, -0.000999928], 0],
        ["Land_PaperBox_closed_F", [-14.5547, 10.6074, 0], 0],
        ["Land_BagFence_Long_F", [-15.6621, 9.34961, -0.000999928], 90],
        ["Land_BagFence_Corner_F", [-15.6641, 11.7305, -0.000999928], 270],
        ["Snake_random_F", [24.5391, 1.44336, 0.0083878], 176.007],
        ["Snake_random_F", [11.5703, 29.5508, 0.0083878], 330.714]
    ],
    [
        // Second emplacement
        ["Land_HBarrier_Big_F", [3.94922, 0.425781, 0], 59],
        ["Box_East_AmmoVeh_F", [6.9707, -0.492188, 0.0295436], 226.43],
        ["Land_HBarrier_Big_F", [1.62109, 7.15234, 0], 269],
        ["Land_MetalBarrel_F", [6.24805, 4.45117, 0.00035429], 31.2693],
        ["Land_BagBunker_Large_F", [-3.79883, 7.39453, 0], 90.3651],
        ["Land_Pallets_F", [6.53711, 4.2168, 0], 90],
        ["Land_Garbage_square5_F", [8.61133, 1.65039, 0], 90],
        ["Land_Pipes_small_F", [9.375, -1.05859, -2.38419e-07], 181],
        ["Land_HBarrier_Big_F", [10.3242, -2.48047, 0], 179],
        ["Land_Shovel_F", [11.0371, -0.0644531, 0.0241168], 240.152],
        ["Land_MetalWire_F", [11.0391, -0.8125, 0], 300],
        ["Land_TinContainer_F", [11.0781, -0.318359, 0.00121045], 300.343],
        ["Land_FoodContainer_01_F", [11.2852, -1.0625, 0.000974894], 14.9073],
        ["CamoNet_OPFOR_big_F", [10.084, 5.45117, 0], 180],
        ["Land_HBarrier_Big_F", [6.62109, 9.40234, 0], 269],
        ["Land_BagBunker_Small_F", [4.03906, 11.7422, 0], 180],
        ["Land_Sacks_heap_F", [12.2891, -0.8125, 0], 0],
        ["O_HMG_01_high_F", [4.03906, 11.9375, -0.0871191], 360],
        ["Land_HBarrier_1_F", [13.7969, -1.0625, 0], 270],
        ["Land_Ammobox_rounds_F", [14.7891, 5.1875, -0.000167847], 164.999],
        ["Land_Ammobox_rounds_F", [15.2891, 4.9375, -0.000167847], 224.995],
        ["Land_CratesWooden_F", [14.7891, 6.6875, 0], 90],
        ["Land_HBarrier_5_F", [7.79297, 12.8281, 0], 357],
        ["Land_HBarrier_5_F", [16.6465, 3.19141, 0], 267],
        ["Land_HBarrier_1_F", [13.2891, 12.9297, 0], 0],
        ["Snake_random_F", [-35.1309, -33.002, 0.0083878], 243.873]
    ],
    [
        // Third emplacement
        ["Land_HBarrier_5_F", [2.41211, 6.52734, 0], 75.3196],
        ["Land_BagFence_Long_F", [-2.31445, 4.88672, -0.000999928], 150.32],
        ["Land_BagFence_Long_F", [0.246094, 5.94336, -0.000999928], 165.32],
        ["Land_BagBunker_Tower_F", [5.86914, -2.15039, 0], 165.32],
        ["Land_MetalBarrel_F", [6.17188, 3.4707, 1.43051e-06], 330.31],
        ["Land_CampingChair_V1_F", [-0.697266, -7.84961, 0.00309849], 29.9556],
        ["Land_FieldToilet_F", [2.59766, -7.39648, -0.000998497], 49.0001],
        ["Land_MetalBarrel_F", [6.59375, 4.39258, 1.43051e-06], 105.324],
        ["Land_MetalBarrel_F", [7.14648, 3.76172, 1.43051e-06], 60.3113],
        ["Land_CampingChair_V1_F", [-1.94727, -7.84961, 0.00308967], 344.976],
        ["Land_BagFence_Long_F", [4.58398, 7.11133, -0.000999928], 345.32],
        ["Land_BagFence_Long_F", [2.79492, -8.21094, -0.000999928], 345],
        ["Land_CampingTable_F", [-1.32227, -8.59961, -0.00259185], 0.00153876],
        ["Land_BagFence_Long_F", [5.54492, -7.46094, -0.000999928], 345],
        ["Land_CampingTable_F", [-1.32422, -9.47266, -0.00140953], 180.373],
        ["Land_BagFence_Long_F", [1.81641, -9.8418, -0.000999928], 75],
        ["Land_CampingChair_V1_F", [-1.94922, -10.1035, 0.005229], 225.047],
        ["Land_CampingChair_V1_F", [-0.822266, -10.3496, 0.00308943], 314.99],
        ["Land_BagFence_Long_F", [8.04492, -6.83594, -0.000999928], 345],
        ["Land_BagFence_Long_F", [10.5176, 2.18164, -0.000999928], 240.32],
        ["Land_BagFence_Long_F", [11.543, -0.259766, -0.000999928], 255.32],
        ["Land_BagFence_Short_F", [9.55469, -7.10938, -0.0010004], 255],
        ["CamoNet_INDP_open_F", [-0.0332031, -12.0527, 0], 80],
        ["Land_BagFence_Long_F", [11.9355, -3.125, -0.000999928], 90.3196],
        ["Land_Cargo_House_V1_F", [6.74805, -10.8457, 0], 75],
        ["Land_BagFence_Long_F", [10.0391, -8.85742, -0.000999928], 255],
        ["Land_Garbage_square5_F", [3.27344, -14.4707, 0], 0],
        ["Land_BagFence_Long_F", [7.06055, -14.1133, -0.000999928], 165],
        ["Land_BagFence_Long_F", [10.8164, -11.5918, -0.000999928], 75],
        ["Land_BagFence_Long_F", [9.81055, -13.3633, -0.000999928], 165],
        ["Land_PowerGenerator_F", [7.53711, -14.7285, 0], 255],
        ["Land_PaperBox_closed_F", [9.81055, -14.6094, 0], 150],
        ["Land_TTowerSmall_1_F", [8.69336, -14.959, 0], 345],
        ["Land_PaperBox_closed_F", [12.6895, -13.7637, -0.263005], 298.947],
        ["Land_BagFence_End_F", [-2.99219, -18.1758, -0.00100017], 240],
        ["Land_GarbagePallet_F", [11.7715, -14.8867, 0], 345],
        ["Land_BagFence_End_F", [1.52539, -19.4199, -0.00100017], 330],
        ["Land_BagFence_Round_F", [-2.49023, -20.2324, -0.00130081], 60],
        ["Land_Garbage_square5_F", [12.1426, -16.4961, 0], 150],
        ["Land_BagFence_Round_F", [-0.015625, -20.9414, -0.00130081], 330],
        ["Snake_random_F", [13.3262, 24.9219, 0.0083878], 209.488],
        ["Snake_random_F", [41.3145, -15.9922, 0], 19.2273]
    ],
    [
        // Fourth emplacement
        ["Land_GarbagePallet_F", [-1.50586, 5.73828, 0], 0],
        ["Land_PaperBox_open_full_F", [-8.33008, -0.564453, 0], 45],
        ["Land_TBox_F", [5.33594, 8.30469, 0], 90],
        ["Snake_random_F", [9.82422, 0.712891, 0.0083878], 188.497],
        ["Land_Metal_Shed_F", [1.84766, 8.1543, 0], 0],
        ["Land_CratesShabby_F", [-0.414063, 9.90234, 0], 90],
        ["Land_Cages_F", [-4.03125, 9.52539, 0], 270],
        ["Land_Garbage_square5_F", [1.75586, 10.4727, 0], 0],
        ["Land_Tyre_F", [-3.30273, 10.7988, -0.0043025], 0.0136312],
        ["Land_BagFence_Long_F", [-11.3281, -0.917969, -0.000999928], 359],
        ["Land_Pallet_vertical_F", [4.08789, 10.9023, 0.219031], 35.3103],
        ["Land_GarbageBags_F", [7.05469, 8.13477, 0], 0],
        ["Land_FoodContainer_01_F", [-0.03125, 12.6504, 7.15256e-07], 60.0011],
        ["Land_GarbageBags_F", [6.75781, 11.6289, 0], 150],
        ["Land_Razorwire_F", [-13.8027, -4.87695, -2.86102e-06], 359.657],
        ["Land_CampingTable_small_F", [-0.519531, 13.1543, 0.0026021], 29.9986],
        ["Land_Ammobox_rounds_F", [-0.90625, 13.2754, -0.000165462], 14.9917],
        ["Land_BagFence_Round_F", [11.4707, -7.4668, -0.00130081], 0.745396],
        ["Land_CampingChair_V1_F", [13.5742, -2.17773, 0.00308919], 255.739],
        ["Land_CampingChair_V1_F", [-0.28125, 13.7754, 0.00308943], 359.999],
        ["Land_BagFence_Round_F", [-14.0098, -0.822266, -0.00130081], 29.65],
        ["Land_CampingTable_F", [14.2324, -1.52344, -0.00259161], 240.211],
        ["Land_BagFence_Long_F", [-14.7148, 1.6875, -0.000999928], 269],
        ["Land_BagFence_Long_F", [13.6309, -5.92578, -0.000999928], 315.745],
        ["Land_BagFence_Long_F", [15.6895, -3.91992, -0.000999928], 315.745],
        ["Land_Razorwire_F", [-17.0059, -2.53711, -2.86102e-06], 269.657],
        ["Land_BagFence_End_F", [17.0898, -2.23438, -0.00100017], 300.745],
        ["MapBoard_altis_F", [17.002, 0.128906, -0.00223589], 45.7568],
        ["Land_BagFence_Round_F", [4.54492, 18.2871, -0.00130081], 89.65],
        ["Land_BagFence_Round_F", [7.85547, 18.1465, -0.00130081], 270],
        ["Land_PowerGenerator_F", [10.6563, 17.4121, 0], 194.305],
        ["Land_MetalBarrel_F", [11.5352, 16.9277, 1.66893e-06], 129.013],
        ["Land_BagFence_Round_F", [6.29883, 19.9375, -0.00130081], 180.265],
        ["Land_TTowerSmall_2_F", [6.27539, 18.332, 0], 180],
        ["Land_MetalBarrel_F", [11.9102, 17.5762, 1.43051e-06], 330.001],
        ["Land_BagFence_Long_F", [10.1602, 19.1621, -0.000999928], 194],
        ["Land_BagFence_Long_F", [14.0508, 16.6777, -0.000999928], 104],
        ["Land_Razorwire_F", [6.0957, 22.0703, -2.86102e-06], 164.657],
        ["Land_BagFence_Long_F", [13.0352, 18.5684, -0.000999928], 14],
        ["Land_Razorwire_F", [15.5215, 14.8418, -2.86102e-06], 276.523],
        ["Land_Razorwire_F", [13.6914, 21.3008, -2.86102e-06], 194.657],
        ["Snake_random_F", [26.3711, 14.5176, 0.0083878], 139.83]
    ],
    [
        // Fifth emplacement
        ["Land_Pallets_stack_F", [3.56055, 2.16992, 1.43051e-06], 193.854],
        ["Land_Garbage_square5_F", [-5.16797, 1.51172, 0], 0],
        ["CamoNet_INDP_F", [-1.72852, 5.26367, 0], 0],
        ["Land_HBarrier_3_F", [3.74609, -5.76367, 0], 240],
        ["Land_Portable_generator_F", [-5.11133, 2.94141, -0.000874043], 300.057],
        ["Land_Pallet_MilBoxes_F", [-6.19531, -1.49023, 0], 150],
        ["Land_HBarrier_Big_F", [5.46289, 2.97461, 0], 90],
        ["Land_PortableLight_double_F", [-6.06641, 2.25391, 0], 300],
        ["Land_CratesWooden_F", [3.04492, 6.06445, 0], 0],
        ["Land_PaperBox_closed_F", [-6.32227, 4.30469, 0], 150],
        ["Land_HBarrier_Big_F", [2.13477, 7.98242, 0], 0],
        ["Land_HBarrier_3_F", [-8.22852, -1.19727, 0], 90],
        ["Land_PaperBox_closed_F", [-6.33203, 5.95117, 0], 0],
        ["Land_BagFence_End_F", [8.69531, -0.285156, -0.00100017], 105],
        ["Land_HBarrier_Big_F", [-8.24805, 3.0293, 0], 270],
        ["Land_BagFence_Short_F", [9.4375, 1.06641, -0.0010004], 135],
        ["Land_HBarrier_5_F", [3.92383, -10.9336, 0], 270],
        ["Land_Razorwire_F", [7.35156, 4.58594, -2.86102e-06], 270],
        ["Land_BagFence_End_F", [8.92578, -2.97266, -0.00100017], 180],
        ["Land_Razorwire_F", [3.97266, 9.87891, -2.86102e-06], 180],
        ["Land_HBarrier_Big_F", [-6.36523, 7.85742, 0], 0],
        ["Land_PaperBox_open_full_F", [-10.3301, -0.445313, 0], 0],
        ["Land_Radar_Small_F", [-3.68359, -8.61719, 0], 90],
        ["Land_BagFence_Round_F", [11.2715, 2.19922, -0.00130081], 180],
        ["Land_BagFence_Round_F", [11.0215, -3.63672, -0.00130081], 0],
        ["CamoNet_INDP_F", [-11.2559, 1.33789, 0], 90],
        ["Land_Razorwire_F", [-4.52734, 9.75391, -2.86102e-06], 180],
        ["Land_Pallet_MilBoxes_F", [-10.4453, 5.81641, 0], 270],
        ["Land_CncBarrier_F", [9.04297, -8.69336, 0], 0],
        ["Land_Pallet_vertical_F", [-10.7051, -6.93359, 4.57764e-05], 359.992],
        ["Land_BagFence_Short_F", [12.9258, 1.05664, -0.0010004], 225],
        ["Land_BagFence_Short_F", [12.8555, -2.50195, -0.0010004], 315],
        ["Land_CampingChair_V2_F", [-13.0801, 3.06445, -1.43051e-06], 149.999],
        ["Land_BagFence_Round_F", [14.0605, -0.777344, -0.00130081], 270],
        ["Land_WaterBarrel_F", [-12.3301, -6.68555, -0.000999928], 0.000175169],
        ["Land_IronPipes_F", [0.376953, -14.4805, 0], 0],
        ["MapBoard_altis_F", [-13.3262, 5.19727, -0.00222731], 24.7905],
        ["Land_CampingChair_V2_F", [-14.7051, 2.06445, -1.19209e-06], 164.995],
        ["Land_CampingChair_V2_F", [-14.7051, 5.18945, -1.43051e-06], 359.992],
        ["Land_CncBarrier_F", [13.043, -8.56836, 0], 0],
        ["Land_Cargo10_grey_F", [-8.45508, -13.8105, -0.00099802], 90],
        ["Land_HBarrierTower_F", [8.95313, -13.8867, 0], 270],
        ["Land_HBarrier_Big_F", [2.95508, -16.2285, 0], 180],
        ["Land_HBarrier_Big_F", [-14.2949, -8.35352, 0], 180],
        ["Land_HBarrier_Big_F", [-14.8652, 7.73242, 0], 0],
        ["MapBoard_stratis_F", [-15.9648, 5.19531, -0.00223398], 292.699],
        ["Land_HBarrier_Big_F", [-10.873, -13.4707, 0], 270],
        ["Land_HBarrier_Big_F", [-5.54492, -16.3535, 0], 180],
        ["Land_Razorwire_F", [-13.0273, 9.62891, -2.86102e-06], 180],
        ["Land_HBarrier_Big_F", [-17.748, 2.4043, 0], 270],
        ["Land_Razorwire_F", [-1.13281, -18.125, -2.86102e-06], 0],
        ["Land_Razorwire_F", [-14.3516, -10.0039, -2.86102e-06], 180],
        ["Land_Razorwire_F", [-13.1387, -12.707, -2.86102e-06], 90],
        ["Land_Razorwire_F", [-9.63281, -18.25, -2.86102e-06], 0],
        ["Land_Razorwire_F", [14.3516, -15.5391, -2.86102e-06], 270],
        ["Land_Razorwire_F", [-19.6367, 5.41797, -2.86102e-06], 90],
        ["Land_Razorwire_F", [10.3984, -18.2539, -2.86102e-06], 180],
        ["Land_HBarrier_5_F", [-23.3867, -1.00977, 0], 0],
        ["Land_BagFence_Long_F", [-23.3789, -2.10742, -0.000999928], 270],
        ["Land_BagFence_Long_F", [-23.373, -3.25195, -0.000999928], 90],
        ["Land_BagFence_Long_F", [-22.9668, -6.14844, -0.000999928], 75],
        ["Snake_random_F", [1.08398, 38.791, 0.0083878], 0.116513],
        ["Snake_random_F", [-39.2637, 4.71289, 0.0083878], 147.753]
    ],
    [
        // Sixth emplacement
        ["Land_HBarrier_5_F", [-0.308594, 1.92578, 0], 180],
        ["Land_Garbage_square5_F", [0.279297, 3.55273, 0], 0],
        ["Land_GarbageWashingMachine_F", [-0.796875, 3.6543, 0], 180],
        ["Land_HBarrier_5_F", [0.939453, 6.16992, 0], 90],
        ["Land_BagFence_Short_F", [-4.80859, 0.162109, -0.0010004], 270],
        ["Land_BagFence_End_F", [-4.7832, 1.86133, -0.00100017], 270],
        ["Land_BagFence_Round_F", [-5.36133, -2.00195, -0.00130081], 315],
        ["MapBoard_stratis_F", [5.0625, 2.78906, -0.00223398], 225.138],
        ["MapBoard_altis_F", [3.31836, 5.04492, -0.00223589], 240.114],
        ["Land_BarrelTrash_grey_F", [-5.55664, 5.17188, 1.90735e-06], 359.957],
        ["Land_BagFence_Short_F", [-7.54688, -2.33008, -0.0010004], 180],
        ["Land_Cargo_House_V1_F", [-3.57813, 7.42188, 0], 90],
        ["Land_BagFence_End_F", [-8.93945, -1.66211, -0.00100017], 225],
        ["Land_ChairWood_F", [3.47266, 8.63672, -1.66893e-06], 255.123],
        ["Land_HBarrier_5_F", [0.947266, 7.42383, 0], 270],
        ["Land_WoodenTable_small_F", [4.33594, 8.92383, -2.38419e-07], 180.007],
        ["Land_WoodenTable_large_F", [7.85742, 6.76953, -2.38419e-07], 207.248],
        ["Land_Garbage_square5_F", [-5.76953, 8.74414, 0], 0],
        ["Land_GarbagePallet_F", [-5.53125, 9.13477, 0], 0],
        ["CamoNet_INDP_open_F", [8.57031, 7.26172, -0.864591], 270.145],
        ["Land_CampingChair_V2_F", [9.64453, 5.4082, -2.38419e-06], 120.142],
        ["Land_CratesShabby_F", [10.6895, 3.27734, 0], 45.1448],
        ["Land_Basket_F", [4.32813, 10.3477, 7.15256e-07], 180.146],
        ["Land_Garbage_square5_F", [10.1797, 5.12891, 0], 330.145],
        ["Land_CampingChair_V2_F", [9.9082, 6.36914, -1.66893e-06], 135.128],
        ["Land_PowerGenerator_F", [-1.07227, 11.7969, 0], 270],
        ["Land_GarbagePallet_F", [11.668, 1.81641, 0], 180.145],
        ["Land_PaperBox_closed_F", [-10.8145, 4.91211, 0], 225],
        ["Land_BagFence_Round_F", [-12.2285, -3.15625, -0.00130081], 315],
        ["Land_WaterBarrel_F", [11.9668, 4.51367, 0.00288248], 269.085],
        ["CamoNet_INDP_open_F", [-11.9199, 6.07422, 0], 90],
        ["Land_WaterBarrel_F", [-11.5566, 6.17188, 0], 360],
        ["Land_CratesPlastic_F", [-2.30469, 12.9258, 0], 255],
        ["Land_Garbage_square5_F", [-12.2988, 4.65039, 0], 0],
        ["Land_HBarrier_3_F", [-1.16992, 13.1484, 0], 0],
        ["Land_WoodenTable_large_F", [9.21289, 9.66016, -2.38419e-07], 347.096],
        ["Land_CampingChair_V2_F", [9.97266, 9.33789, 7.15256e-06], 90.1445],
        ["Land_Pallets_F", [12.7891, 3.51367, 0], 45.1448],
        ["Land_WoodenTable_large_F", [6.84375, 12.541, -1.19209e-06], 120.01],
        ["Land_TTowerSmall_2_F", [-0.171875, 11.0176, 0], 0],
        ["Land_Pallets_stack_F", [-2.33203, 14.4453, -0.000993967], 314.721],
        ["Land_BagFence_Round_F", [-14.8047, -3.0332, -0.00130081], 45],
        ["Land_CratesWooden_F", [-14.5566, 2.92188, 0], 75],
        ["Land_CampingChair_V2_F", [6.82813, 13.2617, -2.14577e-06], 30.1378],
        ["Land_CampingChair_V2_F", [7.71094, 13.0391, 2.38419e-06], 60.141],
        ["Land_BagFence_Long_F", [-15.4531, -0.244141, -0.000999928], 260],
        ["Land_PaperBox_closed_F", [-12.3086, 10.9355, 0], 0],
        ["Land_HBarrier_5_F", [-16.9199, 5.73047, 0], 75],
        ["Land_HBarrier_5_F", [-8.80859, 12.9258, 0], 180],
        ["Land_HBarrier_5_F", [-17.0605, 10.9199, 0], 90],
        ["I_Truck_02_transport_F", [-7.31836, 18.1777, -0.0154696], 285.002],
        ["Snake_random_F", [40.5059, 1.76758, 0.0083878], 205.102],
        ["Snake_random_F", [41.8281, -0.216797, 0.0083878], 212.167]
    ],
    [
        // Seventh emplacement
        ["Land_BagFence_Short_F", [-3.24023, 0.585938, -0.0010004], 270],
        ["Land_BagFence_Corner_F", [-3.25391, -1.24219, -0.000999928], 90],
        ["Land_BagFence_Corner_F", [-3.27539, 2.08008, -0.000999928], 0],
        ["Land_BagFence_Short_F", [-4.74805, -1.27734, -0.0010004], 0],
        ["Land_BagFence_Short_F", [-5.10352, 2.09375, -0.0010004], 180],
        ["Land_BagFence_Corner_F", [-6.57617, -1.26367, -0.000999928], 180],
        ["Land_BagFence_Corner_F", [-6.59766, 2.05859, -0.000999928], 270],
        ["Land_BagFence_Short_F", [-6.61133, 0.230469, -0.0010004], 90],
        ["Land_u_House_Small_02_V1_dam_F", [1.20898, 9.02734, 0], 270],
        ["Land_CampingChair_V1_F", [-3.82422, 7.54102, 0.00308919], 254.98],
        ["Land_CampingTable_F", [-2.96484, 8.10938, -0.00339723], 272.059],
        ["Land_CampingChair_V1_F", [-3.44336, 8.61523, 0.00319862], 284.796],
        ["Land_PaperBox_open_empty_F", [-8.23828, 6.2207, 0], 315],
        ["Land_Pallet_MilBoxes_F", [-9.51172, 4.84766, 0], 255],
        ["CamoNet_INDP_open_F", [-6.25, 9.82031, 0], 270],
        ["Land_Sacks_heap_F", [-10.2383, 6.2207, 0], 0],
        ["Land_Wreck_Car_F", [-12.2441, 0.357422, 0], 210],
        ["Land_IronPipes_F", [-3.91992, 14.0938, 0], 105],
        ["Land_BagFence_Round_F", [-14.5938, 0.640625, -0.00130081], 15],
        ["Land_BagFence_Short_F", [-15.9922, 2.23047, -0.0010004], 60],
        ["Land_PaperBox_closed_F", [-9.87109, 12.9805, 0], 330],
        ["Land_CinderBlocks_F", [0.53125, 16.3457, 7.15256e-07], 89.9931],
        ["Land_CinderBlocks_F", [1.90625, 16.3457, -2.38419e-07], 104.993],
        ["Land_PaperBox_open_full_F", [-11.7285, 11.7188, 0], 285],
        ["Land_BagFence_Round_F", [-16.5977, 4.37109, -0.00130081], 105],
        ["Land_Pallets_stack_F", [-11.7383, 13.4707, 0], 105],
        ["Snake_random_F", [-1.03711, 21.9492, 0.0083878], 24.8029],
        ["Land_JunkPile_F", [-8.41602, 20.6367, 0], 75],
        ["Land_BagFence_Round_F", [-10.3848, 21.4082, -0.00130081], 195],
        ["Land_BagFence_Round_F", [-12.6953, 20.1738, -0.00130081], 105],
        ["Snake_random_F", [-27.2871, -17.4707, 0.0083878], 134.729]
    ],
	[
	
		["Land_GarbagePallet_F",[-2.12109,-3.47852,0],240],
        ["Land_BagFence_Short_F",[0.203125,-9.50781,-0.0010004],90],
        ["CamoNet_INDP_open_F",[-8.19922,-7.25586,0],0],
        ["Land_BagFence_Corner_F",[0.1875,-11.1523,-0.000999928],90],
        ["Land_Pallet_MilBoxes_F",[-6.54688,-8.77734,0],0],
        ["Land_d_House_Small_02_V1_F",[-8.86719,1.16016,0],0],
        ["Land_BagFence_Long_F",[-1.91992,-11.1582,-0.000999928],180],
        ["Land_BagFence_Short_F",[-4.16406,-11.1445,-0.0010004],180],
        ["Land_Sacks_heap_F",[-6.67383,-10.2676,0],0],
        ["Land_HBarrier_3_F",[-8.32227,-8.1543,0],90],
        ["Land_PaperBox_closed_F",[-10.0508,-8.25586,0],0],
        ["Land_HBarrier_5_F",[-10.0469,-11.6465,0],0],
        ["Land_PaperBox_open_empty_F",[-10.0488,-9.89258,0],0],
        ["MetalBarrel_burning_F",[-14.9238,-2.89258,0],0],
        ["Land_CratesWooden_F",[-14.6738,-8.01758,0],0],
        ["Land_Razorwire_F",[-11.0957,14.873,-2.86102e-06],0],
        ["Land_FieldToilet_F",[-17.5156,-1.74805,2.38419e-06],44.9994],
        ["Land_HBarrier_5_F",[-15.6719,-11.6465,0],0],
        ["Land_FieldToilet_F",[-18.0488,-0.142578,9.05991e-06],60.0024],
        ["Land_HBarrier_5_F",[-16.8027,-7.39453,0],90],
        ["Land_WaterTank_F",[-15.6738,-13.1992,-8.58307e-06],0.00724751],
        ["Land_Razorwire_F",[-7.96094,-18.2578,-2.86102e-06],171],
        ["Land_Pallet_F",[-20.9102,-6.12109,0.0262344],17.5225],
        ["Land_Pallets_F",[-21.4316,-8.27734,0],60],
        ["Land_Razorwire_F",[-18.9297,13.4219,-2.86102e-06],345],
        ["Land_Razorwire_F",[-15.9043,-18.8828,-2.86102e-06],186],
        ["I_Quadbike_01_F",[-26.3613,0.0820313,-0.010004],286.781],
        ["Land_BagFence_Round_F",[-26.5605,-2.67773,-0.00130081],136.163],
        ["I_HMG_01_high_F",[-25.6816,-6.44727,-0.0871181],271.162],
        ["Land_BagFence_Long_F",[-27.0176,-5.29102,-0.000999928],91.1634],
        ["Land_BagFence_Round_F",[-26.709,-7.88086,-0.00130081],46.1634],
        ["Snake_random_F",[-28.0098,-26.4629,0.0083878],198.361]
    ],

    // Second emplacement
    [
        ["MetalBarrel_burning_F",[-2.74219,7.03711,0],89.4783],
        ["Land_Pallets_stack_F",[-4.27539,6.51367,-2.38419e-07],89.4785],
        ["Land_PaperBox_closed_F",[-3.9043,8.14258,0],89.4783],
        ["Land_d_Stone_HouseBig_V1_F",[-9.07031,-3.39063,0],0],
        ["Land_ToiletBox_F",[-5.96094,-8.12109,-0.000992298],359.996],
        ["Land_HBarrier_Big_F",[-3.91797,-10.7109,0],90],
        ["Land_d_House_Small_02_V1_F",[-8.71875,7.55273,0],89.4783],
        ["Land_BagFence_Round_F",[-13.0215,2.60156,-0.00130081],227.528],
        ["Land_CratesWooden_F",[-11.4609,-7.62109,0],0],
        ["CamoNet_INDP_open_F",[-9.11133,-11.4844,0],0],
        ["Land_PaperBox_closed_F",[-8.84766,-12.002,0],255],
        ["Land_BagFence_Short_F",[-15.2402,3.16797,-0.0010004],180.163],
        ["Land_BagFence_Round_F",[-15.5234,-1.18164,-0.00130081],239.342],
        ["Land_Sacks_heap_F",[-10.4609,-12.3711,0],270],
        ["Land_BagFence_Long_F",[-15.8203,-4.12109,-0.000999928],105],
        ["Land_PaperBox_open_empty_F",[-13.5508,9.17773,0],344.478],
        ["Land_HBarrier_Big_F",[-8.74609,-14.0781,0],0],
        ["Land_PaperBox_open_empty_F",[-16.8359,-1.74609,0],225],
        ["Land_Sacks_heap_F",[-16.7109,-3.49609,0],330],
        ["Land_BagFence_Round_F",[-17.3047,2.93555,-0.00130081],140.141],
        ["Land_BagFence_Round_F",[-17.7383,0.214844,-0.00130081],53.632],
        ["MetalBarrel_burning_F",[-17.9609,-2.62109,0],0],
        ["Land_HBarrier_5_F",[-15.7148,-7.62305,0],90],
        ["Land_PaperBox_open_full_F",[-17.3359,-8.13086,0],0],
        ["Land_Pallets_stack_F",[-17.4609,-9.99609,-2.38419e-07],360],
        ["Land_BagFence_Long_F",[-13.3516,-15.625,-0.000999928],120],
        ["Land_BagFence_Long_F",[-16.3555,-13.6953,-0.000999928],300],
        ["Land_Pallets_F",[-19.5762,-10.7539,0],330],
        ["Land_BagFence_Round_F",[-15.1836,-17.5664,-0.00130081],349.483],
        ["Land_BagFence_Round_F",[-17.3125,-16.0469,-0.00130081],78.854],
        ["Snake_random_F",[13.9043,-35.3066,0.0083878],212.29]
    ],

    // Third emplacement
    [
        ["Land_GarbageBags_F",[-0.115234,3.14453,0],0],
        ["Land_BagFence_Long_F",[-2.45313,3.92578,-0.000999928],0],
        ["Land_BagFence_Long_F",[-1.21484,5.28125,-0.000999928],270],
        ["Land_WaterTank_F",[0.671875,6.2168,0.076262],359.996],
        ["Land_BagFence_Long_F",[-5.20313,3.92578,-0.000999928],0],
        ["Land_PaperBox_closed_F",[-5.94727,5.14844,0],180],
        ["Land_Sacks_heap_F",[-1.57422,7.78516,0],90],
        ["Land_BagFence_Long_F",[-8.07031,3.89453,-0.000999928],180],
        ["Land_PaperBox_closed_F",[-7.58594,5.1582,0],270],
        ["Land_CampingTable_small_F",[-1.69531,9.4082,0.00564981],269.751],
        ["Land_CampingChair_V1_F",[-2.19727,9.45703,0.00320816],255],
        ["Land_HBarrier_5_F",[8.05469,2.85156,0],0],
        ["Land_CampingChair_V1_F",[-6.07422,9.28516,0.00308919],74.9811],
        ["Land_d_Stone_HouseBig_V1_F",[3.06641,10.3906,0],0],
        ["Land_Razorwire_F",[10.0742,1.29688,-2.86102e-06],0],
        ["CamoNet_INDP_open_F",[-5.21094,10.5098,0],270],
        ["Land_CampingChair_V1_F",[-6.82422,10.4102,0.00309134],29.981],
        ["Land_MapBoard_F",[-9.20898,8.40234,-0.00223255],239.956],
        ["Land_Sacks_heap_F",[12.0527,4.23047,0],0],
        ["Land_Tyres_F",[8.63086,9.46289,0.00659728],255],
        ["Land_CampingChair_V1_F",[-7.82422,10.6602,0.00308943],14.9734],
        ["Land_Sacks_heap_F",[12.3027,5.48047,0],90],
        ["Land_HBarrier_5_F",[13.7988,7.22852,0],90],
        ["Land_Pallets_stack_F",[-12.0742,8.41016,-2.38419e-07],225.001],
        ["Land_CncBarrierMedium_F",[-1.70898,15.7695,0],210],
        ["Land_Razorwire_F",[15.2363,3.25195,-2.86102e-06],270],
        ["Land_HBarrier_1_F",[13.7949,8.35547,0],90],
        ["Land_CratesWooden_F",[2.05078,16.2852,0],180],
        ["Land_PaperBox_closed_F",[-5.96094,15.4141,0],300],
        ["Land_BagFence_Long_F",[-14.5586,7.91406,-0.000999928],90],
        ["Land_CncBarrierMedium_F",[-3.57422,16.2676,0],180],
        ["Land_CncBarrierMedium_F",[-5.43945,16.8008,0],30],
        ["Land_CampingChair_V1_F",[14.0137,10.8535,0.00308919],239.985],
        ["Land_PaperBox_open_empty_F",[-8.07422,15.9102,0],255],
        ["Land_BagFence_Long_F",[-14.5898,10.7813,-0.000999928],270],
        ["Land_Sacks_heap_F",[-15.4492,9.66016,0],270],
        ["Land_CampingChair_V1_F",[14.1016,11.9922,0.00308895],270.025],
        ["Land_Pallets_stack_F",[17.4277,6.35547,-4.76837e-07],345.001],
        ["Land_CampingTable_F",[14.707,11.6289,-0.00259161],257.543],
        ["Land_CncBarrierMedium_F",[-7.19922,17.3926,0],180],
        ["Land_PaperBox_open_empty_F",[17.5527,8.10547,0],90],
        ["Land_CncBarrierMedium_F",[-10.6875,16.1484,0],135],
        ["Land_CncBarrierMedium_F",[-9.07031,17.1426,0],165],
        ["Land_BagFence_Long_F",[16.3184,14.8594,-0.000999928],90],
        ["Land_BagFence_Long_F",[15.0566,16.4648,-0.000999928],180],
        ["Snake_random_F",[3.35938,35.6367,0.0083878],306.214]
    ],

    // Fourth emplacement
    [
        ["Land_CampingChair_V1_F",[-4.68555,1.16797,0.00308943],74.9849],
        ["Land_ToiletBox_F",[-2.77148,3.98828,-0.000999451],15.0033],
        ["Land_BagFence_Corner_F",[2.56445,3.81836,-0.000999928],181.351],
        ["Land_CampingChair_V1_F",[-5.1875,0.0957031,0.00321722],105.998],
        ["Land_HBarrier_3_F",[-1.04492,6.22656,0],90],
        ["Land_CampingTable_F",[-5.58398,0.580078,-0.00259066],98.9803],
        ["Land_BagFence_Short_F",[4.31445,3.76172,-0.0010004],1.35146],
        ["Land_BagFence_Long_F",[2.63672,5.80469,-0.000999928],91.3515],
        ["RoadCone_F",[3.19922,6.01953,-3.33786e-06],91.3466],
        ["Land_Cargo_House_V1_F",[-7.75,2.23828,0],270],
        ["Land_BagFence_Long_F",[6.32813,3.69727,-0.000999928],181.351],
        ["Land_HBarrier_5_F",[-6.76953,6.10938,0],0],
        ["RoadCone_F",[3.77344,7.08203,-0.00606847],5.8856],
        ["RoadBarrier_F",[4.14258,7.11914,-0.00399971],121.355],
        ["Land_Garbage_square5_F",[-8.35938,-2.68945,0],0],
        ["RoadCone_F",[4.04688,7.89258,1.90735e-06],166.361],
        ["Land_HBarrier_3_F",[2.94727,9.91016,0],91.3515],
        ["Land_WeldingTrolley_01_F",[4.4668,8.77148,1.66893e-06],226.351],
        ["Land_BagFence_Round_F",[9.20898,3.72656,-0.00130081],331.351],
        ["Land_HBarrier_3_F",[-2.29492,-8.64844,0],90],
        ["Land_Cargo_House_V1_F",[-7.875,-8.13672,0],270],
        ["Land_Tyres_F",[-10.7324,-1.75977,0.00659728],315],
        ["Land_GasTank_02_F",[4.61523,9.76758,3.57628e-05],91.3464],
        ["Land_GasTank_02_F",[5.09375,9.74414,3.62396e-05],331.35],
        ["Land_PaperBox_open_empty_F",[-10.2715,-4.13672,0],0],
        ["Land_CampingChair_V1_F",[-5.26367,-9.84766,0.00318909],75.074],
        ["Land_CampingTable_small_F",[-5.77148,-9.88672,0.0034256],89.8781],
        ["Land_Garbage_square5_F",[8.49219,7.75195,0],91.3515],
        ["Land_HBarrier_3_F",[2.75781,11.0273,0],1.35146],
        ["Land_BagFence_Long_F",[10.0215,6.13086,-0.000999928],91.3515],
        ["Land_HBarrier_5_F",[-12.3945,6.10938,0],0],
        ["Land_BarrelEmpty_F",[9.53906,7.51367,2.14577e-06],91.349],
        ["Land_HBarrier_5_F",[-12.1426,0.365234,0],270],
        ["Land_HBarrier_5_F",[-12.1426,-5.25977,0],270],
        ["Land_HBarrier_5_F",[-2.14844,-12.1328,0],180],
        ["Land_Garbage_square5_F",[6.82227,11.166,0],91.3515],
        ["Land_Workbench_01_F",[7.33594,12.1445,3.8147e-06],351.731],
        ["Land_HBarrier_3_F",[4.79883,12.2637,0],271.351],
        ["Land_Saw_F",[6.16602,12.9688,-0.00273991],136.324],
        ["Land_Wrench_F",[6.87891,13.0684,-2.38419e-07],191.31],
        ["Land_HBarrier_5_F",[-12.1426,-10.8848,0],270],
        ["CamoNet_INDP_F",[10.4707,10.9414,0],1.35146],
        ["Land_Screwdriver_V1_F",[8.64648,12.7246,-0.00538445],133.488],
        ["Land_EngineCrane_01_F",[10.2578,11.498,0],331.352],
        ["Land_Screwdriver_V2_F",[8.77148,12.7402,-0.00679684],16.7478],
        ["Land_HBarrier_5_F",[-7.77344,-12.1328,0],180],
        ["Land_HBarrier_3_F",[6.08594,14.3242,0],1.35146],
        ["Land_CarBattery_02_F",[11.2871,12.7246,-7.15256e-07],196.332],
        ["Land_ShelvesWooden_F",[12.041,12.582,-0.00106454],91.3417],
        ["Land_CanisterFuel_F",[12.9082,12.5625,2.02656e-05],196.268],
        ["Land_PlasticCase_01_large_F",[14.3203,11.0098,-9.53674e-07],339.334],
        ["Land_HBarrier_Big_F",[16.1191,9.01953,0],91.3515],
        ["Land_Tyre_F",[14.4883,12.6328,-0.00430322],91.3517],
        ["Land_HBarrier_Big_F",[12.9102,14.1035,0],1.35146],
        ["Snake_random_F",[-23.123,-1.625,0],71.9837],
        ["Snake_random_F",[33.6641,-17.3047,0.0083878],207.457],
        ["Snake_random_F",[-1.9668,45.0781,0.0083878],173.042]
    ],

    // Fifth emplacement
    [
        ["Land_MetalBarrel_F",[0.607422,2.12695,1.43051e-06],300.008],
        ["Land_MetalBarrel_F",[-0.0585938,2.22266,1.43051e-06],75.0092],
        ["Land_IndFnc_Pole_F",[-0.591797,-3.27734,0],270],
        ["Land_PaperBox_closed_F",[-0.570313,3.3457,0],270],
        ["Land_PaperBox_closed_F",[1.19336,3.33594,0],180],
        ["Land_BarrelSand_F",[2.69141,2.97266,1.90735e-06],0.000494253],
        ["Land_Net_Fence_Gate_F",[-2.68359,-3.15234,0],180],
        ["Land_PaperBox_open_full_F",[-2.44336,3.34766,0],90],
        ["Land_IndFnc_3_F",[-0.556641,-4.77539,0],270],
        ["Land_WoodenTable_small_F",[-3.43359,-3.52734,0],180.004],
        ["Land_PortableLight_double_F",[3.22461,3.8457,0],15],
        ["Land_HBarrier_5_F",[1.68945,4.97656,0],180],
        ["Land_ChairWood_F",[-4.08594,-3.41992,1.19209e-05],301.364],
        ["Land_BagFence_Long_F",[3.5625,5.11328,-0.000999928],0],
        ["Land_BagFence_Long_F",[-4.6875,5.11328,-0.000999928],0],
        ["Land_IndFnc_3_F",[5.31445,-4.6543,0],90],
        ["Land_IndFnc_3_F",[-0.556641,-7.77539,0],270],
        ["Land_BagFence_Long_F",[-7.82422,1.59375,-0.000999928],270],
        ["Land_CratesWooden_F",[-4.43359,-6.77734,0],255],
        ["Land_HBarrier_5_F",[-7.9375,-0.279297,0],90],
        ["Land_BagFence_Long_F",[8.55078,1.84375,-0.000999928],270],
        ["Land_HBarrier_5_F",[8.44531,-4.65039,0],270],
        ["CamoNet_INDP_big_F",[-0.511719,8.68164,0],21.1121],
        ["Land_Cargo10_military_green_F",[-3.87891,8.3457,1.90735e-06],125.452],
        ["Land_IndFnc_3_F",[5.31445,-7.6543,0],90],
        ["Land_Sacks_heap_F",[-5.55859,-7.52734,0],255],
        ["Land_CratesWooden_F",[-4.55859,-8.90234,0],0],
        ["Land_Cargo20_grey_F",[0.310547,10.1621,-4.76837e-07],57.9907],
        ["Land_IndFnc_Corner_F",[-0.556641,-10.6973,0],270],
        ["Land_HBarrier_5_F",[-7.9375,-5.7793,0],90],
        ["Land_HBarrier_5_F",[8.44531,-10.1504,0],270],
        ["Land_IndFnc_3_F",[5.31445,-10.6543,0],90],
        ["Land_IndFnc_3_F",[0.939453,-12.1504,0],180],
        ["Land_IndFnc_Corner_F",[3.86133,-12.1504,0],180],
        ["Land_LampShabby_F",[2.42383,-12.6641,0],0],
        ["Land_BagFence_Long_F",[-7.79297,-12.2734,-0.000999928],90],
        ["Land_BagFence_Long_F",[8.42578,-12.1563,-0.000999928],270],
        ["Land_HBarrier_5_F",[1.81445,-15.3984,0],180],
        ["Land_BagFence_Short_F",[3.05664,-15.2754,-0.0010004],0],
        ["Land_BagFence_Long_F",[-4.6875,-15.3867,-0.000999928],0],
        ["Land_BagFence_Long_F",[5.3125,-15.2617,-0.000999928],0],
        ["Land_BagFence_Round_F",[-7.43359,-14.9824,-0.00130081],45],
        ["Land_BagFence_Round_F",[8.02148,-14.9004,-0.00130081],315]
    ],

    // Sixth emplacement
    [
        ["Land_BarrelSand_F",[1.26953,-2.05859,2.14577e-06],359.981],
        ["Land_Garbage_square5_F",[1.55664,2.01367,0],0],
        ["Land_MetalWire_F",[1.79102,-2.12891,0],300],
        ["Land_CratesWooden_F",[1.51953,-3.05859,0],0],
        ["RoadBarrier_F",[-2.96875,-3.06445,0.00177598],29.9063],
        ["Land_FoodContainer_01_F",[-4.23047,-1.80859,7.15256e-07],209.968],
        ["Land_FireExtinguisher_F",[3.01953,-3.59961,2.02656e-05],224.975],
        ["Land_FoodContainer_01_F",[-4.13086,-2.32617,-0.000893593],359.901],
        ["I_MRAP_03_hmg_F",[-2.08984,3.84375,-0.000402451],14.9997],
        ["RoadBarrier_F",[4.37891,-2.4375,-0.00399685],191.937],
        ["I_Truck_02_fuel_F",[3.46875,3.62305,-0.00551367],345.029],
        ["Land_CncBarrierMedium_F",[-3.9668,-3.79688,0],45],
        ["Land_CncBarrierMedium_F",[-5.21289,-2.05469,0],75],
        ["Land_CncBarrierMedium4_F",[-0.833984,-5.63477,0],180],
        ["Land_CratesWooden_F",[-5.33008,3.9707,0],285],
        ["Land_CarBattery_02_F",[6.51953,3.44141,-4.76837e-07],314.936],
        ["Land_CncBarrierMedium_F",[6.2832,-4.07227,0],135],
        ["Box_IND_AmmoVeh_F",[7.1875,2.16992,0.0324323],345.029],
        ["Land_DuctTape_F",[-6.22266,4.38086,-2.38419e-07],285.008],
        ["Land_Portable_generator_F",[-4.95313,5.84766,-0.000816107],315.008],
        ["Land_ButaneTorch_F",[-6.21875,4.59766,2.36034e-05],29.9913],
        ["Land_TinContainer_F",[-5.95508,5.01563,0.00113988],75.4796],
        ["Land_ButaneCanister_F",[-6.33008,4.59766,1.40667e-05],90.1077],
        ["Land_ButaneCanister_F",[-6.26172,4.74219,1.33514e-05],285.194],
        ["FlexibleTank_01_forest_F",[7.00195,3.92773,-0.00101924],357.708],
        ["Land_PowerGenerator_F",[-3.25391,-7.70313,0],180],
        ["Land_CncBarrierMedium_F",[8.75391,-0.304688,0],285],
        ["Land_TTowerSmall_1_F",[-2.10938,-7.05078,0],0],
        ["Land_CncBarrierMedium_F",[8.75391,2.18555,0],255],
        ["Land_CncBarrierMedium_F",[8.00391,4.18164,0],240],
        ["Land_CncBarrierMedium_F",[6.75391,6.43164,0],240],
        ["Land_CncBarrierMedium4_F",[-4.71484,-9.21875,0],90],
        ["Land_Research_house_V1_F",[1.24609,-9.83398,0],0],
        ["Land_CncBarrierMedium_F",[8.56836,-7.12109,0],345],
        ["Land_Pallets_stack_F",[-0.607422,-11.9922,-2.38419e-07],176.477],
        ["Land_LampShabby_F",[5.28516,-10.8555,0],180],
        ["Land_Cargo20_grey_F",[12.9766,-3.95703,-9.53674e-07],57.9908],
        ["Land_CanisterFuel_F",[6.42969,-12.752,2.12193e-05],224.886],
        ["Land_CncBarrierMedium_F",[-4.2168,-13.8594,0],60],
        ["Land_CanisterFuel_F",[6.24414,-13.1348,2.12193e-05],254.922],
        ["Land_Pallets_F",[7.24219,-12.8438,0],134.158],
        ["Land_CncBarrierMedium_F",[-3.46484,-15.6133,0],75],
        ["Land_CncBarrierMedium4_F",[13.1543,-9.26953,0],210],
        ["Land_Research_house_V1_F",[10.5059,-12.5195,0],30],
        ["Land_Cargo10_military_green_F",[16.7207,-1.71875,4.76837e-07],126.115],
        ["Land_CncBarrierMedium_F",[-2.7168,-17.3594,0],60],
        ["Land_PaperBox_closed_F",[1.0293,-17.9922,0],97.181],
        ["Land_PaperBox_closed_F",[3.1543,-17.9883,0],81.088],
        ["Land_PaperBox_open_empty_F",[5.01758,-17.9922,0],357.49],
        ["Land_CncBarrierMedium_F",[-1.5957,-18.8555,0],45],
        ["Land_CncBarrierMedium4_F",[2.86914,-19.5996,0],0],
        ["Land_CncBarrierMedium4_F",[13.9902,-14.2539,0],300],
        ["Land_CncShelter_F",[7.77734,-19.4961,0],0],
        ["Land_PaperBox_closed_F",[3.14063,-21.1055,0],2.88349],
        ["Land_MetalBarrel_F",[4.58008,-20.9395,1.66893e-06],324.507],
        ["Land_CncBarrierMedium_F",[11.3809,-18.2305,0],315],
        ["Land_CncBarrierMedium_F",[9.76367,-19.2266,0],345],
        ["Snake_random_F",[-6.49219,-21.752,0],202.148]
    ],
	
	[
 // First emplacement
        ["Land_PaperBox_open_empty_F",[-2.55273,-3.07031,0],135],
        ["Land_BarrelTrash_grey_F",[-1.67773,-4.07031,1.90735e-06],0.0038035],
        ["Land_BagFence_Short_F",[-3.67188,-3.45313,-0.0010004],225],
        ["Land_BagFence_Short_F",[-2.29492,-4.57617,-0.0010004],210],
        ["Land_BagFence_Short_F",[-0.792969,-5.19922,-0.0010004],195],
        ["Land_BagFence_End_F",[-5.0293,-2.39258,-0.00100017],210],
        ["Land_BagFence_End_F",[0.873047,-5.19727,-0.00100017],345],
        ["Land_HelipadCircle_F",[1.57227,5.55469,0],0],
        ["Land_BagFence_Short_F",[4.0625,-5.19727,-0.0010004],345],
        ["Land_BagFence_Short_F",[5.5625,-4.57422,-0.0010004],330],
        ["Land_BagFence_Short_F",[-7.43359,0.0625,-0.0010004],45],
        ["Land_BagFence_Short_F",[6.93945,-3.57617,-0.0010004],315],
        ["Land_CncBarrier_F",[5.82031,-5.70313,0],0],
        ["Land_BagFence_End_F",[8.38672,-2.96875,-0.00100017],0],
        ["Land_BagFence_Short_F",[-8.43164,1.43945,-0.0010004],60],
        ["Land_CncBarrier_F",[7.19336,-5.32813,0],15],
        ["Land_BagFence_Short_F",[-9.05469,2.93945,-0.0010004],75],
        ["Land_BagFence_End_F",[-8.75,4.53125,-0.00100017],300],
        ["Land_PalletTrolley_01_khaki_F",[10.3125,1.54688,1.43051e-06],314.165],
        ["Land_BagFence_Short_F",[10.4551,0.0605469,-0.0010004],135],
        ["Land_Sacks_heap_F",[-1.91992,-10.2793,0],195],
        ["Land_MetalBarrel_F",[-8.67773,6.67969,1.66893e-06],315],
        ["Land_PaperBox_closed_F",[-7.91406,7.67969,0],105],
        ["Land_Pallets_stack_F",[10.8359,4.11133,0.00586319],305.784],
        ["Land_BagFence_End_F",[-9.96875,6.29688,-0.00100017],135],
        ["Land_BagFence_Short_F",[11.5781,1.4375,-0.0010004],120],
        ["Land_HBarrier_5_F",[2.32813,-11.6504,0],180],
        ["Land_Pallet_MilBoxes_F",[-6.77539,9.72266,0],135],
        ["Land_BagFence_Short_F",[-9.05664,7.79492,-0.0010004],285],
        ["Land_BagFence_End_F",[3.75977,-11.4453,-0.00100017],150],
        ["Land_BagFence_Long_F",[5.88867,-11.0742,-0.000999928],180],
        ["Land_BagFence_Short_F",[12.2012,2.93945,-0.0010004],105],
        ["Land_BagFence_Short_F",[-8.43359,9.29688,-0.0010004],300],
        ["Land_BagFence_Short_F",[-7.31055,10.6738,-0.0010004],315],
        ["Land_BagFence_End_F",[-5.08594,-11.584,-0.00100017],240],
        ["Land_BagFence_End_F",[12.875,4.53125,-0.00100017],300],
        ["Land_WaterBarrel_F",[0.705078,-13.2793,0],359.999],
        ["Land_Garbage_square5_F",[-1.11719,-13.2422,0],270],
        ["Land_Pallets_stack_F",[-0.919922,-13.5293,-0.0010004],149.999],
        ["Land_HelicopterWheels_01_assembled_F",[10.5723,9.05469,-0.00152946],150.004],
        ["Land_HelicopterWheels_01_disassembled_F",[10.5723,9.42969,-0.000773907],44.8743],
        ["Land_MetalBarrel_F",[-3.0918,13.9004,1.43051e-06],30.0071],
        ["Land_BagFence_End_F",[12.9551,6.39063,-0.00100017],45],
        ["Land_BagFence_Round_F",[8.63477,-11.4785,-0.00130081],225],
        ["Land_BagFence_Long_F",[-4.71484,-13.7129,-0.000999928],270],
        ["Land_MetalBarrel_F",[-2.55273,14.3047,1.43051e-06],254.993],
        ["Land_BagFence_Short_F",[12.1992,7.91992,-0.0010004],255],
        ["Land_BagFence_End_F",[-5.22852,13.6816,-0.00100017],165],
        ["Land_CargoBox_V1_F",[3.95508,-14.0293,0.0305393],179.995],
        ["CargoNet_01_barrels_F",[-1.17773,14.8047,-2.38419e-07],165.003],
        ["Land_BagFence_Short_F",[11.5762,9.41992,-0.0010004],240],
        ["Land_BagFence_Short_F",[-3.91992,14.4355,-0.0010004],135],
        ["Land_BagFence_Short_F",[10.5781,10.7969,-0.0010004],225],
        ["Land_HBarrier_5_F",[2.20117,-12.9063,0],90],
        ["Land_MetalBarrel_F",[5.20508,-14.5293,1.43051e-06],359.979],
        ["CamoNet_INDP_open_F",[2.30469,-15.8926,0],0],
        ["Land_BagFence_Short_F",[-2.54297,15.4336,-0.0010004],150],
        ["Land_BagFence_End_F",[8.23633,13.5117,-0.00100017],15],
        ["Land_BagFence_Short_F",[6.81641,14.3125,-0.0010004],45],
        ["Land_BagFence_Short_F",[-1.04297,16.0566,-0.0010004],165],
        ["Land_PaperBox_closed_F",[3.95703,-15.666,0],180],
        ["Land_BagFence_Short_F",[5.43945,15.4355,-0.0010004],30],
        ["Land_BagFence_End_F",[0.572266,16.6914,-0.00100017],330],
        ["Land_Garbage_square5_F",[5.38281,-15.4922,0],270],
        ["Land_BagFence_Short_F",[3.9375,16.0586,-0.0010004],15],
        ["Land_BagFence_Long_F",[8.99414,-14.0625,-0.000999928],270],
        ["Land_BagFence_Long_F",[-4.6543,-16.6504,-0.000999928],90],
        ["Land_Sacks_heap_F",[3.83008,-17.2793,0],195],
        ["Land_BagFence_Long_F",[9.05469,-17,-0.000999928],90],
        ["Land_BagFence_Round_F",[-4.29492,-19.2344,-0.00130081],45],
        ["Land_BagFence_End_F",[0.580078,-19.2676,-0.00100017],330],
        ["Land_BagFence_Long_F",[-1.54883,-19.6387,-0.000999928],0],
        ["Land_BagFence_End_F",[9.42578,-19.1289,-0.00100017],60],
        ["Snake_random_F",[3.11328,23.0391,0.0083878],112.585],
        ["Snake_random_F",[-11.6895,-37.1699,0.0083878],47.8806]
    ],
    [
        // Second emplacement
        ["Land_MapBoard_F",[-0.761719,-2.26172,-0.00223398],55.4568],
        ["Land_PaperBox_closed_F",[-2.63477,0.84375,0],85.4484],
        ["Land_Pallets_stack_F",[2.09766,-2.04297,-2.38419e-07],40.4494],
        ["Land_PaperBox_closed_F",[-4.26953,0.722656,0],355.448],
        ["Land_BagFence_Long_F",[4.5332,-1.35156,-0.000999928],265.448],
        ["Land_CampingChair_V1_F",[-1.96094,-4.62305,0.00308895],190.421],
        ["Land_CampingChair_V1_F",[-3.81445,-3.39063,0.00308919],250.431],
        ["Land_CampingChair_V1_F",[-2.97656,-4.45313,0.00308919],205.425],
        ["Land_BagFence_Long_F",[-5.10742,1.88281,-0.000999928],175.448],
        ["CamoNet_INDP_open_F",[-4.57813,-4.67773,0],85.4484],
        ["Land_Sacks_heap_F",[5.56055,-3.01953,0],85.4484],
        ["Land_BagFence_Long_F",[4.79297,-4.20508,-0.000999928],85.4484],
        ["Snake_random_F",[-2.39063,8.40625,0.0083878],316.582],
        ["Land_PaperBox_open_empty_F",[-1.29492,-9.83594,0],70.4484],
        ["Land_CncBarrierMedium_F",[1.32813,-9.86523,0],310.448],
        ["Land_PaperBox_closed_F",[-3.44141,-9.50977,0],115.448],
        ["Land_PaperBox_01_small_closed_white_med_F",[-10.502,-2.76172,-7.15256e-07],75.0112],
        ["Land_PaperBox_01_open_boxes_F",[-10.752,-1.51172,0.000930548],0.000499928],
        ["Land_CncBarrierMedium_F",[-0.205078,-10.9844,0],340.448],
        ["Land_PortableLight_single_F",[-11.1973,-0.0371094,0],30],
        ["Land_PaperBox_01_small_closed_white_med_F",[-11.127,-2.76172,-4.76837e-07],270.015],
        ["Land_CncBarrierMedium_F",[-3.84961,-10.9316,0],205.448],
        ["Land_CncBarrierMedium_F",[-2.05078,-11.3828,0],355.448],
        ["Land_CncBarrierMedium_F",[-5.75195,-10.5488,0],355.448],
        ["MapBoard_altis_F",[-10.9902,-5.26172,-0.00222778],90.0174],
        ["Land_CncBarrierMedium_F",[-7.65234,-10.2012,0],25.4484],
        ["Land_CampingChair_V2_white_F",[-12.127,-4.13672,-1.43051e-06],0.00274109],
        ["Land_CampingTable_white_F",[-12.627,-4.88672,-0.00259185],359.999],
        ["Land_CampingChair_V2_white_F",[-13.127,-4.01172,-1.66893e-06],15.0012],
        ["Land_PaperBox_01_open_water_F",[-10.5098,-8.85547,0.000930071],359.215],
        ["Land_CampingTable_white_F",[-12.627,-5.76172,-0.00259185],179.999],
        ["Land_CampingChair_V2_white_F",[-12.4082,-6.61523,-1.66893e-06],194.974],
        ["Land_MedicalTent_01_floor_light_F",[-13.6406,-5.18945,0],359.817],
        ["Land_MedicalTent_01_white_generic_outer_F",[-13.627,-5.13672,-1.23711],0],
        ["Land_CampingChair_V2_white_F",[-14.127,-4.01172,7.62939e-06],0.0252407],
        ["Land_CampingChair_V2_white_F",[-13.2598,-6.70703,9.53674e-07],165.005],
        ["Land_CampingTable_white_F",[-14.627,-4.88672,-0.00259185],359.999],
        ["Land_CampingChair_V2_white_F",[-14.127,-6.51172,5.24521e-06],209.999],
        ["Land_CampingTable_white_F",[-14.627,-5.76172,-0.00259113],180],
        ["Land_CampingChair_V2_white_F",[-15.252,-4.01172,1.19209e-06],330.022],
        ["Land_PlasticNetFence_01_roll_F",[-16.3047,-1.79688,-0.0208256],329.836],
        ["Land_CampingChair_V2_white_F",[-15.0996,-6.48438,-1.19209e-06],180.002],
        ["Land_PlasticNetFence_01_roll_F",[-16.5781,-1.33203,-0.0208254],314.833],
        ["Land_Stretcher_01_folded_F",[-17.127,-1.13672,-2.38419e-07],44.982],
        ["Land_FireExtinguisher_F",[-17.3516,-0.232422,4.24385e-05],313.001],
        ["Land_FoodContainer_01_White_F",[-17.252,-2.13672,7.15256e-07],359.967],
        ["Land_Stretcher_01_folded_F",[-17.502,-2.51172,-2.38419e-07],330.001],
        ["Land_FireExtinguisher_F",[-17.7813,-1.28906,2.74181e-05],66.1109],
        ["Land_FoodContainer_01_White_F",[-17.1914,-6.61328,4.76837e-07],155.64],
        ["Land_FoodContainer_01_White_F",[-17.1777,-7.04688,4.76837e-07],154.401],
        ["Land_PaperBox_01_small_open_brown_IDAP_F",[-16.25,-9.00977,0],60.2858],
        ["Land_FoodContainer_01_White_F",[-17.623,-6.61328,4.76837e-07],152.211],
        ["Land_EmergencyBlanket_01_stack_F",[-17.3438,-7.60352,-7.15256e-07],356.005],
        ["Land_FoodContainer_01_White_F",[-17.6074,-7.06641,4.76837e-07],167.777],
        ["Land_EmergencyBlanket_01_stack_F",[-17.377,-8.13672,-7.15256e-07],174.392],
        ["Land_FirstAidKit_01_closed_F",[-16.877,-9.26172,-2.14577e-06],234.701],
        ["Land_EmergencyBlanket_02_stack_F",[-17.3926,-8.66016,0],86.7648],
        ["Land_GasTank_01_blue_F",[-17.002,-9.63672,8.58307e-06],147.064],
        ["Land_GasTank_01_blue_F",[-17.373,-9.44922,8.58307e-06],158.099],
        ["Snake_random_F",[-15.7988,16.0879,0.0083878],68.3242],
        ["Snake_random_F",[-36.3594,28.0977,0.0083878],353.114]
    ],
    [
        // Third emplacement
        ["SpinalBoard_01_orange_F",[4.46289,-0.591797,0.0160594],318.903],
        ["Land_ChairWood_F",[0.126953,4.74805,7.15256e-07],255.14],
        ["Land_WoodenTable_small_F",[0.990234,5.03516,0],180.006],
        ["Land_FireExtinguisher_F",[-5.08984,1.28906,2.74181e-05],17.3062],
        ["Land_WoodenTable_large_F",[4.51172,2.88086,-9.53674e-07],207.25],
        ["PressureHose_01_Roll_F",[4.61914,-2.61523,0.0231397],210],
        ["Land_FireExtinguisher_F",[-5.17383,1.70313,4.36306e-05],152.3],
        ["Land_Sleeping_bag_blue_folded_F",[-5.84766,2.87109,-0.00136685],270.309],
        ["Land_Basket_F",[0.982422,6.45898,9.53674e-07],180.145],
        ["Land_Stretcher_01_F",[-6.28711,2.17773,0],353.145],
        ["Land_Can_V3_F",[-6.66016,1.54297,3.09944e-06],194.504],
        ["Land_Can_V3_F",[-6.67969,1.63867,1.09673e-05],343.451],
        ["Land_Can_V3_F",[-6.7168,1.58398,3.57628e-06],319.743],
        ["Land_PlasticCase_01_small_F",[-6.38672,3.51758,0],82.6424],
        ["Land_Garbage_square5_F",[3.99023,-6.98242,0],270.343],
        ["Land_WoodenTable_large_F",[5.86719,5.77148,-2.38419e-07],347.096],
        ["Land_CampingChair_V2_F",[6.62695,5.44922,-1.43051e-06],90.1469],
        ["Land_Stretcher_01_F",[-8.44336,2.03125,2.38419e-07],353.145],
        ["Land_PlasticCase_01_small_gray_F",[-6.79883,5.73242,-2.38419e-07],262.643],
        ["Land_Sleeping_bag_brown_folded_F",[-8.62109,3.21484,0],346.546],
        ["Land_WoodenTable_large_F",[3.49805,8.65234,-2.38419e-07],120.008],
        ["Land_CratesShabby_F",[5.84766,-7.4707,0],345.343],
        ["Land_Ground_sheet_folded_F",[-7.0918,6.47656,2.21729e-05],266.107],
        ["Land_AirConditioner_02_F",[-9.45898,-1.76172,0],172.642],
        ["Land_Pillow_grey_F",[-7.38086,6.37695,-4.29153e-06],52.6387],
        ["Land_Stretcher_01_F",[-6.86133,7.05664,0],352.642],
        ["Land_CampingChair_V2_F",[3.48242,9.37305,4.52995e-06],30.1421],
        ["Land_CampingChair_V2_F",[4.36523,9.15039,-2.14577e-06],60.1451],
        ["Land_Sleeping_bag_blue_folded_F",[-7.46289,6.92188,-0.00109792],143.737],
        ["Land_GarbagePallet_F",[7.60352,-7.35938,0],120.343],
        ["Land_FieldToilet_F",[10.3262,-1.35547,0.0221806],104.995],
        ["Land_MedicalTent_01_floor_light_F",[-9.71875,4.25781,0],262.459],
        ["Land_Sleeping_bag_brown_folded_F",[-8.68945,6.19531,1.43051e-06],106.604],
        ["Land_MedicalTent_01_white_generic_open_F",[-9.75391,4.2168,0],262.642],
        ["Land_Stretcher_01_F",[-10.752,1.70508,9.53674e-07],353.145],
        ["Land_Stretcher_01_F",[-9.02344,6.65625,2.38419e-07],353.145],
        ["Land_Portable_generator_F",[-11.1406,-1.63086,-0.000809669],228.528],
        ["Land_PlasticCase_01_small_gray_F",[-10.8652,3.06445,-2.38419e-07],82.6438],
        ["Land_Ground_sheet_folded_F",[-11.2148,1.45508,8.10623e-06],356.145],
        ["Land_Pillow_grey_F",[-11.3125,1.74219,-4.29153e-06],142.638],
        ["Land_Stretcher_01_folded_F",[-9.8418,5.91797,-2.38419e-07],11.0376],
        ["Tire_Van_02_Transport_F",[5.82031,10.0215,-2.38419e-07],8.39303],
        ["Tire_Van_02_Transport_F",[6.75,9.72461,-2.38419e-07],263.393],
        ["Land_CanisterFuel_Red_F",[7.53711,9.18945,2.09808e-05],153.859],
        ["Land_PaperBox_01_small_closed_brown_food_F",[8.18945,8.86328,-7.15256e-07],222.456],
        ["Land_Stretcher_01_folded_F",[-10.1035,6.78125,-2.38419e-07],84.5224],
        ["Land_CanisterFuel_Red_F",[7.61328,9.5332,2.09808e-05],138.858],
        ["Land_PlasticBucket_01_closed_F",[6.49023,10.5977,1.43051e-06],147.449],
        ["Land_Ground_sheet_folded_yellow_F",[-10.418,7.36914,2.31266e-05],250.725],
        ["Land_PlasticCase_01_large_idap_F",[7.28711,10.5117,4.76837e-07],147.458],
        ["Land_Sleeping_bag_F",[-11.4863,6.70898,0],351.588],
        ["Land_Ground_sheet_folded_blue_F",[-10.6738,7.35547,2.28882e-05],81.3587],
        ["Land_Pallets_F",[11.6289,-3.82031,0],45.1448],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[8.79297,9.54492,-7.15256e-07],162.459],
        ["Land_PlasticBucket_01_closed_F",[6.53711,11.2207,1.43051e-06],63.8602],
        ["Land_Stretcher_01_F",[-13.0254,1.66797,2.38419e-07],354.815],
        ["Land_PaperBox_01_small_closed_brown_F",[8.45703,10.0723,-2.38419e-07],147.454],
        ["Land_Sleeping_bag_blue_folded_F",[-12.1914,5.23828,-0.0010972],97.0671],
        ["Land_Sleeping_bag_brown_folded_F",[-13.4453,0.814453,-0.00110054],268.688],
        ["Land_PlasticCase_01_large_idap_F",[7.91797,10.916,-9.53674e-07],147.456],
        ["Land_MetalCase_01_small_F",[7.06445,11.5566,-2.38419e-07],237.455],
        ["Land_Pillow_camouflage_F",[-11.584,7.14453,-0.024586],80.0117],
        ["Land_WaterBarrel_F",[-8.76758,10.6133,2.38419e-07],270.075],
        ["Land_Ground_sheet_khaki_F",[-12.6172,5.87891,0],176.31],
        ["Land_Stretcher_01_folded_F",[7.76367,11.8535,-2.38419e-07],292.323],
        ["Land_Pillow_F",[-12.6758,6.63867,-4.52995e-06],81.3273],
        ["Land_Camping_Light_F",[-13.1914,6.99023,-0.00121641],57.8452],
        ["Land_Tablet_01_F",[-13.3613,6.77539,-2.38419e-07],119.536],
        ["Land_Sleeping_bag_brown_F",[-13.9863,6.35938,0],351.588],
        ["C_IDAP_Van_02_transport_F",[11.0918,10.125,-0.0556121],147.456],
        ["Land_Pillow_grey_F",[-13.998,6.57422,-0.0269799],81.3254],
        ["Land_CampingChair_V2_F",[-11.1445,11.5879,-2.38419e-06],120.146],
        ["Land_CampingChair_V2_F",[-10.8809,12.5488,-2.38419e-06],135.131],
        ["Snake_random_F",[-22.084,-12.3594,0.0083878],188.256],
        ["Snake_random_F",[-26.6094,18.6953,0.0083878],345.023],
        ["Snake_random_F",[-10.291,-34.7773,0.0083878],151.26],
        ["Rabbit_F",[-44.8086,-15.6035,-0.00343108],263.54]
    ],
    [
        // Fourth emplacement
        ["Land_CanisterFuel_F",[2.40625,-5.50391,2.47955e-05],344.965],
        ["Land_Pallets_stack_F",[-5.12305,3.64844,0],248.573],
        ["Land_MetalWire_F",[2.15625,-6.25391,0],315],
        ["Land_ToolTrolley_02_F",[2.78125,-6.12891,-2.6226e-06],284.997],
        ["Land_Wrench_F",[2.58594,-6.60742,-2.38419e-07],59.9997],
        ["Land_Sacks_goods_F",[-4.91211,5.19336,0],8.57147],
        ["Land_PlasticBucket_01_open_F",[3.65625,-6.25391,1.43051e-06],179.997],
        ["Land_Rope_01_F",[3.28125,-6.62891,-2.38419e-07],135.004],
        ["Land_CratesShabby_F",[-6.00781,4.79883,0],338.572],
        ["Oil_Spill_F",[0.369141,-8.11719,0],180],
        ["Land_Sacks_heap_F",[-6.16211,6.17383,0],308.571],
        ["Land_cmp_Shed_F",[-8.11914,1.04297,0],248.572],
        ["C_Offroad_01_F",[-1.32617,-8.81055,-0.0319381],75.004],
        ["Land_MetalCase_01_small_F",[1.40625,-9.50391,-2.38419e-07],44.9981],
        ["Land_GarbagePallet_F",[4.16016,8.88672,0],58.5692],
        ["Land_Bucket_clean_F",[4.65625,-10.0039,7.15256e-07],179.955],
        ["Land_DuctTape_F",[3.9375,-10.4355,0],180.005],
        ["Land_Hammer_F",[4.27344,-10.373,-0.0139863],135.035],
        ["Land_Wrench_F",[3.90625,-10.7539,0],14.9992],
        ["Land_CanisterFuel_F",[5.03125,-10.5039,2.0504e-05],164.947],
        ["Land_CanisterPlastic_F",[4.53125,-11.0039,-2.38419e-07],149.996],
        ["Fridge_01_open_F",[4.16211,11.252,-0.000997305],178.567],
        ["C_Van_02_service_F",[9.3125,-7.62891,0.0862284],90.001],
        ["Land_GarbageBags_F",[12.4102,2.58398,0],298.569],
        ["Land_CratesWooden_F",[-12.6582,0.263672,0],248.572],
        ["Land_Garbage_square5_F",[9.56641,8.78125,0],298.569],
        ["Land_Wreck_Ural_F",[-10.6211,7.63867,0.00151062],68.5715],
        ["Land_GarbageBags_F",[12.8086,4.36133,0],298.569],
        ["Land_MetalBarrel_F",[-13.252,1.77539,9.05991e-06],38.5895],
        ["Land_CratesShabby_F",[5.0918,12.5605,0],28.5692],
        ["Land_MetalBarrel_F",[-13.8867,0.318359,1.43051e-06],8.57],
        ["Land_Metal_Shed_F",[9.33984,8.72852,0],28.5692],
        ["Land_JunkPile_F",[13.7363,4.1582,0],238.569],
        ["Land_GarbagePallet_F",[-14.2441,4.0332,0],338.571],
        ["Land_Tyre_F",[6.25391,13.5293,-0.00430274],298.583],
        ["Land_Garbage_square5_F",[7.91211,12.9707,0],298.569],
        ["Land_Metal_Shed_F",[-14.3027,-0.542969,0],248.572],
        ["Land_Basket_F",[12.3906,10.1992,9.53674e-07],268.568],
        ["Land_Bench_F",[13.6016,9.24414,0],298.569],
        ["Snake_random_F",[-5.01563,-17.8691,0.0083878],11.8312]
    ],
	[
	 ["Land_PlasticCase_01_small_gray_F", [5.10352,2.87695,-2.38419e-07], 331.679, 1, 0, [], "", "", true, false], 
        ["Land_Stethoscope_01_F", [4.60742,4.44336,0], 136.679, 1, 0, [], "", "", true, false], 
        ["Land_VitaminBottle_F", [4.46289,5.27148,2.28882e-05], 196.658, 1, 0, [], "", "", true, false], 
        ["BloodTrail_01_New_F", [6.8418,-1.29297,0], 31.6792, 1, 0, [], "", "", true, false], 
        ["Land_VitaminBottle_F", [4.61914,5.35352,2.28882e-05], 196.658, 1, 0, [], "", "", true, false], 
        ["Land_FirstAidKit_01_open_F", [5.02539,4.98438,-0.00489044], 256.69, 1, 0, [], "", "", true, false], 
        ["Land_Stretcher_01_olive_F", [6.35742,3.55859,2.38419e-07], 61.6792, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_cup_F", [-7.17773,-2.10352,-1.66893e-06], 351.517, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_napkin_F", [-7.19531,-2.33789,0], 164.551, 1, 0, [], "", "", true, false], 
        ["Land_Can_V3_F", [-7.20117,-2.55469,2.6226e-06], 169.564, 1, 0, [], "", "", true, false], 
        ["Land_Pallets_F", [-6.81641,1.94727,0], 306.551, 1, 0, [], "", "", true, false], 
        ["Land_Stretcher_01_olive_F", [5.5,5.93555,2.38419e-07], 256.679, 1, 0, [], "", "", true, false], 
        ["Land_Can_V2_F", [-7.75,-2.45703,3.09944e-06], 136.605, 1, 0, [], "", "", true, false], 
        ["MedicalGarbage_01_3x3_v1_F", [8.18359,1.29492,0], 1.67916, 1, 0, [], "", "", true, false], 
        ["Land_Stretcher_01_olive_F", [8.04102,1.29688,7.15256e-07], 46.6789, 1, 0, [], "", "", true, false], 
        ["BloodSplatter_01_Medium_New_F", [8.15234,0.789063,0], 181.679, 1, 0, [], "", "", true, false], 
        ["MedicalGarbage_01_3x3_v1_F", [5.53906,6.11914,0], 241.679, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [-7.94922,-2.93359,0], 118.551, 1, 0, [], "", "", true, false], 
        ["Land_TablePlastic_01_F", [-8.02539,-2.72852,-4.76837e-07], 126.55, 1, 0, [], "", "", true, false], 
        ["Leaflet_05_New_F", [-8.28516,-2.42578,-2.38419e-07], 47.5506, 1, 0, [], "", "", true, false], 
        ["Land_PainKillers_F", [8.8125,0.917969,-4.76837e-07], 31.6779, 1, 0, [], "", "", true, false], 
        ["BloodPool_01_Medium_New_F", [8.79102,1.15234,0], 61.6792, 1, 0, [], "", "", true, false], 
        ["Land_ChairPlastic_F", [-8.85742,-1.33398,2.38419e-06], 47.5445, 1, 0, [], "", "", true, false], 
        ["Land_ClothShelter_01_F", [-8.41406,-2.75,-0.887077], 306.551, 1, 0, [], "", "", true, false], 
        ["Land_Bandage_F", [9.06641,0.498047,-2.38419e-07], 331.668, 1, 0, [], "", "", true, false], 
        ["BloodSplatter_01_Small_New_F", [5.76563,7.04102,0], 61.6792, 1, 0, [], "", "", true, false], 
        ["Land_Bandage_F", [9.10742,-0.544922,-4.76837e-07], 61.6745, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_cup_F", [-8.62109,-3.21289,-2.38419e-06], 27.5031, 1, 0, [], "", "", true, false], 
        ["Land_Bandage_F", [9.19727,0.371094,-2.38419e-07], 211.678, 1, 0, [], "", "", true, false], 
        ["Land_Bandage_F", [9.19727,-0.392578,-2.38419e-07], 211.678, 1, 0, [], "", "", true, false], 
        ["Land_Bandage_F", [9.24414,-0.470703,-4.76837e-07], 346.678, 1, 0, [], "", "", true, false], 
        ["Land_PalletTrolley_01_khaki_F", [-8.24023,4.43945,3.8147e-06], 111.552, 1, 0, [], "", "", true, false], 
        ["MedicalGarbage_01_3x3_v1_F", [9.50586,-0.521484,0], 91.6792, 1, 0, [], "", "", true, false], 
        ["Land_FirstAidKit_01_closed_F", [9.51563,-0.658203,-9.53674e-07], 16.6753, 1, 0, [], "", "", true, false], 
        ["MedicalGarbage_01_1x1_v1_F", [9.55664,-0.232422,0], 61.6792, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [-8.91992,-3.61328,-4.76837e-07], 178.553, 1, 0, [], "", "", true, false], 
        ["Land_Pallet_F", [-9.23438,2.74609,0.00641608], 83.1969, 1, 0, [], "", "", true, false], 
        ["Land_ChairPlastic_F", [-9.72461,-2.71289,1.19209e-06], 354.544, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [-10.2168,0.304688,-4.76837e-07], 88.5501, 1, 0, [], "", "", true, false], 
        ["Land_Defibrillator_F", [9.98242,3.24219,-2.38419e-07], 241.683, 1, 0, [], "", "", true, false], 
        ["C_IDAP_Truck_02_transport_F", [-2.02539,-10.1348,-0.0154943], 90.0019, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [-10.5625,-0.373047,-4.76837e-07], 178.551, 1, 0, [], "", "", true, false], 
        ["Land_DisinfectantSpray_F", [10.2363,4.08203,-0.000858784], 151.282, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_open_brown_F", [11.3906,3.42773,0], 241.679, 1, 0, [], "", "", true, false], 
        ["CamoNet_INDP_F", [11.1289,5.19727,0], 61.6792, 1, 0, [], "", "", true, false], 
        ["Land_PlasticCase_01_small_gray_F", [10.0723,6.83203,-2.38419e-07], 331.679, 1, 0, [], "", "", true, false], 
        ["Land_PlasticCase_01_small_gray_F", [8.5918,9.16992,-2.38419e-07], 271.681, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_open_white_IDAP_F", [-11.8359,-4.41016,0], 149.551, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_brown_F", [11.6211,5.11719,-4.76837e-07], 121.676, 1, 0, [], "", "", true, false], 
        ["Land_PlasticCase_01_medium_gray_F", [7.86719,9.98242,-2.38419e-07], 301.679, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [-12.5703,-2.68555,2.38419e-07], 176.55, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [-12.5469,-3.25977,2.38419e-07], 178.55, 1, 0, [], "", "", true, false], 
        ["Land_IntravenStand_01_2bags_F", [12.7324,2.60547,3.29018e-05], 346.679, 1, 0, [], "", "", true, false], 
        ["MedicalGarbage_01_1x1_v3_F", [9.7168,9.02148,0], 61.6792, 1, 0, [], "", "", true, false], 
        ["Land_BarrelWater_F", [8.84375,10.0098,2.14577e-06], 16.6787, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_open_boxes_F", [12.7656,4.3125,0.000932217], 166.679, 1, 0, [], "", "", true, false], 
        ["Land_Stretcher_01_olive_F", [11.3242,7.51367,2.38419e-07], 61.6792, 1, 0, [], "", "", true, false], 
        ["Land_Stretcher_01_folded_olive_F", [9.66211,9.81445,-7.15256e-07], 76.6792, 1, 0, [], "", "", true, false], 
        ["MedicalGarbage_01_3x3_v1_F", [14.1406,1.28711,0], 241.679, 1, 0, [], "", "", true, false], 
        ["Land_Stretcher_01_olive_F", [14.2129,1.16406,4.76837e-07], 106.679, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_open_boxes_F", [-13.8965,-3.19141,0.000930548], 76.5511, 1, 0, [], "", "", true, false], 
        ["C_IDAP_Truck_02_transport_F", [-13.7305,4.16992,-0.0151258], 36.5518, 1, 0, [], "", "", true, false], 
        ["Land_Stretcher_01_folded_olive_F", [10.8398,9.73828,-2.38419e-07], 46.6793, 1, 0, [], "", "", true, false], 
        ["Land_PlasticBucket_01_closed_F", [-6.16016,-13.5078,1.45435e-05], 168.021, 1, 0, [], "", "", true, false], 
        ["Land_PlasticBucket_01_closed_F", [-6.66016,-13.6328,1.43051e-06], 258.003, 1, 0, [], "", "", true, false], 
        ["Land_PlasticBucket_01_closed_F", [-6.41016,-14.1328,1.43051e-06], 347.998, 1, 0, [], "", "", true, false], 
        ["Land_Pallets_F", [1.19141,-15.6934,0], 240, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [-15.7441,-3.38672,0], 171.551, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_open_water_F", [-8.03516,-14.0078,0.000931263], 74.9998, 1, 0, [], "", "", true, false], 
        ["Land_Pallet_F", [-1.76172,-16.0801,0.00788879], 183.043, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-7.03516,-14.8828,7.15256e-07], 29.9737, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-7.28516,-14.8828,9.53674e-07], 179.972, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_compressed_F", [-7.41016,-15.1328,-1.12057e-05], 74.9995, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_cap_F", [-7.22461,-15.4102,-0.000636101], 179.996, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_empty_F", [-7.30859,-15.4336,3.29018e-05], 179.907, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [-10.1465,-13.7578,0], 105, 1, 0, [], "", "", true, false], 
        ["Land_PalletTrolley_01_yellow_F", [-0.660156,-17.7402,1.43051e-06], 285.001, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-8.95117,-15.4746,1.43051e-06], 149.976, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-8.41016,-15.8828,3.24249e-05], 194.945, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-8.66016,-15.7578,1.43051e-06], 89.9688, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-8.17969,-16.0137,3.24249e-05], 194.945, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-9.91016,-15.0078,9.53674e-07], 179.972, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-8.3125,-16.1016,3.24249e-05], 194.945, 1, 0, [], "", "", true, false], 
        ["Land_LiquidDispenser_01_F", [-11.5352,-14.1328,1.19209e-06], 254.002, 1, 0, [], "", "", true, false], 
        ["Land_LiquidDispenser_01_F", [-11.0059,-14.8398,1.43051e-06], 209, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-6.81445,-17.7168,3.24249e-05], 164.874, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-7.08008,-17.7188,3.24249e-05], 164.874, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-6.88672,-17.8594,3.24249e-05], 164.874, 1, 0, [], "", "", true, false], 
        ["Land_ChairPlastic_F", [-3.36914,-18.8965,1.43051e-06], 70.9935, 1, 0, [], "", "", true, false], 
        ["Land_ChairPlastic_F", [-5.78516,-18.7578,1.19209e-06], 100.994, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_cup_F", [-2.91016,-20.0078,-1.90735e-06], 14.9454, 1, 0, [], "", "", true, false], 
        ["Land_ChairPlastic_F", [-7.41016,-18.8828,1.21593e-05], 47.9939, 1, 0, [], "", "", true, false], 
        ["Land_PlasticBucket_01_closed_F", [-2.16016,-20.2578,4.05312e-05], 167.991, 1, 0, [], "", "", true, false], 
        ["Leaflet_05_New_F", [-3.2793,-20.123,9.72748e-05], 70.9094, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_cup_F", [-3.41211,-20.1328,0.00107408], 50.8906, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-2.66016,-20.2578,2.38419e-06], 119.973, 1, 0, [], "", "", true, false], 
        ["Land_ClothShelter_02_F", [-5.00781,-19.7305,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_napkin_F", [-2.24219,-20.4668,0.000511408], 187.9, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-3.16016,-20.5078,1.66893e-06], 59.9731, 1, 0, [], "", "", true, false], 
        ["Land_TablePlastic_01_F", [-3.16016,-20.5078,-2.38419e-07], 339, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-3.53516,-20.5078,3.24249e-05], 164.874, 1, 0, [], "", "", true, false], 
        ["Leaflet_05_New_F", [-6.32227,-19.8691,0], 102, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-6.15234,-20.0449,3.24249e-05], 194.945, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-3.41016,-20.7578,3.24249e-05], 164.874, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-3.53516,-20.7578,3.24249e-05], 164.874, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-6.66016,-20.0078,3.24249e-05], 194.945, 1, 0, [], "", "", true, false], 
        ["Land_Can_V2_F", [-6.03516,-20.2578,2.6226e-06], 189.951, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-5.78516,-20.3828,3.24249e-05], 194.945, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_cup_F", [-5.41016,-20.5078,-2.14577e-06], 44.9556, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_cup_F", [-7.16016,-20.0078,-1.19209e-06], 80.9419, 1, 0, [], "", "", true, false], 
        ["Land_TablePlastic_01_F", [-6.41016,-20.2578,0], 9, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-6.78516,-20.2578,2.6226e-06], 149.974, 1, 0, [], "", "", true, false], 
        ["Land_Can_V3_F", [-6.16016,-20.5078,1.90735e-06], 222.977, 1, 0, [], "", "", true, false], 
        ["Land_Tableware_01_napkin_F", [-5.60352,-20.6914,0], 218, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-6.49414,-20.541,1.43051e-06], 89.9688, 1, 0, [], "", "", true, false], 
        ["Snake_random_F", [-25.0176,32.3555,0.0083878], 331.797, 1, 0, [], "", "", true, false]
    ],
    // Second emplacement
    [
        ["Land_Sacks_heap_F", [-4.02344,-7.33203,0], 195, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_End_F", [1.65625,-8.49805,-0.00100017], 150, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [3.78516,-8.12695,-0.000999928], 180, 1, 0, [], "", "", true, false], 
        ["Land_HBarrier_5_F", [0.224609,-8.70313,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_FoodSacks_01_small_brown_idap_F", [-0.841797,9.17969,0.0446303], 78.8699, 1, 0, [], "", "", true, false], 
        ["Land_FoodSack_01_full_brown_idap_F", [-0.00390625,9.24609,0], 326.764, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [1.39063,9.46094,-4.76837e-07], 5.19738, 1, 0, [], "", "", true, false], 
        ["Land_FoodSacks_01_large_brown_idap_F", [-2.04883,9.4082,-4.76837e-07], 85.2768, 1, 0, [], "", "", true, false], 
        ["Land_FoodSack_01_empty_brown_idap_F", [-1.0293,9.81641,0.00145364], 322.805, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [2.69922,9.66992,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_FoodSack_01_full_brown_idap_F", [-0.148438,10.0527,0], 279.391, 1, 0, [], "", "", true, false], 
        ["Land_FoodSacks_01_cargo_brown_idap_F", [-3.54883,9.4082,-9.53674e-07], 89.9972, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_closed_white_IDAP_F", [1.45117,10.0332,-4.76837e-07], 0.00580447, 1, 0, [], "", "", true, false], 
        ["Land_WaterBarrel_F", [-1.39844,-10.332,0], 359.999, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [6.53125,-8.53125,-0.00130081], 225, 1, 0, [], "", "", true, false], 
        ["Land_Garbage_square5_F", [-3.2207,-10.2949,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_Pallets_stack_F", [-3.02344,-10.582,-0.00100017], 149.999, 1, 0, [], "", "", true, false], 
        ["Land_CargoBox_V1_F", [1.85156,-11.082,0.0305417], 179.993, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_End_F", [-7.18945,-8.63672,-0.00100017], 240, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_open_boxes_F", [2.70117,11.6582,0.000930309], 160.266, 1, 0, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [3.10156,-11.582,1.43051e-06], 359.977, 1, 0.00988404, [], "", "", true, false], 
        ["Land_HBarrier_5_F", [0.0976563,-9.95898,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [-3.42578,11.7949,0], 0, 1, 0, [], "", "", true, false], 
        ["CamoNet_INDP_open_F", [0.201172,-12.9453,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [-6.81836,-10.7656,-0.000999928], 270, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [1.85352,-12.7188,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_Garbage_square5_F", [3.2793,-12.5449,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_MedicalTent_01_floor_light_F", [-0.3125,12.9805,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [6.89063,-11.1152,-0.000999928], 270, 1, 0, [], "", "", true, false], 
        ["Land_PartyTent_01_F", [-0.304688,13.0332,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_open_white_IDAP_F", [2.32617,13.0371,0], 22.5886, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_open_water_F", [-3.17383,13.5332,0.000930548], 284.999, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_01_small_open_white_IDAP_F", [3.07422,14.0313,0], 277.589, 1, 0, [], "", "", true, false], 
        ["Land_Sacks_heap_F", [1.72656,-14.332,0], 195, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-2.54883,14.4082,9.53674e-07], 359.935, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-2.88281,14.5,1.43051e-06], 329.953, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-3.17383,14.7832,1.43051e-06], 269.933, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [-6.75781,-13.7031,-0.000999928], 90, 1, 0, [], "", "", true, false], 
        ["C_IDAP_Offroad_01_F", [8.45313,12.9883,-0.0541725], 15.0038, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [6.95117,-14.0527,-0.000999928], 90, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_white_F", [0.767578,16.2207,-1.43051e-06], 185.982, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_white_F", [2.20117,16.1582,-2.14577e-06], 245.996, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_white_F", [-2.92383,16.1582,1.43051e-06], 186.01, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_End_F", [-1.52344,-16.3203,-0.00100017], 330, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [-3.65234,-16.6914,-0.000999928], 0, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-2.04883,17.0332,3.24249e-05], 14.91, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-2.17383,17.0332,3.19481e-05], 89.9912, 1, 0, [], "", "", true, false], 
        ["Land_FoodSacks_01_small_brown_idap_F", [-0.798828,17.1582,0], 83.8697, 1, 0, [], "", "", true, false], 
        ["Land_FoodSack_01_dmg_brown_idap_F", [1.20117,17.1582,0], 69.5978, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_End_F", [7.32227,-16.1816,-0.00100017], 60, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-2.42383,17.0332,3.24249e-05], 14.91, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [-6.39844,-16.2871,-0.00130081], 45, 1, 0, [], "", "", true, false], 
        ["Land_FoodSack_01_full_brown_idap_F", [0.201172,17.2832,0], 219.598, 1, 0, [], "", "", true, false], 
        ["Land_FoodContainer_01_White_F", [2.07617,17.1582,7.15256e-07], 240.945, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-1.98828,17.1836,3.19481e-05], 89.9912, 1, 0, [], "", "", true, false], 
        ["Land_CampingTable_white_F", [0.701172,17.2832,-0.00259185], 179.999, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-3.05859,17.0352,9.53674e-07], 224.914, 1, 0, [], "", "", true, false], 
        ["Land_FoodContainer_01_White_F", [3.32617,17.0332,1.0252e-05], 108.105, 1, 0, [], "", "", true, false], 
        ["Land_CampingTable_white_F", [-2.67383,17.1582,-0.00259185], 180.002, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-2.14648,17.252,3.24249e-05], 14.8793, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-4.04883,16.9082,3.24249e-05], 14.91, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_full_F", [-2.52148,17.252,3.24249e-05], 14.8795, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_cap_F", [-3.79883,17.0332,-0.000635624], 254.894, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-3.29883,17.1582,9.53674e-07], 104.928, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_empty_F", [-3.92383,17.0332,3.21865e-05], 254.955, 1, 0, [], "", "", true, false], 
        ["Land_CampingTable_white_F", [2.70117,17.2832,-0.00259185], 179.998, 1, 0, [], "", "", true, false], 
        ["Land_FoodContainer_01_White_F", [2.95117,17.2832,7.15256e-07], 26.9164, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_pack_F", [-3.79883,17.2832,1.90735e-06], 254.93, 1, 0, [], "", "", true, false], 
        ["Land_BarrelEmpty_grey_F", [4.07617,17.2832,3.09944e-06], 156.53, 1, 0, [], "", "", true, false], 
        ["Land_WaterBottle_01_compressed_F", [-4.07227,17.3398,-1.16825e-05], 149.996, 1, 0, [], "", "", true, false], 
        ["Snake_random_F", [-16.793,29.5508,0.0083878], 308.416, 1, 0, [], "", "", true, false]
    ],
    // Third emplacement
    [
        ["Land_dp_transformer_F", [0.720703,-3.39258,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_dp_transformer_F", [0.720703,4.60742,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_dp_transformer_F", [-5.2793,-3.39258,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_dp_transformer_F", [-5.2793,4.60742,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_dp_transformer_F", [6.7207,-3.39258,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [1.49805,-8.3418,2.14577e-05], 319.635, 1, 0.00500209, [], "", "", true, false], 
        ["Land_dp_transformer_F", [6.7207,4.60742,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [0.978516,-9.00195,1.43051e-06], 4.66434, 1, 0.00494849, [], "", "", true, false], 
        ["Land_spp_Transformer_F", [-3.02734,-8.98438,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_Pole_F", [5.98242,-7.68945,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_3_D_F", [-1.67969,10.1895,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_3_Hole_F", [1.36133,10.1875,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_3_Hole_F", [7.48047,-7.74805,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_GarbagePallet_F", [-6.82031,-9.32031,0], 60, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_9_F", [11.7988,5.7168,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_3_Hole_F", [11.8262,-3.2832,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_9_F", [4.36133,10.1602,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_9_F", [-10.6387,10.1602,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_9_F", [-7.50781,-7.38477,-0.451371], 180, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_Corner_F", [10.4023,-7.7793,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_3_F", [11.8555,-6.2832,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_HighVoltageEnd_F", [-12.584,1.0625,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [2.21289,-13.8516,-0.000999928], 7.36134, 1, 0, [], "", "", true, false], 
        ["Land_Pallet_MilBoxes_F", [7.39063,-12.3672,0], 349.529, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [4.86133,-13.8164,-0.000999928], 352.361, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_Corner_F", [11.8359,8.7168,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [9.48633,-11.3301,0], 319.529, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_9_F", [-14.957,-3.4043,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [10.6836,-10.9375,1.43051e-06], 169.526, 1, 0.00494872, [], "", "", true, false], 
        ["Land_BagFence_Short_F", [7.29102,-13.4531,-0.0010004], 169.529, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Short_F", [8.99609,-12.957,-0.0010004], 154.529, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Short_F", [10.3613,-12.0742,-0.0010004], 139.529, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_3_Hole_F", [-14.9844,5.59766,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_End_F", [11.9648,-11.3574,-0.00100017], 349.529, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_Corner_F", [-14.9961,-6.40234,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_Corner_F", [-13.5625,10.0918,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [13.6387,10.1406,-0.000999928], 181.019, 1, 0, [], "", "", true, false], 
        ["Land_BagBunker_Tower_F", [16.8633,0.830078,0], 181.019, 1, 0, [], "", "", true, false], 
        ["Land_IndFnc_3_F", [-15.0156,8.5957,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_HBarrier_5_F", [15.8809,10.1152,0], 91.0185, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [18.582,-5.13672,-0.000999928], 305.571, 1, 0, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [18.6758,6.1582,1.43051e-06], 346.012, 1, 0.00494653, [], "", "", true, false], 
        ["Snake_random_F", [-26.9063,-2.02344,0], 142.126, 1, 0, [], "", "", true, false]
    ],
    // Fourth emplacement
    [
        ["Land_Sacks_heap_F", [-3.60938,1.62305,0], 343, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [-3.36914,3.11523,0], 242, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_open_full_F", [-4.95898,2.33594,0], 228, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [0.00390625,-5.66016,0], 195, 1, 0, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [-3.66016,4.35547,1.66893e-06], 54.9997, 1, 0.00494914, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [-4.375,3.99414,1.43051e-06], 339.997, 1, 0.00494852, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [-4.3418,4.66602,1.43051e-06], 205, 1, 0.00494873, [], "", "", true, false], 
        ["Land_CratesShabby_F", [-5.74023,3.24414,0], 46, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [3.52734,-5.91797,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_ChairWood_F", [-2.27344,6.64063,5.48363e-06], 164.983, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [7.25391,1.55078,0], 75, 1, 0, [], "", "", true, false], 
        ["Land_TableDesk_F", [-2.35938,7.24805,1.23978e-05], 180.006, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [7.50195,-1.96875,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [4.87109,6.00781,0], 105, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [-7.6582,-1.27734,0], 135, 1, 0, [], "", "", true, false], 
        ["Land_Cargo_House_V2_F", [-0.734375,9.22656,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [6.8418,-5.27734,0], 135, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [5.12695,9.53125,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [-10.9727,-1.91797,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_CratesWooden_F", [-5.73438,9.62305,0], 93, 1, 0, [], "", "", true, false], 
        ["Land_Pallet_vertical_F", [-7.60938,8.99805,4.93526e-05], 183.004, 1, 0, [], "", "", true, false], 
        ["Land_CzechHedgehog_01_F", [11.8516,1.14258,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_F", [-11.7344,3.87305,3.8147e-06], 165, 1, 0, [], "", "", true, false], 
        ["Land_CzechHedgehog_01_F", [9.47852,8.16992,0], 60, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_F", [-11.4844,5.24805,-1.90735e-06], 59.9992, 1, 0, [], "", "", true, false], 
        ["CamoNet_BLUFOR_open_F", [-11.7598,3.75977,-0.864591], 0, 1, 0, [], "", "", true, false], 
        ["Land_Garbage_square5_F", [-12.3594,2.96289,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_F", [-12.6094,3.24805,-1.43051e-06], 149.997, 1, 0, [], "", "", true, false], 
        ["Land_CzechHedgehog_01_F", [-10.834,-7.45508,0], 75, 1, 0, [], "", "", true, false], 
        ["Land_CzechHedgehog_01_F", [-4.70898,-12.5801,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_WoodenTable_large_F", [-12.7539,4.23633,-2.38419e-07], 227.999, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [1.17969,13.5039,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [4.48828,12.8438,0], 45, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [-3.94531,13.5039,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_F", [-12.9844,5.24805,-1.66893e-06], 329.997, 1, 0, [], "", "", true, false], 
        ["Land_Garbage_square5_F", [-13.8047,4.86133,0], 240, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V2_F", [-13.9844,4.74805,-1.66893e-06], 299.997, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_End_F", [-13.1563,-8.21484,-0.00100017], 345, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_tall_F", [-9.99805,11.6387,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [-16.0977,-1.91797,0], 180, 1, 0, [], "", "", true, false], 
        ["Land_WoodenBox_F", [-16.3359,4.50195,-2.38419e-07], 120, 1, 0, [], "", "", true, false], 
        ["Land_Tyre_F", [-15.873,6.13672,-0.0043025], 315, 1, 0, [], "", "", true, false], 
        ["Land_Sacks_heap_F", [-14.1094,9.74805,0], 88, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [-15.0859,-9.25195,-0.00130081], 345, 1, 0, [], "", "", true, false], 
        ["Land_WoodenBox_F", [-16.9551,5.2207,2.14577e-06], 282, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [-18.4863,3.76172,0], 2, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_open_empty_F", [-18.3691,5.53711,0], 348, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [-19.4043,-1.25586,0], 225, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [-16.0703,11.1309,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [-17.5781,-8.30664,-0.00130081], 180, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [-20.0449,2.05664,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_3_F", [-20.0449,7.18164,0], 270, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [-19.7539,-9.56836,-0.00130081], 345, 1, 0, [], "", "", true, false], 
        ["Land_Bunker_01_blocks_1_F", [-19.3828,10.4902,0], 315, 1, 0, [], "", "", true, false], 
        ["Land_Wreck_Offroad2_F", [-21.9004,-7.54883,0], 300, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Long_F", [-22.3633,-8.51758,-0.000999928], 210, 1, 0, [], "", "", true, false], 
        ["Snake_random_F", [-19.0176,-18.7402,0.0083878], 284.566, 1, 0, [], "", "", true, false], 
        ["Snake_random_F", [-37.0313,-1.25977,0.0083878], 192.416, 1, 0, [], "", "", true, false]
    ],
    // Fifth emplacement
    [
        ["Land_BagFence_Long_F", [0.283203,2.28516,-0.000999928], 180, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Short_F", [2.52539,2.33008,-0.0010004], 179.331, 1, 0, [], "", "", true, false], 
        ["Land_HBarrier_5_F", [-6.21875,2.54688,0], 0, 1, 0, [], "", "", true, false], 
        ["CamoNet_BLUFOR_open_F", [-1.12109,4.5625,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [4.83008,2.68359,-0.00130081], 317.528, 1, 0, [], "", "", true, false], 
        ["MetalBarrel_burning_F", [1.7793,5.55078,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_Pallet_MilBoxes_F", [-4.21875,4.16602,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Short_F", [5.39648,4.90039,-0.0010004], 270.163, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [2.44141,7.40039,-0.00130081], 143.632, 1, 0, [], "", "", true, false], 
        ["Land_BagFence_Round_F", [5.16211,6.96484,-0.00130081], 230.141, 1, 0, [], "", "", true, false], 
        ["Land_WaterTank_F", [-2.7207,7.92578,-4.76837e-06], 0.00131096, 1, 0, [], "", "", true, false], 
        ["Land_HBarrier_5_F", [-5.97461,8.29883,0], 90, 1, 0, [], "", "", true, false], 
        ["Land_i_Stone_Shed_V1_F", [-2.9082,10.9883,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_FieldToilet_F", [2.5293,10.4258,3.8147e-06], 269.999, 1, 0, [], "", "", true, false], 
        ["Land_Sacks_heap_F", [8.9043,6.67578,0], 30, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_closed_F", [2.40234,12.4375,0], 0, 1, 0, [], "", "", true, false], 
        ["Land_Razorwire_F", [-7.7793,11.7793,-2.86102e-06], 90, 1, 0, [], "", "", true, false], 
        ["Land_Pallets_stack_F", [10.0293,7.92578,-2.38419e-07], 360, 1, 0, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [9.0293,9.05078,1.43051e-06], 89.9837, 1, 0.00494839, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [9.0293,9.80078,1.43051e-06], 300.005, 1, 0.00494863, [], "", "", true, false], 
        ["Land_MetalBarrel_F", [9.6543,9.30078,1.66893e-06], 225.007, 1, 0.00494881, [], "", "", true, false], 
        ["Land_CampingTable_F", [5.91602,12.1914,-0.00259185], 47.7756, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V1_F", [6.61914,12.1797,0.00308967], 60.8616, 1, 0, [], "", "", true, false], 
        ["Land_PaperBox_open_empty_F", [2.4043,14.3008,0], 345, 1, 0, [], "", "", true, false], 
        ["Land_CampingChair_V1_F", [6.13086,13.207,0.00308895], 29.9776, 1, 0, [], "", "", true, false], 
        ["Land_Razorwire_F", [-2.11719,15.3594,-2.86102e-06], 180, 1, 0, [], "", "", true, false], 
        ["Snake_random_F", [17.6484,41.416,0.0083878], 126.532, 1, 0, [], "", "", true, false]
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
		_objectData set ["veh1", ["B_Slingload_01_Ammo_F", "Tag Field Supplies", [5, 30]]];
		_objectData set ["veh2", ["B_Slingload_01_Fuel_F", "Tag Field Supplies", [5, 30]]];
		_objectData set ["veh3", ["B_Slingload_01_Medevac_F", "Tag Field Supplies", [5, 30]]];
		_objectData set ["veh4", ["B_Slingload_01_Repair_F", "Tag Field Supplies", [5, 30]]];
		

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
									_caller sideChat format ["Objective Complete: Field Supplies Marked", _actionText];
									nul = [] execVM "missionCompleteScreen.sqf";
									
									//add xp/coins
									[20] execVM "addXP.sqf";
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

		//==========End New Systems Here==========//

		_spawned = true;
		player sideChat "New Objective: Locate & Tag Field Supplies";
		nul = [] execVM "missionBriefings\logisticMissionBrief.sqf";
	};
};