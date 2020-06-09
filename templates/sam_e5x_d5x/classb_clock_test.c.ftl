/*******************************************************************************
  Class B Library ${REL_VER} Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_clock_test.c

  Summary:
    Class B Library CPU clock frequency self-test source file

  Description:
    This file provides CPU clock frequency self-test.

*******************************************************************************/

/*******************************************************************************
* Copyright (C) ${REL_YEAR} Microchip Technology Inc. and its subsidiaries.
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
#include "classb/classb_clock_test.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/
#define CLASSB_CLOCK_MAX_CLOCK_FREQ         (${CLASSB_CPU_MAX_CLOCK}U)
#define CLASSB_CLOCK_MAX_SYSTICK_VAL        (0x${CLASSB_SYSTICK_MAXCOUNT}U)
#define CLASSB_CLOCK_RTC_CLK_FREQ           (${CLASSB_RTC_EXPECTED_CLOCK}U)
#define CLASSB_CLOCK_MAX_TEST_ACCURACY      (${CLASSB_CPU_CLOCK_TEST_ACCUR}U)
/* Since no floating point is used for clock test, multiply intermediate
 * values with 128.
 */
#define CLASSB_CLOCK_MUL_FACTOR             (128U)

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/
extern void _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE test_type,
    CLASSB_TEST_ID test_id, CLASSB_TEST_STATUS value);

/*============================================================================
static uint32_t _CLASSB_Clock_SysTickGetVal(void)
------------------------------------------------------------------------------
Purpose: Reads the VAL register of the SysTick
Input  : None.
Output : None.
Notes  : None.
============================================================================*/
static uint32_t _CLASSB_Clock_SysTickGetVal ( void )
{
	return (SysTick->VAL);
}

/*============================================================================
static void _CLASSB_Clock_SysTickStart(void)
------------------------------------------------------------------------------
Purpose: Configure the SysTick for clock self-test
Input  : None.
Output : None.
Notes  : If SysTick is used by the application, ensure that it
         is reconfigured after the clock self test.
============================================================================*/
static void _CLASSB_Clock_SysTickStart ( void )
{
	SysTick->LOAD = CLASSB_CLOCK_MAX_SYSTICK_VAL;
    SysTick->VAL = 0;
	SysTick->CTRL |= SysTick_CTRL_ENABLE_Msk;
}

/*============================================================================
static void _CLASSB_Clock_RTC_Enable(void)
------------------------------------------------------------------------------
Purpose: Enables the RTC
Input  : None.
Output : None.
Notes  : None.
============================================================================*/
static void _CLASSB_Clock_RTC_Enable ( void )
{
    RTC_REGS->MODE0.RTC_CTRLA |= RTC_MODE0_CTRLA_ENABLE_Msk;
    while((RTC_REGS->MODE0.RTC_SYNCBUSY & RTC_MODE0_SYNCBUSY_ENABLE_Msk) == RTC_MODE0_SYNCBUSY_ENABLE_Msk)
    {
        // Wait for synchronization after Enabling RTC
        ;
    }
}

/*============================================================================
static void _CLASSB_Clock_RTC_ClockInit(void)
------------------------------------------------------------------------------
Purpose: Configure clocks for the RTC peripheral
Input  : None.
Output : None.
Notes  : This self-test configures RTC to use an external
         32.768kHz Crystal as reference clock. Do not use this self-test
         if the external crystal is not available.
============================================================================*/
static void _CLASSB_Clock_RTC_ClockInit(void)
{
    // Enable APB clock for RTC
    MCLK_REGS->MCLK_APBAMASK |= MCLK_APBAMASK_RTC_Msk;

    // Configure 32K External Oscillator
    OSC32KCTRL_REGS->OSC32KCTRL_XOSC32K = OSC32KCTRL_XOSC32K_STARTUP(2) |
        OSC32KCTRL_XOSC32K_ENABLE_Msk | OSC32KCTRL_XOSC32K_CGM(1) |
        OSC32KCTRL_XOSC32K_EN1K_Msk | OSC32KCTRL_XOSC32K_EN32K_Msk | OSC32KCTRL_XOSC32K_XTALEN_Msk;
    while(!((OSC32KCTRL_REGS->OSC32KCTRL_STATUS & OSC32KCTRL_STATUS_XOSC32KRDY_Msk) == OSC32KCTRL_STATUS_XOSC32KRDY_Msk))
    {
        // Wait for the XOSC32K Ready state
    }
    // Select 32.768 kHz XOSC32K as RTC clock
    OSC32KCTRL_REGS->OSC32KCTRL_RTCCTRL = OSC32KCTRL_RTCCTRL_RTCSEL(5);
}

