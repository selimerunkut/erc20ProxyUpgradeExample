pragma solidity 0.6.2;

import "@openzeppelin/contracts-ethereum-package/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/access/AccessControl.sol";
import "./EnhancedERC20.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/utils/Pausable.sol";

/**
 * @dev ERC20 token with pausable token transfers.
 *
 * Useful as an emergency switch for freezing all token transfers in the
 * event of a large bug or major project-impacting event.
 */
abstract contract ManagedEnhancedERC20 is
    Initializable,
    ContextUpgradeSafe,
    AccessControlUpgradeSafe,
    EnhancedERC20,
    PausableUpgradeSafe
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant FEE_EXCLUDED_ROLE = keccak256("FEE_EXCLUDED_ROLE");

    uint32 public tokenTransferFeeDivisor;
    //address where the fees will be sent
    address public feeAddress;

    function __ManagedEnhancedERC20_init(
        string memory name,
        string memory symbol
    ) internal initializer {
        __Context_init_unchained();
        __AccessControl_init_unchained();
        __ERC20_init_unchained(name, symbol);
        __Pausable_init_unchained();
        __ManagedEnhancedERC20_init_unchained();
    }

    function __ManagedEnhancedERC20_init_unchained() internal initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
        _setupRole(FEE_EXCLUDED_ROLE, _msgSender());
        //TODO not set during intializiation
        setMintingFeeAddress(0xFEff5513B45A48D0De4f5e277eD22973a9389e0B);
        //TODO not set during intializiation
        setMintingFeePercent(2000);


    }

    // minting process does not involve fees (by design)
    function mintWithoutDecimals(address recipient, uint256 amount) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "PauseableEnhancedERC20: must have admin role to mint"
        );

        return super._mint(recipient, amount * 1000000000000000000);
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        if (hasRole(FEE_EXCLUDED_ROLE, _msgSender())) {
            super.transfer(recipient, amount);
        } else return super.transfer(recipient, _calculateAmountSubTransferFee(amount));      
    }

    function setMintingFeeAddress(address _feeAddress) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "PauseableEnhancedERC20: must have admin role to set minting fee address"
        );

        feeAddress = _feeAddress;
    }

    function setMintingFeePercent(uint32 _tokenTransferFeeDivisor) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "PauseableEnhancedERC20: must have admin role to set minting fee address"
        );

        tokenTransferFeeDivisor = _tokenTransferFeeDivisor;
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public {
        require(
            hasRole(PAUSER_ROLE, _msgSender()),
            "PauseableEnhancedERC20: must have pauser role to pause"
        );
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public {
        require(
            hasRole(PAUSER_ROLE, _msgSender()),
            "PauseableEnhancedERC20: must have pauser role to unpause"
        );
        _unpause();
    }

    /**
     * @dev See {EnhancedERC20-_beforeTokenTransferBatch}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */

    function _beforeTokenTransferBatch() internal virtual override {
        super._beforeTokenTransferBatch();
        require(!paused(), "ManagedEnhancedERC20: token transfer while paused");
    }

    // calculate transfer fee and send to predefined wallet
    function _calculateAmountSubTransferFee(uint256 amount) private returns (uint256){
            uint256 transferFeeAmount = amount.div(tokenTransferFeeDivisor);
            super.transfer(feeAddress, transferFeeAmount);
            return amount.sub(transferFeeAmount);
    }

    uint256[50] private __gap;
}
