pragma solidity 0.4.26;

contract voting {
    
    mapping (address => bool) member;
   
    address public owner;
    uint256 public countMember = 0;
    
    constructor() public payable{
        owner = msg.sender;
    }
    
    event Deposit(address indexed member, uint256 value);
    event Withdraw(address indexed member, uint256 value);
    
    struct Voting{
        address adrFrom;
        uint256 money;
        uint yesVote;
        uint noVote;
        bool execute;
    }
    
    mapping(uint256 => Voting) public listVote;
    uint256 size = 0;
    
    mapping (address => mapping ( uint256 => bool )) public isVoted; // member vote chua?
    
    modifier onlyOwner() {
        require(msg.sender == owner,"chi goi den owner");
        _;
    }
    
    modifier onlyMember() {
        require(member[msg.sender] == true,"chi goi den member");
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
    function voteYes(uint256 idVote) onlyMember public view returns(uint256){
        require(isVoted[msg.sender][idVote] == false ,"da vote roi" );
        listVote[idVote].yesVote ++;
        if (listVote[size].yesVote > countMember * 50 / 100){
            listVote[idVote].execute = true;
            execution(listVote[idVote].money);
        }
        else{
            listVote[idVote].execute = false;
            // ko thuc thi
        }
    }
    
    function execution(uint256 amount) onlyMember payable public {
        require(this.balance >= amount, "Khong du");
        msg.sender.transfer(amount); 
        emit Withdraw(msg.sender, amount);
    }
       
    function withdrawAmount(uint256 amount) onlyMember payable public {
        Voting memory vote = Voting({
            adrFrom: msg.sender,
            money: amount,
            yesVote: 0,
            noVote : 0,
            execute : false
        });
        size++;
        listVote[size] = vote;
        
     }
}
