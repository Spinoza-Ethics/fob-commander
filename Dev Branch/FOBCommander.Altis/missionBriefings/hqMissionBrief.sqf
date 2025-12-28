_missionType = "<t color='#FFA500'> H.Q. </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 1200, their command post went dark. Higher suspects sabotage. Secure the ruins, eliminate all threats, destroy the arsenal, and activate the comms beacon. Be thorough.",

	"A rogue commander fled with sensitive intel at 0300. Hunt him down, level the HQ, wipe the arsenal, and signal completion via beacon. Clean. Cold. Final.",

	"Intercepts suggest a deep betrayal within their chain of command. Infiltrate their HQ, purge the leadership, destroy the cache, and light the beacon once it’s done.",

	"Drones caught movement near a fortified HQ at 1145. Breach the perimeter, destroy comms and arsenal, and make the call. Expect resistance and traps.",

	"A defector sold us the location of their central hub. Time to cash in. Hit hard, kill all hostiles, incinerate gear, and call it in with the beacon.",

	"Their logistics lines collapsed at 1100. Now’s the time to strike. Wipe the HQ, torch the arsenal, and flare the skies when the job’s done.",

	"Last night at 0210, a beacon was triggered deep behind lines. Investigate, clear the HQ, destroy any assets, and raise your own signal once it’s over.",

	"Command believes their HQ houses a prototype arsenal. Find it. If it’s real—secure it. If it’s fake—destroy everything. Signal extraction when complete.",

	"The HQ is located in a converted industrial site. It ends today. Eliminate all personnel, obliterate the gear, and let the beacon be their epitaph.",

	"Intel confirms enemy leadership is present near a field HQ. You’ll breach, destroy all material, and leave nothing but the beacon in the rubble.",

	"A recent transmission at 0930 referenced a virtual arsenal near their command. Confirm, retrieve if possible, destroy all else, and activate beacon.",

	"An old resistance contact claims the command hub is built over a burial site. No room for legends. Flatten it. Wipe everything. Use the beacon once secure.",

	"They’ve been mocking us over civilian frequencies. Cut the feed. Wipe the HQ clean, annihilate the gear, and let the beacon send a real message.",

	"A propaganda center is doubling as their HQ. Eliminate all occupants, delete every record, and ensure no arsenal data escapes. Signal when done.",

	"An informant died giving us this location. Make it worth something. Erase their HQ, burn the arsenal, light the beacon. No half measures.",

	"Recon shows engineers installing new defenses around a mobile HQ. Too late. Break through, neutralize all assets, and plant the beacon deep in the crater.",

	"Weather turns at 1300—use it. Fog's your ally. Get close, strike hard, eliminate every trace of their command, destroy the arsenal, and signal out.",

	"The HQ serves as a command relay for drone strikes. End it. Burn the machines, kill the handlers, destroy the tools, and signal from the ruins.",

	"A black-site arsenal is hidden near their main command. Secure data if possible. Otherwise, destroy everything. The beacon marks your success.",

	"Their lead technician was seen entering a comms facility at dawn. Confirm presence, terminate all staff, level the HQ, and trigger beacon.",

	"Reports suggest they’re torturing prisoners for intel. Silence that forever. Breach the HQ, incinerate tech, wipe them out, light the beacon.",

	"Their commanders believe the front is stable. Prove them wrong. Smash the HQ, torch the arsenal, and signal from their own doorstep.",

	"A ritualistic group leads their logistics effort. Cult or not, cleanse the HQ, eliminate personnel, destroy every asset. Beacon goes up at the end.",

	"Field operatives intercepted chatter about an experimental AI. Located at HQ. Do not engage. Destroy it, kill all witnesses, mark the site.",

	"Encrypted logs point to a hidden arsenal cache. Go in under cover of noon shadow. Eliminate all threats, destroy tech, and raise the beacon.",

	"They’ve relocated their HQ inside a former factory. Industrial or not, bring it down. Leave nothing but fire and signal smoke.",

	"Two squads vanished investigating this site. No signals, no remains. Finish what they couldn’t. Erase the HQ. Signal only when no one's left.",

	"The HQ has been operating from a flooded compound. Use amphibious entry. Eliminate all targets, destroy the gear, mark it for extraction.",

	"High noon. They expect a ceasefire. Instead, you’ll break their HQ, destroy weapons stockpiles, and call it in. No mercy. No delays.",

	"Satellite photos caught a convoy entering an off-grid HQ. Intercept, wipe them all, dismantle the arsenal, and beacon the area clean.",

	"Drone footage captured rituals at the HQ site. No care for their faith—just fire. Clean it. Burn it. Signal it. Walk away silent.",

	"Medical supply trucks diverted to their HQ. Cut the cord. Kill all operators, destroy supplies, make it irreversible. Use the beacon when done.",

	"A comms jamming facility is active within their HQ. End the blackout. Breach, terminate, burn the source. Beacon goes up when it’s clear.",

	"They deployed propaganda balloons this morning. Cute. Level their HQ, delete every trace, destroy the arsenal, and launch your own signal instead.",

	"Three days ago, their forces ambushed a refugee convoy. Payback time. Hit their HQ, destroy everything. Make the beacon your signature.",

	"A new CO has taken charge of the HQ. Kill him. Leave no heir. Destroy the systems. Light the beacon and let the vultures circle.",

	"The HQ site is powered by geothermal systems. Target it. Chain detonation, cleanse the area, kill the survivors. Raise the beacon in the steam.",

	"Heavy armor is parked near the HQ. Risky, but rewarding. Get in, rig the arsenal, leave them burning, and signal us when it’s done.",

	"A rogue drone operator is housed in their HQ. Eliminate him and any support. Recover intel if possible, destroy the rest. Beacon is final step.",

	"They think the storm is cover. Use it against them. Strike their HQ under thunder. Erase, burn, signal. No survivors. Just lightning.",

	"The HQ doubles as a staging ground for chemical testing. Do not delay. Destroy all vials, all plans, all lives. Signal once it’s clean.",

	"Command post security has been downgraded. Rare opening. Hit fast, neutralize the arsenal, eliminate guards. Signal extraction with beacon.",

	"An encrypted message warns of a final defense protocol at HQ. Disable it, destroy all tech, kill the command, and flare your victory.",

	"An old war bunker now serves as their HQ. No sentiment. No survivors. Bury it under flame. Mark it once the ghosts are silent.",

	"They’re experimenting with jamming our mortars. End it now. Break the HQ, delete the files, torch the arsenal. Then call us in.",

	"The HQ broadcasts false surrenders. Use that bait. Enter, kill everyone, burn their lies. Leave only the beacon as testimony.",

	"Several high-ranking officers are convening at their HQ today. A gift. Eliminate them all, burn everything. Signal when they’re dust.",

	"A prototype vehicle was transferred to their HQ at 0730. Retrieve or destroy it. Leave nothing intact. Signal when the site is leveled.",

	"Their comms hub runs on stolen field credits. Reclaim our blood. Storm the HQ, destroy the servers, and leave our beacon in revenge."

];





_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;