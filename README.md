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
   - RightsRegistry: Intellectual property registry for creative works

2. **API Gateway** (Node.js/Express)
   - RESTful interfaces for off-chain interactions
   - Azure Key Vault integration for secure key management

3. **Indexing Service** (Node.js)
   - Real-time event indexing from blockchain
   - PostgreSQL storage with optimized queries
   - OpenTelemetry observability

4. **Web Console** (HTML/JS)
   - Simple UI for asset-claim-attestation flow
   - Rights management interface

5. **Infrastructure** (Terraform/Helm/Docker)
   - Azure cloud deployment
   - Kubernetes orchestration
   - CI/CD pipeline

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

### ✅ Completed (Phase 3 - TrustLedger Rights™)
- Rights Registry for creative works (compositions, recordings, videos)
- Split sheets with contributor management and share allocation
- Proof-of-existence timestamps and provenance tracking
- IPFS/Arweave metadata integration

### ✅ Completed (Phase 4 - Enterprise/Azure Hybrid)
- Azure Key Vault integration for secure key management
- Terraform infrastructure as code for Azure deployment
- Helm charts for Kubernetes orchestration
- Indexing service with OpenTelemetry observability
- Docker containerization for all services
- CI/CD pipeline with GitHub Actions
- Automated deployment scripts

### ✅ Completed (Phase 5 - Ecosystem Hardening)
- Formal verification specifications for critical contracts
- Third-party security audit report and remediation
- Community contribution guidelines and grant program
- Interoperability standards (EIP-like specifications)
- Module registry for community extensions
- Governance proposal templates
- Incident response runbook and procedures

## 📋 Future Roadmap

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

### Automated Deployment

1. Set up Azure credentials:
```bash
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
export AZURE_TENANT_ID="your-tenant-id"
```

2. Run the deployment script:
```bash
./infra/scripts/deploy.sh
```

This will:
- Deploy Azure infrastructure (Key Vault, Container Apps, etc.)
- Set up Kubernetes cluster with Helm
- Configure monitoring and observability
- Run health checks

### Manual Deployment

#### Infrastructure
```bash
cd infra/terraform
terraform init
terraform apply
```

#### Services
```bash
cd infra/helm
helm install trustledger .
```

#### Docker Build
```bash
docker build -f infra/docker/Dockerfile.api -t trustledger/api-gateway .
docker build -f infra/docker/Dockerfile.indexing -t trustledger/indexing-service .
```

## � Security

- **Audit Reports**: [2026 Security Audit](audits/audit-report-2026.md)
- **Formal Verification**: [Certora Specifications](contracts/evm/certora/)
- **Bug Bounty**: Coming soon
- **Responsible Disclosure**: security@trustledger.org

## 🔗 Interoperability

TrustLedger implements open standards for cross-chain and cross-protocol compatibility:

- [Interoperability Specifications](docs/specs/interoperability.md)
- EIP-like proposal process
- Bridge interfaces for multi-chain support
- Oracle integration standards

## 🧩 Module Ecosystem

Extend TrustLedger with community modules:

- [Module Registry](docs/modules/README.md)
- Grant program for module development
- SDKs and API clients
- Industry-specific extensions

## 🏛️ Governance

- [Governance Model](GOVERNANCE.md)
- [Proposal Templates](docs/governance/proposal-template.md)
- Community decision-making
- Grant allocation process

## 📖 Documentation

- [Vision Document](docs/vision.md)
- [Architecture Overview](docs/architecture/)
- [Smart Contract Specs](docs/specs/contracts.md)
- [API Documentation](docs/specs/api.md)
- [Deployment Runbooks](docs/runbooks/)
- [Contributing Guide](CONTRIBUTING.md)

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