/*============================================================================
static void _CLASSB_Clock_RTC_Init(void)
------------------------------------------------------------------------------
Purpose: Configure RTC peripheral for CPU clock self-test
Input  : None.
Output : None.
Notes  : The clocks required for RTC are configured in a separate function.
============================================================================*/
static void _CLASSB_Clock_RTC_Init(uint32_t test_cycles)
{
    RTC_REGS->MODE0.RTC_CTRLA = RTC_MODE0_CTRLA_SWRST_Msk;

    while((RTC_REGS->MODE0.RTC_SYNCBUSY & RTC_MODE0_SYNCBUSY_SWRST_Msk) == RTC_MODE0_SYNCBUSY_SWRST_Msk)
    {
        // Wait for Synchronization after Software Reset
        ;
    }
    RTC_REGS->MODE0.RTC_CTRLA = RTC_MODE0_CTRLA_MODE(0) | RTC_MODE0_CTRLA_PRESCALER(0x1) | RTC_MODE0_CTRLA_MATCHCLR_Msk ;
    RTC_REGS->MODE0.RTC_COMP[0] = test_cycles;
    RTC_REGS->MODE0.RTC_INTFLAG = RTC_MODE0_INTFLAG_Msk;
}

/*============================================================================
CLASSB_TEST_STATUS CLASSB_ClockTest(uint32_t cpu_clock_freq,
    uint8_t error_limit,
    uint8_t clock_test_rtc_cycles,
    bool running_context);
------------------------------------------------------------------------------
Purpose: Check whether CPU clock frequency is within acceptable limits.
Input  : Expected CPU clock frequency value, acceptable error percentage,
         test duration (in RTC cycles) and running context.
Output : Test status.
Notes  : None.
============================================================================*/
CLASSB_TEST_STATUS CLASSB_ClockTest(uint32_t cpu_clock_freq,
    uint8_t error_limit,
    uint16_t clock_test_rtc_cycles,
    bool running_context)
{
    CLASSB_TEST_STATUS clock_test_status = CLASSB_TEST_NOT_EXECUTED;
    int64_t expected_ticks = ((cpu_clock_freq / CLASSB_CLOCK_RTC_CLK_FREQ) * clock_test_rtc_cycles);
    volatile uint32_t systick_count_a = 0;
    volatile uint32_t systick_count_b = 0;
    int64_t ticks_passed = 0;
    uint8_t calculated_error_limit = 0;

    if ((expected_ticks > CLASSB_CLOCK_MAX_SYSTICK_VAL)
        || (cpu_clock_freq > CLASSB_CLOCK_MAX_CLOCK_FREQ)
        || (error_limit < CLASSB_CLOCK_MAX_TEST_ACCURACY))
    {
        ;
    }
    else
    {
        if (running_context == true)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_CLOCK,
                CLASSB_TEST_INPROGRESS);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_CLOCK,
                CLASSB_TEST_INPROGRESS);
        }

        _CLASSB_Clock_RTC_ClockInit();
        _CLASSB_Clock_RTC_Init(clock_test_rtc_cycles);
        _CLASSB_Clock_SysTickStart();
        _CLASSB_Clock_RTC_Enable();

        systick_count_a = _CLASSB_Clock_SysTickGetVal();
        while(!((RTC_REGS->MODE0.RTC_INTFLAG & RTC_MODE0_INTFLAG_CMP0_Msk) == RTC_MODE0_INTFLAG_CMP0_Msk))
        {
            ;
        }
        systick_count_b = _CLASSB_Clock_SysTickGetVal();

        expected_ticks = expected_ticks * CLASSB_CLOCK_MUL_FACTOR;
        ticks_passed = (systick_count_a - systick_count_b) * CLASSB_CLOCK_MUL_FACTOR;

        if (ticks_passed < expected_ticks)
        {
            // The CPU clock is slower than expected
            calculated_error_limit = ((((expected_ticks - ticks_passed) * CLASSB_CLOCK_MUL_FACTOR)/ (expected_ticks)) * 100) / CLASSB_CLOCK_MUL_FACTOR;
        }
        else
        {
            // The CPU clock is faster than expected
            calculated_error_limit = ((((ticks_passed - expected_ticks) * CLASSB_CLOCK_MUL_FACTOR)/ (expected_ticks)) * 100) / CLASSB_CLOCK_MUL_FACTOR;
        }

        if (error_limit > calculated_error_limit)
        {
            clock_test_status = CLASSB_TEST_PASSED;
            if (running_context == true)
            {
                _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_CLOCK,
                    CLASSB_TEST_PASSED);
            }
            else
            {
                _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_CLOCK,
                    CLASSB_TEST_PASSED);
            }
        }
        else
        {
            clock_test_status = CLASSB_TEST_FAILED;
            if (running_context == true)
            {
                _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_CLOCK,
                    CLASSB_TEST_FAILED);
            }
            else
            {
                _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_CLOCK,
                    CLASSB_TEST_FAILED);
            }
            CLASSB_SelfTest_FailSafe(CLASSB_TEST_CLOCK);
        }
    }

    return clock_test_status;
}
