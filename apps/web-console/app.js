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

async function registerWork() {
    const title = document.getElementById('workTitle').value;
    const workType = document.getElementById('workType').value;
    const contentHash = document.getElementById('workContentHash').value;
    const metadataURI = document.getElementById('workMetadataURI').value;
    const result = await apiCall('/rights/works', 'POST', { title, workType, contentHash, metadataURI });
    document.getElementById('workResult').textContent = JSON.stringify(result, null, 2);
}

function addContributor() {
    const container = document.getElementById('contributors');
    const div = document.createElement('div');
    div.className = 'contributor';
    div.innerHTML = `
        <input type="text" placeholder="Contributor address" class="contribAddr" />
        <input type="text" placeholder="Role" class="contribRole" />
        <input type="number" placeholder="Share (basis points)" class="contribShare" />
    `;
    container.appendChild(div);
}

async function createSplitSheet() {
    const workId = document.getElementById('splitWorkId').value;
    const contributors = [];
    const contribDivs = document.querySelectorAll('.contributor');
    contribDivs.forEach(div => {
        const addr = div.querySelector('.contribAddr').value;
        const role = div.querySelector('.contribRole').value;
        const share = parseInt(div.querySelector('.contribShare').value);
        if (addr && role && share) {
            contributors.push({ contributor: addr, role, share });
        }
    });
    const result = await apiCall(`/rights/works/${workId}/splits`, 'POST', { contributors });
    document.getElementById('splitResult').textContent = JSON.stringify(result, null, 2);
}

// For MVP, these are placeholders - actual implementation would connect to blockchain