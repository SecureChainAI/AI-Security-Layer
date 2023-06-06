pragma solidity 0.5.16;
import "./BEP20.sol";

contract BEP81 is Ownable, BEP20Token {


     /* Nonces of transfers performed */
    mapping(bytes32 => bool) transactionHashes;
    event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
    event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
    
     /**
     * @notice Submit a presigned transfer
     * @param _to address The address which you want to transfer to.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function executeByFee(
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce,
        uint8 v, 
        bytes32 r, 
        bytes32 s
    )
        public
        onlyOwner
        returns (bool)
    {
        require(_to != address(0), 'Invalid _to address');
        bytes32 hashedTx = keccak256(abi.encodePacked('transferPreSigned', address(this), _to, _value, _fee, _nonce));
        require(transactionHashes[hashedTx] == false, 'transaction hash is already used');
        address from = ecrecover(keccak256(abi.encodePacked("x19Ethereum Signed Message:n32", hashedTx)),v,r,s);
        require(from == _from, 'Invalid _from address');
        

        _balances[from] = _balances[from].sub(_value).sub(_fee);
        _balances[_to] = _balances[_to].add(_value);
        _balances[msg.sender] = _balances[msg.sender].add(_fee);
        transactionHashes[hashedTx] = true;
        emit Transfer(from, _to, _value);
        emit Transfer(from, msg.sender, _fee);
        emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
        return true;
    }
	
	    
    function signedHash(
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce,
        uint8 v, 
        bytes32 r, 
        bytes32 s
    )
        public
        view
        returns (address)
    {
        bytes32 hashedTx = keccak256(abi.encodePacked(address(this), _to, _value, _fee, _nonce));
        return ecrecover(keccak256(abi.encodePacked("x19Ethereum Signed Message:n32", hashedTx)),v,r,s);
    }


}