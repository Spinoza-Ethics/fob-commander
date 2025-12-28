// Check if player has enough Field Credits
private _currentCredits = player getVariable ["FieldCredits", 0];
if (_currentCredits < 8) exitWith {
    player sideChat "Insufficient Field Credits. Need 8 FC.";
};

// Check cooldown (20 minutes = 1200 seconds)
private _lastCASTime = missionNamespace getVariable ["lastCASTime", -9999];
private _now = time;
if (_now - _lastCASTime < 1200) exitWith {
    private _remaining = 1200 - (_now - _lastCASTime);
    player sideChat format ["CAS cooldown: %1 seconds remaining.", ceil _remaining];
};

// Deduct credits and set cooldown
[-8] execVM "addCredits.sqf";
missionNamespace setVariable ["lastCASTime", _now, true];

// Initialize CAS system variables
CAS_Active = false;
CAS_Aircraft = objNull;
CAS_Group = grpNull;
CAS_TargetQueue = [];
CAS_AttackInProgress = false;

CAS_fnc_SpawnAircraft = {
    params ["_spawnPos"];

    if (CAS_Active) exitWith {
        hint "CAS aircraft already active!";
    };

    private _aircraftType = "B_Plane_CAS_01_dynamicLoadout_F"; // A-164 Wipeout
    private _spawnHeight = 500;
    private _spawnDistance = 4500;

    private _spawnAngle = random 360;
    private _spawnOffset = [
        _spawnDistance * cos _spawnAngle,
        _spawnDistance * sin _spawnAngle,
        _spawnHeight
    ];
    private _aircraftSpawnPos = _spawnPos vectorAdd _spawnOffset;

    CAS_Aircraft = createVehicle [_aircraftType, _aircraftSpawnPos, [], 0, "FLY"];
    CAS_Aircraft removeWeaponTurret ["Cannon_30mm_Plane_CAS_02_F", [-1]];
    CAS_Aircraft removeWeaponTurret ["Missile_AGM_01_Plane_CAS_01_F", [-1]];
    CAS_Aircraft removeWeaponTurret ["Missile_AGM_02_Plane_CAS_01_F", [-1]];
    CAS_Aircraft addWeaponTurret ["Bomb_04_Plane_CAS_01_F", [-1]];
    for "_i" from 1 to 8 do {
        CAS_Aircraft addMagazineTurret ["4Rnd_Bomb_04_F", [-1]];
    };

    CAS_Group = createGroup west;
    private _pilot = CAS_Group createUnit ["B_Pilot_F", _aircraftSpawnPos, [], 0, "CAN_COLLIDE"];
    _pilot moveInDriver CAS_Aircraft;
    _pilot setSkill 1;

    CAS_Aircraft flyInHeight _spawnHeight;
    CAS_Aircraft setBehaviour "COMBAT";
    CAS_Aircraft setCombatMode "RED";
    CAS_Aircraft setSpeedMode "FULL";

    private _patrolPos = _spawnPos vectorAdd [0, 0, _spawnHeight];
    private _wp = CAS_Group addWaypoint [_patrolPos, 0];
    _wp setWaypointType "LOITER";
    _wp setWaypointLoiterRadius 500;
    _wp setWaypointSpeed "FULL";

    CAS_Active = true;

    ["HIGH COMMAND", "CAS inbound, ETA 45 Seconds - use laser designator"] remoteExec ["BIS_fnc_showSubtitle", 0];
	playSound "supportConfirmed";
    [] spawn CAS_fnc_TargetDetection;
    [_spawnPos] spawn CAS_fnc_CleanupTimer;
};

CAS_fnc_TargetDetection = {
    private _currentTarget = objNull;
    private _lockTime = 0;
    private _lockDuration = 1;
    private _targetLockedAnnounced = false;

    while {CAS_Active && !isNull CAS_Aircraft && alive CAS_Aircraft} do {
        sleep 0.05;

        private _newTarget = objNull;

        {
            if (alive _x && vehicle _x == _x) then {
                private _weapon = currentWeapon _x;
                if (_weapon in ["Laserdesignator", "Laserdesignator_02", "Laserdesignator_03"]) then {
                    private _laserTarget = laserTarget _x;
                    if (!isNull _laserTarget && alive _laserTarget) then {
                        _newTarget = _laserTarget;
                    };
                };
            };
        } forEach allPlayers;

        if (!isNull _newTarget) then {
            if (_newTarget == _currentTarget) then {
                _lockTime = _lockTime + 0.05;

                if (_lockTime >= _lockDuration && !CAS_AttackInProgress && !_targetLockedAnnounced) then {
                    player sideChat "Target locked!";
                    _targetLockedAnnounced = true;
                    [_currentTarget] spawn CAS_fnc_AttackTarget;
                    _currentTarget = objNull;
                    _lockTime = 0;
                    _targetLockedAnnounced = false;
                };
            } else {
                _currentTarget = _newTarget;
                _lockTime = 0;
                _targetLockedAnnounced = false;
            };
        } else {
            if (!isNull _currentTarget) then {
                _currentTarget = objNull;
                _lockTime = 0;
                _targetLockedAnnounced = false;
            };
        };
    };
};

