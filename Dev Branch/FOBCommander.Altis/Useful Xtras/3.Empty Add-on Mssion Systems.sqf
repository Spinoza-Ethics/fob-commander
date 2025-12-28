//=== Start Object Destruction Check System ===//

//Must be placed at end of scripts after... _spawned = true;
//Make sure object is Destroyable

if (_spawned) then {
    // objects to watch
    _watchClasses = [
        "Land_Communication_F",
        "Land_TTowerSmall_2_F", 
        "Land_TTowerBig_2_F",
        "Land_TTowerBig_1_F"
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
                    player sideChat "Objective Complete: Tower Disabled";
					nul = [] execVM "missionCompleteScreen.sqf";
                    break;
                };
                
                sleep 5; 
            };
        };
    };
};

//=== END Object Destruction Check System ===//
		
		
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		
		
		// === Start Smoke Spawn System ==== //
		{
			private _obj = _x;
			private _classname = typeOf _obj;
			
			//objects to attach smoke to
			if (_classname in [
				"Land_Wreck_Heli_02_Wreck_01_F",
				"Land_Wreck_Heli_02_Wreck_02_F",	
				"Land_Wreck_Heli_02_Wreck_03_F",
				"Land_Wreck_Heli_02_Wreck_04_F",
				"Land_Wreck_Heli_Attack_01_F",
				"Land_Wreck_Heli_Attack_02_F",
				"Land_Mi8_wreck_F",
				"Land_Wreck_Plane_Transport_01_F"
			]) then {
				
				_obj setVariable ["smokeSource", objNull, true];
				_obj setVariable ["smokingActive", false, true];
				
				private _smokePos = getPosATL _obj;
				_smokePos set [2, (_smokePos select 2) + 2];
				
				private _smoke = createVehicle ["test_EmptyObjectForSmoke", _smokePos, [], 0, "CAN_COLLIDE"];
				_smoke enableSimulation false;
				_obj setVariable ["smokeSource", _smoke, true];
				
				[_obj, _smoke] spawn {
					params ["_wreck", "_smokeObj"];
					
					while {!isNull _wreck && !isNull _smokeObj} do {
						private _playerNear = false;
						
						{
							if (alive _x && isPlayer _x && (_wreck distance _x) <= 1000) then {
								_playerNear = true;
							};
						} forEach allUnits;
						
						private _currentlyActive = _wreck getVariable ["smokingActive", false];
						
						if (_playerNear && !_currentlyActive) then {
							_smokeObj enableSimulation true;
							_wreck setVariable ["smokingActive", true, true];
						} else {
							if (!_playerNear && _currentlyActive) then {
								_smokeObj enableSimulation false;
								_wreck setVariable ["smokingActive", false, true];
							};
						};
						
						sleep 10;
					};
					
					if (!isNull _smokeObj) then {
						deleteVehicle _smokeObj;
					};
				};
			};
		} forEach _spawnedObjects;
		
		// === End Smoke Spawn System ==== //
		
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		

		// === Start Survivor Spawn System === //
		private _civilianTypes = ["B_Soldier_unarmed_F", "C_man_pilot_F" ];
		private _numCivilians = 1 + floor random 4;


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

					_civilian setVariable ["isPotentialSurvivor", true, true];

					private _checkCivilian = _civilian; // Reference to the civilian for the spawned script
					private _proximityCheckScript = _checkCivilian spawn {
						
						params ["_civ"];

						
						while {true} do {
							
							if (isNull _civ || !(_civ getVariable ["isPotentialSurvivor", false])) exitWith {};

							private _playerNear = false;
							
							{
								if (alive _x && (_civ distance _x) <= 2) then {
									_playerNear = true;
								};
							} forEach allPlayers;

							if (_playerNear) then {
								_civ setCaptive false; 
								_civ enableAI "MOVE";

								
								_civ setVariable ["isPotentialSurvivor", false, true]; 

								
								{ _x sideChat "Survivor Found!"; } forEach allPlayers;

								
								private _survivorsLeft = 0;
								{
									
									if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialSurvivor", false])) then {
										_survivorsLeft = _survivorsLeft + 1;
									};
								} forEach allUnits;

								
								{ _x sideChat format ["Survivors left: %1", _survivorsLeft]; } forEach allPlayers;
								
								if (_survivorsLeft == 0) then {
											player sideChat "Objective Cmplete: All Survivors Found";
											nul = [] execVM "missionCompleteScreen.sqf";
										};

								break; 
							};
							sleep 2;
						};
					};
				};
			};

			private _totalInitialSurvivors = 0;
			{
				
				if (alive _x && (side _x == civilian) && (_x getVariable ["isPotentialSurvivor", false])) then {
					_totalInitialSurvivors = _totalInitialSurvivors + 1;
				};
			} forEach allUnits;
			{ _x sideChat format ["Total potential survivors in mission: %1", _totalInitialSurvivors]; } forEach allPlayers;
		};
		// === End Survivor Spawn System ==== //
		
		
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		
		

		// === Start Object Spawn System === //
		private _objectData = createHashMap;
			
		//script ref(needed), obj file name, add action(leave empty to remove), spawn range min,max
		_objectData set ["blackbox", ["Land_Suitcase_F", "black box", [5, 10]]];
		private _basePosition = _campPos;

		// Min and max number of objects to spawn
		private _minObjectsToSpawn = 1;
		private _maxObjectsToSpawn = 1;
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
		// === End Object Spawn System === //
		
		
		
		
		// === Start Crewed Vehicle Spawn System === //
		private _objectData = createHashMap;

		//script ref(needed), obj file name, add action(leave empty to remove), spawn range min,max
		_objectData set ["aa1", ["B_SAM_System_03_F", "", [5, 30]]];
		_objectData set ["aa2", ["B_Radar_System_01_F", "", [5, 30]]];
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
						
						// --- Start Crew Spawning for Objects ---
						if (_obj isKindOf "LandVehicle" || _obj isKindOf "Air" || _obj isKindOf "Ship") then {
							private _objGroup = createGroup [resistance, true]; // Create a new group for the object's crew

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
		
		
		
												//==========RANK SYSTEM==========//

										// Add XP and Credits
										[500] execVM "addXP.sqf";
										[500] execVM "addCredits.sqf";

										// Get current player stats
										private _xp = player getVariable ["XP", 0];
										private _credits = player getVariable ["FieldCredits", 0];
										private _rank = player getVariable ["Rank", "Private"];
										private _rankThresholds = missionNamespace getVariable ["RankThresholds", []];

										// Calculate next rank progression
										private _nextRankXP = 10000; // Max rank XP as default
										private _nextRankName = "FOB Commander";

										// Find next rank threshold
										{
											_x params ["_rank", "_threshold"];
											if (_xp < _threshold) exitWith {
												_nextRankXP = _threshold;
												_nextRankName = _rank;
											};
										} forEach _rankThresholds;

										// Display SITREP header
										player sideChat "=== SITREP ===";
										player sideChat format ["Rank: %1", _rank];
										// Display XP with progression info
										if (_nextRankName == "MAX RANK") then {
											player sideChat format ["XP: %1 - MAX RANK ACHIEVED!", _xp];
										} else {
											player sideChat format ["XP: %1/%2 to %3", _xp, _nextRankXP, _nextRankName];
										};
										player sideChat format ["Field Credits: %1", _credits];
		




