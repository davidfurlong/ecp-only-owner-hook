// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "../src/hook.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        OnlyOwnerCanMakeTopLevelCommentsHook hook = new OnlyOwnerCanMakeTopLevelCommentsHook();
        
        console.log("Hook deployed to:", address(hook));
        
        vm.stopBroadcast();
    }
}