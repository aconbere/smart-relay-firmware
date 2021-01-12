Makefile https://gist.github.com/electronut/8a4c297213620958ebef
Programmer -c usbtiny
/usr/lib/avr/include/avr/iotnx5.h
https://www.tspi.at/2019/04/24/avrgpio.html
https://embedds.com/controlling-avr-io-ports-with-avr-gcc/

# Notes on ATtiny85

There are 5 I/O Pins comprising a 6 bit bidirectional I/O port
- PB0 to PB5
- or PortB 0-5


# Running in the simulator


> ./simavr/run_avr -m attiny85 -f 8000000 -g ~/Projects/attiny85-example/build/main.hex


