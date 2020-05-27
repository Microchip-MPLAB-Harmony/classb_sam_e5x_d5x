/*******************************************************************************
  Class B Library v0.1.0 Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb.c

  Summary:
    Class B Library main source file

  Description:
    This file provides general functions for the Class B library.

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
#include "classb/src/classb.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/
#define CLASSB_RESULT_ADDR                  (0x20000000U)
#define CLASSB_COMPL_RESULT_ADDR            (0x20000004U)
#define CLASSB_ONGOING_TEST_VAR_ADDR        (0x20000008U)
#define CLASSB_TEST_IN_PROG_VAR_ADDR        (0x2000000cU)
#define CLASSB_WDT_TEST_IN_PROG_VAR_ADDR    (0x20000010U)
#define CLASSB_FLASH_TEST_VAR_ADDR          (0x20000014U)
#define CLASSB_INTERRUPT_TEST_VAR_ADDR      (0x20000018U)
#define CLASSB_INTERRUPT_COUNT_VAR_ADDR     (0x2000001cU)
#define CLASSB_SRAM_STARTUP_TEST_SIZE       (65536U)
#define CLASSB_CLOCK_ERROR_PERCENT          (5U)
#define CLASSB_CLOCK_TEST_RTC_CYCLES        (200U)
// RTC is clocked from 32768 Hz Crystal. One RTC cycle is 30517 nano sec
#define CLASSB_CLOCK_TEST_RTC_RATIO_NS      (30517U)
#define CLASSB_CLOCK_TEST_RATIO_NS_MS       (1000000U)
#define CLASSB_CLOCK_DEFAULT_CLOCK_FREQ     (48000000U)
#define CLASSB_INVALID_TEST_ID              (0xFFU)

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/
__attribute__((persistent)) volatile uint8_t * ongoing_sst_id;
__attribute__((persistent)) volatile uint8_t * classb_test_in_progress;
__attribute__((persistent)) volatile uint8_t * wdt_test_in_progress;
__attribute__((persistent)) volatile uint8_t * interrupt_tests_status;
__attribute__((persistent)) volatile uint32_t * interrupt_count;

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/

/*============================================================================
void CLASSB_GlobalsInit(void)
------------------------------------------------------------------------------
Purpose: Initialization of global variables for the classb library.
Input  : None
Output : None
Notes  : This function is called before C startup code
============================================================================*/
void CLASSB_GlobalsInit(void)
{
    /* Initialize persistent pointers
     * These variables point to address' in the reserved SRAM for the
     * Class B library.
     */
    ongoing_sst_id = (volatile uint8_t *)CLASSB_ONGOING_TEST_VAR_ADDR;
    classb_test_in_progress = (volatile uint8_t *)CLASSB_TEST_IN_PROG_VAR_ADDR;
    wdt_test_in_progress = (volatile uint8_t *)CLASSB_WDT_TEST_IN_PROG_VAR_ADDR;
    interrupt_tests_status = (volatile uint8_t *)CLASSB_INTERRUPT_TEST_VAR_ADDR;
    interrupt_count = (volatile uint32_t *)CLASSB_INTERRUPT_COUNT_VAR_ADDR;
    
    // Initialize variables
    *ongoing_sst_id = CLASSB_INVALID_TEST_ID;
    *classb_test_in_progress = CLASSB_TEST_NOT_STARTED;
    *wdt_test_in_progress = CLASSB_TEST_NOT_STARTED;
    *interrupt_tests_status = CLASSB_TEST_NOT_STARTED;
}

/*============================================================================
void CLASSB_App_WDT_Recovery(void)
------------------------------------------------------------------------------
Purpose: Called if a WDT reset is caused by the application
Input  : None
Output : None
Notes  : The application decides the contents of this function.
============================================================================*/
void CLASSB_App_WDT_Recovery(void)
{
#if (defined(__DEBUG) || defined(__DEBUG_D)) && defined(__XC32)
    __builtin_software_breakpoint();
#endif
    // Infinite loop
    while (1)
    {
        ;
    }
}

