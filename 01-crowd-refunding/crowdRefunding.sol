// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract CrowdRefunding {

struct Campaign {
    address creator;
    uint256 goal;
    uint256 deadline;
    uint256 raised;
    campaignStatus status;
}

enum campaignStatus {Active,Successful,Failed}

uint256 public  campaignCount;

//Mapping
mapping (uint256 => Campaign) public campaigns;
mapping (uint256 =>mapping (address =>uint256)) public donations;


//Events 

event CampaignCreated(uint256 indexed campaignId,address indexed creator, uint256 goal, uint256 deadline);
event DonationReceived(uint256 indexed  campaignId,address indexed donor, uint256 amount);
event Withdrawn(uint256 indexed campaignId, address indexed creator, uint256 amount);
event Refunded(uint256 indexed  campaignId, address indexed donor, uint256 amount);


//functions

//1-campaign-creation

function createCampaign(uint256 _goal,uint256 _durationInSeconds) public {
    require(_goal >0,"Goal must be > 0");
    require(_durationInSeconds >0,"Duration must be greater then 0");
    
    campaignCount +=1;
    uint256 _id=campaignCount;
    campaigns[_id]=Campaign({
     creator:msg.sender,
     goal:_goal,
     deadline:block.timestamp + _durationInSeconds,
     raised:0,
     status:campaignStatus.Active
  });

 emit CampaignCreated(_id, msg.sender, _goal, _durationInSeconds);

}

//2-donattion

function donate(uint256 _campaignId) external payable {
   Campaign storage campaign=campaigns[_campaignId];
   require(_campaignId > 0 && _campaignId <= campaignCount, "Invalid campaign");
   require(campaign.status ==campaignStatus.Active,"Campaign is not Active" );
   require(block.timestamp <= campaign.deadline,"Deadline over");
   require(msg.value >0, "Deposit some Eth");

   campaign.raised +=msg.value;
   donations[_campaignId][msg.sender] += msg.value;

   emit  DonationReceived(_campaignId, msg.sender, msg.value);

}

//3-status updation after deadline

function updateStatus(uint256 _campaignId) external {
   Campaign storage campaign=campaigns[_campaignId];
   require(block.timestamp > campaign.deadline,"Campaign still alive");
   require(campaign.status == campaignStatus.Active,"Status already updated");
   if(campaign.raised >= campaign.goal){
    campaign.status=campaignStatus.Successful;
   }else {
    campaign.status=campaignStatus.Failed;
    
   }

}

//4-withdrawn

function withdraw(uint256 _campaignId) external {
   Campaign storage campaign=campaigns[_campaignId];
   require(msg.sender == campaign.creator,"You are  not the creator ");
require(campaign.status == campaignStatus.Successful,"Campaign is not successful");
require(campaign.raised >0 ,"Nothing to withdraw");
uint256 amount=campaign.raised;
campaign.raised=0;

(bool sent,)=msg.sender.call{value:amount}("");
require(sent,"Withdrawal Failed");

emit Withdrawn(_campaignId, msg.sender, amount);
}

//5- Refund Donor
function refund(uint256 _campaignId) external {
   Campaign storage campaign=campaigns[_campaignId];
  uint256 donated=donations[_campaignId][msg.sender];
   require(campaign.status == campaignStatus.Failed,"The campaign is not yet failed");
require(donated >0 ,"Nothing to withdraw");

donations[_campaignId][msg.sender]=0;
(bool sent,)=msg.sender.call{value:donated}("");
require(sent,"Transaction failed");

  emit Refunded(_campaignId, msg.sender, donated);
}


//6- View Campaigns

function getCampaign(uint256 _campaignId) external view returns (
address creator, uint256 goal,uint256 deadline, uint256 raised, campaignStatus status
){
    Campaign storage campaign=campaigns[_campaignId];

    return (
        campaign.creator,
        campaign.goal,
        campaign.deadline,
        campaign.raised,
        campaign.status
    );

}
}
