//==========General Settings ==========//

private _markerNameText = "Eliminate HVT";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 4; //Default 2
private _staticGroupSizeMax = 6; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 2; //Default 2

//Patrol Groups
private _patrolSizeMin = 2; //Default 1
private _patrolSizeMax = 5; //Default 6
private _patrolGroupCountMin = 0; //Default 0
private _patrolGroupCountMax = 1; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.7; //Default 0.2
private _staticWeaponChance = 0.2; //Default 0.3

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
		["Land_HBarrier_5_F", [-4.49414, 4.03906, 0], 0],
		["Land_HBarrier_5_F", [1.00586, 4.03906, 0], 0],
		["Land_PaperBox_closed_F", [-2.50098, 5.67969, 0], 345],
		["Land_CratesWooden_F", [2.50488, 5.66797, 0], 0],
		["Land_PaperBox_closed_F", [-2.48242, 7.66992, 0], 90],
		["Land_HBarrier_5_F", [-4.24121, 5.29492, 0], 270],
		["Land_Garbage_square5_F", [1.7959, 9.25586, 0], 0],
		["Land_HBarrier_5_F", [6.50586, 4.03906, 0], 0],
		["Land_MetalBarrel_F", [-0.995117, 9.66797, 1.90735e-06], 329.983],
		["Land_MetalBarrel_F", [8.25391, 5.17383, -0.000972748], 210.033],
		["Land_PaperBox_closed_F", [-2.49707, 9.43164, 0], 0],
		["Land_MetalBarrel_F", [8.25488, 5.91797, 1.90735e-06], 164.969],
		["Land_Garbage_square5_F", [6.47559, 9.02148, 0], 0],
		["Land_HBarrier_5_F", [1.50391, 11.1719, 0], 180],
		["Land_CratesWooden_F", [10.0049, 5.66797, 0], 180],
		["Land_PowerGenerator_F", [10.2393, 8.41797, 0], 270],
		["Land_HBarrier_5_F", [12.251, 8.54102, 0], 90],
		["Land_HBarrier_5_F", [-4.24121, 10.9199, 0], 270],
		["Land_HBarrier_5_F", [12.5283, 9.75, 0], 180],
		["Land_Cargo_House_V1_F", [0.0263672, 15.293, 0], 270],
		["Land_Cargo_House_V1_F", [7.9834, 13.918, 0], 90],
		["Land_BarrelWater_grey_F", [6.15918, 15.8828, 1.90735e-06], 59.9659],
		["Land_HBarrier_5_F", [12.3066, 15.4766, 0], 90],
		["Land_CratesPlastic_F", [0.256836, 18.9141, 0], 30],
		["Land_HBarrier_3_F", [-0.880859, 19.0664, 0], 180],
		["Land_HBarrier_5_F", [-4.24121, 16.5449, 0], 270],
		["Land_ToiletBox_F", [10.0049, 17.668, -5.72205e-06], 89.9974],
		["Land_Pallets_stack_F", [-2.49512, 20.668, -1.90735e-06], 360],
		["Land_ToiletBox_F", [10.0049, 18.918, -5.72205e-06], 74.9965],
		["Land_HBarrier_5_F", [12.251, 21.166, 0], 90],
		["Land_HBarrier_3_F", [10.9941, 20.9414, 0], 180],
		["Land_BagFence_Long_F", [3.39063, 23.7207, -0.000999451], 180],
		["Land_BagFence_Round_F", [0.791016, 24.3359, -0.00130081], 49.4831],
		["Land_BagFence_Round_F", [6.15137, 24.127, -0.00130081], 313.854],
		["CamoNet_INDP_open_F", [4.10352, 24.3047, 0], 3.41509e-06],
		["Land_BagFence_Round_F", [1.04297, 26.9395, -0.00130081], 138.854],
		["Land_BagFence_Round_F", [6.17676, 26.7422, -0.00130081], 224.483],
		["Land_BagFence_Long_F", [3.75879, 27.1523, -0.000999451], 180],
		["Snake_random_F", [12.6572, 47.916, 0.00838852], 196.21]
	],

	// Second emplacement
	[
		["Land_Cargo10_cyan_F", [-4.76563, 2.75391, 1.14441e-05], 179.998],
		["Land_HBarrier_3_F", [1.99414, 4.73047, 0.00259018], 0],
		["Land_Garbage_square5_F", [1.27246, -5.79883, 0], 0],
		["Land_HBarrier_5_F", [-6.31348, 4.90039, 0], 0],
		["Land_Garbage_square5_F", [-2.72754, -5.79883, 0], 0],
		["Land_MetalBarrel_empty_F", [2.85938, -6.24609, 0], 345],
		["Land_MetalBarrel_empty_F", [2.65918, -6.94727, 0], 195],
		["Land_HBarrier_5_F", [4.10547, -4.12305, 0], 90],
		["Land_Garbage_square5_F", [-6.61328, -5.16992, 0], 0],
		["Land_Sacks_goods_F", [-2.51465, -8.23242, 0], 0],
		["Land_MetalBarrel_empty_F", [2.74121, -8.21875, 0], 90],
		["CamoNet_INDP_F", [-5.86621, -6.82031, 0], 180],
		["Land_GarbagePallet_F", [0.133789, -8.7832, 0], 0],
		["CargoNet_01_barrels_F", [-8.9248, 3.10547, 9.53674e-06], 166.583],
		["Land_HBarrier_5_F", [4.2334, -9.74219, 0], 180],
		["Land_HBarrier_5_F", [-1.2666, -9.74219, 0], 180],
		["Land_HBarrier_5_F", [-12.0146, 4.875, 0], 0],
		["Box_IND_AmmoVeh_F", [-7.89063, -7.74609, 0.0305519], 359.998],
		["Land_WaterBarrel_F", [-10.6406, 3.37891, 9.53674e-06], 104.997],
		["Land_CanisterFuel_F", [-11.1406, 2.12891, 3.43323e-05], 269.878],
		["Land_CanisterFuel_F", [-11.2178, 2.67773, -0.000968933], 149.554],
		["Land_PaperBox_closed_F", [-10.3779, -5.37109, 0], 105],
		["Land_PaperBox_closed_F", [-10.3799, -7.36523, 0], 75],
		["Land_HBarrier_5_F", [-6.41406, -9.65625, 0], 180],
		["Land_HBarrier_1_F", [-13.2725, -1.12109, 0], 90],
		["Land_GarbageBags_F", [-13.8057, 3.98828, 0], 0],
		["Land_HBarrier_5_F", [-12.2695, -5.37305, 0], 90],
		["Land_BagBunker_Tower_F", [-14.4307, -0.3125, 0], 0],
		["Land_Garbage_square5_F", [-13.9775, 6.57617, 0], 0],
		["Snake_random_F", [-3.28711, 23.8672, 0.00839233], 136.581],
		["Snake_random_F", [-26.0264, -20.9316, 0.00838852], 109.222]
	],

	// Third emplacement
	[
		["Land_BagFence_End_F", [5.19629, -1.13867, -0.000999451], 300],
		["Land_BagFence_Long_F", [4.91016, 1.88867, -0.000999451], 90],
		["Land_HBarrier_5_F", [0.773438, -7.86328, 0], 270],
		["Land_BagFence_Long_F", [4.75391, -3.36914, -0.000999451], 270],
		["Land_MetalBarrel_F", [6.03516, 3.88477, -0.000986099], 269.974],
		["Land_HBarrier_5_F", [4.89063, 7.75781, 0], 90],
		["Land_MetalBarrel_F", [6.03613, 4.63477, 3.24249e-05], 89.901],
		["Land_HBarrier_5_F", [-0.729492, 7.63086, 0], 3.41509e-06],
		["Land_MetalBarrel_empty_F", [-0.480469, -7.86523, 0], 180],
		["Land_MetalBarrel_empty_F", [6.01953, 5.38477, 0], 105],
		["Land_HBarrier_5_F", [4.76563, -4.86719, 0], 90],
		["Land_HBarrier_5_F", [-6.22852, 7.63086, 0], 3.41509e-06],
		["Land_PaperBox_closed_F", [6.39258, -6.10352, 0], 0],
		["Land_HBarrier_3_F", [-1.03027, -9.64648, 0], 0],
		["WaterPump_01_forest_F", [-7.60547, -6.74023, 0.000839233], 149.998],
		["Land_GarbageBags_F", [-0.520508, -11.1309, 0], 0],
		["Land_PaperBox_closed_F", [6.38184, -8.24219, 0], 270],
		["Oil_Spill_F", [-8.56738, -7.00195, 0], 0],
		["Land_BarrelWater_grey_F", [5.89453, -9.49023, -9.53674e-06], 359.989],
		["Land_BagFence_Long_F", [-1.46484, -11.3613, -0.000999451], 90],
		["Land_ReservoirTower_F", [-5.60547, -0.115234, 0], 0],
		["Land_HBarrier_5_F", [-11.6094, 4.25781, 0], 90],
		["Land_BagFence_Long_F", [4.62891, -11.1191, -0.000999451], 270],
		["Land_HBarrier_5_F", [-11.6094, -1.36719, 0], 90],
		["CamoNet_INDP_open_F", [-5.25684, -11.6035, 0], 0],
		["Land_HBarrier_5_F", [-11.8535, 7.63086, 0], 3.41509e-06],
		["Land_MetalBarrel_F", [-10.3555, -7.36523, -9.53674e-06], 29.9867],
		["Land_MetalBarrel_empty_F", [-10.3555, -8.11523, 0], 0],
		["Land_MetalBarrel_F", [-10.3555, -8.86523, -9.53674e-06], 359.968],
		["Land_BagFence_Round_F", [-1.10449, -13.9453, -0.00130081], 45],
		["Land_MetalBarrel_empty_F", [-10.3555, -9.86523, 0], 150],
		["Land_BagFence_Round_F", [4.55469, -13.8555, -0.00130081], 300],
		["Land_HBarrier_3_F", [-8.11621, -11.0918, 0], 180],
		["Land_BagFence_End_F", [0.871094, -14.918, -0.000999451], 30],
		["Land_HBarrier_5_F", [-11.6094, -6.86719, 0], 90],
		["Land_BagFence_End_F", [2.77637, -15.252, -0.000999451], 135],
		["Land_GarbagePallet_F", [-8.70605, -12.9023, 0], 0],
		["Land_PaperBox_closed_F", [-10.6074, -12.8535, 0], 0],
		["Land_Garbage_square5_F", [-7.87305, -15.3926, 0], 75],
		["Snake_random_F", [-18.3701, -14.3418, 0.00838852], 33.3908]
	],

	// Fourth emplacement
	[
		["Land_BagFence_Round_F", [-1.56934, -0.675781, -0.00130081], 315],
		["Land_BagFence_End_F", [1.72168, 0.818359, -0.000999451], 225],
		["Land_BagFence_Short_F", [3.11426, 0.150391, -0.000999451], 180],
		["Land_BagFence_Round_F", [-4.14551, -0.552734, -0.00130081], 45],
		["Land_BagFence_Round_F", [5.29883, 0.478516, -0.00130081], 315],
		["Land_BagFence_Long_F", [-4.79297, 2.23633, -0.000999451], 260],
		["Land_BagFence_Short_F", [5.85254, 2.64258, -0.000999451], 270],
		["Land_CratesWooden_F", [-3.89648, 5.40234, 0], 75],
		["Land_BagFence_End_F", [5.87695, 4.3418, -0.000999451], 270],
		["Land_Garbage_square5_F", [-1.63867, 7.13086, 0], 0],
		["Land_PaperBox_closed_F", [-0.15332, 7.39258, 0], 225],
		["Land_HBarrier_5_F", [-6.25977, 8.21094, 0], 75],
		["Land_WaterBarrel_F", [-0.896484, 8.65234, 0], 360],
		["CamoNet_INDP_open_F", [-1.25879, 8.55469, 0], 90],
		["Land_BarrelTrash_grey_F", [5.10352, 7.65234, 0], 359.959],
		["Land_HBarrier_5_F", [10.3525, 4.40625, 0], 180],
		["Land_GarbageWashingMachine_F", [9.86328, 6.13477, 0], 180],
		["Land_Cargo_House_V1_F", [7.08203, 9.90234, 0], 90],
		["Land_Garbage_square5_F", [4.8916, 11.2246, 0], 0],
		["Land_Garbage_square5_F", [10.9395, 6.0332, 0], 0],
		["Land_GarbagePallet_F", [5.12793, 11.6152, 0], 0],
		["Land_HBarrier_5_F", [-6.40039, 13.4004, 0], 90],
		["Land_HBarrier_5_F", [11.5996, 8.65039, 0], 90],
		["Land_PaperBox_closed_F", [-1.64844, 13.416, 0], 0],
		["Land_HBarrier_5_F", [1.85254, 15.4063, 0], 180],
		["Land_HBarrier_5_F", [11.6084, 9.9043, -0.00325394], 270],
		["Land_PowerGenerator_F", [9.58789, 14.2773, -2.09808e-05], 270],
		["Land_CratesPlastic_F", [8.35449, 15.4063, 5.72205e-06], 255],
		["Land_Pallets_stack_F", [8.32715, 16.9258, 1.14441e-05], 314.952],
		["Land_HBarrier_3_F", [9.48926, 15.6289, -0.00151062], 0],
		["Land_TTowerSmall_2_F", [10.5, 13.5098, -0.000371933], 0],
		["Snake_random_F", [30.5029, 30.7422, 0.00838852], 42.8553]
	],

	// Fifth emplacement
	[
		["Land_WaterBarrel_F", [-1.41113, 1.03027, 0.00354385], 359.353],
		["Land_Pallets_F", [-2.40918, 0.205078, 0], 135],
		["Land_Garbage_square5_F", [-0.802734, 2.82031, 0], 60],
		["Land_CampingChair_V2_F", [0.438477, 3.09473, 5.72205e-06], 224.984],
		["Land_CampingChair_V2_F", [-0.525391, 3.35449, 7.62939e-06], 209.994],
		["Land_CratesShabby_F", [-2.65137, 2.30566, 0], 135],
		["Land_GarbagePallet_F", [-4.11133, 1.32324, 0], 270],
		["Land_CampingChair_V2_F", [3.40527, 3.03613, 1.90735e-06], 179.994],
		["Land_WoodenTable_large_F", [0.832031, 5.14551, 1.90735e-06], 297.105],
		["CamoNet_INDP_open_F", [1.32617, 4.43652, -0.865269], 0],
		["Land_WoodenTable_large_F", [3.72656, 3.79785, -1.90735e-06], 76.9514],
		["MapBoard_stratis_F", [-3.15723, 7.92969, -0.00218391], 315.002],
		["Land_CampingChair_V2_F", [7.10352, 5.30859, -1.14441e-05], 149.995],
		["Land_WoodenTable_large_F", [6.60254, 6.17383, -5.53131e-05], 209.852],
		["Land_WoodenTable_small_F", [2.97754, 8.67383, -1.33514e-05], 269.874],
		["Land_CampingChair_V2_F", [7.32422, 6.19141, -1.52588e-05], 119.997],
		["Land_Basket_F", [4.40234, 8.68555, -9.53674e-06], 269.999],
		["MapBoard_altis_F", [-0.904297, 9.68262, -0.00222969], 330.019],
		["Land_ChairWood_F", [2.74609, 9.49023, -1.90735e-06], 345.045],
		["Snake_random_F", [-29.2168, 16.7764, 0.00838852], 175.267],
		["Snake_random_F", [-32.125, -22.5029, 0.00838852], 199.14]
	],

	// Sixth emplacement
	[
		["Land_BagFence_Short_F", [-0.166992, -2.08008, 0.00310898], 0],
		["Land_BagFence_Round_F", [-2.36035, -2.45703, -0.00384331], 135],
		["Land_BagFence_Short_F", [-2.78223, -4.4668, 0.000272751], 270],
		["Land_PortableLight_double_F", [-1.87305, -5.96973, 0.000486374], 225],
		["Land_BagFence_Round_F", [-2.40527, -6.53613, -0.000797272], 45],
		["Land_PaperBox_open_empty_F", [-2.5332, 6.24805, 2.67029e-05], 270.001],
		["Land_PowerGenerator_F", [3.11719, -6.00684, 9.53674e-06], 345],
		["Land_Sacks_heap_F", [-6.99121, 0.743164, 1.90735e-06], 203.249],
		["Land_MetalBarrel_F", [2.96875, 6.375, 3.24249e-05], 89.9808],
		["Land_MetalBarrel_empty_F", [3.59473, 6.625, 1.71661e-05], 224.981],
		["Land_BagFence_Round_F", [-0.03125, -7.50293, -0.00402641], 225],
		["Land_MetalBarrel_F", [2.96973, 7.125, 2.67029e-05], 299.975],
		["Land_Medevac_house_V1_F", [-1.28223, 8.85156, -0.00521469], 0],
		["Land_TTowerSmall_1_F", [3.84277, -5.32617, -0.000137329], 0],
		["Land_Medevac_house_V1_F", [-8.85254, 2.87598, 0.000923157], 285],
		["Land_BagFence_Round_F", [8.46875, -3.00293, -0.00831032], 225],
		["Land_FieldToilet_F", [-8.73535, -1.20215, -9.53674e-06], 297.941],
		["Land_BagFence_Round_F", [0.719727, -10.1611, 0.00176239], 44.9999],
		["Land_BagFence_Round_F", [5.76465, -7.83203, -0.00496101], 135],
		["Land_BagFence_Short_F", [8.8457, -5.07129, -0.00351524], 90.0012],
		["CamoNet_BLUFOR_open_F", [5.98047, 8.14941, 0.00385666], 90.0016],
		["Land_BagFence_Round_F", [8.42383, -7.08105, 0.00800323], 315.001],
		["Land_MetalBarrel_F", [-10.7373, -0.295898, -3.8147e-06], 105.009],
		["Land_MetalBarrel_F", [-10.8574, -1.08789, -1.90735e-06], 179.965],
		["Land_BagFence_Short_F", [2.73047, -10.583, -0.00442696], 180],
		["Land_BagFence_Round_F", [4.79883, -10.2061, 0.00331306], 315],
		["Land_CanisterFuel_F", [-10.9229, -1.93945, 1.71661e-05], 164.905],
		["B_G_Offroad_01_F", [6.74219, 8.93066, -0.0307579], 135.011],
		["Land_CanisterFuel_F", [-11.3047, -1.75195, 1.71661e-05], 134.83],
		["Land_HBarrier_3_F", [-8.53223, 7.02246, -0.00108337], 195],
		["Land_PaperBox_open_full_F", [-12.2461, -0.764648, 1.90735e-05], 36.432],
		["Land_HBarrier_3_F", [3.20801, 13.3164, -0.00602722], 180],
		["Land_HBarrier_5_F", [-0.03125, 13.2979, -0.00712204], 180],
		["B_G_Van_01_transport_F", [-12.2881, -5.74023, 0.00177574], 240.007],
		["Land_HBarrier_3_F", [-13.3477, 2.87012, -0.001791], 105],
		["Land_HBarrier_5_F", [-11.9111, 8.08789, -0.00151062], 105],
		["Land_PaperBox_closed_F", [11.3379, 10.1113, 0.000148773], 210.651],
		["Land_Pallets_stack_F", [10.1533, 11.9502, 0.00205994], 99.8996],
		["Land_Pallets_F", [11.5068, 11.5029, 0.00306511], 37.886]
	],

	// Seventh emplacement
	[
		["Land_Shoot_House_Wall_F", [-1.17676, 1.26367, -0.271807], 0],
		["Land_BagFence_Long_F", [0.723633, -3.38477, -0.000999451], 178.245],
		["Land_Axe_fire_F", [-2.33203, 2.65137, 0.117994], 35.9034],
		["Land_WoodPile_F", [-3.08887, 1.81445, 0], 265.172],
		["Land_BottlePlastic_V2_F", [2.50586, 2.8418, 0.0347023], 183.062],
		["Land_Shoot_House_Wall_Long_F", [-3.32617, 1.23047, -0.271177], 2.73208e-05],
		["Land_BagFence_Long_F", [3.98145, -0.349609, -0.000999451], 268.245],
		["Land_BagFence_Long_F", [-2.16895, -3.37305, -0.000999451], 358.245],
		["Land_BagFence_Round_F", [3.55371, -2.96289, -0.00130081], 316.002],
		["Land_BakedBeans_F", [-0.665039, 4.77051, 0.0384541], 229.408],
		["Land_BagFence_Round_F", [-4.85059, -2.91992, -0.00130081], 46.002],
		["Land_ButaneCanister_F", [0.856445, 5.34082, -0.0696468], 96.1513],
		["Land_Canteen_F", [-1.03809, 5.4248, 0.0529175], 335.757],
		["Land_Shoot_House_Wall_Long_F", [4.24707, 3.41309, -0.257113], 270],
		["Land_DuctTape_F", [-0.979492, 5.85742, 0.0204563], 99.2113],
		["Land_Unfinished_Building_02_F", [-2.63574, 4.8125, 0], 0],
		["Land_RiceBox_F", [0.586914, 6.08008, 0.0316124], 310.757],
		["Land_Ammobox_rounds_F", [3.19531, 5.32324, -0.0267982], 67.8862],
		["Land_RiceBox_F", [0.0205078, 6.4082, 0.033741], 338.511],
		["Land_JunkPile_F", [-6.66895, -0.0488281, 0], 193.572],
		["Land_CerealsBox_F", [-0.40918, 6.49414, 0.141481], 121.537],
		["Land_Bandage_F", [3.33301, 5.61816, 0.0209045], 99.1518],
		["Land_CerealsBox_F", [-0.323242, 6.58398, 0.141317], 291.64],
		["Land_Bandage_F", [3.81445, 5.43262, 0.0208988], 67.5674],
		["Land_CanisterPlastic_F", [3.47363, 5.9707, -0.138823], 247.95],
		["Land_GasCooker_F", [3.02637, 6.40527, -0.0299816], 176.396],
		["Land_GasCanister_F", [3.02441, 6.54883, 0.0147285], 87.384],
		["Land_WoodenCart_F", [6.73242, 3.00879, 0.0159702], 32.2509],
		["Land_Shoot_House_Wall_F", [4.28809, 5.86328, -0.251261], 270],
		["Land_cargo_addon02_V1_F", [6.65039, 3.86035, 7.62939e-06], 91.5981],
		["Land_CratesPlastic_F", [-4.74316, 6.36719, 0], 94.9998],
		["Land_Pallet_MilBoxes_F", [3.06934, 7.61816, -0.252609], 356.771],
		["Land_BagFence_Short_F", [4.35254, 7.09961, -0.2481], 271.993],
		["Land_BagFence_Long_F", [5.94434, 6.13281, -0.0030632], 358.245],
		["Land_Tyres_F", [-8.58887, -0.308594, 0.00659752], 193.637],
		["Land_PlasticCase_01_small_F", [-7.6748, 5.39258, -0.000997543], 177.078],
		["Land_Shoot_House_Wall_Long_F", [4.25293, 8.44727, -0.245281], 270],
		["Land_PlasticCase_01_small_F", [-0.369141, 10.0449, -0.00105858], 265.58],
		["Land_Ammobox_rounds_F", [2.5293, 9.78711, -0.0267982], 67.8312],
		["Land_GasCanister_F", [2.35547, 9.9834, 0.0037632], 237.42],
		["Land_Ammobox_rounds_F", [0.352539, 10.2549, -0.0011673], 310.932],
		["Land_Sacks_heap_F", [3.54785, 9.76563, -0.244915], 272.657],
		["Land_Ammobox_rounds_F", [2.40332, 10.2061, -0.0011673], 241.573],
		["Land_BagFence_Round_F", [8.46875, 6.58984, -0.000827789], 312.772],
		["Land_Shoot_House_Wall_Long_F", [1.56445, 10.7461, -0.250179], 180],
		["Land_Shoot_House_Wall_Long_Crouch_F", [1.87207, 10.7617, -0.248993], 180],
		["Land_CanisterPlastic_F", [-9.42773, 5.83984, -0.000715256], 243.842],
		["Land_Garbage_square3_F", [6.07129, 9.33203, 0], 198.821],
		["Land_Shoot_House_Wall_F", [3.30762, 10.75, -0.243504], 0],
		["Land_CanisterPlastic_F", [-9.39258, 6.58203, -0.000926971], 194.42],
		["Land_CratesShabby_F", [5.27832, 10.5273, 0], 358.386],
		["Land_BarrelWater_grey_F", [-9.8877, 6.62402, -0.000997543], 358.534],
		["Land_WoodenTable_small_F", [0.96582, 11.9688, 0.0442371], 270.876],
		["Land_Garbage_square5_F", [0.87793, 12.2227, 0.000291824], 0],
		["Land_Scaffolding_F", [-11.7139, 5.5918, 0], 0],
		["Land_BagFence_Long_F", [-0.520508, 12.3242, 0.000982285], 88.2447],
		["MetalBarrel_burning_F", [2.76855, 12.125, 0], 0],
		["Land_Basket_F", [-5.13379, 11.6113, 7.62939e-06], 359.967],
		["Land_Sacks_heap_F", [4.41699, 12.002, 0], 27.137],
		["Land_BakedBeans_F", [6.01953, 11.3721, 0.0412769], 37.7851],
		["Land_BagFence_Long_F", [8.87988, 9.36719, -0.00103951], 88.2446],
		["Land_BakedBeans_F", [5.88086, 11.5068, 0.0412846], 5.51423],
		["Land_DuctTape_F", [-6.04199, 11.4492, 7.62939e-06], 34.6966],
		["Land_Shoot_House_Wall_Long_Prone_F", [-7.74902, 10.6904, -0.250854], 180],
		["Land_Garbage_square3_F", [5.13379, 12.252, 0], 198.821],
		["Land_Ammobox_rounds_F", [-7.47168, 11.4561, -0.000160217], 37.4236],
		["Land_Bench_F", [-5.42285, 13.2676, 0.244102], 105.968],
		["Land_BagFence_Round_F", [-0.141602, 14.9883, -0.000343323], 136.002],
		["Land_ConcretePipe_F", [-3.74121, 14.4951, -0.0534229], 45.1396],
		["Land_BagFence_Long_F", [8.80762, 12.2441, -0.00135803], 88.2446],
		["Land_Bricks_V2_F", [-15.3359, 0.94043, -0.000991821], 12.2506],
		["Land_BagFence_Long_F", [2.66895, 15.4219, -0.000999451], 358.245],
		["Land_Garbage_square5_F", [-8.22363, 14.1387, 0], 97.7588],
		["Land_BagFence_Long_F", [5.52637, 15.4629, -0.00133514], 178.245],
		["Land_Bricks_V3_F", [-16.3398, 2.91699, 7.62939e-06], 318.161],
		["Land_BagFence_Round_F", [8.28223, 15.1074, -0.000919342], 222.772],
		["Land_Pipes_large_F", [-17.4336, 0.960938, 3.8147e-06], 233.167],
		["Land_CinderBlocks_F", [-13.2852, 12.8027, 2.09808e-05], 335.61],
		["Land_CinderBlocks_F", [-15.25, 12.9258, 1.14441e-05], 236.036],
		["Land_CinderBlocks_F", [-14.666, 14.5488, 5.72205e-06], 300.092],
		["Snake_random_F", [-23.0039, -8.51074, 0.00838852], 323.217],
		["Snake_random_F", [-20.2539, -29.3711, 0.00838852], 148.133]
	],

	// Eighth emplacement
	[
		["Land_GarbagePallet_F", [1.68262, 2.66016, 0], 0],
		["Land_Canteen_F", [-4.92676, -2.36133, 0.132458], 142.075],
		["Land_Bricks_V1_F", [-5.94922, -2.27637, -9.53674e-06], 185.002],
		["Land_Garbage_square5_F", [-6.46973, -0.458984, -0.000162125], 255.357],
		["Land_Garbage_square5_F", [-3.12207, 6.12305, 0], 130.357],
		["Land_Shoot_House_Panels_F", [2.59473, 6.49805, 0], 90],
		["Land_Pallet_F", [-7.65137, -1.62891, -5.72205e-06], 125],
		["Land_Shoot_House_Panels_F", [1.10156, 7.8916, -0.267136], 0],
		["Land_Bricks_V2_F", [-8.39648, -0.0146484, -9.53674e-06], 225.002],
		["Land_Shoot_House_Panels_F", [3.5752, 7.90039, -0.270864], 0],
		["Land_Sacks_heap_F", [-1.5957, 8.90527, -0.26012], 90],
		["Land_Shoot_House_Panels_Crouch_F", [2.35742, 9.09375, -0.267797], 90],
		["Land_Shoot_House_Panels_F", [7.26465, 6.56445, 0], 270],
		["Land_Scaffolding_F", [-3.95605, 12.418, 0], 0],
		["Land_Coil_F", [11.6611, 1.60547, 0.000930786], 54.9897],
		["Land_Shoot_House_Panels_F", [-1.13086, 12.7334, -0.255367], 0],
		["Land_Unfinished_Building_02_F", [5.28223, 11.4844, 0], 0],
		["Land_IronPipes_F", [-10.6221, 10.0723, 0], 295],
		["Land_Shoot_House_Panels_F", [8.59668, 12.8672, -0.263876], 0],
		["Land_Shoot_House_Wall_Long_F", [12.1162, 10.3203, -0.256735], 270],
		["Land_CanisterPlastic_F", [16.8096, 2.62109, -3.8147e-06], 54.8707],
		["Land_CinderBlocks_F", [17.0625, 0.785156, -5.72205e-06], 149.986],
		["Land_Shoot_House_Panels_F", [-1.18066, 17.4785, -0.249817], 180],
		["Land_CratesWooden_F", [-6.39746, 16.4121, 0], 90],
		["Land_Shoot_House_Panels_F", [7.43945, 16.1631, -0.263338], 90.0001],
		["Land_CinderBlocks_F", [17.8887, 2.24414, -1.90735e-06], 89.9899],
		["Land_WoodenTable_small_F", [8.41602, 16.1934, -0.00103188], 347.165],
		["Land_Pallet_vertical_F", [-7.24121, 16.8594, -1.14441e-05], 265.003],
		["Land_JunkPile_F", [10.8438, 15.4609, -0.253527], 0],
		["Land_BagFence_Long_F", [9.07324, 17.2959, -0.251823], 0],
		["Land_BagFence_End_F", [13.7471, 13.8848, -0.00195503], 180],
		["Land_BagFence_Short_F", [15.4893, 13.8496, 0.000265121], 180.163],
		["Land_FieldToilet_F", [6.06934, 20.1816, 3.43323e-05], 180.006],
		["Land_ConcretePipe_F", [19.1846, 9.08203, -0.0534077], 215.64],
		["Land_Garbage_square5_F", [13.8721, 16.459, 0.000293732], 0],
		["Land_FieldToilet_F", [8.19238, 20.0059, 2.09808e-05], 195.002],
		["Land_WorkStand_F", [-2.9043, 21.623, -0.000349045], 165.002],
		["Land_Saw_F", [-5.5127, 21.2754, -0.00274086], 339.983],
		["Land_Meter3m_F", [-5.15137, 21.3945, -7.62939e-06], 114.882],
		["Land_BagFence_Long_F", [16.2568, 15.1973, -0.000312805], 90],
		["Land_Gloves_F", [-4.97559, 21.8184, 0.000505447], 39.9752],
		["Land_Gloves_F", [-5.15137, 21.7949, 3.8147e-06], 0.000980953],
		["Land_Tyre_F", [2.32617, 22.3369, -0.00430107], 0.0486909],
		["Land_BagFence_Round_F", [12.2979, 18.8594, -0.000360489], 127.528],
		["Land_GasTank_01_blue_F", [-4.33301, 22.125, 7.62939e-06], 359.89],
		["Land_ConcretePipe_F", [18.5908, 13.0967, -0.0418491], 258.425],
		["Land_Garbage_square5_F", [2.66504, 23.373, -0.000202179], 130.357],
		["Land_BagFence_Long_F", [16.2588, 18.0449, -0.000999451], 90],
		["Land_BagFence_Long_F", [14.7861, 19.3965, -0.000999451], 2.73208e-05],
		["Land_Garbage_square5_F", [9.24121, 22.625, 0], 130.357],
		["Land_Garbage_square5_F", [-6.31348, 23.8711, -0.000118256], 130.357]
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
		
	
		// === CIVILIAN SPAWNING === //
				private _civilianTypes = [
					"O_Officer_Parade_F",
					"O_Officer_Parade_Veteran_F"
				];
				
				private _numCivilians = 1;


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

							_civilian setVariable ["isPotentialenemyHVT", true, true];

							private _checkCivilian = _civilian; // Reference to the civilian for the spawned script
							private _proximityCheckScript = _checkCivilian spawn {
								
								params ["_civ"];

								
								while {true} do {
									
									if (isNull _civ || !(_civ getVariable ["isPotentialenemyHVT", false])) exitWith {};

									private _playerNear = false;
									
									{
										if (alive _x && (_civ distance _x) <= 2) then {
											_playerNear = true;
										};
									} forEach allPlayers;

									if (_playerNear) then {
										_civ setCaptive false;
										_civ enableAI "MOVE";

										
										_civ setVariable ["isPotentialenemyHVT", false, true];

										

										
										private _enemyHVTsLeft = 0;
										{
											
											if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialenemyHVT", false])) then {
												_enemyHVTsLeft = _enemyHVTsLeft + 1;
											};
										} forEach allUnits;

										
										{ _x sideChat format ["enemy HVTs left: %1", _enemyHVTsLeft]; } forEach allPlayers;

										if (_enemyHVTsLeft == 0) then {
										
										};

										break;
								   };
									sleep 2;
								};
							};
						};
					};

			private _totalInitialenemyHVTs = 0;
			{
				
				if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialenemyHVT", false])) then {
					_totalInitialenemyHVTs = _totalInitialenemyHVTs + 1;
				};
			} forEach allUnits;
			{ _x sideChat format ["Total potential enemy HVTs in mission: %1", _totalInitialenemyHVTs]; } forEach allPlayers;
		};


		//==========End New Systems Here==========//

		_spawned = true;
		
		//Must be placed at end of script after... _spawned = true;
		//Make sure object is Destroyable

		if (_spawned) then {
			// objects to watch
			_watchClasses = [
					"O_Officer_Parade_F",
					"O_Officer_Parade_Veteran_F"
			];

			_objectsToWatch = [];
			{
				_found = nearestObjects [_campPos, [_x], 500];
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
							player sideChat "Objective Complete: HVT Eliminated";
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
		player sideChat "New Objective: Terminate key operative";
		nul = [] execVM "missionBriefings\eliminateHVTBrief.sqf";
		
	};
};