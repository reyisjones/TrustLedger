// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

contract DIDRegistry is Initializable, UUPSUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    struct DIDDocument {
        string did;
        string documentURI;
        address controller;
        uint256 createdAt;
        uint256 updatedAt;
        bool active;
    }

    mapping(string => DIDDocument) public dids;
    mapping(address => string[]) public controllerDIDs;

    event DIDRegistered(string indexed did, address indexed controller, string documentURI);
    event DIDUpdated(string indexed did, string newDocumentURI);
    event DIDDeactivated(string indexed did);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __Pausable_init();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function registerDID(string memory did, string memory documentURI) external whenNotPaused {
        require(bytes(dids[did].did).length == 0, "DID already exists");
        dids[did] = DIDDocument({
            did: did,
            documentURI: documentURI,
            controller: msg.sender,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            active: true
        });
        controllerDIDs[msg.sender].push(did);
        emit DIDRegistered(did, msg.sender, documentURI);
    }

    function updateDID(string memory did, string memory newDocumentURI) external whenNotPaused {
        require(dids[did].controller == msg.sender, "Not controller");
        require(dids[did].active, "DID inactive");
        dids[did].documentURI = newDocumentURI;
        dids[did].updatedAt = block.timestamp;
        emit DIDUpdated(did, newDocumentURI);
    }

    function deactivateDID(string memory did) external {
        require(dids[did].controller == msg.sender || owner() == msg.sender, "Not authorized");
        dids[did].active = false;
        emit DIDDeactivated(did);
    }

    function resolveDID(string memory did) external view returns (DIDDocument memory) {
        return dids[did];
    }

    function getControllerDIDs(address controller) external view returns (string[] memory) {
        return controllerDIDs[controller];
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}