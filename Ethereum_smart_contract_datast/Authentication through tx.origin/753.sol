require(xrt.mint(tx.origin, wnFromGas(gasUtilizing[msg.sender])));
require(xrt.transferFrom(liability.promisor(),
                                 tx.origin,
                                 liability.lighthouseFee()));