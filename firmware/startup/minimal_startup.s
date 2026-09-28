/* 
 * minimal_startup.s
 * Custom startup code for STM32L476RG
 * @author: Marco Chen
 */

.syntax unified
.cpu cortex-m4
.thumb

/* Create a minimal vector table that the linker will dump throw into flash*/
.section .isr_vector,"a"
.type g_pfnVectors, %object

g_pfnVectors:
    .word _estack
    .word Reset_Handler
.size g_pfnVectors, .-g_pfnVectors

.section .text
.type Reset_Handler, %function
.global Reset_Handler

Reset_Handler:
    ldr sp, = _estack

    /* copy .data from FLASH to SRAM */
    ldr r0, = _sdata
    ldr r1, = _edata
    ldr r2, = _sidata
    movs r3, #0
    b LoopCopyDataInit

    CopyDataInit:
        ldr r4, [r2, r3]
        str r4, [r0, r3]
        adds r3, r3, #4

    LoopCopyDataInit:
        adds r4, r0, r3
        cmp r4, r1
        bcc CopyDataInit /* Loop again if (_sdata + offset) < _edata */

    /* Zero out bss */
    ldr r2, = _sbss
    ldr r4, = _ebss
    movs r3, #0
    b LoopFillZeroBss

    FillZeroBss:
        str r3, [r0]
        adds r2, r2, #4

    LoopFillZeroBss:
        cmp r2, r4
        bcc FillZeroBss /* Loop again if (_sbss + offset) < _ebss */

    bl main

LoopForever:
    b LoopForever

.size Reset_Handler, .-Reset_Handler

