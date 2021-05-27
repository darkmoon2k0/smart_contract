pragma solidity 0.4.26;

contract multiAcount {
    
    mapping (address => bool) member;
   
    address public owner;
    uint32 public countMember = 0;
    
    event Deposit(address indexed member, uint256 value);
    event Withdraw(address indexed member, uint256 value);
    
    struct Voting{
        address adrFrom;
        uint256 balance;
        uint yesVote;
        uint noVote;
    }
    
    mapping (uint => mapping ( address => uint )) public voteMb;
    
    modifier onlyOwner() {
        require(msg.sender == owner,"chi goi den owner");//kiem tra owner
        _;
    }
    
    modifier onlyMember() {
        require(member[msg.sender] == true,"chi goi den member");//kiem tra owner
        _;
    }
    
    function addMember(address newMember) public onlyOwner returns(bool) {
        require(member[newMember] != true, "da la member");
        member[newMember] = true;
        countMember += 1;
    }
    
    function removeMember(address oldMember) public onlyOwner returns(bool) {
        require(member[oldMember] == true, "chua la member");
        member[oldMember] = false;
        countMember -= 1;
    }
    
    function getBalance() public view returns (uint256) {
         return address(this).balance;
    }
     
    function deposit() payable onlyMember public {
        emit Deposit(msg.sender, msg.value);
    }
    
    function depositAmount(uint256 amount) payable onlyMember public { 
         require(msg.value == amount);
         emit Deposit(msg.sender, msg.value);
    }
    function vote() onlyMember public{
        
    }
    
    function withdrawAmount(uint256 amount) onlyMember payable public {
        //kiem tra vote co hon 50 % 
        require(this.balance >= amount, "Khong du");
         msg.sender.transfer(amount); //this not work
         emit Withdraw(msg.sender, amount);
        //  msg.sender.transfer(getBalance()); // this ok
     }

}
