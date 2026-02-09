// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

contract IssuerDirectory is Initializable, UUPSUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    struct Issuer {
        address issuerAddress;
        string name;
        string description;
        bytes32[] capabilities;
        bool active;
        uint256 registeredAt;
    }

    mapping(address => Issuer) public issuers;
    address[] public issuerList;

    event IssuerAdded(address indexed issuer, string name, bytes32[] capabilities);
    event IssuerUpdated(address indexed issuer, string name, bytes32[] capabilities);
    event IssuerRemoved(address indexed issuer);
    event CapabilityGranted(address indexed issuer, bytes32 capability);
    event CapabilityRevoked(address indexed issuer, bytes32 capability);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __Pausable_init();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function addIssuer(address issuer, string memory name, string memory description, bytes32[] memory capabilities) external onlyOwner whenNotPaused {
        require(!issuers[issuer].active, "Issuer already exists");
        issuers[issuer] = Issuer({
            issuerAddress: issuer,
            name: name,
            description: description,
            capabilities: capabilities,
            active: true,
            registeredAt: block.timestamp
        });
        issuerList.push(issuer);
        emit IssuerAdded(issuer, name, capabilities);
    }

    function updateIssuer(address issuer, string memory name, string memory description, bytes32[] memory capabilities) external onlyOwner whenNotPaused {
        require(issuers[issuer].active, "Issuer not active");
        issuers[issuer].name = name;
        issuers[issuer].description = description;
        issuers[issuer].capabilities = capabilities;
        emit IssuerUpdated(issuer, name, capabilities);
    }

    function removeIssuer(address issuer) external onlyOwner {
        require(issuers[issuer].active, "Issuer not active");
        issuers[issuer].active = false;
        emit IssuerRemoved(issuer);
    }

    function grantCapability(address issuer, bytes32 capability) external onlyOwner whenNotPaused {
        require(issuers[issuer].active, "Issuer not active");
        issuers[issuer].capabilities.push(capability);
        emit CapabilityGranted(issuer, capability);
    }

    function revokeCapability(address issuer, bytes32 capability) external onlyOwner {
        require(issuers[issuer].active, "Issuer not active");
        // Remove capability from array (simplified)
        for (uint i = 0; i < issuers[issuer].capabilities.length; i++) {
            if (issuers[issuer].capabilities[i] == capability) {
                issuers[issuer].capabilities[i] = issuers[issuer].capabilities[issuers[issuer].capabilities.length - 1];
                issuers[issuer].capabilities.pop();
                break;
            }
        }
        emit CapabilityRevoked(issuer, capability);
    }

    function isAuthorized(address issuer, bytes32 capability) external view returns (bool) {
        if (!issuers[issuer].active) return false;
        for (uint i = 0; i < issuers[issuer].capabilities.length; i++) {
            if (issuers[issuer].capabilities[i] == capability) return true;
        }
        return false;
    }

    function getIssuer(address issuer) external view returns (Issuer memory) {
        return issuers[issuer];
    }

    function getAllIssuers() external view returns (address[] memory) {
        return issuerList;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}