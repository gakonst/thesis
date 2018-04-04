pragma solidity ^0.4.21;

library L {
    function add(uint a, uint b) public pure returns(uint) { 
    	return (a+b); 
    }
}

contract C {
    using L for uint;
    uint public x = 1;
    uint public y = 2;

    function add() {
        x = x.add(y);
    }
    
}