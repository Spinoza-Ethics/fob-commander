_missionType = "<t color='#FFA500'> Downed Chopper </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"Last night at 0300, a friendly recon bird went down behind contested lines. Signals cut at impact. Your task is to locate the wreck, sweep for survivors, eliminate hostiles, and retrieve the black box—if it still exists.",

	"At 1200, a friendly Helo, callsign 'Specter 2', vanished mid-transit. No comms, no flares. Get eyes on the crash zone, eliminate threats, recover anything useful. Command wants that black box—no matter the cost.",

	"Friendly bird went down—nobody knows why. Find the wreck. Kill whoever’s poking around. If there are survivors, patch them up. If there’s a black box, bring it home. If not... improvise.",

	"Drone feed confirmed enemy looters on-site. We want eyes on the downed helo, not bootprints. Secure the area, deal with any threats, and retrieve that black box if it wasn’t stripped already.",

	"At 1100, 'Skyhand 3' dropped off radar. Your mission: investigate the crash site, sweep for survivors, and recover intel. Enemy QRF might already be en route—move fast.",

	"A chopper went down at dawn—no distress call, no survivors seen. Rumors say the enemy was waiting for it. Get there, clean house, and bring back whatever they didn’t torch.",

	"FOB Caraway picked up a weak mayday before silence. You’re to search the crash area, rescue any survivors, neutralize hostiles, and recover the black box before it vanishes for good.",

	"Don’t expect a warm welcome. Command suspects the bird was shot down during covert insertion. Search the wreck, eliminate resistance, extract the flight recorder—or what’s left of it.",

	"A crash, a blackout, and now enemy chatter is spiking. Get in fast, secure the wreck, kill any threats, and find out what they were carrying. The black box might be our only answer.",

	"A low-flying helo went down at 0300. Civilian witnesses saw men in gear looting it soon after. If they got the black box, you’ll need to take it back by force. Expect resistance.",

	"Retrieve that black box. Enemy patrols may already be on-site. Any survivors—unlikely—are secondary. Your rifle is the only rescue they'll get.",

	"At noon, 'Falcon Nine' fell off the map. Last known heading suggests hostile airspace. You are to locate the wreckage, neutralize any presence, and recover the data core if intact.",

	"Something cooked that bird midair—EMP? AA? We don’t know. Find the pieces, kill any snoopers, and bring back anything worth debriefing. Survivors are a bonus.",

	"No heroics. Get in, find the crash site, neutralize any enemy, and search for survivors. If the black box was taken, track it down. If it’s gone, make sure nobody benefits from it.",

	"Scouts found smoke this morning—might be from our missing bird. Get boots on the ground, recover data, and eliminate any hostiles guarding the wreck.",

	"The enemy has the site locked down. They're looking for something. Beat them to it. Secure the crash, recover the black box, and kill anything that slows you down.",

	"No last words, no mayday. A bird dropped dead over contested territory. We want answers. Locate the wreckage, secure the area, and recover any salvageable intel.",

	"Radar showed one blip too many—then none at all. Assume the crash is no accident. Sweep the site, take out hostiles, and confirm if the black box survived the impact.",

	"1300 hours: satellite shows a burn mark the size of a helo. Friendly callsigns are silent. Get out there. Secure the site, kill hostiles, and see what’s left worth saving.",

	"Enemy scavengers are crawling the site. Our wreck, our data, our dead. Don’t let them leave with anything. Recover the black box—or prevent anyone else from finding it.",

	"We've lost more than a chopper. High-level data was onboard. Search the crash site, confirm casualties, and recover or destroy the black box. No one else gets that intel.",

	"Midday crash, unknown cause. No signs of survivors. If the black box is still there, bring it in. If it’s not—find out who has it and erase them.",

	"A courier bird went down an hour ago. Top-side wants the payload recovered and the scene secured. Black box is priority. Survivors? If any, consider them lucky.",

	"Mission priority is the flight recorder. Second is clearing any hostiles. If survivors resist recovery, sedate or extract. We need answers more than sentiment.",

	"Radio silence since dawn. Intel suggests the bird was shot down. You’re to investigate the crash, confirm enemy presence, and recover what you can.",

	"Black box might be fried. That’s not your concern. Get to the crash, kill whatever’s poking around, and send a drone back with anything salvageable.",

	"‘Rook-5’ vanished mid-evac. Last ping was just north of the zone. Find the wreck, terminate threats, and retrieve any comms logs still intact.",

	"They were running evac under fire—something clipped their tail. Crash happened around 0900. You're boots-on-site. Kill threats, secure the crash, and check for surviving crew.",

	"We intercepted enemy chatter about a crash site raid. Get there first. Eliminate the scavengers and find out what secrets burned in that wreck.",

	"Your boots will touch soil ten minutes ahead of enemy search teams. Find the wreck, hold it, and exfil the black box. Leave no survivors.",

	"Some say the bird was sabotaged. Others say it was cursed. Either way, find what’s left of it, kill any grave-robbers, and bring back something useful.",

	"Friendly HVT was aboard when the helo went dark. His fate is unknown. You are to recover the black box and sweep for survivors. Discretion is not required.",

	"Weapons fire was reported moments before crash. Enemy denial squads may already be on-site. You know what to do: secure, recover, eliminate.",

	"This ain’t a rescue mission—it’s a cleanup. Kill hostiles, find the black box, and leave nothing behind but brass.",

	"Eyes in the sky caught fire—literally. Your boots are on-site in five. Find that crash. Secure it. Kill anything breathing near it. The black box takes priority over people.",

	"Crash site confirmed. You are not the only one inbound. Secure it by any means. If the black box is in enemy hands—take it back or destroy it.",

	"Enemy scouts are sniffing around where our bird went down. Beat them there, silence them, and bring us what they missed.",

	"Midday crash, hostile airspace. Survivors may be hiding nearby. Eliminate hostiles and recover the flight log. Use of drones and mortars is authorized.",

	"At 1130, pilot broadcast engine failure. Then silence. Expect ambush, booby traps, or worse. Secure the site. Recover the black box or destroy it in place.",

	"Find the wreckage. Clear the site. Bring back the black box if it exists. If you find survivors, patch them up. If you find enemies, bury them.",

	"No questions asked. Secure the crash site, search the wreck, and if there's a black box—extract it. Friendly units 'Spade 1' and 'Spade 2' are on standby for support.",

	"The helo dropped fast and hard. Don't expect anyone to be breathing. Clear the site, retrieve what you can, and deny the enemy a single byte of data.",

	"Command doesn’t believe in coincidence. Find that wreck and confirm whether this was mechanical failure... or sabotage. Survivors optional. Intel essential.",

	"Enemy patrols are circling the impact zone. Get in, clean house, and sweep the wreckage. The black box may be buried, busted—or worse, in enemy hands.",

	"Pilot dumped altitude after reporting unknown contact. Track the crash trail, wipe out any interference, and recover the data log.",

	"Your mission: secure a crash site from enemy forces, eliminate resistance, and locate any trace of the aircraft’s black box. Expect contact on arrival.",

	"‘Sword 6’ was ferrying sensitive equipment when it went down. If the enemy gets the black box, we lose more than lives. Recover it or make sure no one ever does.",

	"One of ours is burning in the field. Scavs are already moving in. You’re there to make sure they don’t leave. Clean sweep. Recover what you can.",

	"The bird went down too clean. No wreck spread, no bodies. Something’s off. Investigate the site, neutralize threats, and secure or destroy the black box.",

	"Your boots are first on scene. Wreckage might still be hot. Secure the crash, check for survivors, and recover what remains. No second chances.",

	"The crash was messy. Fire burned half the hull. Recover any fragments of the black box. Anyone in your way—make them regret it.",

	"Rescue isn’t the goal. Recovery is. Secure the site, sweep for data, and eliminate resistance. If the black box is MIA, trace its path and retrieve it."
	
];


_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;