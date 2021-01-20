/*******************************************************************************
  Class B Library v2.0.0 Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_cpu_reg_test.S

  Summary:
    Assembly functions to perform self-test of CPU registers.

  Description:
    This file provides self-test routines for the processor core registers
    and FPU registers.

*******************************************************************************/

/*******************************************************************************
* Copyright (C) 2020 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*******************************************************************************/
.thumb
.syntax unified
.global CLASSB_CPU_RegistersTest
.global CLASSB_FPU_RegistersTest
.extern _CLASSB_UpdateTestResult

; /* Test bit patterns for R0 */
.equ CPU_TEST_PATTERN_A, 0xAA000000
.equ CPU_TEST_PATTERN_B, 0x00AA0000
.equ CPU_TEST_PATTERN_C, 0x0000AA00
.equ CPU_TEST_PATTERN_D, 0x000000AA
.equ CPU_TEST_PATTERN_E, 0x55000000
.equ CPU_TEST_PATTERN_F, 0x00550000
.equ CPU_TEST_PATTERN_G, 0x00005500
.equ CPU_TEST_PATTERN_H, 0x00000055

; /* Test bit patterns for r1 to r11 */
.equ CPU_TEST_PATTERN_I, 0xAAAAAAAA
.equ CPU_TEST_PATTERN_J, 0x55555555

; /* Test bit patterns for MSP and PSP must be multiple of 4 */
.equ CPU_TEST_PATTERN_K, 0xAAAAAAA8
.equ CPU_TEST_PATTERN_L, 0x55555558

; /* Test bit pattern for FPSCR */
.equ FPSCR_TEST_PATTERN_A, 0xF7C0009F

; /* Common test bit patterns */
.equ CPU_TEST_PATTERN_ZERO, 0x00000000
.equ CPU_TEST_PATTERN_APSR_A, 0xf80f0000

;/* CLASSB_TEST_TYPE defined in classb_common.h */
.equ CLASSB_TEST_TYPE_SST, 0x00
.equ CLASSB_TEST_TYPE_RST, 0x01

; /* CLASSB_TEST_ID defined in classb_common.h */
.equ CLASSB_TEST_CPU, 0x00
.equ CLASSB_TEST_FPU, 0x0E

; /* CLASSB_TEST_STATUS defined in classb_common.h */
.equ CLASSB_TEST_PASSED, 0x1
.equ CLASSB_TEST_INPROGRESS, 0x3


;/* Refer AAPCS at https://developer.arm.com/docs/ihi0042/latest*/

; /* Function Prototype
; CLASSB_TEST_STATUS CLASSB_CPU_RegistersTest(bool running_context) */

CLASSB_CPU_RegistersTest:
    push    {r14}
    push    {r2-r7}
    ; /* Copy input arguments */
    mov	    r6, r0
    ; /* Call _CLASSB_UpdateTestResult after loading arguments into registers */
    ldr	    r0, =CLASSB_TEST_TYPE_SST
    cbz     r6, progress_test_type_sst
    ldr	    r0, =CLASSB_TEST_TYPE_RST
progress_test_type_sst:
    ldr	    r1, =CLASSB_TEST_CPU
    ldr	    r2, =CLASSB_TEST_INPROGRESS
    bl	    _CLASSB_UpdateTestResult
    bl	    CLASSB_CPU_GPR_Test
update_result_return:
    ; /* Code reaches here if none of the above tests are failed */
    bl	    cpu_test_passed
    ; /* Return CLASSB_TEST_PASSED */
    ldr	    r0, =CLASSB_TEST_PASSED
    pop	    {r2-r7}
    ; /* retun by POP-ing LR into PC */
    pop	    {r15}

CLASSB_CPU_GPR_Test:
    push    {r14}
    bl	    cpu_test_r0
    bl	    cpu_test_r1_r11
    bl      cpu_test_special_regs
    pop	    {r15}

