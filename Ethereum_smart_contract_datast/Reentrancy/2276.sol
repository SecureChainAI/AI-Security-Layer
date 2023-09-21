  function _buy(address _token, uint _tokenId, Currency _currency, uint _price, address _buyer) internal {
        bytes32 key = _getHashKey(_token, _tokenId);
        Currency currency = listings[key].currency;
        address seller = listings[key].seller;

        address currencyAddress = _currency == Currency.PLAT ? address(PLAT) : address(0);

        require(currency == _currency, "Wrong currency.");
        require(_price > 0 && _price == listings[key].price, "Invalid price.");
        require(listings[key].expiry > now, "Item expired.");

        ERC721 gameToken = ERC721(_token);
        require(gameToken.ownerOf(_tokenId) == address(this), "Item is not available.");

        if (_currency == Currency.PLAT) {
            // Transfer PLAT to marketplace contract
            require(PLAT.transferFrom(_buyer, address(this), _price), "PLAT payment transfer failed.");
        }

        // Transfer item token to buyer
        gameToken.safeTransferFrom(this, _buyer, _tokenId);

        uint fee;
        (,fee) = getFee(_price, currencyAddress, _buyer, seller, _token); // getFee returns percentFee and fee, we only need fee

        if (_currency == Currency.PLAT) {
            PLAT.transfer(seller, _price - fee);
        } else {
            require(seller.send(_price - fee) == true, "Transfer to seller failed.");
        }

        // Emit event
        emit LogItemSold(_buyer, seller, _token, _tokenId, _price, currency, now);

        // delist item
        delete(listings[key]);
    }

    function _decodePriceData(bytes _extraData) internal pure returns(uint _currency, uint _price) {
        // Deserialize _extraData
        uint256 offset = 64;
        _price = _bytesToUint256(offset, _extraData);
        offset -= 32;
        _currency = _bytesToUint256(offset, _extraData);
    }

    function _decodeBuyData(bytes _extraData) internal pure returns(address _contract, uint _tokenId) {
        // Deserialize _extraData
        uint256 offset = 64;
        _tokenId = _bytesToUint256(offset, _extraData);
        offset -= 32;
        _contract = _bytesToAddress(offset, _extraData);
    }

    // @dev Decoding helper function from Seriality
    function _bytesToUint256(uint _offst, bytes memory _input) internal pure returns (uint256 _output) {
        assembly {
            _output := mload(add(_input, _offst))
        }
    }
