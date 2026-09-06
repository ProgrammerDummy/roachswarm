# stm32-bare-metal-blinky

A bare-metal blinky for the STM32L476RG Nucleo. Built with no CubeMX, no HAL, and no IDE. This is the toolchain foundation for the A/B bootloader that will be written in this repo.

CMSIS headers are register definitions so I still use them rather than retyping base addresses.

## Building and flashing
`make`

`make flash`

Flashing uses the ST_Link already on the Nucleo through OpenOCD. This can be seen in the Makefile.

To debug:

`openocd -f board/st_nucleo_l4.cfg`

`arm-none-eabi-gdb build/blinky.elf -ex 'target extended-remote :3333'`


## Notes
The startup file and linker script are from ST. Currently working on replacing them with my own minimal ones.