/*============================================================================
void CLASSB_SST_WDT_Recovery(void)
------------------------------------------------------------------------------
Purpose: Called after WDT reset, to indicate that a Class B function is stuck.
Input  : None
Output : None
Notes  : The application decides the contents of this function.
============================================================================*/
void CLASSB_SST_WDT_Recovery(void)
{
#if (defined(__DEBUG) || defined(__DEBUG_D)) && defined(__XC32)
    __builtin_software_breakpoint();
#endif
    // Infinite loop
    while (1)
    {
        ;
    }
}

/*============================================================================
void CLASSB_SelfTest_FailSafe(CLASSB_TEST_ID cb_test_id)
------------------------------------------------------------------------------
Purpose: Called if a non-critical self-test is failed.
Input  : None
Output : None
Notes  : The application decides the contents of this function. This function
         should perform failsafe operation after checking the 'cb_test_id'.
         This function must not return.
============================================================================*/
void CLASSB_SelfTest_FailSafe(CLASSB_TEST_ID cb_test_id)
{
#if (defined(__DEBUG) || defined(__DEBUG_D)) && defined(__XC32)
    __builtin_software_breakpoint();
#endif
    // Infinite loop
    while (1)
    {
        ;
    }
}


/*============================================================================
void CLASSB_TestWDT(void)
------------------------------------------------------------------------------
Purpose: Function to check WDT after a device reset.
Input  : None
Output : None
Notes  : None
============================================================================*/
void CLASSB_TestWDT(void)
{
    /* This persistent flag is checked after reset */
    *wdt_test_in_progress = CLASSB_TEST_STARTED;

    /* If WDT ALWAYSON is set, wait till WDT resets the device */
    if ((WDT_REGS->WDT_CTRLA & WDT_CTRLA_ALWAYSON_Msk) == WDT_CTRLA_ALWAYSON_Msk)
    {
        // Infinite loop
        while (1)
        {
            ;
        }
    }
    else
    {
        // If WDT is not enabled, enable WDT and wait
        if ((WDT_REGS->WDT_CTRLA & WDT_CTRLA_ENABLE_Msk) == 0)
        {
            // Configure timeout
            WDT_REGS->WDT_CONFIG = WDT_CONFIG_PER_CYC256;
            WDT_REGS->WDT_CTRLA |= WDT_CTRLA_ENABLE_Msk;
            // Infinite loop
            while (1)
            {
                ;
            }
        }
        else
        {
            // Infinite loop
            while (1)
            {
                ;
            }
        }
    }
}

/*============================================================================
void CLASSB_Init(void)
------------------------------------------------------------------------------
Purpose: To check reset cause and decide the startup flow.
Input  : None
Output : None
Notes  : This function is executed on every device reset. This shall be
         called right after the reset, before any other initialization is
         performed.
============================================================================*/

