/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "sys/alt_stdio.h"
#include "altera_avalon_i2c.h"
#include "altera_avalon_pio_regs.h"
#include <stdio.h>

#define HDMI_I2C_ADDRESS	0x72
#define HDMI_I2C_DATE_BUFFER	31


alt_u8 i2c_hdmi_data[HDMI_I2C_DATE_BUFFER][2] = {
		{0x98, 0x03},	//Must be set to 0x03 for proper operation
		{0x10, 0x00},	//Set 'N' value at 6144
		{0x02, 0x18},	//Set 'N' value at 6144
		{0x03, 0x00},	//Set 'N' value at 6144
		{0x14, 0x70},	//Set Ch count in the channel status to 8.
		{0x15, 0x20},	//Input 444 (RGB or YCrCb) with Separate Syncs, 48kHz fs
		{0x16, 0x30},	//Output format 444, 24-bit input
		{0x18, 0x46},	//Disable CSC
		{0x40, 0x80},	//General control packet enable
		{0x41, 0x10},	//Power down control
		{0x49, 0xA8},	//Set dither mode - 12-to-10 bit
		{0x55, 0x10},	//Set RGB in AVI infoframe
		{0x56, 0x08},	//Set active format aspect
		{0x96, 0xF6},	//Set interrup
		{0x73, 0x07},	//Info frame Ch count to 8
		{0x76, 0x1F},	//Set speaker allocation for 8 channels
		{0x98, 0x03},	//Must be set to 0x03 for proper operation
		{0x99, 0x02},	//Must be set to Default Value
		{0x9A, 0xE0},	//Must be set to 0b1110000
		{0x9C, 0x30},	//PLL filter R1 value
		{0x9D, 0x61},	//Set clock divide
		{0xA2, 0xA4},	//Must be set to 0xA4 for proper operation
		{0xA3, 0xA4},	//Must be set to 0xA4 for proper operation
		{0xA5, 0x04},	//Must be set to Default Value
		{0xAB, 0x40},	//Must be set to Default Value
		{0xAF, 0x16},	//Select HDMI mode
		{0xBA, 0x60},	//No clock delay
		{0xD1, 0xFF},	//Must be set to Default Value
		{0xDE, 0x10},	//Must be set to Default for proper operation
		{0xE4, 0x60},	//Must be set to Default Value
		{0xFA, 0x7D}	//Nbr of times to look for good phase
};

int main()
{ 
  printf("Hello from Nios II!\n");

  ALT_AVALON_I2C_DEV_t *i2c_dev; //pointer to instance structure
  ALT_AVALON_I2C_STATUS_CODE status;

  //get a pointer to the avalon i2c instance
  i2c_dev = alt_avalon_i2c_open("/dev/i2c_0");
  if (NULL==i2c_dev)
  {
	  printf("Error: Cannot find /dev/i2c_0\n");
	  return 1;
  }

  alt_avalon_i2c_master_target_set(i2c_dev, HDMI_I2C_ADDRESS);

  for (alt_u8 i = 0; i < HDMI_I2C_DATE_BUFFER; i++)
  {
	  //alt_u8 data[2] = {i2c_hdmi_data[i][0], i2c_hdmi_data[i][1]};
	  alt_u8 data[2] = {0x55, 0x55};

	  status = alt_avalon_i2c_master_tx(i2c_dev, data, 1, ALT_AVALON_I2C_NO_INTERRUPTS);
	  if (status != ALT_AVALON_I2C_SUCCESS)
	  {
		  printf("%d, I2C failed\n", i);
		  return 1; //FAIL
	  }
  }

  IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 1);
  printf("Finish\n");

  //read I2C
  //status=alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 2, rxbuffer, 0x10, ALT_AVALON_I2C_NO_INTERRUPTS);
  //if (status != ALT_AVALON_I2C_SUCCESS) return 1; //FAIL

  return 0;
}

