// TrustLedger MVP Console - Client-side JavaScript
const API_BASE = 'http://localhost:3000';

async function apiCall(endpoint, method = 'GET', data = null) {
    const config = {
        method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (data) config.body = JSON.stringify(data);

    try {
        const response = await fetch(`${API_BASE}${endpoint}`, config);
        const result = await response.json();
        return result;
    } catch (error) {
        return { error: error.message };
    }
}

async function registerAsset() {
    const content = document.getElementById('assetContent').value;
    const metadata = document.getElementById('assetMetadata').value;
    const result = await apiCall('/assets', 'POST', { contentHash: content, metadataURI: metadata });
    document.getElementById('assetResult').textContent = JSON.stringify(result, null, 2);
}

async function submitClaim() {
    const assetId = document.getElementById('claimAssetId').value;
    const schemaId = document.getElementById('claimSchema').value;
    const claimHash = document.getElementById('claimHash').value;
    const subject = document.getElementById('claimSubject').value;
    const result = await apiCall('/claims', 'POST', { assetId: parseInt(assetId), schemaId, claimHash, subject });
    document.getElementById('claimResult').textContent = JSON.stringify(result, null, 2);
}

async function issueAttestation() {
    const claimId = document.getElementById('attClaimId').value;
    const expiry = document.getElementById('attExpiry').value;
    const signature = document.getElementById('attSignature').value;
    const result = await apiCall('/attestations', 'POST', { claimId: parseInt(claimId), expiryTimestamp: parseInt(expiry), signatureRef: signature });
    document.getElementById('attResult').textContent = JSON.stringify(result, null, 2);
}

async function verifyAttestation() {
    const attId = document.getElementById('verifyAttId').value;
    const result = await apiCall(`/attestations/${attId}/verify`);
    document.getElementById('verifyResult').textContent = JSON.stringify(result, null, 2);
}

// For MVP, these are placeholders - actual implementation would connect to blockchain