pragma solidity ^0.4.11;

contract Owned {
    address owner;    function Owned() {
        owner = msg.sender;
    }
    modifier onlyOwner{
        if (msg.sender != owner)
            revert();        _;
    }
}

contract KingOfTheHill is Owned {
    address public owner;
    uint public jackpot;
    uint public withdrawDelay;

    function() public payable {
        // transfer contract ownership if player pay more than current jackpot
        if (msg.value > jackpot) {
            owner = msg.sender;
            withdrawDelay = block.timestamp + 5 days;
        }
        jackpot+=msg.value;
    }

    function takeAll() public onlyOwner {
        require(block.timestamp >= withdrawDelay);
        msg.sender.transfer(this.balance);
        jackpot=0;
    }
}