/* 
 * stm32l476rg_flash.ld
 * Custom linker script for NUCLEO-L476RG board
 * @author: Marco Chen
 */

ENTRY(Reset_Handler)

/* Start the stack from the top of SRAM1 (stack grows down) */
_estack = ORIGIN(SRAM1) + LENGTH(SRAM1); 

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
    SRAM1 (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
}

SECTIONS
{
    /* 
     * .isr_vector, .text, and .rodata live in flash because they contain
     * read-only instructions and fixed metadata, so they should never need to
     * change during runtime. So LMA and VMA are at FLASH.
     * 
     */
    /* The vector table, which holds interrupt and exception handlers, 
     * is placed on top of the flash
     */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } >FLASH

    /* Throw the executeable code into flash */
    .text : 
    {
        . = ALIGN(4);
        *(.text)
        *(.text.*)
        . = ALIGN(4);
    } >FLASH

    /* Dump the constants into flash too*/
    .rodata : 
    {
        .= ALIGN(4)
        *(.rodata)
        *(.rodata*)
        .= ALIGN(4)
    } >FLASH

    /* Make SRAM1 the VMA and FLASH the LMA. */
    .data : {
        . = ALIGN(4);
        _sdata = .; /* create a global variable at data start */
        *(.data)
        *(.data*)
        . = ALIGN(4)
        _edata = .; /* create a global variable at data end */
    } >SRAM1 AT >FLASH

    /* Put uninitialized variables into SRAM to be cleared to zero on startup */
    .bss : {
        _sbss = .;
        . = ALIGN(4);
        *(.bss)
        *(*.bss)
        . = ALIGN(4);
        ._ebss = .;
    } >SRAM1

    . = ALIGN(4)

}