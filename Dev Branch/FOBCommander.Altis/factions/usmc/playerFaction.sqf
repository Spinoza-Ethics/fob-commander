private _playerFaction = createHashMap;

//Declare FOB Flag Type
//dont change this without changing fob composition flag type too, they should match
_playerFaction set ["flagType", "Flag_Nato_F"];

// Unit types
//list name, classname
_playerFaction set ["unitTypes", [
	["Marine", "PUP_UMW_Marine"],
    ["Marksman", "PUP_UMW_Marksman"],
    ["Engineer", "PUP_UMW_Engineer"],
    ["Heavy Gunner", "PUP_UMW_Heavy_Gunner"],
    ["Grenadier", "PUP_UMW_Grenadier"],
    ["AT", "PUP_UMW_Marine_AT"],
    ["UAV Operator", "PUP_UMW_UAV_Operator"]
]];


// Vehicle types
//list name, classname
_playerFaction set ["vehicleTypes", [
    ["MRAP (Unarmed)", "B_MRAP_01_F"],
    ["MRAP (HMG)", "B_MRAP_01_hmg_F"],
    ["Prowler (Unarmed)", "B_LSV_01_unarmed_F"],
    ["Prowler(HMG)", "B_LSV_01_armed_F"],
    ["Prowler (AT)", "B_LSV_01_AT_F"],
    ["Cargo Truck", "B_Truck_01_cargo_F"],
    ["Transport Truck", "B_Truck_01_transport_F"],
    ["Cheetah (AA)", "B_APC_Tracked_01_AA_F"],
    ["Marshall (APC)", "B_APC_Wheeled_01_cannon_F"],
    ["Bobcat (Resupply)", "B_APC_Tracked_01_CRV_F"],
    ["Rooikat (Wheeled Tank)", "B_AFV_Wheeled_01_up_cannon_F"],
    ["Slammer (Tracked Tank)", "B_MBT_01_TUSK_F"],
    ["Little Bird (Heli)", "B_Heli_Light_01_F"],
    ["Ghosthawk (Heli)", "B_Heli_Transport_01_F"],
    ["Assault Boat", "B_Boat_Armed_01_minigun_F"],
	["Submarine", "B_SDV_01_F"]
]];
	


// FOB Composition
//if you want the FOB to be built with just a flag and map. delete everything except for Flag_NATO_F

_playerFaction set ["fixedFOB", [
    ["Land_Portable_generator_F", [-4.3623, -1.87305, 0], 23.629],
    ["Oil_Spill_F", [-1.50488, -4.88867, 0], 0],
    ["Land_CncShelter_F", [-4.01563, -3.91406, 0], 223.067],
    ["Land_Tyre_F", [-1.86035, -5.44336, 0], 0],
    ["Land_FoodSacks_01_small_brown_idap_F", [-1.21289, -6.13672, 0], 71.5821],
    ["Land_BagFence_Long_F", [-3.57617, -5.51563, -0.000999451], 312.439],
    ["Land_BagFence_Long_F", [-5.70508, -3.5918, -0.000999451], 312.439],
    ["Land_ShellCrater_01_decal_F", [-6.67871, -1.99805, 0], 44.0471],
    ["Land_PaperBox_01_open_water_F", [-2.38574, -6.88867, 0], 49.4385],
    ["Land_CncShelter_F", [-5.12695, -5.11523, 0], 222.2],
    ["Land_FoodSack_01_full_brown_idap_F", [-3.63672, -7.44336, 0], 89.398],
    ["VirtualReammoBox_camonet_F", [-7.58398, -3.125, 0], 313.205],
    ["Land_Garbage_square3_F", [-0.114258, -8.76563, 0], 107.177],
    ["Land_CncShelter_F", [-6.20313, -6.27148, 0], 223.067],
    ["Land_BagFence_Long_F", [-5.5752, -7.74414, -0.000999451], 312.439],
    ["Land_BagFence_Long_F", [-7.7041, -5.82031, -0.000999451], 312.439],
    ["Land_ShellCrater_01_decal_F", [-8.97559, -4.50195, 0], 310.285],
    ["Land_CncShelter_F", [-7.31445, -7.47266, 0], 222.2],
    ["Land_CampingChair_V2_F", [-9.20117, -7.38867, 0], 30.8731],
    ["Land_Garbage_square5_F", [-4.52637, -11.3887, 0], 328.941],
    ["Flag_NATO_F", [-14.2744, -8.74023, 0], 0]
]];

// Return the faction hashmap
_playerFaction
