// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Utils} from "../src/utils/Utils.sol";
import {MessageSender} from "../src/MessageSender.sol";

contract DeployMessageSenderScript is Utils {
    MessageSender public sender;
    uint256 deployerPrivateKey;

    function run() public {
        if (block.chainid == 31337) {
            deployerPrivateKey = vm.envUint("ANVIL_PRIVATE_KEY");
        } else {
            deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(deployerPrivateKey);
        sender = new MessageSender(getValue("routerAddress", 0), getValue("linkAddress", 0));
        updateDeployment(address(sender), "currentSenderAddress");
    }
}
