_missionType = "<t color='#FFA500'> Stolen Vehicle </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 1200 hours, a stolen Helios Logistics Truck vanished behind contested lines. Command suspects inside help. Locate the vehicle, confirm status, and transmit recovery signal. Eyes open—enemy patrols frequent the area.",
	
	"Last night at 0300, a QRF truck went dark after rerouting from a compromised outpost. Friendly signatures detected briefly before vanishing. Locate it. Recover if intact. Radio back once secured.",
	
	"A supply convoy went rogue at dawn. One of our trucks, code-tagged ARK-15, disappeared from comms. Intelligence flags internal betrayal. Secure the vehicle. Do not engage unless fired upon.",
	
	"Drone recon at 0930 caught a glimpse of a military truck matching BLUFOR designations deep in enemy territory. Verify the sighting. Locate. Transmit beacon upon confirmation.",
	
	"Rumors spread fast—locals say a 'ghost truck' appeared near the ruins. Might be our stolen asset. Investigate. If found, get it operational and call it in. This isn’t superstition. It’s logistics.",
	
	"A friendly truck hijacked by unknowns during refuel has reappeared on scattered comms. Reports place it mobile. If it's still running, we want it back. Locate and report.",
	
	"ARC-2 lost contact near the perimeter at 1100. Intel suggests the crew defected. Drone eyes saw a truck in hostile livery matching its frame. If it's functional, call it in. If not, mark it.",
	
	"At noon, radio intercepts caught chatter about a 'new prize'. We suspect it’s the stolen KILO-7 supply vehicle. Find it. Verify it’s intact. Avoid destruction at all costs—Command wants it running.",
	
	"Command is furious—another truck lost. This one's an upgraded logistics variant, stolen yesterday evening. Search nearby routes and strongholds. Recover and ping home.",
	
	"Enemy unit MAW-3 parades our stolen vehicle in front of locals. Morale’s bleeding. Reclaim it. Quietly. Radio the location once it’s in hand. Make it personal if you have to.",
	
	"Interference on friendly channels hints at a stolen communications truck still broadcasting. Track the signal, find the truck, and call it in. No retrieval, no bonuses.",
	
	"Last seen on a ridge at 0845, our logistics truck may have been stripped for parts—or bait. Intel's shaky. Proceed, locate the asset, and activate recovery signal if viable.",
	
	"A civilian tip suggests our missing APC—designated PACT-9—was seen loaded on a flatbed under guard. If it’s real, extract its coordinates. Bring it home.",
	
	"Three days ago, a tech team’s truck vanished during a resupply run. Our UAVs finally picked up thermal signatures in a nearby compound. Find the truck. Report once secure.",
	
	"Our stolen light armor truck was last heard transmitting coded pings at 0430. Cracked encryption suggests it’s powering enemy systems. Shut that down. Radio when it’s yours again.",
	
	"A friendly vehicle outfitted for drone control was captured yesterday. It may be powering enemy UAVs now. Find it. Secure it. Call in coordinates.",
	
	"FALCON-2’s recon truck was hijacked mid-operation. The crew is presumed KIA. Find the truck. Confirm status. Transmit recovery beacon. Vengeance optional.",
	
	"An experimental refueling truck never returned from last night’s convoy. High command wants it intact. You find it, you own the moment. Ping back when recovered.",
	
	"At 1000, intercepted comms suggested a stolen BLUFOR truck is being prepped for transport. That’s your window. Retrieve and signal command when it’s clear.",
	
	"One of our engineers’ prototype comms trucks is in enemy hands. If they reverse engineer it, we’re blind. Secure it. Radio in the moment you get it safe.",
	
	"Midday drone footage spotted a blue-outlined truck behind enemy lines. Could be one of ours. Investigate. Get eyes on it. Signal once confirmed.",
	
	"Enemy troops were seen offloading crates from a truck marked Delta-12. That’s a friendly unit’s gear. Locate and recover the vehicle. Aerial support on standby.",
	
	"A senior officer’s transport truck, hijacked last week, just pinged a GPS location. Get there. Secure it. Don’t leave without calling in.",
	
	"The truck was last seen being driven by hostiles dressed in BLUFOR fatigues. Don’t trust uniforms. Get that vehicle. Radio us as soon as it's safe.",
	
	"A freelancer swears he saw a military truck bearing our sigils moving fast toward the north. Trust but verify. Locate the truck. Signal home.",
	
	"Hostile unit HAMMER-6 is joyriding in our own motor pool asset. That ends now. Reclaim the truck. No need for fireworks—just secure and ping HQ.",
	
	"Word is, our stolen asset is being used as bait. Trust no one. Sweep carefully. Recover the truck. Signal as soon as it's in good shape.",
	
	"BLUFOR truck ‘ECHO-BIRD’ was last pinged 26 hours ago. Repeating signals indicate it's powered. Seek it out. Confirm functionality. Radio when secure.",
	
	"Command lost contact with a truck transporting encryption tech. Recovery is critical. Time matters—radio the location immediately once found.",
	
	"Our stolen asset may now serve as a mobile enemy HQ. If it's running, we want it. Confirm status. Radio in. We’ll handle the rest.",
	
	"They think they can flaunt our gear? A friendly truck was seen in an enemy parade. Find it. Reclaim it. Radio in, loud and clear.",
	
	"A traitor handed them our comms vehicle. We need it back to decrypt their plans. Locate it fast. Transmit position when it’s in hand.",
	
	"A BLUFOR-marked truck showed up in local drone feeds—half-buried in foliage. Could be salvageable. Find it. Don’t engage unless needed. Signal HQ.",
	
	"Last known position was grid 2043—an old forward point. Truck could be under wraps. Approach with caution. Ping command if the engine still runs.",
	
	"A recon drone crashed hours ago—its uplink truck went with it. Recovery priority is moderate. Find it. Radio if it’s functional.",
	
	"Your task: locate our stolen supply truck. No heroics, no deviation. Secure, confirm integrity, and signal base. Everything else is background noise.",
	
	"Our fuel logistics truck was taken during a blackout. Infrared picked up heat near an abandoned checkpoint. Confirm it's ours. Call it in.",
	
	"A military vehicle, BLUFOR build, is reported stationed near enemy HQ. Recovery is delicate. Avoid confrontation if possible. Signal once you’ve got eyes.",
	
	"High-value logistics truck taken from FOB Remnant last week. Markings still visible. Locate, verify status. Radio command immediately.",
	
	"A major reward’s been placed on the return of transport vehicle Echo-9. That’s incentive. Get it running and signal HQ.",
	
	"A platoon’s transport truck vanished in a storm three days ago. Enemy may have found it first. Retrieve and confirm status. Radio back.",
	
	"Last sat-pass at 0930 shows our truck abandoned near a ravine. Maybe they couldn’t drive stick. Check it. If it's usable, call it in.",
	
	"Friendly vehicle CHALK-5 lost during last week’s retreat may still be intact. Drone feed shows a possible match. Investigate. Signal once confirmed.",
	
	"A broadcast traced to a stolen comms truck was picked up at 1130. We need that tech back. Locate and report once secured.",
	
	"A vital logistics truck lost contact during a chemical leak response. No time to waste. If it's operational, mark it for evac. Radio us.",
	
	"Callsign GHOST-6 lost their ride last operation. It's likely intact. Enemy may not even know what they’ve got. Find it. Signal fast.",
	
	"Yesterday, a friendly truck was seen heading the wrong direction—likely coerced. No pursuit team was sent. That’s your job. Find it. Transmit status.",
	
	"Recovering our drone-launch vehicle is top priority. It was lost in the chaos during a failed assault. Track it. If functional, signal base.",
	
	"Our vehicle—PASTURE-1—was overtaken during last week's mutiny. If it’s still operational, we want it. Get to it and radio in."

];




_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;