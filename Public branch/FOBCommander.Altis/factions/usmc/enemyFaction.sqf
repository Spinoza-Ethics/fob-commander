private _config = createHashMap;

// Infantry types
_config set ["infantryTypes", [
    "O_T_Soldier_A_F",
    "O_T_Soldier_AR_F",
    "O_T_Medic_F",
    "O_T_Engineer_F",
    "O_T_Soldier_GL_F",
    "O_T_HeavyGunner_F",
    "O_T_Soldier_AT_F",
    "O_T_Soldier_F",
    "O_T_Sharpshooter_F",
    "O_V_Soldier_ghex_F",
    "O_V_Soldier_Medic_ghex_F",
    "O_V_Soldier_TL_ghex_F",
    "O_T_Recon_AR_F",
    "O_T_Recon_M_F",
    "O_T_Recon_F",
    "O_T_Pathfinder_F",
    "O_T_Officer_F",
    "O_T_RadioOperator_F",
    "O_T_soldier_UAV_06_F"
]];

// Vehicle types
_config set ["vehicleTypes", [
    "O_T_MRAP_02_ghex_F",
    "O_T_MRAP_02_hmg_ghex_F",
    "O_T_LSV_02_armed_F",
    "O_T_LSV_02_unarmed_F",
    "O_T_Quadbike_01_ghex_F",
    "O_T_Truck_03_ammo_ghex_F",
    "O_T_Truck_03_medical_ghex_F",
    "O_T_Truck_03_repair_ghex_F",
    "O_T_Truck_03_transport_ghex_F",
    "O_T_APC_Wheeled_02_unarmed_lxWS",
    "O_T_APC_Wheeled_02_hmg_lxWS",
    "O_T_APC_Tracked_02_30mm_lxWS",
    "O_T_APC_Tracked_02_cannon_ghex_F",
    "O_T_Truck_03_covered_ghex_F",
    "O_T_Truck_02_Ammo_F",
    "O_T_Truck_02_cargo_lxWS",
    "O_T_Truck_02_flatbed_lxWS",
    "O_T_Truck_02_fuel_F",
    "O_T_Truck_02_Medical_F",
    "O_T_Truck_02_Box_F",
    "O_T_Truck_02_transport_F",
    "O_T_Truck_02_F",
    "O_T_Heli_Light_02_dynamicLoadout_ghex_F",
    "O_T_Heli_Attack_02_dynamicLoadout_F",
    "O_T_Heli_Transport_04_bench_F",
    "O_T_Heli_Transport_04_F",
    "Aegis_C_Heli_Light_01_Civil_F_LXWS",
    "Aegis_C_Heli_Light_02_civil_F_Argana",
    "C_Offroad_02_unarmed_F",
    "C_Offroad_01_F",
    "C_Offroad_01_comms_F",
    "C_Offroad_01_covered_F",
    "C_Offroad_01_repair_F",
    "C_Tractor_01_F",
    "C_Van_01_box_F",
    "C_Van_02_service_F",
    "C_Van_02_transport_F",
    "C_Truck_02_covered_F",
    "C_Truck_02_box_F"
]];

// Armored vehicle types
_config set ["armoredVehicleTypes", [
    "O_T_MRAP_02_hmg_ghex_F",
    "O_T_LSV_02_armed_F",
    "O_T_APC_Wheeled_02_hmg_lxWS",
    "O_T_APC_Tracked_02_30mm_lxWS",
    "O_T_APC_Tracked_02_cannon_ghex_F",
    "O_T_MBT_02_cannon_ghex_F",
    "O_T_MBT_04_cannon_F"
]];

// Static weapon types
//list name(dont change), classname (edit freely)
_config set ["staticATTypes", ["I_AT_Static_01_F", "I_Static_AT_F"]];
_config set ["staticMGTypes", ["I_HMG_02_F", "I_HMG_02_high_F"]];
_config set ["mortarTypes", ["O_Mortar_01_F"]];

// Default crew types
//list name(dont change), classname (edit freely)
_config set ["defaultDriverType", "O_T_Crew_F"];
_config set ["defaultGunnerType", "O_T_Engineer_F"];
_config set ["defaultCommanderType", "O_T_Soldier_F"];

// Return the faction hashmap
_config