CLASSB_INIT_STATUS CLASSB_Init(void)
{
    /* Initialize persistent pointers
     * These variables point to address' in the reserved SRAM for the
     * Class B library.
     */
    ongoing_sst_id = (volatile uint8_t *)CLASSB_ONGOING_TEST_VAR_ADDR;
    classb_test_in_progress = (volatile uint8_t *)CLASSB_TEST_IN_PROG_VAR_ADDR;
    wdt_test_in_progress = (volatile uint8_t *)CLASSB_WDT_TEST_IN_PROG_VAR_ADDR;
    interrupt_tests_status = (volatile uint8_t *)CLASSB_INTERRUPT_TEST_VAR_ADDR;
    interrupt_count = (volatile uint32_t *)CLASSB_INTERRUPT_COUNT_VAR_ADDR;

    CLASSB_INIT_STATUS ret_val = CLASSB_SST_NOT_DONE;

    if ((RSTC_REGS->RSTC_RCAUSE & RSTC_RCAUSE_WDT_Msk) == RSTC_RCAUSE_WDT_Msk)
    {
        if (*wdt_test_in_progress == CLASSB_TEST_STARTED)
        {
            *wdt_test_in_progress = CLASSB_TEST_NOT_STARTED;
        }
        else if (*classb_test_in_progress == CLASSB_TEST_STARTED)
        {
            CLASSB_SST_WDT_Recovery();
        }
        else
        {
            CLASSB_App_WDT_Recovery();
        }
    }
    else
    {
        /* If it is a software reset and the Class B library has issued it */
        if ((*classb_test_in_progress == CLASSB_TEST_STARTED) &&
            ((RSTC_REGS->RSTC_RCAUSE & RSTC_RCAUSE_SYST_Msk) == RSTC_RCAUSE_SYST_Msk))
        {
            *classb_test_in_progress = CLASSB_TEST_NOT_STARTED;
            ret_val = CLASSB_SST_DONE;
        }
        else
        {
            /* For all other reset causes,
             * test the reserved SRAM,
             * initialize Class B variables
             * clear the test results and test WDT
             */
            bool result_area_test_ok = false;
            bool ram_buffer_test_ok = false;
            // Test the reserved SRAM
            result_area_test_ok = CLASSB_RAMMarchC((uint32_t *)HSRAM_ADDR,
                CLASSB_SRAM_TEST_BUFFER_SIZE);
            ram_buffer_test_ok = CLASSB_RAMMarchC((uint32_t *)HSRAM_ADDR + CLASSB_SRAM_TEST_BUFFER_SIZE,
                CLASSB_SRAM_TEST_BUFFER_SIZE);
            if ((result_area_test_ok == true) && (ram_buffer_test_ok == true))
            {
                // Initialize all Class B variables
                CLASSB_GlobalsInit();
                CLASSB_ClearTestResults(CLASSB_TEST_TYPE_SST);
                CLASSB_ClearTestResults(CLASSB_TEST_TYPE_RST);
                // Perform WDT test
                CLASSB_TestWDT();
            }
            else
            {
                while (1)
                {
                    ;
                }
            }
        }
    }

    return ret_val;
}

