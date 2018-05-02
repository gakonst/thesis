contract Owned {
    address owner;
    function Owned() public { owner = msg.sender; }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract Test is Owned {
    function foo() onlyOwner { 
        /* do something only owner can do */ 
    }
}