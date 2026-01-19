// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SecureWallet {
    address public owner;
    bool public paused;
    
    //events
    event Deposited(address indexed sender, uint256 amount);
    event Withdrawal(address indexed reciever, uint256 amount);
    event StatChaged(bool status);

//modifiers
    modifier onlyOwner(){
        require(msg.sender == owner,"Not owner");
        _;
    }
    modifier whenNotPaused(){
        require(!paused,"Contract is paused");
        _;
    }

    // constructor
   constructor(){
    owner=msg.sender;
   }


//payables
   receive() external payable whenNotPaused{ 
    emit Deposited(msg.sender, msg.value);
   }
    fallback() external payable whenNotPaused{ 
    emit Deposited(msg.sender, msg.value);
   }

   //functions
   function Deposit() external payable whenNotPaused{
        require(msg.value >0, "Nothing to deposit");
        
        emit Deposited(msg.sender, msg.value);
   }

   function Withdraw(uint256 _amount) external onlyOwner whenNotPaused{
    require(_amount >0,"Withrawal amount must be > 0");
    require(_amount <= address(this).balance,"Insufficient balance");

    (bool sent,)=owner.call{value:_amount}("");
    (sent,"Fialed to withdraw");
   emit Withdrawal(owner, _amount);
   }

   function setPaused(bool _status) external onlyOwner{
        paused =_status;
        emit StatChaged(_status);
   }
}
