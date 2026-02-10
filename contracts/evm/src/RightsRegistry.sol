// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

contract RightsRegistry is Initializable, UUPSUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    struct Work {
        uint256 id;
        string title;
        string workType; // "composition", "recording", "video", etc.
        address creator;
        bytes32 contentHash;
        string metadataURI; // IPFS/Arweave link
        uint256 createdAt;
        bool active;
    }

    struct Contributor {
        address contributor;
        string role; // "composer", "lyricist", "producer", etc.
        uint256 share; // Basis points (e.g., 2500 = 25%)
    }

    struct SplitSheet {
        uint256 workId;
        Contributor[] contributors;
        uint256 totalShares; // Should be 10000 for 100%
        uint256 createdAt;
        bool finalized;
    }

    mapping(uint256 => Work) public works;
    mapping(uint256 => SplitSheet) public splitSheets;
    uint256 public nextWorkId;

    event WorkRegistered(uint256 indexed workId, string title, address indexed creator);
    event SplitSheetCreated(uint256 indexed workId, uint256 splitId);
    event SplitSheetFinalized(uint256 indexed workId, uint256 splitId);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __Pausable_init();
        nextWorkId = 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function registerWork(
        string memory title,
        string memory workType,
        bytes32 contentHash,
        string memory metadataURI
    ) external whenNotPaused returns (uint256) {
        uint256 workId = nextWorkId++;
        works[workId] = Work({
            id: workId,
            title: title,
            workType: workType,
            creator: msg.sender,
            contentHash: contentHash,
            metadataURI: metadataURI,
            createdAt: block.timestamp,
            active: true
        });
        emit WorkRegistered(workId, title, msg.sender);
        return workId;
    }

    function createSplitSheet(uint256 workId, Contributor[] memory contributors) external whenNotPaused returns (uint256) {
        require(works[workId].creator == msg.sender, "Not work creator");
        require(works[workId].active, "Work inactive");
        require(splitSheets[workId].workId == 0, "Split sheet already exists");

        uint256 totalShares = 0;
        for (uint i = 0; i < contributors.length; i++) {
            totalShares += contributors[i].share;
        }
        require(totalShares == 10000, "Total shares must be 10000 (100%)");

        Contributor[] storage sheetContributors = splitSheets[workId].contributors;
        for (uint i = 0; i < contributors.length; i++) {
            sheetContributors.push(contributors[i]);
        }

        splitSheets[workId] = SplitSheet({
            workId: workId,
            contributors: sheetContributors,
            totalShares: totalShares,
            createdAt: block.timestamp,
            finalized: false
        });

        emit SplitSheetCreated(workId, workId); // Using workId as splitId for simplicity
        return workId;
    }

    function finalizeSplitSheet(uint256 workId) external {
        require(works[workId].creator == msg.sender, "Not work creator");
        require(splitSheets[workId].workId != 0, "Split sheet not created");
        require(!splitSheets[workId].finalized, "Already finalized");

        splitSheets[workId].finalized = true;
        emit SplitSheetFinalized(workId, workId);
    }

    function getWork(uint256 workId) external view returns (Work memory) {
        return works[workId];
    }

    function getSplitSheet(uint256 workId) external view returns (SplitSheet memory) {
        return splitSheets[workId];
    }

    function getContributors(uint256 workId) external view returns (Contributor[] memory) {
        return splitSheets[workId].contributors;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}