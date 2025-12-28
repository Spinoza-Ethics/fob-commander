_missionType = "<t color='#FFA500'> Outpost </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 1400, U.N.I.T. drones picked up thermal blooms in Sector 9. It’s likely an enemy outpost. Sweep, clear, and establish control using the comms beacon. Requisition any weapons or gear left behind—no questions asked.",

	"INTEL from Vulture-2 indicates a mobile logistics site set up last night. We move in fast, wipe it clean, and capture it before reinforcements dig in. Recover any explosives or equipment to bolster our loadouts.",

	"FOB Hammer took shellfire at dawn. Counterbattery triangulated origin—likely a hidden outpost. Your job is simple: locate, neutralize, and take it over. Salvage any gear you can carry. Don’t waste time.",

	"Bravo 5 found crates marked with Syndicate glyphs—enemy supply cache confirmed. Sweep the area, wipe hostiles, and take the outpost. Expect booby traps. Recover anything you can haul—ammo, explosives, maybe even lunch.",

	"High Command wants deniability. We found their outpost. Wipe it. No uniforms, no emblems, no rules. Claim the site with the beacon, grab what’s useful, and leave no witnesses.",

	"Eyes-only: A rogue recon team has gone dark near a suspected blacksite. You’re going in blind. Eliminate threats, secure the outpost, and transmit control. Salvage intel and supplies—we might not get a second pass.",

	"At 1130, drones saw enemy patrols moving munitions into a woodland clearing. Clear the area, claim it, and catalog all equipment left behind. Command wants answers—and grenades.",

	"Yesterday’s ceasefire was a lie. A forward element has set up an illegal outpost. You’ll find it, level it, and mark it for occupation. Take anything useful—no such thing as too many explosives.",

	"Intercepts suggest a weapons dump is being guarded in a makeshift depot. Push in, secure the site, and rig the comms beacon. Anything you find—guns, gear, lunchboxes—take it.",

	"Enemy squad 'Iron Pike' is holed up in a hidden comms nest. Eliminate them, secure the gear, and deploy the beacon. No one gets out. Use what you find, and don't waste field credits unless you have to.",

	"Friendly drone 'Gnat-6' was shot down near a suspected outpost. Find the crash, follow the smoke, clear the site, and salvage anything not bolted down. Plant the beacon once it’s secure.",

	"At noon, hostile frequency spiked near a known smuggling corridor. Intel suggests a temporary forward base. Locate it, neutralize resistance, and claim it with the beacon. Loot’s fair game.",

	"Don't get sentimental. The outpost you're hitting used to be ours—now it's painted enemy colors. Wipe them out, reclaim it with the beacon, and recover what they stole. No second chances.",

	"Drones lost signal over the valley—jammed. Means something’s down there. Probably an outpost. Secure it, clear it, activate beacon. Expect traps. Bring mortar support if you can afford it.",

	"Last week, enemy engineers built something underground. Our best guess? A staging post. Breach and sweep. Secure the area and rig the beacon. Scavenge anything that goes boom.",

	"Commander Frost wants results by sundown. Suspected weapons cache in hostile hands. Sweep, secure, and deploy the comms beacon. Any unmarked crates—crack 'em open.",

	"Enemy logistics dogtagged the region ‘Boxhole’—cute. Find their outpost, wipe resistance, deploy beacon, and search for stockpiles. If they left you a truck, consider it a gift.",

	"Rumors of a warlord storing prototype explosives in a backwater depot. Locate the site, silence opposition, and take it over. Beacon goes up once secure. Any found tech goes to R&D.",

	"At 0300, callsign Whiskey-Echo spotted movement near the ridge. Could be another supply site. Recon, engage, and secure. Plant the beacon. Loot is yours—field credits won’t carry themselves.",

	"An old comms tower came online again—enemy frequencies. They’re squatting in one of our abandoned posts. Evict them. Deploy the beacon and grab anything still functional.",

	"Desperate times—High Command needs a win. Push out, secure an outpost, and mark it with the comms beacon. Recover everything—ammo, food, batteries. Yes, batteries.",

	"Heavy movement on seismic sensors. They’re hiding something—probably explosives. Find their post, take it, tag it. Use whatever you find. We won’t ask where it came from.",

	"Intel from an intercepted courier confirms a resupply zone just outside our grid. Infiltrate, wipe it out, and activate the comms beacon. Weapons and equipment are top salvage priority.",

	"Stoic orders from command: engage, secure, transmit. Suspected outpost, minimal resistance, but recover everything. We lost a lot here last month. Don’t repeat history.",

	"Hostile squad 'Black Warden' is operating from a hidden firebase. Eliminate, secure, and establish control. Beacon goes up. Anything useful becomes BLUFOR property.",

	"We’ve got a ghost signal broadcasting encrypted codes. Source is likely an enemy outpost. Go in, clean sweep, claim it, and see what secrets are lying around. Especially the loud ones.",

	"Enemy drones flying low out of nowhere—follow the trail, and you’ll find the nest. Hit fast, hit hard, secure the site and mark it for us. Explosives and comms gear are gold.",

	"An old rival is back—unit 'Ash Knife' was sighted. They’re dug in. Wipe them out, capture the site, deploy the beacon, and recover anything left behind. Revenge is field-issued today.",

	"Whispers of a black-market weapons deal led us to a forest clearing. Sweep the site, take control, and raise the comms beacon. Check under tarps, in crates, and behind lies.",

	"Enemy scouts vanished in this sector. Likely a field bunker’s gone live. Find it, neutralize occupants, and capture the area. Beacon up, and check for munitions and comms gear.",

	"We’re bleeding resources. There’s an enemy outpost nearby—somewhere. Find it, clear it, mark it. Anything useful is to be brought back or used in the field. No excuses.",

	"Interference from a jamming tower led us here. They’ve built something nasty. Breach, purge, and establish our claim with a beacon. Grab any electronics or gear they left behind.",

	"Enemy techs set up a forward repair bay. No doubt there's loot worth risking. Clear them out, claim it, and salvage everything that isn’t nailed down. Time’s not your friend today.",

	"The desert hides many things—one of them is an enemy cache. Confirm presence, take control, and beacon it. Priority on weapons and explosives. Expect nothing but dust and bullets.",

	"Someone’s trying to go dark—unknown outpost with low EM signature. Dangerous. You’ll make contact, sweep, secure, and deploy the beacon. If there’s anything worth stealing, do so.",

	"Hostile comms traffic increased at 0940. Suspect mobile base in operation. Secure it. Plant beacon. Recover any drones, parts, or high-value equipment. Priority alpha.",

	"You’ll find a lightly-defended supply depot. Take it before they reinforce. Once secure, set the beacon. Salvage munitions, food, and vehicle parts. Anything we don’t have to buy helps.",

	"At 1200, allied satellite IR found warm signatures in the trees. Go check it out. If it’s a nest, clear it. Tag it. Loot it. Shoot anyone who blinks wrong.",

	"Enemy commandos were spotted dragging crates at dawn. Intercept, engage, and recover the area. Deploy the beacon and collect anything that explodes or transmits.",

	"One of our own turned—Unit Aegis went AWOL last week. They’re holed up in an old relay post. Take it back. Deploy the beacon. Grab anything they didn’t burn.",

	"INTEL from an enemy defector points to a supply hub. Could be booby-trapped. Proceed with caution. Clear the site, take it over, and recover anything field-usable.",

	"A series of tremors suggest underground storage nearby. Confirm the location, neutralize any guards, and beacon the site. Watch for unstable ordinance.",

	"An allied squad was ambushed near a suspected outpost. They’re presumed KIA. Clear the site, beacon it, and recover any equipment left behind. Let their gear serve again.",

	"An old war relic has been reoccupied—satellite heatmaps confirm enemy activity. Clear the compound, deploy the beacon, and scavenge whatever’s still ticking.",

	"Enemy field commander was heard bragging about a 'hidden jewel'. Hunt it down, purge resistance, and mark the zone. See if their treasure helps our war chest.",

	"Mortar teams were spotted here yesterday. They’re likely dug in now. Neutralize them, take the zone, and salvage any artillery shells or guidance kits.",

	"Command wants new ground. You’re planting a flag. Find the outpost, eliminate threats, set the beacon, and stockpile all gear. The drones will thank you.",

	"Radar blackout at 0530 suggests jammer presence. Find the source, clear it out, activate the beacon, and bring back any jamming tech. HQ wants to reverse-engineer it.",

	"New orders: Field test scavenged drones. Secure an enemy post, capture it with the beacon, and check for drones or drone components. If it hovers, it’s ours.",

	"Expect nothing but bad weather and worse odds. Your objective remains: locate the outpost, clear it, mark it, and gather gear. This is war. Make it ours."
];





_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;