// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract AuditLog is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    struct AuditEntry {
        uint256 id;
        address actor;
        string action;
        bytes data;
        uint256 timestamp;
    }

    AuditEntry[] public auditTrail;

    event AuditEntryAdded(uint256 indexed id, address indexed actor, string action);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function logAction(address actor, string memory action, bytes memory data) external {
        // Allow any contract to log, or restrict to known contracts
        uint256 id = auditTrail.length;
        auditTrail.push(AuditEntry({
            id: id,
            actor: actor,
            action: action,
            data: data,
            timestamp: block.timestamp
        }));
        emit AuditEntryAdded(id, actor, action);
    }

    function getAuditTrailLength() external view returns (uint256) {
        return auditTrail.length;
    }

    function getAuditEntry(uint256 index) external view returns (AuditEntry memory) {
        return auditTrail[index];
    }
}