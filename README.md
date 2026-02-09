# TrustLedger

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![GitHub Issues](https://img.shields.io/github/issues/reyisjones/TrustLedger)](https://github.com/reyisjones/TrustLedger/issues)
[![GitHub Stars](https://img.shields.io/github/stars/reyisjones/TrustLedger)](https://github.com/reyisjones/TrustLedger/stargazers)

An enterprise-grade decentralized trust and verification network for high-value digital assets, contracts, certifications, and audit trails.

## 🚀 Vision

TrustLedger provides a neutral, tamper-resistant foundation for establishing and verifying the authenticity, provenance, and compliance of digital artifacts across industries. Built for durability, security, and composability, it outlasts market cycles and technological trends.

## ✨ Key Features

- **Decentralized Trust Primitives**: Assets, Claims, Attestations, and Revocations
- **Enterprise-Ready**: Regulator-friendly, cloud-integratable, and security-first
- **Chain-Agnostic**: EVM-first with interfaces for multi-chain support
- **Open-Source**: Top-tier GitHub project with strong governance and community

## 🏗️ Architecture

### Core Components

1. **Smart Contracts** (EVM)
   - AssetRegistry: Register and manage verifiable digital assets
   - ClaimRegistry: Store claims about assets
   - AttestationRegistry: Issue and manage attestations with revocation
   - DIDRegistry: Decentralized identity management
   - IssuerDirectory: Role-based issuer authorization
   - AuditLog: Append-only audit trail

2. **API Gateway** (Node.js/Express)
   - RESTful interfaces for off-chain interactions
   - Placeholder endpoints for MVP

3. **Web Console** (HTML/JS)
   - Simple UI for asset-claim-attestation flow

4. **Indexing Service** (Planned)
   - Efficient querying of attestations and provenance

5. **Identity Layer** (Implemented)
   - DID-based identities with verifiable credentials

## 📦 Current Status

### ✅ Completed (Phase 1 - MVP)
- Smart contracts with upgradeable architecture
- Basic API gateway skeleton
- Web console for core user flow
- Unit tests for contracts

### ✅ Completed (Phase 2 - Identity + Compliance)
- DID Registry for decentralized identities
- Issuer Directory with role-based access control
- Audit Log for append-only event tracking
- Enhanced security: issuer authorization checks, emergency pause

### 🔄 In Progress (Phase 3 - TrustLedger Rights™)

### 📋 Roadmap
- **Phase 3**: TrustLedger Rights™ (Intellectual property registry)
- **Phase 4**: Enterprise/Azure hybrid integration
- **Phase 5**: Ecosystem hardening and formal verification

## 🛠️ Quick Start

### Prerequisites
- Node.js 18+
- Foundry (for smart contracts)
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/reyisjones/TrustLedger.git
cd TrustLedger
```

2. Install API dependencies:
```bash
cd services/api-gateway
npm install
```

3. Install contract dependencies:
```bash
cd contracts/evm
forge install
```

### Running the MVP

1. Start the API Gateway:
```bash
cd services/api-gateway
npm start
```

2. Open the Web Console:
```bash
cd apps/web-console
# Open index.html in your browser
```

3. Test the contracts:
```bash
cd contracts/evm
forge test
```

## 📚 Documentation

- [Vision Document](docs/vision.md)
- [Architecture Overview](docs/architecture/)
- [Smart Contract Specs](docs/specs/contracts.md)
- [Threat Model](docs/architecture/threat-model.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🌍 Community

- [GitHub Issues](https://github.com/reyisjones/TrustLedger/issues)
- [Discussions](https://github.com/reyisjones/TrustLedger/discussions)
- [Twitter](https://twitter.com/trustledger) (planned)

## ⚖️ Governance

TrustLedger follows an open governance model. See [GOVERNANCE.md](GOVERNANCE.md) for details on decision-making processes.

## 🙏 Acknowledgments

Built with ❤️ using:
- [Foundry](https://book.getfoundry.sh/) for smart contract development
- [OpenZeppelin](https://openzeppelin.com/) for secure contract libraries
- [Express.js](https://expressjs.com/) for the API gateway

---

*TrustLedger: Building verification infrastructure that outlasts trends.*