// main.c
// 
// A simple blinky program for ATtiny85
// Connect red LED at pin 2 (PB3)
//
// electronut.in

#include <avr/io.h>
#include <util/delay.h>
#include <TinyWire/TinyWire.h>

#define LED_PIN 0
 
int main (void) {
  // set PB3 to be output
	DDRB |= (1<<LED_PIN);

  while (1) {
    // set PB3 high
		PORTB |= (1<<LED_PIN);
    _delay_ms(100);

    // set PB3 low
		PORTB &= ~(1<<LED_PIN);
    _delay_ms(100);
  }

  return 1;
}
