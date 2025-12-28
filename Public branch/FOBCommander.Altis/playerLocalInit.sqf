//========================================//
//          Mission Startup Sequence      //
//========================================//

[] spawn {
    // Initial Spawn Placement
    [] execVM "randomSpawn.sqf";

    sleep 2;
    systemChat "Initializing Startup Sequence, Please Wait...";

    // Spawn Starting FOB
    [] execVM "playerFobStart.sqf";

    sleep 12;

    // Add Core Logic Systems
    [] execVM "rankInit.sqf";
    [] execVM "fobSystem.sqf";
    [] execVM "campSystem.sqf";
    [] execVM "buildSystem.sqf";

    // Add Sitrep Action to Player
    player addAction ["<t color='#008080' size='1.2'>Sitrep</t>", { execVM "sitrepScreen.sqf"; }, nil, 50, true, true, "", "", 5];

    sleep 2;
    systemChat "Initialization Complete. All assets loaded. Good Luck!";

    // Display Initial Sitrep
    [] execVM "sitrepScreen.sqf";
};