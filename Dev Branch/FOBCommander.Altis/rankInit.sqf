//========================================//
//          Rank System Initialization    //
//========================================//

//starting rank,xp and credits
player setVariable ["XP", 0, true];
player setVariable ["FieldCredits", 12, true];
player setVariable ["Rank", "Recruit", true];

//xp needed for each rank
missionNamespace setVariable ["RankThresholds", [
    ["Recruit", 0],
    ["Private", 100],
    ["Corporal", 250],
    ["Sergeant", 500],
    ["Staff Sergeant", 750],
    ["Lieutenant", 1000],
    ["Captain", 1500],
    ["Major", 2000],
    ["Colonel", 3000],
    ["Warlord", 5000],
    ["FOB Commander", 10000]
], true];