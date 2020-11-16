#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include <TinyWire/TinyWire.h>

#define RELAY_ADDRESS 0x18
#define RELAY_OFF 0x00
#define RELAY_ON 0x01
#define ADC_REF_VOLTAGE 3.3
#define ADC_PRECISION_BITS 10
#define ADC_PRECISON_MAX pow(2, 10)

void set_relay(uint8_t state) {
  TinyWire.beginTransmission(0x18);
  TinyWire.send(state);
  TinyWire.endTransmission();
}

void adc_config() {
  /*
   * ADLAR configures the way that data is presented in the ADCH and ADCL registers
   * When ADLAR is 0 results are kept in ADCH and ADCL (ADC high and low bits)
   * When reading results if ADLAR is 0 you must read ADCL first before reading
   * ADCH.
   * 
   * If ADLAR is 1 (results left adjusted) and only 8 bits of precision are needed
   * You can simply ready ADCH.
   * 
   * Selecting ADC4 will select a temperature sensor
   */
  ADMUX =
            (0 << ADLAR) |     // right shift result
            (0 << REFS1) |     // Sets ref. voltage to VCC, bit 1
            (0 << REFS0) |     // Sets ref. voltage to VCC, bit 0
            (0 << MUX3)  |     // use ADC2 for input (PB4), MUX bit 3
            (0 << MUX2)  |     // use ADC2 for input (PB4), MUX bit 2
            (1 << MUX1)  |     // use ADC2 for input (PB4), MUX bit 1
            (0 << MUX0);       // use ADC2 for input (PB4), MUX bit 0

  ADCSRA = 
            (1 << ADEN)  |     // Enable ADC 
            (1 << ADPS2) |     // set prescaler to 64, bit 2 
            (1 << ADPS1) |     // set prescaler to 64, bit 1 
            (0 << ADPS0) |     // set prescaler to 64, bit 0
            (1 << ADIE);       // set to trigger iterrupts
}

void adc_start_conversion() {
  ADCSRA |= (1 << ADSC);
}

/* we have the measured ADC voltage which will be
 * some value from [0, MAX_PRECISION]
 *
 * That's mapped from [0, REF_VOLTAGE]
 *
 * We want to take an external voltage like 1.2 V
 * and figure out how to make the measured volatge make sense
 */
uint16_t convert_voltage(uint16_t measured_voltage) {
  return (measured_voltage / ADC_REF_VOLTAGE) * ADC_PRECISON_MAX
}

ISR(ADC_vect) {
//  uint16_t ref_voltage = 3.3;
//  uint16_t target_voltage = 1;
  uint16_t measured_voltage = ADCL | (ADCH << 8);

  if (measured_voltage > 100) {
    set_relay(RELAY_ON);
  } else {
    set_relay(RELAY_OFF);
  }
}
 
int main (void) {
  TinyWire.begin();

  while (true) {
    adc_start_conversion();
    _delay_ms(1000);
  }

  return 1;
}
