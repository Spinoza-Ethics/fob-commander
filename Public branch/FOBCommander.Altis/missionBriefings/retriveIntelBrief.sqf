_missionType = "<t color='#FFA500'> Retrieve Intel </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 1200, a patrol intercepted encrypted chatter near a supply route. Command suspects a data drop occurred. Locate the intel, avoid detection, and transmit findings. Avoid alerting the garrison—Falcon-2 barely made it out last week.",

	"INTEL OP: Disguised operatives reported potential war plans stored on a laptop. Infiltrate the AO quietly, recover data, and exfiltrate safely. Ghost-1 was KIA last time we tried. Keep it silent.",

	"Rumor has it a traitor from Hammer Brigade defected last night. He’s carrying blueprints in a suitcase. Track the signal, retrieve the case, and confirm defection via radio. No loud moves. Not yet.",

	"High Command wants answers. At 0430, a comms relay lit up near an enemy checkpoint. Get in, find what they’re transmitting, and vanish. Keep eyes off you. Phoenix-4 will be monitoring airwaves.",

	"Two nights ago, we lost contact with Recon Firefly. They mentioned finding 'something big.' Search the AO for their gear and any intel. No reinforcements are coming—don’t screw this up.",

	"An enemy officer defected at dawn, leaving behind sensitive documents near his former outpost. They're likely booby-trapped. Proceed silently, recover what you can, and signal extraction once clear.",

	"Enemy forces deployed a mobile ops van at 0600. It’s loaded with logistics data. Get in undetected, locate the terminal, and upload contents to HQ. We need that info before nightfall.",

	"A broken transmission hinted at Project Helix—a blacksite research op. One of their maps is in-country. Your task: find it, don't be seen, and radio home when it’s secure. Expect hidden patrols.",

	"Earlier today, Viper-3 spotted a convoy unloading locked crates. Contents unknown. Get eyes on them, locate any info nearby, and keep the noise to zero. You’ve got one chance.",

	"Don’t ask questions—just get in. A friendly mole marked a laptop with foreign code on it. It’s somewhere near the barracks. Infiltrate, retrieve, and get out clean. No kills unless necessary.",

	"We believe enemy Group Grayjack is planning something big. At 0300, a file was dropped via drone. Locate it near their staging ground. Stay quiet, stay alive. We need proof.",

	"Satellite pinged thermal signatures around an abandoned vehicle depot. Sources say there’s intel left behind. Sneak in, retrieve, and vanish before they know we were ever there.",

	"Operation Amber Flood ended last year, but reports say a suitcase with post-op data remains hidden. Head out, search quietly, and signal once you’ve secured it. Don’t trust the locals.",

	"At 0900, Phoenix-2 intercepted code fragments pointing to an asset dump. Your mission: find the mainframe or any physical backups. Maintain stealth—there are drones nearby.",

	"Enemy squadron Delta Veil is stockpiling something big. We want to know what. Enter quietly, identify the intel, and exfil before they realize. You’ll be watched the second you step in.",

	"A disgruntled officer may have left maps near a logistics hub. No one knows why. Don’t ask. Locate them, gather what you can, and call it in when safe. Avoid direct contact.",

	"This isn’t revenge. It’s recon. After that ambush at 1100, we need to know how they knew. Check their fallback zone for any data or equipment. Ghost protocol active—no gunfire.",

	"Last night, enemy frequency 'Black Echo' went dark. A transmitter case is still active. Find it, extract its logs, and ghost out. Don’t touch the nearby vehicles—they’re bait.",

	"Friendly informants smuggled footage of a bunker containing confidential plans. Locate the evidence, gather files, and leave no trace. Expect traitors and fakes.",

	"At 0500, command heard rumors of an enemy mutiny. One of them hid docs before disappearing. Infiltrate the suspected area, recover any found material, and remain unseen.",

	"A commander’s tablet was lost during last week's assault. It holds ops schedules. You’re tasked with recovering it. Enter with caution, avoid patrols, and signal extraction once secure.",

	"A rogue engineer left GPS logs for all enemy troop movements. They're stored on a terminal near the fuel station. Find it, copy the files, and vanish before they sweep the area.",

	"A map marked ‘OP Veil Cleaver’ surfaced on black market chatter. High-value. You need to locate and recover it. Avoid firefights—reinforcements will not come.",

	"Drone footage revealed a case buried shallow near the old comms post. It’s got something they want hidden. Sneak in, find it, get out. No trails. No glory.",

	"Enemy laptop discovered during a recon flyover. Inside a burnt truck. Your job? Get there, grab it, get gone. Assume the wreck is under watch.",

	"We don’t care where it came from—Command just wants what’s inside. A hard drive is pinging from a remote shed. Find it, don’t get caught, and don’t look curious.",

	"At 1030, Bravo-9 intercepted a courier but lost him. Last ping places the target’s satchel in hostile territory. Locate the bag, gather data, exfil silent.",

	"A strange comm pattern suggests a mobile server was relocated to a makeshift HQ. Check the tents, the crates—hell, the damn latrine. We need that data. Stay invisible.",

	"Operation Snow Throttle was supposedly shut down. But someone’s still running it. Track down the source material—likely maps or flash drives. They can’t see you.",

	"Three suitcases were offloaded by an unmarked chopper this morning. Only one matters. Get in, check contents fast, and avoid detection. Be a ghost, not a hero.",

	"ENCRYPTION OP: A hidden relay dish is suspected of transmitting troop movements. Locate its control device—likely a laptop—and get the logs. Drones are circling.",

	"We know they’re planning something. A handwritten playbook is said to be inside a ruined structure nearby. Enter quietly, recover it, and disappear.",

	"Midnight last night, Gunmetal-2 heard odd transmissions. A decoder unit is likely in range. Seek out electronics gear and retrieve anything readable.",

	"A mission went wrong three days ago. We lost Reaper-5 and an intel bag. Find that gear. You are not authorized to engage unless fired upon. In and out.",

	"Overheard radio traffic suggests a classified route map was stashed near the perimeter. Recover and radio when clear. Watch for motion sensors.",

	"INTEL SCRAPE: A forward enemy OP contains war plans. Expect tight security. Don’t break cover. We need the data, not another rescue mission.",

	"One of ours turned. They leaked operational data, and now it’s buried somewhere out there. Clean up the mess. Find the files, stay low, no loud moves.",

	"Defector from Iron Hand Regiment dropped a data slate before capture. It’s in enemy hands now. Slip in, secure the asset, and vanish into the dirt.",

	"Echo-Fox spotted high-ranking officers photographing something underground. Get in, find any stored visuals, and call it in. Assume traps are laid.",

	"A courier vehicle flipped at dawn. Inside: a case of unknown importance. Outside: very angry people. Get in, locate, get out. Stay out of sight.",

	"At 0600, enemy team Ravenline deployed jammers. Under them lies encrypted intel. Find the control rig, get the codes, and vanish. Eyes everywhere.",

	"Someone leaked coordinates on the darknet. The source must be local. Sweep the suspected hide and retrieve any tech. Do not engage unless discovered.",

	"Enemies deployed decoys last night. We need proof of who planned it. Sneak in, grab logs from a field PC, and disappear. This stays off the record.",

	"Two days ago, friendly recon spotted maps taped under a bench. You heard that right. Locate them, copy what you need, and exfil before dogs start barking.",

	"A laptop pinged our net at 0930. Last known position: a convoy checkpoint. Find it, verify contents, and slip away. Everyone’s watching today.",

	"Red Hand Division is hiding something in their makeshift camp. Rumors say it’s bio-lab schematics. Locate, retrieve, and keep a low profile. No alarms.",

	"Someone’s storing crypto-keys in the field. Why? No clue. All we know—it’s in a suitcase. Recover and exfiltrate. Act like you’ve done this before.",

	"Earlier this morning, Intercept Team Torchfall picked up chatter about an emergency evac. The cause? Sensitive docs. Go in, get them, and don’t be seen.",

	"A blueprint for drone jammers was lost near enemy lines. You’ll search the area quietly, recover it, and vanish. If they see you, we lose the edge.",

	"Confidential drop left near a farmhouse. Inside: strategic deployment routes. You must acquire the briefcase, transmit contents, and keep your presence unknown."

];


_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;