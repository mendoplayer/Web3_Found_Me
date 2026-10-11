//* Este archivo se usa para generar los scripts de instalación y desinstalación de la aplicación. sin tener que repetirlos todo el tiempo.

//!! EJEMPLOS
.PHONY: all build test clean format snapshot

all: clean build test

build:
	forge build

test:
	forge test -vvv

format:
	forge fmt

snapshot:
	forge snapshot

clean:
	forge clean

	//* se ejecutan ==> make build - make test - make format - make snapshot - make clean