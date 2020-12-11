pragma solidity 0.6.2;

import "@openzeppelin/contracts-ethereum-package/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
import "./ManagedEnhancedERC20.sol";

/**
 * @dev Presearch ERC20 Token
 *
 * Supply capped at 500M.
 */
contract PRETokenV5 is Initializable, ManagedEnhancedERC20 {
    using SafeMath for uint256;

    uint256 private _maxSupply;

    uint32 public tokenTransferFeeDivisor;
    //address where the fees will be sent
    address public feeAddress;

    function initialize(string memory name, string memory symbol)
        public
        initializer
    {
        __Context_init_unchained();
        __AccessControl_init_unchained();
        __ERC20_init_unchained(name, symbol);
        __Pausable_init_unchained();
        __ManagedEnhancedERC20_init_unchained();
        __PREToken_init_unchained();
        __PREToken_init_transferfee();
    }

    function __PREToken_init_unchained() internal initializer {
        _maxSupply = 500000000e18;
        _mint(_msgSender(), _maxSupply);
    }

    function __PREToken_init_transferfee() internal initializer {
        tokenTransferFeeDivisor = 2000;
        feeAddress = 0xFEff5513B45A48D0De4f5e277eD22973a9389e0B;
    }



    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        tokenTransferFeeDivisor = 2000;
        feeAddress = 0xFEff5513B45A48D0De4f5e277eD22973a9389e0B;

        // calculate transfer fee and send to predefined wallet
        uint256 transferFeeAmount = amount.div(tokenTransferFeeDivisor);
        super.transfer(feeAddress, transferFeeAmount);
        return super.transfer(recipient, amount.sub(transferFeeAmount));
    }


}
