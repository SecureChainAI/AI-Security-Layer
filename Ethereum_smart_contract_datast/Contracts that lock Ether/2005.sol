contract CentralizedBugOracleProxy is Proxy, CentralizedBugOracleData {

    /// @dev Constructor sets owner address and IPFS hash
    /// @param _ipfsHash Hash identifying off chain event description
    constructor(address proxied, address _owner, bytes _ipfsHash, address _maker, address _taker)
        public
        Proxy(proxied)
    {
        // Description hash cannot be null
        require(_ipfsHash.length == 46);
        owner = _owner;
        ipfsHash = _ipfsHash;
        maker = _maker;
        taker = _taker;
    }
}
