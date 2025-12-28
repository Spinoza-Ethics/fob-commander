//========================================//
//           Configuration Section        //
//========================================//

buildSystem_config = createHashMap;

// Bunkers category
buildSystem_config set ["bunkers", [
	//custom build menu name, actual in game class name 
    ["Bunker (small)", "Land_BagBunker_Small_F"],
    ["Bunker (large)", "Land_BagBunker_Large_F"],
    ["Bunker Garage", "Land_Bunker_F"],
    ["Cargo Bunker (small)", "Land_Cargo_House_V1_F"],
    ["Cargo Bunker (large)", "Land_Cargo_HQ_V1_F"]
]];

// Towers category
buildSystem_config set ["towers", [
    ["Sandbag Tower", "Land_BagBunker_Small_F"],
    ["Roadblock Tower", "Land_BagBunker_Tower_F"],
    ["Guard Tower", "Land_GuardTower_02_F"],
    ["H-Barrier Tower", "Land_HBarrierTower_F"],
    ["Cargo Tower", "Land_Cargo_Patrol_V1_F"]
]];

// Camo Nets category
buildSystem_config set ["camonets", [
    ["Camo Net (small)", "CamoNet_BLUFOR_F"],
    ["Camo Net (large)", "CamoNet_BLUFOR_open_F"],
    ["Vehicle Masking Net (small)", "Land_IRMaskingCover_01_F"],
    ["Vehicle Masking Net (large)", "Land_IRMaskingCover_02_F"]
]];

// Storage category
buildSystem_config set ["storage", [
    ["Ammo Box", "VirtualReammoBox_camonet_F"],
    ["Cargo Net Box", "CargoNet_01_box_F"],
    ["Plastic Case Black", "Land_PlasticCase_01_large_black_F"],
    ["Plastic Case Olive", "Land_PlasticCase_01_large_olive_F"],
    ["Container", "B_Slingload_01_Medevac_F"]
]];

// Tents category
buildSystem_config set ["tents", [
    ["Connector Tent", "Land_ConnectorTent_01_NATO_open_F"],
    ["Connector Tent (Cross)", "Land_ConnectorTent_01_NATO_cross_F"],
    ["Tent (open)", "Land_MedicalTent_01_NATO_generic_open_F"],
    ["Tent (wide open)", "Land_MedicalTent_01_NATO_generic_outer_F"],
    ["Tent (high peak)", "Land_PartyTent_01_F"],
    ["Tent (camp)", "Land_TentDome_F"]
]];

// Clutter category
buildSystem_config set ["clutter", [
    ["Red Cargo Box", "Land_CargoBox_V1_F"],
    ["Grass Cutter", "Land_ClutterCutter_large_F"],
    ["Food Sacks", "Land_FoodSacks_01_large_brown_idap_F"],
    ["Garbage Heap 1", "Land_GarbageHeap_02_F"],
    ["Garbage Heap 2", "Land_GarbageHeap_03_F"],
    ["Garbage Square", "Land_Garbage_square5_F"],
    ["Pallet", "Land_Pallet_F"],
    ["Pallet Stack", "Land_Pallets_F"],
    ["Weapon Box Stack", "Land_Pallet_MilBoxes_F"],
    ["Box Closed", "Land_PaperBox_closed_F"],
    ["Box Open", "Land_PaperBox_open_empty_F"],
    ["Water Bottle Stack", "Land_WaterBottle_01_stack_F"],
    ["Wooden Crate Stack 5", "Land_WoodenCrate_01_stack_x5_F"]
]];

// Misc category
buildSystem_config set ["misc", [
    ["Chair", "Land_CampingChair_V1_F"],
    ["Table", "Land_CampingTable_F"],
    ["Concrete Hedgehog", "Land_ConcreteHedgehog_01_F"],
    ["Helipad", "Land_HelipadCivil_F"],
    ["Pallet Trolley", "Land_PalletTrolley_01_yellow_F"],
    ["Plastic Barrier Orange", "PlasticBarrier_03_orange_F"],
    ["Portable Light", "Land_PortableLight_double_F"],
    ["Razorwire", "Land_Razorwire_F"],
    ["Road Barrier", "RoadBarrier_F"],
    ["Gate", "Land_RoadBarrier_01_F"],
    ["Traffic Cone", "RoadCone_F"],
    ["Cot", "Land_Sun_chair_green_F"],
    ["Welding Trolley", "Land_WeldingTrolley_01_F"]
]];

