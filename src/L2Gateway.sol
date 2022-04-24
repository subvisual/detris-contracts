// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/* Interface Imports */

import {Detris} from "./Detris.sol";
import {IL2DepositedERC721} from "./IL2DepositedERC721.sol";
import {IERC721Gateway} from "./IERC721Gateway.sol";

/* Library Imports */
import {CrossDomainEnabled} from "@eth-optimism/contracts/libraries/bridge/CrossDomainEnabled.sol";

/**
 * @title Abs_DepositedERC721
 * @dev An Deposited Token is a representation of funds which were deposited from the other side
 * Usually contract mints new tokens when it hears about deposits from the other side.
 * This contract also burns the tokens intended for withdrawal, informing the gateway to release the funds.
 *
 * NOTE: This abstract contract gives all the core functionality of a deposited token implementation except for the
 * token's internal accounting itself.  This gives developers an easy way to implement children with their own token code.
 *
 * Compiler used: solc, optimistic-solc
 * Runtime target: EVM or OVM
 */
contract L2Gateway is IL2DepositedERC721, CrossDomainEnabled, Detris {
    /*******************
     * Contract Events *
     *******************/

    event Initialized(IERC721Gateway tokenGateway);

    /********************************
     * External Contract References *
     ********************************/

    IERC721Gateway public tokenGateway;

    /********************************
     * Constructor & Initialization *
     ********************************/

    /**
     * @param _messenger Messenger address being used for cross-chain communications.
     */
    constructor(address _messenger, string memory baseTokenURI)
        CrossDomainEnabled(_messenger)
        Detris(baseTokenURI)
    {}

    /**
     * @dev Initialize this contract with the token gateway address on the otehr side.
     * The flow: 1) this contract gets deployed on one side, 2) the
     * gateway is deployed with addr from (1) on the other, 3) gateway address passed here.
     *
     * @param _tokenGateway Address of the corresponding gateway deployed to the other side
     */

    function init(IERC721Gateway _tokenGateway) public {
        require(
            address(tokenGateway) == address(0),
            "Contract has already been initialized"
        );

        tokenGateway = _tokenGateway;

        emit Initialized(tokenGateway);
    }

    /**********************
     * Function Modifiers *
     **********************/

    modifier onlyInitialized() {
        require(
            address(tokenGateway) != address(0),
            "Contract has not yet been initialized"
        );
        _;
    }

    /********************************
     * Overridable Accounting logic *
     ********************************/

    // Default gas value which can be overridden if more complex logic runs on L2.
    uint32 constant DEFAULT_FINALIZE_WITHDRAWAL_GAS = 1200000;

    /**
     * @dev Core logic to be performed when a withdrawal from L2 is initialized.
     * In most cases, this will simply burn the withdrawn L2 funds.
     *
     * param _to Address being withdrawn to
     * param _tokenId Token being withdrawn
     */

    // When a withdrawal is initiated, we burn the withdrawer's token to prevent subsequent usage.
    function _handleInitiateWithdrawal(
        address, // _to,
        uint256 _tokenId
    ) internal {
        _burn(_tokenId);
    }

    // When a deposit is finalized, we mint a new token to the designated account
    function _handleFinalizeDeposit(
        address _to,
        uint256 _tokenId,
        string memory _tokenURI
    ) internal {
        _mint(_to, _tokenId);
    }

    /**
     * @dev Overridable getter for the *Other side* gas limit of settling the withdrawal, in the case it may be
     * dynamic, and the above public constant does not suffice.
     *
     */

    function getFinalizeWithdrawalGas() public view virtual returns (uint32) {
        return DEFAULT_FINALIZE_WITHDRAWAL_GAS;
    }

    /***************
     * Withdrawing *
     ***************/

    /**
     * @dev initiate a withdraw of an ERC721 to the caller's account on the other side
     * @param _tokenId ERC721 token to withdraw
     */
    function withdraw(uint256 _tokenId) external override onlyInitialized {
        _initiateWithdrawal(msg.sender, _tokenId);
    }

    /**
     * @dev initiate a withdraw of an ERC721 to a recipient's account on the other side
     * @param _to adress to credit the withdrawal to
     * @param _tokenId ERC721 token to withdraw
     */
    function withdrawTo(address _to, uint256 _tokenId)
        external
        override
        onlyInitialized
    {
        _initiateWithdrawal(_to, _tokenId);
    }

    /**
     * @dev Performs the logic for withdrawals
     *
     * @param _to Account to give the withdrawal to on the other side
     * @param _tokenId ERC721 token to withdraw
     */
    function _initiateWithdrawal(address _to, uint256 _tokenId) internal {
        // Call our withdrawal accounting handler implemented by child contracts (usually a _burn)
        _handleInitiateWithdrawal(_to, _tokenId);

        // Construct calldata for ERC721Gateway.finalizeWithdrawal(_to, _tokenId)
        bytes memory data = abi.encodeWithSelector(
            IERC721Gateway.finalizeWithdrawal.selector,
            _to,
            _tokenId
        );

        // Send message up to L1 gateway
        sendCrossDomainMessage(
            address(tokenGateway),
            getFinalizeWithdrawalGas(),
            data
        );

        emit WithdrawalInitiated(msg.sender, _to, _tokenId);
    }

    /************************************
     * Cross-chain Function: Depositing *
     ************************************/

    /**
     * @dev Complete a deposit, and credits funds to the recipient's balance of the
     * specified ERC721
     * This call will fail if it did not originate from a corresponding deposit in OVM_ERC721Gateway.
     *
     * @param _to Address to receive the withdrawal at
     * @param _tokenId ERC721 to deposit
     * @param _tokenURI URI of the token being deposited
     */
    function finalizeDeposit(
        address _to,
        uint256 _tokenId,
        string memory _tokenURI
    )
        external
        override
        onlyInitialized
        onlyFromCrossDomainAccount(address(tokenGateway))
    {
        _handleFinalizeDeposit(_to, _tokenId, _tokenURI);
        emit DepositFinalized(_to, _tokenId, _tokenURI);
    }
}