cpu_test_r0:
    push    {lr}
    push    {r0}
    ; /* Immediate value for CMP operation is limited to 8-bits */
    ldr     r0, =CPU_TEST_PATTERN_A
    ; /* Shift the patten to right and compare */
    lsr     r0, r0, #24
    cmp	    r0, #0xAA
    bne	    cpu_test_failed
    ldr     r0, =CPU_TEST_PATTERN_B
    lsr     r0, r0, #16
    cmp	    r0, #0xAA
    bne	    cpu_test_failed
    ldr     r0, =CPU_TEST_PATTERN_C
    lsr     r0, r0, #8
    cmp	    r0, #0xAA
    bne	    cpu_test_failed
    ldr     r0, =CPU_TEST_PATTERN_D
    cmp	    r0, #0xAA
    bne	    cpu_test_failed

    ; /* Immediate value for CMP operation is limited to 8-bits */
    ldr     r0, =CPU_TEST_PATTERN_E
    ; /* Shift the patten to right and compare */
    lsr     r0, r0, #24
    cmp	    r0, #0x55
    bne	    cpu_test_failed
    ldr     r0, =CPU_TEST_PATTERN_F
    lsr     r0, r0, #16
    cmp	    r0, #0x55
    bne	    cpu_test_failed
    ldr     r0, =CPU_TEST_PATTERN_G
    lsr     r0, r0, #8
    cmp	    r0, #0x55
    bne	    cpu_test_failed
    ldr     r0, =CPU_TEST_PATTERN_H
    cmp	    r0, #0x55
    bne	    cpu_test_failed
    pop     {r0}
    pop	    {r15}

cpu_test_passed:
    push    {lr}
    ldr	    r0, =CLASSB_TEST_TYPE_SST
    cbz     r6, pass_test_type_sst
    ldr	    r0, =CLASSB_TEST_TYPE_RST
pass_test_type_sst:
    ldr	    r1, =CLASSB_TEST_CPU
    ldr	    r2, =CLASSB_TEST_PASSED
    bl	    _CLASSB_UpdateTestResult
    pop	    {r15}

; /* Remain in infinite loop if a register test is failed */
cpu_test_failed:
    b cpu_test_failed

cpu_test_r1_r11:
    push    {lr}
    push    {r4-r11}

    ; /* Test r1 to r11 with 0xAAAAAAAA */
    ldr	    r0, =CPU_TEST_PATTERN_I
    mov	    r1, r0
    cmp	    r1, r0
    bne	    cpu_test_failed
    mov	    r2, r0
    cmp	    r2, r0
    bne	    cpu_test_failed
    mov	    r3, r0
    cmp	    r3, r0
    bne	    cpu_test_failed
    mov	    r4, r0
    cmp	    r4, r0
    bne	    cpu_test_failed
    mov	    r5, r0
    cmp	    r5, r0
    bne	    cpu_test_failed
    mov	    r6, r0
    cmp	    r6, r0
    bne	    cpu_test_failed
    mov	    r7, r0
    cmp	    r7, r0
    bne	    cpu_test_failed
    mov	    r8, r0
    cmp	    r8, r0
    bne	    cpu_test_failed
    mov	    r9, r0
    cmp	    r9, r0
    bne	    cpu_test_failed
    mov	    r10, r0
    cmp	    r10, r0
    bne	    cpu_test_failed
    mov	    r11, r0
    cmp	    r11, r0
    bne	    cpu_test_failed

    ; /* Test r1 to r11 with 0x55555555 */
    ldr	    r0, =CPU_TEST_PATTERN_J
    mov	    r1, r0
    cmp	    r1, r0
    bne	    cpu_test_failed
    mov	    r2, r0
    cmp	    r2, r0
    bne	    cpu_test_failed
    mov	    r3, r0
    cmp	    r3, r0
    bne	    cpu_test_failed
    mov	    r4, r0
    cmp	    r4, r0
    bne	    cpu_test_failed
    mov	    r5, r0
    cmp	    r5, r0
    bne	    cpu_test_failed
    mov	    r6, r0
    cmp	    r6, r0
    bne	    cpu_test_failed
    mov	    r7, r0
    cmp	    r7, r0
    bne	    cpu_test_failed
    mov	    r8, r0
    cmp	    r8, r0
    bne	    cpu_test_failed
    mov	    r9, r0
    cmp	    r9, r0
    bne	    cpu_test_failed
    mov	    r10, r0
    cmp	    r10, r0
    bne	    cpu_test_failed
    mov	    r11, r0
    cmp	    r11, r0
    bne	    cpu_test_failed

    ; /* Code reaches here if none of the above tests are failed */
    pop     {r4-r11}
    pop	    {r15}

