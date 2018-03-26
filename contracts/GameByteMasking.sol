pragma solidity ^0.4.21;

contract GameByteMasking {

    uint[] public Characters;
    event CharacterCreated(uint c, uint CharacterId);

    /* ... same functions and vars */

	function CreateCharacter(
		uint256 creationTime,
		uint256 class,
		uint256 race,
		uint256 strength, 
		uint256 agility, 
		uint256 wisdom,
		uint256 metadata) 
		external 
    {
        uint16 playerID = player2ID[msg.sender];
        require(playerID != 0);

        uint c = uint256(playerID);
        c |= creationTime  <<  16;
        c |= class         <<  48;
        c |= race          <<  52;
        c |= strength      <<  56;
        c |= agility       <<  72;
        c |= wisdom        <<  88;
        c |= metadata      << 104;
        
        uint CharacterId = Characters.length;
        emit CharacterCreated(c, CharacterId);

        Characters.push(c);
    }

    function GetCharacterStats(uint256 index) 
        external view
        returns (
            uint16 playerID, 
            uint32 creationTime, 
            uint8 race, 
            uint8 class,
            uint16 strength,
            uint16 agility,
            uint16 wisdom,
            bytes18 metadata)
        {
        uint c = Characters[index];
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
    }
}