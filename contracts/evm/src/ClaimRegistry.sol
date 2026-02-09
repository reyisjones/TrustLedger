// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

contract ClaimRegistry is Initializable, UUPSUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    struct Claim {
        uint256 id;
        uint256 assetId;
        bytes32 schemaId;
        bytes32 claimHash;
        address subject;
        uint256 createdAt;
    }

    mapping(uint256 => Claim) public claims;
    uint256 public nextClaimId;

    event ClaimSubmitted(uint256 indexed claimId, uint256 indexed assetId, address indexed subject);
    event ClaimUpdated(uint256 indexed claimId, bytes32 newClaimHash);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __Pausable_init();
        nextClaimId = 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function submitClaim(uint256 assetId, bytes32 schemaId, bytes32 claimHash, address subject) external whenNotPaused returns (uint256) {
        uint256 claimId = nextClaimId++;
        claims[claimId] = Claim({
            id: claimId,
            assetId: assetId,
            schemaId: schemaId,
            claimHash: claimHash,
            subject: subject,
            createdAt: block.timestamp
        });
        emit ClaimSubmitted(claimId, assetId, subject);
        return claimId;
    }

    function updateClaim(uint256 claimId, bytes32 newClaimHash) external whenNotPaused {
        require(claims[claimId].subject == msg.sender, "Not subject");
        claims[claimId].claimHash = newClaimHash;
        emit ClaimUpdated(claimId, newClaimHash);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}