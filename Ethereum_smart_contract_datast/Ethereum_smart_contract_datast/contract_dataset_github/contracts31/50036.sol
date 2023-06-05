/**
 *  $$$$$$\  $$\                 $$\                           
 * $$  __$$\ $$ |                $$ |                          
 * $$ /  \__|$$$$$$$\   $$$$$$\  $$ |  $$\  $$$$$$\   $$$$$$\  
 * \$$$$$$\  $$  __$$\  \____$$\ $$ | $$  |$$  __$$\ $$  __$$\ 
 *  \____$$\ $$ |  $$ | $$$$$$$ |$$$$$$  / $$$$$$$$ |$$ |  \__|
 * $$\   $$ |$$ |  $$ |$$  __$$ |$$  _$$<  $$   ____|$$ |      
 * \$$$$$$  |$$ |  $$ |\$$$$$$$ |$$ | \$$\ \$$$$$$$\ $$ |      
 *  \______/ \__|  \__| \_______|\__|  \__| \_______|\__|
 * $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 * ____________________________________________________________
*/

pragma solidity >=0.4.23 <0.6.0;

import "./interfaces/BTCHTokenInterface.sol";
import "./interfaces/ERC20Interface.sol";
import "./interfaces/TokenLockerInterface.sol";

import "./ReentrancyGuard.sol";
import "./Mocks/SafeMath.sol";

/**
 * The bonus will calculated with 5 factors:
 * 1- Base bonus factor. This is base bonus factor, here we set it as 0.05
 * 2- Amount after exponent. This will reduce the weight of whale capital. Here we set it as 2/3. That means if somebody deposit 100,000, will just caculatd busnus 
 *    according to 100,000 ** (2/3) = 2154.435
 * 3- Hours factor between Deposit Withdraw. This is let the people store the money in contract longer. 
 *    If below 1 hour, there will be no bonus token.
 *    from 1-24 hours, the factor is 0.05; 24-48 hours, factor is 0.15, etc.
 *    This factor will be modified by council according to the market.
 * 4- Stage factor: If total mint token is 300,000, we will devided it into several stages. Each stage has special bonus times. Ex. if stage factor is 5, 
 *    means in this stage, miner will get 5 times than normal.
 * 5- Price elastical factor. We want the mint quantity for each deposit can be different under different market. If the price is higher than normal, the factor will 
 *    become smaller automaticly, and if the price go down, the factor will become smaller also. It is a Gaussian distribution, and the average price (normal price) 
 *    is fee of deposit and withdrawal.
 * 
 * So the bonus amount will be:
 * Bonus amount = Amount after exponent * Base bonus factor * hours factor * stage factor * price elastical factor.
 * 
 * In this version, we will keep price elastical factor as 1.
 * 
 */
