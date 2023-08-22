// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error TrophiesCard__NotEnoughMintFee();
error TrophiesCard__WithdrawalFailed();

contract TrophiesCard is VRFConsumerBaseV2, ERC721URIStorage, Ownable {
    // NFT variables
    uint256 internal immutable i_mintFee;
    mapping(uint256 => address) public s_requestIdToSender; // a mapping from requestId to the address that made that request
    uint256 private s_tokenCounter;
    string[] internal s_trophiesTokenURIs = [
        "ipfs://QmSkuwBSBzw8XvTi8vz6QxSoHbP9FsgJSFwjJHzCcyE8oa", // challender
        "ipfs://QmXyd58R8CYDys33aeJ4W1rUrZKhbQiDPuciXDVawYK8g2", // Grandmaster
        "ipfs://Qmdkpe61wpA45Su27iyZbfhGKYFVoX7wU2itbEK5pDo4Ge", // Master
        "ipfs://QmdE2wgcXxt1tw3aBTjCcsdXgv8qXLZyvvGjQEzVv5cEvX", // Diamond
        "ipfs://QmdYG7hDmQ3FPVPGHM51anB4AkuJEBj78nwEjdFgQ1BhK5", // Platinum
        "ipfs://QmdFnHfYmAXcD1jC2ckagPgygwpZtEod7BMqkGQ4MgaiXE", // golden
        "ipfs://QmVfXFpyaiex8hSZsMhQxehZeR4LggXxiVxFdAf2dN4utF", // Silver
        "ipfs://Qmc1gVyftmknUwWhPMX6qqDnKQrD6iEZZk18mXFtvXbGLa" // Bronze
    ]; // [Hokage, Jonin, Chunin, Genin]

    enum TrophiesType {
        CHALLENGER,
        GRANDMASTER,
        MASTER,
        DIAMOND,
        PLATINUM,
        GOLDEN,
        SILVER,
        BRONZE
    }

    // Chainlink VRF variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId; // get subscription ID from vrf.chain.link
    bytes32 private immutable i_keyHash;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    // Events
    event NftRequested(uint256 indexed requestId, address requester);
    event NftMinted(TrophiesType trophiesType, address minter);

    constructor(
        uint256 mintFee,
        address vrfCoordinatorV2Address,
        uint64 subId,
        bytes32 keyHash,
        uint32 callbackGasLimit
    )
        VRFConsumerBaseV2(vrfCoordinatorV2Address)
        ERC721("Trophies Cards", "TROPHIES")
    {
        i_mintFee = mintFee;
        s_tokenCounter = 0;

        // VRF variables
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2Address);
        i_subscriptionId = subId;
        i_keyHash = keyHash;
        i_callbackGasLimit = callbackGasLimit;
    }

    function requestNFT() public payable returns (uint256 requestId) {
        // check if mintFee is paid
        if (msg.value < i_mintFee) {
            revert TrophiesCard__NotEnoughMintFee();
        }

        requestId = i_vrfCoordinator.requestRandomWords(
            i_keyHash, //
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );

        s_requestIdToSender[requestId] = msg.sender; // map the caller to their respective requestIDs.

        // emit an event
        emit NftRequested(requestId, msg.sender);
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        // Step 1 - figure out nftOwner
        address nftOwner = s_requestIdToSender[requestId]; // map the requestId to whoever sent the request for Randomness

        // Step 2 - mint the NFT
        uint256 tokenId = s_tokenCounter; // assign unique tokenId

        // figure out which NFT to mint
        // create a randomNumber by modding the value provided by VRF through randomWords[] array
        uint256 randomNumber = randomWords[0] % 100; // get a random number between 0 - 99

        TrophiesType trophiesType = getTrophiesRarity(randomNumber); // get which random Card to mint
        _safeMint(nftOwner, tokenId); // finally, mint the NFT using _safeMint function

        // set Token URI of that particular NFT
        _setTokenURI(tokenId, s_trophiesTokenURIs[uint256(trophiesType)]); // takes tokenID and tokenURI
        s_tokenCounter += 1; // increment the token count

        // emit event
        emit NftMinted(trophiesType, nftOwner);
    }

    function getTrophiesRarity(
        uint256 randomNumber
    ) public pure returns (TrophiesType) {
        uint256 cumulativeSum = 0;
        uint8[8] memory chanceArray = getChanceArray();

        // loop through chanceArray: [10,25, 50, 100]
        for (uint256 i = 0; i < chanceArray.length; i++) {
            if (
                randomNumber >= cumulativeSum && randomNumber < chanceArray[i]
            ) {
                return TrophiesType(i);
            }
            cumulativeSum = chanceArray[i];
        }
    }

    function getChanceArray() public pure returns (uint8[8] memory) {
        //         ###tỷ lệ
        // - Challenger: 1%
        // - Grandmaster: 3%
        // - Master: 5%
        // - Diamond: 10%
        // - Platinum: 15%
        // - Golden: 15%
        // - Silver: 20%
        // - Bronze: 31%
        return [1, 4, 9, 19, 34, 49, 69, 100];
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: amount}("");

        if (!success) {
            revert TrophiesCard__WithdrawalFailed();
        }
    }

    // View Functions
    function getMintFee() public view returns (uint256) {
        return i_mintFee;
    }

    function getTokenURIs(uint256 index) public view returns (string memory) {
        return s_trophiesTokenURIs[index];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
