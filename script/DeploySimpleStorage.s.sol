// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

//* comando para cargar el env = source .env
//* comando para correr el script = forge script script/DeploySimpleStorage.s.sol --rpc-url (url que diga) --broadcast --private-key (la clave que da)
//* comando con clave cifrada en wallet = forge script script/Deploy.s.sol:DeployScript --rpc-url http://127.0.0.1:8545  --account defaultKey --sender 0xTU_CLAVE --broadcast
//* comando para castear gas o numeros clave = cast --to-base (el numero) dec
//* comando para llamar a la funcion de transaccion = cast send <DIRECCION_CONTRATO> "nombreFuncion(tipo1,tipo2)" arg1 arg2 --rpc-url http://127.0.0.1:8545 --account defaultKey
//* comando para llamar a la funcion de call = cast call <DIRECCION_CONTRATO> "nombreFuncion(tipo1,tipo2)" arg1 arg2 --rpc-url http://127.0.0.1:8545
//* Contrato o funcion para poder desplegar o implementar nuestro contrato original , se crea este script
contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();
        return simpleStorage;
    }
}
