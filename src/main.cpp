#include <util/delay.h>

#include <avr/io.h>

#define RELAY_ON true
#define RELAY_OFF false

void set_relay(bool state) {
  if (state) {
    PORTB |= (1 << PB1);
  } else {
    PORTB &= ~(1 << PB1);
  }
}

int main(void) {
  DDRB |= (1 << DDB1);

  while (true) {
    _delay_ms(1000);
    set_relay(RELAY_ON);
    _delay_ms(1000);
    set_relay(RELAY_OFF);
    _delay_ms(1000);
  }

  return 1;
}