cpu_test_special_regs:
    push    {lr}
    push    {r4-r7}
    ; /* Save MSP and test it */
    mrs	    r3, MSP
    ldr	    r0, =CPU_TEST_PATTERN_K
    msr	    MSP, r0
    mrs	    r1, MSP
    cmp	    r1, r0
    bne	    cpu_test_failed
    ldr	    r0, =CPU_TEST_PATTERN_L
    msr	    MSP, r0
    mrs	    r1, MSP
    cmp	    r1, r0
    bne	    cpu_test_failed
    ; /* Restore MSP */
    msr	    MSP, r3
    ; /* Save PSP and test it */
    mrs	    r3, PSP
    ldr	    r0, =CPU_TEST_PATTERN_K
    msr	    PSP, r0
    mrs	    r1, PSP
    cmp	    r1, r0
    bne	    cpu_test_failed
    ldr	    r0, =CPU_TEST_PATTERN_L
    msr	    PSP, r0
    mrs	    r1, PSP
    cmp	    r1, r0
    bne	    cpu_test_failed
    ; /* Restore PSP */
    msr	    PSP, r3

    ; /* Test LR */
    ldr	    r0, =CPU_TEST_PATTERN_I
    mov	    LR, r0
    cmp	    LR, r0
    bne	    cpu_test_failed
    ldr	    r0, =CPU_TEST_PATTERN_J
    mov	    LR, r0
    cmp	    LR, r0
    bne	    cpu_test_failed

    ; /* Test APSR */
    ; /* Copy the value of APSR_g and restore after test */
    mrs     r6, PSR
    ldr     r4, =CPU_TEST_PATTERN_APSR_A
    msr     APSR_nzcvq, r4
    msr     APSR_g, r4
    mrs     r5, APSR
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    ;/* Load zero and read it back */
    mov     r4, #0
    msr     APSR_nzcvq, r4
    msr     APSR_g, r4
    mrs     r5, APSR
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    msr     APSR_g, r6

    ; /* Test PRIMASK */
    mrs     r6, PRIMASK
    mov	    r4, #1
    msr	    PRIMASK, r4
    mrs     r5, PRIMASK
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    mov     r4, #0
    msr	    PRIMASK, r4
    mrs     r5, PRIMASK
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    msr     PRIMASK, r6

    ; /* Test FAULTMASK */
    mrs     r6, FAULTMASK
    mov	    r4, #1
    msr	    FAULTMASK, r4
    mrs     r5, FAULTMASK
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    mov     r4, #0
    msr	    FAULTMASK, r4
    mrs     r5, FAULTMASK
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    msr     FAULTMASK, r6

    ; /* Test BASEPRI */
    mrs     r6, BASEPRI
    mov	    r4, #0x40
    msr	    BASEPRI, r4
    mrs     r5, BASEPRI
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    mov     r4, #0xA0
    msr	    BASEPRI, r4
    mrs     r5, BASEPRI
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    msr     BASEPRI, r6

    ; /* Test CONTROL */
    mrs     r6, CONTROL
    mov	    r4, #0x6
    msr	    CONTROL, r4
    mrs     r5, CONTROL
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    mov     r4, #0x0
    msr	    CONTROL, r4
    mrs     r5, CONTROL
    cmp     r5, r4
    IT	    NE
    bne     cpu_test_failed
    msr     CONTROL, r6

    pop     {r4-r7}
    pop	    {r15}

