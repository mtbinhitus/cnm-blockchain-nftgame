// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error PepeCards__NotEnoughMintFee();
error PepeCards__WithdrawalFailed();

contract PepeCards is VRFConsumerBaseV2, ERC721URIStorage, Ownable {
    // NFT variables
    uint256 internal immutable i_mintFee;
    mapping(uint256 => address) public s_requestIdToSender; // a mapping from requestId to the address that made that request
    uint256 private s_tokenCounter;
    uint256[] offset = [0, 36, 63, 84, 93, 97];
    string[] internal s_pepeTokenURIs = [
        "ipfs://QmXYxYTHdSVrRwdapUDvKyeovCGLPNXyoBCV8BvpLyvqLk",
        "ipfs://QmNrX3mCeTa6F25SqLKyVS54rNGLp5T38MEgbSmUQkfbWf",
        "ipfs://QmbALhZ8fpPFcKFUPgbrncCWjvbs1nT9og7F7DoQ7ihWvK",
        "ipfs://QmTF1zkQKhuF96nsBPDDpMNrsKtuFaPAHLLjY5w2KhP4jw",
        "ipfs://QmWPmW3UAVR4viAxaTiC4mHGadhj5Xu5Gx1U5gfdhW5oCd",
        "ipfs://QmNjvGPrFwa9DM2BgrQPMtVuaYPtxJYDi8Rrud5aeGxcKh",
        "ipfs://Qma9iPnNz9KzShv2kdpbNWm1u7AcoT5zrBT3hW5D2EbsG1",
        "ipfs://QmS55HaH8NKqrYRUPY9RL2ostw2JrMtGLyEDkgHuG8yAeb",
        "ipfs://QmW1ayEBfLvzxKymo4hGPYmmkyxzWBegDikrVg5g2K7pcs",
        "ipfs://QmcJnjtby2sdE8hdr5TptrhPtTwj1Jtow7fEdSYUHp3uTm",
        "ipfs://QmQvRppNcukLy8E66h87tT6HeeRCf1EjdP86RNrLfamezv",
        "ipfs://QmdsW9fxjzqvSaAUrMPYrwEmkgC8ftPm6abLFRDQf749GU",
        "ipfs://QmbZQLX3ErwHL9QhYDfR4dtHfMvm8Mo3gSqyEwrVcAw5aA",
        "ipfs://QmRuZjPYQP1AtpRq4c1CJgiccJXSc9nRvKwoDoqg8m8iVR",
        "ipfs://QmPNZJrJjYjwky9K5gZksi1Eok6o2i2mXF4N2rXP2Fwcj8",
        "ipfs://QmXYoKfDpQrRXBxgrDduzUkTiCX9wNGmu6PctJgHWyG1Yc",
        "ipfs://QmZX86KGow2XLJeirtT8Xgo5FH2hKWHrRUPadX4KC4Ygfb",
        "ipfs://QmaN1Rvq9isferPsbTGciVUfeLD5RerzCTtYenHWxLnGCq",
        "ipfs://QmYkvNBeAd8yEGUoopc6i1WsTSSNzsGgfZxcDSkYRYk4Yr",
        "ipfs://Qmdxe4gDNAjqkB9xbUN9w9idTBuD5hrPsJwLtyccxk6MGj",
        "ipfs://QmeUym98Cp8VdRLVWVh1F5uMjXaFwbqnA9vw8sv6HQKMfx",
        "ipfs://QmSnwhNMXyiw5pKZ4BPWzdrZVQhpTHR8jhC5rPutyRy5oo",
        "ipfs://QmXvZ6awVLwd2ZqL4YERW1ViEK9yV34GB9XAbP3XgWBNum",
        "ipfs://QmT3P2dutH26YJQ3A7ebU9wAi49tCsQ1maRb9MwUD9Wc1w",
        "ipfs://QmbWbjBZdi47P98C7Mtf2hmhdrmcCALkjFWd6Y4fRLEEZ4",
        "ipfs://QmYowrb9Dn3oWsuQgF8912SQ7KHrSPWGiFaEai4T9Ntb6f",
        "ipfs://QmWD9sEoyvNvpQiPrpRWej1F69DKjvmF2HbSMFby5tj72T",
        "ipfs://Qmc11orKQg4TyHZx2hKU7wYhjy4Zww9pJw9L5aBcRuuKK7",
        "ipfs://QmSAZkbWnTL62nTqoAFr3ihyrRLQ5ffN9zDrhgyqQQdQGc",
        "ipfs://Qmb7JhnEFVbTUneHzdXQ7fBLjHtuYmxdEucoF8s92F22jf",
        "ipfs://QmP2FEjLjwL5DKLwk4rtizs5jB5coxVs8ctoeQAg1SJVW6",
        "ipfs://QmZC4PMMVqFYWUHZjY2sEKMqYtT3SgSHkWBKDqte1bTM23",
        "ipfs://QmWYu4xyxBdTTU6qZyXoRxDej5jpysxqgXo5KUcGH2nhrD",
        "ipfs://QmZ3pSeGmBh3sGUsDNSo786CumaxzZUQm2gcVBX9yA2eEF",
        "ipfs://Qmc6QEMLPW2pJpaPGBkfUmNWxTzXkrWCu4B1KvHrzMQWCi",
        "ipfs://QmRMcPFmjSDRTNGqeUZzqLtenXLVvD4P3Svvj7gFRwzBan",
        "ipfs://QmS9WXbuDRdK4DvNY6WevcHKgFY7ELaA27AUtKogUVZ1qZ",
        "ipfs://QmTBC8cYE5VuNfYaJqLKGhSg6EiyHjZafMdz2CnHZe7nrD",
        "ipfs://QmWzuWMBfNWQz3EkTGRDnexemQyfWXr8kqhMdjfULqAdSE",
        "ipfs://QmYmugUQwCFDwavJNtLWjTNH4MezRMBCB2oJ18VLGqZUeE",
        "ipfs://QmNuVE77Si8c85jEihM2aTzrWeyLcoq6cogdMNXAg4moG9",
        "ipfs://QmSvgRm7BE1qnoSDW51fwq6XZniP9deEQ4ToRNjttqceGm",
        "ipfs://QmX1jUaw7Fo48MEzdepE2ysYaSD1woUes62YCXyFZow8g9",
        "ipfs://QmdWiJTejChswuVfSZNr3ddES3EFFYas9VJP6urujn49Fs",
        "ipfs://QmPjZDWvnJ4NiVDqqhGZivKDjgNSqi7y3CStoGS7bNknvh",
        "ipfs://QmVrV3BSi1KdWEmnosyYu4H9goYt4vwwXNLocbV9YPxB6j",
        "ipfs://QmNTbV2Ce8KWSmhZdhGBNbTDpjkNuGK5rH3RQHx728hMLJ",
        "ipfs://QmW8nE2hYJq3k1XZcnBhCA5biLuuBahQvA5zT4n2FNmuV3",
        "ipfs://QmY7uPjVozMoRPrhBR5neU1bD1XWArgGeW3Lyo7tvzyWk8",
        "ipfs://Qma2C8eqSu1nghqzz6fFZbUrTC6h31GL4zuUfxDMawwkU3",
        "ipfs://QmZbWf5z2xKPTktjFqLjhnwuu2JkSW5GxF9k8byoPDjN7f",
        "ipfs://QmfMo4omK7V4i6cJA71jJbdVZfmjTCDHsyP2KHZsd3TkPE",
        "ipfs://QmRaAMkJ9wWABfDZjgP518u7zDF9qPmLpeC6mAyYeaiojD",
        "ipfs://QmQUsqG4ckKvcdm43SDTWiRJnxXgvdQF6UvN8C83YTzugm",
        "ipfs://QmZk96u95SDTngHgHsF9cJHxqGGaWmJNqLRg3W6jvpGJU1",
        "ipfs://QmNVmbaqB2TFaQFLmhSJaYjEMtSLxYQ4eALe8hGSLVg2m8",
        "ipfs://QmXLxTm8dfHTMKL6XumfK1iN8SHjvbx4k7HDETM73iGTYH",
        "ipfs://QmNaaSRGBCUzDYNZwukuKn3VJzZ51Ke7C2eNagBCTmWEa2",
        "ipfs://QmUKbyhEFFQsWZfS4G4izjP1GSz9RgX6WK62UK9oQAeKje",
        "ipfs://QmZLw2mXapN2P4T7juq69ey1Pq1UC5YEh9ScUPuRapspKr",
        "ipfs://QmeF9SgMzx8ZXzE2vT9NEFybkyJniXVXTLvA7riVu2qXsN",
        "ipfs://QmRphkb7DUbNKxy4d2gqTUBPLVGyrZyAHeuNa7TRZSMFq3",
        "ipfs://QmXo3jEUyhp9eyJ8BFepXpdccLT78Sm7yCffS6JQacTJbv",
        "ipfs://QmZFBACxdJ6SG3M32Zp29t5BTJVDp2TZMQ8ZBV9GcYbQzg",
        "ipfs://QmUvUis9AhZJsuM6LAUwRvai4mCoan297bYc2pUbpsrQw2",
        "ipfs://QmWhJQLRvLSv4eYWQV395eX1b3QdVBYN7SDJFqz46D7MH6",
        "ipfs://QmcjBLvS9mezTakLGyhZjcP1Nu1Rk9nTgQGgsSsWKrPvhc",
        "ipfs://QmZ6PMME7wHLLJEwmo3Pd44LhV9KhrehSVPm3boJDfeM5J",
        "ipfs://QmaKe9fRF65MNABhBQn38uvCZgvuqg6EyGJwAj1wT64f4D",
        "ipfs://QmZBetu2aCeMuD7H75zgy2TopssyQGyVkRASjBjxkt2peN",
        "ipfs://QmbAStZEWeHyjZwN5Y9VPsbSZ82ubKTMQhj3pB8vMLRS6y",
        "ipfs://Qmf3rNEqjwDQdnpaLc6yqHTUXNMCv3YdRZZc7Leb5BhFDP",
        "ipfs://QmQhGVJ2XZjsQgnVRas9VumyRV8ZVTAoZEXx4ADmtC54gt",
        "ipfs://QmQ5wj5ACHqTHbByPmA7RsVaoF56F56nEmyH9GS2gkPFSG",
        "ipfs://QmebYvTJWAYPzx5NYHsBJNCyDbrPaX2qFFfjxxeepvVyRp",
        "ipfs://QmWfg8VLM6xkDoruVasAtf9cFMxJjzN69irHiWvsvbVGuk",
        "ipfs://Qmbit9sjA4kVMK6bRUnCw6QaU5ztyVtW9oC2Yb791woZDV",
        "ipfs://QmNqcKjD2dSXr41dXAM8Fm4yKHbpP9rQ4KK4JZHnBMbdEf",
        "ipfs://QmRKmRmyvZM9r7dkAEMU4QJMGT2Xe28iKoMqFajnMfjMnJ",
        "ipfs://QmanM2krRyieERZWUqeXJigwSoTKfmDe5efXBgHSeRsNvs",
        "ipfs://QmfTjPqMiHQs9w7qVtdAFKDQiFrkBVRV7ErtadNWKNcdGU",
        "ipfs://QmQ63oZ6JcZ3U1hBGTp8ZXQvuoNzDYVRfitRru8qVyL6Gm",
        "ipfs://QmZpX6WvWtipNf6AdT9qEzFUfRgxKA9bm4DjspVbPx9igE",
        "ipfs://QmSQtRJBFok4JmeexTi4VwQcR68hfV2jng8pZdEBH63yjB",
        "ipfs://QmQWxmz15Sj6cFTGm7d8TjVACvA4NAVf4Li132Gs3XLySg",
        "ipfs://QmWu7DzC34fb9WLjCtV1tKhjrJuLv5sGeKJ2YAYGsMU5gT",
        "ipfs://QmeNdojDkhK83KziengZmEb35s8rqrkN7v76NYRajqz1SW",
        "ipfs://QmZLtxz7XGVRs8kQJZejjwbi6nebNCXXDmK62HBHwdjtuz",
        "ipfs://QmPcWpc3sBE7AA6F3gPu5X8BoFsea8JTHqVesgpfd4a7ZF",
        "ipfs://Qmf4r3efFAqLVmpMpzC1HW6H5in2TKWqyoCUpFRzFf5tmq",
        "ipfs://QmQFnWvDvqQtVfxJtnDqYWnn1PJkB2oAZCVVZt6ifWfry7",
        "ipfs://QmZTnuMz58U5trPwXsNpmyqPhTtHt4BoJiiAMXFuUeP4rX",
        "ipfs://QmPTebgchrNWhPyM9iSJvAP2pPepfEWGBXr7hMt8Jx5o9R",
        "ipfs://QmPRTeVv9EgcNiPvS3HtXpcyfuhqyBby91AjV6i3zq1GME",
        "ipfs://QmZk5TAr7EmxiTp1nYfs3zoGoni49JWsco636ZCAuQdUnK",
        "ipfs://QmWmyjGcPmUEwWUmv8cui26vDte189wkvkm9tBdfkDo6Xe",
        "ipfs://QmcSc8DytbEdRzpT5VhDbgRx2Nbq892KYKha78Z7UYWhd2"
    ]; // [LEGENDARY, EPIC, RARE, UNCOMMON, COMMON]

    enum PepeType {
        LEGENDARY,
        EPIC,
        RARE,
        UNCOMMON,
        COMMON
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
    event NftMinted(PepeType pepeType, address minter);

    constructor(
        uint256 mintFee,
        address vrfCoordinatorV2Address,
        uint64 subId,
        bytes32 keyHash,
        uint32 callbackGasLimit
    )
        VRFConsumerBaseV2(vrfCoordinatorV2Address)
        ERC721("Pepe Cards", "PEPEV23")
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
            revert PepeCards__NotEnoughMintFee();
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

    // Off-chain Chainlink VRF
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

        PepeType pepeType = getPepeRarity(randomNumber); // get which random Card to mint
        // Get index array nft by rarity type
        uint256 index = getRandomCardByRarity(pepeType);
    
        _safeMint(nftOwner, tokenId); // finally, mint the NFT using _safeMint function

        // set Token URI of that particular NFT
        if(pepeType == PepeType.COMMON)
            index = index + offset[0];
        else if (pepeType == PepeType.UNCOMMON)
            index = index + offset[1];
        else if (pepeType == PepeType.RARE)
            index = index + offset[2];
        else if (pepeType == PepeType.EPIC)
            index = index + offset[3];
        else if (pepeType == PepeType.LEGENDARY)
            index = index + offset[4];

        _setTokenURI(tokenId, s_pepeTokenURIs[index]); // takes tokenID and tokenURI
        s_tokenCounter += 1; // increment the token count

        // emit event
        emit NftMinted(pepeType, nftOwner);
    }

    function getPepeRarity(
        uint256 randomNumber
    ) public pure returns (PepeType) {
        uint256 cumulativeSum = 0;
        uint8[5] memory chanceArray = getChanceArray();

        // loop through chanceArray: [5, 20, 40, 65, 100]
        for (uint256 i = 0; i < chanceArray.length; i++) {
            if (
                randomNumber >= cumulativeSum && randomNumber < chanceArray[i]
            ) {
                return PepeType(i);
            }
            cumulativeSum = chanceArray[i];
        }
    }

    function getChanceArray() public pure returns (uint8[5] memory) {
        // Tỷ lệ
        // Legendary: 5%
        // Epic: 15%
        // Rare: 20%
        // Uncommon: 25%
        // Common: 35%
        return [5, 20, 40, 65, 100];
    }

    // On-chain data
    function getRandomCardByRarity(PepeType pepeType) private view returns (uint256) {
        // common:start->hết 7mb: 36 files
        // uncommon:8mb->hết 10mb: 27 files
        // rare:11mb->hết 13mb: 21 files
        // epic:14mb->hết 14mb: 9 files
        // legendary:15mb->end: 4 files

        // Needed to be + 1 to make impossible to predict
        uint256 targetBlock = block.number + 1;
        require(block.number > targetBlock, "Target block not arrived");

        uint256 seed = uint256(blockhash(targetBlock));
        // Ethereum blockchain only allows access to the 256 most recent blocks
        // in a real scenario, a revert case should be implement in case that blockhash is not available anymore
        require(seed != 0, "Hash block isn't available");
        uint256 tokenId = s_tokenCounter + 1;
        uint256 randomNumber = uint256(keccak256(abi.encode(seed, tokenId)));

        // Check type to get chance of type nft
        if(pepeType == PepeType.COMMON)
            return randomNumber % 36;
        else if (pepeType == PepeType.UNCOMMON)
            return randomNumber % 27;
        else if (pepeType == PepeType.RARE)
            return randomNumber % 21;
        else if (pepeType == PepeType.EPIC)
            return randomNumber % 9;
        else if (pepeType == PepeType.LEGENDARY)
            return randomNumber % 4;

        return randomNumber % 36;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: amount}("");

        if (!success) {
            revert PepeCards__WithdrawalFailed();
        }
    }

    // View Functions
    function getMintFee() public view returns (uint256) {
        return i_mintFee;
    }

    function getTokenURIs(uint256 index) public view returns (string memory) {
        return s_pepeTokenURIs[index];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
