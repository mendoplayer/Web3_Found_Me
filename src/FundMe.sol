// SPDX-License-Identifier: MIT
//*Pagina para construir con eth speedrun ethrteum
pragma solidity 0-8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

//* Los errores personalizados se declaran FUERA del contrato (a nivel de archivo)
//* Convención: prefijo con el nombre del contrato para evitar colisiones, ej. FundMe__NoEsOwner
//* despues desde el front con el nombre del error le dejas el mensaje personalizado
error FundMe__NoEsOwner();
error FundMe__MontoInsuficiente();
error FundMe__FalloEnvio();

contract FundMe {
    using PriceConverter for uint256;

    //* Las variables constantes se inicializan en tiempo de compilación, mientras que las variables inmutables se inicializan en tiempo de despliegue.
    //* constant = Su valor debe fijarse en tiempo de compilación (no puede depender de msg.sender, de otra variable de estado, ni calcularse en runtime).
    //* immutable = similar pero que permite asignar el valor una sola vez en el constructor (útil cuando el valor depende del deploy, como una dirección).
    uint256 public constant MIN_USD = 5e18;
    address[] private s_funders;
    mapping(address funder => uint256 amountFounded)
        private s_addressToAmountFounded;
    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    //* constructor = es una función especial que se ejecuta una única vez, justo en el momento en que el contrato se despliega (deploya) en la blockchain.
    //* Nunca más se vuelve a ejecutar después de eso.

    //* Características del constructor:
    //* 1-No tiene modificador de visibilidad obligatorio en versiones modernas (antes se ponía public, ahora es opcional).
    //* 2-Puede recibir parámetros, por ejemplo si quisieras definir el owner de otra forma: constructor(address _owner){ owner = _owner;}
    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    //* payable: Si alguien intenta enviarle plata a una función sin payable, la transacción falla. Al agregar payable, le decís a la función: vos sí podés recibir ether junto con la llamada
    function enviar() public payable {
        //* require es la verificacion
        //* require(msg.value.getConvertirRate() >= MIN_USD, "Debe enviar mas de 1 eth");
        if (msg.value.getConversionRate(s_priceFeed) < MIN_USD) {
            revert FundMe__MontoInsuficiente();
        } //*Mejora de manejo de errores con revert y custom errors para el ahorro de gas

        s_funders.push(msg.sender);

        //* addressToAmountFounded["0xABC..."] = 1000000000000000000; // 1 eth en wei esto es lo hace
        //* Se lee así:
        //* addressToAmountFounded[msg.sender] → busca cuánto donó msg.sender hasta ahora (si nunca donó, esto va a ser 0).
        //* le suma msg.value (lo que está donando en esta transacción).
        //* guarda ese nuevo total en la misma clave msg.sender.
        //* addressToAmountFounded[msg.sender] = addressToAmountFounded[msg.sender] + msg.value;
        s_addressToAmountFounded[msg.sender] += msg.value; //Funcion acortada que ahce lo mismo que lad e arriba
    }

    //* Funcion de retirar mas economica
    function cheaperRetirar() public validaOwner {
        //*  Al colocar en variable local la matriz de funders, se ahorra gas al no tener que leerla de storage en cada iteración del for loop.
        uint256 fundersLength = s_funders.length;

        for (uint256 funderIndex; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFounded[funder] = 0;
        }

        //* para reiniciar la matriz o array de funders
        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Fallo el envio.");
    }

    function retirar() public validaOwner {
        for (
            uint256 funderIndex;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFounded[funder] = 0;
        }

        //* para reiniciar la matriz o array de funders
        s_funders = new address[](0);

        //! TIPOS DE RETIRO DE MONEDA

        //? transfer => enviar un eth o tokens desde diferentes contratos entre si, esta limitada a 2300 de gas, si se pasa la llamada fallara.
        //* msg.sender =  tipo de direccion
        //* payable(msg.sender) = tipo de direccion de pago
        //* payable(msg.sender).transfer(address(this).balance); Forma de enviar

        //? send => esta limitado a 2300 de gas, si se exede enviara un boolean.
        //* bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //* require(sendSuccess, "Fallo el envio."); Forma de enviar

        //? call => Si falla devuelve todo el gas para qeu no tenga gas tapado o simialres, retirna un bolean si falla o si hay success
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Fallo el envio.");
    }

    //* modifier =  funcion global que permite ser llamada un las funciones asi no repetir codigo
    modifier validaOwner() {
        //*  require(msg.sender == owner, "Debe ser el propietario para retirar.");
        if (msg.sender != i_owner) {
            revert FundMe__NoEsOwner();
        }

        //* se dice parad ecir ejecuta lo qeu sigue,
        //* si se pone al principio se jecuta el codigo y despues lo que esta dentro del modifier si se pone al final ejecuta el modifier primero y despues el codigo de la funcion
        _;
    }

    //* ¿Llega una transacción con ETH y/o datos?
    //* │
    //* ├── msg.data está vacío?
    //* │     ├── Sí → ¿existe receive()?
    //* │     │        ├── Sí → se ejecuta receive()
    //* │     │        └── No → se ejecuta fallback() (si es payable)
    //* │     └── No → ¿el selector coincide con alguna función?
    //* │              ├── Sí → se ejecuta esa función
    //* │              └── No → se ejecuta fallback()
    receive() external payable {
        //* Es una función especial que Solidity ejecuta automáticamente cuando alguien envía ETH al contrato sin especificar ningún dato (msg.data vacío),
        //* por ejemplo con una simple transferencia como metamask → enviar ETH → dirección del contrato, o payable(contractAddress).transfer(1 ether).
        enviar();
    }

    fallback() external payable {
        //* Se ejecuta cuando alguien llama al contrato con datos que no coinciden con ninguna función existente (msg.data no vacío, pero no matchea ningún selector de función),
        //* o cuando llaman a una función que no existe.
        //* También se ejecuta si no existe receive() y alguien manda ETH sin datos (fallback actúa como respaldo).
        enviar();
    }

    //TODO: Views Getters

    function getAddressToAmountFounded(
        address funder
    ) public view returns (uint256) {
        return s_addressToAmountFounded[funder];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }
}
