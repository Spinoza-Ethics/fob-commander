_missionType = "<t color='#FFA500'> Logistics </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"Enemy crates were sighted by drone at 1140—likely munitions. Secure and mark for pickup. Echo-6 lost visual shortly after. Disrupt any hostiles nearby. RTB once done.",

	"We received a garbled distress ping near a burned-out village. Crate signals followed. Tag anything useful. Expect stragglers and mines. No one’s coming to help.",

	"At 0300, Raider-4 spotted enemy supply boxes during a low flyby. Command wants them tagged for recovery. Engage if fired upon. In and out, quick and clean.",

	"A freelance recon drone caught footage of an unguarded enemy stash. Intel says it's legit. Mark for pickup, but don't trust the quiet. Stay sharp.",

	"Someone's been dumping enemy gear behind our lines—sabotage or smuggling? Sweep the area, secure anything you find. Nothing leaves without a tag.",

	"Bravo-2 intercepted comms suggesting hidden logistics in the area. Locate the supplies and tag them. If possible, knock out any guards quietly.",

	"Rumors of a rogue logistics convoy dumping gear off-grid proved true. At 0900, visuals confirmed crates. Tag all viable equipment. Avoid detection if possible.",

	"Command believes the enemy's prepping for an offensive. Crush their logistics. Tag and secure all supply caches. Leave nothing useful behind.",

	"At first light, SIGINT picked up chatter about emergency supply drops. Locate and mark anything you find. Enemy patrols expected. Disrupt if necessary.",

	"Delta-7 lost contact after reporting multiple ammo crates in the forest. Locate the supplies. If you find Delta-7… don't stop moving.",

	"Enemy logistics trail is leaking into neutral territory. We’re clearing house. Tag and secure any contraband. Use whatever force needed.",

	"At 1200, drone swarm picked up heat signatures by a ruined barn. Could be logistics. Sweep, secure, and tag. Civilians may be nearby—watch fire.",

	"Scouts found weapon crates stashed in a ravine last night. Tag them for pickup. Word is, the enemy doesn’t even know we know yet. Let’s keep it that way.",

	"A deserter tipped us off—crates hidden in enemy rear lines. No one knows how many. Grab what you can, tag 'em, and cause chaos on the way out.",

	"HQ spotted a resupply drone making unauthorized deliveries. Find the drop site. If you see supplies, mark 'em. If you see the drone, shoot it down.",

	"Enemy has started caching assets in civilian zones. We’re cleaning house. Locate, tag, and mark any crates. No engagement unless provoked.",

	"Crates. Woods. No guards. Intel says it's a trap. You go anyway. Tag what you can and keep moving. Don't play hero.",

	"At 0700, recon picked up logistics crates abandoned after a skirmish. Secure and tag them. If the enemy comes back, show them what regret feels like.",

	"Command wants eyes on all supply trails. Your task: tag anything you find for later recovery. Don't engage unless necessary. Operate quietly.",

	"Disrupt the enemy's war machine. Intel points to scattered supply dumps. Mark them for extraction. Shoot anyone who gets in the way.",

	"A downed enemy chopper dropped cargo mid-evac. Find it. Tag it. Make sure no one else gets it. We don’t share with people who shoot at us.",

	"One of our informants hinted at a hidden supply network. Verify. Tag supplies. Make it look like an accident if you’re seen.",

	"The last time someone went looking for crates here, they didn’t come back. Don’t be them. Secure and tag supplies. Minimal heroics.",

	"A wandering UAV spotted crates near the old fuel depot. Probably boobytrapped. You’re still going. Tag and extract. Stay low.",

	"Enemy convoy was ambushed last night. Gear scattered across the terrain. Secure and tag. Expect vultures—enemy or otherwise.",

	"FOB Echo was shelled this morning. Intel suggests logistics were moved nearby. Locate, tag, and make it hell for them.",

	"Strike Team Vulture tagged multiple logistics last week. Their trail went cold. Pick up where they left off. Mark all assets.",

	"A captured officer mentioned stashed crates near the riverbed. They won’t stay hidden forever. Find and mark them. Fast.",

	"Enemy's rerouting their supplies through unguarded zones. Tag every crate you find. If it's too quiet, assume you're already surrounded.",

	"Someone’s hoarding gear behind our lines. It’s not us. Secure the logistics, tag them, and let Command sort out who gets court-martialed.",

	"The enemy uses children to ferry ammo. Be careful. Secure supplies. Do not engage unarmed minors. Tag gear and disrupt operations.",

	"Late-night drone pass showed crates under camouflage netting. Locate and tag. If it's a trap, spring it with grenades.",

	"Our forward unit CallSign Shark-3 recovered partial coordinates. Search the zone, secure supplies, and mark them. Expect stiff resistance.",

	"You'll be ghosting in at noon. Enemy may still be unaware. Tag any supply drops you find. Avoid large-scale firefights.",

	"They tried to burn the evidence, but half the crates survived. Recover and tag the salvage. Watch for ambushes—smoke draws company.",

	"Enemy QRFs are thin today—perfect time to hit their rear lines. Locate and tag abandoned supplies. Bonus: wreck anything that looks important.",

	"At 1100, UAV Blackbird-2 detected logistical movements off main routes. Likely stash points. Secure, tag, and extract cleanly.",

	"Tag the crates, disrupt the network, and get out. You know the drill. No medals, no speeches—just another damn day in paradise.",

	"We found crates. Enemy wants them back. So do we. Beat them to it, mark the lot, and make some noise while you’re there.",

	"Enemy dumped some gear during retreat. It’s ours now. Tag everything useful. Don’t get sentimental—anything that moves, doesn’t.",

	"Logi caches lit up thermal last night. Probably real. Probably watched. Tag the boxes and don’t make friends.",

	"Command says their supply net's too clean. You’re the mop. Locate, mark, and undermine. Hit the rest on the way out.",

	"Enemy stashed crates in the wreck of an old outpost. Tag them before they come to reclaim. Let them walk into the blast radius if they do.",

	"Our drones spotted the enemy resupplying at noon sharp. Hit them hard, tag what’s left, and vanish before the dust settles.",

	"Intelligence suggests the enemy’s been burying supplies. Scan with drones, find them, tag 'em, and make sure they don't do it again.",

	"You'll find crates. Or they'll find you. Tag what you can. Scatter what you can’t. Don’t leave anything useful behind.",

	"Enemy logistics command is testing new routes. Interrupt their plans. Locate, tag, and if you’ve got time—salt the earth.",

	"A rogue tech dropped GPS points into our system. Could be bait. Could be gold. Either way, tag those boxes and stay frosty.",

	"The war machine stumbles when it’s hungry. Starve it. Locate and tag all logistics. Bonus if you wreck any fuel storage on the way.",

	"Enemy left supplies under guard of local militias. Expect untrained resistance. Engage if necessary. Tag and extract supplies cleanly.",

	"An encrypted drone sweep showed crates under tarp near farm ruins. Mark them fast. Avoid full engagement—Command wants stealth.",

	"You know what to do. Secure supplies. Tag them. Make them regret ever stockpiling so close to our AO. RTB once the job's done."

];




_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;