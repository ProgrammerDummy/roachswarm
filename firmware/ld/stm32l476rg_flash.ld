/* 
 * stm32l476rg_flash.ld
 * Custom linker script for NUCLEO-L476RG board
 * @author: Marco Chen
 */

/*
 * Only need FLASH and SRAM1 for a blinky
 *
 */
ENTRY(Reset_Handler)
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
    SRAM1 (rwx) : ORIGIN = 0x2000 0000, LENGTH = 96K
}

