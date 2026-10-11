// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "fundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract Financiacion is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address contrato) public {
        vm.startBroadcast();
        FundMe(payable(contrato)).enviar{value: SEND_VALUE}();
        vm.stopBroadcast();
    }

    function run() external {
        address contrato = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        vm.startBroadcast();
        fundFundMe(contrato);
        vm.stopBroadcast();
    }
}

contract RetiroFondos is Script {
    function retirarFondos(address contrato) public {
        vm.startBroadcast();
        FundMe(payable(contrato)).retirar();
        vm.stopBroadcast();
    }

    function run() external {
        address contrato = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        vm.startBroadcast();
        retirarFondos(contrato);
        vm.stopBroadcast();
    }
}
