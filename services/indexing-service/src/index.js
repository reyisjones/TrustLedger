const express = require('express');
const { ethers } = require('ethers');
const { Pool } = require('pg');
require('dotenv').config();

// OpenTelemetry setup
const { NodeTracerProvider } = require('@opentelemetry/sdk-node');
const { registerInstrumentations } = require('@opentelemetry/instrumentation');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');

const provider = new NodeTracerProvider();
registerInstrumentations({
  instrumentations: [new HttpInstrumentation()],
});
provider.register();

const app = express();
const PORT = process.env.PORT || 4000;

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Contract ABIs (simplified)
const assetRegistryABI = [
  "event AssetRegistered(uint256 indexed assetId, address indexed owner, bytes32 contentHash)",
  "event MetadataUpdated(uint256 indexed assetId, string newMetadataURI)",
];

const attestationRegistryABI = [
  "event AttestationIssued(uint256 indexed attestationId, uint256 indexed claimId, address indexed issuer)",
  "event AttestationRevoked(uint256 indexed attestationId, uint256 revokedAt)",
];

// Initialize indexer
async function initializeIndexer() {
  const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

  // Asset Registry
  const assetRegistry = new ethers.Contract(process.env.ASSET_REGISTRY_ADDRESS, assetRegistryABI, provider);
  assetRegistry.on('AssetRegistered', async (assetId, owner, contentHash, event) => {
    console.log(`Asset registered: ${assetId}`);
    await pool.query(
      'INSERT INTO assets (id, owner, content_hash, block_number, transaction_hash) VALUES ($1, $2, $3, $4, $5) ON CONFLICT (id) DO NOTHING',
      [assetId.toString(), owner, contentHash, event.blockNumber, event.transactionHash]
    );
  });

  // Attestation Registry
  const attestationRegistry = new ethers.Contract(process.env.ATTESTATION_REGISTRY_ADDRESS, attestationRegistryABI, provider);
  attestationRegistry.on('AttestationIssued', async (attestationId, claimId, issuer, event) => {
    console.log(`Attestation issued: ${attestationId}`);
    await pool.query(
      'INSERT INTO attestations (id, claim_id, issuer, block_number, transaction_hash) VALUES ($1, $2, $3, $4, $5) ON CONFLICT (id) DO NOTHING',
      [attestationId.toString(), claimId.toString(), issuer, event.blockNumber, event.transactionHash]
    );
  });

  console.log('Indexer initialized and listening for events');
}

// API endpoints
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'TrustLedger Indexing Service' });
});

app.get('/assets', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM assets ORDER BY block_number DESC LIMIT 100');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/attestations', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM attestations ORDER BY block_number DESC LIMIT 100');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start server
app.listen(PORT, async () => {
  console.log(`TrustLedger Indexing Service running on port ${PORT}`);
  await initializeIndexer();
});