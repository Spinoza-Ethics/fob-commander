_missionType = "<t color='#FFA500'> Ammo Cache </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"Last night at 0215, Raven recon lost contact near a suspected ammo dump. High Command suspects a hidden supply site. Locate the cache, rig it, blow it sky high. Eliminate resistance. No salvage—just ashes.",

	"Aerial scans flagged unusual thermal spikes near an old comms relay. Might be a weapons stockpile. Move in, verify, and destroy all munitions. Expect company—callsign Vulture reports patrols in the area.",

	"At 0400, enemy trucks were spotted offloading crates. Intel says it's ordnance for an assault. You’re to find their stash and vaporize it. Clean up any opposition. Think of it as pest control with C4.",

	"Command’s bored. Make it interesting. Blow up their ammo. Shoot anyone dumb enough to guard it. No paperwork needed.",

	"Deserters from Spade Battalion say the enemy’s got an ammo dump nestled in the hills. Find it. Demo it. Anyone guarding it? Put them six feet under. Operation starts at 1300 sharp.",

	"At 1100, a drone pinged what looks like a cache—hidden under camo netting. Get in, confirm, and bring thermite. Expect scattered resistance. Eyes open. Not every rock is a rock.",

	"A convoy radioed out a distress call before going silent at 0700. Guess what? They stumbled onto an ammo site. Locate that cache. Erase it from the map. Sweep up any stragglers.",

	"Enemy broadcast chatter at dawn hinted at a fresh ammo cache drop. Trace the source. Sneak in or blast in, your call. Just leave nothing usable behind.",

	"Friendly drone Whiskey-4 tagged several heat signatures near a shackline. Suspected ammo depot. Deploy, identify, and incinerate the stockpile. Hostile presence is probable. Go loud if needed.",

	"Word is, enemy spec-ops hid munitions near the burned vehicles zone. You're to find the cache and reduce it to scrap. Kill anyone guarding it. Then ghost out before they regroup.",

	"Our comms boys decrypted traffic—something about 'Package Ember' delivered at 0900. It’s munitions. Find it. Burn it. Light up any hostiles. Make them regret speaking in code.",

	"Intel’s shaky but urgent. A source says the enemy planted a major ammo dump underground. You’ll locate and destroy it. Collapse the tunnels if needed. And silence the guards.",

	"Destroy enemy ammo. No backup. No time. Get in. Plant charges. Evacuate. Optional: survive.",

	"An intercepted call from enemy fireteam 'Ghost Talon' hints at a new supply cache. Your job? Find it. Turn it to fireworks. Expect light patrols or heavy traps—coin toss.",

	"Command wants a show. We found their bullets. Now we need explosions. Pinpoint the cache, wipe it out. Leave nothing but scorched dirt and brass casings.",

	"A unit calling themselves 'Iron Banner' guards something important—likely munitions. At 1430, you'll breach, sweep, and turn it to rubble. Keep it clean. No witnesses.",

	"An informant from Red Tide defected and revealed a stockpile of explosives stashed in an abandoned structure. Clear the guards and detonate the cache. Do it before dusk.",

	"Drones caught camo netting in a clearing. Under it? Ammo, probably. Bring enough charges. Go in silent, come out louder than hell.",

	"Enemy checkpoint went dark this morning. Recon believes they’re protecting a cache. Your orders: locate, confirm, and turn their fireworks into a crater.",

	"Enemy squad ‘Coal Ember’ offloaded weapons this morning. You’re tasked with reducing their stockpile to ash. Sweep the area. Eliminate guards. Send a message.",

	"A captured POW mentioned a ‘black site’ holding explosives. Sounds fake. Go prove it wrong. Confirm the cache and level it. If you meet resistance, return fire with interest.",

	"Enemy built their house on sand. Let’s blow it down. Find the ammo dump, ignite it, and clean out anything that breathes nearby. Operation Inferno begins at 1500.",

	"You're authorized to use drones for recon. Confirm enemy ammo stockpile and destroy it. Optional: test new drone payloads on whoever’s guarding it.",

	"Enemy hunters are sniffing around our forward scouts. Likely they’re guarding a cache nearby. Sweep, detonate, and leave nothing but scrap. Take ammo, leave bodies.",

	"Enemy squad Ember 3-5 is hiding munitions. Locate the cache and smoke them out. Secondary: test mortar fire on site. Field Credits available for overkill.",

	"A drone spotted a camouflaged tent cluster. Suspected ammo cache. You’ve got explosives. Use them. Kill anything that moves. Confirm burn after boom.",

	"High Command wants eyes off this op. You didn’t hear it from me, but there’s a stash of enemy arms ripe for demolition. Torch it. Pretend it was lightning.",

	"A convoy just rolled in from the north. Might be resupplying their ammo site. Ambush, destroy the stockpile, and engage any survivors. Make it look like an accident.",

	"Insurgents call it 'The Well'—a deep stash point for ammo. We call it a problem. Find it. Blow it up. Salt the earth for good measure.",

	"At 0615, artillery hit our supply line. Find their source. It starts with an ammo cache. Detonate it. No mercy. No survivors.",

	"Enemy supply officer was intercepted an hour ago. His map shows a stash. If it’s real, destroy it. If it’s bait, spring it and eliminate whoever laid the trap.",

	"Fireteam Delta-6 went MIA near suspected ammo storage. Assume they're dead. Finish their job—destroy the munitions and clear the zone of threats.",

	"Satellite feed shows increased foot traffic in Zone Echo. Probably resupply. Scope it, confirm munitions, and annihilate everything flammable.",

	"They don’t expect a strike at noon. Good. You’re heading in hot. Find the cache. Send it to hell. Bonus points if you do it with style.",

	"Burn their bullets. They’ve got plenty—too many. Cut their claws. Locate and demo the stash. Shoot anything guarding it. No arrests.",

	"Enemy FOB Bravo is quiet—too quiet. Likely hiding ammo. Breach, verify, demolish. Watch for traps or defenders playing dead.",

	"Our drones malfunctioned last night. Was it jamming or sabotage? Doesn’t matter. They were watching an ammo stash. You’ll go where they couldn’t. Bring C4.",

	"At 0940, a scout drone picked up a camouflaged container cluster. Looks like ammo. Confirm, neutralize, and withdraw. Any enemy left standing? Make sure they regret it.",

	"You’re the scalpel. They’re the tumor. Slice in, identify their munitions depot, and carve it out with explosives. Bonus XP for minimal damage to the surroundings.",

	"Enemy called in reinforcements an hour ago. They're prepping for something big. Blow up their supply cache before they do. Treat it like a race—one they can’t win.",

	"A local informant claims the enemy buries their stockpiles. You’ll find it. You’ll dig it up. Then you’ll erase it. Flamethrowers not included, but encouraged.",

	"Operations Command is nervous. You’re their nerve tonic. Locate the suspected munitions stockpile and reduce it to nothing. Eliminate all resistance. Calm restored.",

	"Enemy commander joked about his ‘bullet garden’. Time to prune it. Confirm presence of ammo, then burn it. Kill the gardener, too.",

	"Crates just offloaded by chopper. You know what that means—fresh cache. Find and explode. Bonus credits if you intercept the unloading crew.",

	"Enemy platoon was observed near an abandoned depot. Bet your boots there’s ammo. Sweep the site, identify the cache, and level it. Use drones to scout. Or not.",

	"You’ve got 6 hours before the enemy re-arms. Beat them to it. Locate their ammo reserve and annihilate it. If they resist, consider that permission to escalate.",

	"Enemy unit 'Gray Flame' is protecting something. Probably ammo. Blow it up. If they beg, shoot first, question never. Mission begins at 1300 sharp.",

	"They hid their bullets well. Let’s do worse—make sure they don’t even have a box left. Seek and destroy. Let them feel the consequences of overconfidence.",

	"A lone quad drone pinged a bunker full of crates. Marked ‘supplies’. You know what to do. Confirm, detonate, extract. Minimal drama—unless they start it.",

	"You’ve got free rein. There’s a cache somewhere in that zone. Use vehicles, drones, mortars—whatever earns you XP. But the objective is simple: no more bullets for them. Ever."

];


_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;