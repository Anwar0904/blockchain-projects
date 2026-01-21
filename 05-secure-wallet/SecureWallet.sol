// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SecureWallet {


    error NotOwner();
    error ContractPaused();
    error AmountTooSmall();
    error InsufficientBalance();
    error TransferFailed();


    address public owner;
    bool public paused;
    
    //events
    event Deposited(address indexed sender, uint256 amount);
    event Withdrawal(address indexed reciever, uint256 amount);
    event StatChaged(bool status);

//modifiers
    modifier onlyOwner(){
        if(msg.sender != owner) revert NotOwner();
        _;
    }
    modifier whenNotPaused(){
        if(paused) revert ContractPaused();
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
        if(msg.value <=0) revert AmountTooSmall();
        
        emit Deposited(msg.sender, msg.value);
   }

   function Withdraw(uint256 _amount) external onlyOwner whenNotPaused{
   if(_amount ==0) revert AmountTooSmall();
   if(_amount > address(this).balance) revert InsufficientBalance();

    (bool sent,)=owner.call{value:_amount}("");
    if(!sent) revert TransferFailed();
   emit Withdrawal(owner, _amount);
   }

   function setPaused(bool _status) external onlyOwner{
        paused =_status;
        emit StatChaged(_status);
   }
}
