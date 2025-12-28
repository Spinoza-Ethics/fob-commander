_missionType = "<t color='#FFA500'> Eliminate HVT </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 0600, recon drone spotted enemy Colonel Arsin at a forward CP. Find him, confirm the kill. If his bodyguards resist, eliminate them. No room for error—Command wants his head, not excuses.",

	"Intel decrypted last night suggests a high-ranking officer will inspect a weapons cache today. Confirm the kill—don't let him leave alive. If things go loud, clean house.",

	"Seraph 4 intercepted enemy comms at 1100. They're expecting a visit from 'The Hawk'—a senior commander. Find and silence him. A clean kill earns extra Field Credits.",

	"Eyes-only: HVT 'Kestrel' is rumored to be touring frontline units. Terminate with prejudice. Optional: sweep the area of remaining forces. You're cleared hot.",

	"Friendly patrol was ambushed at dawn—only survivor said 'an officer gave the order in person'. Find that bastard and end him. This one’s personal.",

	"At 0930, satellite pinged a signal tied to Lt. Col. Voren. Locate, eliminate, and verify identity. Any other hostiles? Do what you do best.",

	"Word is an enemy VIP is inspecting defenses. You’ll know him when you see him—he’s not subtle. Take him out. If you must mow down a few guards, so be it.",

	"Drone recon spotted a commander dismounting a black SUV at 1130. Discreet kill preferred. Don’t get flashy—Command wants deniability.",

	"Rumor says enemy brass is 'observing morale' near our perimeter. Give him a reason to reconsider. Eliminate and confirm the kill.",

	"XO of Wolfpack 2 was captured at 0300. Their last transmission? 'Officer's here, watching.' Find and kill that officer. Leave the rest in pieces if needed.",

	"At noon sharp, enemy General Serik attends a 'discipline parade'. You’re invited too. Crash it—kill him and anyone who salutes wrong.",

	"Interference in our drone net started around 0800. Suspected jammer escorted by command staff. Kill the officer and destroy the source if visible.",

	"At 1000, encrypted chatter suggests a regimental briefing is underway. Target their lead officer. Drop him before he can finish his speech.",

	"FOB Thistle went dark at 0440. Last transmission mentioned 'hostile inspection team'. Investigate, confirm kill on commanding officer.",

	"At 1105, HALO ops spotted an enemy captain arguing with guards near an antenna site. End his career—and his life. Confirm the body.",

	"Last week, they shelled a village for fun. The commander behind it sleeps nearby. Wake him—then silence him forever.",

	"An enemy officer is touring defensive lines disguised as a grunt. Spot him, drop him, tag the corpse. Simple job if you're clever.",

	"Reports of a 'cleaner' overseeing prisoner executions surfaced at 0730. He’s still there. Put a round in him. Confirm the corpse.",

	"Enemy convoy rolls in daily for 'inspections'. One officer always barks orders. Today, make it his last ride.",

	"At 1140, an enemy major enters a logistics hub to 'motivate' workers. Motivate him into an early grave.",

	"Command tracked an elite advisor arriving at a field HQ. Quietly locate and eliminate. No heroics—just results.",

	"Enemy Colonel Raskov hosts a 'loyalty trial' today at noon. Make it his trial by fire. Confirm identity before exfil.",

	"Audio logs from our last drone sweep mention 'Red Saber'—a ruthless officer. Eliminate and verify. You’ll know him. He’s the one shouting.",

	"Strike Team Vega missed their extraction at 0500. Last comms: 'Officer... he’s here…' Finish what they started. Confirm it’s him.",

	"A decorated enemy officer brags on radio channels every morning. End his broadcasts permanently. Confirm kill.",

	"FOB Sentinel intercepted a memo: high command visiting frontline. Your mission? Make it their last inspection.",

	"Enemy morale's up—likely because a respected commander’s on site. Remove him and let morale crash with him.",

	"At 0700, enemy units moved with discipline—someone new’s in charge. Kill that someone. Confirm with visuals.",

	"Yesterday at 1430, our recon spotted medals on a commander’s chest. Too shiny for the field. Eliminate and strip him down.",

	"Interrogation of POWs revealed 'Brigadier Vos' is feared even by his own. Show them fear dies too. Confirm the body.",

	"Enemy signal boost came online near a bunker. Find the officer guarding it. Eliminate. Confirm identity.",

	"Local deserters say 'a man in black beret' gives summary executions. End his sentence. Confirm the corpse.",

	"A traitor sold us out last week. We traced it to a colonel's team. Wipe him out—leave no doubt. Confirm it's him.",

	"Heavy armor convoys are well-coordinated—too well. Suspect officer nearby. Find and eliminate him. Confirm ID.",

	"Drone footage at 0900 caught a man barking orders by a crashed truck. Officer. Probably angry. Make him quiet. Confirm kill.",

	"Enemy launched psyops via loudspeakers this morning. Voiceprint matches their propaganda chief. Silence him forever.",

	"An officer was seen punishing troops for 'cowardice'. Show him what courage looks like. In a scope. Confirm the body.",

	"Enemy patrols halted unexpectedly at 1100. Could mean a command visit. Intercept and assassinate. Confirm ID.",

	"Our drone footage glitched near bunker sites. Suspected officer-led EW team. Kill the commander. Confirm.",

	"Aide to an enemy general landed by helo at 0600. He’s calling shots until the general returns. Cancel the meeting permanently.",

	"Yesterday’s recon shows a smug-looking man surrounded by files and flak jackets. Probably the officer. Find and unmake him.",

	"Local resistance says 'one-eyed major' is camped nearby. Says he tortures prisoners. Find and kill him. Confirm by the eyepatch.",

	"Enemy’s unit cohesion has improved—suggests field leadership nearby. Strip them of it. Eliminate and confirm officer presence.",

	"At 0730, two APCs pulled up to a ridge. Officer dismounted. Kill him. Blow the rest if you feel like it. Confirm kill first.",

	"Calls to enemy units went unanswered at 1000—possible field commander issuing blackout orders. Break his silence permanently.",

	"Enemy captain was heard screaming at troops last night. Passion’s nice. Killing him’s better. Confirm his death.",

	"A heavyset officer was seen inspecting trenches at 1145. Probably too slow to run. Put him down. Confirm the identity post-mortem.",

	"Enemy morale is rising—rumor says they brought in a 'hero' to inspire. Remind them heroes bleed too. Confirm it's him.",

	"A lone officer was seen riding in an unmarked jeep. Might be inspecting. Might be running. Stop him either way. Confirm the body.",

	"A field-grade commander ordered a retaliatory strike last week. We traced the orders. Now you trace him. Kill and confirm."

];



_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;