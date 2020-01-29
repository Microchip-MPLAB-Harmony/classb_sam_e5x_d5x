/*******************************************************************************
  Class B Library v0.1.0 Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_interrupt_test.c

  Summary:
    Class B Library source file for the Interrupt test

  Description:
    This file provides self-test functions for the Interrupt.

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

/*----------------------------------------------------------------------------
 *     include files
 *----------------------------------------------------------------------------*/
#include "classb/src/classb_interrupt_test.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/
#define DEVICE_VECT_OFFSET 16
#define CLASSB_VECTOR_TABLE_SIZE (DEVICE_VECT_OFFSET + PERIPH_MAX_IRQn)

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/
extern uint32_t __svectors;
extern volatile uint16_t * interrupt_tests_status;
// Align the vector table at 1024 byte boundary
__attribute__ ((aligned (1024)))
uint32_t classb_ram_vector_table[CLASSB_VECTOR_TABLE_SIZE];

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/

/*============================================================================
void _CLASSB_RTC_handler(void)
------------------------------------------------------------------------------
Purpose: Custom handler used for RTC Interrupt test
Input  : None.
Output : None.
Notes  : The RTC is reset after successfully performing the test.
============================================================================*/
void _CLASSB_RTC_Handler(void)
{
    // Clear the checked interrupt flag
    RTC_REGS->MODE0.RTC_INTFLAG = RTC_MODE0_INTFLAG_CMP0_Msk;
    interrupt_tests_status[0] = CLASSB_INTERRUPT_OK_PATTERN;
    // Reset the tested peripheral
    RTC_REGS->MODE0.RTC_CTRLA = RTC_MODE0_CTRLA_SWRST_Msk;
    while((RTC_REGS->MODE0.RTC_SYNCBUSY & RTC_MODE0_SYNCBUSY_SWRST_Msk) == RTC_MODE0_SYNCBUSY_SWRST_Msk)
    {
        // Wait for Synchronization after Software Reset
    }
}

/*============================================================================
void _CLASSB_TC0_Handler(void)
------------------------------------------------------------------------------
Purpose: Custom handler used for TC Interrupt test
Input  : None.
Output : None.
Notes  : The TC0 is reset after successfully performing the test.
============================================================================*/
void _CLASSB_TC0_Handler(void)
{
    // Clear the checked interrupt flag
    TC0_REGS->COUNT16.TC_INTFLAG = TC_INTFLAG_OVF_Msk;
    interrupt_tests_status[1] = CLASSB_INTERRUPT_OK_PATTERN;
    // Reset the tested peripheral
    TC0_REGS->COUNT16.TC_CTRLA = TC_CTRLA_SWRST_Msk;
    while((TC0_REGS->COUNT16.TC_SYNCBUSY & TC_SYNCBUSY_SWRST_Msk) == TC_SYNCBUSY_SWRST_Msk)
    {
        // Wait for Synchronization after Software Reset
    }
}

/*============================================================================
void _CLASSB_BuildVectorTable(void)
------------------------------------------------------------------------------
Purpose: Build the vector table for Interrupt self-test
Input  : None.
Output : None.
Notes  : The vector table used by this test is placed in SRAM.
============================================================================*/
void _CLASSB_BuildVectorTable(void)
{
    int i = 0;
    uint32_t vector_start = (uint32_t)&__svectors;
    
    for(i = 0; i < CLASSB_VECTOR_TABLE_SIZE; i++)
    {
        // Get the interrupt handler address from the original vector table.
        classb_ram_vector_table[i] = *(uint32_t *)(vector_start + (i * 4));
    }
    // Modify the tested interrupt handler address
    classb_ram_vector_table[DEVICE_VECT_OFFSET + RTC_IRQn] = (uint32_t )&_CLASSB_RTC_Handler;
    classb_ram_vector_table[DEVICE_VECT_OFFSET + TC0_IRQn] = (uint32_t )&_CLASSB_TC0_Handler;
    // Update VTOR to point to the new vector table in SRAM
    SCB->VTOR = ((uint32_t)&classb_ram_vector_table[0] & SCB_VTOR_TBLOFF_Msk);
}

/*============================================================================
void _CLASSB_RTC_Init(void)
------------------------------------------------------------------------------
Purpose: Configure RTC peripheral for Interrupt self-test
Input  : None.
Output : None.
Notes  : The clocks required for RTC are enabled after reset. This function
         does not modify the default clocks.
============================================================================*/
void _CLASSB_RTC_Init(void)
{
    // Select the RTC clock
    OSC32KCTRL_REGS->OSC32KCTRL_RTCCTRL = OSC32KCTRL_RTCCTRL_RTCSEL_ULP1K;
    // Enable APB clock for RTC
    RTC_REGS->MODE0.RTC_CTRLA = RTC_MODE0_CTRLA_SWRST_Msk;
    
    while((RTC_REGS->MODE0.RTC_SYNCBUSY & RTC_MODE0_SYNCBUSY_SWRST_Msk) == RTC_MODE0_SYNCBUSY_SWRST_Msk)
    {
        // Wait for Synchronization after Software Reset
    }
    RTC_REGS->MODE0.RTC_CTRLA = RTC_MODE0_CTRLA_MODE(0) | RTC_MODE0_CTRLA_PRESCALER(0x1) | RTC_MODE0_CTRLA_MATCHCLR_Msk ;
    RTC_REGS->MODE0.RTC_COMP[0] = 0x100;
    RTC_REGS->MODE0.RTC_INTENSET = RTC_MODE0_INTENSET_CMP0_Msk;
    
    // Enable NVIC IRQn for RTC
    NVIC_EnableIRQ(RTC_IRQn);
    
    // Start RTC
    RTC_REGS->MODE0.RTC_CTRLA |= RTC_MODE0_CTRLA_ENABLE_Msk;
    while((RTC_REGS->MODE0.RTC_SYNCBUSY & RTC_MODE0_SYNCBUSY_ENABLE_Msk) == RTC_MODE0_SYNCBUSY_ENABLE_Msk)
    {
        // Wait for synchronization after Enabling RTC
    }
}

