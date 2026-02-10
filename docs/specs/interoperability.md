# TrustLedger Interoperability Specifications

## Overview

This document defines the interoperability standards for TrustLedger, enabling seamless integration with other blockchain systems, oracles, and decentralized applications.

## EIP-Like Specification Format

### EIP-XXXX: TrustLedger Attestation Standard

```
EIP: XXXX
Title: TrustLedger Attestation Standard
Author: TrustLedger Team
Status: Draft
Type: Standards Track
Category: ERC
Created: 2026-02-10
```

## Abstract

This EIP defines a standard interface for decentralized attestation registries, enabling cross-chain and cross-protocol attestation verification.

## Motivation

Current attestation systems are siloed and incompatible. This standard provides a common interface for:
- Cross-chain attestation verification
- Interoperable trust primitives
- Standardized metadata formats

## Specification

### Core Interface

```solidity
interface IAttestationRegistry {
    event AttestationIssued(uint256 indexed attestationId, uint256 indexed claimId, address indexed issuer);
    event AttestationRevoked(uint256 indexed attestationId);

    function attest(uint256 claimId, uint256 expiryTimestamp, bytes32 signatureRef) external returns (uint256);
    function revokeAttestation(uint256 attestationId, uint8 reasonCode, string memory reason) external;
    function isValidAttestation(uint256 attestationId) external view returns (bool);
    function getAttestation(uint256 attestationId) external view returns (Attestation memory);
}
```

### Attestation Structure

```solidity
struct Attestation {
    uint256 id;
    uint256 claimId;
    address issuer;
    bytes32 signatureRef;
    uint256 expiresAt;
    uint8 status;
}
```

### Metadata Standards

#### Claim Schema Format
```json
{
  "schema": "trustledger-claim-v1",
  "type": "object",
  "properties": {
    "subject": { "type": "string" },
    "predicate": { "type": "string" },
    "object": { "type": "string" },
    "evidence": { "type": "array" }
  }
}
```

#### Attestation Metadata
```json
{
  "issuer": "did:trustledger:issuer:0x...",
  "issuedAt": "2026-02-10T10:00:00Z",
  "expiresAt": "2027-02-10T10:00:00Z",
  "proof": {
    "type": "EthereumSignature",
    "proofPurpose": "assertionMethod",
    "verificationMethod": "did:ethr:0x...#controller"
  }
}
```

## Cross-Chain Compatibility

### Bridge Interfaces

#### Source Chain Interface
```solidity
interface IAttestationBridge {
    function bridgeAttestation(uint256 attestationId, uint256 targetChainId) external payable;
    function verifyBridgedAttestation(bytes memory proof) external view returns (bool);
}
```

#### Target Chain Interface
```solidity
interface IAttestationReceiver {
    function receiveBridgedAttestation(
        uint256 sourceChainId,
        uint256 sourceAttestationId,
        address issuer,
        bytes32 claimHash,
        bytes memory proof
    ) external;
}
```

### Bridge Proof Format
```solidity
struct BridgeProof {
    uint256 sourceChainId;
    uint256 attestationId;
    bytes32 claimHash;
    address issuer;
    uint256 timestamp;
    bytes signature;
    bytes32 blockHash;
    uint256 blockNumber;
}
```

## Oracle Integration

### Oracle Interface
```solidity
interface IAttestationOracle {
    function requestAttestation(bytes32 claimHash, address callback) external returns (uint256);
    function fulfillAttestation(uint256 requestId, bool result, bytes memory proof) external;
    function getAttestationResult(uint256 requestId) external view returns (bool, bytes memory);
}
```

### Oracle Response Format
```json
{
  "requestId": "12345",
  "result": true,
  "proof": {
    "type": "oracle-attestation",
    "oracleId": "chainlink-oracle-1",
    "timestamp": 1644450000,
    "data": "0x..."
  }
}
```

## DID Integration

### DID Resolution
```solidity
interface IDIDResolver {
    function resolveDID(string memory did) external view returns (DIDDocument memory);
    function verifyDIDSignature(string memory did, bytes32 message, bytes memory signature) external view returns (bool);
}
```

### DID Document Format
```json
{
  "@context": "https://www.w3.org/ns/did/v1",
  "id": "did:trustledger:0x123...",
  "verificationMethod": [{
    "id": "did:trustledger:0x123...#key-1",
    "type": "EcdsaSecp256k1VerificationKey2019",
    "controller": "did:trustledger:0x123...",
    "publicKeyHex": "04..."
  }]
}
```

## Implementation Guidelines

### Contract Deployment
1. Deploy core registry contracts
2. Register with bridge contracts
3. Configure oracle integrations
4. Set up DID resolvers

### Testing Requirements
- Cross-chain attestation verification
- Oracle response handling
- DID signature verification
- Bridge proof validation

### Security Considerations
- Validate all external proofs
- Implement rate limiting for bridge operations
- Use secure random for request IDs
- Regular key rotation for oracles

## Backward Compatibility

This standard maintains backward compatibility with:
- Existing TrustLedger deployments
- ERC-721 and ERC-1155 standards
- DID Core specification
- Chainlink oracle interfaces

## Future Extensions

### Planned Features
- Zero-knowledge proof attestations
- Multi-signature issuer pools
- Decentralized oracle networks
- Cross-chain governance

### Extension Points
- Custom claim schemas
- Alternative proof mechanisms
- Enhanced privacy features
- Advanced revocation methods

## Reference Implementation

See `contracts/evm/src/` for complete implementation examples.

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).