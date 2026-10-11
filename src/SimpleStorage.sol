// SPDX-License-Identifier: MIT
//* comnado para levantar cadena blockchain = forge create SimpleStorage --interactive
//* EVM =  MAquina virtual de ethereum
//* Versiones del compilador solidity
//* Compinibles-Componibilidad: los contratos inteligentes pueden interactuar entre si.
pragma solidity 0-8.18;
//* pragma solidity >=0.8.18 <0.9.0;

//* Un repaso rápido de los 4 modificadores de visibilidad en Solidity, para que te quede claro el porqué:

//* public: se puede llamar desde cualquier lado (de adentro del contrato, desde otro contrato, o desde una wallet/dApp).
//* external: solo se puede llamar desde afuera del contrato (otro contrato o una wallet). No se puede llamar internamente con solo el nombre de la función (tendrías que usar this.miFuncion(),
//*           que además gasta más gas).
//* internal: solo se puede llamar desde dentro del mismo contrato, o desde contratos que heredan de él.
//* private: solo se puede llamar desde dentro del mismo contrato, ni siquiera los contratos que heredan pueden acceder.

contract SimpleStorage {
    //* variables parecidas a javascript pero se suman
    //* address micalle = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; Se usa para direccion de billeteras

    //* uint256 public nrofav = 0;
    uint256 nrofav = 0;
    uint256[] listaNroFav; //* arrays

    //*Objeto
    struct Persona {
        uint256 suNroFav;
        string nombre;
    }

    Persona public anto = Persona(29, "patito");
    Persona public fer = Persona({suNroFav: 88, nombre: "Fernando"});

    //* Array estatico
    //* Persona[5] public listaPersonas;

    //* Array dinamico
    Persona[] public listaPersonas;

    //* Mapeo de array
    mapping(string => uint256) public nombreYFavNro;

    //* Funciones
    //*  virtual:  esta fuincion se puede anular
    function store(uint256 _nrofav) public virtual {
        nrofav = _nrofav;
    }

    function mostrar() public view returns (uint256) {
        //* Al usar view se indica que solo se va a leer el estado de la cadena por lo que no se toma como una transaccion
        //* dentro de view no se permiten realizar cambios de estado, solo lectura
        return nrofav;
    }

    //* calldata = deja en memoria el parametro pero no puede ser alterado dentro de la funcion
    //* memory = deja en memoria el parametro pero si puede ser alterado dentro de la funcion
    //* storage= variables de almacenamiento permanentes y permanecen en el contrato para siempre
    function addPersonas(uint256 _suNroFav, string memory _nombre) public {
        listaPersonas.push(Persona(_suNroFav, _nombre));
        nombreYFavNro[_nombre] = _suNroFav;
    }
}

contract SimpleStorage2 {}
contract SimpleStorage3 {}
