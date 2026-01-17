// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract EscrowSmartContract {

// Escrow struct
struct Escrow{
    address buyer;
    address seller;
    uint256 amount;
    EscrowStatus status;
}

//Escrow states
enum EscrowStatus {Created,Funded,Released,Refunded}

//mapping
mapping (uint256 => Escrow) public escrows;

uint256 public  escrowCount ;

//Events 
event EscrowCreated(uint256 indexed escrowId,address buyer,address seller, uint256 amount);
event Funded(uint256 indexed escrowId,uint256 amount);
event Released(uint256 indexed escrowId);
event Refunded(uint256 indexed escrowId);

//access controllers

modifier onlyBuyer(uint256 _id){
    require(msg.sender ==escrows[_id].buyer,"Not buyer");
    _;
}

  modifier validEscrow(uint256 _escrowId) {
        require(_escrowId > 0 && _escrowId <= escrowCount, "Invalid escrow ID");
        _;
    }


//functions

//Creat an Escrow

function createEscrow(address _seller,uint256 _amount) external {
         require(_seller !=address(0),"Invalid address");
         require(_amount >0,"Amount must be > 0");

         escrowCount +=1;
         uint256 _id=escrowCount;
         escrows[_id]=Escrow({
            buyer:msg.sender,
            seller:_seller,
            amount:_amount,
            status:EscrowStatus.Created
         });
         emit EscrowCreated(_id, msg.sender, _seller, _amount);
}

// fund Escrow by buyer

function fundEscrow(uint256 _escrowId) external payable onlyBuyer(_escrowId) validEscrow(_escrowId){
    Escrow storage escrow=escrows[_escrowId];
     
   require(escrow.status == EscrowStatus.Created,"Escrow didn't created");
   require(msg.value == escrow.amount,"Incorrect Eth amount");

   escrow.status=EscrowStatus.Funded;
   emit Funded(_escrowId, msg.value);
}

//Release fund

function releaseFund(uint256 _escrowId)external onlyBuyer(_escrowId)  validEscrow(_escrowId){
    Escrow storage escrow=escrows[_escrowId];

    require(escrow.status == EscrowStatus.Funded,"Escrow is not funded");

    escrow.status=EscrowStatus.Released;

    (bool sent,)=escrow.seller.call{value:escrow.amount}("");
    require(sent,"Transaction/Release fialed");
    emit Released(_escrowId);
}

//Refund function
function refund(uint256 _escrowId) external onlyBuyer(_escrowId)  validEscrow(_escrowId) {
    Escrow storage escrow = escrows[_escrowId];

    require(escrow.status == EscrowStatus.Funded, "Escrow not funded");

    escrow.status = EscrowStatus.Refunded;

    (bool sent, ) = escrow.buyer.call{value: escrow.amount}("");
    require(sent, "ETH transfer failed");

    emit Refunded(_escrowId);
}

  // View escrow details
    function getEscrow(uint256 _escrowId)
        external
        view
        validEscrow(_escrowId)
        returns (
            address buyer,
            address seller,
            uint256 amount,
            EscrowStatus status
        )
    {
        Escrow storage escrow = escrows[_escrowId];
        return (escrow.buyer, escrow.seller, escrow.amount, escrow.status);
    }


}
