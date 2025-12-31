//========================================//
//          Faction Initialization        //
//========================================//
private _playerFaction = call compile preprocessFileLineNumbers "factions\playerFaction.sqf";

private _flagType = _playerFaction get "flagType";
private _unitTypes = _playerFaction get "unitTypes";
private _vehicleTypes = _playerFaction get "vehicleTypes";
private _fixedFOB = _playerFaction get "fixedFOB";

//========================================//
//             Main Function              //
//========================================//
player addAction ["<t color='#3399FF' size='1.2'>-Build F.O.B.-</t>", {
    params ["_target", "_caller", "_actionId", "_flagType_param"];

    private _nearbyRedFlags = nearestObjects [_caller, ["Flag_Red_F"], 100];
    if (count _nearbyRedFlags > 0) exitWith {
        _caller sideChat "Cannot build F.O.B. too close to an enemy flag (within 100m). Capture the enemy flag first.";
    };

    private _nearbyFlags = nearestObjects [player, [_flagType_param], 4000];
    if (count _nearbyFlags > 0) exitWith { player sideChat "Cannot build F.O.B.s within (4000m) of each other"; };

    private _safezone = [];
    private _minDistance = 5;
    private _maxDistance = 10;
    private _maxAttempts = 100;
    private _spawned = false;
    private _addMapMarker = true;

    private _fixedFOB_local = missionNamespace getVariable ["_fixedFOB", []];
    if (_fixedFOB_local isEqualTo []) then {
        private _tempConfig = call compile preprocessFileLineNumbers "factions\playerFaction.sqf";
        _fixedFOB_local = _tempConfig get "fixedFOB";
    };

    private _spawnAttempts = 0;
    private _playerPos = getPos player;
    private _marker = "";

    //========================================//
    //     Global Functions & Variables Setup //
    //========================================//
    missionNamespace setVariable ["fob_vehicleSpawnTimes", []];
    missionNamespace setVariable ["fob_canSpawnVehicle", {
        private _times = missionNamespace getVariable ["fob_vehicleSpawnTimes", []];
        private _now = time;
        _times = _times select { _x > (_now - 600) };
        missionNamespace setVariable ["fob_vehicleSpawnTimes", _times];
        if (count _times < 2) then {
            missionNamespace setVariable ["fob_vehicleSpawnTimes", _times + [_now]];
            true
        } else {
            false
        };
    }];

    missionNamespace setVariable ["fob_canSpawnDrone", {
        private _lastDroneTime = missionNamespace getVariable ["lastDroneSpawnTime", -9999];
        private _now = time;
        if (_now - _lastDroneTime > 600) then { missionNamespace setVariable ["lastDroneSpawnTime", _now, true]; true } else { false };
    }];

    missionNamespace setVariable ["fob_canSpawnMortar", {
        private _lastMortarTime = missionNamespace getVariable ["lastMortarSpawnTime", -9999];
        private _now = time;
        if (_now - _lastMortarTime > 600) then { missionNamespace setVariable ["lastMortarSpawnTime", _now, true]; true } else { false };
    }];

    missionNamespace setVariable ["fob_canSpawnAirSupportRadio", {
        private _lastAirSupportRadioTime = missionNamespace getVariable ["lastAirSupportRadioSpawnTime", -9999];
        private _now = time;
        if (_now - _lastAirSupportRadioTime > 600) then { missionNamespace setVariable ["lastAirSupportRadioSpawnTime", _now, true]; true } else { false };
    }];

    fnc_cleanupSubmenu = {
        params ["_objectWithActions", "_submenuVarName", "_distanceThreshold"];
        private _startTime = time;
        private _timeoutDuration = 10;
        private _cleanupCondition = {
            !(player distance2D _objectWithActions < _distanceThreshold) ||
            (time - _startTime > _timeoutDuration)
        };
        waitUntil { call _cleanupCondition };
        private _submenuActions = _objectWithActions getVariable [_submenuVarName, []];
        { _objectWithActions removeAction _x } forEach _submenuActions;
        _objectWithActions setVariable [_submenuVarName, []];
    };

    fnc_executeMission = {
        params ["_missionData", "_caller"];
        private _missionName = _missionData select 0;
        private _scriptFile = _missionData select 1;
        nul = [] execVM _scriptFile;
    };

    //========================================//
    //          Build FOB Function            //
    //========================================//
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
        
        // Flatten grass radius
        private _grassCutter1 = createVehicle ["Land_ClutterCutter_large_F", _safePos, [], 0, "NONE"];
        _grassCutter1 setPos _safePos;

        private _grassCutters = [];
        for "_i" from 0 to 270 step 90 do {
            private _cutterPos = _safePos getPos [8, _i];
            private _grassCutter = createVehicle ["Land_ClutterCutter_large_F", _cutterPos, [], 0, "NONE"];
            _grassCutter setPos _cutterPos;
            _grassCutters pushBack _grassCutter;
        };

        private _buildTime = 8;
        playSound "fobDig";

        player sideChat "Building F.O.B. Please wait...";
        for "_i" from 1 to _buildTime do {
            sleep 1;
        };

        private _fobObjects = [_safePos, _campDir, _fixedFOB_local] call BIS_fnc_objectsMapper;

        if (_addMapMarker) then {
            private _markerNameText = "F.O.B.";
            private _markerType = "b_installation";
            private _uniqueMarkerName = format ["FOB_%1", round(random 100000)];
            _marker = createMarker [_uniqueMarkerName, _safePos];
            _marker setMarkerType _markerType;
            _marker setMarkerColor "ColorBlue";
            _marker setMarkerText _markerNameText;
        };

        private _flag = nil;
        {
            if (_x isKindOf _flagType_param) then { _flag = _x };
        } forEach _fobObjects;

        if (!isNil "_flag") then {
            private _signOffset = _flag getRelPos [2, 210];
            private _groundZ = getTerrainHeightASL _signOffset;
            private _signASL = _signOffset vectorAdd [0, 0, _groundZ];
            private _signATL = ASLToATL _signASL;
            private _vehicleSign = createVehicle ["MapBoard_altis_F", [0,0,0], [], 0, "NONE"];
            _vehicleSign setPosATL _signATL;
            _vehicleSign setDir (getDir _flag);
            _vehicleSign allowDamage false;
            _vehicleSign enableSimulation false;
            _flag setVariable ["fob_vehicleSign", _vehicleSign, true];

            //========================================//
            //          Pack up FOB Function          //
            //========================================//
            _flag addAction ["<t color='#00FF00' size='1.2'>Pack up FOB</t>", {
                params ["_target", "_caller", "_actionId", "_params"];
                private _packTime = 8;
                _caller sideChat "Packing up F.O.B. Please wait...";
                playSound "fobDig";
                for "_i" from 1 to _packTime do {
                    sleep 1;
                };
                { deleteVehicle _x } forEach (_params select 0);
                if (!isNil {_params select 1} && {_params select 1 != ""}) then { deleteMarker (_params select 1); };
                private _sign = _target getVariable ["fob_vehicleSign", objNull];
                if (isNull _sign) exitWith {};
                if (alive _sign) then {
                    deleteVehicle _sign;
                };
                _caller sideChat "F.O.B. packed up.";
                
            }, [_fobObjects, _marker], 97.1, true, true, "", "true", 5, false, "", ""];
            
			//========================================//
			//          Side Mission Function         //
			//========================================//
			_vehicleSign addAction [
				"<t color='#FFA500' size='1.2'>Request Mission</t> <t color='#00FF00'>(XP)</t>",
				{
					params ["_target", "_caller", "_actionId"];
					private _lastMissionTime = missionNamespace getVariable ["lastSideMissionTime", -9999];
					private _now = time;
					if (_now - _lastMissionTime < 10) exitWith {
						private _remaining = 10 - (_now - _lastMissionTime);
						_caller sideChat format ["Side mission cooldown: %1 seconds remaining.", ceil _remaining];
					};
					missionNamespace setVariable ["lastSideMissionTime", _now];
					
					private _missionConfig = [
						["Downed Chopper", "missions\downedChopper.sqf"],
						["Radio Tower", "missions\radioTower.sqf"],
						["Ammo Cache", "missions\ammoCache.sqf"],
						["Fuel Depot", "missions\fuelDepot.sqf"],
						["Anti-Air", "missions\antiAir.sqf"],
						["Stolen NATO Vehicle", "missions\stolenVehicle.sqf"],
						["Intel", "missions\retriveIntel.sqf"],
						["Vehicle Wreck Site", "missions\vehicleWreck.sqf"],
						["Rescue HVT", "missions\rescueHVT.sqf"],
						["Eliminate HVT", "missions\eliminateHVT.sqf"]
					];
					
					// Get last 2 missions to prevent repeats
					private _lastMissions = missionNamespace getVariable ["lastSideMissions", []];
					
					// Filter out recently used missions
					private _availableMissions = _missionConfig select {
						!(((_x select 0) in _lastMissions))
					};
					
					// If all missions were recently used, reset the history
					if (count _availableMissions == 0) then {
						_availableMissions = _missionConfig;
						_lastMissions = [];
					};
					
					private _selectedMissionData = selectRandom _availableMissions;
					
					// Update mission history (keep last 2 missions)
					_lastMissions pushBack (_selectedMissionData select 0);
					if (count _lastMissions > 2) then {
						_lastMissions deleteAt 0; // Remove oldest mission
					};
					missionNamespace setVariable ["lastSideMissions", _lastMissions];
					
					[_selectedMissionData, _caller] call fnc_executeMission;
					playSound "missionBrief";
				},
				nil, 98.9, true, true, "", "true", 5, false, "", ""
			];

            //========================================//
            //       Logistic Mission Function        //
            //========================================//
            _vehicleSign addAction [
                "<t color='#FFA500' size='1.2'>Request Logistics Mission</t> <t color='#00FF00'>(Fc)</t>",
                {
                    params ["_target", "_caller", "_actionId"];
                    private _lastLogisticsMissionTime = missionNamespace getVariable ["lastLogisticsMissionTime", -9999];
                    private _now = time;
                    if (_now - _lastLogisticsMissionTime < 10) exitWith {
                        private _remaining = 10 - (_now - _lastLogisticsMissionTime);
                        _caller sideChat format ["Logistics mission cooldown: %1 seconds remaining.", ceil _remaining];
                    };
                    missionNamespace setVariable ["lastLogisticsMissionTime", _now];
                    private _logisticsMissionConfig = [
                        ["Logistics Mission", "missions\logisticMission.sqf"]
                    ];
                    private _selectedLogisticsMissionData = selectRandom _logisticsMissionConfig;
                    [_selectedLogisticsMissionData, _caller] call fnc_executeMission;
                    playSound "missionBrief";
                },
                nil, 98.8, true, true, "", "true", 5, false, "", ""
            ];

            //========================================//
            //         Outpost Mission Function       //
            //========================================//
            _vehicleSign addAction [
                "<t color='#FFA500' size='1.2'>Request Outpost Mission</t>",
                {
                    params ["_target", "_caller", "_actionId"];

                    // Rank Check
                    private _requiredRank = "Corporal";
                    private _currentRank = _caller getVariable ["Rank", "Private"];
                    private _rankHierarchy = ["Recruit", "Private", "Corporal", "Sergeant", "Staff Sergeant", "Lieutenant", "Captain", "Major", "Colonel", "Warlord", "FOB Commander"];
                    private _playerRankIndex = _rankHierarchy find _currentRank;
                    private _requiredRankIndex = _rankHierarchy find _requiredRank;

                    if (_playerRankIndex < _requiredRankIndex) exitWith {
                        _caller sideChat format ["Rank too low. Need %1.", _requiredRank];
                    };

                    private _lastOutpostMissionTime = missionNamespace getVariable ["lastOutpostMissionTime", -9999];
                    private _now = time;
                    if (_now - _lastOutpostMissionTime < 10) exitWith {
                        private _remaining = 10 - (_now - _lastOutpostMissionTime);
                        _caller sideChat format ["Outpost mission cooldown: %1 seconds remaining.", ceil _remaining];
                    };
                    missionNamespace setVariable ["lastOutpostMissionTime", _now];
                    private _outpostMissionConfig = [
                        ["Outpost Mission", "missions\outpostMission.sqf"]
                    ];
                    private _selectedOutpostMissionData = selectRandom _outpostMissionConfig;
                    [_selectedOutpostMissionData, _caller] call fnc_executeMission;
                    playSound "missionBrief";
                },
                nil, 98.7, true, true, "", "true", 5, false, "", ""
            ];

            //========================================//
            //          FOB Mission Function          //
            //========================================//
            _vehicleSign addAction [
                "<t color='#FFA500' size='1.2'>Request FOB Mission</t>",
                {
                    params ["_target", "_caller", "_actionId"];

                    // Rank Check
                    private _requiredRank = "Lieutenant";
                    private _currentRank = _caller getVariable ["Rank", "Private"];
                    private _rankHierarchy = ["Recruit", "Private", "Corporal", "Sergeant", "Staff Sergeant", "Lieutenant", "Captain", "Major", "Colonel", "Warlord", "FOB Commander"];
                    private _playerRankIndex = _rankHierarchy find _currentRank;
                    private _requiredRankIndex = _rankHierarchy find _requiredRank;

                    if (_playerRankIndex < _requiredRankIndex) exitWith {
                        _caller sideChat format ["Rank too low. Need %1.", _requiredRank];
                    };

                    private _lastFOBMissionTime = missionNamespace getVariable ["lastFOBMissionTime", -9999];
                    private _now = time;
                    if (_now - _lastFOBMissionTime < 10) exitWith {
                        private _remaining = 10 - (_now - _lastFOBMissionTime);
                        _caller sideChat format ["FOB mission cooldown: %1 seconds remaining.", ceil _remaining];
                    };
                    missionNamespace setVariable ["lastFOBMissionTime", _now];
                    private _fobMissionConfig = [
                        ["FOB Mission", "missions\fobMission.sqf"]
                    ];
                    private _selectedFOBMissionData = selectRandom _fobMissionConfig;
                    [_selectedFissionData, _caller] call fnc_executeMission;
                    playSound "missionBrief";
                },
                nil, 98.6, true, true, "", "true", 5, false, "", ""
            ];

            //========================================//
            //           HQ Mission Function          //
            //========================================//
            _vehicleSign addAction [
                "<t color='#FFA500' size='1.2'>Request HQ Mission</t>",
                {
                    params ["_target", "_caller", "_actionId"];

                    // Rank Check
                    private _requiredRank = "Colonel";
                    private _currentRank = _caller getVariable ["Rank", "Private"];
                    private _rankHierarchy = ["Recruit", "Private", "Corporal", "Sergeant", "Staff Sergeant", "Lieutenant", "Captain", "Major", "Colonel", "Warlord", "FOB Commander"];
                    private _playerRankIndex = _rankHierarchy find _currentRank;
                    private _requiredRankIndex = _rankHierarchy find _requiredRank;

                    if (_playerRankIndex < _requiredRankIndex) exitWith {
                        _caller sideChat format ["Rank too low. Need %1.", _requiredRank];
                    };

                    private _lastHQMissionTime = missionNamespace getVariable ["lastHQMissionTime", -9999];
                    private _now = time;
                    if (_now - _lastHQMissionTime < 10) exitWith {
                        private _remaining = 10 - (_now - _lastHQMissionTime);
                        _caller sideChat format ["HQ mission cooldown: %1 seconds remaining.", ceil _remaining];
                    };
                    missionNamespace setVariable ["lastHQMissionTime", _now];
                    private _hqMissionConfig = [
                        ["HQ Mission", "missions\hqMission.sqf"]
                    ];
                    private _selectedHQMissionData = selectRandom _hqMissionConfig;
                    [_selectedHQMissionData, _caller] call fnc_executeMission;
                    playSound "missionBrief";
                },
                nil, 98.5, true, true, "", "true", 5, false, "", ""
            ];

            //========================================//
            //        Research Mission Function       //
            //========================================//
            _vehicleSign addAction [
                "<t color='#FFA500' size='1.2'>Request Top Secret Mission</t>",
                {
                    params ["_target", "_caller", "_actionId"];

                    // Rank Check
                    private _requiredRank = "Warlord";
                    private _currentRank = _caller getVariable ["Rank", "Private"];
                    private _rankHierarchy = ["Recruit", "Private", "Corporal", "Sergeant", "Staff Sergeant", "Lieutenant", "Captain", "Major", "Colonel", "Warlord", "FOB Commander"];
                    private _playerRankIndex = _rankHierarchy find _currentRank;
                    private _requiredRankIndex = _rankHierarchy find _requiredRank;

                    if (_playerRankIndex < _requiredRankIndex) exitWith {
                        _caller sideChat format ["Rank too low. Need %1.", _requiredRank];
                    };

                    private _lastResearchMissionTime = missionNamespace getVariable ["lastResearchMissionTime", -9999];
                    private _now = time;
                    if (_now - _lastResearchMissionTime < 10) exitWith {
                        private _remaining = 10 - (_now - _lastResearchMissionTime);
                        _caller sideChat format ["Research mission cooldown: %1 seconds remaining.", ceil _remaining];
                    };
                    missionNamespace setVariable ["lastResearchMissionTime", _now];
                    private _researchMissionConfig = [
                        ["Research Mission", "missions\researchMission.sqf"]
                    ];
                    private _selectedResearchMissionData = selectRandom _researchMissionConfig;
                    [_selectedResearchMissionData, _caller] call fnc_executeMission;
                    playSound "missionBrief";
                },
                nil, 98.4, true, true, "", "true", 5, false, "", ""
            ];

            //========================================//
            //            Vehicle Function            //
            //========================================//
            private _vehiclePricing = createHashMap;

            // Default vehicle costs
            _vehiclePricing set ["default_unarmed_cost", 2];
            _vehiclePricing set ["default_unarmed_rank", ""];
            _vehiclePricing set ["default_armed_cost", 3];
            _vehiclePricing set ["default_armed_rank", ""];

            // Tracked vehicles (tanks, APCs with tracks)
            _vehiclePricing set ["tracked_cost", 8];
            _vehiclePricing set ["tracked_rank", "Lieutenant"];

            // MRAP vehicles (Hunter, Ifrit, Strider, etc.)
            _vehiclePricing set ["mrap_unarmed_cost", 2];
            _vehiclePricing set ["mrap_unarmed_rank", ""];
            _vehiclePricing set ["mrap_armed_cost", 3];
            _vehiclePricing set ["mrap_armed_rank", ""];

            // AFV (Armored Fighting Vehicles)
            _vehiclePricing set ["afv_unarmed_cost", 5];
            _vehiclePricing set ["afv_unarmed_rank", "Corporal"];
            _vehiclePricing set ["afv_armed_cost", 6];
            _vehiclePricing set ["afv_armed_rank", "Sergeant"];

            // Trucks
            _vehiclePricing set ["truck_basic_cost", 1];
            _vehiclePricing set ["truck_basic_rank", ""];
            _vehiclePricing set ["truck_utility_cost", 2];
            _vehiclePricing set ["truck_utility_rank", "Corporal"];
            _vehiclePricing set ["truck_armed_cost", 3];
            _vehiclePricing set ["truck_armed_rank", "Corporal"];

            // Helicopters
            _vehiclePricing set ["heli_unarmed_cost", 8];
            _vehiclePricing set ["heli_unarmed_rank", "Sergeant"];
            _vehiclePricing set ["heli_armed_cost", 10];
            _vehiclePricing set ["heli_armed_rank", "Lieutenant"];

            // Planes
            _vehiclePricing set ["plane_unarmed_cost", 12];
            _vehiclePricing set ["plane_unarmed_rank", "Sergeant"];
            _vehiclePricing set ["plane_armed_cost", 15];
            _vehiclePricing set ["plane_armed_rank", "Lieutenant"];

            // Ships
            _vehiclePricing set ["ship_unarmed_cost", 2];
            _vehiclePricing set ["ship_unarmed_rank", ""];
            _vehiclePricing set ["ship_armed_cost", 4];
            _vehiclePricing set ["ship_armed_rank", "Sergeant"];

            // Submarines
            _vehiclePricing set ["submarine_cost", 4];
            _vehiclePricing set ["submarine_rank", "Sergeant"];

            // Submenu timeout (seconds)
            private _submenuTimeout = 20;

            // Function to check if vehicle has weapons (excluding horns)
            private _fnc_hasWeapons = {
                params ["_classname"];
                private _hasRealWeapons = false;
                
                // List of non-combat "weapons" to ignore
                private _hornWeapons = ["CarHorn", "TruckHorn", "SportCarHorn", "TruckHorn2", "CarHorn2", "CarHorn3", "Truck_01_Horn", "Truck_02_Horn", "Truck_03_Horn"];
                
                // Create a temporary vehicle to check its actual weapons
                private _tempVeh = createVehicle [_classname, [0,0,0], [], 0, "CAN_COLLIDE"];
                
                if (!isNull _tempVeh) then {
                    // Check all turret paths for weapons
                    private _allTurrets = [[-1]] + (allTurrets _tempVeh);
                    
                    {
                        private _turretWeapons = _tempVeh weaponsTurret _x;
                        {
                            if !(_x in _hornWeapons) then {
                                _hasRealWeapons = true;
                                break;
                            };
                        } forEach _turretWeapons;
                        if (_hasRealWeapons) then { break; };
                    } forEach _allTurrets;
                    
                    deleteVehicle _tempVeh;
                };
                
                _hasRealWeapons
            };

            _vehicleSign addAction [
                "<t color='#FFA500' size='1.2'>Request Vehicle</t>",
                {
                    params ["_target", "_caller", "_actionId"];
                    private _vehicleSubmenuActions = _target getVariable ["vehicleSubmenuActions", []];
                    if (count _vehicleSubmenuActions > 0) then {
                        { _target removeAction _x } forEach _vehicleSubmenuActions;
                        _target setVariable ["vehicleSubmenuActions", []];
                    } else {
                        private _fobFlag = _target getVariable ["fob_parentFlag", objNull];
                        private _vehicleTypes_local = missionNamespace getVariable ["_vehicleTypes", []];
                        if (_vehicleTypes_local isEqualTo []) then {
                            private _tempConfig = call compile preprocessFileLineNumbers "factions\playerFaction.sqf";
                            _vehicleTypes_local = _tempConfig get "vehicleTypes";
                        };
                        
                        // Get pricing config from parent scope
                        private _vehiclePricing = _target getVariable ["vehiclePricing", createHashMap];
                        private _submenuTimeout = _target getVariable ["submenuTimeout", 10];
                        private _fnc_hasWeapons = _target getVariable ["fnc_hasWeapons", {}];
                        
                        private _newSubmenuActions = [];
                        {
                            private _label = _x select 0;
                            private _classname = _x select 1;
                            private _cost = _vehiclePricing get "default_unarmed_cost";
                            private _requiredRank = _vehiclePricing get "default_unarmed_rank";
                            private _vehicleConfig = configFile >> "CfgVehicles" >> _classname;
                            
                            // Check if vehicle has weapons
                            private _hasWeapons = [_classname] call _fnc_hasWeapons;
                            
                            // Check for tracked vehicles (tanks, APCs, etc.) or mortars - HIGHEST PRIORITY
                            if (getNumber(_vehicleConfig >> "tracksSpeed") > 0 || _classname == "B_Mortar_01_weapon_F") then {
                                _cost = _vehiclePricing get "tracked_cost";
                                _requiredRank = _vehiclePricing get "tracked_rank";
                            } else {
                                // AFV (Armored Fighting Vehicle) classification - SECOND PRIORITY
                                if (_classname isKindOf "Wheeled_APC_F" || _classname isKindOf "Tank_F" || _classname isKindOf "APC_Wheeled_01_base_F" || _classname isKindOf "APC_Tracked_01_base_F") then {
                                    if (_hasWeapons) then {
                                        _cost = _vehiclePricing get "afv_armed_cost";
                                        _requiredRank = _vehiclePricing get "afv_armed_rank";
                                    } else {
                                        _cost = _vehiclePricing get "afv_unarmed_cost";
                                        _requiredRank = _vehiclePricing get "afv_unarmed_rank";
                                    };
                                } else {
                                    // MRAP (Mine-Resistant Ambush Protected) classification - THIRD PRIORITY
                                    if (_classname isKindOf "MRAP_01_base_F" || 
                                        _classname isKindOf "MRAP_02_base_F" || 
                                        _classname isKindOf "MRAP_03_base_F" || 
                                        _classname find "Hunter" > -1 || 
                                        _classname find "Ifrit" > -1 || 
                                        _classname find "Strider" > -1 ||
                                        _classname find "EF_B_MRAP_01" > -1) then {
                                        if (_hasWeapons) then {
                                            _cost = _vehiclePricing get "mrap_armed_cost";
                                            _requiredRank = _vehiclePricing get "mrap_armed_rank";
                                        } else {
                                            _cost = _vehiclePricing get "mrap_unarmed_cost";
                                            _requiredRank = _vehiclePricing get "mrap_unarmed_rank";
                                        };
                                    } else {
                                        // Truck classification - FOURTH PRIORITY
                                        if (_classname isKindOf "Truck_F" || _classname isKindOf "Truck_01_base_F" || _classname isKindOf "Truck_02_base_F" || _classname isKindOf "Truck_03_base_F") then {
                                            private _isUtility = (_classname find "medical" > -1) || (_classname find "repair" > -1) || (_classname find "fuel" > -1) || (_classname find "ammo" > -1);
                                            if (_hasWeapons) then {
                                                _cost = _vehiclePricing get "truck_armed_cost";
                                                _requiredRank = _vehiclePricing get "truck_armed_rank";
                                            } else {
                                                if (_isUtility) then {
                                                    _cost = _vehiclePricing get "truck_utility_cost";
                                                    _requiredRank = _vehiclePricing get "truck_utility_rank";
                                                } else {
                                                    _cost = _vehiclePricing get "truck_basic_cost";
                                                    _requiredRank = _vehiclePricing get "truck_basic_rank";
                                                };
                                            };
                                        } else {
                                            // Helicopter classification
                                            if (_classname isKindOf "Helicopter") then {
                                                if (_hasWeapons) then {
                                                    _cost = _vehiclePricing get "heli_armed_cost";
                                                    _requiredRank = _vehiclePricing get "heli_armed_rank";
                                                } else {
                                                    _cost = _vehiclePricing get "heli_unarmed_cost";
                                                    _requiredRank = _vehiclePricing get "heli_unarmed_rank";
                                                };
                                            } else {
                                                // Plane classification
                                                if (_classname isKindOf "Plane") then {
                                                    if (_hasWeapons) then {
                                                        _cost = _vehiclePricing get "plane_armed_cost";
                                                        _requiredRank = _vehiclePricing get "plane_armed_rank";
                                                    } else {
                                                        _cost = _vehiclePricing get "plane_unarmed_cost";
                                                        _requiredRank = _vehiclePricing get "plane_unarmed_rank";
                                                    };
                                                } else {
                                                    // Ship classification
                                                    if (_classname isKindOf "Ship") then {
                                                        if (_classname isKindOf "Submarine") then {
                                                            _cost = _vehiclePricing get "submarine_cost";
                                                            _requiredRank = _vehiclePricing get "submarine_rank";
                                                        } else {
                                                            if (_hasWeapons) then {
                                                                _cost = _vehiclePricing get "ship_armed_cost";
                                                                _requiredRank = _vehiclePricing get "ship_armed_rank";
                                                            } else {
                                                                _cost = _vehiclePricing get "ship_unarmed_cost";
                                                                _requiredRank = _vehiclePricing get "ship_unarmed_rank";
                                                            };
                                                        };
                                                    } else {
                                                        // Default classification - LOWEST PRIORITY
                                                        if (_hasWeapons) then {
                                                            _cost = _vehiclePricing get "default_armed_cost";
                                                            _requiredRank = _vehiclePricing get "default_armed_rank";
                                                        } else {
                                                            _cost = _vehiclePricing get "default_unarmed_cost";
                                                            _requiredRank = _vehiclePricing get "default_unarmed_rank";
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                            
                            private _actionId = _target addAction [
                                format ["    %1 <t color='#00FF00'>(Cost %2 Field Credits)</t>", _label, _cost],
                                {
                                    params ["_target", "_caller", "_actionId", "_params"];
                                    private _vehicleClass = _params select 0;
                                    private _fobFlag_param = _params select 1;
                                    private _vehicleCost = _params select 2;
                                    private _minRank = _params select 3;
                                    private _currentRank = _caller getVariable ["Rank", "Private"];
                                    private _rankHierarchy = ["Recruit", "Private", "Corporal", "Sergeant", "Staff Sergeant", "Lieutenant", "Captain", "Major", "Colonel", "Warlord", "FOB Commander"];
                                    private _playerRankIndex = _rankHierarchy find _currentRank;
                                    private _requiredRankIndex = _rankHierarchy find _minRank;
                                    if (_playerRankIndex < _requiredRankIndex) exitWith {
                                        _caller sideChat format ["Rank too low. Need %1.", _minRank];
                                    };
                                    private _currentCredits = _caller getVariable ["FieldCredits", 0];
                                    if (_currentCredits < _vehicleCost) exitWith {
                                        _caller sideChat format ["Insufficient Field Credits. Need %1 FC.", _vehicleCost];
                                    };
                                    if (!(missionNamespace call (missionNamespace getVariable ["fob_canSpawnVehicle", {true}]))) exitWith {
                                        _caller sideChat "Vehicle limit reached. Try again later.";
                                    };
                                    [(_vehicleCost * -1)] execVM "addCredits.sqf";
                                    private _spawnCenter = getPos _fobFlag_param;
                                    private _vehiclePos = [_spawnCenter, 10, 20, 5, 0, 0.3, 0, [], _spawnCenter] call BIS_fnc_findSafePos;
                                    if (_vehiclePos isEqualTo []) exitWith {
                                        _caller sideChat "No safe area for vehicle nearby.";
                                    };
                                    private _veh = createVehicle [_vehicleClass, _vehiclePos, [], 0, "NONE"];
                                    if (!isNull _veh) then {
                                        _caller sideChat format ["%1 spawned near FOB.", getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName")];
                                        playSound "Click";
                                    } else {
                                        _caller sideChat "Vehicle spawn failed.";
                                    };
                                },
                                [_classname, _fobFlag, _cost, _requiredRank],
                                1.4, true, true, "", "true", 5, false, "", ""
                            ];
                            _newSubmenuActions pushBack _actionId;
                        } forEach _vehicleTypes_local;
                        _target setVariable ["vehicleSubmenuActions", _newSubmenuActions];
                        [_target, "vehicleSubmenuActions", _submenuTimeout] spawn fnc_cleanupSubmenu;
                    };
                },
                nil, 98.95, true, true, "", "true", 5, false, "", ""
            ];

            // Store config variables on the vehicle sign for access in nested scopes
            _vehicleSign setVariable ["vehiclePricing", _vehiclePricing, true];
            _vehicleSign setVariable ["submenuTimeout", _submenuTimeout, true];
            _vehicleSign setVariable ["fob_parentFlag", _flag, true];
            _vehicleSign setVariable ["fnc_hasWeapons", _fnc_hasWeapons, true];

            //========================================//
            //            Rest Function               //
            //========================================//
			_flag addAction ["<t color='#FFDD00' size='1.2'>Rest</t>", {
            params ["_target", "_caller", "_actionId"];
            skipTime 4;
            _caller sideChat "Rested for 4 Hours.";
            playSound "Click";
			}, nil, 97, true, true, "", "true", 5, false, "", ""];
		
			_flag addAction ["<t color='#FFDD00' size='1.2'>----- FLAG MENU -----</t>", {
				params ["_target", "_caller", "_actionId"];
			}, nil, 97.2, true, true, "", "true", 5, false, "", ""];
		
			_vehicleSign addAction ["<t color='#FFDD00' size='1.2'>----- MAP MENU -----</t>", {
            params ["_target", "_caller", "_actionId"];
			}, nil, 98.96, true, true, "", "true", 5, false, "", ""];
            
            //========================================//
            //      Request Air Support Radio Function//
            //========================================//
            _flag addAction ["<t color='#FFA500' size='1.2'>Request Air Support Radio</t> <t color='#00FF00'>(Cost 1 Field Credits)</t>", {
                params ["_target", "_caller", "_actionId"];

                private _currentCredits = _caller getVariable ["FieldCredits", 0];
                if (_currentCredits < 1) exitWith {
                    _caller sideChat "Insufficient Field Credits. Need 1 FC.";
                };

                if (!(missionNamespace call (missionNamespace getVariable ["fob_canSpawnAirSupportRadio", {true}]))) exitWith {
                    private _lastTime = missionNamespace getVariable ["lastAirSupportRadioSpawnTime", 0];
                    private _remaining = 600 - (time - _lastTime);
                    _caller sideChat format ["Air Support Radio cooldown: %1 seconds remaining.", ceil _remaining];
                };

                private _radioClass = "B_RadioBag_01_mtp_F";
                private _radioLabel = "Radio Bag";

                // Deduct credits
                _caller setVariable ["FieldCredits", _currentCredits - 1, true];

                private _flagPos = getPosATL _target;
                private _spawnOffset = [2, 0, 0.1];
                private _spawnPos = _flagPos vectorAdd _spawnOffset;

                private _radioBag = createVehicle [_radioClass, _spawnPos, [], 0, "NONE"];

                _radioBag setPosATL _spawnPos;
                _radioBag setDir (getDir _target + 90);

                waitUntil { !isNull _radioBag && alive _radioBag };

                if (!local _radioBag) then {
                    _radioBag setOwner (owner _caller);
                    waitUntil { local _radioBag };
                };

                sleep 0.1;
                waitUntil { simulationEnabled _radioBag };
                sleep 0.2;

                if (!isNull _radioBag && alive _radioBag && local _radioBag) then {
                    [_radioBag, _caller] spawn {
                        params ["_radio", "_player"];

                        sleep 0.5;
						[_radio, [
                        "<t color='#FFDD00' size='1.2'>----- AIR SUPPORT MENU -----</t>",
                        {},
                        nil,
                        110.2,
                        true,
                        true,
                        "",
                        "true",
                        5
                    ]] remoteExec ["addAction", 0, true];
                        
                        [_radio, [
                            "<t color='#FFA500' size='1.2'>Request Heli Transport</t> <t color='#00FF00'></t>",
                            { execVM "supports\heliTransport.sqf"; },
                            nil,
                            110.1,
                            true,
                            true,
                            "",
                            "true",
                            5
                        ]] remoteExec ["addAction", 0, true];

                        [_radio, [
                            "<t color='#FFA500' size='1.2'>Request Supply Drop</t> <t color='#00FF00'>(2 Field credits)</t>",
                            { execVM "supports\supplyDrop.sqf"; },
                            nil,
                            110,
                            true,
                            true,
                            "",
                            "true",
                            5
                        ]] remoteExec ["addAction", 0, true];

                        [_radio, [
                            "<t color='#FFA500' size='1.2'>Request Vehicle Drop</t> <t color='#00FF00'>(2 Field credits)</t>",
                            { execVM "supports\vehicleDrop.sqf"; },
                            nil,
                            109,
                            true,
                            true,
                            "",
                            "true",
                            5
                        ]] remoteExec ["addAction", 0, true];

                        [_radio, [
                            "<t color='#FFA500' size='1.2'>Request CAS Attack Heli</t> <t color='#00FF00'>(5 Field credits)</t>",
                            { execVM "supports\heliGunship.sqf"; },
                            nil,
                            107,
                            true,
                            true,
                            "",
                            "true",
                            5
                        ]] remoteExec ["addAction", 0, true];

                        [_radio, [
                            "<t color='#FFA500' size='1.2'>Request CAS Guided Missile</t> <t color='#00FF00'>(8 Field credits)</t>",
                            { execVM "supports\planeGunship.sqf"; },
                            nil,
                            106,
                            true,
                            true,
                            "",
                            "true",
                            5
                        ]] remoteExec ["addAction", 0, true];

                        sleep 1;
                        private _actionCount = count (actionIDs _radio);

                        if (_actionCount == 0) then {
                            sleep 0.5;
                        };
                    };

                    _radioBag setVariable ["isAirSupportRadio", true, true];
                    _radioBag setVariable ["ownerUID", getPlayerUID _caller, true];

                    _caller sideChat format ["%1 deployed with Air Support capabilities.", _radioLabel];
                    playSound "Click";

                } else {
                    _caller sideChat "Failed to deploy Air Support Radio. (Object creation failed)";
                    _caller setVariable ["FieldCredits", _currentCredits, true];
                };
                _target setVariable ["radioSubmenuActions", []];
            }, nil, 96.5, true, true, "", "true", 5, false, "", ""];
            
            //========================================//
            //          Recruit AI Function           //
            //========================================//
            _flag addAction ["<t color='#FFA500' size='1.2'>Recruit AI Squadmate</t> <t color='#00FF00'>(Cost 1 Field Credits)</t>", {
                params ["_target", "_caller", "_actionId"];
                private _recruitAISubmenuActions = _target getVariable ["recruitAISubmenuActions", []];
                if (count _recruitAISubmenuActions > 0) then {
                    { _target removeAction _x } forEach _recruitAISubmenuActions;
                    _target setVariable ["recruitAISubmenuActions", []];
                } else {
                    private _unitTypes = missionNamespace getVariable ["_unitTypes", []];
                    if (_unitTypes isEqualTo []) then {
                        private _tempConfig = call compile preprocessFileLineNumbers "factions\playerFaction.sqf";
                        _unitTypes = _tempConfig get "unitTypes";
                    };
                    private _newSubmenuActions = [];
                    
                    // Add NATO Fire Team option
                    private _fireTeamActionId = _target addAction ["    <t color='#FFD700'>NATO Fire Team (4 units)</t> <t color='#00FF00'>(Cost 3 FC)</t>", {
                        params ["_target", "_caller", "_actionId"];
                        private _currentCredits = _caller getVariable ["FieldCredits", 0];
                        if (_currentCredits < 3) exitWith {
                            _caller sideChat "Insufficient Field Credits. Need 3 FC.";
                        };
                        
                        [-3] execVM "addCredits.sqf";
                        
                        private _fireTeamConfig = createHashMapFromArray [
                            ["side", west],
                            ["units", [
                                ["B_Soldier_TL_F", "Team Leader"],
                                ["B_Soldier_F", "Rifleman"],
                                ["B_Soldier_AR_F", "Autorifleman"], 
                                ["B_Soldier_GL_F", "Grenadier"]
                            ]],
                            ["spawnPos", _caller modelToWorld [10, 0, 0]]
                        ];
                        
                        [_fireTeamConfig, _caller] spawn {
                            params ["_config", "_caller"];
                            private _side = _config get "side";
                            private _units = _config get "units";
                            private _spawnPos = _config get "spawnPos";
                            
                            private _group = createGroup _side;
                            private _createdUnits = [];
                            
                            private _skillConfig = createHashMapFromArray [
                                ["general", 1.0],
                                ["courage", 1.0], 
                                ["aimingAccuracy", 0.8],
                                ["aimingShake", 0.8],
                                ["aimingSpeed", 1.0],
                                ["commanding", 1.0],
                                ["endurance", 1.0],
                                ["spotDistance", 1.0],
                                ["spotTime", 1.0],
                                ["reloadSpeed", 0.8]
                            ];
                            
                            {
                                private _className = _x select 0;
                                private _role = _x select 1;
                                private _unit = _group createUnit [_className, _spawnPos, [], 3, "NONE"];
                                
                                {
                                    _unit setSkill [_x, _skillConfig get _x];
                                } forEach ["general", "courage", "aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "endurance", "spotDistance", "spotTime", "reloadSpeed"];
                                
                                _unit allowFleeing 0;
                                _unit addEventHandler ["HandleDamage", {
                                    params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
                                    _damage * 0.25
                                }];
                                _createdUnits pushBack _unit;
                            } forEach _units;
                            
                            _caller hcSetGroup [_group];
                            _caller sideChat "NATO Fire Team deployed and ready for High Command.";
                        };
                        
                        playSound "Click";
                    }, nil, 1.6, true, true, "", "true", 5, false, "", ""];
                    _newSubmenuActions pushBack _fireTeamActionId;
                    
                    // Add individual unit options
                    {
                        private _label = _x select 0;
                        private _class = _x select 1;
                        private _actionId = _target addAction [format ["    %1", _label], {
                            params ["_target", "_caller", "_actionId", "_params"];
                            private _className = _params select 0;
                            private _currentCredits = _caller getVariable ["FieldCredits", 0];
                            if (_currentCredits < 1) exitWith {
                                _caller sideChat "Insufficient Field Credits. Need 1 FC.";
                            };
                            private _group = group _caller;
                            if (count (units _group) >= 16) exitWith {
                                _caller sideChat "Your squad is full (max 16 units).";
                            };
                            [-1] execVM "addCredits.sqf";
                            private _pos = _caller modelToWorld [2, 2, 0];
                            private _unit = _group createUnit [_className, _pos, [], 0, "NONE"];
                            [_unit] join _group;
                            
                            // Elite AI skill configuration
                            private _skillConfig = createHashMapFromArray [
                                ["general", 1.0],
                                ["courage", 1.0], 
                                ["aimingAccuracy", 0.8],
                                ["aimingShake", 0.8],
                                ["aimingSpeed", 1.0],
                                ["commanding", 1.0],
                                ["endurance", 1.0],
                                ["spotDistance", 1.0],
                                ["spotTime", 1.0],
                                ["reloadSpeed", 0.8]
                            ];
                            
                            [_unit, _skillConfig] spawn {
                                params ["_unit", "_config"];
                                {
                                    _unit setSkill [_x, _config get _x];
                                } forEach ["general", "courage", "aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "endurance", "spotDistance", "spotTime", "reloadSpeed"];
                                
                                _unit addEventHandler ["HandleDamage", {
                                    params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
                                    _damage * 0.25
                                }];
                            };
                            
                            _unit allowFleeing 0;
                            _unit disableAI "AUTOCOMBAT";
                            _caller sideChat format ["%1 reporting for duty.", name _unit];        
                            playSound "Click";                            
                            
                        }, [_class], 1.5, true, true, "", "true", 5, false, "", ""];
                        _newSubmenuActions pushBack _actionId;
                    } forEach _unitTypes;
                    _target setVariable ["recruitAISubmenuActions", _newSubmenuActions];
                    [_target, "recruitAISubmenuActions", 5] spawn fnc_cleanupSubmenu;
                };
            }, nil, 96, true, true, "", "true", 5, false, "", ""];

            //========================================//
            //          Resupply AI Function          //
            //========================================//
            _flag addAction ["<t color='#FFA500' size='1.2'>Resupply Squad</t> <t color='#00FF00'>(Cost 1 Field Credits)</t>", {
                params ["_target", "_caller", "_actionId"];
                private _currentCredits = _caller getVariable ["FieldCredits", 0];
                if (_currentCredits < 1) exitWith {
                    _caller sideChat "Insufficient Field Credits. Need 1 FC.";
                };
                private _units = units group player select { _x != player && alive _x };
                if (count _units == 0) exitWith { player sideChat "No Squad Members to Resupply."; };
                [-1] execVM "addCredits.sqf";
                {
                    // Resupply
                    private _primary = primaryWeapon _x;
                    if (!isNil {_primary} && {_primary != ""} && {isClass(configFile >> "CfgWeapons" >> _primary)}) then {
                        private _magsArray = getArray(configFile >> "CfgWeapons" >> _primary >> "magazines");
                        if (count _magsArray > 0) then {
                            private _magType = _magsArray select 0;
                            _x addMagazines [_magType, 7];
                        };
                    };
                    private _launcher = secondaryWeapon _x;
                    if (!isNil {_launcher} && {_launcher != ""} && {isClass(configFile >> "CfgWeapons" >> _launcher)}) then {
                        private _missileArray = getArray(configFile >> "CfgWeapons" >> _launcher >> "magazines");
                        if (count _missileArray > 0) then {
                            private _missileType = _missileArray select 0;
                            _x addMagazine _missileType;
                        };
                    };
                    _x addMagazine "HandGrenade";
                    _x addMagazine "SmokeShell";
                    _x addItem "FirstAidKit";
                    _x addItem "FirstAidKit";

                    // Heal
                    _x setDamage 0; 

                } forEach _units;
                player sideChat "Squad Resupplied and Healed.";
                playSound "Click";
            }, nil, 95, true, true, "", "true", 5, false, "", ""];
            
            //========================================//
            //       Request Combat Drone Function    //
            //========================================//
            _flag addAction ["<t color='#FFA500' size='1.2'>Deploy Combat Drone</t> <t color='#00FF00'>(Cost 2 Field Credits)</t>", {
                params ["_target", "_caller", "_actionId"];
                private _requiredRank = "Corporal";
                private _currentRank = _caller getVariable ["Rank", "Private"];
                private _rankHierarchy = ["Recruit", "Private", "Corporal", "Sergeant", "Staff Sergeant", "Lieutenant", "Captain", "Major", "Colonel", "Warlord", "FOB Commander"];
                private _playerRankIndex = _rankHierarchy find _currentRank;
                private _requiredRankIndex = _rankHierarchy find _requiredRank;

                if (_playerRankIndex < _requiredRankIndex) exitWith {
                    _caller sideChat format ["Rank too low. Need %1.", _requiredRank];
                };

                private _currentCredits = _caller getVariable ["FieldCredits", 0];
                if (_currentCredits < 2) exitWith {
                    _caller sideChat "Insufficient Field Credits. Need 2 FC.";
                };
                if (!(missionNamespace call (missionNamespace getVariable ["fob_canSpawnDrone", {true}]))) exitWith {
                    private _lastTime = missionNamespace getVariable ["lastDroneSpawnTime", 0];
                    private _remaining = 600 - (time - _lastTime);
                    _caller sideChat format ["Combat Drone cooldown: %1 seconds remaining.", ceil _remaining];
                };
                [-2] execVM "addCredits.sqf";
                private _flagPos = getPosASL _target;
                private _spawnOffset = [2, 0, 0];
                private _spawnPos = _flagPos vectorAdd _spawnOffset;
                private _uavBag = createVehicle ["B_UAV_01_backpack_F", _spawnPos, [], 0, "NONE"];
                if (!isNull _uavBag) then {
                    _caller sideChat "Combat Drone Deployed";
                    playSound "Click";
                } else {
                    _caller sideChat "Failed to Deploy Combat Drone.";
                };
            }, nil, 94, true, true, "", "true", 5, false, "", ""];

            //========================================//
            //          Request Mortar Function       //
            //========================================//
            _flag addAction ["<t color='#FFA500' size='1.2'>Deploy Mortar</t> <t color='#00FF00'>(Cost 4 Field Credits)</t>", {
                params ["_target", "_caller", "_actionId"];
                private _requiredRank = "Staff Sergeant";
                private _currentRank = _caller getVariable ["Rank", "Private"];
                private _rankHierarchy = ["Recruit", "Private", "Corporal", "Sergeant", "Staff Sergeant", "Lieutenant", "Captain", "Major", "Colonel", "Warlord", "FOB Commander"];
                private _playerRankIndex = _rankHierarchy find _currentRank;
                private _requiredRankIndex = _rankHierarchy find _requiredRank;

                if (_playerRankIndex < _requiredRankIndex) exitWith {
                    _caller sideChat format ["Rank too low. Need %1.", _requiredRank];
                };

                private _currentCredits = _caller getVariable ["FieldCredits", 0];
                if (_currentCredits < 4) exitWith {
                    _caller sideChat "Insufficient Field Credits. Need 4 FC.";
                };
                if (!(missionNamespace call (missionNamespace getVariable ["fob_canSpawnMortar", {true}]))) exitWith {
                    private _lastTime = missionNamespace getVariable ["lastMortarSpawnTime", 0];
                    private _remaining = 600 - (time - _lastTime);
                    _caller sideChat format ["Mortar cooldown: %1 seconds remaining.", ceil _remaining];
                };
                [-4] execVM "addCredits.sqf";
                private _flagPos = getPosASL _target;
                private _spawnOffset = [3, 0, 0];
                private _spawnPos = _flagPos vectorAdd _spawnOffset;
                private _mortarBag = createVehicle ["B_Mortar_01_weapon_F", _spawnPos, [], 0, "NONE"];
                private _bipodBag = createVehicle ["B_Mortar_01_support_F", _spawnPos vectorAdd [0.5, 0, 0], [], 0, "NONE"];
                if (!isNull _mortarBag && !isNull _bipodBag) then {
                    _caller sideChat "Mortar and Bipod Deployed.";
                    playSound "Click";
                } else {
                    _caller sideChat "Failed to Deploy Mortar.";
                };
            }, nil, 93, true, true, "", "true", 5, false, "", ""];
        };
		
        player sideChat "F.O.B. successfully deployed. Interact with the flagpole and map for more details.";
        playMusic "LeadTrack01b_F_Bootcamp";
        nul = [] execVM "sitrepScreen.sqf";
        
        _spawned = true;
    };
    if (!_spawned) then {
        player sideChat "No Suitable Position to Deploy the F.O.B.";
    };
}, _flagType, 100, true, true, "", "true", 5, false, "", ""];

//========================================//
//        Squad Management Function       //
//========================================//
player addAction ["<t color='#8A2BE2' size='1.2'>Squad Management</t>", {
    params ["_target", "_caller", "_actionId"];

    private _squadSubmenuActions = _target getVariable ["squadSubmenuActions", []];

    if (count _squadSubmenuActions > 0) then {
        { _target removeAction _x } forEach _squadSubmenuActions;
        _target setVariable ["squadSubmenuActions", []];
    } else {
        private _newSubmenuActions = [];
        private _nearbyRecruitableAI = [];

        {
            if (_x != _caller && alive _x && !(_x isKindOf "VirtualMan_F") && !(isPlayer _x) && (group _x != group _caller)) then {
                _nearbyRecruitableAI pushBack _x;
            };
        } forEach (nearestObjects [_caller, ["CAManBase"], 3]); 

        if (count _nearbyRecruitableAI > 0) then {
            {
                private _unit = _x;
                private _actionId = _target addAction [format ["    Recruit %1 <t color='#00FF00'>(Cost 1 Field Credits)</t>", name _unit], {
                    params ["_target", "_caller", "_actionId", "_params"];
                    private _unitToRecruit = _params select 0;
                    private _currentCredits = _caller getVariable ["FieldCredits", 0];
                    if (_currentCredits < 1) exitWith {
                        _caller sideChat "Insufficient Field Credits. Need 1 FC.";
                    };
                    private _group = group _caller;
                    if (count (units _group) >= 8) exitWith {
                        _caller sideChat "Your squad is full (max 8 units).";
                    };
                    [-1] execVM "addCredits.sqf";
                    
                    private _pos = _caller modelToWorld [2, 2, 0];
                    private _unit = _group createUnit [typeOf _unitToRecruit, _pos, [], 0, "NONE"];
                    [_unit] join _group;
                    
                    // Elite AI skill configuration
                    private _skillConfig = createHashMapFromArray [
                        ["general", 1.0],
                        ["courage", 1.0], 
                        ["aimingAccuracy", 0.8],
                        ["aimingShake", 0.8],
                        ["aimingSpeed", 1.0],
                        ["commanding", 1.0],
                        ["endurance", 1.0],
                        ["spotDistance", 1.0],
                        ["spotTime", 1.0],
                        ["reloadSpeed", 0.8]
                    ];
                    
                    [_unit, _skillConfig] spawn {
                        params ["_unit", "_config"];
                        {
                            _unit setSkill [_x, _config get _x];
                        } forEach ["general", "courage", "aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "endurance", "spotDistance", "spotTime", "reloadSpeed"];
                    };
                    
                    _unit allowFleeing 0;
                    _unit disableAI "AUTOCOMBAT";
                    _caller sideChat format ["%1 reporting for duty.", name _unit];        
                    playSound "Click";
                            
                }, [_unit], 1.5, true, true, "", "true", 5, false, "", ""];
                _newSubmenuActions pushBack _actionId;
            } forEach _nearbyRecruitableAI;
        } else {
            private _noRecruitActionId = _target addAction ["    No recruitable AI nearby.", {}, nil, 1.5, false, false, "", "true", 0, false, "", ""];
            _newSubmenuActions pushBack _noRecruitActionId;
        };

        private _squadAI = units (group _caller) select { _x != _caller && alive _x };
        if (count _squadAI > 0) then {
            {
                private _unitToDismiss = _x;
                private _actionId = _target addAction [format ["    Dismiss %1", name _unitToDismiss], {
                    params ["_target", "_caller", "_actionId", "_params"];
                    private _unit = _params select 0;
                    if (alive _unit) then {
                        deleteVehicle _unit;
                        _caller sideChat format ["%1 has been dismissed.", name _unit];
                        playSound "Click";
                    } else {
                        _caller sideChat format ["%1 is no longer alive.", name _unit];
                    };
                }, [_unitToDismiss], 1.5, true, true, "", "true", 5, false, "", ""];
                _newSubmenuActions pushBack _actionId;
            } forEach _squadAI;
        } else {
            private _noDismissActionId = _target addAction ["    No AI in squad to dismiss.", {}, nil, 1.5, false, false, "", "true", 0, false, "", ""];
            _newSubmenuActions pushBack _noDismissActionId;
        };

        _target setVariable ["squadSubmenuActions", _newSubmenuActions];
        [_target, "squadSubmenuActions", 3] spawn fnc_cleanupSubmenu;
    };
}, nil, 99, true, true, "", "true", 5, false, "", ""];
