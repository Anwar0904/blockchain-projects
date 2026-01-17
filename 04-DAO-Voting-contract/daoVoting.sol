// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract VotingContract{

//Struct for proposal
    struct Proposal{
        string description;
        uint256 deadline;
        uint256 yesVotes;
        uint256 noVotes;
        ProposalStatus status;
        mapping(address => bool) hasVoted;
    }

    enum ProposalStatus {Active,Passed,Failed}

//mapping and variables
    uint256 public  ProposalCount;
    mapping (uint256 => Proposal) public proposals;

    mapping(address => bool) public members;      
    uint256 public memberCount;

    // events
    event MemberJoined(address indexed  member);
    event ProposalCreated(uint256 indexed proposalId,string description,uint256 deadline);
    event Voted(uint256 indexed proposalId,address indexed voter, bool support);
    event ProposalFinalized(uint256 indexed proposalId, ProposalStatus status);

    //modifiers
    modifier onlyMember(){
       require(members[msg.sender],"Not a member");
       _;
    }
    modifier proposalExists(uint256 _proposalId){
        require(_proposalId >0 && _proposalId <=ProposalCount,"Not valid proposal");
        _;
    }


    // functions
    function joinDAO() external {
        require(!members[msg.sender],"Already a member");
        members[msg.sender]=true;
        memberCount+=1;
        emit MemberJoined(msg.sender);
    }

    function createProposal(string memory _description,uint256 _durationInSeconds) external onlyMember{
        require(_durationInSeconds >0,"Duration must be greater then zero");
        require(bytes(_description).length > 0, "Description must not be empty");

        ProposalCount+=1;
        uint256 _id=ProposalCount;
        Proposal storage p= proposals[_id];
        p.description=_description;
        p.deadline=block.timestamp + _durationInSeconds;
        p.status=ProposalStatus.Active;

        emit ProposalCreated(_id, p.description, p.deadline);
    }


function vote(uint256 _proposalId, bool _support)external onlyMember proposalExists(_proposalId){
    Proposal storage proposal=proposals[_proposalId];
       
    require(block.timestamp <= proposal.deadline, "Voting period over");
    require(!proposal.hasVoted[msg.sender],"Member already voted");

    proposal.hasVoted[msg.sender]=true;
    if(_support){
      proposal.yesVotes+=1;
    }else {
      proposal.noVotes+=1;
    }
    emit Voted(_proposalId, msg.sender, _support);
}

function finalizeProposal(uint256 _proposalId) external onlyMember proposalExists(_proposalId){
    Proposal storage proposal=proposals[_proposalId];
        require(block.timestamp > proposal.deadline, "Proposal still Active");
        require(proposal.status ==ProposalStatus.Active,"Proposal already finalized");

        if(proposal.yesVotes >proposal.noVotes){
            proposal.status=ProposalStatus.Passed;
        }else {
            proposal.status=ProposalStatus.Failed;
        }

        emit ProposalFinalized(_proposalId, proposal.status);
       
}

//view proposals 

function getProposal(uint256 _proposalId) external view proposalExists(_proposalId) 
returns (
string memory description,
uint256 deadline,
uint256 yesVotes,
uint256 noVotes,
ProposalStatus status
){
Proposal storage p=proposals[_proposalId];
    return (
        p.description,
        p.deadline,
        p.yesVotes,
        p.noVotes,
        p.status
    );
}

}
