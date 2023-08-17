pragma solidity ^0.8.2;

contract ERC721 {
    // event Transfer(
    //     address indexed _from,
    //     address indexed _to,
    //     uint256 indexed _tokenId
    // );

    // event Approval(
    //     address indexed _owner,
    //     address indexed _approved,
    //     uint256 indexed _tokenId
    // );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    // function safeTransferFrom(
    //     address _from,
    //     address _to,
    //     uint256 _tokenId,
    //     bytes data
    // ) external payable;

    // function safeTransferFrom(
    //     address _from,
    //     address _to,
    //     uint256 _tokenId
    // ) external payable;

    // function transferFrom(
    //     address _from,
    //     address _to,
    //     uint256 _tokenId
    // ) external payable;

    // function approve(address _approved, uint256 _tokenId) external payable;

    // function getApproved(uint256 _tokenId) external view returns (address);

    mapping(address => uint256) internal _balances;
    mapping(uint256 => address) internal _owners;
    mapping(address => mapping(address => bool)) private _operatorApprivals;

    //return number of NFTs of an user
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "Address is zero"); // check for standard ERC721
        return _balances[owner];
    }

    //Find owner of an NFT
    function ownerOf(uint256 tokenId) external view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token Id is not exits"); // check for standard ERC721

        return owner;
    }

    // enable or disable an operator
    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprivals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // check if an address is an operator for another address
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool) {

        return _operatorApprivals[owner][operator];
    }
}