// Walls (Low) category
buildSystem_config set ["walls (low)", [
    ["Razorwire", "Land_Razorwire_F"],
    ["Sandbag", "Land_BagFence_Long_F"],
    ["Sandbag Round", "Land_BagFence_Round_F"],
    ["Concrete Barrier", "Land_CncBarrier_F"],
    ["Concrete Barrier Medium", "Land_CncBarrierMedium_F"],
    ["Concrete Barrier Medium 4", "Land_CncBarrierMedium4_F"],
    ["Concrete Barrier Stripes", "Land_CncBarrier_stripes_F"],
    ["H-Barrier 3", "Land_HBarrier_3_F"],
    ["H-Barrier 5", "Land_HBarrier_5_F"],
    ["Plastic Net Fence Long", "Land_PlasticNetFence_01_long_F"],
    ["Barricade", "Land_Barricade_01_10m_F"]
]];

// Walls (Medium) category
buildSystem_config set ["walls (med)", [
    ["H-Barrier Wall 4", "Land_HBarrierWall4_F"],
    ["H-Barrier Wall 6", "Land_HBarrierWall6_F"],
    ["H-Barrier Wall Corner", "Land_HBarrierWall_corner_F"],
    ["H-Barrier Wall Corridor", "Land_HBarrierWall_corridor_F"],
    ["Sandbag Barricade", "Land_SandbagBarricade_01_F"],
    ["Sandbag Barricade Half", "Land_SandbagBarricade_01_half_F"],
    ["Sandbag Barricade Hole", "Land_SandbagBarricade_01_hole_F"]
]];

// Walls (High) category
buildSystem_config set ["walls (high)", [
    ["Concrete Shelter", "Land_CncShelter_F"],
    ["Concrete Wall 4", "Land_CncWall4_F"],
    ["H-Barrier Big", "Land_HBarrier_Big_F"],
    ["Military Wall Big 4", "Land_Mil_WallBig_4m_F"],
    ["Fence 8", "Land_Net_Fence_8m_F"]
]];

// Categories to show in main menu
buildSystem_categories = [
    ["Walls (low)", "walls (low)"],
    ["Walls (med)", "walls (med)"],
    ["Walls (high)", "walls (high)"],
    ["Bunkers", "bunkers"],
    ["Towers", "towers"],
    ["Camo Nets", "camonets"],
    ["Tents", "tents"],
    ["Storage", "storage"],
    ["Clutter", "clutter"],
    ["Misc", "misc"]
];

// Flag types that allow building
buildSystem_allowedFlags = [
    "Flag_Blue_F",
    "Flag_NATO_F"
];

// Build distance from flag (in meters)
buildSystem_flagDistance = 50;

// Distance check interval (in seconds)
buildSystem_checkInterval = 5;

//========================================//
//            Global Variables            //
//========================================//
buildSystem_objectDirection = 0;
buildSystem_objectHeight = 0;
buildSystem_currentObject = objNull;
buildSystem_currentMenu = "main"; // Track current menu state
buildSystem_actions = []; // Array to store action IDs
buildSystem_lastClassName = ""; // Store the last object class name for quick rebuild
buildSystem_placedObjects = []; // Array to track all objects placed by the build system
buildSystem_nearFlag = false; // Track if player is near blue flag
buildSystem_distanceCheckHandle = -1; // Handle for distance check script

//========================================//
//             Core Functions             //
//========================================//

// Function to remove only build system actions
buildSystem_removeActions = {
    {
        player removeAction _x;
    } forEach buildSystem_actions;
    buildSystem_actions = [];
};

