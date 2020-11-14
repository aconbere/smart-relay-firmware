DEVICE			= attiny85
CLOCK				= 8000000
PROGRAMMER	= usbtiny
PORT				= usb
BAUD				= 19200
FILENAME		= main
CC					= avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib
CPP					= avr-g++ -std=c++11 -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib
BUILD_DIR		= ./out

all: clean build size upload

build:
	mkdir -p $(BUILD_DIR)
	$(CPP) -o $(BUILD_DIR)/$(FILENAME).elf $(FILENAME).c
	avr-objcopy -j .text -j .data -O ihex $(BUILD_DIR)/$(FILENAME).elf $(BUILD_DIR)/$(FILENAME).hex

size:
	avr-size --format=avr --mcu=$(DEVICE) $(BUILD_DIR)/$(FILENAME).elf

upload:
	avrdude -p $(DEVICE) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:$(BUILD_DIR)/$(FILENAME).hex:i 

clean:
	$(RM) $(BUILD_DIR)/main.o
	$(RM) $(BUILD_DIR)/main.elf
	$(RM) $(BUILD_DIR)/main.hex
