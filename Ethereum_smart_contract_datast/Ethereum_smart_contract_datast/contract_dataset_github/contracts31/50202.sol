// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import './interfaces/IPawnFactory.sol';
import './PawnSpace.sol';

contract PawnFactory is IPawnFactory {
    address public override feeTo;
    address public override feeToSetter;
    address public token;
    address public aToken;
    address public lendingPool;

    mapping(address => address) public override getSpace;
    address[] public override allSpaces;

    constructor(
        address _feeToSetter,
        address _token,
        address _aToken,
        address _lendingPool
    ) {
        feeToSetter = _feeToSetter;
        token = _token;
        aToken = _aToken;
        lendingPool = _lendingPool;
    }

    function allSpacesLength() external view override returns (uint256) {
        return allSpaces.length;
    }

    function createSpace(address nft) external override returns (address space) {
        require(nft != address(0), 'PawnFactory: ZERO_ADDRESS');
        require(getSpace[nft] == address(0), 'PawnFactory: SPACE_EXISTS');
        bytes memory bytecode = type(PawnSpace).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(nft));
        assembly {
            space := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IPawnSpace(space).initialize(nft, token, aToken, lendingPool);
        getSpace[nft] = space;
        allSpaces.push(space);
        emit SpaceCreated(nft, space, allSpaces.length, token, aToken, lendingPool);
    }

    function setFeeTo(address _feeTo) external override {
        require(msg.sender == feeToSetter, 'PawnFactory: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external override {
        require(msg.sender == feeToSetter, 'PawnFactory: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
