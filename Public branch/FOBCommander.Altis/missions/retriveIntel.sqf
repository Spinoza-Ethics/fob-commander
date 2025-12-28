//==========General Settings ==========//

private _markerNameText = "Intel";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 2; //Default 2
private _staticGroupSizeMax = 8; //Default 8
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
    // First emplacement
    [
        ["Land_WoodPile_F",[-1.28516,2.62695,0],292.763],
        ["Land_CampingChair_V1_F",[3.53613,2.54883,0.00309181],241.14],
        ["Land_Can_V3_F",[3.53809,2.97461,1.90735e-06],246.193],
        ["Land_CampingChair_V1_F",[3.08301,3.47461,0.00960922],266.472],
        ["Land_CampingTable_F",[3.77734,3.23047,0.0106602],243.838],
        ["Land_Garbage_square5_F",[4.25391,3.29883,0],246.134],
        ["Land_Can_Dented_F",[3.47754,4.28906,-0.000196457],246.13],
        ["Land_Ammobox_rounds_F",[3.57031,4.43164,-0.000167847],358.338],
        ["Land_CampingTable_F",[4.50586,3.58008,-0.00190353],63.8398],
        ["Land_FoodContainer_01_F",[3.91895,4.5918,0],0.00433724],
        ["Land_Can_V1_F",[-0.732422,6.22852,1.90735e-06],359.916],
        ["Land_Can_V2_F",[-0.65332,6.30469,1.90735e-06],359.919],
        ["Land_Can_Rusty_F",[-0.725586,6.34961,1.90735e-06],359.838],
        ["Land_CampingChair_V1_F",[5.58105,3.32617,0.0030899],78.1479],
        ["Land_FMradio_F",[-0.584961,6.51563,0],50.7598],
        ["Land_CampingChair_V1_F",[5.04883,4.44141,0.0030899],38.9618],
        ["Land_WoodenLog_F",[-0.935547,6.73047,9.53674e-06],359.99],
        ["Land_Garbage_square5_F",[-1.47559,7.55273,0],0],
        ["Campfire_burning_F",[0.636719,8.29492,0.0299988],0],
        ["Land_JunkPile_F",[-6.72363,5.35352,0],0],
        ["Land_Ground_sheet_folded_F",[-4.55566,7.89453,2.47955e-05],53.3025],
        ["Land_CampingChair_V1_folded_F",[7.04004,5.84375,0],0],
        ["Land_LuggageHeap_02_F",[6.5166,6.58203,0],136.51],
        ["Land_Camera_01_F",[6.1084,7.08594,-7.62939e-06],125.152],
        ["Land_GarbagePallet_F",[-7.87402,6.70313,0],0],
        ["Land_Sacks_goods_F",[7.73047,6.98047,0],245.308],
        ["Land_Ground_sheet_OPFOR_F",[-4.13867,9.72656,0],287.316],
        ["Land_Sleeping_bag_blue_folded_F",[-4.85254,9.80469,1.90735e-06],137.557],
        ["Land_CampingChair_V1_folded_F",[8.50684,7.75781,0],91.1399],
        ["Land_Pillow_F",[-4.19238,10.9004,-5.72205e-06],359.987],
        ["Land_Pillow_old_F",[-3.78711,11.1035,-5.72205e-06],64.3101],
        ["Land_Ground_sheet_folded_khaki_F",[-3.86816,11.4004,2.28882e-05],359.98],
        ["Land_Sleeping_bag_folded_F",[-4.4668,11.2129,-0.000961304],276.55],
        ["Land_GasCanister_F",[-4.2793,11.4316,4.57764e-05],332.446],
        ["Land_Garbage_square5_F",[-1.50098,12.1836,0],0],
        ["Land_Ground_sheet_folded_yellow_F",[-3.8916,11.5742,2.28882e-05],359.98],
        ["Land_GasCanister_F",[-4.20898,11.6621,0],332.511],
        ["Land_GasCooker_F",[-4.43164,11.6387,0],332.502],
        ["Land_Garbage_square5_F",[4.44629,11.9922,0],0],
        ["Land_Sleeping_bag_brown_F",[-1.20117,13.1758,0],339.337],
        ["Land_Sleeping_bag_F",[1.12109,13.8418,0],3.53083],
        ["Land_Pillow_grey_F",[-1.53516,13.5371,-0.023777],359.985],
        ["Land_Pillow_old_F",[0.887695,14.0684,-0.0257454],359.989],
        ["Land_Camping_Light_F",[5.77832,13.2617,-0.00121689],359.987],
        ["Land_Bandage_F",[5.04785,13.5801,0],108.241],
        ["Land_Antibiotic_F",[5.19141,13.5781,-1.90735e-06],133.369],
        ["Land_Bandage_F",[4.95996,13.666,0],0.00675207],
        ["Land_Bandage_F",[5.04395,13.7227,0],229.357],
        ["Land_VitaminBottle_F",[5.1709,13.6914,2.09808e-05],359.997],
        ["Land_VitaminBottle_F",[5.13477,13.7793,2.09808e-05],359.997],
        ["Land_Ammobox_rounds_F",[4.87305,13.9082,-0.000167847],359.999],
        ["Land_PlasticCase_01_small_F",[5.53125,13.7402,-1.90735e-06],303.662],
        ["Land_Rope_01_F",[4.73535,14.2637,0],97.3868],
        ["Land_GasTank_01_blue_F",[5.02637,14.334,7.62939e-06],359.997],
        ["Land_GasTank_01_khaki_F",[5.3916,14.6211,7.62939e-06],305.937],
        ["Land_WoodPile_large_F",[-3.07324,16.6016,0.0232067],255.022],
        ["Snake_random_F",[-38.2754,30.2168,0.00836945],113.832]
    ],
    // Second emplacement
    [
        ["Land_CampingChair_V2_F",[0.0419922,1.98633,7.62939e-06],194.976],
        ["Land_CampingChair_V2_F",[-0.831055,1.96094,7.62939e-06],150.001],
        ["Snake_random_F",[-0.523438,-2.57813,0.00838852],58.7715],
        ["Land_WoodenTable_large_F",[-0.360352,2.75,9.53674e-06],105.002],
        ["Snake_random_F",[-0.363281,-3.48633,0.00838852],160.086],
        ["Land_CampingChair_V2_F",[-0.683594,3.47461,7.62939e-06],15.0032],
        ["Land_CampingChair_V2_F",[0.257813,3.60938,5.72205e-06],270.008],
        ["Land_PortableLight_double_F",[-6.8457,0.685547,0],240],
        ["Land_Portable_generator_F",[-6.86133,-0.246094,-0.000799179],240.022],
        ["Land_PaperBox_closed_F",[7.02734,1.12109,-1.71661e-05],120],
        ["Land_WoodenCrate_01_F",[6.36621,3.41016,-0.000989914],0.606404],
        ["Land_Sacks_heap_F",[7.38965,1.625,1.90735e-06],15],
        ["Land_CampingChair_V2_F",[-1.27441,7.89648,9.53674e-06],180.002],
        ["Land_CampingChair_V2_F",[-0.34082,8.27539,1.71661e-05],164.998],
        ["Land_PaperBox_closed_F",[-8.24609,1.50781,0],315],
        ["Land_WoodenCrate_01_stack_x5_F",[8.15527,2.90039,-1.90735e-05],210],
        ["Land_Pallets_F",[8.1416,4.7207,-0.00137901],270],
        ["Land_WoodenTable_large_F",[-0.985352,8.75,9.53674e-06],74.9989],
        ["Land_PaperBox_closed_F",[-8.99219,-0.00976563,0],225],
        ["Land_CampingChair_V2_F",[-1.75098,9.19141,7.62939e-06],345.005],
        ["Land_MetalBarrel_F",[4.26563,8.375,1.33514e-05],99.0081],
        ["Land_MetalBarrel_F",[4.89063,8.625,1.33514e-05],225.01],
        ["Land_CampingChair_V2_F",[-0.557617,9.90039,7.62939e-06],15.0012],
        ["Land_WoodenCrate_01_stack_x5_F",[8.99023,4.39063,3.62396e-05],120],
        ["Land_MetalBarrel_F",[4.26563,9.125,1.33514e-05],299.973],
        ["Land_PaperBox_closed_F",[10.1436,2.63672,-3.8147e-06],30],
        ["Land_PaperBox_closed_F",[10.7773,4.375,-1.52588e-05],105],
        ["Land_CratesWooden_F",[5.13965,10.5,3.8147e-06],60.0001],
        ["Land_PaperBox_open_empty_F",[-8.23633,9,0],315],
        ["Land_HistoricalPlaneWreck_02_front_F",[9.60449,-7.47266,-0.0401936],0.0287938],
        ["Land_WoodenCrate_01_F",[-7.23535,10.375,9.53674e-06],285.001],
        ["Land_WoodenCrate_01_stack_x3_F",[6.17285,12.082,1.14441e-05],225],
        ["Land_PaperBox_closed_F",[-9.40332,10.5039,0],60],
        ["Land_BagFence_01_long_green_F",[-8.23047,11.7559,-0.000999451],30],
        ["Land_Pallet_F",[4.26465,13.875,3.8147e-06],283.513],
        ["Land_BagFence_01_long_green_F",[-6.26465,14.6621,-0.000999451],30],
        ["Land_BagFence_01_round_green_F",[-9.88867,13.5254,-0.00130081],75],
        ["Land_BagFence_01_round_green_F",[-8.7168,15.3809,-0.00126457],165],
        ["Land_HistoricalPlaneWreck_02_rear_F",[13.2891,12.8574,-0.0373497],30.1209]
    ],
    // Third emplacement
    [
        ["Land_Sleeping_bag_blue_folded_F",[-0.916992,1.23828,-0.00135803],300.413],
        ["Campfire_burning_F",[-0.0253906,-1.76758,0.0299988],311.909],
        ["Land_Canteen_F",[-1.34766,1.33398,3.24249e-05],43.4199],
        ["Land_Sleeping_bag_brown_folded_F",[-1.1123,1.77344,-0.00135803],330.481],
        ["Land_PainKillers_F",[-1.47461,1.5918,0],5.09988],
        ["Land_Sleeping_bag_F",[-2.11719,1.24609,0],135.534],
        ["Land_Sleeping_bag_brown_F",[2.5791,0.230469,0],230.312],
        ["Land_Camping_Light_F",[-3.15039,-1.01758,-0.00132751],27.3587],
        ["Land_DuctTape_F",[-2.69336,-2.76953,-3.8147e-06],33.5679],
        ["Land_Canteen_F",[-3.02148,-2.73242,1.71661e-05],73.5163],
        ["Land_Ammobox_rounds_F",[-2.95508,-3.08789,-0.000137329],36.6856],
        ["Land_Sleeping_bag_blue_F",[-3.25,-1.9707,0.000761032],91.1051],
        ["Land_Canteen_F",[1.0332,-4.19922,3.24249e-05],238.433],
        ["Land_Camping_Light_F",[2.72949,-3.38281,-0.00121117],222.335],
        ["Land_Sleeping_bag_F",[3.25879,-2.21289,0],284.138],
        ["Land_Ammobox_rounds_F",[-3.34766,-3.04102,-0.000173569],80.2691],
        ["Land_PainKillers_F",[1.08887,-4.48047,0],200.064],
        ["Land_Sleeping_bag_brown_F",[1.79883,-4.3125,0],330.534],
        ["Land_WoodenCrate_01_stack_x3_F",[6.98242,5.30273,-5.72205e-05],255],
        ["Land_MetalBarrel_F",[5.75781,6.96484,5.72205e-06],288.657],
        ["Land_MetalBarrel_F",[6.56641,6.56445,5.72205e-06],213.659],
        ["Land_Sacks_heap_F",[-10.3135,1.94727,0],312.545],
        ["Land_Sacks_heap_F",[4.2666,-9.70703,0],357.137],
        ["Land_BagFence_01_round_green_F",[-10.6143,-4.50586,-0.00130081],195],
        ["Land_BagFence_01_round_green_F",[-1.6875,-11.5098,-0.00056839],45],
        ["Land_Sacks_heap_F",[4.47461,-10.8926,0],267.137],
        ["Land_MetalBarrel_F",[-11.6504,2.10742,-1.90735e-06],93.6356],
        ["Land_BagFence_01_round_green_F",[-8.02344,-8.80469,-0.00284004],300],
        ["Land_BagFence_01_round_green_F",[3.0918,-11.5547,-0.00130081],315],
        ["Land_BagFence_01_long_green_F",[0.716797,-12.127,-0.00206566],0],
        ["Land_BagFence_01_round_green_F",[-11.8096,3.49805,0.000608444],58.717],
        ["Land_WoodenBox_F",[12.373,0.611328,0],190.202],
        ["I_G_Mortar_01_F",[-10.0254,-7.51758,-0.0384808],344.95],
        ["Land_BagFence_01_round_green_F",[-11.2607,5.64258,-0.00130081],146.309],
        ["Land_Sacks_heap_F",[-12.7451,2.33203,0],254.684],
        ["Land_BagFence_01_round_green_F",[12.6377,4.36133,-0.00118637],208.717],
        ["Land_BagFence_01_round_green_F",[13.2295,2.19531,-0.0039196],296.309],
        ["Land_BagFence_01_round_green_F",[-12.5586,-5.48828,-0.00130081],105],
        ["Land_BagFence_01_round_green_F",[-10.1865,-9.6543,-0.00130081],15],
        ["Land_BagFence_01_long_green_F",[-11.8906,-7.87695,-0.000999451],60],
        ["Snake_random_F",[17.6406,4.85938,0.00838852],327.482]
    ],
    // Fourth emplacement
    [
        ["Land_CanisterPlastic_F",[-0.520508,2.36523,0.000152588],209.477],
        ["Land_BagFence_01_round_green_F",[-1.41504,2.01758,-0.000684738],15],
        ["Land_BagFence_01_end_green_F",[3.39648,0.328125,-0.000822067],240],
        ["Land_BagFence_01_short_green_F",[4.22656,-0.396484,-0.00053978],30],
        ["Land_BagFence_01_round_green_F",[-2.66211,3.87891,-0.00160789],90],
        ["Land_BagFence_01_short_green_F",[5.72559,-0.775391,0.000253677],0],
        ["Campfire_burning_F",[2.4834,6.09766,0.0287228],27.42],
        ["Land_WoodPile_F",[7.38867,0.234375,0],255.172],
        ["Land_BagFence_01_short_green_F",[7.35059,-0.527344,-0.000102997],345],
        ["Land_Axe_fire_F",[7.3584,1.47266,-0.00336075],5.82698],
        ["CamoNet_BLUFOR_open_F",[3.95703,6.23438,-0.000135422],0],
        ["Land_BakedBeans_F",[5.48438,5.92188,1.33514e-05],333.769],
        ["Land_BakedBeans_F",[5.65234,5.90625,9.53674e-06],30.5213],
        ["Land_Garbage_square3_F",[5.28906,6.69727,0],198.821],
        ["Land_BagFence_01_short_green_F",[8.72656,0.21875,-0.000999451],315],
        ["Land_Sleeping_bag_brown_F",[7.19629,4.94531,0],284.138],
        ["Land_Sleeping_bag_brown_F",[1.4043,9.38867,-0.000406265],151.105],
        ["Land_Cliff_stoneCluster_F",[-5.39844,8.59375,0],225],
        ["Land_Canteen_F",[2.2334,10.0977,2.86102e-05],73.3218],
        ["Land_DuctTape_F",[2.56152,10.0605,1.90735e-06],33.5604],
        ["Land_Sleeping_bag_F",[4.44922,8.88086,9.53674e-06],215.312],
        ["Land_Sleeping_bag_F",[7.23926,8.08594,0],337.361],
        ["Land_PicnicTable_01_F",[-3.50391,14.1074,0],270],
        ["Land_PicnicTable_01_F",[4.49707,14.1074,2.67029e-05],270],
        ["Snake_random_F",[-6.55176,-13.3926,0.00838852],159.861],
        ["Land_PicnicTable_01_F",[12.4961,14.1074,0],270],
        ["Rabbit_F",[-10.1885,-44.7988,0.00230026],123.225]
    ],
    // Fifth emplacement
    [
        ["Land_DataTerminal_01_F",[0.201172,3.44434,0],165],
        ["Land_CampingTable_F",[-2.54688,2.5625,0.000537872],344.458],
        ["Land_CampingChair_V1_F",[-2.10352,3.36719,0.00309944],359.981],
        ["Land_CampingChair_V1_F",[-3.17285,2.97852,0.00319672],314.987],
        ["Land_GarbageHeap_02_F",[-4.04297,0.453125,-0.000947952],0],
        ["Land_Sacks_heap_F",[2.08105,4.44824,0],285],
        ["Land_IRMaskingCover_02_F",[-1.62109,5.08203,0],345],
        ["Land_WoodenCrate_01_F",[3.23438,4.35059,1.14441e-05],26.8255],
        ["Land_Pallets_F",[-7.38477,-0.416016,-0.423822],133.068],
        ["Land_WoodenCrate_01_stack_x5_F",[-3.92578,5.97754,3.62396e-05],165],
        ["Land_TripodScreen_01_large_F",[-2.04297,6.82324,5.53131e-05],149.993],
        ["Land_PortableGenerator_01_F",[-0.417969,7.31641,9.53674e-06],239.986],
        ["Land_BagFence_01_end_green_F",[6.01172,4.4043,-0.000488281],150],
        ["Land_PaperBox_closed_F",[-7.17871,2.19043,-1.90735e-05],240],
        ["Land_TripodScreen_01_dual_v1_F",[0.950195,7.80469,0.035862],179.223],
        ["Land_Tyre_F",[-8.23828,1.12695,-0.00430489],1.51956],
        ["Land_WoodenCrate_01_F",[-5.79395,6.44824,5.72205e-06],30.0011],
        ["Land_CratesShabby_F",[-8.54492,1.95605,0],165],
        ["Land_GarbageHeap_01_F",[-8.71973,-0.625977,-1.90735e-06],150],
        ["Land_BagFence_01_round_green_F",[7.24805,5.44141,-0.00297165],300],
        ["Oil_Spill_F",[-9.25586,0.436523,0],0],
        ["Land_GarbageHeap_03_F",[0.0615234,9.29883,-0.00037384],0],
        ["Land_Tyre_F",[-10.5713,-1.24121,-0.00529861],357.257],
        ["Land_BagFence_01_short_green_F",[7.4541,7.59668,-0.00188828],255],
        ["Land_BagFence_01_end_green_F",[4.86914,9.86719,-0.000534058],195],
        ["Land_BagFence_01_round_green_F",[6.36914,9.37598,-0.00124168],210],
        ["Land_SatelliteAntenna_01_F",[-9.66992,6.57324,-0.00387573],240.003],
        ["Land_Pillow_F",[-11.8154,5.02051,-0.023838],0.000573658],
        ["Land_WaterTank_04_F",[-9.04688,9.83789,0.000354767],60],
        ["O_T_Quadbike_01_ghex_F",[-13.2979,-1.64355,-0.0102196],210],
        ["Land_Sleeping_bag_blue_folded_F",[-13.293,2.94824,-3.8147e-06],104.999],
        ["Land_Sleeping_bag_F",[-12.3037,4.95801,0],120],
        ["Land_Pillow_grey_F",[-13.7939,3.19824,-5.72205e-06],135.018],
        ["Land_Ground_sheet_folded_yellow_F",[-13.2939,7.44824,2.28882e-05],74.9767],
        ["Land_Ground_sheet_khaki_F",[-13.5439,8.69727,-1.90735e-06],225],
        ["Land_Sleeping_bag_brown_folded_F",[-14.0439,8.44922,-3.8147e-06],14.9998],
        ["Land_PlasticCase_01_small_F",[-12.415,10.8125,1.90735e-06],210.573],
        ["Campfire_burning_F",[-15.2939,6.19824,0.0299988],0],
        ["Snake_random_F",[-5.62598,-15.666,0.00838852],277.551],
        ["Land_Garbage_square5_F",[-13.6641,9.97852,0.000295639],0],
        ["Land_CampingChair_V1_F",[-13.4199,10.3223,0.0030899],194.971],
        ["Land_Pillow_camouflage_F",[-16.3809,4.43359,-5.72205e-06],359.95],
        ["Land_CampingTable_small_F",[-13.1592,10.8145,0.00260544],196.327],
        ["Land_Sleeping_bag_folded_F",[-13.7783,10.8418,-0.00134659],60.4336],
        ["Land_TinContainer_F",[-13.6846,11.292,0.00122452],45.6658],
        ["Land_Camping_Light_off_F",[-13.5078,11.6025,-0.000375748],90.1997],
        ["Land_Pillow_old_F",[-13.9609,11.3457,-5.72205e-06],75.0366],
        ["Land_Ground_sheet_folded_blue_F",[-16.5439,7.69824,2.28882e-05],44.9726],
        ["Land_Sleeping_bag_F",[-16.2207,9.71484,0],345],
        ["Land_FMradio_F",[-16.7939,9.19824,0],135],
        ["Land_Ground_sheet_folded_yellow_F",[-16.7236,9.55859,2.28882e-05],104.98],
        ["Rabbit_F",[16.5303,40.4961,0.00223732],66.8265]
    ],
    // Sixth emplacement
    [
        ["Land_Sleeping_bag_F",[-0.578125,-1.29688,0.000242233],305.312],
        ["Land_Campfire_F",[-2.6123,-0.456055,0.0299263],311.909],
        ["Land_CanisterPlastic_F",[-0.591797,3.49512,3.8147e-06],144.862],
        ["Land_Canteen_F",[-3.26953,1.57715,2.86102e-05],43.2088],
        ["Land_PainKillers_F",[-3.39648,1.83496,9.53674e-06],5.05035],
        ["Land_Sleeping_bag_brown_F",[-2.7627,-2.58594,0.000665665],359.138],
        ["Land_CanisterPlastic_F",[-0.600586,4.33008,1.90735e-06],204.856],
        ["Land_DuctTape_F",[-4.24023,-1.40039,1.90735e-06],33.5587],
        ["Land_Camping_Light_F",[-4.69727,0.351563,-0.0013237],27.4271],
        ["Land_Canteen_F",[-4.56836,-1.36328,2.86102e-05],73.5635],
        ["Land_Sleeping_bag_F",[-4.03906,1.48828,-6.10352e-05],135.534],
        ["Land_Ammobox_rounds_F",[-4.50195,-1.71875,-0.000164032],36.7612],
        ["Land_Ammobox_rounds_F",[-4.89453,-1.67188,-0.000162125],80.327],
        ["Land_Sleeping_bag_F",[-4.79688,-0.602539,0.000759125],91.1051],
        ["Land_Pallets_stack_F",[7.15723,-0.629883,5.72205e-06],330.748],
        ["Land_GarbageBags_F",[-1.25684,6.35547,0],0],
        ["Land_Pallets_F",[8.30566,1.91309,0.00136566],237.166],
        ["Land_BagFence_01_long_green_F",[5.01563,-5.87891,0.00075531],300],
        ["Land_BagFence_01_round_green_F",[-1.12891,-8.12207,-0.00226021],45],
        ["Land_WoodenCrate_01_stack_x5_F",[-3.27734,8.09473,0],175.519],
        ["Land_BagFence_01_long_green_F",[1.27539,-8.73926,-0.0030365],0],
        ["Land_BagFence_01_round_green_F",[3.65039,-8.16699,-0.00276566],315],
        ["C_IDAP_Van_02_vehicle_F",[-8.7666,-0.94043,0.0902386],167.46],
        ["Land_Cargo_Patrol_V2_F",[3.28613,8.24219,3.8147e-06],180],
        ["Land_BagFence_01_round_green_F",[8.27539,4.45801,-0.00288773],315],
        ["Land_WoodenCrate_01_stack_x5_F",[-1.97754,9.52051,0],131.998],
        ["Land_BagFence_01_long_green_F",[8.89258,6.8623,-0.00101852],270],
        ["Land_FoodContainer_01_White_F",[-11.5781,-0.382813,-1.90735e-06],257.462],
        ["Land_FoodContainer_01_White_F",[-11.7402,-0.802734,-3.8147e-06],32.4645],
        ["Land_FoodContainer_01_White_F",[-12.0664,-0.491211,-3.8147e-06],227.463],
        ["Land_PlasticCase_01_large_idap_F",[-12.2559,0.363281,-5.72205e-06],167.459],
        ["Tire_Van_02_Cargo_F",[-12.1611,1.66504,-3.8147e-06],181.421],
        ["Land_MetalCase_01_medium_F",[-12.2422,-1.42676,-5.72205e-06],272.461],
        ["Land_BagFence_01_round_green_F",[8.32031,9.2373,-0.000360489],225],
        ["Land_BagFence_01_round_green_F",[1.04102,12.6572,0.00124741],135],
        ["Land_CanisterFuel_F",[-12.8955,0.0214844,3.05176e-05],143.884],
        ["Land_CanisterPlastic_F",[-12.8936,-0.802734,1.14441e-05],257.497],
        ["Land_CanisterFuel_F",[-13.002,-0.314453,7.62939e-06],158.864],
        ["Land_PlasticCase_01_medium_idap_F",[-13.083,1.2041,-1.90735e-06],231.596],
        ["Land_BagFence_01_long_green_F",[3.41602,13.2295,0.00102043],180],
        ["Land_PlasticNetFence_01_roll_F",[-13.7529,0.179688,-0.0208263],167.228],
        ["Land_BagFence_01_round_green_F",[5.82031,12.6123,-0.00192642],225],
        ["Land_PlasticNetFence_01_roll_F",[-14.252,0.582031,-0.0208282],182.291],
        ["C_Quadbike_01_F",[-12.6104,6.55762,-0.0105228],137.449],
        ["Headgear_H_Construction_basic_red_F",[-14.3506,-0.100586,-5.53131e-05],287.46],
        ["Snake_random_F",[-20.1895,-15.2363,0.00838852],218.696],
        ["Snake_random_F",[-18.5576,-32.5684,0.00839043],346.701]
    ],
    // Seventh emplacement
    [
        ["Land_AirConditioner_04_F",[-0.172852,2.4834,0],45],
        ["BloodSplatter_01_Medium_New_F",[3.72852,3.08301,0],300],
        ["MedicalGarbage_01_1x1_v1_F",[5.07617,2.2627,3.8147e-05],135],
        ["MedicalGarbage_01_3x3_v1_F",[4.51758,3.50879,0.000127792],135],
        ["Land_Stretcher_01_olive_F",[4.61523,3.6123,0],195],
        ["Land_Stretcher_01_olive_F",[7.24023,3.3623,0],345],
        ["Land_Bandage_F",[7.8623,3.33105,0],104.992],
        ["MedicalGarbage_01_1x1_v3_F",[7.25586,4.70996,3.05176e-05],255],
        ["Land_PainKillers_F",[7.8418,3.76172,0],314.974],
        ["MedicalGarbage_01_5x5_v1_F",[8.2002,3.33496,0],255],
        ["Land_PainKillers_F",[8.00684,3.97949,0],254.998],
        ["Land_FirstAidKit_01_open_F",[8.2373,3.50195,-0.00489235],254.989],
        ["Land_IntravenStand_01_1bag_F",[8.49121,2.73828,3.62396e-05],105.003],
        ["Land_VitaminBottle_F",[8.48633,3.77148,2.09808e-05],314.825],
        ["Land_VitaminBottle_F",[8.58203,3.57227,2.09808e-05],254.803],
        ["Land_VitaminBottle_F",[8.58594,3.72949,2.09808e-05],254.803],
        ["Land_MedicalTent_01_digital_closed_F",[-9.08887,2.1377,7.62939e-06],90.0001],
        ["Land_Stethoscope_01_F",[8.52734,4.11816,-1.90735e-06],225],
        ["Land_CampingChair_V2_F",[5.86621,7.7373,-3.8147e-06],60.0042],
        ["Land_Stretcher_01_olive_F",[9.17188,3.87988,0],345],
        ["Land_CampingChair_V2_F",[4.99121,8.6123,-3.8147e-06],44.9974],
        ["Land_Bodybag_01_folded_black_F",[7.06055,7.6084,-0.0155163],75.0008],
        ["BloodSpray_01_New_F",[9.43457,4.33789,0],255],
        ["Land_Bodybag_01_folded_black_F",[7.11523,8.1123,-0.0191803],119.994],
        ["CamoNet_INDP_big_F",[-10.3105,2.10254,0.00071907],270],
        ["MedicalGarbage_01_3x3_v2_F",[7.6748,8.17383,0],75],
        ["Land_PaperBox_01_small_open_brown_F",[6.11328,9.36133,0],270],
        ["Land_IntravenStand_01_1bag_F",[7.77637,8.16016,3.62396e-05],330.006],
        ["Land_Bodybag_01_black_F",[1.74121,11.2373,-0.0266075],345],
        ["Land_Bodybag_01_folded_black_F",[3.11523,11.1123,-0.0191841],135],
        ["Land_PlasticCase_01_large_gray_F",[7.49121,9.1123,0],44.9985],
        ["Land_PlasticCase_01_small_gray_F",[7.07227,9.4834,-1.90735e-06],44.9974],
        ["Land_Stretcher_01_olive_F",[10.9512,4.48633,0],6.5216e-05],
        ["Land_Bandage_F",[10.8867,5.05078,0],0.00570216],
        ["Land_Bandage_F",[10.9902,4.8623,0],254.997],
        ["Land_IntravenStand_01_empty_F",[8.49121,8.7373,3.24249e-05],45.0068],
        ["Land_Stretcher_01_folded_olive_F",[8.5332,9.44434,0],135],
        ["Land_Stretcher_01_folded_olive_F",[4.85254,11.792,0],30.0002],
        ["Land_Bodybag_01_black_F",[0.115234,12.8623,-0.0265636],15],
        ["Land_Bodybag_01_black_F",[3.24023,12.6123,-0.0266018],330],
        ["Land_Stretcher_01_folded_olive_F",[9.19043,9.29004,0],150],
        ["Land_IntravenStand_01_1bag_F",[12.4912,4.2373,3.24249e-05],60.012],
        ["CamoNet_INDP_big_F",[8.85352,9.40723,-0.140486],90],
        ["Land_Stretcher_01_folded_olive_F",[5.61523,12.3623,0],14.9998],
        ["Land_Bodybag_01_black_F",[4.24316,13.6123,-0.0266132],359.998],
        ["Land_Bodybag_01_empty_black_F",[0.615234,15.3623,-0.0141296],90],
        ["Land_PlasticCase_01_small_idap_F",[14.2402,6.1123,-1.90735e-06],29.9976],
        ["Land_PlasticCase_01_large_gray_F",[14.4912,5.4873,-1.90735e-06],29.9968],
        ["BloodSplatter_01_Small_New_F",[6.61523,14.1152,0],0],
        ["MedicalGarbage_01_1x1_v3_F",[7.45508,13.7041,8.96454e-05],150],
        ["Land_Stretcher_01_olive_F",[6.11523,14.4873,0],360],
        ["Land_DisinfectantSpray_F",[7.23633,13.9961,-0.000839233],0.127247],
        ["MedicalGarbage_01_3x3_v2_F",[6.22852,14.7266,0],0],
        ["Land_FirstAidKit_01_open_F",[6.86133,14.4707,-0.00489235],104.914],
        ["Land_Stethoscope_01_F",[7.36719,14.2461,-1.90735e-06],285],
        ["Land_PainKillers_F",[7.36719,14.5625,0],0.00792869],
        ["Land_PaperBox_01_open_boxes_F",[14.3662,7.7373,0.000928879],240],
        ["Land_BarrelTrash_F",[13.7412,8.8623,3.81]]
    ],
	
	 [
        ["Land_IndFnc_3_F",[-2.1084,-0.335938,0],270],
        ["Land_IndFnc_3_F",[-2.1084,2.66406,0],270],
        ["Land_IndFnc_3_F",[3.7627,-0.214844,0],90],
        ["Land_IndFnc_Corner_F",[-2.1084,-3.25684,0],270],
        ["Land_Net_Fence_Gate_F",[-4.23535,4.28711,0],180],
        ["Land_IndFnc_3_F",[3.76367,2.78613,-0.00247955],90],
        ["Land_IndFnc_Pole_F",[-2.14355,4.16309,0],270],
        ["Land_IndFnc_3_F",[-0.613281,-4.71094,0],180],
        ["Land_IndFnc_3_F",[3.7627,-3.21484,0],90],
        ["Land_IndFnc_Corner_F",[2.30859,-4.71094,0],180],
        ["Land_CratesWooden_F",[-5.98535,0.662109,0],255],
        ["Land_LampShabby_F",[0.873047,-5.22461,0],0],
        ["Land_CratesWooden_F",[-6.11035,-1.46289,0],0],
        ["Land_WoodenTable_small_F",[-4.98535,3.91211,7.62939e-06],180.004],
        ["Land_ChairWood_F",[-5.63574,4.01855,1.90735e-05],301.339],
        ["Land_HBarrier_5_F",[6.89453,-2.71094,-0.00389671],270],
        ["Land_Sacks_heap_F",[-7.11035,-0.0878906,0],255],
        ["Land_BagFence_Short_F",[1.50391,-7.83594,-0.000999451],0],
        ["Land_HBarrier_5_F",[0.263672,-7.95898,0],180],
        ["Land_BagFence_Long_F",[6.87402,-4.7168,-0.000999451],270],
        ["Land_HBarrier_5_F",[6.89355,2.78809,-0.00298119],270],
        ["Land_BagFence_Long_F",[3.76074,-7.82227,-0.000999451],0],
        ["Land_HBarrier_5_F",[-9.48926,1.66113,0],90],
        ["Land_BagFence_Round_F",[6.46875,-7.46191,-0.00130081],315],
        ["Land_MetalBarrel_F",[-0.945313,9.56543,0],300.006],
        ["Land_MetalBarrel_F",[-1.61133,9.66113,0],75.0092],
        ["Land_BagFence_Long_F",[-6.23926,-7.94727,-0.000999451],0],
        ["Land_BarrelSand_F",[1.13867,10.4111,-9.53674e-06],0.00566483],
        ["Land_BagFence_Long_F",[-9.34473,-4.83398,-0.000999451],90],
        ["Land_HBarrier_5_F",[-9.48926,7.16113,0],90],
        ["Land_PaperBox_closed_F",[-0.357422,10.7744,-9.53674e-06],180],
        ["Snake_random_F",[4.93848,9.82715,0.00838852],265.74],
        ["Land_PaperBox_closed_F",[-2.12305,10.7852,-1.90735e-05],270],
        ["Land_PortableLight_double_F",[1.67285,11.2881,0.000417709],15],
        ["Land_BagFence_Round_F",[-8.98438,-7.54199,-0.00130081],45],
        ["Land_PaperBox_open_full_F",[-3.99414,10.7871,-9.53674e-06],90.0001],
        ["Land_BagFence_Long_F",[6.99902,9.2832,-0.000999451],270],
        ["Land_HBarrier_5_F",[0.138672,12.416,0.00299454],180],
        ["Land_BagFence_Long_F",[2.01074,12.5527,-0.000875473],0],
        ["Land_BagFence_Long_F",[-9.37598,9.0332,-0.000999451],270],
        ["Land_BagFence_Long_F",[-6.23926,12.5527,-0.00361824],0]
    ],
    // Second emplacement
    [
        ["Land_BagFence_Round_F",[-0.532227,-2.3457,-0.00156021],230.141],
        ["Land_CampingTable_F",[0.229492,2.88965,0.000480652],46.5776],
        ["Land_CampingChair_V1_F",[0.927734,2.86621,0.0045948],60.0191],
        ["Land_MetalBarrel_F",[3.33594,-0.260742,1.90735e-06],89.9818],
        ["Land_MetalBarrel_F",[3.33594,0.489258,6.48499e-05],300.001],
        ["Land_FieldToilet_F",[-3.16309,1.11719,1.33514e-05],270.001],
        ["Land_BagFence_Round_F",[-3.25293,-1.91211,-0.00389099],143.632],
        ["Land_CampingChair_V1_F",[0.4375,3.89648,0.00309753],29.966],
        ["Land_MetalBarrel_F",[3.96094,-0.0107422,1.90735e-06],225.007],
        ["Land_Sacks_heap_F",[3.20996,-2.63574,3.8147e-06],30],
        ["Land_BagFence_Short_F",[-0.298828,-4.41016,0.000276566],270.163],
        ["Land_Pallets_stack_F",[4.33594,-1.38574,3.8147e-06],360],
        ["Land_PaperBox_closed_F",[-3.29199,3.12695,-2.47955e-05],0],
        ["MetalBarrel_burning_F",[-3.91406,-3.75977,1.90735e-06],0],
        ["Land_PaperBox_open_empty_F",[-3.29004,4.98926,1.90735e-06],345],
        ["Land_BagFence_Round_F",[-0.865234,-6.62793,0.00127029],317.528],
        ["Land_BagFence_Short_F",[-3.16992,-6.98047,-0.00227547],179.331],
        ["CamoNet_BLUFOR_open_F",[-6.81641,-4.74805,0.000686646],0],
        ["Land_i_Stone_Shed_V1_F",[-8.60352,1.67578,-0.00339699],0],
        ["Land_WaterTank_F",[-8.41406,-1.38477,2.28882e-05],0.00122953],
        ["Land_BagFence_Long_F",[-5.41113,-7.02637,-0.00299644],180],
        ["Land_Pallet_MilBoxes_F",[-9.91309,-5.14648,-0.000156403],0],
        ["Land_Razorwire_F",[-7.81152,6.04688,-0.00924301],180],
        ["Land_HBarrier_5_F",[-11.9141,-6.76465,0.00299835],0],
        ["Land_HBarrier_5_F",[-11.6689,-1.01172,-0.00298119],90.0001],
        ["Land_Razorwire_F",[-13.4727,2.46777,-0.0154495],90.0002],
        ["Snake_random_F",[-16.2998,16.1719,0.00839043],129.167],
        ["Snake_random_F",[25.2051,29.6572,0.00839043],83.8004],
        ["Snake_random_F",[-12.1465,-45.0947,0.00838852],284.693]
    ],
    // Third emplacement
    [
        ["Land_BagFence_Round_F",[1.44043,1.81445,-0.00180244],45],
        ["Land_HBarrier_3_F",[-1.25684,3.66016,-0.00291824],0],
        ["Land_BagFence_Long_F",[3.98535,1.29199,0.00100136],180],
        ["Land_MetalBarrel_F",[-2.01953,4.80664,7.82013e-05],300.001],
        ["Land_WaterTank_F",[-0.269531,5.30664,-1.14441e-05],0.000759941],
        ["Land_BagFence_Round_F",[6.68555,1.68359,-0.0037384],315],
        ["Land_HBarrier_3_F",[6.99219,3.65918,0],0],
        ["MetalBarrel_burning_F",[3.85645,8.18262,0],0],
        ["Land_MetalBarrel_F",[7.98145,4.93262,3.8147e-06],89.998],
        ["CamoNet_INDP_open_F",[-3.66211,9.57422,0.00116348],240],
        ["Land_MetalBarrel_F",[8.85645,5.30762,1.90735e-06],225.01],
        ["Land_Pallets_stack_F",[9.35645,6.55762,-5.72205e-06],120.001],
        ["Land_Sacks_heap_F",[6.10645,10.1826,0],165],
        ["Land_PaperBox_closed_F",[-5.4043,10.9648,-1.90735e-05],225],
        ["Land_BagFence_Round_F",[-9.64258,8.47852,-0.00130081],45],
        ["Land_Pallets_stack_F",[-7.26953,11.6816,-1.90735e-06],315],
        ["Land_HBarrier_Big_F",[12.1396,6.47461,-6.10352e-05],315],
        ["Land_CratesWooden_F",[7.73145,11.5576,5.72205e-06],285],
        ["Land_PaperBox_closed_F",[-5.90332,12.9238,-1.71661e-05],240],
        ["Land_BagFence_Long_F",[-10.0342,11.1787,-0.00110817],270],
        ["Land_u_House_Small_02_V1_dam_F",[3.18066,16.9912,0.00568199],270],
        ["Land_BagFence_Round_F",[-9.51172,13.7236,0.00121498],135],
        ["Land_WaterBarrel_F",[-1.39355,18.0576,-3.8147e-06],359.999],
        ["Land_PaperBox_closed_F",[12.6035,13.5703,0],0],
        ["Land_HBarrier_Big_F",[14.6885,13.1475,0],270],
        ["Land_PaperBox_closed_F",[-1.40625,19.6807,-1.71661e-05],270],
        ["Land_Pallet_MilBoxes_F",[12.6094,15.2969,0],0],
        ["CamoNet_INDP_open_F",[11.4688,17.6563,0],270],
        ["Land_PaperBox_closed_F",[7.72852,20.0703,0],0],
        ["Land_CampingChair_V1_F",[9.33691,19.8545,0.00323677],194.997],
        ["Land_CampingChair_V1_F",[10.4102,19.4727,0.00308418],164.968],
        ["Land_CampingTable_F",[9.84473,20.334,-0.00246811],182],
        ["Snake_random_F",[-10.8379,19.8447,0.00839233],323.949],
        ["Land_HBarrier_Big_F",[11.2666,22.2646,0],180]
    ],
    // Fourth emplacement
    [
        ["Land_PaperBox_closed_F",[-2.15234,-0.00976563,0],0],
        ["Land_FieldToilet_F",[1.84082,2.10449,2.28882e-05],29.9585],
        ["Land_PaperBox_closed_F",[-2.6377,-1.64844,0],105],
        ["Land_CratesWooden_F",[-4.15039,-0.772461,0],300],
        ["Land_FieldToilet_F",[3.73633,2.10547,0.000263214],345.246],
        ["MetalBarrel_burning_F",[-3.14941,3.47852,1.90735e-06],0],
        ["Land_HBarrier_5_F",[0.473633,-4.64355,0],180],
        ["Land_Sacks_heap_F",[4.84961,2.97754,0],255],
        ["CamoNet_INDP_F",[-6.09961,1.20313,0],270],
        ["Land_PaperBox_closed_F",[0.362305,-6.27051,0],90],
        ["Land_PaperBox_closed_F",[-1.27734,-6.25977,0],0],
        ["Land_Pallets_stack_F",[0.349609,6.60254,0.000484467],165],
        ["Land_HBarrier_5_F",[4.6543,-3.02539,0.00408363],330],
        ["Land_Pallets_F",[-7.42969,1.85059,0.00149155],0],
        ["Land_MetalBarrel_F",[-0.525391,7.85254,-7.62939e-06],89.9837],
        ["Land_Pallets_stack_F",[0.849609,8.47754,-1.14441e-05],300],
        ["Land_HBarrier_5_F",[-4.90137,-4.64355,0],180],
        ["Land_MetalBarrel_F",[-0.525391,8.60254,-7.62939e-06],300.005],
        ["Land_Pallet_F",[-2.40039,-8.52246,0],30],
        ["Land_Razorwire_F",[-8.25391,-5.95508,-1.90735e-06],0],
        ["Land_HBarrier_5_F",[8.72852,-0.521484,0],270],
        ["Land_PaperBox_open_full_F",[-7.15039,5.96777,1.52588e-05],0],
        ["Land_HBarrier_Big_F",[-9.35742,0.387695,0],90],
        ["Land_Razorwire_F",[-11.083,-0.293945,-1.90735e-06],90],
        ["Land_WaterTank_F",[-3.15137,11.7939,-0.00128174],359.981],
        ["Snake_random_F",[-12.2461,1.1875,0.00838852],95.4576],
        ["Land_Razorwire_F",[-11.208,7.70605,-0.00930786],90],
        ["Land_HBarrier_Big_F",[-9.60742,8.51172,-4.76837e-05],90],
        ["Land_Pallet_MilBoxes_F",[-5.27344,11.7168,-0.000152588],0],
        ["Land_HBarrier_5_F",[-0.151367,13.3564,-1.90735e-06],180],
        ["Land_HBarrier_5_F",[-5.65039,13.3574,0.00110626],180],
        ["Snake_random_F",[-9.11816,16.332,0.00839233],116.065]
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
		
		_objectData set ["laptop", ["Land_Laptop_device_F", "laptop (Intel)", [5, 20]]];
		_objectData set ["suitcase", ["Land_Suitcase_F", "suitcase (Intel)", [5, 20]]];
		_objectData set ["mapBoardAltis", ["MapBoard_altis_F", "map (intel)", [5, 20]]];
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

						// Spawn grass cutter under the intel item
						private _grassCutter = createVehicle ["Land_ClutterCutter_medium_F", _finalPos, [], 0, "CAN_COLLIDE"];
						_grassCutter setDir (random 360);
						
						if (_hasAction) then {
							_obj addAction [
								format ["<t color='#00ff00' size='1.2'>%1</t>", _actionText],
								{
									params ["_target", "_caller"];
									private _actionText = _target getVariable ["actionText", "Item"];
									_caller sideChat format ["Acquired %1", _actionText];
									deleteVehicle _target;
								},
								nil,
								101,
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
			
				"Land_Laptop_device_F",
				"Land_Suitcase_F",
				"MapBoard_altis_F"
		  
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
							player sideChat "Objective Complete: ALL Intel Items Acquired";
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
		
		player sideChat "New Objective: Search and retrieve enemy intel";
		nul = [] execVM "missionBriefings\retriveIntelBrief.sqf";
		
	};
};