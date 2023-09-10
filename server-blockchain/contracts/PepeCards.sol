// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error PepeCard__NotEnoughMintFee();
error PepeCard__WithdrawalFailed();

contract PepeCards is VRFConsumerBaseV2, ERC721URIStorage, Ownable {
    // NFT variables
    uint256 internal immutable i_mintFee;
    mapping(uint256 => address) public s_requestIdToSender; // a mapping from requestId to the address that made that request
    uint256 private s_tokenCounter;
    uint256[] internal offset = [0, 37, 65, 86, 95, 99];
    string[] internal s_pepeTokenURIs = [
        "ipfs://QmcXzSP6VVKY3yMH5dQXDqiiUfwP8Z7exyvZZa9BwcFNk9",
        "ipfs://QmV41XEh6S1Ggh1Gr9w81gW4K2BSMi7PzvEDtQL5Y9daEh",
        "ipfs://QmWMN3pmwqkxgY6Co7Wno3vfTaMWAD4enHNrdiY8DTkbYp",
        "ipfs://QmTWvjfhEfY6vMBBJ97MNRctYDoicUSYQup6Nnz8bH6uNC",
        "ipfs://QmTCyWtcXyZmHzszwhejW2F4G1ApjN7BFKcghm65mb23fv",
        "ipfs://QmTVQ3BYTqker6DKv7hwv4EGhznXXK5tV9iwgppoHDt2jw",
        "ipfs://QmREwJCJrfX9oGEGWU6mmmazFCjJWuPu37knN2yfqjjiCE",
        "ipfs://QmTVmoh5qTuiC13hTbArtCZHdS5zJF6zcCW8bJokVvgz8Z",
        "ipfs://QmUTiDcGQBy1VZHdMfZ9ivKv6EucTQmkA1rxWsXwEyUE3a",
        "ipfs://QmTxz9xAJLAkwZ4W9xd8CfK6TyPZ4BrRL1CEcbDAjvQREP",
        "ipfs://QmYQGJh1dAje6F5cXMDGo2UU6ZgfoH5EPZ5MwHRD4GWwU5",
        "ipfs://QmVkZwj3EremdLwu2xvpEwHNa9qa6cmytbUo88rXv8cX23",
        "ipfs://QmNvcLYsoAbfMdmuMDeVe6GSEfnf4sjQci3tTVAiCpGWnV",
        "ipfs://QmVo26u8PCcpE597BJd46HSHPwUMKEVoop8EBcqxuX7kTA",
        "ipfs://Qmb97k9QPVQSsidymo3h5FTyDknPqfmdjPJQv4mWwBQodF",
        "ipfs://QmWprDQWLDaR35PciFzs3vvuCLmk3myGTbGcmMc3mzKrdL",
        "ipfs://QmTr1aPojNkdWeoY1ZcKaHDUy32QCin68tcbZiBzpWgZJx",
        "ipfs://QmRaThsFc3XRYYpD4DP5vvWCTyih7AsirXA2rUwZXv8YDk",
        "ipfs://QmdywyJP1dobtPeBeRDpNJyMuBgttUme2sayHvmYHdjqgq",
        "ipfs://QmWAtf7VM8qNDwmUiNKu9KyCyrjvipm681b75VHHjJaAzE",
        "ipfs://QmauN2giNLo2VRDCb2RgVmh4BJvbLA2FNb5ud7viqoe3hU",
        "ipfs://QmWFBvHSUNUDjk7K17GEfxBYzeFcWQokUNPLqUDq8hMCds",
        "ipfs://QmdTVKHcTTikMgBRotxov4GrXiK9eo6fgFXqKQbBzjXBnP",
        "ipfs://QmYenSkUReJzEWSpQuzTyyUFgoJVsA6jYEg4Ad6a1oEB9t",
        "ipfs://QmXCt67tNf5UKBgC14HPEkpSq4CetnDrzQVejtTv17MybL",
        "ipfs://Qmbo6XYE8SfpTD9xRxcdjvriE8ohF7UohYcdSkmG9Yw1XH",
        "ipfs://QmT5jyG4JpkKzfm9CJHGWyhx1ChmDz9ijNvFfe1Ng5sTKt",
        "ipfs://QmW7x3cVgYC7a58e2TXGUpQmH1orfmUfQuTwH57DyVNS4t",
        "ipfs://QmeUf2vbdzxf3NMSukWmmpou5Me5A1LNqmfPEh85ZFs3iT",
        "ipfs://QmPTATpHmU25kx7XCsA41m2G6pv13x1RSXd8rgdFu63z91",
        "ipfs://QmfNuaKqG2wtVdjC5RxuJyKkSgumVMjatwb57XR7tncN84",
        "ipfs://QmXPd2Db9LPcTbu4Mf223Sqrg1VaUADGvo3HuzBCJy9vhU",
        "ipfs://QmZXkeFfTzXS56tTN2A6Ww84BUrza2dMXuKF5axPk2Djxt",
        "ipfs://QmbXnW7ZcZ1rpyKjiad9kh8gq3JR35b64SeJyLurXHwsXT",
        "ipfs://QmfYnyYCNHeWCq7u7NEN7W6BLowKtFTV3ETAcGxhfc7tRz",
        "ipfs://QmcN9CFvCUWkCyzYHQ7oxWVs7WJEMsbx2cvd86pTM8nhbb",
        "ipfs://QmQx8SeFX9kD9UKu5cYZeE5eiYGHYFVW7nAYha7KeK4EMx",
        "ipfs://QmfK6ax8mZoVyFHVMWFNWaXy4L6ULTcV7ZdsanHFYrupnb",
        "ipfs://QmNrfjerZXC5TLrzF2gnWYjNfzutrXxERCR6FaUkQcVntM",
        "ipfs://Qme8S5oJsb93Toh8xYUEt5Mwk7EE7h2NgvCq9ugJ7hyJbS",
        "ipfs://QmZFJjas2QMp29AwcvSQBueMEKKZUnoFKMmJuYnKTwHhGt",
        "ipfs://QmTp9xkLdWzEXRRPGLFYUajttSZs1edMrraDd8hmaYFjHx",
        "ipfs://QmY2kAGtgwKgA8hkxGJ5ut7zkKB6BQbUAvMxzzZbDn8pk2",
        "ipfs://QmNaEPHV4evAXt8Jbn5jpKjpUQC2v8oNEYN6BBAw1Ueyfj",
        "ipfs://QmWcpqypNfcijeX9YVg1D7Z4BMNVKyo7Cws4mLMAr8Q5kz",
        "ipfs://QmQLN6N2n6GHDE17JVXk1E8CSpHhFNkr5JFH7tMBJjoFc8",
        "ipfs://QmQwfLythU2SAc4JMT3i8oYmvHRkezt12aYhdofKWJQTdD",
        "ipfs://QmdRqpRtYFg8rAVtQWG4QwKuTHdNj64KiHorbpUCVj3jFW",
        "ipfs://QmdYndSmF5fRE685Vqc2TTX5Bvat9UhEYzkw6s9cSD2LmL",
        "ipfs://QmNV28rLaPUi3sY2FxRwiVtRjvadDWtcRSveF8mFEyYTKu",
        "ipfs://QmYztwSdku84dVDAMtKmtwyUc1PfzJEZiEprQSxYHHoEpd",
        "ipfs://QmPwEGESJgwyP9mZwPEqTvYKAFyoE4q1DBwAKuBW2WzXYH",
        "ipfs://QmckXYFAba4u8aabD9k7oawB2YadnoZoYDhjjV4PHEem3B",
        "ipfs://QmYN3Rp4Lur6C9Rp91W7ywTsUeJwUt64MySvZQP3Mtnj39",
        "ipfs://QmVJ4FaDJJYs7R4DniTrNmG7jD2NBUBttWYzAsmLG7Y6qD",
        "ipfs://QmeVescHij6nw9xZeDxbqW13ALud4A2C6jUEL3z5gnUH6P",
        "ipfs://QmdCch1rGyujVBxesGDG57uHaPSxJ9LiFK6HThzS6oB7GR",
        "ipfs://QmRvWa4NLcLeLVu64Fya1LruVV7SdnKqrDF2s5xNdwdDm6",
        "ipfs://QmPyVgsexxhqTUme5pA9ts3mgweAsLGwZuJEjL9p7ULE8x",
        "ipfs://QmV42aEb7rKSdGihv78eEdF1cEekaUxT1kZxRVhhbhB8b4",
        "ipfs://QmS8QeupuHXavLWWaPMHxn4LLq6UrZi7RQyU7N2hgH4tBB",
        "ipfs://QmNcx7BoHev3HAmPXpGHq99CK5ePRfr6oxVGDneNkzLP5J",
        "ipfs://QmVLfEHxiK8knfA3vYR8Lr6YfCeGPqWoXtBnq76sNFS3zw",
        "ipfs://QmcVbQim6aNZKLAaUSNuCKAZzD5jNQZfakfNsj7oGoH6ia",
        "ipfs://QmWCDtK8kXopJnsEq9TGVWeCAJd6gJ6JwgWoEpqnVoj94A",
        "ipfs://QmPLUP71SorxqYRehSsxTdcdTC8dVDMDsbQUz5y15qJAhd",
        "ipfs://QmNm3vTZxSyQmgfWu5Ygkh2RRSgW52zaKanRZ3FnFJU556",
        "ipfs://QmWe851iDeMo9QUA93BwtofGrNeLBmVo3RSBQ3acRJp1Y8",
        "ipfs://QmSssW2HC1vMbh31YbFnnCTxvTY9jpikKd1obYm2y4NZzb",
        "ipfs://Qmf7feqUtUKQtgzLWg2h1Qn1iVWqSdxoNUtCF9PcEeKADJ",
        "ipfs://Qmbb1obB9mtsBCzFHrwwmshgCHNiARnLtnK1HYHxaUb1MM",
        "ipfs://Qmb1xgxbvfvaLJL5Qzt53DZjim2VLCrtwnvJ5gT3Kw4fxu",
        "ipfs://QmdpZJ7eaLxEamMEmUB6yeghwww9jWRnL5MSUc1U76Mu5a",
        "ipfs://QmUYYsYXb47Ria5CFwu19bJrxKFfXLdfQUw97a3eG3uZsS",
        "ipfs://QmZ1R5dAnfHCnbdo8S9dpDyMZy42kuGSAPcdPA9tyi3wpr",
        "ipfs://QmRwNeEHZbAMLgPTBBU2i99y5b4Q9ag4YYWXcSWT6Mu7Sn",
        "ipfs://QmcoK4RUvemZR4YQTqvhTgG6YdvQdWtTasQNFwqfW6akv2",
        "ipfs://QmUdUwoZrxFJJqkyw1b6AN8iUJS8BG1UqR8RxAeAcnszV2",
        "ipfs://QmVgbZD3fQromjchN3pkRSuXfv6XQtnRZh7cUQpH1QhrVU",
        "ipfs://QmTWLoSxTuns4V69Gn4U41ZguC31CoiUysUVVZzge2YUpu",
        "ipfs://QmYN643zj1hAov7Dhh3dRbo8K6km3BpThQHm2Ehb1h9gkE",
        "ipfs://QmXNaqJtSdwYomEgV5tyM1oszgy8Lzh4waGiisaUtPcRsr",
        "ipfs://QmeKoXSgJKYUaGdBnytzLcCdDdzVGXkoeTBviLahQ7aQ7Z",
        "ipfs://QmWZcLgoE5pBrwwnTJJhwzQpWK4Yyuqwx6Un4uJBD42v7N",
        "ipfs://QmPNwGbboCvykUyvBVcCTCSL9H31GAUgAhRwmTfKaUnwkB",
        "ipfs://QmSvtUEXaktcuXU3JGdHtKW8KE6EkFLZRGfPagWvjDnrE1",
        "ipfs://QmSB9URtQjCqwWEx7Pq3aEun35ZZ3ou3GXMR55h5NAMxCJ",
        "ipfs://QmS2WcFMV4ePBre8ZGKddFhkniGZwKcJxKmMLc4q9Sb8cd",
        "ipfs://QmeDKcxP29ewhXJYpyWg6hbs7vi7WD17g5UoYdjad9HjEq",
        "ipfs://QmVqfRw7DdH77tBUAMzq9ahtGixy1T7RQ9bfh4F3WbxGHs",
        "ipfs://QmTazwAb8SWmy97foYdj4ZpxGvMmEVaQ5roJdL5WuK4eqd",
        "ipfs://QmcC2CUKyDkznWbt9id8U75HfFwcghG86b7GeVEr1zqsSQ",
        "ipfs://QmeczoF5VVpdoLw1nQQW4bQqsAtK6HKdi4odNhwBtp9BY1",
        "ipfs://QmUbvK3fSjnheemcwwLJnUcPjKpxPdEoFAgAeyRom3dpAV",
        "ipfs://QmP9TGhe1rEiib92QjACCurgsCkChSSjn4EtyRp2Nu7zQK",
        "ipfs://QmUBQNJDb2NjFDP75dbWbiPnoNm7JTAqon1oJv95RoAb6o",
        "ipfs://QmNh7SEP1gjmA75A5hcixerFcPatgKV3w8vkJmc8a4nPKn",
        "ipfs://QmZeZuwNgg1uyZYSaXAzmXYYNEWPSWPdrXvGakChoaa6sg",
        "ipfs://QmSp4vAYEZ16SL3E3ins35oGxmthJSKLHaqHetvA7XuErL"
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
    ) VRFConsumerBaseV2(vrfCoordinatorV2Address) ERC721("Pepe Cards", "PEPE") {
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
            revert PepeCard__NotEnoughMintFee();
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

        PepeType pepeType = getPepeRarity(randomNumber); // get which random Card to mint
        // Get index array nft by rarity type
        uint256 index = getRandomCardByRarity(pepeType);

        _safeMint(nftOwner, tokenId); // finally, mint the NFT using _safeMint function

        // set Token URI of that particular NFT
        if (pepeType == PepeType.COMMON) index = index + offset[0];
        else if (pepeType == PepeType.UNCOMMON) index = index + offset[1];
        else if (pepeType == PepeType.RARE) index = index + offset[2];
        else if (pepeType == PepeType.EPIC) index = index + offset[3];
        else if (pepeType == PepeType.LEGENDARY) index = index + offset[4];

        // set Token URI of that particular NFT
        _setTokenURI(tokenId, s_pepeTokenURIs[index]); // takes tokenID and tokenURI
        s_tokenCounter += 1; // increment the token count

        // emit event
        emit NftMinted(pepeType, nftOwner);
    }

    function getPepeRarity(
        uint256 randomNumber
    ) public pure returns (PepeType rarity) {
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
    function getRandomCardByRarity(
        PepeType pepeType
    ) public view returns (uint256) {
        // common:start->hết 7mb: 37 files
        // uncommon:8mb->hết 10mb: 28 files
        // rare:11mb->hết 13mb: 21 files
        // epic:14mb->hết 14mb: 9 files
        // legendary:15mb->end: 4 files

        uint256 seed = uint256(blockhash(block.number - 1));
        // Ethereum blockchain only allows access to the 256 most recent blocks
        // in a real scenario, a revert case should be implement in case that blockhash is not available anymore
        require(seed != 0, "Hash block isn't available");
        uint256 tokenId = s_tokenCounter + 1;
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    seed,
                    tokenId,
                    block.timestamp,
                    block.difficulty
                )
            )
        );

        // Check type to get chance of type nft
        if (pepeType == PepeType.COMMON) return randomNumber % 37;
        else if (pepeType == PepeType.UNCOMMON) return randomNumber % 28;
        else if (pepeType == PepeType.RARE) return randomNumber % 21;
        else if (pepeType == PepeType.EPIC) return randomNumber % 9;
        else if (pepeType == PepeType.LEGENDARY) return randomNumber % 4;

        return randomNumber % 36;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: amount}("");

        if (!success) {
            revert PepeCard__WithdrawalFailed();
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
