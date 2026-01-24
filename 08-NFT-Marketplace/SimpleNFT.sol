// SimpleNFT.sol - For testing only
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SimpleNFT {
    string public name = "Test NFT";
    string public symbol = "TEST";
    uint256 public tokenCounter;
    
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    
    function mint() external returns (uint256) {
        tokenCounter++;
        uint256 newTokenId = tokenCounter;
        _owners[newTokenId] = msg.sender;
        _balances[msg.sender]++;
        return newTokenId;
    }
    
    function ownerOf(uint256 tokenId) external view returns (address) {
        return _owners[tokenId];
    }
    
    function getApproved(uint256 tokenId) external view returns (address) {
        return _tokenApprovals[tokenId];
    }
    
    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    
    function approve(address to, uint256 tokenId) external {
        require(_owners[tokenId] == msg.sender, "Not owner");
        _tokenApprovals[tokenId] = to;
    }
    
    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;
    }
    
    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        require(_owners[tokenId] == from, "Not owner");
        require(
            msg.sender == from || 
            msg.sender == _tokenApprovals[tokenId] || 
            _operatorApprovals[from][msg.sender],
            "Not approved"
        );
        
        _owners[tokenId] = to;
        _balances[from]--;
        _balances[to]++;
    }
}
