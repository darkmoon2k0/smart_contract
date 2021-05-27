pragma solidity ^0.4.26;

contract sendEth{
    address public owner;
    
    constructor() public payable{
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner,"chi goi den owner");//kiem tra owner
        _;
    }
    
    function getBalance() public view returns (uint256) {
         return address(this).balance;
    }
     
    function deposit() payable public {
    }
    
    function depositAmount(uint256 amount) payable public { 
         require(msg.value == amount);
    }
    
    function withdraw() onlyOwner public {
         msg.sender.transfer(address(this).balance);
    }
    
    function withdrawAmount(uint256 amount) onlyOwner payable public { 
         require(amount <= getBalance());
        //  msg.sender.transfer(amount); //this not work
         msg.sender.transfer(getBalance()); // this ok
     }
}