// Function to add action and track it
buildSystem_addAction = {
    params ["_text", "_script", ["_priority", 100], ["_textColor", "#FFFFFF"]];
    
    private _formattedText = format ["<t color='%1'>%2</t>", _textColor, _text];
    
    if (_text == "example") then {
        _formattedText = "<t color='#FFA500' size='1.2'>example</t> <t color='#00FF00'>(Cost 2 Field Credits)</t>";
    };

    private _actionId = player addAction [_formattedText, _script, nil, _priority, true, true, "", "", 50, false, "", ""];
    buildSystem_actions pushBack _actionId;
    _actionId
};

// Function to find the nearest allowed flag
buildSystem_findAllowedFlag = {
    private _flagPos = [];
    private _nearestDistance = 999999;
    
    private _flagSearchClasses = ["FlagPole_F", "Flag_Blue_F", "Flag_NATO_F"];
    
    {
        private _flagsOfClass = allMissionObjects _x;
        
        {
            private _flagClassname = typeOf _x;
            
            if (_flagClassname in buildSystem_allowedFlags) then {
                private _distance = player distance _x;
                if (_distance < _nearestDistance) then {
                    _nearestDistance = _distance;
                    _flagPos = position _x;
                };
            };
        } forEach _flagsOfClass;
    } forEach _flagSearchClasses;
    
    _flagPos
};

// Function to check if player is within build distance of allowed flags
buildSystem_checkFlagDistance = {
    private _flagPos = call buildSystem_findAllowedFlag;
    private _wasNearFlag = buildSystem_nearFlag;
    
    if (count _flagPos > 0) then {
        private _distance = player distance _flagPos;
        buildSystem_nearFlag = _distance <= buildSystem_flagDistance;
    } else {
        buildSystem_nearFlag = false;
    };
    
    // If status changed, update actions
    if (_wasNearFlag != buildSystem_nearFlag) then {
        if (buildSystem_nearFlag) then {
            call buildSystem_removeActions;
            buildSystem_currentMenu = "main";
            ["Open Build Menu", {
                playSound "Click";
                call buildSystem_main;
            }, 199, "#FFA500"] call buildSystem_addAction;
            systemChat "Build Menu activated - within range of a F.O.B.";
        } else {
            call buildSystem_removeActions;
            if (!isNull buildSystem_currentObject) then {
                deleteVehicle buildSystem_currentObject;
                buildSystem_currentObject = objNull;
                buildSystem_objectHeight = 0;
            };
            systemChat "Build Menu deactivated - too far from a F.O.B.";
        };
    };
};

// Start the distance checking loop
buildSystem_startDistanceCheck = {
    if (buildSystem_distanceCheckHandle != -1) then {
        terminate buildSystem_distanceCheckHandle;
    };
    
    buildSystem_distanceCheckHandle = [] spawn {
        while {true} do {
            call buildSystem_checkFlagDistance;
            sleep buildSystem_checkInterval;
        };
    };
};

// Function to create and position object properly on ground
buildSystem_createAndPositionObject = {
    params ["_className"];
    
    // Check if player is still near flag before creating object
    if (!buildSystem_nearFlag) then {
        systemChat format ["You must be within %1m of an F.O.B. to build!", buildSystem_flagDistance];
        exit;
    };
    
    // Store the class name for potential rebuilding
    buildSystem_lastClassName = _className;
    
    // Create object at player position
    private _obj = _className createVehicle (position player);
    
    // Get the bounding box to find the bottom of the object
    private _boundingBox = boundingBox _obj;
    private _minZ = (_boundingBox select 0) select 2;
    
    // Calculate offset to place bottom of object slightly into ground level
    private _offsetZ = -_minZ - 0.1;
    
    // If buildSystem_objectHeight is 0 (default/reset), use the calculated offset, otherwise use the remembered height
    if (buildSystem_objectHeight == 0) then {
        buildSystem_objectHeight = _offsetZ;
    };
    
    // Attach to player with calculated offset
    _obj attachTo [player, [0, 5, buildSystem_objectHeight]];
    
    // Apply the current rotation to the new object
    _obj setDir buildSystem_objectDirection;
    
    buildSystem_currentObject = _obj;
    call buildSystem_objectAdjustment;
};

