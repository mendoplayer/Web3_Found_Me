// SPDX-License-Identifier: MIT
pragma solidity 0-8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

// is para heredear
contract AddFiveSotrage is SimpleStorage{

    // function sayHello() public pure returns (string memory){
    //     return "hola fer";
    // }

// override para cambiar una funcion heredada
 function store(uint256 _nrofav) public override {
    nrofav = _nrofav+5;
 }

}