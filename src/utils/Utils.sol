// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

contract Utils is Script {
    using stdJson for string;

    struct Json {
        uint64 ChainSelector;
        address CurrentReceiverAddress;
        address LinkAddress;
        address RouterAddress;
    }

    function updateDeployment(address newAddress, string memory key) internal {
        string memory inputDir = "script/input/";
        string memory chainDir = string.concat(vm.toString(block.chainid), "/config.json");
        string[] memory inputs = new string[](4);
        inputs[0] = "./update-config.sh";
        inputs[1] = string.concat(inputDir, chainDir);
        inputs[2] = key;
        inputs[3] = vm.toString(newAddress);

        vm.ffi(inputs);
    }

    function getValue(string memory key, uint256 _chainid) internal returns (address) {
        uint256 chainid = (_chainid == 0) ? block.chainid : _chainid;
        string memory inputDir = "script/input/";
        string memory chainDir = string.concat(vm.toString(chainid), "/config.json");
        string[] memory inputs = new string[](3);
        inputs[0] = "./get-value.sh";
        inputs[1] = string.concat(inputDir, chainDir);
        inputs[2] = key;

        bytes memory r = vm.ffi(inputs);
        address addr;
        assembly {
            addr := mload(add(r, 20))
        }
        return addr;
    }

    function getStringValue(string memory key) internal returns (string memory) {
        string memory inputDir = "script/input/";
        string memory chainDir = string.concat(vm.toString(block.chainid), "/config.json");
        string[] memory inputs = new string[](3);
        inputs[0] = "./get-value.sh";
        inputs[1] = string.concat(inputDir, chainDir);
        inputs[2] = key;

        bytes memory r = vm.ffi(inputs);

        return string(r);
    }

    function getJson(uint256 _chainid) internal view returns (Json memory) {
        uint256 chainid = (_chainid == 0) ? block.chainid : _chainid;
        string memory inputDir = "script/input/";
        string memory chainDir = string.concat(vm.toString(chainid), "/config.json");
        string memory path = string.concat(inputDir, chainDir);

        string memory json = vm.readFile(path);
        bytes memory jsonBytes = json.parseRaw("");
        Json memory jsonStruct = abi.decode(jsonBytes, (Json));

        return jsonStruct;
    }
}
