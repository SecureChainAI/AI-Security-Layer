  function buyListing(bytes32 listingId, uint256 amount) external payable {
        Listing storage listing = listings[listingId];
        address seller = listing.seller;
        address contractAddress = listing.tokenContractAddress;
        uint256 price = listing.price;
        uint256 decimals = getDecimals(listing.tokenContractAddress);
        uint256 factor = 10 ** decimals;
        uint256 sale;
        if (decimals > 0) {
            sale = price.mul(amount).div(factor);
        } else {
            sale = price.mul(amount);
        } 
        uint256 allowance = listing.allowance;
        //make sure listing is still available
        require(now <= listing.dateEnds);
        //make sure there are still enough to sell from this listing
        require(allowance - sold[listingId] >= amount);
        //make sure that the seller still has that amount to sell
        require(getBalance(contractAddress, seller) >= amount);
        //make sure that the seller still will allow that amount to be sold
        require(getAllowance(contractAddress, seller, this) >= amount);
        require(msg.value == sale);
        DetailedERC20 tokenContract = DetailedERC20(contractAddress);
        require(tokenContract.transferFrom(seller, msg.sender, amount));
        if (ownerPercentage > 0) {
            seller.transfer(sale - (sale.mul(ownerPercentage).div(10000)));
        } else {
            seller.transfer(sale);
        }
        sold[listingId] = sold[listingId].add(amount);
        emit ListingBought(listingId, contractAddress, price, amount, now, msg.sender);
    }
