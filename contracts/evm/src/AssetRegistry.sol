// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

contract AssetRegistry is Initializable, UUPSUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    struct Asset {
        uint256 id;
        address owner;
        bytes32 contentHash;
        string metadataURI;
        uint256 createdAt;
        bool active;
    }

    mapping(uint256 => Asset) public assets;
    uint256 public nextAssetId;

    event AssetRegistered(uint256 indexed assetId, address indexed owner, bytes32 contentHash);
    event MetadataUpdated(uint256 indexed assetId, string newMetadataURI);
    event OwnershipTransferred(uint256 indexed assetId, address indexed previousOwner, address indexed newOwner);
    event AssetDeactivated(uint256 indexed assetId);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __Pausable_init();
        nextAssetId = 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function registerAsset(bytes32 contentHash, string memory metadataURI) external whenNotPaused returns (uint256) {
        uint256 assetId = nextAssetId++;
        assets[assetId] = Asset({
            id: assetId,
            owner: msg.sender,
            contentHash: contentHash,
            metadataURI: metadataURI,
            createdAt: block.timestamp,
            active: true
        });
        emit AssetRegistered(assetId, msg.sender, contentHash);
        return assetId;
    }

    function updateMetadata(uint256 assetId, string memory newMetadataURI) external whenNotPaused {
        require(assets[assetId].owner == msg.sender, "Not owner");
        require(assets[assetId].active, "Asset inactive");
        assets[assetId].metadataURI = newMetadataURI;
        emit MetadataUpdated(assetId, newMetadataURI);
    }

    function transferOwnership(uint256 assetId, address newOwner) external whenNotPaused {
        require(assets[assetId].owner == msg.sender, "Not owner");
        require(assets[assetId].active, "Asset inactive");
        address previousOwner = assets[assetId].owner;
        assets[assetId].owner = newOwner;
        emit OwnershipTransferred(assetId, previousOwner, newOwner);
    }

    function deactivateAsset(uint256 assetId) external {
        require(assets[assetId].owner == msg.sender || owner() == msg.sender, "Not authorized");
        assets[assetId].active = false;
        emit AssetDeactivated(assetId);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}