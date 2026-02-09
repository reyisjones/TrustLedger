# Smart Contract Specifications

## Overview

TrustLedger's smart contracts implement the core trust primitives on-chain. The system is EVM-first with chain-agnostic interfaces for future expansion. Contracts follow modular design principles with upgradeability through UUPS proxies.

## Architecture Principles

- **Modularity**: Separate contracts for distinct responsibilities.
- **Upgradeability**: UUPS proxy pattern for evolution.
- **Security**: Multi-signature governance, time-locks, and emergency pauses.
- **Gas Efficiency**: Optimized for cost-effective operations.
- **Composability**: Interfaces allow integration with external contracts.

## Core Contracts

### AssetRegistry

**Purpose**: Register and manage digital assets requiring verification.

**Key Functions**:
- `registerAsset(bytes32 contentHash, string metadataURI, address owner)`: Register a new asset.
- `updateMetadata(uint256 assetId, string newMetadataURI)`: Update asset metadata.
- `transferOwnership(uint256 assetId, address newOwner)`: Transfer asset ownership.

**Events**:
- `AssetRegistered(uint256 indexed assetId, address indexed owner, bytes32 contentHash)`
- `MetadataUpdated(uint256 indexed assetId, string newMetadataURI)`
- `OwnershipTransferred(uint256 indexed assetId, address indexed previousOwner, address indexed newOwner)`

### ClaimRegistry

**Purpose**: Store claims made about assets.

**Key Functions**:
- `submitClaim(uint256 assetId, bytes32 schemaId, bytes32 claimHash, address subject)`: Submit a claim.
- `updateClaim(uint256 claimId, bytes32 newClaimHash)`: Update an existing claim.

**Events**:
- `ClaimSubmitted(uint256 indexed claimId, uint256 indexed assetId, address indexed subject)`
- `ClaimUpdated(uint256 indexed claimId, bytes32 newClaimHash)`

### AttestationRegistry

**Purpose**: Issue and manage attestations to claims.

**Key Functions**:
- `attest(uint256 claimId, uint256 expiryTimestamp, bytes signature)`: Issue an attestation.
- `revokeAttestation(uint256 attestationId)`: Revoke an attestation.

**Events**:
- `AttestationIssued(uint256 indexed attestationId, uint256 indexed claimId, address indexed issuer)`
- `AttestationRevoked(uint256 indexed attestationId, uint256 revokedAt)`

### RevocationRegistry

**Purpose**: Handle revocation of attestations with reasons.

**Key Functions**:
- `revoke(uint256 attestationId, uint8 reasonCode, string reason)`: Revoke with details.

**Events**:
- `Revocation(uint256 indexed attestationId, uint8 reasonCode, string reason)`

### IssuerDirectory

**Purpose**: Manage authorized issuers and their capabilities.

**Key Functions**:
- `addIssuer(address issuer, bytes32[] capabilities)`: Add an issuer with permissions.
- `removeIssuer(address issuer)`: Remove issuer authorization.
- `isAuthorized(address issuer, bytes32 capability)`: Check issuer permissions.

**Events**:
- `IssuerAdded(address indexed issuer, bytes32[] capabilities)`
- `IssuerRemoved(address indexed issuer)`

### PolicyEngine

**Purpose**: On-chain policy evaluation for attestations.

**Key Functions**:
- `evaluatePolicy(uint256 claimId, address issuer, bytes data)`: Evaluate if attestation is allowed.
- `setPolicy(bytes32 policyId, bytes policyData)`: Set policy rules.

**Events**:
- `PolicyEvaluated(uint256 indexed claimId, bool approved)`
- `PolicySet(bytes32 indexed policyId)`

## Data Model

```solidity
struct Asset {
    uint256 id;
    address owner;
    bytes32 contentHash;
    string metadataURI;
    uint256 createdAt;
    bool active;
}

struct Claim {
    uint256 id;
    uint256 assetId;
    bytes32 schemaId;
    bytes32 claimHash;
    address subject;
    uint256 createdAt;
}

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
```

## Upgrade Strategy

- **UUPS Proxies**: Implementation contracts can be upgraded without changing proxy addresses.
- **Governance Control**: Upgrades require multi-signature approval and time-locks.
- **Versioning**: New contract versions are deployed and linked through registry.

## Security Features

- **Access Control**: Only authorized issuers can perform sensitive operations.
- **Input Validation**: Comprehensive checks on all inputs.
- **Emergency Pause**: Circuit breaker for critical functions.
- **Event Logging**: All state changes emit events for off-chain monitoring.

## Gas Optimization

- **Batch Operations**: Support for bulk registrations and attestations.
- **Efficient Storage**: Packed structs and optimized mappings.
- **Lazy Evaluation**: Off-chain processing where possible.

## Testing Strategy

- **Unit Tests**: Foundry for contract-specific tests.
- **Integration Tests**: Test contract interactions.
- **Formal Verification**: Certora or similar for critical contracts.
- **Audit**: Third-party security audit before mainnet deployment.

## Deployment

- **Testnets First**: Deploy on Ethereum Goerli, Polygon Mumbai, etc.
- **Mainnet Rollout**: Staged deployment with monitoring.
- **Multi-Chain**: Bridge contracts for cross-chain attestations.

## Future Extensions

- **ZK Proofs**: Privacy-preserving attestations.
- **Cross-Chain**: Interoperability with non-EVM chains.
- **Token Integration**: Optional governance token for advanced features.
