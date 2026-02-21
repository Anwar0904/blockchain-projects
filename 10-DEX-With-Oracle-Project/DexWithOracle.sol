
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract DexWithOracle{
address public owner;

uint256 public  reserveA;
uint256 public  reserveB;

// oracle 
AggregatorV3Interface internal priceFeed;

//Deviation tracking
uint256 public maxDeviation =5; //5%
bool public paused;

 // Events
    event Swapped(address indexed user, uint256 amountIn, uint256 amountOut, bool direction); // true = A→B, false = B→A
    event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB);
    event Paused(address indexed owner);
    event Unpaused(address indexed owner);

constructor (address _priceFeed){
    priceFeed= AggregatorV3Interface(_priceFeed);
    owner=msg.sender;
}

//Modifiers

modifier priceWithRange(){
    require(!paused,"DEX paused");
    require(getDeviation() <=maxDeviation,"Price deviation too big");
    _;
}

modifier onlyOwner(){
    require(msg.sender==owner,"Not Owner");
    _;
}

//Get price (x=eth, y=usd)

function getOraclePrice() public view returns (uint){
    ( , int price,,,)=priceFeed.latestRoundData();
    uint8 feedDecimals=priceFeed.decimals();
    return uint(price)*10**(18-feedDecimals);
}

//get current pool price (1x= ? y)
function getPoolPrice()public view returns (uint){
    require(reserveA > 0, "No liquidity");
    return uint((reserveB*1e18)/reserveA);
}

//get deviation percentage
function getDeviation()public view returns (uint){
    uint oraclePrice=getOraclePrice();
    uint poolPrice=getPoolPrice();

    if(poolPrice > oraclePrice){
        return ((poolPrice-oraclePrice)*100/oraclePrice);
    }else{
        return ((oraclePrice-poolPrice)*100/oraclePrice);
    }
}



function pause() external onlyOwner{
    paused=true;
    emit Paused(msg.sender);
}



function unpause()external onlyOwner{
    paused=false;
    emit Unpaused(msg.sender);
}

//simplified jsut for testing purposes
function addLiquidity(uint256 amountA, uint256 amountB)external  onlyOwner{
   require(amountA >0 && amountB >0, "Amount must be >0");
   require(!paused,"Contract paused");
   reserveA = amountA;
   reserveB= amountB;
   emit LiquidityAdded(msg.sender, amountA, amountB);
}

//Give A and get B swaping
function swapAforB(uint amountAIn)public priceWithRange returns (uint256 amountBOut){
    require(amountAIn >0, "Amount must be > 0");
    require(!paused,"Contract paused");

    uint256 k=reserveA*reserveB;
    uint256 newReserveA=reserveA+amountAIn;
    uint256 newReserveB=k/newReserveA;
    amountBOut=reserveB-newReserveB;

     require(amountBOut > 0, "Output too small");
        
        // Update reserves
        reserveA = newReserveA;
        reserveB = newReserveB;

    emit Swapped(msg.sender, amountAIn, amountBOut, true);


}

//Give B and get A swaping
function swapBforA(uint amountBIn)public priceWithRange returns (uint256 amountAOut){  
    require(amountBIn > 0, "Amount must be >0");
    require(!paused,"Contract paused");
    uint256 k=reserveA*reserveB;
    uint256 newReserveB=reserveB+amountBIn;    
    uint256 newReserveA=k/newReserveB;
    amountAOut=reserveA-newReserveA;
    require(amountAOut > 0, "Output too small");

    // Update reserves
    reserveA = newReserveA;
    reserveB = newReserveB;
    
emit Swapped(msg.sender, amountBIn, amountAOut, false);
 }
}
