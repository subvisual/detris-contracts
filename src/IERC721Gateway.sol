// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;
pragma experimental ABIEncoderV2;

/**
 * @title IERC721Gateway
 */
interface IERC721Gateway {
    /**********
     * Events *
     **********/

    event DepositInitiated(
        address indexed _from,
        address _to,
        uint256 _tokenId
    );

    event WithdrawalFinalized(address indexed _to, uint256 _tokenId);

    /********************
     * Public Functions *
     ********************/

    function deposit(uint256 _tokenId) external;

    function depositTo(address _to, uint256 _tokenId) external;

    /*************************
     * Cross-chain Functions *
     *************************/

    function finalizeWithdrawal(address _to, uint256 _tokenId) external;
}
