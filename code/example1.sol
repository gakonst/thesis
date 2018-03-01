pragma solidity ^0.4.16;

contract TestContract {

	string private myString = "foo";
	uint private lastUpdated = now;
	
	function getString() view external returns (string, uint) {
		return (myString, lastUpdated);
	}
	
	function setString (string _string) public {
		myString = _string;
		lastUpdated = block.timestamp;
	}
}