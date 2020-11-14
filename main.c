#include <avr/io.h>
#include <util/delay.h>
#include <TinyWire/TinyWire.h>

#define LED_PIN 0
#define RELAY_ADDRESS 0x18

void flash_led() {
  for (int i = 0; i < 10; i++) {
    // set LED_PIN high
		PORTB |= (1<<LED_PIN);
    _delay_ms(50);

    // set LED_PIN low
		PORTB &= ~(1<<LED_PIN);
    _delay_ms(50);
  }
}

void trigger_relay() {
  TinyWire.begin();
  TinyWire.beginTransmission(0x018);
  TinyWire.send(0x01);
  if (TinyWire.endTransmission() != 0) {
    flash_led();
  }
}
 
int main (void) {
  // set LED_PIN to be output
	DDRB |= (1<<LED_PIN);

  //while (true) {
  //  // set LED_PIN high
	//	PORTB |= (1<<LED_PIN);
  //  _delay_ms(100);

  //  // set LED_PIN low
	//	PORTB &= ~(1<<LED_PIN);
  //  _delay_ms(100);
  //}

  // wait one second for everything to get started
  _delay_ms(1000);
  trigger_relay();
  _delay_ms(1000);
  trigger_relay();

  return 1;
}

