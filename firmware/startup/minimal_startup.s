/* 
 * minimal_startup.s
 * Custom startup code for STM32l476RG
 * @author: Marco Chen
 */

.syntax unified
.cpu cortex-m4
.thumb


/* Create a minimal vector table that the linker will dump throw into flash*/
.section .isr_vector "a"
.type g_pfnVectors %object

g_pfnVectors:
    .word _estack
    .word Reset_Handler

.section .text
.type Reset_Handler, %function
.global Reset_Handler

Reset_Handler:
    ldr sp, _estack

    /* copy .data from FLASH to SRAM */
    ldr r0, _sdata
    ldr r1, _edata
    ldr r2, _sidata
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
    ldr r0, _sbss
    ldr r1, _ebss
    movs r3, #0
    b LoopFillZeroBss

    FillZeroBss:
        str r3, [r2]
        adds r2, r2, #4

    LoopFillZeroBss:
        cmp r0, r1
        bcc Fill Zero Bss/* Loop again if (_sbss + offset) < _ebss */

    bl main

LoopForever:
    b LoopForever

