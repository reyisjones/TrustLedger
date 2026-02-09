// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

contract AttestationRegistry is Initializable, UUPSUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    struct Attestation {
        uint256 id;
        uint256 claimId;
        address issuer;
        bytes32 signatureRef;
        uint256 expiresAt;
        uint8 status; // 0: active, 1: revoked
    }

    struct Revocation {
        uint256 attestationId;
        uint256 revokedAt;
        uint8 reasonCode;
        string reason;
    }

    mapping(uint256 => Attestation) public attestations;
    mapping(uint256 => Revocation) public revocations;
    uint256 public nextAttestationId;

    event AttestationIssued(uint256 indexed attestationId, uint256 indexed claimId, address indexed issuer);
    event AttestationRevoked(uint256 indexed attestationId, uint256 revokedAt, uint8 reasonCode, string reason);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __Pausable_init();
        nextAttestationId = 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function attest(uint256 claimId, uint256 expiryTimestamp, bytes32 signatureRef) external whenNotPaused returns (uint256) {
        uint256 attestationId = nextAttestationId++;
        attestations[attestationId] = Attestation({
            id: attestationId,
            claimId: claimId,
            issuer: msg.sender,
            signatureRef: signatureRef,
            expiresAt: expiryTimestamp,
            status: 0
        });
        emit AttestationIssued(attestationId, claimId, msg.sender);
        return attestationId;
    }

    function revokeAttestation(uint256 attestationId, uint8 reasonCode, string memory reason) external whenNotPaused {
        require(attestations[attestationId].issuer == msg.sender || owner() == msg.sender, "Not authorized");
        require(attestations[attestationId].status == 0, "Already revoked");
        attestations[attestationId].status = 1;
        revocations[attestationId] = Revocation({
            attestationId: attestationId,
            revokedAt: block.timestamp,
            reasonCode: reasonCode,
            reason: reason
        });
        emit AttestationRevoked(attestationId, block.timestamp, reasonCode, reason);
    }

    function isValidAttestation(uint256 attestationId) external view returns (bool) {
        Attestation memory att = attestations[attestationId];
        return att.status == 0 && (att.expiresAt == 0 || att.expiresAt > block.timestamp);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}