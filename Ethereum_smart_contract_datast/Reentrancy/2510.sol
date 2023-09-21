function settleETHBatch(address[] _custodies, int[] _flows, uint _fee, uint _insurance) external whenNotPaused onlyExchangeOrOwner
onlyAllowedInPhase(SettlementPhase.ONGOING) {

require(_custodies.length == _flows.length);

uint preBatchBalance = address(this).balance;

if(_insurance > 0) {
Insurance(insuranceAccount).useInsurance(_insurance);
}

for (uint flowIndex = 0; flowIndex < _flows.length; flowIndex++) {

//Every custody can be served ETH once during settlement
require(custodiesServedETH[lastSettlementStartedTimestamp][_custodies[flowIndex]] == false);

//All addresses must be custodies
require(custodyStorage.custodiesMap(_custodies[flowIndex]));

if (_flows[flowIndex] > 0) {
//10% rule
var outboundFlow = uint(_flows[flowIndex]);

//100% rule exception threshold
if(outboundFlow > 10 ether) {
//100% rule
require(getTotalBalanceFor(_custodies[flowIndex]) >= outboundFlow);
}

_custodies[flowIndex].transfer(uint(_flows[flowIndex]));

} else if (_flows[flowIndex] < 0) {
Custody custody = Custody(_custodies[flowIndex]);

custody.withdraw(uint(-_flows[flowIndex]), address(this));
}

custodiesServedETH[lastSettlementStartedTimestamp][_custodies[flowIndex]] = true;
}

if(_fee > 0) {
feeAccount.transfer(_fee);
totalFeeFlows = totalFeeFlows + _fee;
//100% rule for fee account
require(totalFeeFlows <= startingFeeBalance);
}

uint postBatchBalance = address(this).balance;

//Zero-sum guaranteed for ever batch
if(address(this).balance > preBatchBalance) {
uint leftovers = address(this).balance - preBatchBalance;
insuranceAccount.transfer(leftovers);
totalInsuranceFlows += leftovers;
//100% rule for insurance account
require(totalInsuranceFlows <= startingInsuranceBalance);
}
}
