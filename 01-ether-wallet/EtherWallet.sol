// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


contract EtherWallet{

    //golobal variables
    address public  owner;
    bool paused;


//events
event Deposit(address indexed sender,uint256 value);
event Withdraw(address indexed  reciever, uint256 value);
event pausedEvent(bool status);

//modifiers

modifier  onlyOwner(){
    require(msg.sender == owner,"Not owner");
    _;
}

modifier  whenNotPaused(){
    require(!paused,"Transaction paused");
    _;
}

//constructor
constructor(){
    owner=msg.sender;
}

//recieve and Callback payables

receive() external payable {
    emit Deposit(msg.sender, msg.value);
 }

fallback() external payable {
    emit Deposit(msg.sender, msg.value);
}

//functions
function togglePaused()external onlyOwner  {
paused=!paused;
emit pausedEvent(paused);
}


function deposit() public whenNotPaused payable {
    require(msg.value >0 ,"Deposit some amount");
    emit Deposit(msg.sender, msg.value);
}

function withdraw(uint256 _amount) public onlyOwner whenNotPaused{
    require(_amount >0,"Enter amount to withdraw");
    require(_amount <= address(this).balance,"Insufficient balance");
    (bool sent,) =owner.call{value:_amount}("");
    require(sent,"Transaction/Withdrawal fialed");

    emit Withdraw(owner, _amount);
}

function getBalance()external  view  returns (uint256){
    return address(this).balance;
}
}
