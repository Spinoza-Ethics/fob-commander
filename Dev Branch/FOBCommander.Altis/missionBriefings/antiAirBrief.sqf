_missionType = "<t color='#FFA500'> Anti-Air </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"Last night at 0200, a friendly recon drone caught glimpses of an enemy AA vehicle rolling through Sector Echo. Locate and neutralize it before our helos start falling like flies. Hostile QRFs are already sweeping nearby. Make it fast, make it clean.",

	"Command has picked up radar spikes north of our AO. Possible SA-6 site. We want it dead by sundown. Expect patrols. Shoot first, verify later.",

	"Intel suggests a hostile radar dish was erected at dawn. Disrupt their eyes before they spot our convoys. Expect engineers and guards nearby.",

	"We've lost two drones since 0700. It's no coincidence. The enemy's hiding AA teeth. Find the source. Silence it. Leave no survivors.",

	"Optimistic news: their AA net is sloppy. Realistic task: exploit that. Disable their radar gear and toast any resistance. Our birds want skies back by 1400.",

	"AA hunter teams are active. Warlord-2 got clipped at noon. Find their battery. End it. Remember what they did to our friends in Sector Zulu.",

	"Saboteurs from Reaper Cell are in your AO. They're hunting enemy radar vehicles. Support them if seen, but your task is clear—shut down the air threat.",

	"Enemy engineers are setting up a mobile SAM site—likely disguised as a logistics convoy. Kill the crew, trash the tech. Do it before sundown.",

	"At 0330, one of our UAVs picked up a suspicious heat signature. Possible AA vehicle, likely camouflaged. Investigate and destroy on confirmation.",

	"High noon, skies are clear—too clear. Enemy must be confident. Time to change that. Jam their radar, torch their launchers, and keep moving.",

	"Enemy vultures have been circling our FOBs unchecked. This changes now. Locate their AA platforms and knock them out before nightfall.",

	"Detached orders for a detached world: find the emitter, shut it down, kill anyone nearby. No ceremony. No survivors.",

	"A traveling SAM convoy passed through a civilian sector two hours ago. They’re getting bold. Teach them humility. No friendlies nearby, no excuses.",

	"Enemy AA net is disrupting drone resupply. HQ says enough. We say hell yes. Track their signals, torch the gear, and scatter their ashes.",

	"Mortar teams reported strange interference at 0900. Suspected jamming linked to enemy radar. Confirm presence and demolish the cause.",

	"They shot down a medevac bird. No more mercy. Find that SAM. Wipe the crew, burn the launcher. Make an example.",

	"We have a short window before their radar sweeps restart. Move fast, find the jammer or launcher, neutralize. Your time starts now.",

	"A rumor claims enemy forces recovered old NATO AA hardware. Prove it wrong—or right—and put it six feet under regardless.",

	"Defector from the 41st Motor Brigade says their battery’s low on fuel. Intercept and destroy before they resupply. They won’t be idle long.",

	"Drone feed shows camo netting over a suspicious ridge. SAMs love the shade. Find it, light it up, and don’t stick around.",

	"Enemy helos are grounded for now. That changes if their AA goes mobile. You know what to do—cripple their defenses before they rebuild.",

	"A stolen NATO radar dish is active somewhere in your AO. Consider it treason. Find the traitors, end their lease on life.",

	"Phoenix Squad spotted AA gear being offloaded near a dry riverbed. Eyes on the prize. Hit hard. Evade fast. Don’t die trying.",

	"A dark joke made rounds this morning: ‘Our pilots are safer dead than flying.’ Make it untrue. Find the SAMs and purge them.",

	"A sat phone intercepted chatter about 'sky shields' going up. You’ll make sure they fall. Target confirmed enemy AA assets and exterminate.",

	"Enemy recon drones are circling our resupply lines. Their AA net’s the anchor. Cut the line. Destroy the gear. Their drones will follow.",

	"A shadow convoy slipped through last night. High chance it’s AA. Find the ghosts and bury them. No funerals.",

	"Midday radio chatter from enemy frequency hinted at ‘airstrike bait’. Sounds like a trap. Spring it anyway. Remove the threat.",

	"Pilot down. Our chopper was hit by unknown AA south of grid black zone. Secure the wreck, neutralize the launcher, and recover intel if found.",

	"FOB Avalanche took fire from unseen AA during drone launch. Find and dismantle their hidden launcher before they relocate.",

	"Enemy’s betting on new radar to dominate the skies. Time to call their bluff. Wipe their tech, clear their crews, fly free again.",

	"A rogue AA vehicle left the main battalion. Possibly bait, possibly treasure. Confirm and engage. If it shoots, bury it.",

	"Our gunships will strike in three hours. Clear the AA so they can enter safely. Every launcher you miss is one body bag we need to fill.",

	"A downed drone suggests strong radar coverage in the AO. Don't just poke the bear. Break its legs. Strike now while they’re overconfident.",

	"Enemy is reportedly hiding mobile AA among civilian transports. We don’t like it, but we’re still clearing them. Check your fire. Then burn it all.",

	"A militia unit may have acquired stolen AA gear. They don’t know how to use it yet. Teach them why that’s not enough.",

	"Enemy is broadcasting fake IFF signals to mask AA emplacements. Follow the interference. Find their source. Cut the signal. Clean up.",

	"A downed recon drone captured glimpses of an unmarked launcher. Find that ghost and exorcise it before it takes more from us.",

	"Hostile Commander Tyrel personally deployed a radar vehicle into your sector. Capture or kill him. The radar's just the bonus.",

	"Our skies are dead. They made them that way. We’ll revive them with fire. Find whatever’s jamming our wings and turn it to ash.",

	"A young corporal swore he saw a 'turret with fangs' in the east. Sounds like a mobile AA. Humor him. Confirm or deny—with bullets.",

	"Radar dishes aren’t pets, yet they keep feeding theirs. Ruin their meal. Kill the operators, destroy the site. Then vanish.",

	"A convoy labeled 'weather team' entered your AO. No such team exists. Sounds like radar. Investigate, dismantle, and disappear.",

	"An old enemy airbase may have been rearmed. Command smells AA. You’ll sniff it out, blow it up, and make sure it’s never used again.",

	"Friendly air patrol was nearly shot down. The launch was traced to your sector. Find that launcher. Ensure it never speaks again.",

	"We lost radio contact with Recon CallSign 'Bishop'. Last known was near suspected radar. Confirm fate, eliminate threat, extract logbook.",

	"Drone logs captured faint radar pings from a nearby valley. Could be AA, could be decoy. You’ll go see. If it breathes, kill it.",

	"A hidden jammer is blinding our drones. Find the bastard. Rip its cords out. Dismantle their eyes and ears before they use them on us.",

	"A decommissioned AA site might be active again. If they’re resurrecting old monsters, you’ll need to put them down—hard.",

	"Command authorizes full field credit bonus for confirmed AA kills today. Consider it open season. Bring home scrap and corpses.",

	"A single hostile operator has been deploying radar decoys. He’s smart. Be smarter. Find the real thing, torch the bait, end the game."

];



_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;