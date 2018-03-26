pragma solidity ^0.4.21;

library CharacterLib {
    /**--Virtual Structure-----------
     * BetRecord
     *  Type        Name          Index         Bits
     *  uint16      playerID      0             16
     uint32      creationTime  16            32  // 2^32 = 02/07/2106 @ 6:28am (UTC)
     uint4       class         48            4   // 2^4 = 16 classes, more than enough for a game
     uint4       race          52            4   // same as above
     uint16      strength      56            16  // stats until 65535
     uint16      agility       72            16  // same
     uint16      wisdom        88            16  // same 
     bytes18     metadata      104           152 // use what's left for unique metadata, 134 bits are more than enough 
     **-------------------------------*/

    /**Here we create bit masks for all of our funky data sizes*/
    uint private constant mask1         =  1;                //binary 1
    uint private constant mask4         = (1 << 4)  -1;     //binary 1111
    uint private constant mask16        = (1 << 16) -1;     //binary 1111 1111 1111 1111
    uint private constant mask32        = (1 << 32) -1;    
    uint private constant mask152       = (1 << 152)-1;

    /**Here we create shift indices for each property. It is simply 1 shifted left by the Index listed above.*/
    uint private constant _PlayerID     = 1 << 0;
    uint private constant _CreationTime = 1 << 16;
    uint private constant _Class        = 1 << 48;
    uint private constant _Race         = 1 << 52;
    uint private constant _Strength     = 1 << 56;
    uint private constant _Agility      = 1 << 72;
    uint private constant _Wisdom       = 1 << 88;
    uint private constant _Metadata     = 1 << 104;

    /**Generic Getter/Setter which does the bit magic.*/
    function GetProperty(bytes32 Character, uint mask, uint shift) private pure returns (uint property) {
        property = mask&(uint(Character)/shift);
        //                  ^ shift right and apply mask
    }

    function SetProperty(bytes32 Character, uint mask, uint shift, uint value) private pure returns (bytes32 updated) {
        updated = bytes32((~(mask*shift) & uint(Character)) | ((value & mask) * shift));
        //                        ^ Clear area inside the mask  --> Fill it with the value (mask redundant)
    }

    function SetPlayerID(bytes32 Character, uint256 value) internal pure returns (bytes32)     { return SetProperty(Character, mask16,  _PlayerID,     value); }
    function SetCreationTime(bytes32 Character, uint256 value) internal pure returns (bytes32) { return SetProperty(Character, mask32,  _CreationTime, value); }
    function SetClass(bytes32 Character, uint256 value) internal pure returns (bytes32)       { return SetProperty(Character, mask4,   _Class,        value); }
    function SetRace(bytes32 Character, uint256 value) internal pure returns (bytes32)          { return SetProperty(Character, mask4,   _Race,         value); }
    function SetStrength(bytes32 Character, uint256 value) internal pure returns (bytes32)     { return SetProperty(Character, mask16,  _Strength,     value); }
    function SetAgility(bytes32 Character, uint256 value)  internal pure returns (bytes32)     { return SetProperty(Character, mask16,  _Agility,      value); }
    function SetWisdom(bytes32 Character, uint256 value)   internal pure returns (bytes32)     { return SetProperty(Character, mask16,  _Wisdom,       value); }
    function SetMetadata(bytes32 Character, uint256 value)   internal pure returns (bytes32)  { return SetProperty(Character, mask152, _Metadata,     value); }

    function GetPlayerID(bytes32 Character) internal pure returns (uint16) { return uint16(GetProperty(Character, mask16, _PlayerID)); }
    function GetCreationTime(bytes32 Character) internal pure returns (uint32) { return uint32(GetProperty(Character, mask32, _CreationTime)); }
    function GetClass(bytes32 Character) internal pure returns (uint8) { return uint8(GetProperty(Character, mask4, _Class)); }
    function GetRace(bytes32 Character) internal pure returns (uint8) { return uint8(GetProperty(Character, mask4, _Race)); }
    function GetStrength(bytes32 Character) internal pure returns (uint16) { return uint16(GetProperty(Character, mask16, _Strength)); }
    function GetAgility(bytes32 Character)  internal pure returns (uint16) { return uint16(GetProperty(Character, mask16, _Agility)); }
    function GetWisdom(bytes32 Character)   internal pure returns (uint16) { return uint16(GetProperty(Character, mask16, _Wisdom)); }
    function GetMetadata(bytes32 Character)   internal pure returns (bytes18) { return bytes18(GetProperty(Character, mask152, _Metadata)); }

}

contract GameByteMasking { 
    using CharacterLib for bytes32;

    bytes32[] public Characters;
    mapping(address => uint16) public player2ID;
    address[] registeredPlayers;

    event CharacterCreated(bytes32 c, uint CharacterId);
    event PlayerRegistered(uint16 playerID, address player);

    function GameByteMasking() public {
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

        bytes32 c = c.SetPlayerID(playerID);
        c = c.SetCreationTime(creationTime);
        c = c.SetClass(class);
        c = c.SetRace(race);
        c = c.SetStrength(strength);
        c = c.SetAgility(agility);
        c = c.SetWisdom(wisdom);
        c = c.SetMetadata(metadata);

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
    }

}