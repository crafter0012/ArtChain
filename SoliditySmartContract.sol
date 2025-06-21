// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ArtChainMarketplace {
    address public owner;
    uint256 public artworkCount;

    struct Artwork {
        uint256 id;
        string title;
        string uri;  // Metadata URI for the artwork
        address payable artist;
        uint256 price;
        bool isSold;
    }

    mapping(uint256 => Artwork) public artworks;

    event ArtworkCreated(uint256 id, string title, address artist, uint256 price);
    event ArtworkSold(uint256 id, address buyer, uint256 price);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyArtist(uint256 id) {
        require(msg.sender == artworks[id].artist, "Not the artwork owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        artworkCount = 0;
    }

    // Function to create artwork (mint NFT)
    function createArtwork(string memory _title, string memory _uri, uint256 _price) public {
        artworkCount++;
        artworks[artworkCount] = Artwork(artworkCount, _title, _uri, payable(msg.sender), _price, false);
        emit ArtworkCreated(artworkCount, _title, msg.sender, _price);
    }

    // Function to buy artwork
    function buyArtwork(uint256 _id) public payable {
        Artwork storage artwork = artworks[_id];
        require(!artwork.isSold, "Artwork already sold");
        require(msg.value >= artwork.price, "Insufficient funds");

        artwork.artist.transfer(msg.value);
        artwork.isSold = true;
        emit ArtworkSold(_id, msg.sender, msg.value);
    }

    // Function to change price of artwork (by the artist)
    function changePrice(uint256 _id, uint256 _newPrice) public onlyArtist(_id) {
        artworks[_id].price = _newPrice;
    }
}
