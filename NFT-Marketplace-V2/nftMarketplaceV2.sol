// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address);
    function getApproved(uint256 tokenId) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

contract NFTMarketplaceOptimized {

    address public immutable owner = msg.sender;

    // 250 = 2.5%
    uint16 public platformFeePercentage = 250;

    uint256 public totalFeesCollected;
    uint256 public listingCount;


    /* ---------- Errors ---------- */

    error NotOwner();
    error InvalidPrice();
    error NotTokenOwner();
    error MarketplaceNotApproved();
    error NotForSale();
    error IncorrectPrice();
    error TransferFailed();
    error ListingInactive();
    error MaxFeeExceeded();
    error NoFees();
    error NotSeller();


    /* ---------- Events ---------- */

    event NFTListed(address indexed seller, address indexed nft, uint256 indexed tokenId, uint96 price);
    event NFTSold(address indexed buyer, address indexed nft, uint256 indexed tokenId, uint96 price);
    event ListingCancelled(address indexed seller, address indexed nft, uint256 indexed tokenId);
    event PlatformFeeUpdated(uint16 oldFee, uint16 newFee);
    event FeesWithdrawn(address indexed recipient, uint256 amount);


    struct Listing {
        address seller;
        uint96 price;
        uint8 flags;
    }

    uint8 private constant IS_ACTIVE = 1 << 0;

    mapping(address => mapping(uint256 => Listing)) private _listings;


    /* ---------- Views ---------- */

    function getListing(address nft, uint256 tokenId)
        external
        view
        returns (address seller, uint96 price, bool active)
    {
        Listing memory l = _listings[nft][tokenId];
        return (l.seller, l.price, (l.flags & IS_ACTIVE) != 0);
    }

    function isListed(address nft, uint256 tokenId) external view returns (bool) {
        return (_listings[nft][tokenId].flags & IS_ACTIVE) != 0;
    }

    function getListingPrice(address nft, uint256 tokenId) external view returns (uint96) {
        return _listings[nft][tokenId].price;
    }


    /* ---------- Core logic ---------- */

    function listNFT(address nftAddress, uint256 tokenId, uint96 price) external {
        if (price == 0) revert InvalidPrice();

        IERC721 nft = IERC721(nftAddress);

        if (nft.ownerOf(tokenId) != msg.sender) revert NotTokenOwner();

        address approved = nft.getApproved(tokenId);
        bool isOperator = nft.isApprovedForAll(msg.sender, address(this));

        if (approved != address(this) && !isOperator) revert MarketplaceNotApproved();

        _listings[nftAddress][tokenId] = Listing({
            seller: msg.sender,
            price: price,
            flags: IS_ACTIVE
        });

        unchecked {
            listingCount++;
        }

        emit NFTListed(msg.sender, nftAddress, tokenId, price);
    }


    function buyNFT(address nftAddress, uint256 tokenId) external payable {
        Listing storage listing = _listings[nftAddress][tokenId];

        if ((listing.flags & IS_ACTIVE) == 0) revert NotForSale();

        uint96 price = listing.price;

        if (msg.value != price) revert IncorrectPrice();

        uint256 fee = (msg.value * platformFeePercentage) / 10_000;
        uint256 sellerAmount = msg.value - fee;

        totalFeesCollected += fee;
        listing.flags &= ~IS_ACTIVE;

        IERC721(nftAddress).safeTransferFrom(listing.seller, msg.sender, tokenId);

        (bool success, ) = payable(listing.seller).call{value: sellerAmount}("");
        if (!success) revert TransferFailed();

        emit NFTSold(msg.sender, nftAddress, tokenId, price);
    }


    function cancelListing(address nftAddress, uint256 tokenId) external {
        Listing storage listing = _listings[nftAddress][tokenId];

        if ((listing.flags & IS_ACTIVE) == 0) revert ListingInactive();

        if (listing.seller != msg.sender && msg.sender != owner) revert NotSeller();

        listing.flags &= ~IS_ACTIVE;

        emit ListingCancelled(msg.sender, nftAddress, tokenId);
    }


    /* ---------- Owner ---------- */

    function setPlatformFee(uint16 newFee) external {
        if (msg.sender != owner) revert NotOwner();
        if (newFee > 1000) revert MaxFeeExceeded();

        emit PlatformFeeUpdated(platformFeePercentage, newFee);
        platformFeePercentage = newFee;
    }

    function withdrawFees() external {
        if (msg.sender != owner) revert NotOwner();

        uint256 fees = totalFeesCollected;
        if (fees == 0) revert NoFees();

        totalFeesCollected = 0;

        (bool success, ) = payable(msg.sender).call{value: fees}("");
        if (!success) revert TransferFailed();

        emit FeesWithdrawn(msg.sender, fees);
    }


    receive() external payable {}
}
