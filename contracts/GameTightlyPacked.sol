pragma solidity ^0.4.21;

contract GameTightlyPacked {
    struct Character {
        uint16 playerID;
        uint32 creationTime;
        uint8 class;
        uint8 race;
        uint16 strength;
        uint16 agility;
        uint16 wisdom;
        bytes18 metadata;
    }

    Character[] public Characters;
    mapping(address => uint16) public player2ID;
    address[] registeredPlayers;

    event CharacterCreated(Character c, uint CharacterId);
    event PlayerRegistered(uint16 playerID, address player);

    function GameTightlyPacked() public {
        registeredPlayers.push(0x0);
    }

    function Register() public returns (uint16) {
        uint16 playerID = player2ID[msg.sender];
        require(playerID == 0 && registeredPlayers.length < 65535);

        playerID = uint16(registeredPlayers.length);
        registeredPlayers.push(msg.sender);
        player2ID[msg.sender] = playerID;
        emit PlayerRegistered(playerID, msg.sender);

        return playerID;
    }

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

        Character memory  c;
        // Overhead from converting, in order to match interface
        c.playerID = uint16(playerID);
        c.creationTime = uint32(creationTime);
        c.class = uint8(class);
        c.race = uint8(race);
        c.strength = uint16(strength);
        c.agility = uint16(agility);
        c.wisdom = uint16(wisdom);
        c.metadata = bytes18(metadata);

        uint CharacterId = Characters.length;
        emit CharacterCreated(c, CharacterId);

        Characters.push(c);
    }

    function GetCharacterStats(uint256 index) 
        external view
        returns (
            uint16 playerID, 
            uint32 creationTime, 
            uint8 class,
            uint8 race, 
            uint16 strength,
            uint16 agility,
            uint16 wisdom,
            bytes18 metadata
        )
    {
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
}

}