const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'TrustLedger API Gateway' });
});

// Placeholder routes for MVP
app.get('/assets', (req, res) => {
  res.json({ message: 'Asset listing endpoint - TODO' });
});

app.post('/assets', (req, res) => {
  res.json({ message: 'Asset registration endpoint - TODO' });
});

app.get('/claims', (req, res) => {
  res.json({ message: 'Claim listing endpoint - TODO' });
});

app.post('/claims', (req, res) => {
  res.json({ message: 'Claim submission endpoint - TODO' });
});

app.get('/attestations', (req, res) => {
  res.json({ message: 'Attestation listing endpoint - TODO' });
});

app.post('/attestations', (req, res) => {
  res.json({ message: 'Attestation issuance endpoint - TODO' });
});

app.listen(PORT, () => {
  console.log(`TrustLedger API Gateway running on port ${PORT}`);
});