private _config = createHashMap;

// Infantry types
_config set ["infantryTypes", [
    "O_Soldier_F",
    "O_soldier_M_F",
    "O_Soldier_A_F",
    "O_Soldier_GL_F",
    "O_Soldier_AT_F",
    "O_HeavyGunner_F",
    "O_Sharpshooter_F",
    "O_engineer_F",
    "O_medic_F",
    "O_officer_F",
    "O_soldier_UAV_F",
    "O_Soldier_AR_F",
    "O_Soldier_SL_F",
    "O_Soldier_TL_F",
    "O_soldier_exp_F"
]];

// Vehicle types
_config set ["vehicleTypes", [
    "O_MRAP_02_F",
    "O_MRAP_02_hmg_F",
    "O_LSV_02_AT_F",
    "O_LSV_02_armed_F",
    "O_LSV_02_unarmed_F",
    "O_Quadbike_01_F",
    "O_Truck_03_ammo_F",
    "O_Truck_03_fuel_F",
    "O_Truck_03_medical_F",
    "O_Truck_03_repair_F",
    "O_Truck_03_transport_F",
    "O_Truck_03_covered_F",
    "O_Truck_02_Ammo_F",
    "O_Truck_02_medical_F",
    "O_Truck_02_box_F",
    "O_Truck_02_transport_F",
    "O_Truck_02_covered_F",
    "O_APC_Wheeled_02_rcws_v2_F",
    "O_Heli_Transport_04_bench_F",
    "O_Heli_Transport_04_box_F",
    "O_Heli_Transport_04_fuel_F",
    "O_Heli_Transport_04_covered_F",
    "O_Heli_Attack_02_dynamicLoadout_F",
    "O_Heli_Light_02_dynamicLoadout_F",
    "O_Heli_Light_02_unarmed_F",
    "O_UAV_02_dynamicLoadout_F",
    "C_Offroad_02_unarmed_F",
    "C_Offroad_01_F",
    "C_Offroad_01_comms_F",
    "C_Offroad_01_covered_F",
    "C_Offroad_01_repair_F",
    "C_Quadbike_01_F",
    "C_Van_01_transport_F",
    "C_Van_01_box_F",
    "C_Van_02_transport_F",
    "C_Van_02_service_F",
    "C_Offroad_01_F", 
    "C_Heli_Light_01_civil_F",
    "C_IDAP_Heli_Transport_02_F",
    "C_IDAP_Offroad_02_unarmed_F", 
    "C_IDAP_Truck_02_water_F",
    "C_IDAP_Truck_02_F",
    "C_IDAP_Truck_02_transport_F",
    "C_IDAP_Van_02_transport_F",
    "C_IDAP_Van_02_medevac_F",
    "C_IDAP_Offroad_01_F",
    "C_IDAP_Offroad_02_unarmed_F", 
    "C_IDAP_Offroad_01_F", 
    "O_MRAP_02_F",
    "O_MRAP_02_F"  
]];

// Armored vehicle types
_config set ["armoredVehicleTypes", [
    "O_MRAP_02_hmg_F",
    "O_APC_Tracked_02_cannon_F",
    "O_APC_Wheeled_02_rcws_v2_F",
    "O_LSV_02_armed_F",
    "O_LSV_02_AT_F",
    "O_MBT_02_cannon_F"
]];

// Static weapon types
//list name(dont change), classname (edit freely)
_config set ["staticATTypes", ["I_AT_Static_01_F", "I_Static_AT_F"]];
_config set ["staticMGTypes", ["I_HMG_02_F", "I_HMG_02_high_F"]];
_config set ["mortarTypes", ["O_Mortar_01_F"]];

// Default crew types
//list name(dont change), classname (edit freely)
_config set ["defaultDriverType", "O_engineer_F"];
_config set ["defaultGunnerType", "O_crew_F"];
_config set ["defaultCommanderType", "O_Soldier_SL_F"];

// Return the faction hashmap
_config