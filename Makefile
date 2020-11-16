DEVICE			= attiny85
CLOCK				= 8000000
PROGRAMMER	= usbtiny
PORT				= usb
BAUD				= 19200
CC					= avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib
CPP					= avr-g++ -std=c++11 -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib -fno-exceptions -fno-rtti -ffunction-sections -fdata-sections -Wl,--gc-sections

.DEFAULT_GOAL := all

build/main.elf: ./src/main.cpp ./lib/TinyWire/TinyWire.cpp ./lib/TinyWire/TinyWire.h ./lib/TinyWire/twi.cpp ./lib/TinyWire/TinyWire.h
	$(CPP) -o ./build/main.elf ./src/main.cpp ./lib/TinyWire/TinyWire.cpp ./lib/TinyWire/TinyWire.h ./lib/TinyWire/twi.cpp ./lib/TinyWire/TinyWire.h

build/main.hex: ./build/main.elf
	avr-objcopy -j .text -j .data -O ihex ./build/main.elf ./build/main.hex

.PHONY: all
all: build/main.hex size upload

.PHONY: size
size:
	avr-size --format=avr --mcu=$(DEVICE) build/main.elf

.PHONY: upload
upload:
	avrdude -p $(DEVICE) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:./build/main.hex:i 

.PHONY: clean
clean:
	$(RM) ./build/*

.PHONY: setclock
setclock:
	avrdude -p $(DEVICE) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U lfuse:w:0xe2:m
