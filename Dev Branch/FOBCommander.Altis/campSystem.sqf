//========================================//
//             Camp Emplacements          //
//========================================//

// Define the fixed set of camp objects for emplacement 1 (solo player)
private _campObjectsEmplacement1 = [
    ["Land_TentSolar_01_folded_sand_F", [-3.97754, 2.27539, 0], 201.022],
    ["Land_TentDome_F", [-4.36426, 0.494141, 0], 9.07733],
    ["dmpCampingLampON", [-4.47461, 2.35352, 0], 0],
    ["Land_Pillow_grey_F", [-4.96094, 3.50781, 1.90735e-06], 219.363],
    ["Land_Sleeping_bag_brown_F", [-5.08301, 3.15234, 0], 59.8084],
    ["Land_TinContainer_F", [-7.70898, 2.21875, 0], 249.167],
    ["Campfire_burning_F", [-8.46191, 1.68945, 0.0299988], 175.03],
    ["Land_Garbage_square3_F", [-7.12988, 5.16797, 0], 280.901],
    ["Land_WoodenLog_F", [-8.62891, 3.22852, 0], 92.2363]
];

// Define the fixed set of camp objects for emplacement 2 (player with squadmates)
private _campObjectsEmplacement2 = [
    ["dmpCampingLampON", [1.19824, 2.0957, 0], 0],
    ["Land_TinContainer_F", [0.185547, -3.35938, 0], 91.989],
    ["Land_WoodenLog_F", [-2.53027, -2.21094, 0], 92.2363],
    ["Land_CanisterPlastic_F", [-3.16602, 1.66602, 0], 204.868],
    ["Land_Garbage_square5_F", [0.771484, 3.74023, 0], 38.1039],
    ["Campfire_burning_F", [1.25293, -3.58789, 0.0299988], 175.03],
    ["Land_Garbage_square5_F", [-2.02832, -3.94531, 0], 198.821],
    ["Land_TentSolar_01_folded_sand_F", [-4.19043, 1.36328, 0], 0],
    ["Land_CampingChair_V2_F", [3.57129, -2.92383, 0], 67.9239],
    ["Land_Sacks_heap_F", [-3.6875, 3.31445, 0], 46.9263],
    ["Land_Sleeping_bag_brown_F", [3.97461, 4.00977, 0], 59.8084],
    ["Land_Sleeping_bag_F", [-1.76953, 5.43555, 0], 302.783],
    ["CamoNet_BLUFOR_open_F", [1.12793, 5.78906, -0.0540009], 180],
    ["Land_BagFence_Round_F", [-5.16504, 2.33594, -0.00130081], 45],
    ["Land_Sleeping_bag_blue_F", [1.30176, 6.10938, 0.0321636], 0],
    ["Land_CampingChair_V2_F", [3.24414, -4.76367, 0], 125.218],
    ["Land_Pillow_old_F", [3.91211, 4.84766, 0], 74.2452],
    ["Land_TentDome_F", [5.93848, 2.33789, 0], 32.5271],
    ["Land_Pillow_grey_F", [1.04297, 6.31055, 0], 160.729],
    ["Land_BagFence_Long_F", [-5.52539, 5.04492, -0.000999451], 90],
    ["Land_WaterBottle_01_compressed_F", [-3.47266, 6.83008, 0], 0],
    ["MedicalGarbage_01_1x1_v2_F", [-3.9668, 6.71875, 0], 123.647],
    ["Land_Sleeping_bag_brown_folded_F", [-3.09375, 7.1875, 0], 98.8261],
    ["Land_TentDome_F", [-0.885742, 8.17188, 0], 252.658],
    ["Land_WaterBottle_01_pack_F", [-3.74805, 7.14453, 0], 0],
    ["dmpSleepingBag_V", [-3.58594, 7.61719, 0], 0],
    ["Land_TentDome_F", [3.43848, 8.20703, 0], 282.395],
    ["Land_TentDome_F", [6.59668, 5.97656, 0], 350.439],
    ["Land_BagFence_Round_F", [-5.12012, 7.78906, -0.00130081], 135],
    ["Land_SharpStone_02", [-4.56738, 9.74609, 0], 133.001],
    ["Land_Basket_F", [6.28613, 8.92773, 0], 184.108],
    ["Land_WoodPile_F", [5.36914, 10.3262, 0], 277.724],
    ["Land_Sack_F", [7.14453, 9.64258, 0], 33.1445],
    ["Snake_random_F", [-39.2881, -26.3633, 0.00838852], 61.1387]
];

missionNamespace setVariable ["CurrentDeployedCampMarker", "", true];

