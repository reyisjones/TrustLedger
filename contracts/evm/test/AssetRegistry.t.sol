// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/AssetRegistry.sol";

contract AssetRegistryTest is Test {
    AssetRegistry registry;

    function setUp() public {
        registry = new AssetRegistry();
        registry.initialize();
    }

    function testRegisterAsset() public {
        bytes32 contentHash = keccak256("test content");
        string memory metadataURI = "ipfs://test";
        uint256 assetId = registry.registerAsset(contentHash, metadataURI);
        assertEq(assetId, 1);
        (uint256 id, address owner, bytes32 hash, string memory uri, uint256 createdAt, bool active) = registry.assets(assetId);
        assertEq(id, 1);
        assertEq(owner, address(this));
        assertEq(hash, contentHash);
        assertEq(uri, metadataURI);
        assertTrue(active);
    }

    function testUpdateMetadata() public {
        bytes32 contentHash = keccak256("test content");
        string memory metadataURI = "ipfs://test";
        uint256 assetId = registry.registerAsset(contentHash, metadataURI);
        string memory newURI = "ipfs://new";
        registry.updateMetadata(assetId, newURI);
        (, , , string memory uri, , ) = registry.assets(assetId);
        assertEq(uri, newURI);
    }

    function testTransferOwnership() public {
        bytes32 contentHash = keccak256("test content");
        string memory metadataURI = "ipfs://test";
        uint256 assetId = registry.registerAsset(contentHash, metadataURI);
        address newOwner = address(0x123);
        registry.transferOwnership(assetId, newOwner);
        (, address owner, , , , ) = registry.assets(assetId);
        assertEq(owner, newOwner);
    }
}