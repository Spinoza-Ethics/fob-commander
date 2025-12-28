_missionType = "<t color='#FFA500'> Vehicle Wreck </t><br/><br/>";
_missionTitle = "<t color='#0066FF'>--- MISSION BRIEFING ---</t><br/>";

private _briefMessages = [

	"At 0400, a supply convoy was ambushed. Drone footage confirms wreckage nearby. Find the lead truck, identify survivors or KIA from Echo-3, and report via radio. Enemy patrols may still linger. Proceed with caution. Keep it quiet if you can.",

	"Our recon bird spotted a plume of smoke at 0930—likely from a downed recon vehicle. HQ wants it tagged and the crew accounted for. Friendly callsign was Raven-1. Hostiles may be scavenging. Eyes open.",

	"Somewhere out there is the husk of Vulture-2, a recon unit shot down at dawn. Your job is simple: locate the wreck, ID any friendly remains, and radio it in. Command wants answers, not excuses.",

	"A transmission from Foxtrot-6 cut off mid-sentence last night at 0200. Wreckage was likely. Find the vehicle, tag any bodies—living or not—and call it in. No heroics. Just closure.",

	"Desperation reeks from what’s left of Delta-4. They vanished at 0500—nothing but static. HQ’s betting the wreck isn’t far. Tag their last stand and call it in. The war doesn't pause for ghosts.",

	"War chews us up and forgets our names. Not this time. Locate Alpha-7's downed APC, tag what remains of them, and report it. They earned that much.",

	"Bravo-9 sent their last ping at 1122. You're to locate their burnt-out ride, tag the crew, and report back. Rumors say hostiles execute survivors. Let’s prove them wrong—or right.",

	"Crash at 0700. Callsign: Lynx-2. You’ll find the wreck, mark any friendlies, and radio HQ. Avoid direct contact. Their fate may already be sealed.",

	"A gun-truck from Charlie-5 veered off comms during a dust storm. Last seen heading north. Find it. Tag it. Speak their names into the net.",

	"Command wants confirmation on a vehicle loss logged 3 days ago. You’ll sweep the grid, tag remains, and send the coordinates. Don’t expect glory. Just wreckage and silence.",

	"Viper-3 was last heard screaming over the net. Their IFV’s burning shell might still be warm. Locate the wreck, mark the crew, and call it in. Maybe someone lived.",

	"A drone spotted twisted metal near the dry creekbed. Could be Hammer-1. Find the site, tag the dead, and report in. Don't get sentimental. They knew the risks.",

	"At noon yesterday, a mortar carrier lost contact. It’s your mess now. Find the vehicle, ID what’s left of the team, and check for possible survivors.",

	"Rescue’s out. Recovery’s in. Locate Dragoon-4’s downed recon truck, tag their bodies or biosigns, and relay it. Command won't risk more lives for ghosts.",

	"Intelligence shows a smoking ruin south of the last known position of Kilo-7. Confirm if it's friendly, tag remains, and call it. Expect hostiles salvaging tech.",

	"A lost drone spotted a wrecked vehicle in sector 4. Could be Nomad-6. Find the wreck, tag friendly units alive or KIA, and report in. Don’t let them disappear.",

	"We need to know if Titan-2 made it out. Last seen evading contact 48 hours ago. Locate their wreckage, scan for friendlies, and notify HQ.",

	"A rumor circulates of captured friendlies near a destroyed light truck. Your task is to find it, tag the scene, and call it in. Don't become the next rumor.",

	"One of ours went dark mid-patrol. Command suspects ambush. Wreck must be tagged, crew identified, and report filed. Forget vengeance—focus on closure.",

	"A recon bike from Saber-5 went missing after skirmish reports. We need confirmation. Locate the wreckage, tag the rider, and send coordinates.",

	"Lost contact with friendly quad at 0615. Might be sabotage. Find it, check for survivors, tag all remains. HQ wants it logged. No room for loose ends.",

	"Helios-3, a recon drone team, lost link 30 mins ago. Last ping placed them near a ridge. Find the wreck, tag personnel, and call it in. Expect resistance.",

	"Someone's shooting at our convoys again. Last hit was on a medevac truck. Locate the vehicle, tag medics and patients, and radio the loss. Brutal work.",

	"Drone feed picked up smoke at 0830. Could be Wolf-4. Go there, confirm the wreck, tag the friendlies, and report. Every second counts for potential survivors.",

	"A crash site was marked by civs. Might be friendly. HQ wants it checked, tagged, and reported before hostiles strip it clean. Move quick. Move smart.",

	"An old wreck might still carry intelligence tags. Search it, mark any friendly bodies, and get on the horn. It could be nothing—or everything.",

	"A rumor from last week claimed a friendly convoy was torched in the hills. HQ wants confirmation. Go there, find any tags, and call it in.",

	"Recovered enemy comms mentioned a 'burning steel box with men inside'. Could be ours. Investigate, tag the site, and report.",

	"Flash floods exposed a wreck yesterday. Might be Sentinel-1. Find it, tag any remains, and call it in. Nothing noble—just duty.",

	"At 1000, drone footage showed a convoy’s last stand. One vehicle remains unaccounted. Find it, tag friendlies, and relay the loss.",

	"A patrol vanished near a suspected minefield. We suspect their vehicle triggered it. Confirm the site, tag the remains, and notify HQ.",

	"Fury-3 reported engine trouble before vanishing off the net. Locate the downed APC, tag survivors or remains, and call it in. Expect ambushes.",

	"Multiple friendlies from Lance-4 were last seen mounting a retreat. Their wreck might still be smoking. Locate and log it.",

	"One of our drones spotted vultures circling something metallic. HQ suspects friendly wreckage. Investigate, tag anyone, and report it up the chain.",

	"Thunder-2’s recon bike was last seen speeding toward enemy lines. Find it, tag it, and pray he died fast. HQ wants records clean.",

	"The enemy’s got a twisted sense of humor. They left dog tags on display near a ruined Humvee. Might be Bravo-7. Confirm, tag, and radio.",

	"Rain washed away tracks near a supposed crash site. No confirmation yet. Go there, verify the wreck, tag any friendlies, and notify command.",

	"At 0300, enemy jammers lit up near a patrol zone. Shortly after, Tiger-1 vanished. Locate their wreck, ID the team, and send it up the wire.",

	"You’re looking for the bones of Ghost-6’s last run. The vehicle's likely half-buried. Dig it up, mark the bodies, and radio the facts.",

	"A drone went down scouting a ridge. The crew had no escort. Confirm their fate. Tag their site. HQ wants a list of the lost.",

	"Our men die screaming in the dark and we send you to turn screams into paperwork. Find the wreck. Tag the fallen. Call it in. War goes on.",

	"You’ve got a dusty trail, a dead radio, and Command breathing down your neck. Find the wreck, mark who’s dead or alive, and report. Don’t dawdle.",

	"The enemy left traps near the last known location of a lost recon team. Find the wreck, tag any bodies, and call it in without becoming one of them.",

	"An old recon truck was found flipped near enemy lines. Could be ours. Your job is to ID it, tag remains, and relay back. The dead can’t speak, but we can.",

	"Drone footage suggests a vehicle exploded last night near a dry gulch. Command suspects friendly. Confirm, tag, and report before scavengers do.",

	"At 1200, a friendly transport left the AO and never returned. Last signal pinged from a ravine. You’re to investigate, tag the site, and radio status.",

	"The last photo from a scout’s helmet cam showed smoke. Nothing since. HQ believes the wreck is within 2 clicks. Find it. Mark it. Call it.",

	"A supply carrier never reached the FOB. Route was clean—then radio silence. Drone spotted something burning nearby. Tag the site. Radio it in.",

	"Echo-7’s encrypted ping came through at 0613. It’s the only thing left of them. You’ll find the vehicle, tag all assets and bodies, and file the report.",

	"A convoy left a trail of fire across the field. HQ says only one truck’s missing. Your job is to find it, tag the remains, and confirm the loss."
	
];



_randombriefMessage = selectRandom _briefMessages;
private _hintText = parseText (_missionType + _missionTitle + "<br/>" + _randombriefMessage);
hint _hintText;