//========================================//
//            Build Camp Action           //
//========================================//
player addAction ["<t color='#3399FF' size='1.2'>-Build Camp-</t>", {
    params ["_target", "_caller", "_actionId", "_params"];

    // Retrieve both emplacement definitions from parameters
    private _emplacement1 = _params select 0;
    private _emplacement2 = _params select 1;

    // Determine which set of objects to spawn based on player's squad size
    private _objectsToSpawn = if (count (units group _caller) == 1) then {
        _emplacement1
    } else {
        _emplacement2
    };

    // Check if a camp is already built
    private _existingCampMarker = missionNamespace getVariable ["CurrentDeployedCampMarker", ""];
    if (!(_existingCampMarker isEqualTo "") && (markerType _existingCampMarker != "")) exitWith {
        _caller sideChat "A camp is already deployed. Only one camp allowed at a time.";
    };

    private _safezone = [];
    private _minDistance = 5;
    private _maxDistance = 10;
    private _maxAttempts = 100;
    private _spawned = false;
    private _addMapMarker = true;

    private _spawnAttempts = 0;
    private _playerPos = getPos player;
    private _marker = "";

    // Build Camp Logic
    while {!_spawned && _spawnAttempts < _maxAttempts} do {
        _spawnAttempts = _spawnAttempts + 1;
        private _safePos = [_playerPos, _minDistance, _maxDistance, 5, 0, 0.3, 0, [], _playerPos] call BIS_fnc_findSafePos;
        if (_safePos isEqualTo []) then { continue; };

        private _inBase = _safezone apply { _safePos inArea _x };
        if (true in _inBase) then { continue; };

        private _campDir = random 360;

        {
            _x hideObjectGlobal true;
        } forEach nearestTerrainObjects [_safePos, ["HIDE", "BUILDING", "FENCE", "WALL", "TREE", "SMALL TREE", "BUSH", "SIGN"], 15];

        private _buildTime = 5;

        player sideChat "Building Camp. Please wait...";
        playSound "campDig";
        for "_i" from 1 to _buildTime do {
            sleep 1;
        };

        private _deployedObjects = [_safePos, _campDir, _objectsToSpawn] call BIS_fnc_objectsMapper;

        if (_addMapMarker) then {
            private _markerNameText = "Camp";
            private _markerType = "mil_dot";
            private _uniqueMarkerName = format ["Camp_%1", round(random 100000)];
            _marker = createMarker [_uniqueMarkerName, _safePos];
            _marker setMarkerType _markerType;
            _marker setMarkerColor "ColorGreen";
            _marker setMarkerText _markerNameText;
            missionNamespace setVariable ["CurrentDeployedCampMarker", _uniqueMarkerName, true]; // Store the marker name globally
        };

        private _campfire = objNull;
        // Find the Campfire_burning_F object to attach actions
        {
            if (_x isKindOf "Campfire_burning_F") then {
                _campfire = _x;
                break;
            };
        } forEach _deployedObjects;
        
        if (!isNull _campfire) then {
            // Pack up Camp Action
            _campfire addAction ["<t color='#00FF00' size='1.2'>Pack up Camp</t>", {
                params ["_target", "_caller", "_actionId", "_params"];
                private _objectsToDelete = _params select 0;
                private _markerToDelete = _params select 1;
                
                private _packTime = 5;
                _caller sideChat "Packing up Camp. Please wait...";
                playSound "campDig";
                for "_i" from 1 to _packTime do {
                    sleep 1;
                };
                { deleteVehicle _x } forEach _objectsToDelete;
                if (!isNil "_markerToDelete" && {_markerToDelete != ""}) then { deleteMarker _markerToDelete; };
                _caller sideChat "Camp packed up.";
                missionNamespace setVariable ["CurrentDeployedCampMarker", "", true]; // Clear the global camp marker
            }, [_deployedObjects, _marker], 99.6, true, true, "", "true", 5, false, "", ""];

            // Rest Action
            _campfire addAction ["<t color='#FFDD00' size='1.2'>Rest</t>", {
                params ["_target", "_caller", "_actionId"];
                skipTime 4;
                _caller sideChat "Rested for 4 Hours.";
                playSound "Click";
            }, nil, 99.5, true, true, "", "true", 5, false, "", ""];
        };
        
        player sideChat "Camp successfully deployed.";
        nul = [] execVM "sitrepScreen.sqf";
        _spawned = true;
    };

    if (!_spawned) then {
        player sideChat "No Suitable Position to Deploy the Camp.";
    };
}, [_campObjectsEmplacement1, _campObjectsEmplacement2], 99.7, true, true, "", "true", 5, false, "", ""];