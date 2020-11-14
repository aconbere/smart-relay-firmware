DEVICE			= attiny85
CLOCK				= 8000000
PROGRAMMER	= stk500v1
PORT				= /dev/tty.usbmodem1421
BAUD				= 19200
FILENAME		= main
COMPILE			= avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Ilib
BUILD_DIR		= ./out

all: clean build upload

build:
	mkdir -p $(BUILD_DIR)
	$(COMPILE) -c $(FILENAME).c -o $(BUILD_DIR)/$(FILENAME).o
	$(COMPILE) $(BUILD_DIR)/$(FILENAME).o -o $(BUILD_DIR)/$(FILENAME).elf 
	avr-objcopy -j .text -j .data -O ihex $(BUILD_DIR)/$(FILENAME).elf $(BUILD_DIR)/$(FILENAME).hex
	avr-size --format=avr --mcu=$(DEVICE) $(BUILD_DIR)/$(FILENAME).elf

upload:
	avrdude -p $(DEVICE) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:$(BUILD_DIR)/$(FILENAME).hex:i 

clean:
	$(RM) $(BUILD_DIR)/main.o
	$(RM) $(BUILD_DIR)/main.elf
	$(RM) $(BUILD_DIR)/main.hex
