pragma solidity ^0.4.21;

interface Game {
    event PlayerRegistered(uint16 playerID, address player);

    function Register() public returns (uint16 playerID);
    function CreateCharacter(uint256 creationTime, uint256 class,  uint256 race, uint256 strength, uint256 agility, uint256 wisdom,  uint256 metadata)   external;
    function GetCharacterStats(uint256 index) external view returns (uint16 playerID, uint32 creationTime, uint8 class , uint8 race, uint16 strength, uint16 agility, uint16 wisdom, bytes18 metadata);

}