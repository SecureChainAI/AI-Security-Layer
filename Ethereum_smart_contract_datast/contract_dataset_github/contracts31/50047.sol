pragma solidity ^0.5.8;

import "./ERCinterface.sol";
import "./SafeMath.sol";

contract ERClock {
 
    mapping(address => bytes32[]) public lockReason;

    struct lockToken {
        uint256 amount;
        uint256 validity;
        bool claimed;
    }

    mapping(address => mapping(bytes32 => lockToken)) public locked;

    event Locked(
        address indexed _of,
        bytes32 indexed _reason,
        uint256 _amount,
        uint256 _validity
    );

    event Unlocked(
        address indexed _of,
        bytes32 indexed _reason,
        uint256 _amount
    );
    
    function lock(bytes32 _reason, uint256 _amount, uint256 _time , address _of) public onlyOwner returns (bool) ;
  

    function tokensLocked(address _of, bytes32 _reason)
        public view returns (uint256 amount);
    
 
    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
        public view returns (uint256 amount);
    

    function totalBalanceOf(address _of)
        public view returns (uint256 amount);
    

    function extendLock(bytes32 _reason, uint256 _time, address _of) public onlyOwner returns (bool) ;
    
 
    function increaseLockAmount(bytes32 _reason, uint256 _amount, address _of) public onlyOwner returns (bool) ;

    function tokensUnlockable(address _of, bytes32 _reason)
        public view returns (uint256 amount);
 
 
    function unlock(address _of)
        public returns (uint256 unlockableTokens);

 
    function getUnlockableTokens(address _of)
        public view returns (uint256 unlockableTokens);

}


contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }


    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

 
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

 
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }

 
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }

 
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }


    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

 
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

 
    function _approve(address owner, address spender, uint256 value) internal {
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }


    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}


contract ERC20Burnable is ERC20 {

    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }


    function burnFrom(address from, uint256 value) public {
        _burnFrom(from, value);
    }
}


contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }

 
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

contract contract is ERC20, ERC20Burnable, ERC20Detailed, ERClock {
    uint8 public constant DECIMALS = 18;
    uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS)); 

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public ERC20Detailed( name, symbol, decimals) {
        _mint(msg.sender, INITIAL_SUPPLY); 
    }
    
    string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
	string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
	string internal constant ALREADY_LOCKED = 'Tokens already locked';
	string internal constant NOT_LOCKED = 'No tokens locked';
	string internal constant AMOUNT_ZERO = 'Amount can not be 0';
    
    
    function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyOwner returns (bool) {
       uint256 validUntil = now.add(_time); //solhint-disable-line

	// If tokens are already locked, then functions extendLock or
	// increaseLockAmount should be used to make any changes
    	require(_amount <= balances[_of], NOT_ENOUGH_TOKENS); // 추가
    	require(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);
    	require(_amount != 0, AMOUNT_ZERO);

	if (locked[_of][_reason].amount == 0)
		lockReason[_of].push(_reason);

    // transfer(address(this), _amount); // 수정
	balances[address(this)] = balances[address(this)].add(_amount);
	balances[_of] = balances[_of].sub(_amount);

	locked[_of][_reason] = lockToken(_amount, validUntil, false);

    // 수정
	emit Transfer(_of, address(this), _amount);
	emit Locked(_of, _reason, _amount, validUntil);
	return true;
}
    

    function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
        public
        returns (bool)
    {
        uint256 validUntil = now.add(_time); //solhint-disable-line

        require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
        require(_amount != 0, AMOUNT_ZERO);

        if (locked[_to][_reason].amount == 0)
            lockReason[_to].push(_reason);

        transfer(address(this), _amount);

        locked[_to][_reason] = lockToken(_amount, validUntil, false);
        
        emit Locked(_to, _reason, _amount, validUntil);
        return true;
    }


    function tokensLocked(address _of, bytes32 _reason)
        public
        view
        returns (uint256 amount)
    {
        if (!locked[_of][_reason].claimed)
            amount = locked[_of][_reason].amount;
    }
    
 
    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
        public
        view
        returns (uint256 amount)
    {
        if (locked[_of][_reason].validity > _time)
            amount = locked[_of][_reason].amount;
    }


    function totalBalanceOf(address _of)
        public
        view
        returns (uint256 amount)
    {
        amount = balanceOf(_of);

        for (uint256 i = 0; i < lockReason[_of].length; i++) {
            amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
        }   
    }    
    
 
    function extendLock(bytes32 _reason, uint256 _time, address _of) public onlyOwner returns (bool) {
        require(tokensLocked(_of, _reason) > 0, NOT_LOCKED);

        locked[_of][_reason].validity = locked[_of][_reason].validity.add(_time);

        emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
        return true;
    }
    

    function increaseLockAmount(bytes32 _reason, uint256 _amount, address _of) public onlyOwner returns (bool) {
        require(tokensLocked(_of, _reason) > 0, NOT_LOCKED);
        transfer(address(this), _amount);

        locked[_of][_reason].amount = locked[_of][_reason].amount.add(_amount);

        emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
        return true;
    }

 
    function tokensUnlockable(address _of, bytes32 _reason)
        public
        view
        returns (uint256 amount)
    {
        if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
            amount = locked[_of][_reason].amount;
    }


    function unlock(address _of)
        public
        returns (uint256 unlockableTokens)
    {
        uint256 lockedTokens;

        for (uint256 i = 0; i < lockReason[_of].length; i++) {
            lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
            if (lockedTokens > 0) {
                unlockableTokens = unlockableTokens.add(lockedTokens);
                locked[_of][lockReason[_of][i]].claimed = true;
                emit Unlocked(_of, lockReason[_of][i], lockedTokens);
            }
        }  

        if (unlockableTokens > 0)
            this.transfer(_of, unlockableTokens);
    }

 
    function getUnlockableTokens(address _of)
        public
        view
        returns (uint256 unlockableTokens)
    {
        for (uint256 i = 0; i < lockReason[_of].length; i++) {
            unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
        }  
    }
    
}