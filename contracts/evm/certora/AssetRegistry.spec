// AssetRegistry Formal Verification Specification
// Using Certora Prover

methods {
    function assets(uint256) external returns (uint256, address, bytes32, string, uint256, bool) envfree;
    function registerAsset(bytes32, string) external returns (uint256) envfree;
    function updateMetadata(uint256, string) external envfree;
    function transferOwnership(uint256, address) external envfree;
    function deactivateAsset(uint256) external envfree;
    function nextAssetId() external returns (uint256) envfree;
}

// Ghost variables for tracking state
ghost mapping(uint256 => uint256) assetCreationTime {
    init_state axiom forall uint256 id. assetCreationTime[id] == 0;
}

// Hooks for tracking asset registration
hook Sstore assets[KEY uint256 id].(offset 32) uint256 creationTime (uint256 oldCreationTime) STORAGE {
    assetCreationTime[id] = creationTime;
}

// Invariants
invariant assetIdIncreases()
    nextAssetId() >= 0;

invariant assetOwnerValid(uint256 id)
    assets(id).owner != 0 => assets(id).active;

invariant assetCreationTimeValid(uint256 id)
    assets(id).createdAt > 0 => assets(id).createdAt <= block.timestamp;

invariant uniqueAssetIds(uint256 id1, uint256 id2)
    id1 != id2 => assets(id1).id != assets(id2).id || assets(id1).id == 0 || assets(id2).id == 0;

// Rules
rule registerAssetCreatesUniqueId(bytes32 contentHash, string metadataURI) {
    uint256 before = nextAssetId();
    uint256 id = registerAsset(contentHash, metadataURI);
    uint256 after = nextAssetId();

    assert id == before;
    assert after == before + 1;
    assert assets(id).owner == currentContract;
    assert assets(id).active == true;
}

rule onlyOwnerCanUpdateMetadata(uint256 id, string newURI, address caller) {
    require assets(id).owner == caller;
    updateMetadata(id, newURI);
    assert assets(id).metadataURI == newURI;
}

rule transferOwnershipChangesOwner(uint256 id, address newOwner, address caller) {
    require assets(id).owner == caller;
    transferOwnership(id, newOwner);
    assert assets(id).owner == newOwner;
}

rule deactivateAssetOnlyByOwner(uint256 id, address caller) {
    require assets(id).owner == caller;
    deactivateAsset(id);
    assert assets(id).active == false;
}

// Parametric rules
rule noAssetModificationWithoutPermission(uint256 id, method f) {
    address ownerBefore = assets(id).owner;
    bool activeBefore = assets(id).active;

    env e;
    if (f.selector != sig:registerAsset(bytes32,string).selector &&
        f.selector != sig:updateMetadata(uint256,string).selector &&
        f.selector != sig:transferOwnership(uint256,address).selector &&
        f.selector != sig:deactivateAsset(uint256).selector) {
        calldataarg args;
        f(e, args);
        assert assets(id).owner == ownerBefore;
        assert assets(id).active == activeBefore;
    }
}