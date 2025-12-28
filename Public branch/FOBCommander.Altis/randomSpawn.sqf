//========================================//
//        Random Flat Land Spawn          //
//========================================//

//this script only runs when a newgame is started
fnc_findFlatLandSpawn = {
    private ["_worldSize", "_attempts", "_maxAttempts", "_spawnPos"];

    _worldSize = worldSize;
    _maxAttempts = 200;
    _attempts = 0;

    while {_attempts < _maxAttempts} do {
        // Generate random coordinates, avoiding world edges
        _spawnPos = [
            (random (_worldSize * 0.8)) + (_worldSize * 0.1),
            (random (_worldSize * 0.8)) + (_worldSize * 0.1),
            0
        ];

        // Quick water check
        if !(surfaceIsWater _spawnPos) then {

            // Check for significant objects within 20m radius
            private _nearObjects = nearestObjects [_spawnPos, ["All"], 20];
            _nearObjects = _nearObjects select {
                !(_x isKindOf "Man") &&
                !(_x isKindOf "Animal") &&
                !(_x isKindOf "Bird") &&
                !(_x isKindOf "Logic") &&
                !(_x isKindOf "Trigger")
            };

            if (count _nearObjects == 0) then {

                private _isFlat = [_spawnPos] call {
                    params ["_center"];

                    // Get reference height at center
                    private _centerHeight = getTerrainHeightASL _center;

                    // Test in a tight 5m radius first for immediate area
                    private _testRadius = 5;
                    private _maxHeightDiff = 0.1; // Only 10cm variation allowed

                    for "_i" from 0 to 15 do {
                        private _angle = _i * 22.5;
                        private _testPos = [
                            (_center select 0) + (_testRadius * cos _angle),
                            (_center select 1) + (_testRadius * sin _angle),
                            0
                        ];

                        private _testHeight = getTerrainHeightASL _testPos;
                        if (abs(_testHeight - _centerHeight) > _maxHeightDiff) exitWith {false};
                    };

                    // If tight circle passes, test wider area
                    _testRadius = 10;
                    _maxHeightDiff = 0.2;

                    for "_i" from 0 to 11 do {
                        private _angle = _i * 30;
                        private _testPos = [
                            (_center select 0) + (_testRadius * cos _angle),
                            (_center select 1) + (_testRadius * sin _angle),
                            0
                        ];

                        private _testHeight = getTerrainHeightASL _testPos;
                        if (abs(_testHeight - _centerHeight) > _maxHeightDiff) exitWith {false};
                    };

                    // Final test: check if we're on a slope by testing 4 cardinal directions
                    private _cardinalDirs = [0, 90, 180, 270];
                    {
                        private _angle = _x;
                        // Test at 15m distance in cardinal directions
                        private _testPos = [
                            (_center select 0) + (15 * cos _angle),
                            (_center select 1) + (15 * sin _angle),
                            0
                        ];

                        private _testHeight = getTerrainHeightASL _testPos;
                        private _heightDiff = abs(_testHeight - _centerHeight);

                        if (_heightDiff > 0.3) exitWith {false};
                    } forEach _cardinalDirs;

                    // Final Validation: Cross-slope test
                    private _oppositeTests = [
                        [[10, 0], [-10, 0]],    // East-West
                        [[0, 10], [0, -10]],    // North-South
                        [[7, 7], [-7, -7]],     // NE-SW diagonal
                        [[7, -7], [-7, 7]]      // NW-SE diagonal
                    ];

                    {
                        private _testPair = _x;
                        private _pos1 = [
                            (_center select 0) + ((_testPair select 0) select 0),
                            (_center select 1) + ((_testPair select 0) select 1),
                            0
                        ];
                        private _pos2 = [
                            (_center select 0) + ((_testPair select 1) select 0),
                            (_center select 1) + ((_testPair select 1) select 1),
                            0
                        ];

                        private _height1 = getTerrainHeightASL _pos1;
                        private _height2 = getTerrainHeightASL _pos2;

                        if (abs(_height1 - _height2) > 0.2) exitWith {false};
                    } forEach _oppositeTests;

                    true // All tests passed
                };

                // If flatness test passes, we found our spot
                if (_isFlat) exitWith {
                    _spawnPos set [2, 0]; // Ground level
                };
            };
        };

        _attempts = _attempts + 1;
    };

    // Fallback: find the flattest area near world center if max attempts reached
    if (_attempts >= _maxAttempts) then {
        hint "Searching for flattest available area...";
        private _bestPos = [_worldSize / 2, _worldSize / 2, 0];
        private _bestFlatness = 999;

        for "_i" from 0 to 49 do {
            private _testCenter = [
                (_worldSize * 0.3) + (random (_worldSize * 0.4)),
                (_worldSize * 0.3) + (random (_worldSize * 0.4)),
                0
            ];

            if !(surfaceIsWater _testCenter) then {
                private _centerHeight = getTerrainHeightASL _testCenter;
                private _maxDiff = 0;

                for "_j" from 0 to 7 do {
                    private _angle = _j * 45;
                    private _testPos = [
                        (_testCenter select 0) + (10 * cos _angle),
                        (_testCenter select 1) + (10 * sin _angle),
                        0
                    ];
                    private _testHeight = getTerrainHeightASL _testPos;
                    _maxDiff = _maxDiff max (abs(_testHeight - _centerHeight));
                };

                if (_maxDiff < _bestFlatness) then {
                    _bestFlatness = _maxDiff;
                    _bestPos = _testCenter;
                };
            };
        };

        _spawnPos = _bestPos;
        hint format ["Using flattest available area (variation: %1m)", round(_bestFlatness * 100) / 100];
    };

    _spawnPos
};

// Execute the function
private _newSpawnPos = [] call fnc_findFlatLandSpawn;

// Teleport player to new position
player setPosATL _newSpawnPos;

// Confirmation message
hint format ["Spawned at: %1", mapGridPosition _newSpawnPos];