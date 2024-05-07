// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {
    IRateProvider,
    TokenConfig,
    TokenType
} from "../contracts/interfaces/VaultTypes.sol";
import {IVault} from "../contracts/interfaces/IVault.sol";
import {IRouter} from "../contracts/interfaces/IRouter.sol";
import {Script} from "forge-std/Script.sol";

/**
 * @title HelperConfig Script
 * @author BuidlGuidl Labs
 * @dev This script is where all configurations are set for the factory deployment, pool deployment, and pool initialization
 * @dev Each pool deployed must have a unique name
 */
contract HelperConfig {
    // BalancerV3 Sepolia addresses
    IVault public vault = IVault(0x1FC7F1F84CFE61a04224AC8D3F87f56214FeC08c);
    IRouter public router = IRouter(0xA0De078cd5cFa7088821B83e0bD7545ccfb7c883);

    /**
     * @dev Set the pause window duration for the pool factory here
     */
    function getFactoryConfig()
        public
        pure
        returns (uint256 pauseWindowDuration)
    {
        pauseWindowDuration = 365 days;
    }

    /**
     * @dev Set the name, symbol, and token configuration for the pool here
     */
    function getPoolConfig(
        IERC20 token1,
        IERC20 token2
    )
        public
        pure
        returns (
            string memory name,
            string memory symbol,
            TokenConfig[] memory tokenConfig
        )
    {
        name = "Scaffold Balancer Pool #2"; // name for the pool
        symbol = "SB-50scUSD-50scDAI"; // symbol for the BPT

        tokenConfig = new TokenConfig[](2); // An array of descriptors for the tokens the pool will manage.
        tokenConfig[0] = TokenConfig({ // Make sure to have proper token order (alphanumeric)
            token: token1,
            tokenType: TokenType.STANDARD, // STANDARD, WITH_RATE, or ERC4626
            rateProvider: IRateProvider(address(0)), // The rate provider for a token
            yieldFeeExempt: false // Flag indicating whether yield fees should be charged on this token
        });
        tokenConfig[1] = TokenConfig({ // Make sure to have proper token order (alphanumeric)
            token: token2,
            tokenType: TokenType.STANDARD, // STANDARD, WITH_RATE, or ERC4626
            rateProvider: IRateProvider(address(0)), // The rate provider for a token
            yieldFeeExempt: false // Flag indicating whether yield fees should be charged on this token
        });
    }

    /**
     * @dev Set the tokens, exactAmountsIn, minBptAmountOut, wethIsEth, and userData here
     */
    function getInitializationConfig(TokenConfig[] memory tokenConfig)
        public
        pure
        returns (
            IERC20[] memory tokens,
            uint256[] memory exactAmountsIn,
            uint256 minBptAmountOut,
            bool wethIsEth,
            bytes memory userData
        )
    {
        tokens = new IERC20[](2); // Array of tokens to be used in the pool
        tokens[0] = tokenConfig[0].token;
        tokens[1] = tokenConfig[1].token;
        exactAmountsIn = new uint256[](2); // Exact amounts of tokens to be added, sorted in token alphanumeric order
        exactAmountsIn[0] = 10 ether; // amount of token1 to send during pool initialization
        exactAmountsIn[1] = 10 ether; // amount of token2 to send during pool initialization
        minBptAmountOut = 1 ether; // Minimum amount of pool tokens to be received
        wethIsEth = false; // If true, incoming ETH will be wrapped to WETH; otherwise the Vault will pull WETH tokens
        userData = bytes(""); // Additional (optional) data required for adding initial liquidity
    }
}
