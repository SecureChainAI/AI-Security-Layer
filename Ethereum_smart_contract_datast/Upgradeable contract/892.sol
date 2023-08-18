contract UpgradeabilityOwnerStorage {
    address private _upgradeabilityOwner;

    function upgradeabilityOwner() public view returns (address) {
        return _upgradeabilityOwner;
    }

    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
        _upgradeabilityOwner = newUpgradeabilityOwner;
    }
}

contract UpgradeabilityStorage {
    string internal _version;

    address internal _implementation;

    function version() public view returns (string) {
        return _version;
    }

    function implementation() public view returns (address) {
        return _implementation;
    }
}

contract OwnedUpgradeabilityStorage is
    UpgradeabilityOwnerStorage,
    UpgradeabilityStorage,
    EternalStorage
{}
