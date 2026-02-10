// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/RightsRegistry.sol";

contract RightsRegistryTest is Test {
    RightsRegistry registry;

    function setUp() public {
        registry = new RightsRegistry();
        registry.initialize();
    }

    function testRegisterWork() public {
        string memory title = "Test Song";
        string memory workType = "composition";
        bytes32 contentHash = keccak256("song content");
        string memory metadataURI = "ipfs://test";

        uint256 workId = registry.registerWork(title, workType, contentHash, metadataURI);
        assertEq(workId, 1);

        (uint256 id, string memory t, string memory wt, address creator, bytes32 hash, string memory uri, uint256 createdAt, bool active) = registry.works(workId);
        assertEq(id, 1);
        assertEq(t, title);
        assertEq(wt, workType);
        assertEq(creator, address(this));
        assertEq(hash, contentHash);
        assertEq(uri, metadataURI);
        assertTrue(active);
    }

    function testCreateSplitSheet() public {
        // Register work first
        uint256 workId = registry.registerWork("Test Song", "composition", keccak256("content"), "ipfs://test");

        // Create contributors
        RightsRegistry.Contributor[] memory contributors = new RightsRegistry.Contributor[](2);
        contributors[0] = RightsRegistry.Contributor({
            contributor: address(0x123),
            role: "composer",
            share: 7000
        });
        contributors[1] = RightsRegistry.Contributor({
            contributor: address(0x456),
            role: "lyricist",
            share: 3000
        });

        uint256 splitId = registry.createSplitSheet(workId, contributors);
        assertEq(splitId, workId);

        RightsRegistry.Contributor[] memory storedContributors = registry.getContributors(workId);
        assertEq(storedContributors.length, 2);
        assertEq(storedContributors[0].share, 7000);
        assertEq(storedContributors[1].share, 3000);
    }

    function testFinalizeSplitSheet() public {
        // Register and create split
        uint256 workId = registry.registerWork("Test Song", "composition", keccak256("content"), "ipfs://test");
        RightsRegistry.Contributor[] memory contributors = new RightsRegistry.Contributor[](1);
        contributors[0] = RightsRegistry.Contributor({
            contributor: address(this),
            role: "composer",
            share: 10000
        });
        registry.createSplitSheet(workId, contributors);

        // Finalize
        registry.finalizeSplitSheet(workId);

        (,,,,, bool finalized) = registry.splitSheets(workId);
        assertTrue(finalized);
    }
}