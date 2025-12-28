// Check if player has enough Field Credits
private _currentCredits = player getVariable ["FieldCredits", 0];
if (_currentCredits < 2) exitWith {
    player sideChat "Insufficient Field Credits. Need 2 FC.";
};

// Check cooldown
private _lastSupplyDropTime = missionNamespace getVariable ["lastSupplyDropTime", -9999];
private _now = time;
if (_now - _lastSupplyDropTime < 600) exitWith {
    private _remaining = 600 - (_now - _lastSupplyDropTime);
    player sideChat format ["Supply Drop cooldown: %1 seconds remaining.", ceil _remaining];
};

// Deduct credits and set cooldown
[-2] execVM "addCredits.sqf";
missionNamespace setVariable ["lastSupplyDropTime", _now, true];

hint "Select a drop zone on the map.";
openMap [true, false];

private _ehID = addMissionEventHandler ["MapSingleClick", {
    params ["_map", "_pos", "_alt"];
    
    openMap [false, false];
    removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
    
    private _dropPosition = [_pos select 0, _pos select 1, 0];
    private _helicopterType = "B_Heli_Transport_01_F"; // Type of helicopter
    private _supplyBoxType = "B_CargoNet_01_ammo_F"; // Type of supply box
    private _flyHeight = 150; // Altitude for helicopter flight
    private _dropHeight = 100; // Altitude at which the supply box is dropped
    private _spawnDistance = 2000; // Distance to spawn helicopter from drop zone
    private _exitDistance = 2000; // Distance helicopter flies away after drop
    
    private _angle = random 360;
    private _spawnOffset = [
        _spawnDistance * cos (_angle),
        _spawnDistance * sin (_angle),
        _flyHeight
    ];
    private _exitOffset = [
        _exitDistance * cos (_angle + 180),
        _exitDistance * sin (_angle + 180),
        _flyHeight
    ];
    
    private _spawnPos = _dropPosition vectorAdd _spawnOffset;
    private _exitPos = _dropPosition vectorAdd _exitOffset;

    ["High Command", "Supply drop request received! ETA 60 seconds."] remoteExec ["BIS_fnc_showSubtitle", 0, true];
	playsound "supportConfirmed";
	hint "";
    
    private _supplyCrate = createVehicle [_supplyBoxType, [0, 0, 0], [], 0, "CAN_COLLIDE"];
    private _helicopter = createVehicle [_helicopterType, _spawnPos, [], 0, "FLY"];
    
    private _pilotGroup = createGroup west; // Creates a group for the pilot
    private _pilot = _pilotGroup createUnit ["B_Pilot_F", _spawnPos, [], 0, "CAN_COLLIDE"];
    
    _pilot moveInDriver _helicopter;
    _helicopter flyInHeight _flyHeight;
    _helicopter setBehaviour "CARELESS";
    _helicopter setCombatMode "BLUE";
    _helicopter setSpeedMode "FULL";
    
    private _wp1 = _pilotGroup addWaypoint [_dropPosition, 0];
    _wp1 setWaypointType "MOVE";
    _wp1 setWaypointSpeed "FULL";
    _wp1 setWaypointBehaviour "CARELESS";
    
    private _wp2 = _pilotGroup addWaypoint [_exitPos, 0];
    _wp2 setWaypointType "MOVE";
    _wp2 setWaypointSpeed "FULL";
    
    [_helicopter, _supplyCrate, _dropPosition, _exitPos, _dropHeight] spawn {
        params ["_heli", "_crate", "_drop", "_exit", "_dropHeight"];
        
        // Wait until helicopter is near the drop zone
        waitUntil {
            sleep 1;
            (_heli distance2D _drop) < 100
        };
        
        // Drop the supply crate
        private _heliPos = getPos _heli;
        _heliPos set [2, _dropHeight]; // Set the drop height
        _crate setPos _heliPos;
        
        private _chute = createVehicle ["B_Parachute_02_F", _heliPos, [], 0, "NONE"]; // Create parachute
        _crate attachTo [_chute, [0, 0, 0]]; // Attach crate to parachute
        
        ["High Command", "Supply drop deployed!"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		playsound "supportDeployed";
        
        // Wait until crate has landed
        waitUntil {
            sleep 1;
            (getPos _crate select 2) < 5
        };
        
        detach _crate; // Detach crate from parachute
        sleep 10;
        deleteVehicle _chute; // Delete parachute
        
        ["High Command", "Supply drop has landed!"] remoteExec ["BIS_fnc_showSubtitle", 0, true];
		playsound "supportLanded";
        
        // Mark the landing position with orange smoke 5m away in a random direction
        private _cratePos = getPos _crate;
        private _randomAngle = random 360;
        private _smokeOffset = [5 * cos _randomAngle, 5 * sin _randomAngle, 0];
        private _smokePos = _cratePos vectorAdd _smokeOffset;
        createVehicle ["SmokeShellOrange", _smokePos, [], 0, "CAN_COLLIDE"];
        
        // Cleanup helicopter after a delay or if it reaches exit point
        private _cleanupTime = time + 30; // Time in seconds before cleanup
        waitUntil {
            sleep 1;
            (!alive _heli) || {(time > _cleanupTime) || (_heli distance _exit < 100)}
        };
        
        if (alive _heli) then {
            {deleteVehicle _x} forEach crew _heli;
            deleteVehicle _heli;
        };
    };
}];