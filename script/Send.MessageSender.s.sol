// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Utils} from "../src/utils/Utils.sol";
import {console} from "forge-std/Console.sol";
import {MessageSender} from "../src/MessageSender.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SendMessageSenderScript is Utils {
    MessageSender public sender;
    uint256 deployerPrivateKey;

    function run() public {
        if (block.chainid == 31337) {
            deployerPrivateKey = vm.envUint("ANVIL_PRIVATE_KEY");
        } else {
            deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        }
        uint256 receiverChain = 11155111;
        Json memory json = getJson(receiverChain);

        vm.startBroadcast(deployerPrivateKey);
        IERC20 token = IERC20(getValue("linkAddress", 0));
        sender = MessageSender(payable(getValue("currentSenderAddress", 0)));
        token.transfer(address(sender), 0.5 ether);
        sender.send(
            json.ChainSelector,
            getValue("currentReceiverAddress", receiverChain),
            "this is a test",
            MessageSender.PayFeesIn.LINK
        );
    }
}
