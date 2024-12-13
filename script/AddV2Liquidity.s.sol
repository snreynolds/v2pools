// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {IUniswapV2Factory} from "v2-core/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Pair} from "v2-core/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router02} from "v2-periphery/interfaces/IUniswapV2Router02.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

contract AddV2Liquidity is Script {
    address uniswapv2Pair;

    MockERC20 USDC;
    MockERC20 CAT;
    address WETH;

    IUniswapV2Router02 uniswapv2Router = IUniswapV2Router02(0xc7A3b85D43fF66AD98A895dE0EaE4b9e24C932D7);
    IUniswapV2Factory uniswapV2Factory = IUniswapV2Factory(0xc021A7Deb4a939fd7E661a0669faB5ac7Ba2D5d6);
    address tester = 0xB7a249bdeFf39727B5Eb4C7AD458f682BAe6aDAD;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy USDC.
        USDC = new MockERC20("USDC", "USDC", 6);
        USDC.mint(tester, 1_000_000_000_000);
        USDC.mint(address(this), 1_000_000_000);
        USDC.approve(address(uniswapv2Router), type(uint256).max);

        // Deploy CAT.
        CAT = new MockERC20("CAT", "CAT", 18);
        CAT.mint(tester, 1000000 ether);
        CAT.mint(address(this), 1000 ether);
        CAT.approve(address(uniswapv2Router), type(uint256).max);

        // Add Liquidity. Will also deploy the pair.
        IUniswapV2Router02(uniswapv2Router).addLiquidity(
            address(USDC), address(CAT), 10_000_000_000, 10_000 ether, 0, 0, tester, block.timestamp + 100
        );

        vm.stopBroadcast();
    }
}
