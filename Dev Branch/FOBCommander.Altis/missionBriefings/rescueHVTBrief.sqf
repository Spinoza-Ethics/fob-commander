_missionType = "<t color='#FFA500'> Rescue HVT </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 1200, a high-value civilian asset fled a militia purge. He's hiding, terrified. Locate him and ensure his safety. Command wants a sitrep the moment he's found. Don't screw this up—HQ’s watching.",
	
	"Dawn recon showed movement near the burnt convoy. Intel believes a civilian VIP escaped capture. Track him. If he dies, his intel dies with him. Eyes open, don’t fire unless fired upon.",
	
	"Command's pissed. A contact with valuable data was supposed to meet at 1100. No-show. Civilians said he ran into the woods. Find him. Alive. No excuses. Radio once secured.",
	
	"One of our informants went silent at 0900. Locals say uniformed men were hunting someone. Find him before they do. Do not let him die. He knows too much about Operation Sand Spire.",
	
	"Staghammer squad botched an evac last night. Their HVT bailed mid-flight. He’s in the AO—terrified, unarmed. You’re cleaning up the mess. Secure him. Notify HQ when done.",
	
	"The civilian you're after helped us decode enemy comms last year. He's on the run again. Enemy troops combing the zone. Locate and protect him. Radio in as soon as he's under control.",
	
	"A friendly asset named Ramil defected from the regime at 0400. He’s a civilian now, with intel that could cripple enemy logistics. He must survive. You must find him. Do not delay.",
	
	"Enemy patrols are thick, and our drone feeds picked up a single civilian fleeing toward the hills. That's your target. Make contact, keep him alive, and call it in.",
	
	"You’re not rescuing a hero today. The man you’re looking for’s a coward. But he’s our coward. Find him before the enemy does. He was last seen running barefoot into the woods.",
	
	"Midnight broadcast intercepted. One voice stood out—panicked, precise. A civilian in hiding. Locate. Secure. Survive. Do not let him fall into hostile hands. Comms silence until confirmed.",
	
	"Some ghost of a warlord turned informant is hiding in the AO. No one’s seen his face in a year. We want him found. Safe. Use drones if needed, and radio HQ the moment he breathes near you.",
	
	"Don’t kill anyone you don’t have to. This one’s surgical. The HVT was a fixer for the opposition, now he wants out. Enemy units will shoot first. Find him. Protect him. Call it in.",
	
	"A single civilian survivor was spotted limping through the hills at 1130. Intel IDs him as a crucial informant from Operation Cold Raven. Get to him. Get him safe.",
	
	"Bravo-6 saw a man being dragged into an alley at 0700. That man fits our HVT's description. He’s a key civilian. If he’s dead, you’re too late. Move fast. Confirm via radio once he's secured.",
	
	"Enemy forces executed several informants at dawn. One slipped the noose. He’s scared, armed, and running blind. Approach with caution. Keep him alive. Radio when he's in your custody.",
	
	"We’re tracking a civilian techie who cracked enemy drone networks last week. He went off-grid this morning. He must survive. Enemy troops are already in the area. Get moving.",
	
	"Two factions want the same man. He knows how to bring down the comms relay. Unfortunately, he’s a civilian and scared of everyone. Don’t spook him. Don’t let him die.",
	
	"Interrogation of enemy POWs revealed a civilian scientist defected last night. Hostiles are sweeping the valley. Find him. He’s the key to ending this fast. Notify when recovered.",
	
	"Our bird dropped him 6 clicks short due to AA fire. He’s alone, no gear, and surrounded. His name is Halim. He’s the package. He dies, you fail. Locate, shield, report.",
	
	"A rumor in the refugee camp says a man named Ferid survived the purge. That name’s tied to weapons intel we need. He’s your mission now. Find him. He must make it out.",
	
	"Whoever finds the asset first wins. That includes us and enemy QRF units. He’s a civilian holding onto documents that will burn their ops to the ground. Get to him first.",
	
	"A child reported a man hiding in the fields near the old bridge. Our analysts say he matches the civilian HVT’s build. Confirm identity, secure him, and don’t let him die.",
	
	"He’s a journalist—stupid, loud, and valuable. He embedded with a rebel squad and vanished. Last ping came from this AO. Find him. Alive. Report the second you make contact.",
	
	"Three hours ago, a drone spotted someone waving a blue cloth. That’s our guy’s signal. Get to him before anyone else does. He dies, and the whole net unravels.",
	
	"Don’t ask questions. Just find the man in the red scarf. He’s not to be touched by enemy hands. He’s our eyes and ears behind the curtain. Alive. Unharmed. Radio once safe.",
	
	"A transmission burst from a civilian phone showed up on our encrypted channel. That’s the target’s emergency code. He’s nearby. Scared. Find him. Defend him. Inform HQ.",
	
	"Word spread that the old doctor who used to patch us up is alive. If it’s true, we owe him a rescue. Find him. The enemy’s hunting him too. Bring him back breathing.",
	
	"The civ you’re after rigged half the enemy’s IEDs—now he wants a deal. Extraction is promised if he survives. Locate him. Keep him from dying. You know the drill.",
	
	"Enemy chatter spiked around 1000. They think a civilian spy is hiding in the town ruins. They’re right. Find him before they do. Get him out alive. Radio when done.",
	
	"She used to code their drones. Now she wants asylum. They’ll kill her for defecting. Find her. Protect her. Bring her home. No mistakes. Confirm recovery by radio.",
	
	"Someone just turned on an old sat phone with our encryption keys. It has to be the HVT. Pinpoint his location. Get there fast. Escort him back or cover until evac. Do not fail.",
	
	"Earlier this morning, gunfire was heard near the dry riverbed. Scouts believe a civilian escaped the ambush. It’s likely our guy. Secure him. Alive. Confirm the find.",
	
	"The civ’s a deserter’s brother. If he makes it out, we might convince more to flip. That’s leverage. He’s worth more alive than dead. Locate. Shield. Transmit confirmation.",
	
	"Our last contact with the asset was 36 hours ago. Since then—radio silence. We know he’s not dead. You’re going to fix this. Find him. Don’t let anything happen to him.",
	
	"Remember that bridge collapse two days ago? One man walked away. The man we need. He’s our target. Reach him, guard him, and send the signal when he’s found.",
	
	"Someone’s been feeding us high-value enemy positions. That someone is now compromised. Find him. If he’s captured, everything burns. Do what must be done. Preferably, save him.",
	
	"Reports say a civ matching our HVT was seen limping toward the treeline. Hostile patrols are closing in. Make contact, stabilize, and defend until further instruction.",
	
	"A friendly drone just lost visual on our target due to weather interference. He’s still somewhere in the grid. You have boots. Use them. He must live.",
	
	"The man you’re after once saved a NATO pilot. Now he needs saving. He’s stuck behind enemy lines. They’ll kill him slowly. Don’t let them.",
	
	"Enemy CO ‘Falcon-2’ wants the civ for questioning. That means torture. That means no intel for us. Find the civ first. Extract him from this madness.",
	
	"Listen carefully: the civilian you’re looking for was last seen hitching a ride in a donkey cart. Laugh later. Get him now. Don’t let him die. Confirm by radio when found.",
	
	"Three gunships swept through the sector last night. Civilian survivors fled in every direction. One of them is ours. It’s chaos. Find the right one.",
	
	"Our old contact in the hills just radioed in. Says he spotted the HVT hiding in a well. Enemy dogs are already sniffing around. Get there first.",
	
	"Local militia are executing informants at random. Our guy’s name came up. Find him before they do. If he’s already dead, you’re too late.",
	
	"The civ you’re after has a kill-switch transmitter that’ll blow a comms relay. He’s panicked and might activate it. Calm him down. Keep him breathing.",
	
	"The informant was a farmer, now he’s a ghost. Track his last known position. Use drones if needed. Don’t spook him. He’s vital.",
	
	"Captured enemy documents mention a ‘ghost civilian’ selling secrets. Our analysts think that’s the HVT. They’re hunting him. You’ll have to beat them to it.",
	
	"One of our operatives burned a safehouse to escape. A civilian fled with him. That civ is our prize. Locate, secure, and stay frosty.",
	
	"A drunk soldier blurted out to a bartender about a civ with coordinates tattooed on his arm. That might be our HVT. Investigate. Confirm. Keep him safe."

];



_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;