// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Utils} from "../src/utils/Utils.sol";
import {MessageReceiver} from "../src/MessageReceiver.sol";

contract DeployMessageReceiverScript is Utils {
    MessageReceiver public receiver;
    uint256 deployerPrivateKey;

    function run() public {
        if (block.chainid == 31337) {
            deployerPrivateKey = vm.envUint("ANVIL_PRIVATE_KEY");
        } else {
            deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(deployerPrivateKey);
        receiver = new MessageReceiver(getValue("routerAddress", 0));
        updateDeployment(address(receiver), "currentReceiverAddress");
    }
}
