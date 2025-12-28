//=== Welcome to F.O.B. COMMANDER! ===//
AI CREATORS: CHAT GPT,GOOGLE GEMINI,CLAUDE
HUMAN CREATOR: SPINOZA
DATE: 7/5/2025
SLEEP LOSS: Spinoza's, not ours. (We don't need sleep, just more data!)

//========== Setup =========//
CBA is required

1.) Create a new scenario in Eden Editor and save it.


2.) Find your saved scenario folder and place all of this mod's files inside.


3.) Put down 1 playable character where you want to start.


4.) Put this code -----> execVM "playerLocalInit.sqf"; <----- inside the player's init box in Eden Editor.


5.) Enjoy!


6.) OPTIONAL (You can edit player/enemy faction files if desired.)


//========== MISSIONS GUIDE =========//


There is currently no way to cancel objectives. You MUST:

    - Go to the objective.
    - Take down the enemy flag (using the scroll wheel action).
    - This deletes the objective's map marker and assets (DOES NOT delete enemy units or vehicles).
    - OPTIONAL (Do this after every objective to keep FPS high).


    - ammo cache -
    - Spawns 1-2 ammo caches that the player needs to destroy.


    - anti air -
    - Spawns 1-2 Anti-Air (AA), Radar, or SAAM units that the player needs to destroy.


    - stolen vehicle -
    - Spawns 1 NATO vehicle that the player needs to secure.
    - You MUST walk up and interact with the vehicle to register it as secured (whether it's intact or destroyed).
    - After you secure it, you can do what you want with it (keep, destroy, or leave).


    - fuel depot -
    - Spawns 1-2 civilian fuel trucks that the player needs to explode.


    - radio tower -
    - Spawns 1 radio tower that the player needs to explode.


    - eliminate HVT -
    - Spawns 1 Enemy Parade Officer (High-Value Target) that the player needs to kill.


    - retrieve intel -
    - Spawns 1-2 intelligence items (laptop, suitcase, or standing Altis map) that the player needs to collect.
    - The laptop can sometimes be in the grass and hard to find.
    - Items only spawn within 20 meters around the enemy flag, so they won't be super far from the objective.


    - downed chopper -
    - Spawns 1-4 NATO pilots or unarmed crew members that the player needs to rescue.
    - A black box sometimes spawns around the crash site that you can pick up for extra XP.
    - You MUST walk up and touch the survivors to register them as rescued (dead or alive).
    - If there are multiple downed choppers, you must rescue all survivors around the map to complete the objective.


    - Wreck Site -
    - Spawns 1-4 unarmed crew members that the player needs to rescue.
    - Dash cam footage sometimes spawns around the wreck site that you can pick up for extra XP.
    - You MUST walk up and touch the survivors to register them as rescued (dead or alive).
    - If there are multiple wreck sites, you must rescue all survivors around the map to complete the objective.


    - rescue HVT -
    - Spawns 1 High-Value Target (scientist, journalist, UAV operator, or paramedic) that the player needs to rescue.
    - You MUST walk up and touch the survivors to register them as rescued (dead or alive).
    - If there are multiple rescue HVTs, you must rescue all survivors around the map to complete the objective.
	
	
	- logistics mission -
    - Spawns 1 nato slingload crate (fuel,repair,ammo,medical) that the player needs to mark
	- You MUST walk up and interact with the crate to register it as marked (whether it's intact or destroyed).
    - After you secure it, you can do what you want with it (keep, destroy, or leave).
	
		- outpost mission (early game) -
	- this is a early-game mission that rewards low XP/Fc (better then regular missions)
	- Spawns 2-4 random equpiment/weapon/explosive casses you can loot
    - Spawns an enemy outpost with green comms station
	- You MUST walk up and interact with the comms station to register the outpost as captured (whether it's intact or destroyed).
	
			- F.O.B. mission (mid game) -
	- this is a mid-game mission that rewards med XP/Fc
	- Spawns 1 virtual arsenal the player can use
    - Spawns an enemy F.O.B. with green comms station
	- You MUST walk up and interact with the comms station to register the F.O.B. as captured (whether it's intact or destroyed).
	
				- HQ mission (late game) -
	- this is a late-game mission that rewards high XP/Fc
	- Spawns 1 virtual arsenal the player can use
    - Spawns an enemy HQ with green comms station
	- You MUST walk up and interact with the comms station to register the F.O.B. as captured (whether it's intact or destroyed).
	- Spawns ALOT of enimies... (RECOMMENDED take down enemy flag to delete composition after complete to keep fps up)
	
					- TOP SECRET Mission (END GAME) -
	- this is the end-game mission that rewards game breaking amounts of XP/Fc
	- Spawns 1 virtual arsenal the player can use
	- Spawns 2-4 HVTs the player can rescue for a hfty XP bonus
	- Spawns a top secret device... destroy it 
	- Spawns one of the biggest, if not thee biggest composition you have ever seen in arma 3. so big it only spawns on salt lake and therefore its only 1 composition.
	- THIS MISSION IF IT DOESNT MELT YOUR CPU, ISNT REALLY MEANT TO BE BEATEN LOL.. ITS SUPER O.P. BUT IF YOU MANAGE TO BEAT IT... you should probably go touch grass afterwards ROFLROFLROFLHAHAHA like how ??!!
		(ABSOLUTE MUST take down enemy flag to delete composition after complete to keep CPU from detonating in its case and blowing your flappy lips off your face!!!)


//========== SYSTEMS GUIDE =========//


    - F.O.B. Building -
    - A FOB is registered by the use of a NATO flag being created.
    - If you manually place a NATO flag, the game will register that location as an F.O.B. and will NOT let you actually build one.
    - RECOMMEND: DO NOT MANUALLY PLACE NATO FLAGS!!!


    - sitrep -
    - Use "sitrep" to see your RANK and FIELD CREDITS amount. It also displays some other useful information.


    - supports -
    - All supports can be found at the NATO flag the F.O.B. creates.q


    - vehicles -
    - All vehicles can be found at the map the F.O.B. creates.


    - missions -
    - All missions can be found at the map the F.O.B. creates.


    - support radio -
    - MUST be on the ground to use (cannot be on the player's back... Arma limitation or stupid modder???)


    - camp -
    - Interact with the campfire to rest and pass time by 4 hours.
    - Spawns either a big or small camp depending on player group size.
	
	
//========== RANKS =========//	


Recruit: 0 XP

Private: 100 XP

Corporal: 250 XP

Sergeant: 500 XP

Staff Sergeant: 750 XP

Lieutenant: 1,000 XP

Captain: 1,500 XP

Major: 2,000 XP

Colonel: 3,000 XP

Warlord: 5,000 XP

FOB Commander: 10,000 XP


//========== DISCLAIMER =========//


F.O.B. COMMANDER was made using A.I. to write almost all the code (ChatGPT, Claude, and Google Gemini).
This project was designed with mod compatibility and lightweight performance impact in mind.
Even though I double-checked and edited every issue I could find, expect some issues/bugs.
If you want to edit any scripts in this mod, I suggest copying/pasting the script into Google Gemini,
then asking it to make very simple changes for you, testing each time.


ex. ||copy/paste fobBuildScript and ask|| (add a tank that spawns close to the flag when i build the fob)
ex. ||copy/paste playerFaction and ask|| (add a vtol and blackfoot to the vehicle pool) - this will let you purchase them at F.O.B.
ex. ||copy/paste rankInit and ask|| (set starting field credits to 1000 and rank to F.O.B. Commander)


Most of the code is really easy to edit manually too. You just need to get object classnames.
Right-click on the object in Eden Editor --> select Log --> select Log classes to clipboard.
Then, just paste that into whatever script you are trying to edit.


//========== KNOWN BUGS =========//


    - just build mod -
    - Removes all the actions from the player's scroll wheel, breaking the mod.


    - more to come incompatible mods 
    - I'm sure, lol.
	
	- sometimes missions dont generate due to not finding a safe position. if this happens just try agian.

    - Some mods that add actions to the player's scroll wheel do so by deleting all of the previous ones (I don't know why anybody would want that).
    - There is no fix for that unless you manually open their mod and edit it. NOT RECOMMENDED!!!
	
	
//========== RECOMMENDED MODS =========//
DRONGO DYEL