/*============================================================================
void CLASSB_Startup_Tests(void)
------------------------------------------------------------------------------
Purpose: Call all startup self-tests.
Input  : None
Output : None
Notes  : This function calls all the configured self-tests during startup.
         The MPLAB Harmony Configurator (MHC) has options to configure
         the startup self-tests. If startup tests are not enabled via MHC,
         this function enables the WDT and returns CLASSB_STARTUP_TEST_NOT_EXECUTED.
============================================================================*/
CLASSB_STARTUP_STATUS CLASSB_Startup_Tests(void)
{
    CLASSB_STARTUP_STATUS cb_startup_status = CLASSB_STARTUP_TEST_NOT_EXECUTED;
    CLASSB_STARTUP_STATUS cb_temp_startup_status = CLASSB_STARTUP_TEST_NOT_EXECUTED;
    CLASSB_TEST_STATUS cb_test_status = CLASSB_TEST_NOT_EXECUTED;
    uint16_t clock_test_rtc_cycles = ((5 * CLASSB_CLOCK_TEST_RATIO_NS_MS) / CLASSB_CLOCK_TEST_RTC_RATIO_NS);
    //Enable watchdog if it is not enabled
    if (((WDT_REGS->WDT_CTRLA & WDT_CTRLA_ENABLE_Msk) == 0) &&
        ((WDT_REGS->WDT_CTRLA & WDT_CTRLA_ALWAYSON_Msk) == 0))
    {
        WDT_REGS->WDT_CONFIG = WDT_CONFIG_PER_CYC256;
        WDT_REGS->WDT_CTRLA |= WDT_CTRLA_ENABLE_Msk;
    }
    // Enable FPU
    SCB->CPACR |= (0xFu << 20);
    __DSB();
    __ISB();
    // Test processor core registers and FPU registers
    *ongoing_sst_id = CLASSB_TEST_CPU;
    cb_test_status = CLASSB_CPU_RegistersTest(CLASSB_FPU_TEST_ENABLE, false);
        if (cb_test_status == CLASSB_TEST_PASSED)
        {
            cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
        }
        else if (cb_test_status == CLASSB_TEST_FAILED)
        {
            cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
        }

        // Program Counter test
        *ongoing_sst_id = CLASSB_TEST_PC;
        cb_test_status = CLASSB_CPU_PCTest(false);

        if (cb_test_status == CLASSB_TEST_PASSED)
        {
            cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
        }
        else if (cb_test_status == CLASSB_TEST_FAILED)
        {
            cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
        }

    // SRAM test
    // Clear WDT before test
    WDT_REGS->WDT_CLEAR = WDT_CLEAR_CLEAR_KEY;
    *ongoing_sst_id = CLASSB_TEST_RAM;
    cb_test_status = CLASSB_SRAM_MarchTestInit((uint32_t *)CLASSB_SRAM_APP_AREA_START,
        CLASSB_SRAM_STARTUP_TEST_SIZE, CLASSB_SRAM_MARCH_C, false);
    if (cb_test_status == CLASSB_TEST_PASSED)
    {
       cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else if (cb_test_status == CLASSB_TEST_FAILED)
    {
       cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }

    // Clock Test
    *ongoing_sst_id = CLASSB_TEST_CLOCK;
    // Clear WDT before test
    WDT_REGS->WDT_CLEAR = WDT_CLEAR_CLEAR_KEY;
    cb_test_status = CLASSB_ClockTest(CLASSB_CLOCK_DEFAULT_CLOCK_FREQ, CLASSB_CLOCK_ERROR_PERCENT, clock_test_rtc_cycles, false);
    if (cb_test_status == CLASSB_TEST_PASSED)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else if (cb_test_status == CLASSB_TEST_FAILED)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }

    // Interrupt Test
    *ongoing_sst_id = CLASSB_TEST_INTERRUPT;
    // Clear WDT before test
    WDT_REGS->WDT_CLEAR = WDT_CLEAR_CLEAR_KEY;
    cb_test_status = CLASSB_SST_InterruptTest();
    if (cb_test_status == CLASSB_TEST_PASSED)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else if (cb_test_status == CLASSB_TEST_FAILED)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }
    if (cb_temp_startup_status == CLASSB_STARTUP_TEST_PASSED)
    {
        cb_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else
    {
        cb_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }
    return cb_startup_status;
}


/*============================================================================
void _on_reset(void)
------------------------------------------------------------------------------
Purpose: Handle reset causes and perform start-up self-tests.
Input  : None
Output : None
Notes  : This function is called from Reset_Handler.
============================================================================*/
void _on_reset(void)
{
    CLASSB_STARTUP_STATUS startup_tests_status = CLASSB_STARTUP_TEST_FAILED;

    CLASSB_INIT_STATUS init_status = CLASSB_Init();

    if (init_status == CLASSB_SST_NOT_DONE)
    {
        *classb_test_in_progress = CLASSB_TEST_STARTED;
        // Run all startup self-tests
        startup_tests_status = CLASSB_Startup_Tests();

        if (startup_tests_status == CLASSB_STARTUP_TEST_PASSED)
        {
            // Reset the device if all tests are passed.
            NVIC_SystemReset();
        }
        else if (startup_tests_status == CLASSB_STARTUP_TEST_FAILED)
        {
#if (defined(__DEBUG) || defined(__DEBUG_D)) && defined(__XC32)
            __builtin_software_breakpoint();
#endif
            // Infinite loop
            while (1)
            {
                ;
            }
        }
        else
        {
            // If startup tests are not enabled via MHC, do nothing.
            ;
        }
    }
    else if (init_status == CLASSB_SST_DONE)
    {
        // Clear flags
        *classb_test_in_progress = CLASSB_TEST_NOT_STARTED;
    }
}