CAS_fnc_AttackTarget = {
    params ["_target"];

    if (isNull _target || !alive _target || isNull CAS_Aircraft || !alive CAS_Aircraft) exitWith {};

    CAS_AttackInProgress = true;

    private _targetPos = getPosATL _target;
    private _targetName = getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName");
    if (_targetName == "") then {_targetName = "TARGET"};

    while {count (waypoints CAS_Group) > 0} do {
        deleteWaypoint [CAS_Group, 0];
    };

    private _attackVector = CAS_Aircraft getRelPos [500, 0];
    private _approachWP = CAS_Group addWaypoint [_attackVector, 0];
    _approachWP setWaypointType "MOVE";
    _approachWP setWaypointSpeed "FULL";
    _approachWP setWaypointBehaviour "COMBAT";

    private _attackWP = CAS_Group addWaypoint [_targetPos, 0];
    _attackWP setWaypointType "DESTROY";
    _attackWP setWaypointSpeed "FULL";
    _attackWP setWaypointBehaviour "COMBAT";
    _attackWP setWaypointCombatMode "RED";

    CAS_Aircraft doTarget _target;
    CAS_Group setCombatMode "RED";

    [_target, _targetName] spawn {
        params ["_target", "_targetName"];

        private _attackTimeout = time + 20;
        private _targetDestroyed = false;

        while {time < _attackTimeout && !_targetDestroyed && alive CAS_Aircraft} do {
            sleep 0.2;
            if (isNull _target || !alive _target || damage _target >= 0.9) then {
                _targetDestroyed = true;
                player sideChat "Keep laser on target";
            };

            if (alive _target && CAS_Aircraft distance _target < 2000) then {
                CAS_Aircraft doTarget _target;
                CAS_Aircraft doFire _target;
            };
        };

        if (!_targetDestroyed && alive _target) then {
            private _targetPos = getPosATL _target;
            "Bo_Mk82" createVehicle _targetPos;
            {
                if (alive _x) then { _x setDamage 1; };
            } forEach (_targetPos nearObjects ["All", 20]);

            player sideChat "Target destroyed - mark next target";
			playSound "supportDeployed";
        };

        sleep 2;
        [] spawn CAS_fnc_ReturnToPatrol;
    };
};

CAS_fnc_ReturnToPatrol = {
    if (isNull CAS_Aircraft || !alive CAS_Aircraft) exitWith {};

    CAS_AttackInProgress = false;

    while {count (waypoints CAS_Group) > 0} do {
        deleteWaypoint [CAS_Group, 0];
    };

    private _patrolPos = getPosATL CAS_Aircraft vectorAdd [0, 0, 100];
    private _wp = CAS_Group addWaypoint [_patrolPos, 0];
    _wp setWaypointType "LOITER";
    _wp setWaypointLoiterRadius 500;
    _wp setWaypointSpeed "FULL";
    _wp setWaypointBehaviour "COMBAT";

    CAS_Aircraft setBehaviour "COMBAT";
    CAS_Aircraft setCombatMode "RED";
};

CAS_fnc_CleanupTimer = {
    params ["_centerPos"];

    sleep 80;

    if (CAS_Active && !isNull CAS_Aircraft) then {
        ["HIGH COMMAND", "CAS returning to base for rearm and refuel."] remoteExec ["BIS_fnc_showSubtitle", 0];
		playSound "supportLanded";

        while {count (waypoints CAS_Group) > 0} do {
            deleteWaypoint [CAS_Group, 0];
        };

        private _exitPos = _centerPos vectorAdd [7000, 7000, 800];
        private _exitWP = CAS_Group addWaypoint [_exitPos, 0];
        _exitWP setWaypointType "MOVE";
        _exitWP setWaypointSpeed "FULL";
        _exitWP setWaypointBehaviour "SAFE";

        [] spawn {
            sleep 25;
            if (!isNull CAS_Aircraft) then {
                {deleteVehicle _x} forEach crew CAS_Aircraft;
                deleteVehicle CAS_Aircraft;
            };
            if (!isNull CAS_Group) then {
                deleteGroup CAS_Group;
            };
            CAS_Active = false;
            CAS_Aircraft = objNull;
            CAS_Group = grpNull;
        };
    };
};

// --- MAIN EXECUTION ---
private _spawnPos = getPosATL player;

if (isServer) then {
    [_spawnPos] call CAS_fnc_SpawnAircraft;
} else {
    [_spawnPos] remoteExec ["CAS_fnc_SpawnAircraft", 2];
};