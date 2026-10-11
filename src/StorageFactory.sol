// SPDX-License-Identifier: MIT
pragma solidity 0-8.18;

// Tipos de importacion por contrato o por documento completo
// import "./SimpleStorage.sol";
import {SimpleStorage,SimpleStorage2} from "./SimpleStorage.sol";

contract StorageFactory{
// SimpleStorage public simpleStorage;
   SimpleStorage[] public listOfSimpleStorageContracts;

function createSimpleStorageContract() public {
// simpleStorage = new SimpleStorage();
       SimpleStorage newContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newContract);
}

function sfStore (uint256 _simpleStorageIndex,uint256 _newSimpleStorageNumber) public {
    // address
    // ABI = interfaz binaria de aplicacion
    listOfSimpleStorageContracts[_simpleStorageIndex].store(_newSimpleStorageNumber);
}

function sfGet (uint256 _simpleStorageIndex) public view returns (uint256) {
    return listOfSimpleStorageContracts[_simpleStorageIndex].mostrar();
}
}