CLASSB_FPU_RegistersTest:
    push    {r14}
    push    {r2-r7}
    ; /* Copy input arguments */
    mov	    r6, r0
    ; /* Call _CLASSB_UpdateTestResult after loading arguments into registers */
    ldr	    r0, =CLASSB_TEST_TYPE_SST
    cbz     r6, progress_fpu_test_type_sst
    ldr	    r0, =CLASSB_TEST_TYPE_RST
progress_fpu_test_type_sst:
    ldr	    r1, =CLASSB_TEST_FPU
    ldr	    r2, =CLASSB_TEST_INPROGRESS
    bl	    _CLASSB_UpdateTestResult

    vpush.32 {s16-s31}
    vmrs    r3, fpscr
    /* Reserve space in stack to use during test */
    sub	    sp, #16
    add	    r7, sp, #0
    ldr	    r4, =CPU_TEST_PATTERN_I
    ; /* Test s0 first */
    ; /* Load tests bit patterns into s0 register */
    vldr    s0, =CPU_TEST_PATTERN_I
    vstm    r7, {s0}
    ldr	    r5, [r7]
    cmp	    r4, r5
    IT	    NE
    bne	    asm_fpu_reg_fail
    add     r7, #16
    mov	    SP, r7

    ; /* Load first pattern into S1 to S31 */
    vldr    s1, =CPU_TEST_PATTERN_I
    vldr    s2, =CPU_TEST_PATTERN_I
    vldr    s3, =CPU_TEST_PATTERN_I
    vldr    s4, =CPU_TEST_PATTERN_I
    vldr    s5, =CPU_TEST_PATTERN_I
    vldr    s6, =CPU_TEST_PATTERN_I
    vldr    s7, =CPU_TEST_PATTERN_I
    vldr    s8, =CPU_TEST_PATTERN_I
    vldr    s9, =CPU_TEST_PATTERN_I
    vldr    s10, =CPU_TEST_PATTERN_I
    vldr    s11, =CPU_TEST_PATTERN_I
    vldr    s12, =CPU_TEST_PATTERN_I
    vldr    s13, =CPU_TEST_PATTERN_I
    vldr    s14, =CPU_TEST_PATTERN_I
    vldr    s15, =CPU_TEST_PATTERN_I
    vldr    s16, =CPU_TEST_PATTERN_I
    vldr    s17, =CPU_TEST_PATTERN_I
    vldr    s18, =CPU_TEST_PATTERN_I
    vldr    s19, =CPU_TEST_PATTERN_I
    vldr    s20, =CPU_TEST_PATTERN_I
    vldr    s21, =CPU_TEST_PATTERN_I
    vldr    s22, =CPU_TEST_PATTERN_I
    vldr    s23, =CPU_TEST_PATTERN_I
    vldr    s24, =CPU_TEST_PATTERN_I
    vldr    s25, =CPU_TEST_PATTERN_I
    vldr    s26, =CPU_TEST_PATTERN_I
    vldr    s27, =CPU_TEST_PATTERN_I
    vldr    s28, =CPU_TEST_PATTERN_I
    vldr    s29, =CPU_TEST_PATTERN_I
    vldr    s30, =CPU_TEST_PATTERN_I
    vldr    s31, =CPU_TEST_PATTERN_I
    vcmpe.f32   s0, s1
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s2, s3
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s4, s5
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s6, s7
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s8, s9
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s10, s11
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s12, s13
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s14, s15
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s16, s17
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s18, s19
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s20, s21
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s22, s23
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s24, s25
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s26, s27
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s28, s29
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s30, s31
    vmrs    APSR_nzcv, fpscr
    IT	    NE
    bne	    asm_fpu_reg_fail

    ; /* Load second pattern into S0 to S31 */
    vldr    s0, =CPU_TEST_PATTERN_J
    vldr    s1, =CPU_TEST_PATTERN_J
    vldr    s2, =CPU_TEST_PATTERN_J
    vldr    s3, =CPU_TEST_PATTERN_J
    vldr    s4, =CPU_TEST_PATTERN_J
    vldr    s5, =CPU_TEST_PATTERN_J
    vldr    s6, =CPU_TEST_PATTERN_J
    vldr    s7, =CPU_TEST_PATTERN_J
    vldr    s8, =CPU_TEST_PATTERN_J
    vldr    s9, =CPU_TEST_PATTERN_J
    vldr    s10, =CPU_TEST_PATTERN_J
    vldr    s11, =CPU_TEST_PATTERN_J
    vldr    s12, =CPU_TEST_PATTERN_J
    vldr    s13, =CPU_TEST_PATTERN_J
    vldr    s14, =CPU_TEST_PATTERN_J
    vldr    s15, =CPU_TEST_PATTERN_J
    vldr    s16, =CPU_TEST_PATTERN_J
    vldr    s17, =CPU_TEST_PATTERN_J
    vldr    s18, =CPU_TEST_PATTERN_J
    vldr    s19, =CPU_TEST_PATTERN_J
    vldr    s20, =CPU_TEST_PATTERN_J
    vldr    s21, =CPU_TEST_PATTERN_J
    vldr    s22, =CPU_TEST_PATTERN_J
    vldr    s23, =CPU_TEST_PATTERN_J
    vldr    s24, =CPU_TEST_PATTERN_J
    vldr    s25, =CPU_TEST_PATTERN_J
    vldr    s26, =CPU_TEST_PATTERN_J
    vldr    s27, =CPU_TEST_PATTERN_J
    vldr    s28, =CPU_TEST_PATTERN_J
    vldr    s29, =CPU_TEST_PATTERN_J
    vldr    s30, =CPU_TEST_PATTERN_J
    vldr    s31, =CPU_TEST_PATTERN_J
    vcmpe.f32   s0, s1
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s2, s3
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s4, s5
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s6, s7
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s8, s9
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s10, s11
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s12, s13
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s14, s15
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s16, s17
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s18, s19
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s20, s21
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s22, s23
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s24, s25
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s26, s27
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s28, s29
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail
    vcmpe.f32   s30, s31
    vmrs    APSR_nzcv, fpscr
    bne	    asm_fpu_reg_fail

    ; /* Test FPSCR */
    ldr	    r4, =CPU_TEST_PATTERN_ZERO
    vmsr    fpscr, r4
    vmrs    r5, fpscr
    cmp	    r5, r4
    bne	    asm_fpu_reg_fail
    ldr	    r4, =FPSCR_TEST_PATTERN_A
    vmsr    fpscr, r4
    vmrs    r5, fpscr
    cmp	    r4, r5
    bne	    asm_fpu_reg_fail
    vmsr    fpscr, r3
    vpop.32 {s16-s31}
    
update_fpu_result_return:
    ; /* Code reaches here if none of the above tests are failed */
    bl	    fpu_test_passed
    ; /* Return CLASSB_TEST_PASSED */
    ldr	    r0, =CLASSB_TEST_PASSED
    pop	    {r2-r7}
    ; /* return by POP-ing LR into PC */
    pop	    {r15}
    
    ; /* Remain in infinite loop if a register test is failed. */
asm_fpu_reg_fail:
    b       asm_fpu_reg_fail

fpu_test_passed:
    push    {lr}
    ldr	    r0, =CLASSB_TEST_TYPE_SST
    cbz     r6, pass_fpu_test_type_sst
    ldr	    r0, =CLASSB_TEST_TYPE_RST
pass_fpu_test_type_sst:
    ldr	    r1, =CLASSB_TEST_FPU
    ldr	    r2, =CLASSB_TEST_PASSED
    bl	    _CLASSB_UpdateTestResult
    pop	    {r15}