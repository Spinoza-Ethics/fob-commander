//==========General Settings ==========//

private _markerNameText = "Rescue HVT";
private _markerType = "o_installation";


//Static Groups
private _staticGroupSizeMin = 2; //Default 2
private _staticGroupSizeMax = 5; //Default 8
private _staticGroupCountMin = 1; //Default 1
private _staticGroupCountMax = 3; //Default 2

//Patrol Groups
private _patrolSizeMin = 3; //Default 1
private _patrolSizeMax = 5; //Default 6
private _patrolGroupCountMin = 0; //Default 0
private _patrolGroupCountMax = 1; //Default 2

//Armored & Static Weapons
private _armoredSpawnChance = 0.1; //Default 0.2
private _staticWeaponChance = 0.8; //Default 0.3

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
        ["Land_MetalBarrel_F",[5.59375,0.583984,1.90735e-06],89.9839],
        ["Land_MetalBarrel_F",[5.85254,1.54883,1.90735e-06],239.984],
        ["Land_Sacks_heap_F",[6.55957,0.324219,0],120],
        ["Land_BagFence_Round_F",[7.08496,1.41211,-0.00130081],45],
        ["Land_CratesShabby_F",[7.94141,0.195313,0],285],
        ["Land_CratesWooden_F",[6.30957,5.07422,0],6.37798],
        ["Land_PortableLight_double_F",[7.9209,2.00977,0],120],
        ["B_G_Van_01_transport_F",[-3.94336,7.82227,0.00461006],180.003],
        ["Land_BagFence_Short_F",[9.1748,0.871094,-0.000999451],0],
        ["Land_Medevac_house_V1_F",[8.05957,7.80273,0],0],
        ["Land_BagFence_Round_F",[11.1406,1.24609,-0.00130081],315],
        ["Land_BagFence_Long_F",[-9.54785,5.99805,-0.000999451],90],
        ["CamoNet_BLUFOR_F",[-1.33984,11.8984,0],0],
        ["Land_BagFence_Long_F",[11.5449,3.99023,-0.000999451],270],
        ["Land_BagFence_Long_F",[-9.54785,8.87305,-0.000999451],90],
        ["Land_Wall_IndCnc_2deco_F",[11.5615,7.11914,0],270],
        ["Land_Wall_IndCnc_2deco_F",[7.06055,11.6191,0],180],
        ["Land_HBarrier_5_F",[-0.9375,13.7402,0],0],
        ["Land_HBarrier_5_F",[-6.1875,13.7402,0],0],
        ["Land_BagFence_Round_F",[-10.8555,10.752,-0.00130081],45],
        ["Land_Wall_IndCnc_2deco_F",[11.5615,10.1191,0],270],
        ["Land_Wall_IndCnc_2deco_F",[10.0605,11.6191,0],180],
        ["Land_BagFence_Long_F",[-8.06738,13.7598,-0.000999451],0],
        ["Land_BagFence_Round_F",[-10.7686,13.3691,-0.00130081],135]
    ],
    // Second emplacement
    [
        ["Land_Garbage_square5_F",[-2.49902,-1.2832,-0.000102997],0],
        ["Land_JunkPile_F",[2.36621,-3.05469,0],120],
        ["Land_Pallets_F",[3.23535,-0.201172,0],60],
        ["Land_GarbagePallet_F",[4.39941,-1.59375,0],195],
        ["Land_GarbageWashingMachine_F",[4.54297,-3.28125,0],0],
        ["Land_LampShabby_F",[-4.12109,-2.10352,0.000112534],15],
        ["Land_Garbage_square5_F",[-1.87695,-5.47656,-0.000102997],0],
        ["Land_GarbageBags_F",[-7.17676,-1.69141,0.00122261],90],
        ["Land_Concrete_SmallWall_4m_F",[5.48633,4.29492,5.53131e-05],0],
        ["Land_Cargo_House_V2_F",[-5.51563,-5.35547,0.00130463],270],
        ["Land_Tyre_F",[-7.0459,-0.453125,0.0133419],357.211],
        ["Campfire_burning_F",[0.833008,-7.10547,0.0294018],0],
        ["Land_Pipes_small_F",[-5.80078,4.37891,3.8147e-06],330],
        ["Land_Concrete_SmallWall_8m_F",[7.50293,0.552734,-2.67029e-05],270],
        ["Land_WoodPile_F",[-3.35449,-6.99609,0.000278473],15],
        ["Land_Axe_F",[-2.53711,-7.35547,-0.00335503],300],
        ["Land_CinderBlocks_F",[-5.76563,5.64453,1.52588e-05],59.9894],
        ["Land_GarbageBags_F",[-8.95215,-2.74609,0],0],
        ["Land_CinderBlocks_F",[-7.26563,5.14453,3.8147e-06],179.988],
        ["Snake_random_F",[6.71582,-5.9375,0.00838852],66.0391],
        ["Land_Pallets_stack_F",[-5.28711,7.39453,9.53674e-05],0.00229293],
        ["Land_CinderBlocks_F",[-7.01563,6.64453,5.72205e-06],14.985],
        ["Land_Sack_F",[-7.9873,6.03516,1.90735e-06],0],
        ["Box_FIA_Ammo_F",[-9.78711,-5.10547,1.14441e-05],195],
        ["Land_Tank_rust_F",[-6.06738,-9.72656,0],0],
        ["Land_Concrete_SmallWall_8m_F",[-1.54297,-11.6152,4.19617e-05],0],
        ["Land_CratesWooden_F",[-9.78711,-7.85547,0],255],
        ["Land_WoodenCart_F",[-12.543,1.63672,-0.00570297],45.0084],
        ["Land_Concrete_SmallWall_4m_F",[-8.13086,10.127,5.34058e-05],0],
        ["Land_Concrete_SmallWall_4m_F",[-10.2734,8.38867,-2.09808e-05],270],
        ["Land_Concrete_SmallWall_8m_F",[-9.29297,-11.6152,0],0],
        ["Land_Concrete_SmallWall_8m_F",[-13.2773,-7.86133,0],270],
        ["Snake_random_F",[-17.998,4.2793,0.00838852],94.7886]
    ],
    // Third emplacement
    [
        ["Land_Map_unfolded_F",[-0.313477,2.41602,3.8147e-06],60.0004],
        ["Land_PortableLongRangeRadio_F",[-0.09375,2.65625,1.90735e-06],0.000403511],
        ["Land_WoodenLog_F",[-0.443359,2.93555,0.000160217],0.00596313],
        ["Land_FMradio_F",[2.91699,2.69531,1.90735e-06],179.999],
        ["Box_FIA_Support_F",[-2.69141,2.93555,0.000534058],119.991],
        ["Land_Garbage_square5_F",[1.59473,4.00781,0],0],
        ["MetalBarrel_burning_F",[1.2666,4.17578,0],0],
        ["Land_WoodenLog_F",[3.05664,3.18555,-3.8147e-06],29.9994],
        ["CamoNet_BLUFOR_open_F",[2.15527,3.82227,0],0],
        ["Land_PlasticCase_01_small_F",[1.55664,6.18555,-1.14441e-05],255],
        ["Land_WoodenLog_F",[1.05664,6.68555,-3.8147e-06],0.00582303],
        ["Land_BottlePlastic_V2_F",[1.55566,6.68359,0.1325],359.812],
        ["Land_BottlePlastic_V2_F",[1.46582,6.81641,0.132498],0.002197],
        ["Box_FIA_Ammo_F",[6.05664,3.68555,-1.14441e-05],135.001],
        ["Land_Sacks_heap_F",[-1.19336,7.43555,1.90735e-06],300],
        ["Land_BarrelTrash_grey_F",[-3.69238,7.43555,0],359.994],
        ["Land_CratesWooden_F",[-2.44336,8.68555,0],285],
        ["Land_MetalBarrel_F",[-1.19238,9.18555,-3.8147e-06],329.99],
        ["Land_BarrelSand_F",[-3.94238,8.43555,-1.90735e-06],359.992],
        ["Land_MetalBarrel_F",[6.80664,8.18555,-7.62939e-06],315.008],
        ["Land_MetalBarrel_F",[6.30664,8.68555,-7.62939e-06],254.994],
        ["Snake_random_F",[-17.0723,-24.0234,0.00838852],23.1103]
    ],
    // Fourth emplacement
    [
        ["Land_Garbage_square5_F",[-2.06641,-2.20313,0],180],
        ["Land_BagFence_End_F",[3.37012,-2.95313,-0.000999451],210],
        ["MetalBarrel_burning_F",[4.72168,-2.38086,0],180],
        ["Land_BagFence_End_F",[-0.839844,-5.6543,-0.000999451],0],
        ["Land_BagFence_Round_F",[5.52832,-3.14648,-0.00130081],320],
        ["Land_BagFence_Long_F",[6.17188,-0.611328,-0.00197601],90],
        ["Land_Garbage_square5_F",[-6.19141,-1.32813,0.000102997],180],
        ["Land_PaperBox_open_empty_F",[-4.77832,-4.25586,0],122],
        ["Land_BagFence_Long_F",[-3.14941,-5.64648,-0.000999451],180],
        ["Land_HBarrier_1_F",[6.28418,1.68555,1.14441e-05],187],
        ["Land_BagFence_Short_F",[-5.26953,-5.26172,-0.00233841],210],
        ["Land_HBarrier_3_F",[5.07324,6.08203,-0.000738144],210],
        ["Land_HBarrier_1_F",[5.96973,5.61133,-1.14441e-05],17],
        ["Land_HBarrier_5_F",[-1.95117,8.82227,0],15],
        ["Land_BagBunker_Large_F",[-6.89941,5.07031,0.000795364],180],
        ["Land_PlasticCase_01_small_F",[-7.99902,-3.27539,-1.90735e-06],67],
        ["Land_WoodenTable_small_F",[-8.15234,-3.32617,-0.296997],269.999],
        ["Land_HBarrier_5_F",[-6.52832,-4.75,0.000749588],180],
        ["Land_Razorwire_F",[-0.379883,11.0234,-1.90735e-06],20],
        ["Land_CratesPlastic_F",[-10.7822,-3.38086,0],147],
        ["Land_HBarrier_3_F",[-11.7881,1.26758,0.00071907],180],
        ["Land_Razorwire_F",[-5.4248,11.5527,-1.90735e-06],180],
        ["Land_BagFence_Round_F",[-14.0439,-3.4375,-0.000152588],50],
        ["Land_BagFence_Long_F",[-14.2627,-0.751953,0.00189972],90],
        ["Snake_random_F",[18.418,16.9199,0.00839043],345.353]
    ],
    // Fifth emplacement
    [
        ["Land_IndFnc_3_F",[-1.49609,1.10059,0],270],
        ["Land_IndFnc_3_F",[-1.49609,-1.89941,0.00063324],270],
        ["Land_IndFnc_Pole_F",[-1.53125,2.59961,0],270],
        ["Land_Net_Fence_Gate_F",[-3.62207,2.72461,-0.00738907],180],
        ["Land_IndFnc_3_F",[4.37598,1.22266,-0.00201416],90],
        ["Land_IndFnc_3_F",[4.375,-1.77832,-0.000356674],90],
        ["Land_WoodenTable_small_F",[-4.37305,2.34863,1.14441e-05],180.005],
        ["Land_IndFnc_Corner_F",[-1.49512,-4.81934,0.00245667],270],
        ["Land_CratesWooden_F",[-5.37305,-0.901367,0],255],
        ["Land_ChairWood_F",[-5.02344,2.45508,1.14441e-05],301.342],
        ["Land_IndFnc_3_F",[0,-6.27344,-0.00200272],180],
        ["Land_CratesWooden_F",[-5.49805,-3.02637,3.8147e-06],0],
        ["Land_IndFnc_3_F",[4.375,-4.77832,0],90],
        ["Land_Sacks_heap_F",[-6.49805,-1.65137,0],255],
        ["Land_IndFnc_Corner_F",[2.9209,-6.27441,0.000535965],180],
        ["Land_LampShabby_F",[1.48535,-6.78809,-0.000371933],0],
        ["Land_HBarrier_5_F",[7.50586,-4.27441,-0.00421143],270],
        ["Land_MetalBarrel_F",[-0.333008,8.00195,1.90735e-06],300.006],
        ["Land_MetalBarrel_F",[-0.999023,8.09766,0],75.0093],
        ["Land_HBarrier_5_F",[7.50586,1.22461,-0.00298119],270],
        ["Land_BarrelSand_F",[1.75098,8.84766,-7.62939e-06],0.00566202],
        ["Land_HBarrier_5_F",[-8.87695,0.0976563,0.002985],90.0001],
        ["Land_PaperBox_closed_F",[0.254883,9.21094,-9.53674e-06],180],
        ["Land_PaperBox_closed_F",[-1.51074,9.22168,-1.90735e-05],270],
        ["Land_HBarrier_5_F",[-8.87598,5.59863,0.00510216],90],
        ["Land_BagFence_Short_F",[2.11621,-9.39941,-0.00226212],0],
        ["Land_HBarrier_5_F",[0.875977,-9.52246,0.00299644],180],
        ["Land_BagFence_Long_F",[7.48633,-6.28027,-0.00101852],270],
        ["Land_PaperBox_open_full_F",[-3.38184,9.22363,-5.72205e-06],90.0001],
        ["Land_PortableLight_double_F",[2.28418,9.72266,0],15],
        ["Land_BagFence_Long_F",[4.37305,-9.38574,-0.00270653],0],
        ["Land_BagFence_Long_F",[-8.73242,-6.39746,-0.000999451],90],
        ["Land_BagFence_Long_F",[7.61133,7.71973,-0.000999451],270],
        ["Land_HBarrier_5_F",[0.751953,10.8535,0.00527954],180],
        ["Land_BagFence_Long_F",[-5.62695,-9.51074,-0.000999451],0],
        ["Land_BagFence_Round_F",[7.08105,-9.02539,-0.00278091],315],
        ["Land_BagFence_Long_F",[2.62305,10.9893,-0.000999451],0],
        ["Land_BagFence_Long_F",[-8.76367,7.46973,-0.000999451],270],
        ["Land_BagFence_Round_F",[-8.37207,-9.10547,-0.00130081],45],
        ["Land_BagFence_Long_F",[-5.62695,10.9893,-0.00299835],0],
        ["Snake_random_F",[17.9238,11.0977,0.00838661],129.064]
    ],
    // Sixth emplacement
    [
        ["MetalBarrel_burning_F",[0.450195,2.5498,1.90735e-05],0],
        ["Land_HBarrier_Big_F",[-3.88379,-0.916992,0.00022316],90.0009],
        ["Land_Sacks_heap_F",[-1.92676,-4.57715,1.52588e-05],345],
        ["Land_d_House_Small_01_V1_F",[9.23047,-0.0341797,-0.0621834],0],
        ["Land_CratesWooden_F",[3.07324,4.42285,4.3869e-05],90.0016],
        ["Land_FieldToilet_F",[-1.04688,-5.69727,6.10352e-05],255.001],
        ["Land_HBarrier_3_F",[-2.04102,-7.47559,0.00151253],0],
        ["Land_Pallet_F",[2.82422,7.54883,9.53674e-06],255.002],
        ["Land_PaperBox_open_full_F",[-1.42676,-9.33691,1.71661e-05],0],
        ["Land_HBarrier_Big_F",[-3.63379,-9.16699,6.67572e-05],90.0001],
        ["B_G_Offroad_01_repair_F",[-4.07129,9.75879,0.017189],330],
        ["Land_BagFence_Round_F",[1.61133,11.3193,-0.0138283],138.855],
        ["Land_PaperBox_closed_F",[-1.42871,-11.3145,-1.14441e-05],0],
        ["Land_BagFence_Long_F",[4.32715,11.5322,-0.00297356],180],
        ["Land_Pallets_stack_F",[3.5752,-12.0762,9.53674e-06],345.004],
        ["CamoNet_BLUFOR_open_F",[9.04688,-9.43945,0.000211716],0],
        ["Land_BagFence_Round_F",[6.74512,11.1221,-0.000804901],224.483],
        ["Land_PaperBox_open_empty_F",[1.82324,-13.2021,1.33514e-05],29.9999],
        ["Land_BagFence_Round_F",[-0.208984,-16.5459,0.00220108],44.4829],
        ["Land_Sacks_heap_F",[13.4482,-9.70215,1.90735e-05],105.001],
        ["Land_BagFence_Long_F",[2.20898,-16.9561,0.00532341],0],
        ["Land_Pallet_MilBoxes_F",[13.0752,-11.2129,-0.000810623],0],
        ["Land_BagFence_Round_F",[4.92383,-16.7432,0.00354385],318.854],
        ["Land_HBarrier_Big_F",[15.1162,-8.04199,0.000473022],90],
        ["B_G_Van_01_fuel_F",[17.3252,3.70703,-0.0334721],0.000810985],
        ["Land_HBarrier_Big_F",[11.9131,-13.4092,0.000587463],0],
        ["Snake_random_F",[11.4189,18.8369,0.00838852],267.877],
        ["Snake_random_F",[-24.7432,-20.5352,0.00838852],107.045],
        ["Snake_random_F",[-26.2314,-28.0264,0.00838852],152.062]
    ],
    // Seventh emplacement
    [
        ["Land_BagFence_Long_F",[-0.0820313,1.47852,-0.00238228],0],
        ["Land_ShelvesWooden_khaki_F",[0.419922,2.08691,-0.00106812],270.017],
        ["Land_GasTank_02_F",[-0.433594,2.15234,7.24792e-05],180.008],
        ["Land_ShelvesWooden_khaki_F",[-1.33105,2.08691,-0.00106239],269.983],
        ["Land_BagFence_Long_F",[2.79297,1.47852,-0.000976563],0],
        ["Land_BagFence_Round_F",[-2.70215,1.88379,-0.00151062],45],
        ["Oil_Spill_F",[1.58496,4.3252,-1.14441e-05],0],
        ["Land_CampingChair_V1_F",[-1.3291,4.71191,0.00308609],60.0043],
        ["Land_CampingTable_small_F",[-1.9541,4.58691,0.00259972],90.0022],
        ["Land_CanisterOil_F",[1.17188,5.21289,7.62939e-06],314.965],
        ["Land_BagFence_Long_F",[-3.09375,4.45898,-0.00312614],270],
        ["B_G_Quadbike_01_F",[3.41992,4.08496,-0.00999641],105],
        ["Land_Garbage_square5_F",[-0.292969,5.92285,0.000295639],0],
        ["Land_Tyre_F",[-2.3291,5.56445,-0.0043087],359.982],
        ["Land_CampingChair_V1_folded_F",[-1.50586,5.86328,-1.90735e-06],90.0001],
        ["Snake_random_F",[-5.74316,3.51465,0.00838852],355.308],
        ["Land_CarBattery_02_F",[-0.203125,7.21289,-1.33514e-05],104.982],
        ["Land_Garbage_square5_F",[2.08496,7.15918,0.000196457],0],
        ["Land_CanisterFuel_F",[0.0283203,7.7627,5.72205e-06],134.905],
        ["Land_WeldingTrolley_01_F",[-2.3291,7.46191,-5.72205e-06],285.012],
        ["Land_CanisterFuel_F",[-0.453125,7.83789,-1.90735e-06],104.955],
        ["Land_TinContainer_F",[0.647461,7.86719,0.0997543],285.299],
        ["Land_BagFence_Long_F",[-3.09375,7.33398,-0.00304031],270],
        ["Land_CncBarrier_F",[1.04492,8.20508,-9.53674e-06],0],
        ["RoadCone_F",[2.67188,7.96289,-1.90735e-05],119.996],
        ["CamoNet_BLUFOR_F",[-0.652344,8.31348,-0.000289917],270],
        ["Land_ButaneCanister_F",[-2.20313,8.46289,0],0.0969651],
        ["RoadCone_F",[3.04785,8.22266,-1.71661e-05],135.006],
        ["Land_ButaneCanister_F",[-2.45703,8.52344,1.90735e-06],345.04],
        ["Land_ButaneTorch_F",[-2.14355,8.67188,1.71661e-05],180.04],
        ["Land_GasTank_01_khaki_F",[-2.45313,8.83789,-7.62939e-06],359.968],
        ["Land_BagFence_Long_F",[-3.09375,10.209,-0.00303841],270],
        ["Land_CncBarrier_F",[-2.19531,10.4609,7.62939e-06],270],
        ["B_G_Offroad_01_repair_F",[1.81641,10.6484,0.0184917],90.0058],
        ["Land_BagFence_Long_F",[-2.0918,12.7207,-0.00385475],315],
        ["Land_BagFence_Round_F",[-0.335938,14.6328,0.00157356],150],
        ["Land_BagFence_Long_F",[2.41797,14.7285,-0.00299835],0],
        ["Snake_random_F",[8.12402,13.3584,0],185.335]
    ],
    // Eighth emplacement
    [
        ["Land_Sacks_heap_F",[-0.263672,2.4082,0],195],
        ["Land_BagFence_End_F",[-3.51367,0.419922,-0.000999451],330],
        ["Land_PaperBox_closed_F",[-0.135742,4.02051,0],180],
        ["Land_Garbage_square5_F",[1.28809,4.19629,0],270],
        ["CamoNet_INDP_open_F",[-1.79004,3.7959,0],0],
        ["Land_HBarrier_5_F",[-1.89258,6.7832,0],90],
        ["Land_BagFence_End_F",[5.33203,0.55957,-0.000999451],60],
        ["Land_MetalBarrel_F",[1.11133,5.1582,1.14441e-05],359.979],
        ["Land_BagFence_Long_F",[4.96094,2.68848,-0.000999451],90],
        ["Land_BagFence_Long_F",[-5.6377,0.0488281,-0.000999451],0],
        ["Land_CargoBox_V1_F",[-0.138672,5.6582,0.0305481],179.995],
        ["Land_WaterBarrel_F",[-3.38867,6.4082,1.33514e-05],0.00284562],
        ["Land_BagFence_Long_F",[4.90137,5.62598,-0.000999451],270],
        ["Land_Pallets_stack_F",[-5.01367,6.1582,-0.000991821],149.999],
        ["Land_BagFence_Round_F",[-8.38867,0.448242,-0.00130081],45],
        ["Land_Garbage_square5_F",[-5.21191,6.44629,0],270],
        ["Land_BagFence_End_F",[-0.333008,8.24219,-0.000999451],150],
        ["Land_BagFence_Long_F",[1.7959,8.61426,-0.000999451],180],
        ["Land_HBarrier_5_F",[-1.76465,8.03809,0],180],
        ["Land_BagFence_Round_F",[4.54102,8.20801,-0.00130081],225],
        ["Land_BagFence_Long_F",[-8.74316,3.03711,-0.000999451],90],
        ["Land_BagFence_Long_F",[-8.80371,5.97461,-0.000999451],270],
        ["Land_Sacks_heap_F",[-6.00977,9.40918,0],195],
        ["Land_BagFence_End_F",[-9.17578,8.10352,-0.000999451],240],
        ["Snake_random_F",[3.88184,11.123,0.00838852],77.4784],
        ["Snake_random_F",[47.6494,9.00098,0],281.356]
    ],
    // Ninth emplacement
    [
        ["Land_CratesWooden_F",[0.467773,-3.38672,3.8147e-06],0],
        ["Land_Sacks_heap_F",[4.34277,0.738281,1.90735e-06],285],
        ["Land_Net_Fence_Gate_F",[-4.0332,4.2373,0.012495],180],
        ["Land_WaterBarrel_F",[2.71875,-3.76074,7.62939e-06],0.000142802],
        ["Land_IndFnc_Pole_F",[-2.03223,4.27051,0.00015831],0],
        ["CargoNet_01_barrels_F",[-4.03223,-3.13672,-9.53674e-06],45.0011],
        ["Land_IndFnc_9_F",[2.58984,-5.21777,-0.767174],180],
        ["Land_IndFnc_3_F",[-3.5293,4.23535,0.000917435],0],
        ["Land_WaterBarrel_F",[3.96973,-3.88379,9.53674e-06],329.908],
        ["Land_CratesWooden_F",[5.84277,0.738281,0],270],
        ["CargoNet_01_box_F",[5.84375,-1.38574,1.33514e-05],0.000851368],
        ["Land_MetalBarrel_F",[-6.40723,0.489258,1.90735e-06],74.9915],
        ["Land_MetalBarrel_F",[-6.40723,1.23926,1.90735e-06],254.991],
        ["Land_PaperBox_closed_F",[-6.52051,-1.00586,-5.72205e-06],75],
        ["Land_IndFnc_3_F",[6.92578,-0.0966797,0.00202179],90],
        ["Land_IndFnc_3_F",[5.4707,4.36133,-0.00079155],0],
        ["Land_PaperBox_closed_F",[-6.53516,-2.87402,0],0],
        ["Land_MetalBarrel_F",[-7.15723,0.489258,1.90735e-06],359.99],
        ["Land_MetalBarrel_F",[-7.15723,1.23926,1.90735e-06],314.993],
        ["Land_MetalBarrel_F",[-7.15723,1.98926,3.8147e-06],120.004],
        ["Land_IndFnc_Corner_F",[6.96582,2.90723,-0.000680923],90],
        ["Land_IndFnc_3_F",[6.92578,-3.0957,0.0020256],90],
        ["Land_IndFnc_Corner_F",[5.47168,-5.2959,0.00241852],180],
        ["Land_IndFnc_Corner_F",[-6.32617,4.23535,2.09808e-05],0],
        ["Land_IndFnc_3_F",[-7.78027,-0.260742,-0.00201035],270],
        ["Land_IndFnc_3_F",[-6.28516,-4.63477,0],180],
        ["Land_IndFnc_3_F",[-7.78027,2.73926,-0.00201035],270],
        ["Land_IndFnc_Corner_F",[-7.78027,-3.18066,0.000240326],270],
        ["Snake_random_F",[-20.5078,-0.220703,0.00839043],62.07],
        ["Snake_random_F",[-17.2002,16.5479,0.00838852],176.26]
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
					"C_IDAP_Man_UAV_06_antimine_F",
					"C_Man_Paramedic_01_F",
					"C_scientist_F",
					"C_journalist_F",
					"C_Journalist_01_War_F",
					"C_scientist_02_formal_F",
					"C_scientist_01_formal_F"
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

							_civilian setVariable ["isPotentialfriendlyHVT", true, true];

							private _checkCivilian = _civilian; // Reference to the civilian for the spawned script
							private _proximityCheckScript = _checkCivilian spawn {
								
								params ["_civ"];

								
								while {true} do {
									
									if (isNull _civ || !(_civ getVariable ["isPotentialfriendlyHVT", false])) exitWith {};

									private _playerNear = false;
									
									{
										if (alive _x && (_civ distance _x) <= 2) then {
											_playerNear = true;
										};
									} forEach allPlayers;

									if (_playerNear) then {
										_civ setCaptive false;
										_civ enableAI "MOVE";

										
										_civ setVariable ["isPotentialfriendlyHVT", false, true];

										
										{ _x sideChat "Friendly HVT Survivor Rescued!"; } forEach allPlayers;

										
										private _friendlyHVTsLeft = 0;
										{
											
											if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialfriendlyHVT", false])) then {
												_friendlyHVTsLeft = _friendlyHVTsLeft + 1;
											};
										} forEach allUnits;

										
										{ _x sideChat format ["Friendly HVTs left: %1", _friendlyHVTsLeft]; } forEach allPlayers;

										if (_friendlyHVTsLeft == 0) then {
										
											player sideChat "Objective Complete: All Friendly HVTs Rescued";
											nul = [] execVM "missionCompleteScreen.sqf";
											
											//add xp/coins
											[100] execVM "addXP.sqf";
											[2] execVM "addCredits.sqf";
											
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

			private _totalInitialfriendlyHVTs = 0;
			{
				
				if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialfriendlyHVT", false])) then {
					_totalInitialfriendlyHVTs = _totalInitialfriendlyHVTs + 1;
				};
			} forEach allUnits;
			{ _x sideChat format ["Total potential Friendly HVTs in mission: %1", _totalInitialfriendlyHVTs]; } forEach allPlayers;
		};


		//==========End New Systems Here==========//

		_spawned = true;
		player sideChat "New Objective: Rescue the captured operative";
		nul = [] execVM "missionBriefings\rescueHVTBrief.sqf";
	};
};