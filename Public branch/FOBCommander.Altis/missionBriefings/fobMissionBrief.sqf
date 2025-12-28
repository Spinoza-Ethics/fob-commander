_missionType = "<t color='#FFA500'> F.O.B. </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 1200 hours, enemy forces established a fortified F.O.B. near the river basin. Intel suggests it houses a comms beacon. Sweep and secure the site, eliminate all hostiles, and activate the beacon to claim it. Watch for armor. Command wants this done clean.",

	"Comms went dark at 0530. Our recon drone saw figures moving near a ruined depot. Suspect: enemy F.O.B. in progress. Get in, clear the bastards, locate a rumored virtual arsenal, and deploy the comms beacon. No second chances on this one.",

	"A hostile garrison is holed up in a prefab bunker network. They’ve repelled two previous assaults. Your task: breach, kill, capture. Look for tech crates—we believe they have a black-market arsenal stashed inside.",

	"Enemy logistics convoy spotted unloading crates this morning. Looks like they’re turning an old scrapyard into a forward operating base. Time to crash the party. Hit hard, clear the scum, and activate the beacon. Simple plan—high risk.",

	"Dawn patrol stumbled across comms interference near Grid 9. Suspected enemy relay station. Take a squad, secure the F.O.B., eliminate resistance, and establish our signal. Bonus if you find the enemy’s mobile arsenal. Expect resistance.",

	"Enemy patrol ‘Wolfclaw’ was last seen headed north with portable defenses. We suspect they’ve formed a staging post. Your orders: wipe them out, find the cache, and secure the area for BLUFOR control. Don’t get sentimental—clean sweep only.",

	"At 0300, we intercepted a scrambled message: 'Beacon online. FOB secure.' That FOB isn’t ours. Make it ours. Push in, find the beacon, hold the site until Command flips the zone. There’s no backup. There is no delay. Go.",

	"A rogue unit from the enemy 47th Battalion has dug in tight. They’re well-equipped and expecting us. Eliminate every soldier, locate their virtual cache, and seize the site. Don’t let them radio for reinforcements.",

	"Enemy drone activity spiked over sector six. Suspected relay hub buried in a makeshift FOB. Orders are simple: terminate all hostiles, secure intel, and flip the beacon. They won't know what hit them.",

	"A traitor flipped on us last week. He handed over FOB blueprints. Now it's time we reclaim what’s ours. Sweep the area, neutralize everything breathing, activate the beacon. And find that traitor’s weapons drop, if it's real.",

	"Last night at 2200, heavy fire from a hidden emplacement took out Alpha Convoy. The source? A camouflaged FOB crawling with hostiles. You’re going in. Terminate resistance, search for supplies, flip their beacon against them.",

	"The enemy set up a rapid-deploy FOB using prefabs. They're light on defenses but big on tech. Storm the site, wipe them out, and secure their arsenal before it’s relocated. Expect a quick counterstrike.",

	"Bravo-Two caught a glimpse of enemy forces stockpiling drones near an old bunker. They didn’t make it back. Clear the FOB, seize any drone assets, and transmit capture via the beacon. Payback is personal.",

	"At 1130, a stolen BLUFOR beacon was activated. It’s broadcasting from a hostile zone. Your orders: retake the FOB, destroy the unit operating it, and recover the beacon. If they beat us to it again, we lose more than credits.",

	"High command confirmed enemy drone support over the hills. They're operating from a FOB built within the wreckage of an old factory. Assault the position, kill the operators, locate the beacon, and signal our claim.",

	"Enemy call-sign 'Hammer Eye' has fortified an old communications array. Your task: breach the FOB, kill the comms team, and use their own beacon to secure the site. Find any tech they left behind and destroy it.",

	"A recon drone went offline 6 minutes after passing over the target zone. Suspect: jamming beacon. Move in, eliminate the FOB crew, capture the area, and destroy any jamming tech. Expect heavy infantry resistance.",

	"An enemy squad calling themselves ‘Iron Pact’ has fortified an FOB with stolen BLUFOR gear. Reclaim our equipment, neutralize the hostiles, and activate the beacon. This one's personal.",

	"Resistance is stiff, but a drone strike cleared the outer defenses of a known enemy FOB. Move now while they’re disoriented. Clean out the rest and secure the beacon. Rumor says they have a hidden arsenal deep inside.",

	"A strange transmission came from an abandoned quarry. High command suspects enemy forces are hiding a beacon there. You’re to infiltrate, sweep the FOB, and flip the signal in our favor. Do it fast—before they dig in.",

	"Enemy reinforcements landed last night. They've built a hasty FOB using trucks and dirt barriers. Expect sloppiness. Clean them out, scavenge any intel, and activate the beacon once it's secure.",

	"A drone pilot reported a heat signature underground. It’s a hidden FOB—and likely crawling with enemies. Take them out, locate any virtual arsenal, and beacon in our presence. This is deep strike territory.",

	"FOB 'Stonefist' has fallen to enemy hands. Retake it, hold it, and don’t come back without their heads. The beacon’s still intact. Use it to re-establish friendly control. Wipe the slate clean.",

	"An enemy beacon went live in Sector 4 an hour ago. It's unguarded—too quiet. Proceed with caution, secure the FOB, and watch for traps. Eliminate stragglers and bring that comms post back online.",

	"FOB ‘Cliff Nest’ is more than a name—it’s a deathtrap. Heavy resistance expected. Still, your orders stand: purge all defenders, secure the beacon, and scan for black market gear hidden in the rocks.",

	"A defected engineer claims his old squad is stashing experimental drone tech in a field FOB. Validate the claim, eliminate all resistance, and activate the beacon once you’ve cleared the area.",

	"Enemy platoon 'Grey Harbinger' constructed a camo-netted FOB near the woods. Their morale is high. Crush them, capture the beacon, and look for signs of drone command units. Silence is your ally.",

	"A wounded scout reported automated defenses guarding a remote FOB. That means tech. That means credits. Engage with caution, clear the site, seize the beacon, and hack anything worth salvaging.",

	"An intel drop hints that a mercenary company is operating under enemy banner. Hunt them down at their forward base, eliminate the entire squad, and beacon the zone for extraction ops.",

	"Overwatch drones picked up thermal contacts around a static vehicle depot. It’s no depot—it’s a well-camouflaged FOB. Engage, secure, and reclaim the beacon buried inside. Priority target: their commander.",

	"Their beacon's active. Our zone's lost. Reclaim it. Fast and loud. Leave no survivors. Activate the signal to reassert control. Field Command doesn’t want excuses—they want results.",

	"A drone strike missed its mark. Instead of disabling the FOB, it gave them a warning. Go in and finish the job. Eliminate resistance, search for weapons, and signal our flag once the smoke clears.",

	"Reports say the enemy built a forward base out of stolen BLUFOR components. Reinforcements are on the way. Beat them there, retake our gear, and send the beacon signal. Expect anti-vehicle measures.",

	"Bravo Recon spotted a beacon flashing in the open. It's bait. Take the risk. Kill whoever’s guarding it, reclaim the FOB, and if the arsenal’s still intact—loot it before Command shows up.",

	"Enemy squad ‘Vulture Knife’ established a forward post last week. They’re heavily armed and cocky. Time to fix that. Eliminate them, scavenge their drone controller, and flip the beacon once it’s safe.",

	"A prisoner mentioned an enemy FOB hidden inside an old rail hub. Your objective: secure the beacon, eliminate the defenders, and locate the rumored weapons cache beneath the tracks.",

	"Our mortars got counter-batteried from a mystery location. Turns out: enemy FOB disguised as a medical station. Secure it, clear it, and capture the beacon before they move again.",

	"Enemy engineers constructed a prototype FOB from modular vehicles. Destroy their plans, secure the area, and use their beacon to call in reinforcements. Their modularity is our opportunity.",

	"A forward post housing anti-drone systems has gone dark. Suspected enemy sabotage. Investigate, eliminate opposition, and turn their tech against them by activating the beacon.",

	"A squad of drone specialists defected last month. Now they're field-testing enemy equipment in a hidden FOB. Kill the defectors, recover what tech you can, and beacon the zone for retrieval.",

	"A supply truck was hijacked and redirected to an enemy-controlled FOB. Retrieve the supplies, neutralize the guards, and flip the beacon to signal zone capture.",

	"A massive jamming field went up at 0430. It's coming from a new FOB installation. Find the emitter, shut it down, kill whoever’s operating it, and re-secure the site using the beacon.",

	"An old rebel bunker was refurbished into a military FOB. No rules, no mercy. Kill everyone, take everything, and get that beacon online. The area may still have tripwires—stay sharp.",

	"A drone crashed near a suspected FOB. Retrieve the wreckage, eliminate all hostiles, and activate the beacon once the zone is clear. Enemies are jumpy—use that against them.",

	"They’ve activated an old power substation for FOB ops. Bad news. Clean out their engineers, deactivate enemy systems, secure the beacon. If you see electrified gear—don’t touch it.",

	"Our intel agents believe a beacon was installed beneath an enemy vehicle yard. Dig them out, burn their rides, and send a signal. This op won’t be subtle—nor should it be.",

	"Enemy psy-ops team ‘False Light’ is using a mobile FOB to broadcast disinformation. Shut it down, kill the broadcasters, and beacon the area to signal comms realignment.",

	"A veteran unit has fortified an outpost with redundant defenses and a beacon. Hit fast, hit hard, and disable their fallback tech. Don’t let them regroup.",

	"FOB 'Dust Mirror' is sending encrypted pulses. Suspected enemy comms test site. Eliminate everyone, secure the beacon, and extract any signal data from the hub. Expect scientists and soldiers alike.",

	"A hidden FOB detected by thermal scan contains several weapon crates. You know what to do. Kill everyone, claim the tech, and send the capture signal before anyone notices.",

	"A convoy diverted course and vanished near the badlands. Their last stop: a hidden FOB. Find it. Eliminate the unit. Activate the beacon. Recover any lost gear. Bring them home."

];





_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;