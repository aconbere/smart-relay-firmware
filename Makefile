DEVICE			= attiny85
CLOCK				= 8000000
PROGRAMMER	= usbtiny
PORT				= usb
BAUD				= 19200
CC					= avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib
CPP_FLAGS		= -std=c++11 -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib -fno-exceptions -ffunction-sections -fdata-sections -Wl,--gc-sections
CPP					= avr-g++

.DEFAULT_GOAL := all

build/main.elf: ./src/main.cpp ./lib/twi/twi.cpp ./lib/twi/twi.h
	$(CPP) $(CPP_FLAGS) -o ./build/main.elf ./src/main.cpp ./lib/twi/twi.cpp

build/main.hex: ./build/main.elf
	avr-objcopy -j .text -j .data -O ihex ./build/main.elf ./build/main.hex

.PHONY: all
all: build/main.hex size upload

.PHONY: debug

debug : CPP_FLAGS = -std=c++11 -Wall -g -Og -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib -fno-exceptions -ffunction-sections -fdata-sections -Wl,--gc-sections

debug: build/main.hex


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