contract ShakerTokenManager is ReentrancyGuard {
    using SafeMath for uint256;
    
    uint256 public bonusTokenDecimals = 6; // Must be 6 even the actual decimal is 18
    uint256 public depositTokenDecimals = 6; // Must be 6 even the actual decimal is 18

    // Params
    uint256 public baseFactor = 50; // 50 means 0.05
    uint256[] public intervalOfDepositWithdraw = [1, 24, 48, 96, 192, 384, 720]; // hours of inverval between deposit and withdraw
    uint256[] public intervalOfDepositWithdrawFactor = [5000, 15000, 16800, 20600, 28600, 45500, 81500]; // 5000 will be devided by 1e5, means 0.05
    uint256[] public stageFactors = [10000, 5000, 2500, 1250, 625]; // Stage factor, 5000 means 5, 2500 means 2.5, etc.
    uint256 public eachStageAmount = 7200000 * 10 ** bonusTokenDecimals; // Each stage amount
    uint256[] public exponent = [2, 3];// means 2/3
    uint256 public feeRate = 33333; // 33.333% will be 33333
    uint256 public minChargeFeeAmount = 10 * 10 ** depositTokenDecimals;// Below this amount, will only charge  very special fee
    uint256 public minChargeFee = 0; // min amount of special charge.
    uint256 public minChargeFeeRate = 180; // percent rate of special charge, if need to charge 1.5%, this will be set 150
    uint256 public minMintAmount = 10 * 10 ** depositTokenDecimals;
    uint256 public minRedpacketMintAmount = 0;
    uint256 public taxRate = 2000;// means 20%
    uint256 public depositerShareRate = 5000; // depositer and withdrawer will share the bonus, this rate is for sender(depositer). 5000 means 50%;
    
    uint256 public defaultBCTHolderShareRate = 5000; // if depositer is BCT holder, the depositer and withdrawer will share the bonus according to this rate. 10000 means 100%
    mapping (address => uint256) public bctHolderShareRate;
    uint256 public bctHolderMultiplier = 5;
    uint256 public bctHolderSpecialTotalSupply = 1500000 * 10 ** 6;
    
    address public operator;                      // operator address
    address public taxBereauAddress;              // address to get tax

    address public tokenAddress;                  // BTCH token
    BTCHTokenInterface public token;
    address public bctAddress;                    // BCT (Bitcheck commitee token) address

    address public tokenLockerAddress;            // TokenLocker contract address
    address[] public shakerContractAddresses;         // Shaker contract address
    address[] public redpacketAddresses;

    modifier onlyOperator {
        require(msg.sender == operator, "Only operator can call this function.");
        _;
    }

    modifier onlyShaker {
        require(hasShakerContractAddress(msg.sender), "Only bitcheck contract can call this function.");
        _;
    }
    
    modifier onlyRedpacket {
        require(hasRedpacketContractAddress(msg.sender), "Only redpacket contract can call this function.");
        _;
    }
    
    constructor(
      address _taxBereauAddress, 
      address _bonusTokenAddress, 
      address _bctAddress,
      address _tokenLockerAddress
    ) public {
        operator = msg.sender;
        taxBereauAddress = _taxBereauAddress;
        tokenAddress = _bonusTokenAddress;
        token = BTCHTokenInterface(tokenAddress);
        bctAddress = _bctAddress;
        tokenLockerAddress = _tokenLockerAddress;
    }
    
    function sendBonus(uint256 _amount, uint256 _decimals, uint256 _hours, address _depositer, address _withdrawer) external nonReentrant onlyShaker returns(bool) {
        require(_amount < 1e28, "max is 1e28");
        if(_amount.div(10**(_decimals.sub(6))) <= minMintAmount) return true;
        (uint256 mintAmount, bool isBCTHolder) = this.getMintAmount(_amount.div(10 ** (_decimals.sub(6))), _hours, _depositer);
        if(mintAmount == 0) return true;
        uint256 tax = mintAmount.mul(taxRate).div(10000);
        uint256 notax = mintAmount.sub(tax);
        if(notax > 0) {
          uint256 shareRate = isBCTHolder ? (bctHolderShareRate[_depositer] > 0 ? bctHolderShareRate[_depositer] : defaultBCTHolderShareRate) : depositerShareRate;
          uint256 depositAmount = (notax.mul(shareRate).div(10000));
          uint256 withdrawalAmount = (notax.mul(uint256(10000).sub(shareRate)).div(10000));
          if(isBCTHolder) {
            // set tokenLocker
            if(depositAmount > 0) {
              TokenLockerInterface(tokenLockerAddress).setVestToken(_depositer, depositAmount);
              token.mint(tokenLockerAddress, depositAmount);
            }
            if(withdrawalAmount > 0) {
              TokenLockerInterface(tokenLockerAddress).setVestToken(_withdrawer, withdrawalAmount);
              token.mint(tokenLockerAddress, withdrawalAmount);
            }
          } else {
            if(depositAmount > 0) token.mint(_depositer, depositAmount);
            if(withdrawalAmount > 0) token.mint(_withdrawer, withdrawalAmount);
          }
        }
        if(tax > 0) token.mint(taxBereauAddress, tax);
        return true;
    }

    function sendRedpacketBonus(uint256 _amount, uint256 _decimals, uint256 _hours, address _depositer) external nonReentrant onlyRedpacket returns(bool) {
        require(_amount < 1e28, "max is 1e28");
        if(_amount.div(10**(_decimals.sub(6))) <= minRedpacketMintAmount) return true;
        (uint256 mintAmount, bool isBCTHolder) = this.getMintAmount(_amount.div(10 ** (_decimals.sub(6))), _hours, _depositer);
        if(mintAmount == 0) return true;
        uint256 tax = mintAmount.mul(taxRate).div(10000);
        uint256 notax = mintAmount.sub(tax);
        if(notax > 0) {
            if(isBCTHolder) {
                // set tokenLocker
                TokenLockerInterface(tokenLockerAddress).setVestToken(_depositer, notax);
                token.mint(tokenLockerAddress, notax);
            } else {
                token.mint(_depositer, notax);
            }
        }
        if(tax > 0) token.mint(taxBereauAddress, tax);
        return true;
    }
    
    function burn(uint256 _amount, address _from) external nonReentrant onlyShaker returns(bool) {
        token.burn(_from, _amount);
        return true;
    }
    
    function getMintAmount(uint256 _amount, uint256 _hours, address _depositer) external view returns(uint256, bool) {
        // return back bonus token amount with decimals
        // calculates base on decimals = 6, to avoid the memory leakage while calling getExponent()
        uint256 amountExponented = getExponent(_amount);
        uint256 stageFactor = getStageFactor();
        uint256 intervalFactor = getIntervalFactor(_hours);
        uint256 priceFactor = getPriceElasticFactor();
        uint256 bctBalance = getBCTBalance(_depositer);
        bool b = bctBalance > 0 && token.totalSupply() < bctHolderSpecialTotalSupply;
        uint256 bctMultiplier = b ? bctBalance.mul(bctHolderMultiplier) : 1;
        uint256 re = amountExponented.mul(priceFactor).mul(baseFactor).mul(intervalFactor).mul(stageFactor);
        re = re.div(1e11).mul(bctMultiplier);
        return (re, b);
    }

    function revokeVestToken(address _address) external {
        TokenLockerInterface(tokenLockerAddress).revoke(_address);
    }

    function getFee(uint256 _amount) external view returns(uint256) {
        // return fee amount, including decimals
        // calculates base on decimals = 6, to avoid the memory leakage while calling getExponent()
        require(_amount < 1e28, "max is 1e28");
        if(_amount <= minChargeFeeAmount) return getSpecialFee(_amount);
        uint256 amountExponented = getExponent(_amount);
        return amountExponented.mul(feeRate).div(1e5);
    }
    
    function getExponent(uint256 _amount) internal view returns(uint256) {
        // if 2000, the _amount should be 2000 * 10**decimals, return back 2000**(2/3) * 10**decimals
        if(_amount > 1e28) return 0;
        uint256 e = nthRoot(_amount, exponent[1], bonusTokenDecimals, 1e18);
        return e.mul(e).div(10 ** (bonusTokenDecimals + depositTokenDecimals * exponent[0] / exponent[1]));
    }
    
    function getStageFactor() internal view returns(uint256) {
        uint256 tokenTotalSupply = getTokenTotalSupply();
        uint256 stage = tokenTotalSupply.div(eachStageAmount);
        return stageFactors[stage > stageFactors.length - 1 ? stageFactors.length - 1 : stage];
    }

    function getIntervalFactor(uint256 _hours) internal view returns(uint256) {
        uint256 id = intervalOfDepositWithdraw.length - 1;
        for(uint8 i = 0; i < intervalOfDepositWithdraw.length; i++) {
            if(intervalOfDepositWithdraw[i] > _hours) {
                id = i == 0 ? 999 : i - 1;
                break;
            }
        }
        return id == 999 ? 0 : intervalOfDepositWithdrawFactor[id];
    }
    
    // For tesing, Later will update ######
    function getPriceElasticFactor() internal pure returns(uint256) {
        return 1;
    }

    function getTokenTotalSupply() public view returns(uint256) {
        return token.totalSupply();
    }
    
    function getSpecialFee(uint256 _amount) internal view returns(uint256) {
        return _amount.mul(minChargeFeeRate).div(10000).add(minChargeFee);        
    }
    // calculates a^(1/n) to dp decimal places
    // maxIts bounds the number of iterations performed
    function nthRoot(uint _a, uint _n, uint _dp, uint _maxIts) internal pure returns(uint) {
        assert (_n > 1);

        // The scale factor is a crude way to turn everything into integer calcs.
        // Actually do (a * (10 ^ ((dp + 1) * n))) ^ (1/n)
        // We calculate to one extra dp and round at the end
        uint one = 10 ** (1 + _dp);
        uint a0 = one ** _n * _a;

        // Initial guess: 1.0
        uint xNew = one;
        uint x;
        uint iter = 0;
        while (xNew != x && iter < _maxIts) {
            x = xNew;
            uint t0 = x ** (_n - 1);
            if (x * t0 > a0) {
                xNew = x - (x - a0 / t0) / _n;
            } else {
                xNew = x + (a0 / t0 - x) / _n;
            }
            ++iter;
        }

        // Round to nearest in the last dp.
        return (xNew + 5) / 10;
    }
    
    function setStageFactors(uint256[] calldata _stageFactors) external onlyOperator {
        stageFactors = _stageFactors;
    }
    
    function setIntervalOfDepositWithdraw(uint256[] calldata _intervalOfDepositWithdraw, uint256[] calldata _intervalOfDepositWithdrawFactor) external onlyOperator {
      intervalOfDepositWithdrawFactor = _intervalOfDepositWithdrawFactor;
      intervalOfDepositWithdraw = _intervalOfDepositWithdraw;
    }

    function setBaseFactor(uint256 _baseFactor) external onlyOperator {
        baseFactor = _baseFactor;
    }
    
    function setBonusTokenDecimals(uint256 _decimals) external onlyOperator {
        require(_decimals >= 0);
        bonusTokenDecimals = _decimals;
    }
    
    function setDeositTokenDecimals(uint256 _decimals) external onlyOperator {
        require(_decimals >= 0);
        depositTokenDecimals = _decimals;
    }

    function setTokenAddress(address _address) external onlyOperator {
        tokenAddress = _address;
        token = BTCHTokenInterface(tokenAddress);
    }
    
    function setShakerContractAddress(address _shakerContractAddress) external onlyOperator {
        if(!hasShakerContractAddress(_shakerContractAddress)) shakerContractAddresses.push(_shakerContractAddress);
    }
    
    function hasShakerContractAddress(address _address) internal view returns(bool) {
        bool ok = false;
        for(uint256 i = 0; i < shakerContractAddresses.length; i++) {
            if(_address == shakerContractAddresses[i]) {
                ok = true;
                break;
            }
        }
        return ok;
    }
    
    function hasRedpacketContractAddress(address _address) internal view returns(bool) {
        bool ok = false;
        for(uint256 i = 0; i < redpacketAddresses.length; i++) {
            if(_address == redpacketAddresses[i]) {
                ok = true;
                break;
            }
        }
        return ok;
    }
    function setExponent(uint256[] calldata _exp) external onlyOperator {
        require(_exp.length == 2 && _exp[1] >= 0);
        exponent = _exp;
    }
    
    function setEachStageAmount(uint256 _eachStageAmount) external onlyOperator {
        require(_eachStageAmount >= 0);
        eachStageAmount = _eachStageAmount;
    }

    function setMinChargeFeeParams(uint256 _maxAmount, uint256 _minFee, uint256 _feeRate) external onlyOperator {
        minChargeFeeAmount = _maxAmount;
        minChargeFee = _minFee;
        minChargeFeeRate = _feeRate;
    }
    
    function setMinMintAmount(uint256 _amount) external onlyOperator {
        require(_amount >= 0);
        minMintAmount = _amount;
    }
    
    function setFeeRate(uint256 _feeRate) external onlyOperator {
        require(_feeRate <= 100000 && _feeRate >= 0);
        feeRate = _feeRate;
    }
    
    function setTaxBereauAddress(address _taxBereauAddress) external onlyOperator {
        taxBereauAddress = _taxBereauAddress;
    }
    
    function setTaxRate(uint256 _rate) external onlyOperator {
        require(_rate <= 10000 && _rate >= 0);
        taxRate = _rate;
    }

    function setDepositerShareRate(uint256 _rate) external onlyOperator {
        require(_rate <= 10000 && _rate >= 0);
        depositerShareRate = _rate;
    }

    function updateOperator(address _newOperator) external onlyOperator {
        require(_newOperator != address(0));
        operator = _newOperator;
    }

    function getBCTBalance(address _address) internal view returns(uint256) {
        return ERC20Interface(bctAddress).balanceOf(_address);
    }

    function setBCTAddress(address _address) external onlyOperator {
        require(_address != address(0));
        bctAddress = _address;
    }

    function setBCTHolderMultiplier(uint256 _multiplier) external onlyOperator {
        bctHolderMultiplier = _multiplier;
    }

    function setBCTHolderShareRate(uint256 _shareRate) external {
        require(_shareRate >= 0 && _shareRate <= 10000);
        require(getBCTBalance(msg.sender) > 0, 'you are not BCT holder');
        bctHolderShareRate[msg.sender] = _shareRate;
    }
    function setTokenLockerAddress(address _address) external onlyOperator {
      tokenLockerAddress = _address;
    }
    function setBCTHolderSpecialTotalSupply(uint256 _specialTotalSupply) external onlyOperator {
      bctHolderSpecialTotalSupply = _specialTotalSupply;
    }
    function setRedpacketAddress(address _address) external onlyOperator {
        if(!hasRedpacketContractAddress(_address)) redpacketAddresses.push(_address);
    }
    
    function setMinRedpacketMintAmount(uint256 _minRedpacketMintAmount) external onlyOperator {
        minRedpacketMintAmount = _minRedpacketMintAmount;
    }
}