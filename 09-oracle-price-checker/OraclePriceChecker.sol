
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

//Interface for real time price checking using aggregate protocols 

interface AggregatorV3Interface {
    function latestRoundData() external view returns (
       uint80,
       int256,
       uint256,
       uint256,
       uint80
    );
    function decimals()external view returns (uint8);
}

//Main contract 

contract OraclePriceChecker{
    AggregatorV3Interface public PriceFeed;
    uint256 public targetPrice;

    constructor(address _feed) {
        PriceFeed= AggregatorV3Interface(_feed);
    }

//get raw price from chainlink
    function getRawPrice() public view returns (int256){
        (,int256 price,,,)=PriceFeed.latestRoundData();
        return price;
    }

//Get normalize price in Wei
    function getPrice() public view returns (uint256){
        (,int256 price,,,)=PriceFeed.latestRoundData();
        uint8 decimals=PriceFeed.decimals();
        return  uint256(price) * (10**(18-decimals));
    }

//Set target price 
    function setTargetPrice(uint256 _price)external {
        targetPrice=_price;
    }
//Check if the price of Eth is above the target price or not
    function isAboveTarget() external view returns (bool){
        return getPrice() > targetPrice;
    }

//Check if the price of Eth is below the target price or not
    function isBelowTarget()external view returns (bool){
        return getPrice() < targetPrice;
    }
}
