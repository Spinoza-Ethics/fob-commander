//========================================//
//               Diary Records            //
//========================================//

// Bugs
player createDiaryRecord ["Diary", ["Bugs", "
<font color='#FFA500' size='14' face='PuristaBold'><t align='center'>── BUGS ──</t></font><br />
<br />
<t align='center'><font color='#FF0000'>**MOD COMPATIBILITY ISSUES**</font></t><br />
<t align='center'><font color='#ADD8E6'>JUST BUILD MOD</font></t><br />
<t align='center'>- Most mods that add actions to player scroll wheel, Break this mod.</t><br />
<t align='center'>- This is due to modders clearing all actions instead of just the ones they added.</t><br />
<t align='center'>- There is no simple fix for this.</t><br />
<br />
<t align='center'><font color='#FF0000'>**MISSION GENERATION**</font></t><br />
<t align='center'>- Missions may occasionally fail to generate due to unsafe/not finding a good position error.</t><br />
<t align='center'>- If this occurs, simply try again.</t><br />
<br />
"]];

// Ranks
player createDiaryRecord ["Diary", ["Ranks", "
<font color='#FFA500' size='14' face='PuristaBold'><t align='center'>── RANKS ──</t></font><br />
<br />
<t align='center'>Recruit: 0 XP</t><br />
<t align='center'>Private: 100 XP</t><br />
<t align='center'>Corporal: 250 XP</t><br />
<t align='center'>Sergeant: 500 XP</t><br />
<t align='center'>Staff Sergeant: 750 XP</t><br />
<t align='center'>Lieutenant: 1,000 XP</t><br />
<t align='center'>Captain: 1,500 XP</t><br />
<t align='center'>Major: 2,000 XP</t><br />
<t align='center'>Colonel: 3,000 XP</t><br />
<t align='center'>Warlord: 5,000 XP</t><br />
<t align='center'>FOB Commander: 10,000 XP</t><br />
<br />
"]];

// Systems Guide
player createDiaryRecord ["Diary", ["Systems Guide", "
<font color='#FFA500' size='14' face='PuristaBold'><t align='center'>── SYSTEMS GUIDE ──</t></font><br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• F.O.B. Building:</font><br />
    A FOB is registered when a NATO flag is created.<br />
    Do <font color='#FF0000'>NOT</font> manually place NATO flags, as this prevents F.O.B. construction.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Sitrep:</font><br />
    Use SITREP to view your <font color='#FFA500'>FIELD CREDITS</font>, <font color='#ADD8E6'>XP</font>, <font color='#FF0000'>RANK</font> and other useful information.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Supports, Vehicles, Missions:</font><br />
    All can be accessed at the MAP or FLAG created by your F.O.B.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Support Radio:</font><br />
    Wearable but must be on the ground to use.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Camp:</font><br />
    Interact with the campfire to rest and advance time by 4 hours.<br />
    Camp size varies with player group size.<br />
<br />
"]];

// Base Missions
player createDiaryRecord ["Diary", ["Base Missions", "
<font color='#FFA500' size='14' face='PuristaBold'><t align='center'>── BASE MISSIONS ──</t></font><br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Outpost Missions (Early Game):</font><br />
    Capture enemy outpost by interacting with the <font color='#008000'>GREEN COMMS STATION</font> (intact or destroyed).<br />
<br />
    This is the Only <font color='#FFA500'>MISSION</font> in the game that spawns random loot boxes.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• F.O.B. Missions (Mid Game):</font><br />
    Capture Same as above.<br />
    Spawns 1 NATO Ammo Crate with Access to <font color='#FF0000'>VIRTUAL ARSENAL</font>.<br />
    On some rare occasions, the box spawns inside another object making it impossible to find/use<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• HQ Missions (Late Game):</font><br />
    Capture Same as above, Only alot harder and alot more enemies<br />
    Spawns 1 NATO Ammo Crate with Access to <font color='#FF0000'>VIRTUAL ARSENAL</font>.<br />
    <font color='#008000'>Pro Tip: </font> Take down the enemy flag after completion to delete the composition and maintain FPS.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• TOP SECRET Mission (END GAME):</font><br />
    Capture Same as above, Only extremely harder and an FPS melting amount of enemies<br />
    Rescue 2-4 HVTs for bonus XP.<br />
    This mission only spawns on Salt Lake (Due to Massive size of its composition).<br />
    <font color='#FF0000'>ABSOLUTE MUST:</font> Take down the enemy flag after completion to prevent performance issues.<br />
<br />
"]];

// Side Missions
player createDiaryRecord ["Diary", ["Side Missions", "
<font color='#FFA500' size='14' face='PuristaBold'><t align='center'>── SIDE MISSIONS ──</t></font><br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Logistics Missions:</font><br />
    Tag 1 NATO slingload crate (fuel, repair, ammo or medical).<br />
    Rewards high <font color='#FFA500'>FIELD CREDITS</font> but low <font color='#ADD8E6'>XP</font>.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Ammo Cache:</font><br />
    Destroy 1-2 ammo caches.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Anti-Air:</font><br />
    Destroy 1-2 AA (Radar or AA Vehicle).<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Stolen Vehicle:</font><br />
    Secure 1 NATO vehicle.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Fuel Depot:</font><br />
    Destroy 1-2 fuel trucks.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Radio Tower:</font><br />
    Destroy 1 radio tower.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Eliminate HVT:</font><br />
    Neutralize 1 Enemy Parade Officer.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Retrieve Intel:</font><br />
    Collect 1-2 intel items (laptop, suitcase, or map).<br />
    Items spawn within 20m of the enemy flag.<br />
    Laptops can be hard to spot in grass.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Downed Chopper:</font><br />
    Rescue 1-4 crew members.<br />
    Interact with survivors (dead or alive) to register as found.<br />
    Collect black box for bonus XP.<br />
    MUST Rescue ALL the survivors across multiple crash sites for completion.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Wreck Site:</font><br />
    Rescue 1-4 crew members.<br />
    Interact with survivors (dead or alive) to register as found.<br />
    Collect dash cam footage for bonus XP.<br />
    MUST Rescue ALL the survivors across multiple crash sites for completion.<br />
<br />
<font color='#ADD8E6' face='PuristaBold'>• Rescue HVT:</font><br />
    Rescue 1 civilian (scientist, journalist, UAV operator or paramedic).<br />
    Interact with survivors (dead or alive) to register as found.<br />
    MUST Rescue ALL the HVTs across multiple sites for completion.<br />
<br />
"]];

// Commander Briefing
player createDiaryRecord ["Diary", ["Commander Briefing", "
<font color='#FFA500' size='14' face='PuristaBold'><t align='center'>── OBJECTIVE CLEARING ──</t></font><br />
<br />
To clear an objective, you <font color='#FF0000'>MUST</font>:<br />
<br />
1. Navigate to the objective.<br />
2. Locate and interact with the <marker name='enemy_flag_icon'>enemy flag</marker> (scroll wheel) to take it down.<br />
<br />
This removes the objective's map marker and associated assets, but <font color='#FF0000'>DOES NOT</font> delete enemy units or vehicles.<br />
<br />
<font color='#008000'>Pro Tip: </font>While taking down the flag is not entirely necessary, it helps a lot with maintaining high FPS.<br />
<br />
"]];