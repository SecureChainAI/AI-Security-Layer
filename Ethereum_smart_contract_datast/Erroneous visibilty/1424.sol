function DetherCore() {
    ceoAddress = msg.sender;
}

function initContract(address _dth, address _bank) external onlyCEO {
    require(!isStarted);
    dth = ERC223Basic(_dth);
    bank = DetherBank(_bank);
    isStarted = true;
}

function setPriceOracle(address _priceOracle) external onlyCFO {
    priceOracle = ExchangeRateOracle(_priceOracle);
}