// Initialize build system (only if near fob or nato flag)
buildSystem_init = {
    if (!buildSystem_nearFlag) then {
        exit;
    };
    
    call buildSystem_removeActions;
    buildSystem_currentMenu = "main";
    ["Open Build Menu", {
        playSound "Click";
        call buildSystem_main;
    }, 199, "#FFA500"] call buildSystem_addAction;
};

// Main menu
buildSystem_main = {
    if (!buildSystem_nearFlag) then {
        systemChat format ["You must be within %1m of an F.O.B. to build!", buildSystem_flagDistance];
        exit;
    };
    
    call buildSystem_removeActions;
    buildSystem_currentMenu = "main";
    
    // Dynamically create menu from categories
    private _priority = 189;
    {
        private _displayName = _x select 0;
        private _categoryKey = _x select 1;
        [_displayName, compile format ["['%1'] call buildSystem_showCategory;", _categoryKey], _priority, "#FFFFFF"] call buildSystem_addAction;
        _priority = _priority - 1;
    } forEach buildSystem_categories;
    
    // Delete and close menu actions
    ["Delete Object", {
        call buildSystem_deleteTargetObject;
        playSound "Click";
    }, _priority - 1, "#FF0000"] call buildSystem_addAction;
    
    ["Delete All Objects", {
        call buildSystem_deleteAllObjects;
        playSound "Click";
    }, _priority - 2, "#FF0000"] call buildSystem_addAction;
    
    ["Close Menu", buildSystem_init, _priority - 3, "#FFA500"] call buildSystem_addAction;
};

// Generic function to show any category
buildSystem_showCategory = {
    params ["_categoryKey"];
    
    if (!buildSystem_nearFlag) then {
        systemChat format ["You must be within %1m of an F.O.B. to build!", buildSystem_flagDistance];
        exit;
    };
    
    call buildSystem_removeActions;
    buildSystem_currentMenu = _categoryKey;
    
    // Reset height when returning to a category menu
    buildSystem_objectHeight = 0;
    
    private _items = buildSystem_config get _categoryKey;
    private _priority = 169;
    {
        private _displayName = _x select 0;
        private _className = _x select 1;
        [_displayName, compile format ["['%1'] call buildSystem_createAndPositionObject;", _className], _priority, "#FFFFFF"] call buildSystem_addAction;
        _priority = _priority - 1;
    } forEach _items;
    
    ["Back to Main", buildSystem_main, 100.5, "#FFA500"] call buildSystem_addAction;
};

// Function to delete the object player is looking at
buildSystem_deleteTargetObject = {
    private _targetObject = cursorTarget;
    
    if (!isNull _targetObject && {_targetObject in buildSystem_placedObjects}) then {
        buildSystem_placedObjects = buildSystem_placedObjects - [_targetObject];
        deleteVehicle _targetObject;
        systemChat "Object deleted.";
    } else {
        if (isNull _targetObject) then {
            systemChat "No object targeted. Look at an object to delete it.";
        } else {
            systemChat "You can only delete objects you placed with the build system.";
        };
    };
    
    call buildSystem_main;
};

// Function to delete all objects placed by the build system
buildSystem_deleteAllObjects = {
    private _objectCount = count buildSystem_placedObjects;
    
    if (_objectCount > 0) then {
        {
            if (!isNull _x) then {
                deleteVehicle _x;
            };
        } forEach buildSystem_placedObjects;
        
        buildSystem_placedObjects = [];
        systemChat format ["Deleted %1 objects.", _objectCount];
    } else {
        systemChat "No objects to delete.";
    };
    
    call buildSystem_main;
};

// Function to return to the current menu
buildSystem_returnToCurrentMenu = {
    if (!buildSystem_nearFlag) then {
        exit;
    };
    
    switch (buildSystem_currentMenu) do {
        case "main": { call buildSystem_main; };
        default {
            if (buildSystem_currentMenu != "main") then {
                [buildSystem_currentMenu] call buildSystem_showCategory;
            } else {
                call buildSystem_main;
            };
        };
    };
};

