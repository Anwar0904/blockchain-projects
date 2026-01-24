// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address);
    function getApproved(uint256 tokenId) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

contract NFTMarketplace{
    address public  owner;
    uint256 public platformFeePercentage=250;
    uint256 public totalFeesCollected;

    event NFTListed(
        address indexed seller, 
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price
        );

    event NFTSold(
        address indexed buyer,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price
    );

    event ListingCancelled(
        address indexed  seller,
        address indexed  nftAddress,
        uint256 indexed  tokenId);

    modifier onlyOwner(){
        require(msg.sender == owner,"Not owner");
        _;
    }

    constructor(){
        owner=msg.sender;
    }


    struct Listing{
        address seller;
        uint256 price;
        bool active;
    }

    mapping (address=>mapping(uint256 =>Listing)) public  listings;
    uint256 public listingCount;

    function listNFT(address _nftAddress,uint256 _tokenId,uint256 _price) 
    external {
         require(_price >0,"Invalid price");
         require(IERC721(_nftAddress).ownerOf(_tokenId)==msg.sender,"Not token Owner");
         
         require(
            IERC721(_nftAddress).getApproved(_tokenId)==address(this) || 
            IERC721(_nftAddress).isApprovedForAll(msg.sender,address(this)) ,
            "Marketplace not approved"
         );
         listings[_nftAddress][_tokenId]=Listing({
            seller:msg.sender,
            price:_price,
            active:true
         });

         listingCount++;

         emit NFTListed(msg.sender, _nftAddress,  _tokenId,_price);


    }


  function buyNft(address nftAddress,uint256 tokenId) external payable {
        Listing storage listing=listings[nftAddress][tokenId];
        require(listing.active,"Not for sale");
        require(msg.value == listing.price,"Incorrect price");

        uint256 platformFee=(msg.value * platformFeePercentage)/10000;
        uint256 sellerAmount=msg.value-platformFee;
        totalFeesCollected+=platformFee;

        IERC721(nftAddress).safeTransferFrom(listing.seller,msg.sender,tokenId);
        (bool sent, )=listing.seller.call{value:sellerAmount}("");
        require(sent,"Transaction failed");

        listing.active=false;

        emit NFTSold(msg.sender, nftAddress, tokenId, msg.value);
  }

  function cancelListing(address nftAddress,uint256 tokenId)external {
        Listing storage listing=listings[nftAddress][tokenId];
        require(listing.active,"Listing already Inactive");
        require(listing.seller==msg.sender || msg.sender==owner,"Not seller/owner");

        listing.active=false;
        emit ListingCancelled(msg.sender, nftAddress, tokenId);
  }

  //owner functions
  function setPlatformFee(uint256 newFeePercentage)external  onlyOwner {
    require(newFeePercentage <=1000,"Max 10% Fee");
    
    platformFeePercentage=newFeePercentage;
  }
  function withdrawFees()external onlyOwner{
    uint256 fees=totalFeesCollected;
    require(fees>0,"No Fees to withdraw");
    totalFeesCollected=0;
    (bool sent,) =msg.sender.call{value:fees}("");
    require(sent,"Transfer failed");

  }

}