/*============================================================================
void _CLASSB_TC0_CompareInit(void)
------------------------------------------------------------------------------
Purpose: Configure TC peripheral for Interrupt self-test
Input  : None.
Output : None.
Notes  : The TC0 is reset after successfully performing the test.
============================================================================*/
void _CLASSB_TC0_CompareInit( void )
{
    // Enable APB clock for TC0
    MCLK_REGS->MCLK_APBAMASK |= MCLK_APBAMASK_TC0_Msk;
    
    // Select Generic Clock 0 for TC0
    GCLK_REGS->GCLK_PCHCTRL[9] = GCLK_PCHCTRL_GEN(0)  | GCLK_PCHCTRL_CHEN_Msk;
    while ((GCLK_REGS->GCLK_PCHCTRL[9] & GCLK_PCHCTRL_CHEN_Msk) != GCLK_PCHCTRL_CHEN_Msk)
    {
        // Wait for synchronization
    }
    
    // Reset TC
    TC0_REGS->COUNT16.TC_CTRLA = TC_CTRLA_SWRST_Msk;
    while((TC0_REGS->COUNT16.TC_SYNCBUSY & TC_SYNCBUSY_SWRST_Msk) == TC_SYNCBUSY_SWRST_Msk)
    {
        // Wait for synchronization
    }
    // Configure counter mode & prescaler
    TC0_REGS->COUNT16.TC_CTRLA = TC_CTRLA_MODE_COUNT16 | TC_CTRLA_PRESCALER_DIV64 | TC_CTRLA_PRESCSYNC_PRESC ;
    // Configure waveform generation mode
    TC0_REGS->COUNT16.TC_WAVE = TC_WAVE_WAVEGEN_MFRQ;
    TC0_REGS->COUNT16.TC_CC[0] = 12500U;

    // Clear all interrupt flags
    TC0_REGS->COUNT16.TC_INTFLAG = TC_INTFLAG_Msk;
    while((TC0_REGS->COUNT16.TC_SYNCBUSY))
    {
        // Wait for Write Synchronization
    }
    TC0_REGS->COUNT16.TC_INTENSET |= TC_INTENSET_OVF_Msk;
    TC0_REGS->COUNT16.TC_CTRLA |= TC_CTRLA_ENABLE_Msk;
    
    // Enable NVIC IRQn for TC0
    NVIC_EnableIRQ(TC0_IRQn);
}

/*============================================================================
void _CLASSB_NVIC_Init(void)
------------------------------------------------------------------------------
Purpose: Initializes the NVIC
Input  : None.
Output : None.
Notes  : None.
============================================================================*/
void _CLASSB_NVIC_Init(void)
{
    /* Enable NVIC Controller */
    __DMB();
    __enable_irq();
}

/*============================================================================
CLASSB_TEST_STATUS CLASSB_SST_InterruptTest(void)
------------------------------------------------------------------------------
Purpose: Test interrupt generation and handling.
Input  : None.
Output : Test status.
Notes  : None.
============================================================================*/
CLASSB_TEST_STATUS CLASSB_SST_InterruptTest(void)
{
    CLASSB_TEST_STATUS intr_test_status = CLASSB_TEST_NOT_EXECUTED;
    
    _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_INTERRUPT,
                CLASSB_TEST_INPROGRESS);
    _CLASSB_BuildVectorTable();
    _CLASSB_NVIC_Init();
    _CLASSB_RTC_Init();
    _CLASSB_TC0_CompareInit();
    // Wait until the flags are updated from the interrupt handlers
    while((0 == interrupt_tests_status[0]) || (0 == interrupt_tests_status[1]))
    {
        ;
    }
    
    if ((CLASSB_INTERRUPT_OK_PATTERN == interrupt_tests_status[0]) && (CLASSB_INTERRUPT_OK_PATTERN == interrupt_tests_status[1]))
    {
        intr_test_status = CLASSB_TEST_PASSED;
        _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_INTERRUPT,
                CLASSB_TEST_PASSED);
    }
    else
    {
        intr_test_status = CLASSB_TEST_FAILED;
        _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_INTERRUPT,
                CLASSB_TEST_FAILED);
        CLASSB_SelfTest_FailSafe(CLASSB_TEST_INTERRUPT);
    }
    
    return intr_test_status;
}