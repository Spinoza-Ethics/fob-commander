//==========General Settings ==========//

private _markerNameText = "Research Facility";
private _markerType = "o_hq";


//Static Groups
private _staticGroupSizeMin = 6; //Default 2
private _staticGroupSizeMax = 10; //Default 8
private _staticGroupCountMin = 5; //Default 1
private _staticGroupCountMax = 5; //Default 2

//Patrol Groups
private _patrolSizeMin = 3; //Default 1
private _patrolSizeMax = 8; //Default 6
private _patrolGroupCountMin = 4; //Default 0
private _patrolGroupCountMax = 4; //Default 2

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
    // First emplacement
    [
        ["hatg_mirror", [0, 0, 0.00143886], 82.0815],
        ["Land_Research_house_V1_F", [-0.765625, 5.66016, 2.38419e-06], 337.813],
        ["Land_Research_house_V1_F", [-5.66797, 0.867188, 2.38419e-06], 292.813],
        ["Land_Device_disassembled_F", [3.20703, -3.75, 2.38419e-06], 187.813],
        ["Land_Research_house_V1_F", [-5.66406, -5.98633, 2.38419e-06], 247.813],
        ["Land_Dome_Small_F", [3.25977, -3.73828, -1.1167], 22.8131],
        ["Land_Cargo10_light_blue_F", [11.4355, 0.318359, -4.76837e-07], 7.81402],
        ["Land_Cargo10_yellow_F", [13.5215, -2.45703, 0], 352.814],
        ["Land_Research_house_V1_F", [12.7715, -8.37891, 2.38419e-06], 112.813],
        ["Land_Research_house_V1_F", [7.86719, -13.1699, 2.38419e-06], 157.813],
        ["Land_CncWall1_F", [4.17773, 15.0371, 0], 255],
        ["Land_BagFence_Long_F", [5.99023, 14.6211, -0.000999928], 0],
        ["Land_Cargo_Patrol_V1_F", [-6.00195, 15.8516, 0], 180],
        ["Land_CncWall1_F", [3.79297, 16.2012, 0], 240],
        ["Land_CncWall1_F", [3.01367, 17.2695, 0], 225],
        ["Land_CncWall1_F", [1.9668, 18.0762, 0], 210],
        ["Land_CncWall1_F", [0.783203, 18.6211, 0], 195],
        ["Land_Medevac_house_V1_F", [-16.3496, 10.8516, 0], 300.487],
        ["Land_CncWall4_F", [-2.50977, 18.7676, 0], 180],
        ["Land_CncWall4_F", [-7.75977, 18.7656, 0], 180],
        ["Land_BagFence_Long_F", [15.248, 14.4648, -0.000999928], 180],
        ["Land_Wall_IndCnc_4_F", [2.74609, 19.9375, 0], 268.809],
        ["Land_BagFence_Long_F", [-0.501953, -22.2852, -0.000999928], 180],
        ["Land_CncWall4_F", [-13.0098, 18.7656, 0], 180],
        ["Land_CncWall1_F", [1.21289, -22.6855, 0], 75],
        ["Land_CncWall1_F", [17.0234, 15.2578, 0], 105],
        ["Land_CncWall1_F", [1.59766, -23.8477, 0], 60],
        ["Land_TTowerSmall_2_F", [-19.8711, 9.07617, 0], 0],
        ["Land_CncWall1_F", [17.5664, 16.4434, 0], 120],
        ["Land_Wall_IndCnc_4_F", [-3.82813, 23.9707, 4.76837e-07], 359.648],
        ["Land_BagFence_Long_F", [20.1348, -13.3906, -0.000999928], 90],
        ["Land_Wall_IndCnc_4_F", [2.17188, 24.0078, 4.76837e-07], 359.648],
        ["Land_BagFence_Long_F", [-9.88477, -22.2539, -0.000999928], 0],
        ["B_Slingload_01_Medevac_F", [-16.8809, -17.7695, 0], 75.0001],
        ["Land_BagFence_Long_F", [21.6152, -12.0039, -0.000999928], 0],
        ["Land_CncWall1_F", [2.37695, -24.916, 0], 45],
        ["Land_CncWall1_F", [18.375, 17.4883, 0], 135],
        ["Land_Wall_IndCnc_4_F", [-9.82813, 23.9336, 4.76837e-07], 359.648],
        ["Land_CncWall1_F", [-11.6328, -22.9063, 0], 285],
        ["Land_Cargo40_light_green_F", [2.55078, 25.6406, 4.76837e-07], 359.648],
        ["Land_CncWall1_F", [3.42383, -25.7246, 0], 30],
        ["Land_CncWall4_F", [-18.2598, 18.7656, 0], 180],
        ["Land_CncWall1_F", [4.60742, -26.2676, 0], 15],
        ["Land_CncWall1_F", [19.4414, 18.2695, 0], 150],
        ["Land_CncWall1_F", [-25.3691, 8.95898, 4.76837e-07], 130.159],
        ["Land_CncWall1_F", [-12.1758, -24.0898, 0], 300],
        ["Land_Medevac_HQ_V1_F", [25.2207, 6.90039, 0], 270],
        ["Land_BagFence_Long_F", [24.4902, -12.0039, -0.000999928], 0],
        ["Land_CncWall4_F", [7.90039, -26.4141, 0], 0],
        ["Land_CncWall1_F", [-26.3262, 8.24609, 4.76837e-07], 161.102],
        ["Land_Cargo10_grey_F", [15.5176, -22.7539, 0], 15.0005],
        ["Land_CncWall4_F", [-25.123, 11.9648, 0], 90],
        ["Land_CncWall1_F", [20.6055, 18.6543, 0], 165],
        ["Land_LampHalogen_F", [-10.707, 24.8223, 0], 134.648],
        ["Land_CncWall1_F", [-25.6582, -11.0566, 0], 41.738],
        ["Land_Wall_IndCnc_4_F", [18.3262, 20.1387, 0], 268.655],
        ["Land_CncWall1_F", [-12.9844, -25.1367, 0], 315],
        ["Land_CncWall1_F", [-21.3926, 18.6543, 0], 165],
        ["Land_Cargo20_blue_F", [2.5332, 28.2656, 0], 359.648],
        ["Land_CncWall1_F", [-26.7129, -10.4844, 4.76837e-07], 9.95269],
        ["Land_LampHalogen_F", [-22.6172, 16.4941, 0], 225],
        ["Land_CncWall4_F", [-25.1504, -14.3008, 0], 90],
        ["Land_BagFence_Long_F", [19.9785, -20.7734, -0.000999928], 270],
        ["Land_CncWall1_F", [-22.5566, 18.2676, 0], 150],
        ["Land_CncWall1_F", [-24.9766, 15.2578, 0], 105],
        ["Land_CncWall1_F", [-23.625, 17.4883, 0], 135],
        ["Land_CncWall1_F", [-24.4336, 16.4414, 0], 120],
        ["Land_CncWall4_F", [13.1504, -26.4141, 0], 0],
        ["Land_CncWall1_F", [-14.0527, -25.916, 0], 330],
        ["Land_Wall_IndCnc_4_F", [-11.7207, 28.0664, 4.76837e-07], 89.6477],
        ["Land_BagFence_Long_F", [27.3652, -12.0039, -0.000999928], 0],
        ["Land_CncWall4_F", [23.7402, 18.7676, 0], 180],
        ["Land_CncWall1_F", [-15.2168, -26.3008, 0], 345],
        ["Land_CncBarrierMedium4_F", [1.47461, -30.6211, 0], 211.314],
        ["Land_BagFence_Long_F", [21.2402, -22.3789, -0.000999928], 0],
        ["Land_CncWall1_F", [-12.1211, -28.6445, 0], 195],
        ["Land_CncWall1_F", [-10.9375, -29.1875, 0], 210],
        ["Land_CratesPlastic_F", [-4.73828, 31.2227, 2.38419e-07], 179.648],
        ["Land_CncWall4_F", [-25.1504, -19.4258, 0], 90],
        ["Land_CncWall1_F", [-9.89063, -29.9961, 0], 225],
        ["Land_CncWall4_F", [18.4004, -26.4141, 0], 0],
        ["Land_CncWall4_F", [-18.3496, -26.4141, 0], 0],
        ["Land_Pallets_stack_F", [-6.61133, 31.459, -2.38419e-07], 239.648],
        ["Land_HBarrierWall6_F", [-31.6621, 8.7832, 0], 2.77659],
        ["Land_Wall_IndCnc_4_D_F", [20.1055, 24.1094, 2.38419e-07], 359.648],
        ["Land_MetalBarrel_F", [-4.61523, 32.0977, 1.66893e-06], 224.636],
        ["Land_Research_house_V1_F", [14.0215, 30.3145, 2.38419e-07], 359.648],
        ["Land_MetalBarrel_F", [-5.49023, 32.0918, 1.43051e-06], 193.539],
        ["Land_CncWall1_F", [-9.11133, -31.0625, 0], 240],
        ["Land_CncWall1_F", [-17.8828, -27.3809, 0], 86.3336],
        ["Land_CncWall4_F", [-15.4141, -28.498, 0], 180],
        ["Land_BagFence_Long_F", [23.8652, -22.3789, -0.000999928], 0],
        ["Land_HBarrierWall6_F", [-31.0215, -10.3711, 0], 182.776],
        ["Land_TTowerSmall_1_F", [12.6836, -29.9668, 0], 348.07],
        ["Land_PowerGenerator_F", [11.6973, -30.8418, 0], 168.07],
        ["Land_MetalBarrel_F", [-5.49609, 32.9668, 1.43051e-06], 110.051],
        ["Land_CncWall1_F", [-8.72656, -32.2266, 0], 255],
        ["Land_CncWall1_F", [-25.0371, -22.6836, 0], 75],
        ["Land_LampHalogen_F", [-22.8945, -23.8809, 0], 135],
        ["Land_CncWall1_F", [-21.6426, -26.2676, 0], 15],
        ["Snake_random_F", [17.5684, 28.6445, 0.0083878], 287.885],
        ["Land_Cargo_Tower_V1_F", [26.4414, -16.0391, 0], 0],
        ["Land_CncWall1_F", [-24.6523, -23.8477, 0], 60],
        ["Land_CncWall1_F", [-22.8262, -25.7246, 0], 30],
        ["Land_Wall_IndCnc_Pole_F", [24.1875, 24.1465, 4.76837e-07], 179.648],
        ["Land_CncWall1_F", [-23.873, -24.916, 0], 45],
        ["Land_CncBarrierMedium4_F", [10.5801, -32.625, 0], 78.0701],
        ["Land_CratesShabby_F", [-2.75195, 34.2402, 2.38419e-07], 179.648],
        ["Land_CncWall4_F", [28.9902, 18.7656, 0], 180],
        ["Land_BagFence_Long_F", [26.6152, -22.3789, -0.000999928], 0],
        ["Land_Wall_IndCnc_4_F", [-11.7578, 34.0664, 4.76837e-07], 89.6477],
        ["Land_CncWall4_F", [23.6504, -26.4141, 0], 0],
        ["Land_CncBarrierMedium4_F", [7.83008, -34.4648, 0], 211.314],
        ["Land_CncWall4_F", [-20.6641, -28.498, 0], 180],
        ["Land_CncWall4_F", [35.791, 1.4043, 0], 270],
        ["Land_CncWall4_F", [35.7637, -3.86328, 0], 270],
        ["Land_PortableLight_double_F", [-20.1191, -29.8281, 0], 300],
        ["Land_Sack_F", [22.7773, 27.9043, 2.38419e-07], 29.6477],
        ["Land_CncWall4_F", [35.791, 6.6543, 0], 270],
        ["Land_Wall_IndCnc_4_F", [28.2539, 24.2285, 4.76837e-07], 179.648],
        ["Land_CncWall4_F", [35.7637, -9.11328, 0], 270],
        ["Land_HBarrier_5_F", [36.9492, 1.32422, 0], 90.1519],
        ["Land_Research_house_V1_F", [16.5391, -31.9961, 0], 348.07],
        ["Land_CncWall1_F", [32.2832, 18.6211, 0], 195],
        ["Land_Pallets_F", [23.0586, 28.3516, 2.38419e-07], 329.648],
        ["Land_HBarrier_5_F", [36.9336, -4.05078, 0], 90.1519],
        ["Land_CncWall4_F", [35.791, 11.9043, 0], 270],
        ["Land_Pallets_stack_F", [24.5273, 28.3926, 0.0975425], 317.606],
        ["Land_Pallets_stack_F", [15.1738, -34.4902, 7.15256e-07], 164.547],
        ["Land_LampHalogen_F", [33.5078, 16.2168, 0], 315],
        ["Land_CncWall1_F", [33.4668, 18.0762, 0], 210],
        ["Land_TBox_F", [-9.74219, 36.502, 0], 269.648],
        ["Land_CncWall4_F", [35.7637, -14.3633, 0], 270],
        ["Land_CncWall1_F", [34.5137, 17.2695, 0], 225],
        ["Land_CncWall1_F", [35.6777, 15.0371, 0], 255],
        ["Land_CncWall1_F", [35.293, 16.2012, 0], 240],
        ["C_Truck_02_box_F", [-10.0078, -37.2793, -0.00909805], 105.015],
        ["Land_LampShabby_F", [20.7012, -32.1602, 0], 168.07],
        ["Land_CncWall4_F", [-25.9141, -28.498, 0], 180],
        ["Land_Research_HQ_F", [2.96289, 39.293, 0], 359.648],
        ["Land_CncBarrierMedium_F", [12.0273, -37.0645, 0], 48.0701],
        ["Land_CncWall4_F", [28.9004, -26.4141, 0], 0],
        ["Land_CncBarrierMedium_F", [10.5391, -37.5605, 0], 175.082],
        ["Land_CncBarrierMedium_F", [8.72852, -38.1934, 0], 151.6],
        ["Land_LampHalogen_F", [29.416, 25.168, 0], 44.6477],
        ["Land_HBarrierWall6_F", [-36.3672, 11.793, 0], 92.7763],
        ["Land_HBarrierWall6_F", [-36.6836, -12.4551, 0], 92.7763],
        ["Land_GarbageBags_F", [26.6934, 31.3965, 2.38419e-07], 179.648],
        ["Land_CanisterFuel_F", [22.2148, -33.7793, 2.02656e-05], 213.014],
		["Land_HBarrier_5_F",[42.7012,1.18945,0],180.152],
        ["Land_CncWall4_F",[35.7637,-19.6133,0],270],
        ["Land_Wall_IndCnc_4_F",[30.084,28.373,4.76837e-07],89.6477],
        ["Land_CanisterFuel_F",[22.1133,-34.1914,8.82149e-06],243.093],
        ["Land_Wall_IndCnc_4_F",[-11.7949,40.0664,4.76837e-07],89.6477],
        ["Land_CncBarrierMedium_F",[13.125,-38.623,0],63.0701],
        ["Land_CncBarrierMedium_F",[30.6641,-27.6113,0],48.0701],
        ["Land_CncWall1_F",[32.0352,-26.3008,0],345],
        ["Land_CratesWooden_F",[-18.8828,-37.2676,0],270],
        ["Land_HBarrier_5_F",[42.543,-11.1855,0],180.152],
        ["Land_Pallets_F",[23.0293,-33.6992,0],122.228],
        ["Land_CncWall1_F",[33.1973,-25.916,0],330],
        ["Land_CncWall1_F",[35.6172,-22.9063,0],285],
        ["Land_CncBarrierMedium4_F",[5.78711,-41.6992,0],125.868],
        ["Land_Pallets_stack_F",[26.1445,33.127,0],239.648],
        ["Land_Tank_rust_F",[28.3711,31.2695,0],89.6477],
        ["Land_CncWall1_F",[34.2656,-25.1367,0],315],
        ["Land_HBarrierWall6_F",[-36.2578,20.041,0],92.7763],
        ["Land_CncWall1_F",[35.0742,-24.0898,0],300],
        ["Land_CncWall4_F",[-31.1641,-28.498,0],180],
        ["Land_Research_house_V1_F",[26.1563,-32.709,0],18.0701],
        ["Land_CncBarrierMedium_F",[14.2188,-40.1797,0],48.0701],
        ["Land_CncBarrierMedium_F",[31.0957,-29.2246,0],93.4759],
        ["Land_HBarrier_5_F",[-41.127,-0.988281,0],135.749],
        ["Land_HBarrierWall6_F",[-36.791,-20.7051,0],92.7763],
        ["Land_CratesShabby_F",[-18.6328,-39.2598,0],165],
        ["Land_HBarrier_5_F",[-45.2539,3.0625,0],45.7493],
        ["Land_CncWall1_F",[-8.84961,-42.7617,0],255],
        ["Land_PaperBox_closed_F",[18.0156,-40.0215,0],85.2511],
        ["TrashBagHolder_01_F",[43.8555,-5.42773,-0.000978231],270.128],
        ["Land_CncBarrierMedium_F",[15.625,-41.4082,0],33.0701],
        ["Land_PaperBox_closed_F",[20.0938,-39.5801,0],69.1581],
        ["Land_Research_HQ_F",[17.8105,39.4277,0],179.648],
        ["Land_Pallet_MilBoxes_F",[-40.9102,-17.959,0],277.537],
        ["TrashBagHolder_01_F",[44.4434,-5.45117,-0.000990391],89.9213],
        ["Land_Wall_IndCnc_4_F",[29.9922,34.3242,4.76837e-07],89.6477],
        ["Land_PaperBox_open_empty_F",[21.916,-39.1973,0],345.56],
        ["HazmatBag_01_F",[44.8984,-1.9707,-0.00100136],215.344],
        ["Land_CncBarrierMedium4_F",[29.9219,-33.6855,0],288.07],
        ["Land_Research_house_V1_F",[-15.2383,-42.9238,0],270],
        ["Land_HBarrier_1_F",[44.9258,6.08594,0],270.152],
        ["Land_HBarrierWall6_F",[-39.5703,24.082,0],2.77659],
        ["Land_CncBarrierMedium4_F",[20.1465,-41.2148,0],348.07],
        ["Land_Cargo_Patrol_V3_F",[-41.4336,20.4219,0],180.749],
        ["HazmatBag_01_F",[43.2813,-15.5059,-0.237288],135.382],
        ["Land_CampingTable_white_F",[46.2441,-1.5957,0.0489483],174.382],
        ["Land_Shed_Big_F",[-14.2344,-39.2676,-3.12652],270],
        ["Land_Wall_IndCnc_4_F",[-11.8066,43.7871,4.76837e-07],269.648],
        ["Land_HBarrier_3_F",[45.6543,9.19727,0],90.1519],
        ["Land_CncWall4_F",[-36.4141,-28.498,0],180],
        ["Land_CampingChair_V2_white_F",[46.5938,-1.84961,0.0062933],176.875],
        ["Land_CncWall4_F",[-8.61328,-45.8613,0],270],
        ["Land_HBarrier_1_F",[46.4141,6.08789,0],150.152],
        ["Land_Cargo10_light_blue_F",[-9.32617,45.9434,-1.43051e-06],179.648],
        ["Land_DeconTent_01_IDAP_F",[46.6875,-4.57617,-1.2745],90.1519],
        ["Land_CncBarrierMedium4_F",[0.703125,-46.9453,0],141.946],
        ["Land_Cargo_Patrol_V3_F",[-42.7207,-20.3086,0],0.749299],
        ["Land_CncShelter_F",[24.9277,-40.0996,0],348.07],
        ["Land_HBarrierWall6_F",[-40.8379,-24.2656,0],182.776],
        ["Land_HBarrier_5_F",[45.6875,14.832,0],90.1519],
        ["Land_PaperBox_closed_F",[20.7246,-42.6309,0],350.954],
        ["Land_CncBarrierMedium_F",[28.1895,-38.1152,0],303.07],
        ["Land_MetalBarrel_F",[22.0977,-42.1738,1.66893e-06],312.582],
        ["Land_CncBarrierMedium_F",[26.8145,-39.4258,0],333.07],
        ["Land_Research_HQ_F",[-26.0313,-40.5977,0],270],
        ["Land_GarbageContainer_open_F",[15.3965,46.4941,0.493507],271.703],
        ["Land_CncWall1_F",[-39.5488,-28.6113,0],165],
        ["Land_HBarrier_5_F",[45.7031,20.332,0],90.1519],
        ["TrashBagHolder_01_F",[44.7148,-20.4473,-0.000984192],90.6421],
        ["Tarp_01_Large_Yellow_F",[49.041,-4.56055,0.0235786],90.1519],
        ["Snake_random_F",[-48.9004,6.06055,0.0083878],16.7904],
        ["Land_Wall_IndCnc_4_F",[29.9551,40.3242,4.76837e-07],89.6477],
        ["StretcherRollerSystem_01_F",[49.5781,-1.33008,0.0019486],90.0935],
        ["Land_DeconTent_01_IDAP_F",[46.6523,-17.5762,-1.2745],90.1519],
        ["DeconShower_01_F",[46.6367,-17.5938,-0.00684166],89.9549],
        ["Land_CncWall1_F",[-8.75977,-49.1543,0],285],
        ["Land_Research_house_V1_F",[6.78516,48.4395,2.38419e-07],179.648],
        ["Land_CncWall1_F",[-40.7129,-28.9961,0],150],
        ["Tarp_01_Small_Yellow_F",[49.875,5.20117,0],165.152],
        ["Land_Cargo10_cyan_F",[11.5488,48.7891,-4.76837e-07],89.6487],
        ["Sponge_01_dry_F",[49.9688,5.39648,-0.000989914],47.2695],
        ["Land_CncBarrierMedium4_F",[-5.90039,-50.0117,4.76837e-07],346.851],
        ["Land_Pallet_vertical_F",[-20.0078,-46.2695,4.76837e-07],180.007],
        ["HazmatBag_01_roll_F",[50.2207,4.96875,-0.000966549],269.988],
        ["Broom_01_yellow_F",[50.2207,5.21875,-0.00151229],105.181],
        ["Sponge_01_dry_F",[50.3477,5.5918,-0.000999928],270.152],
        ["Land_Tyres_F",[15.9648,48.2676,0.00659752],344.648],
        ["Land_CratesWooden_F",[-10.5059,49.791,2.38419e-07],89.6477],
        ["Land_CinderBlocks_F",[-4.9707,50.7305,7.15256e-07],179.643],
        ["HazmatBag_01_roll_F",[50.7207,5.2168,-0.000965118],135.086],
        ["Land_Sacks_goods_F",[-8.96289,50.1934,2.38419e-07],89.6477],
        ["Land_CncWall1_F",[-8.98438,-51.5078,0.647342],300],
        ["Land_MetalBarrel_F",[-37.6328,-34.7676,1.43051e-06],179.973],
        ["Land_PaperBox_open_empty_F",[-18.8828,-47.6426,0],176.71],
        ["Land_PaperBox_closed_F",[-51.0293,-5.49414,0],282.537],
        ["Land_CncWall1_F",[-41.7793,-29.7754,0],135],
        ["Land_PaperBox_closed_F",[-51.2578,-3.6875,0],336.537],
        ["StretcherRollerSystem_01_F",[49.4531,-14.3301,0.00195599],89.8646],
        ["Land_GarbageBags_F",[-30.2422,-41.4336,0],270],
        ["Land_Sacks_goods_F",[-51.4766,-2.23438,0],336.537],
        ["Land_Garbage_square5_F",[16.2285,48.9375,2.38419e-07],89.6477],
        ["Land_Pallets_stack_F",[-3.10938,51.4805,-2.38419e-07],254.648],
        ["Land_Research_house_V1_F",[-35.1563,-36.7988,0],90],
        ["Land_HBarrier_5_F",[47.5059,-24.8242,0],180.152],
        ["Tarp_01_Large_Yellow_F",[49.0059,-17.5605,0.0235786],90.1519],
        ["Land_Wall_IndCnc_4_F",[-11.8438,49.7891,4.76837e-07],269.648],
        ["Land_CncWall1_F",[-10.1113,-51.3848,0],315],
        ["Land_MetalBarrel_F",[-38.0078,-35.7676,1.43051e-06],103.894],
        ["Land_Tyre_F",[18.0254,49.1172,-0.00430441],89.9203],
        ["HazmatBag_01_roll_F",[52.0254,-6.44336,-0.000967026],240.131],
        ["Land_CinderBlocks_F",[-5.10352,52.2285,3.09944e-06],194.641],
        ["Land_GarbageWashingMachine_F",[20.1465,48.4863,2.38419e-07],254.648],
        ["HazmatBag_01_roll_F",[52.0879,-6.79883,-0.000967741],165.108],
        ["Land_CratesWooden_F",[-52.4082,3.56836,0],276.537],
        ["Land_CncWall1_F",[-42.5879,-30.8223,0],120],
        ["Land_HBarrierWall6_F",[-47.8184,24.1895,0],2.77659],
        ["Land_CratesWooden_F",[-9.98633,51.8145,2.38419e-07],179.648],
        ["Land_CampingTable_small_white_F",[48.7363,-20.6191,0.00160193],89.5611],
        ["Land_Shed_Small_F",[-11.6836,42.2441,0],359.648],
        ["Land_PaperBox_open_empty_F",[-51.8027,11.5605,0],203.537],
        ["Land_Pallets_stack_F",[22.1758,48.2441,0.0411468],345.864],
        ["Land_CncWall1_F",[-11.1777,-52.1641,0],330],
        ["Broom_01_yellow_F",[52.8086,-5.9668,-0.00151134],165.152],
        ["Land_Garbage_square5_F",[53.2324,3.27539,0],90.1519],
        ["HazmatBag_01_empty_F",[53.1777,-5.70703,-0.00224018],135.161],
        ["Land_CncWall1_F",[-43.1309,-32.0059,0],105],
        ["Land_CampingChair_V2_white_F",[49.5234,-20.709,-0.000994682],120.095],
        ["Land_CncWall1_F",[-12.3418,-52.5488,0],345],
        ["Land_HBarrier_5_F",[-53.2734,-4.92383,0],90.7493],
        ["Land_GarbageContainer_closed_F",[18.0859,50.6875,-0.219586],182.927],
        ["Land_CampingChair_V2_white_F",[53.3184,-7.47852,-0.000995159],276.592],
        ["Land_FieldToilet_F",[53.5527,-8.09375,-0.000965118],195.192],
        ["Land_HBarrier_5_F",[-54.1816,2.08984,0],90.7493],
        ["SpinalBoard_01_orange_F",[54.1816,-2.0332,0.0379865],56.5873],
        ["Land_CratesPlastic_F",[20.3301,50.2656,2.38419e-07],359.648],
        ["Land_Cargo10_cyan_F",[-35.0078,-41.3926,2.86102e-06],359.999],
        ["LayFlatHose_01_Roll_F",[52.1855,-15.0723,0],345.152],
        ["Land_Wall_IndCnc_4_F",[29.918,46.3223,4.76837e-07],89.6477],
        ["Land_Pallet_MilBoxes_F",[-52.3984,14.1113,0],336.537],
        ["Land_HBarrier_5_F",[-54.1133,7.33789,0],90.7493],
        ["Land_IronPipes_F",[-5.37305,53.9219,4.76837e-07],14.6477],
        ["Land_Research_HQ_F",[52.4121,12.3594,0],270.152],
        ["Land_HBarrierWall6_F",[-49.0859,-24.1582,0],182.776],
        ["Land_CncWall4_F",[-15.4766,-52.6621,0],6.83019e-06],
        ["PressureHose_01_Roll_F",[53.0273,-14.3848,-0.0467184],300.152],
        ["Land_HBarrier_5_F",[-53.3438,-10.4219,0],90.7493],
        ["Land_HBarrier_5_F",[-54.043,12.5879,0],90.7493],
        ["Land_HBarrier_5_F",[-53.002,-3.66992,0],180.749],
        ["Land_CncWall1_F",[-18.7695,-52.5156,0],15],
        ["Land_FieldToilet_F",[54.6816,-9.625,1.43051e-06],240.151],
        ["Land_HBarrier_1_F",[50.5039,-23.2109,0],90.1519],
        ["Land_CncWall4_F",[-43.2773,-35.2988,0],90],
        ["Land_HBarrier_3_F",[51.3125,-26.2832,0],255.152],
        ["Land_Wall_IndCnc_4_F",[-11.8809,55.7871,4.76837e-07],269.648],
        ["Land_Pallet_F",[-34.8828,-46.3926,-2.38419e-07],69.292],
        ["Land_HBarrier_5_F",[51.2441,-31.4609,0],270.152],
        ["Land_Cargo_House_V3_F",[-57.5762,-7.86719,0],90.7493],
        ["Land_CncWall4_F",[-43.2773,-40.5488,0],90],
        ["Land_Pallets_F",[-36.873,-46.9238,0],315.074],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[59.0879,5.39258,0],286.152],
        ["Land_CncWall1_F",[-28.127,-52.5508,0],345],
        ["Land_Wall_IndCnc_4_F",[29.9023,52.4141,4.76837e-07],89.6477],
        ["Land_BagFence_Short_F",[-20.627,-56.1035,-0.0010004],270],
        ["Land_PaperBox_01_small_closed_white_IDAP_F",[59.5879,4.66016,-7.15256e-07],157.153],
        ["Land_HBarrierWall6_F",[-55.8184,24.2949,0],2.77659],
        ["C_Truck_02_transport_F",[-4.40039,60.0938,-0.0155764],104.649],
        ["Land_Sack_F",[-59.5898,-10.0898,0],311.537],
        ["C_IDAP_Truck_02_F",[55.1328,-24.832,-0.015018],0.153049],
        ["Land_Cargo_Tower_V3_F",[-60.7598,3.75,0],270.749],
        ["Land_PaperBox_01_open_boxes_F",[60.7148,5.63672,0.000932693],40.1515],
        ["Land_PaperBox_open_empty_F",[-37.1328,-48.3926,0],281.71],
        ["Land_CncWall4_F",[-31.2266,-52.6621,0],6.83019e-06],
        ["Land_BagFence_Short_F",[-25.9883,-55.9063,-0.0010004],255],
        ["Land_PaperBox_closed_F",[60.959,9.13477,0],272.152],
        ["Land_BagFence_Round_F",[-21.168,-58.1953,-0.00130081],315],
        ["Land_HBarrier_5_F",[59.6973,18.2949,0],90.1519],
        ["Land_HBarrier_3_F",[57.3438,20.2793,0],0.151884],
        ["Land_PaperBox_01_open_water_F",[61.9688,7.38477,0.000928402],350.154],
        ["Land_CncWall4_F",[-43.2773,-45.7988,0],90],
        ["Land_HBarrier_5_F",[56.9902,-31.2246,0],180.152],
        ["Land_BagFence_Short_F",[-23.2676,-58.6406,-0.0010004],0],
        ["Land_BagFence_Round_F",[-25.3594,-58.1016,-0.00130081],45],
        ["CargoNet_01_barrels_F",[63.0879,5.38086,-7.15256e-07],97.1519],
        ["Land_PortableLight_double_F",[63.0898,7.9668,0],330.152],
        ["Land_CncWall4_F",[-36.4766,-52.6621,0],6.83019e-06],
        ["Land_Wall_IndCnc_4_F",[-11.9707,61.7402,4.76837e-07],269.648],
        ["Land_HBarrier_5_F",[-65.5469,11.9863,0],0.749299],
        ["Land_MetalBarrel_F",[64.0918,6.62891,1.43051e-06],210.152],
        ["Land_BagBunker_Large_F",[-57.8398,-29.1895,0],0.749299],
        ["Land_Wall_IndCnc_4_F",[29.8828,58.248,4.76837e-07],89.6477],
        ["Land_PortableLight_double_F",[-41.4941,-49.707,0],240],
        ["Land_DischargeStick_01_F",[64.4688,7.12695,-0.000720263],315.152],
        ["Land_Cargo20_military_green_F",[7.31055,64.5449,0],179.648],
        ["Land_MetalBarrel_F",[64.6777,6.17383,1.43051e-06],210.152],
        ["Land_CncWall1_F",[-43.1641,-48.9336,0],75],
        ["Land_CratesWooden_F",[-65.0137,-4.51758,0],213.537],
        ["Land_Pallets_stack_F",[13.2188,63.9629,0],359.648],
        ["Land_HBarrier_5_F",[59.248,-29.9824,0],270.152],
        ["Land_CncWall1_F",[-39.7695,-52.5156,0],15],
        ["Land_Wall_IndCnc_4_D_F",[-1.99219,66.0039,2.38419e-07],179.648],
        ["Land_CncWall1_F",[-42.7793,-50.0957,0],60],
        ["Land_CncWall1_F",[-40.9531,-51.9727,0],30],
        ["Land_CncWall1_F",[-42,-51.1641,0],45],
        ["Land_HBarrier_5_F",[-65.4922,6.20313,0],270.749],
        ["Land_PaperBox_open_full_F",[-65.9004,3.98438,0],353.537],
        ["Land_Wall_IndCnc_4_F",[3.94141,66.0313,4.76837e-07],179.648],
        ["Land_Wall_IndCnc_Pole_F",[-6.07422,65.9629,4.76837e-07],359.648],
        ["Land_Cargo20_red_F",[21.4473,62.7578,9.53674e-07],269.648],
        ["Land_Pallets_stack_F",[14.8105,64.7168,-2.38419e-07],359.648],
        ["Land_CratesShabby_F",[13.5664,65.0625,2.38419e-07],269.648],
        ["Land_CratesPlastic_F",[12.6719,65.2754,2.38419e-07],89.6477],
        ["Land_Wall_IndCnc_4_F",[-10.1426,65.8848,4.76837e-07],359.648],
        ["Land_Sack_F",[-66.5078,-3.74805,0],311.537],
        ["Land_Wall_IndCnc_4_F",[9.94141,66.0684,4.76837e-07],179.648],
        ["Land_Cargo20_grey_F",[-64.9219,-16.5195,-4.76837e-07],53.5483],
        ["Land_Cargo20_grey_F",[24.1973,62.7754,0],269.648],
        ["Land_CratesPlastic_F",[-67.4063,4.01367,0],146.537],
        ["Land_Pallet_MilBoxes_F",[-67.2695,5.57617,0],325.537],
        ["Land_Wall_IndCnc_4_F",[15.9414,66.1035,4.76837e-07],179.648],
        ["Land_HBarrier_5_F",[62.4902,-31.2383,0],180.152],
        ["Land_PaperBox_closed_F",[-67.5996,7.27148,0],78.5373],
        ["Land_Research_house_V1_F",[63.2539,-26.9727,0],180.152],
        ["Land_BagBunker_Large_F",[-62.8125,29.5332,0],180.749],
        ["Land_Wall_IndCnc_4_F",[21.9414,66.1406,4.76837e-07],179.648],
        ["Land_HBarrierWall6_F",[-65.334,-23.9453,0],182.776],
        ["Rabbit_F",[66.0957,-21.8672,0.00223756],66.0864],
        ["Land_Wall_IndCnc_4_F",[29.832,62.0449,4.76837e-07],269.648],
        ["C_IDAP_Heli_Transport_02_F",[70.1738,-6.9043,-0.100193],15.153],
        ["Land_Wall_IndCnc_4_F",[27.9414,66.1777,4.76837e-07],179.648],
        ["Land_HelipadCivil_F",[71.3086,-5.27148,0],90.1519],
        ["Land_LampHalogen_F",[28.9453,65.166,0],314.648],
        ["Land_HBarrier_3_F",[65.6055,-31.2285,0],180.152],
        ["Land_Cargo20_white_F",[-69.7305,17.0449,0],276.827],
        ["Land_PaperBox_01_open_empty_F",[67.7559,-25.7559,0.000932932],67.1515],
        ["Land_PaperBox_01_open_empty_F",[67.875,-28.0059,0.000929356],307.152],
        ["Land_HBarrier_1_F",[66.7383,-31.2598,0],15.1519],
        ["Land_Cargo20_light_blue_F",[-73.7637,14.5977,0],258.894],
        ["Land_HBarrierWall6_F",[-72.0664,24.5078,0],2.77659],
        ["HazmatBag_01_F",[74.2285,-14.1777,2.38419e-06],354.791],
        ["Land_PlasticCase_01_large_CBRN_F",[74.1582,-15.2734,2.14577e-06],345.202],
        ["HazmatBag_01_F",[75.0176,-13.9707,-1.66893e-06],296.08],
        ["Land_HBarrierWall6_F",[-73.334,-23.8398,0],182.776],
        ["HazmatBag_01_F",[75.8984,-17.457,-0.173882],117.341],
        ["Land_Cargo_House_V3_F",[-79.2227,-2.83008,0],270.749],
        ["Land_Cargo_House_V3_F",[-79.1074,5.91797,0],270.749],
        ["TapeSign_F",[77.418,-14.5293,0],180.152],
        ["ContainmentArea_03_yellow_F",[77.2891,-16.2852,0],270.152],
        ["Box_IND_AmmoVeh_F",[77.3027,-16.4746,0.140796],268.965],
        ["ContainmentArea_03_yellow_F",[77.2832,-18.7852,0],270.152],
        ["Box_IND_AmmoVeh_F",[77.2988,-18.9766,0.140619],268.974],
        ["Land_HBarrier_5_F",[-82.1836,1.70313,0],0.749299],
        ["TapeSign_F",[77.4023,-20.4043,0],180.152],
        ["CBRNContainer_01_closed_yellow_F",[79.1621,-14.1621,-2.38419e-07],205.13],
        ["Land_HBarrier_5_F",[-82.5469,-7.04297,0],0.749299],
        ["Land_HBarrier_5_F",[-82.3223,10.2051,0],0.749299],
        ["Land_Pallet_MilBoxes_F",[-77.8965,21.5273,0],277.537],
        ["CBRNContainer_01_closed_yellow_F",[79.5352,-14.6621,0],270.132],
        ["LayFlatHose_01_Roll_F",[80.0273,-14.0293,0],345.152],
        ["Land_MetalCase_01_medium_F",[80.1582,-15.1641,0],195.151],
        ["Land_Cargo_Patrol_V3_F",[-79.1895,20.166,0],180.749],
        ["Land_Antibiotic_F",[80.2969,-15.7148,0],90.1528],
        ["Land_HBarrier_5_F",[82.4707,7.25781,0],240.152],
        ["Land_Cargo_Patrol_V3_F",[-79.7207,-20.0742,0],0.749299],
        ["Land_Defibrillator_F",[80.7969,-15.7168,0],330.153],
        ["Land_HBarrierWall6_F",[-80.3164,24.6152,0],2.77659],
        ["Land_HBarrier_5_F",[83.9141,2.1543,0],255.152],
        ["Land_HBarrierWall6_F",[-84.6816,-3.44336,0],272.777],
        ["Land_HBarrierWall6_F",[-84.5742,4.80469,0],272.777],
        ["Land_HBarrier_5_F",[84.0742,1.32422,0],90.1519],
        ["Land_HBarrier_5_F",[80.1387,-23.9902,0],300.152],
        ["Land_HBarrier_5_F",[84.0586,-4.17578,0],90.1519],
        ["Land_HBarrierWall6_F",[-84.7871,-11.4434,0],272.777],
        ["Land_HBarrierWall6_F",[-84.4688,12.8047,0],272.777],
        ["Land_HBarrier_5_F",[84.0449,-9.67578,0],90.1519],
        ["Land_HBarrier_5_F",[82.6953,-19.3438,0],285.152],
        ["Land_HBarrierWall6_F",[-81.584,-23.7324,0],182.776],
        ["Land_HBarrierWall6_F",[-84.8945,-19.6934,0],272.777],
        ["Land_HBarrierWall6_F",[-84.3613,21.0547,0],272.777]
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
			_finalTerrainCheck = _safePos isFlatEmpty [120, -1, 0.5, 15, 0, false];
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
							_testFlat = _testPos isFlatEmpty [100, -1, 0.4, 10, 0, false];
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
					private _veryRelaxedCheck = _safePos isFlatEmpty [80, -1, 0.8, 5, 0, false];
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

		private _groupDistanceFromCampMin = 30;
		private _groupDistanceFromCampMax = 120;

		private _numGroupsToSpawn = _staticGroupCountMin + floor random ((_staticGroupCountMax - _staticGroupCountMin) + 1);

		for "_groupIdx" from 1 to _numGroupsToSpawn do {
			private _groupBasePositionFound = false;
			private _groupBasePos = _campPos;

			for "_attempt" from 1 to 80 do {
				private _groupDist = _groupDistanceFromCampMin + random (_groupDistanceFromCampMax - _groupDistanceFromCampMin);
				private _tryGroupPos = _campPos getPos [_groupDist, random 360];

				if (count (_tryGroupPos isFlatEmpty [5, -1, 1, 10, 0, false]) > 0) then {
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

					for "_j" from 1 to 80 do {
						private _tryPos = _groupBasePos getPos [(random 10), random 360];
						if (count (_tryPos isFlatEmpty [1, -1, 1, 3, 0, false]) > 0) then {
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

		private _numVehicles = 5 + floor random ((3 - 1) + 1);

		for "_v" from 1 to _numVehicles do {
			private _vehClass = selectRandom _vehicleTypes;
			private _vehPos = [];
			private _vehFound = false;
			private _vehDir = random 360;

			for "_t" from 1 to 20 do {
				private _dist = if (_vehClass isKindOf "Helicopter") then { 110 + random 60 } else { 110 + random 60 };
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
					private _dist = 120 + random 40;
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
		
				//==========Armored Vehicle Spawning==========//
		
		if (random 1 < _armoredSpawnChance) then {

			private _spawnedArmoredVehicle = false;

			if (!_spawnedArmoredVehicle) then {
				private _vehClass = selectRandom _armoredVehicleTypes;
				private _vehPos = [];
				private _vehFound = false;
				private _vehDir = random 360;

				for "_t" from 1 to 20 do {
					private _dist = 120 + random 40;
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
				private _dist = 20 + random 60;
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
			private _patrolRadius = 80+ random (100);
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

		
		

		//ARSENAL BOX SPAWNER - SIMPLIFIED VERSION
		// Make sure _campPos is defined before running this script
		// If not defined, uncomment the line below and set your position
		// _campPos = getPos player; // or your desired position

		// Define spawn position around camp
		private _spawnDistance = 30; // meters from camp position
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
		_objectData set ["aa1", ["I_LT_01_AA_F", "", [110, 160]]];
		private _basePosition = _campPos;

		// Min and max number of objects to spawn
		private _minObjectsToSpawn = 2;
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
	// === CIVILIAN SPAWNING === //
				private _civilianTypes = [
					"C_IDAP_Man_UAV_06_antimine_F",
					"C_Man_Paramedic_01_F",
					"C_scientist_F",
					"C_journalist_F",
					"C_Journalist_01_War_F",
					"C_scientist_02_formal_F",
					"C_scientist_01_formal_F"
					];
				private _numCivilians = 2 + floor random 2;


				if (_numCivilians > 0) then {
					private _civilianGroup = createGroup [civilian, true];

					for "_i" from 1 to _numCivilians do {
						private _civilianType = selectRandom _civilianTypes;
						private _civilianPos = [];
						private _foundCivPos = false;

						for "_k" from 1 to 40 do {
							private _tryPos = _campPos getPos [(random 50), random 360];
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

							_civilian setVariable ["isPotentialHVT", true, true];

							private _checkCivilian = _civilian; // Reference to the civilian for the spawned script
							private _proximityCheckScript = _checkCivilian spawn {
								
								params ["_civ"];

								
								while {true} do {
									
									if (isNull _civ || !(_civ getVariable ["isPotentialHVT", false])) exitWith {};

									private _playerNear = false;
									
									{
										if (alive _x && (_civ distance _x) <= 2) then {
											_playerNear = true;
										};
									} forEach allPlayers;

									if (_playerNear) then {
										_civ setCaptive false;
										_civ enableAI "MOVE";

										
										_civ setVariable ["isPotentialHVT", false, true];

										
										{ _x sideChat "HVT Found!"; } forEach allPlayers;

										
										private _crashSurvivorsLeft = 0;
										{
											
											if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialHVT", false])) then {
												_crashSurvivorsLeft = _crashSurvivorsLeft + 1;
											};
										} forEach allUnits;

										
										{ _x sideChat format ["HVTs left: %1", _crashSurvivorsLeft]; } forEach allPlayers;

										if (_crashSurvivorsLeft == 0) then {
										
											player sideChat "Side Objective Complete: All HVTs Found";
											
											//add xp/coins
											[500] execVM "addXP.sqf";
											[25] execVM "addCredits.sqf";
											
											//-1 side mission from fobSystems.sqf
											private _currentActiveMissions = missionNamespace getVariable ["activeSideMissions", 0];
											missionNamespace setVariable ["activeSideMissions", _currentActiveMissions - 1, true];
										};

										break;
								   };
									sleep 2;
								};
							};
						};
					};

			private _totalInitialcrashSurvivors = 0;
			{
				
				if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialHVT", false])) then {
					_totalInitialcrashSurvivors = _totalInitialcrashSurvivors + 1;
				};
			} forEach allUnits;
			{ _x sideChat format ["Total potential HVTs in mission: %1", _totalInitialcrashSurvivors]; } forEach allPlayers;
		};
		
		

//=== END Object Destruction Check System ===//

		//==========End New Systems Here==========//

		_spawned = true;
		
				//=== Start Object Destruction Check System ===//

		//Must be placed at end of scripts after... _spawned = true;
		//Make sure object is Destroyable

		if (_spawned) then {
			// objects to watch
			_watchClasses = [
				"Land_Device_disassembled_F"
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
							player sideChat "Objective Complete: Secret Device Destroyed";
							["High Command", "GOOD WORK SOLDIER. THATS ALL THE MISSIONS WE HAVE FOR NOW. YOU ARE DISMISSED! "] remoteExec ["BIS_fnc_showSubtitle", 0, true];
							nul = [] execVM "missionCompleteScreen.sqf";
							
							[5000] execVM "addXP.sqf";
							[200] execVM "addCredits.sqf";
							break;
						};
						
						sleep 5; 
					};
				};
			};
		};
		
		
		player sideChat "New Objective: Find and Destroy the Secret Device";
		nul = [] execVM "missionBriefings\researchMissionBrief.sqf";
		
			};
};