
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract MultiSigWallet{
    address[] public owners;
    uint256 public requiredConfirmations;
    uint256 public defaultTimeLock = 1 days; // 24 hours
    mapping(uint256 => uint256) public executionTime;

    mapping(address => bool) public isOwner;

    error NotOwner();
    error TxDoesNotExist();
    error TxAlreadyExecuted();
    error AlreadyConfirmed();
    error InsufficientConfirmations();
    error ExecutionFailed();

    event Deposit(address indexed sender, uint256 amount);
    event SubmitTransaction(address indexed owner, uint256 indexed txIndex,address indexed  to,uint256 value, bytes data);
    event ConfirmTransaction(address indexed  owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed  owner,uint256 indexed txIndex);
    event ExecuteTransaction(address indexed  owner, uint256 indexed txIndex);

     constructor(address[] memory _owners,uint256 _requiredConfirmations){
        require(_owners.length>0,"Owners Not Provided");
        require(_requiredConfirmations >0 && _requiredConfirmations <= _owners.length,"Invalid Requred Confirmations");

        for (uint256 i=0; i<_owners.length; i++){
           address owner=_owners[i];
           require(owner != address(0),"Invalid Owner");
           require(!isOwner[owner],"Duplicate Owner");

           isOwner[owner]=true;
           owners.push(owner);
        }
        requiredConfirmations=_requiredConfirmations;
     }
     struct Transaction{
        address to;
        uint256 value;
        bool executed;
        bytes data;
        uint256 numConfirmations;
     }

     Transaction[] public transactions;
     mapping (uint256 =>mapping (address=>bool)) public  isConfirmed;

     modifier onlyOwner(){
        if(!isOwner[msg.sender]) revert NotOwner();
        _;
     }

     modifier txExists(uint256 _txIndex){
        if(_txIndex >= transactions.length) revert TxDoesNotExist();
        _;
     }
     modifier notExecuted(uint256 _txIndex){
        if(transactions[_txIndex].executed) revert TxAlreadyExecuted();
        _;
     }

     modifier notConfirmed(uint256 _txIndex){
        if(isConfirmed[_txIndex][msg.sender]) revert AlreadyConfirmed();
        _;
     }


    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }

       function submitTransaction(address _to, uint256 _value,bytes memory _data)public onlyOwner{
               uint256 txIndex=transactions.length;
               require(_value >0 && _value <= address(this).balance,"Invalid value");
               transactions.push(
                Transaction({
                to:_to,
                value:_value,
                data:_data,
                executed:false,
                numConfirmations:0
               }));

               executionTime[txIndex]= block.timestamp + defaultTimeLock;

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
       }

     function confirmTransaction(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex){
          Transaction storage transaction=transactions[_txIndex];
          
          isConfirmed[_txIndex][msg.sender]=true;
          transaction.numConfirmations+=1;
          
          emit ConfirmTransaction(msg.sender, _txIndex);
     }

     function executeTransaction(uint256 _txIndex) public onlyOwner notExecuted(_txIndex) txExists(_txIndex) {
          Transaction storage transaction=transactions[_txIndex];
          require(block.timestamp >= executionTime[_txIndex],"Time lock is active");
          if(transaction.numConfirmations < requiredConfirmations) revert InsufficientConfirmations();
          transaction.executed=true;

          (bool success, )=transaction.to.call{value:transaction.value}(transaction.data);
         if(!success) revert ExecutionFailed();

         emit ExecuteTransaction(msg.sender, _txIndex);
     }
     function revokeConfirmation(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex){
          Transaction storage transaction=transactions[_txIndex];
          require(isConfirmed[_txIndex][msg.sender],"not confirmed");

          isConfirmed[_txIndex][msg.sender]=false;
          transaction.numConfirmations -=1;
          emit RevokeConfirmation(msg.sender, _txIndex);
     }

     function getOwners()public view returns(address[] memory){
        return owners;
     }
     function getTransactionCount()public view  returns (uint256){
        return transactions.length;
     }
     function getTransaction(uint256 _txIndex) public view returns (address to, uint256 value,bytes memory data, bool executed, uint256 numConfirmations){
          Transaction storage transaction=transactions[_txIndex];
          return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
          );
     }


    function getExecutionTime(uint256 _txIndex) public view returns (uint256) {
    return executionTime[_txIndex];
    }


}
