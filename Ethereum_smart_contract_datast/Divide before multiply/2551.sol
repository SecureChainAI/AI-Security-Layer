            sale = price.mul(amount).div(factor);
            seller.transfer(sale - (sale.mul(ownerPercentage).div(10000)));
