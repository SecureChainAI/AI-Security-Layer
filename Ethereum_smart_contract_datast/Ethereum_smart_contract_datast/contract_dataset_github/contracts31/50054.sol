// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import './interfaces/IPawnSpace.sol';
import './interfaces/IPawnFactory.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import '@openzeppelin/contracts/utils/EnumerableSet.sol';
import './interfaces/ILendingPool.sol';

contract PawnSpace is IPawnSpace, ERC721 {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.UintSet;
    using SafeERC20 for IERC20;

    uint256 public constant MINIMUM_LIQUIDITY = 10**3;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
    address public stableTokenAddress;
    IERC20 public stableToken;
    IERC20 public aToken;
    ILendingPool public lendingPool;

    address public override factory;
    address public override nftToken;
    uint256 internal _orderId;
    uint256 internal _offerId;

    struct Order {
        uint256[] tokenIds;
        uint256 requestAmount;
        uint256 interest;
        uint256 period;
        uint256 additionalCollateral;
        address offeror;
        uint256 createdAt;
        uint256 offeredAt;
        uint256 paidBackAt;
        uint256 withdrewAt;
    }

    mapping(uint256 => Order) public orders;
    uint256 totalAdditionalCollateral;

    function getOrders() external view override returns (uint256[] memory ids) {
        require(totalSupply() > 0, 'PawnSpace: NONEXIST_ORDERS');

        ids = new uint256[](totalSupply());
        for (uint256 i = 0; i < ids.length; i++) {
            ids[i] = tokenByIndex(i);
        }
    }

    function getNotAcceptedOrders() external view override returns (uint256[] memory ids) {
        require(totalSupply() > 0, 'PawnSpace: NONEXIST_ORDERS');

        ids = new uint256[](totalSupply());
        for (uint256 i = 0; i < totalSupply(); i++) {
            uint256 id = tokenByIndex(i);
            Order memory _order = orders[id];
            if (_order.offeror == address(0)) {
                ids[i] = id;
            }
        }

        return ids;
    }

    function getOrder(uint256 id)
        external
        view
        override
        returns (
            uint256[] memory tokenIds,
            address owner,
            uint256 requestAmount,
            uint256 interest,
            uint256 period,
            uint256 additionalCollateral,
            address offeror,
            uint256 createdAt,
            uint256 offeredAt,
            uint256 paidBackAt,
            uint256 withdrewAt
        )
    {
        require(_exists(id), 'PawnSpace: NONEXIST_ORDER');

        owner = ownerOf(id);
        tokenIds = orders[id].tokenIds;
        requestAmount = orders[id].requestAmount;
        interest = orders[id].interest;
        period = orders[id].period;
        additionalCollateral = orders[id].additionalCollateral;
        offeror = orders[id].offeror;
        createdAt = orders[id].createdAt;
        offeredAt = orders[id].offeredAt;
        paidBackAt = orders[id].paidBackAt;
        withdrewAt = orders[id].withdrewAt;
    }

    constructor() ERC721('PawnSpace', 'PWN') {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(
        address _nft,
        address _token,
        address _aToken,
        address _lendingPool
    ) external override {
        require(msg.sender == factory, 'PawnSpace: FORBIDDEN'); // sufficient check
        nftToken = _nft;
        stableTokenAddress = _token;
        stableToken = IERC20(stableTokenAddress);
        aToken = IERC20(_aToken);
        lendingPool = ILendingPool(_lendingPool);
    }

    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return '0';
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }

    function order(
        uint256[] calldata tokenIds,
        uint256 requestAmount,
        uint256 interest,
        uint256 period,
        uint256 additionalCollateral
    ) external override returns (uint256 orderId) {
        require(tokenIds.length > 0, 'PawnSpace: NO_NFT');
        require(requestAmount > 0, 'PawnSpace: ZERO_REQUEST');

        // Receive Collateral Tokens
        for (uint256 i = 0; i < tokenIds.length; i++) {
            IERC721(nftToken).transferFrom(msg.sender, address(this), tokenIds[i]);
        }

        // Deposit token to Aave
        stableToken.transferFrom(msg.sender, address(this), additionalCollateral);
        stableToken.approve(address(lendingPool), additionalCollateral);
        lendingPool.deposit(stableTokenAddress, additionalCollateral, address(this), 0);

        // Save Info
        orders[_orderId] = Order({
            tokenIds: tokenIds,
            requestAmount: requestAmount,
            interest: interest,
            period: period,
            additionalCollateral: additionalCollateral,
            offeror: address(0),
            createdAt: block.timestamp,
            offeredAt: 0,
            paidBackAt: 0,
            withdrewAt: 0
        });
        totalAdditionalCollateral = totalAdditionalCollateral.add(additionalCollateral);

        // Mint Order Token
        orderId = _orderId;
        _orderId = _orderId.add(1);
        _mint(msg.sender, orderId);

        emit MintOrder(
            msg.sender,
            orderId,
            tokenIds,
            requestAmount,
            interest,
            period,
            additionalCollateral,
            block.timestamp
        );
    }

    function burnOrder(uint256 orderId) external override {
        require(_exists(orderId), 'PawnSpace: NONEXIST_ORDER');
        require(ownerOf(orderId) == msg.sender, 'PawnSpace: NOT_OWNER');
        require(orders[orderId].offeredAt == 0, 'PawnSpace: ALREADY_OFFERED');

        // Return Collateral Tokens
        for (uint256 i = 0; i < orders[orderId].tokenIds.length; i++) {
            IERC721(nftToken).transferFrom(address(this), msg.sender, orders[orderId].tokenIds[i]);
        }

        // Withdraw token from Aave
        uint256 balance = aToken.balanceOf(address(this));
        uint256 additionalCollateral = orders[orderId].additionalCollateral.mul(balance).div(totalAdditionalCollateral);
        lendingPool.withdraw(stableTokenAddress, additionalCollateral, msg.sender);
        totalAdditionalCollateral = totalAdditionalCollateral.sub(orders[orderId].additionalCollateral);

        // Burn Order Token
        _burn(orderId);
        emit BurnOrder(msg.sender, orderId);
    }

    function offer(uint256 orderId) external override {
        require(_exists(orderId), 'PawnSpace: NONEXIST_ORDER');
        require(ownerOf(orderId) != msg.sender, 'PawnSpace: FORBIDDEN');
        require(orders[orderId].offeredAt == 0, 'PawnSpace: ALREADY_OFFERED');
        require(stableToken.balanceOf(msg.sender) >= orders[orderId].requestAmount, 'PawnSpace: NOT_ENOUGH_BALANCE');
        require(
            stableToken.allowance(msg.sender, address(this)) >= orders[orderId].requestAmount,
            'PawnSpace: NO_ALLOWANCE'
        );

        // Save Info
        orders[orderId].offeror = msg.sender;
        orders[orderId].offeredAt = block.timestamp;

        // Lending
        stableToken.safeTransferFrom(msg.sender, ownerOf(orderId), orders[orderId].requestAmount);

        emit Offer(msg.sender, orderId, block.timestamp);
    }

    function payBack(uint256 orderId) external override {
        require(_exists(orderId), 'PawnSpace: NONEXIST_ORDER');
        require(ownerOf(orderId) == msg.sender, 'PawnSpace: NOT_OWNER');
        require(orders[orderId].offeredAt > 0, 'PawnSpace: NOT_OFFERED');
        require(orders[orderId].offeredAt.add(orders[orderId].period) > block.timestamp, 'PawnSpace: EXPIRED');
        require(orders[orderId].paidBackAt == 0, 'PawnSpace: ALREADY_PAIDLOAN');

        // Save Info
        orders[orderId].paidBackAt = block.timestamp;

        // Pay Loan
        stableToken.safeTransferFrom(
            msg.sender,
            orders[orderId].offeror,
            orders[orderId].requestAmount.add(orders[orderId].interest)
        );

        // Send Back NFT tokens
        for (uint256 i = 0; i < orders[orderId].tokenIds.length; i++) {
            IERC721(nftToken).transferFrom(address(this), msg.sender, orders[orderId].tokenIds[i]);
        }

        // Withdraw token from Aave
        uint256 balance = aToken.balanceOf(address(this));
        uint256 additionalCollateral = orders[orderId].additionalCollateral.mul(balance).div(totalAdditionalCollateral);
        lendingPool.withdraw(stableTokenAddress, additionalCollateral, msg.sender);
        totalAdditionalCollateral = totalAdditionalCollateral.sub(orders[orderId].additionalCollateral);

        emit Payback(msg.sender, orderId, block.timestamp);
    }

    function withdraw(uint256 orderId) external override {
        require(_exists(orderId), 'PawnSpace: NONEXIST_ORDER');
        require(orders[orderId].offeror == msg.sender, 'PawnSpace: NOT_LENDER');
        require(orders[orderId].offeredAt > 0, 'PawnSpace: NOT_OFFERED');
        require(orders[orderId].offeredAt.add(orders[orderId].period) <= block.timestamp, 'PawnSpace: NOT_EXPIRED');
        require(orders[orderId].withdrewAt == 0, 'PawnSpace: ALREADY_WITHDRAWN');

        // Save Info
        orders[orderId].withdrewAt = block.timestamp;

        // Withdraw NFT tokens
        for (uint256 i = 0; i < orders[orderId].tokenIds.length; i++) {
            IERC721(nftToken).transferFrom(address(this), msg.sender, orders[orderId].tokenIds[i]);
        }

        emit Withdraw(msg.sender, orderId, block.timestamp);
    }
}
