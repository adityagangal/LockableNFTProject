// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title LockableNFT
 * @dev Extends ERC721 and Ownable contracts from OpenZeppelin. Provides functionality to lock and unlock tokens within an ERC721 collection.
 */
contract LockableNFT is ERC721, Ownable {
    using Strings for uint256;

    // Mapping to track the locked status of each token
    mapping(uint256 => bool) private _isTokenLocked;

    // Whitelisted addresses allowed to claim and unlock tokens
    mapping(address => bool) private _whitelist;

    /**
     * @dev Constructor to initialize the LockableNFT contract.
     * @param _name The name of the ERC721 token.
     * @param _symbol The symbol of the ERC721 token.
     */
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender) {}

    /**
     * @dev Checks if a token is currently locked.
     * @param tokenId The ID of the token to check.
     * @return A boolean indicating whether the token is locked or not.
     */
    function isTokenLocked(uint256 tokenId) external view returns (bool) {
        return _isTokenLocked[tokenId];
    }

    /**
     * @dev Locks a specific token, restricting its transfer.
     * @param tokenId The ID of the token to be locked.
     */
    function lockToken(uint256 tokenId) external onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        _isTokenLocked[tokenId] = true;
    }

    /**
     * @dev Unlocks a specific token, allowing its transfer.
     * @param tokenId The ID of the token to be unlocked.
     */
    function unlockToken(uint256 tokenId) external onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        _isTokenLocked[tokenId] = false;
    }

    /**
     * @dev Whitelists an account to allow claiming and unlocking tokens.
     * @param account The address to be whitelisted.
     */
    function whitelistAccount(address account) external onlyOwner {
        _whitelist[account] = true;
    }

    /**
     * @dev Allows a whitelisted account to claim and unlock a token held by the contract.
     * @param tokenId The ID of the token to be claimed and unlocked.
     */
    function claimAndUnlock(uint256 tokenId) external {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == address(this), "Token not owned by contract");
        require(_whitelist[msg.sender], "Account not whitelisted");

        _isTokenLocked[tokenId] = false;

        _safeTransfer(address(this), msg.sender, tokenId);
    }

    /**
     * @dev Overrides the safeTransferFrom function of ERC721 to restrict transfer of locked tokens.
     * @param from The address transferring the token.
     * @param to The address receiving the token.
     * @param tokenId The ID of the token being transferred.
     * @param _data Additional data to send along with the token transfer.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        require(!_isTokenLocked[tokenId] || msg.sender == owner(), "Token is locked");
        super.safeTransferFrom(from, to, tokenId, _data);
    }
    
    /**
     * @dev Internal function to check if a token exists.
     * @param tokenId The ID of the token to check.
     * @return A boolean indicating whether the token exists or not.
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        return ownerOf(tokenId) != address(0);
    }
}
