pragma solidity ^0.4.21;

library Meter {

    /** Virtual Struct
     *  Type        Name          Index         Bits
     * bool      active             0            1
     * bytes8    id                 1           64
     * uint48    currentPower       65           48
     * uint32    currentTimestamp   113           32
     * uint48    lastPower       145           48
     * uint32    lastTimestamp   193           32
     *    Total = 225 bits
     */

    /**Here we create bit masks for all of our funky data sizes*/
    uint private constant mask1         =  1;                //binary 1
    uint private constant mask64        = (1 << 64) - 1;     //binary ...
    uint private constant mask32        = (1 << 32) - 1;     //binary ...
    uint private constant mask48        = (1 << 48) - 1;     //binary ...

    /**Here we create shift indices for each property. It is simply 1 shifted left by the Index listed above.*/
    uint private constant _active = 1 << 0;
    uint private constant _id = 1 << 1;
    uint private constant _currentPower = 1 << 65;
    uint private constant _currentTimestamp = 1 << 113;
    uint private constant _lastPower = 1 << 145;
    uint private constant _lastTimestamp = 1 << 193;


    /**Generic Getter/Setter which does the bit magic.*/
    function getProperty(bytes32 MeterData, uint mask, uint shift) private pure returns (uint property) {
        property = mask & (uint(MeterData) / shift);
    }

    function setProperty(bytes32 MeterData, uint mask, uint shift, uint value) private pure returns (bytes32 updated) {
        updated = bytes32(
            (~(mask*shift) & uint(MeterData) ) | ( (value & mask) * shift)
        );
    }
    
    /// SETTER FUNCTIONS
    function activateMeter(bytes32 MeterData) internal pure returns (bytes32)     { return setProperty(MeterData, mask1, _active, 1); }
    function deactivateMeter(bytes32 MeterData) internal pure returns (bytes32)     { return setProperty(MeterData, mask1, _active, 0); }

    function setId(bytes32 MeterData, bytes8 id) internal pure returns (bytes32)     { return setProperty(MeterData, mask64,  _id, uint(id)); }

    function setPower(bytes32 MeterData, uint48 power) internal pure returns (bytes32) { 

        // set previous power
        uint48 currentPower = getCurrentPower(MeterData);
        MeterData = setLastPower(MeterData, currentPower);
        return setProperty(MeterData, mask48,  _currentPower, power); 
    }
         
    function setTimestamp(bytes32 MeterData, uint32 timestamp) internal pure returns (bytes32)     { 
        
        uint32 currentTimestamp = getCurrentTimestamp(MeterData);
        MeterData = setLastTimestamp(MeterData, currentTimestamp);
        return setProperty(MeterData, mask32,  _currentTimestamp, timestamp); 
    }

    function setLastPower(bytes32 MeterData, uint48 power) internal pure returns (bytes32)     { return setProperty(MeterData, mask48,  _lastPower, power); }
    function setLastTimestamp(bytes32 MeterData, uint32 timestamp) internal pure returns (bytes32)     { return setProperty(MeterData, mask32,  _lastTimestamp, timestamp); }


    /// GETTER FUNCTIONS

    function getCurrentPower(bytes32 MeterData) internal pure returns (uint48) { return uint48(getProperty(MeterData, mask48, _currentPower)); }
    function getLastPower(bytes32 MeterData) internal pure returns (uint48) { return uint48(getProperty(MeterData, mask48, _lastPower)); }

    function getCurrentTimestamp(bytes32 MeterData) internal pure returns (uint32) { return uint32(getProperty(MeterData, mask32, _currentTimestamp)); }
    function getLastTimestamp(bytes32 MeterData) internal pure returns (uint32) { return uint32(getProperty(MeterData, mask32, _lastTimestamp)); }

    function isActive(bytes32 MeterData) internal pure returns (bool) { return (getProperty(MeterData, mask1, _active) == 1); }
    function getId(bytes32 MeterData) internal pure returns (bytes8) { return bytes8(getProperty(MeterData, mask64, _id)); }

}
