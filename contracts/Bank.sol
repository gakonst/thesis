contract Bank {
    
    struct BalancesStruct{
        address owner;
        mapping(address => uint) balances;
    } 
    
    mapping(uint => BalancesStruct) stackBalance;
    function createBalance(uint idx){
        require(stackBalance[idx].owner == 0);
        stackBalance[idx] = BalancesStruct(msg.sender);
    }    
    
    function deleteBalance(uint idx){
        require(stackBalance[idx].owner == msg.sender);
        delete stackBalance[idx];
    }
    
    function setBalance(uint idx, address addr, uint val){
        require(stackBalance[idx].owner == msg.sender);
        
        stackBalance[idx].balances[addr] = val;
    }
    
    function getBalance(uint idx, address addr) returns(uint){
        return stackBalance[idx].balances[addr];
    }
    
}