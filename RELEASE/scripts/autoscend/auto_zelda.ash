script "auto_zelda.ash"

boolean in_zelda()
{
	return my_path() == "Path of the Plumber";
}

boolean zelda_initializeSettings()
{
	if(in_zelda())
	{
		set_property("auto_getBeehive", true);
		set_property("auto_getStarKey", true);
		set_property("auto_holeinthesky", true);
		set_property("auto_wandOfNagamar", false);
		set_property("auto_useCubeling", true);
		// TODO: Remove when quest handling is correct.
		set_property("auto_paranoia", 1);
	}
	return false;
}

boolean zelda_haveHammer()
{
	return possessEquipment($item[hammer]) || possessEquipment($item[heavy hammer]);
}

boolean zelda_haveFlower()
{
	return possessEquipment($item[[10462]fire flower]) || possessEquipment($item[bonfire flower]);
}

boolean zelda_equippedFlower()
{
	return equipped_item($slot[weapon]) == $item[[10462]fire flower]
		|| equipped_item($slot[weapon]) == $item[bonfire flower];
}

int zelda_numBadgesBought()
{
	return (have_skill($skill[Hammer Throw]).to_int() +
		have_skill($skill[Ultra Smash]).to_int() +
		have_skill($skill[Juggle Fireballs]).to_int() +
		have_skill($skill[Fireball Barrage]).to_int() +
		have_skill($skill[Spin Jump]).to_int() +
		have_skill($skill[Multi-Bounce]).to_int() +
		have_skill($skill[Power Plus]).to_int() +
		have_skill($skill[Secret Eye]).to_int() +
		have_skill($skill[Lucky Buckle]).to_int() +
		have_skill($skill[Rainbow Shield]).to_int() +
		have_skill($skill[Lucky Pin]).to_int() +
		have_skill($skill[Lucky Brooch]).to_int() +
		have_skill($skill[Lucky Insignia]).to_int() +
		have_skill($skill[Health Symbol]).to_int());
}


boolean zelda_buySkill(skill sk)
{
	if (have_skill(sk)) return false;

	int cost = 50 + 25 * zelda_numBadgesBought();
	if (item_amount($item[coin]) < cost) return false;

	visit_url("place.php?whichplace=mario&action=mush_badgeshop");

	int idx = 0;
	switch(sk)
	{
		case $skill[Hammer Throw]: idx=1; break;
		case $skill[Ultra Smash]: idx=2; break;
		case $skill[Juggle Fireballs]: idx=3; break;
		case $skill[Fireball Barrage]: idx=4; break;
		case $skill[Spin Jump]: idx=5; break;
		case $skill[Multi-Bounce]: idx=6; break;
		case $skill[Power Plus]: idx=7; break;
		case $skill[Secret Eye]: idx=8; break;
		case $skill[Lucky Buckle]: idx=9; break;
		case $skill[Rainbow Shield]: idx=10; break;
		case $skill[Lucky Pin]: idx=11; break;
		case $skill[Lucky Brooch]: idx=12; break;
		case $skill[Lucky Insignia]: idx=13; break;
		case $skill[Health Symbol]: idx=14; break;
		default: abort("Unrecognized skill");
	}

	run_choice(idx);

	return have_skill(sk);
}

boolean zelda_buyEquipment(item it)
{
	// Seems like the coinmaster Mafia handling is not quite there? TODO
	if (possessEquipment(it)) return false;

	int coins = item_amount($item[coin]);

	switch(it){
		case $item[hammer]:
			if (coins < 20) return false;
			retrieve_item(1, it);
			break;
		case $item[heavy hammer]:
			if (coins < 300) return false;
			retrieve_item(1, it);
			break;
		case $item[[10462]fire flower]:
			if (coins < 20) return false;
			retrieve_item(1, it);
			break;
		case $item[bonfire flower]:
			if (coins < 300) return false;
			retrieve_item(1, it);
			break;
		case $item[fancy boots]:
			if (coins < 300) return false;
			retrieve_item(1, it);
			break;
	}
	return true;
}

boolean zelda_buyStuff()
{
	if (!have_skill($skill[Lucky Buckle]))
	{
		zelda_buySkill($skill[Lucky Buckle]);
	}
	else if (!have_skill($skill[Secret Eye]))
	{
		zelda_buySkill($skill[Secret Eye]);
	}
	else if (!have_skill($skill[Multi-Bounce]))
	{
		zelda_buySkill($skill[Multi-Bounce]);
	}
	else if (!possessEquipment($item[fancy boots]))
	{
		retrieve_item(1, $item[fancy boots]);
	}
	else if (!have_skill($skill[Lucky Pin]))
	{
		zelda_buySkill($skill[Lucky Pin]);
	}
	else if (!have_skill($skill[Lucky Brooch]))
	{
		zelda_buySkill($skill[Lucky Brooch]);
	}
	else if (!have_skill($skill[Lucky Insignia]))
	{
		zelda_buySkill($skill[Lucky Insignia]);
	}

	return false;
}

int zelda_ppCost(skill sk)
{
	switch(sk)
	{
		case $skill[Hammer Throw]:
		case $skill[Juggle Fireballs]:
		case $skill[Spin Jump]:
			return 1;
		case $skill[Ultra Smash]:
		case $skill[Fireball Barrage]:
		case $skill[Multi-Bounce]:
			return 2;
		default:
			return 0;
	}
}

boolean [skill] zelda_combatSkills = $skills[
	Hammer Throw,
	Ultra Smash,
	Juggle Fireballs,
	Fireball Barrage,
	Spin Jump,
	Multi-Bounce,
];

boolean zelda_canDealScalingDamage()
{
	// TODO: When mafia tracks costumes, account for level 3 basic attacks
	if(my_maxpp() < 2)
	{
		return false;
	}

	if(auto_have_skill($skill[Multi-Bounce]))
	{
		return true;
	}

	if(auto_have_skill($skill[Fireball Barrage]) && zelda_haveFlower())
	{
		return true;
	}

	if(auto_have_skill($skill[Ultra Smash]) && zelda_haveHammer())
	{
		return true;
	}

	return false;
}