// Object adjustment menu
buildSystem_objectAdjustment = {
    call buildSystem_removeActions;
    
    if (!isNull buildSystem_currentObject) then {
        // PLACEMENT MODE - Object is attached and ready to place
        ["Place Object", {
            if (!isNull buildSystem_currentObject) then {
                if (!buildSystem_nearFlag) then {
                    systemChat format ["You must be within %1m of an F.O.B. to build!", buildSystem_flagDistance];
                    deleteVehicle buildSystem_currentObject;
                    buildSystem_currentObject = objNull;
                    buildSystem_objectHeight = 0;
                    exit;
                };
                
                detach buildSystem_currentObject;
                buildSystem_placedObjects pushBack buildSystem_currentObject;
                buildSystem_currentObject = objNull;
                playSound "Click";
                call buildSystem_objectAdjustment;
            };
        }, 149, "#00FF00"] call buildSystem_addAction;
        
        ["Rotate Right", {
            if (!isNull buildSystem_currentObject) then {
                buildSystem_objectDirection = buildSystem_objectDirection + 45;
                if (buildSystem_objectDirection >= 360) then {
                    buildSystem_objectDirection = buildSystem_objectDirection - 360;
                };
                buildSystem_currentObject setDir buildSystem_objectDirection;
            };
        }, 148, "#FFFFFF"] call buildSystem_addAction;
        
        ["Rotate Left", {
            if (!isNull buildSystem_currentObject) then {
                buildSystem_objectDirection = buildSystem_objectDirection - 45;
                if (buildSystem_objectDirection >= 360) then {
                    buildSystem_objectDirection = buildSystem_objectDirection - 360;
                };
                buildSystem_currentObject setDir buildSystem_objectDirection;
            };
        }, 148, "#FFFFFF"] call buildSystem_addAction;
        
        ["Raise", {
            if (!isNull buildSystem_currentObject) then {
                buildSystem_objectHeight = buildSystem_objectHeight + 0.25;
                private _attachPos = attachedTo buildSystem_currentObject;
                if (!isNull _attachPos) then {
                    detach buildSystem_currentObject;
                    buildSystem_currentObject attachTo [player, [0, 5, buildSystem_objectHeight]];
                };
            };
        }, 146, "#FFFFFF"] call buildSystem_addAction;
        
        ["Lower", {
            if (!isNull buildSystem_currentObject) then {
                buildSystem_objectHeight = buildSystem_objectHeight - 0.25;
                private _attachPos = attachedTo buildSystem_currentObject;
                if (!isNull _attachPos) then {
                    detach buildSystem_currentObject;
                    buildSystem_currentObject attachTo [player, [0, 5, buildSystem_objectHeight]];
                };
            };
        }, 145, "#FFFFFF"] call buildSystem_addAction;
        
        ["Delete Object", {
            if (!isNull buildSystem_currentObject) then {
                deleteVehicle buildSystem_currentObject;
                buildSystem_currentObject = objNull;
                buildSystem_objectHeight = 0;
                call buildSystem_objectAdjustment;
            };
        }, 144, "#FF0000"] call buildSystem_addAction;
        
        ["Cancel", {
            if (!isNull buildSystem_currentObject) then {
                deleteVehicle buildSystem_currentObject;
                buildSystem_currentObject = objNull;
                buildSystem_objectHeight = 0;
            };
            call buildSystem_returnToCurrentMenu;
        }, 143, "#FFA500"] call buildSystem_addAction;
    } else {
        // BUILD MODE - No object attached, ready to build more
        ["Build Another", {
            if (buildSystem_lastClassName != "") then {
                [buildSystem_lastClassName] call buildSystem_createAndPositionObject;
            };
        }, 149, "#FFFFFF"] call buildSystem_addAction;
        
        ["Back to Category", {
            call buildSystem_returnToCurrentMenu;
        }, 148, "#FFA500"] call buildSystem_addAction;
    };
};

call buildSystem_startDistanceCheck;
call buildSystem_checkFlagDistance;