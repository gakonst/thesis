Character memory  c;
c.playerID = uint16(playerID);
c.creationTime = uint32(creationTime);
c.class = uint8(class);
c.race = uint8(race);
c.strength = uint16(strength);
c.agility = uint16(agility);
c.wisdom = uint16(wisdom);
c.metadata = bytes18(metadata);

uint c = uint256(playerID);
c |= creationTime  <<  16;
c |= class         <<  48;
c |= race          <<  52;
c |= strength      <<  56;
c |= agility       <<  72;
c |= wisdom        <<  88;
c |= metadata      << 104;

bytes32 c = c.SetPlayerID(playerID);
c = c.SetCreationTime(creationTime);
c = c.SetClass(class);
c = c.SetRace(race);
c = c.SetStrength(strength);
c = c.SetAgility(agility);
c = c.SetWisdom(wisdom);
c = c.SetMetadata(metadata);

Character memory  c = Characters[index];
return (
    c.playerID,
    c.creationTime,
    c.class,
    c.race,
    c.strength,
    c.agility,
    c.wisdom,
    c.metadata
);

return (
    uint16(c),
    uint32(c >> 16), 
    uint8((c >> 48) & uint256(2**4-1)), 
    uint8((c >> 52) & uint256(2**4-1)),
    uint16(c >> 56),
    uint16(c >> 72),
    uint16(c>> 88),
	bytes18(c>>104)
);

bytes32 c = Characters[index];
return (
    c.GetPlayerID(),
    c.GetCreationTime(),
    c.GetClass(),
    c.GetRace(),
    c.GetStrength(),
    c.GetAgility(),
    c.GetWisdom(),
    c.GetMetadata()
);