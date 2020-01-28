/*******************************************************************************
  Class B Library ${REL_VER} Release

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
#include "classb/src/classb.h"

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/
__attribute__((persistent)) volatile uint8_t * ongoing_sst_id; 
__attribute__((persistent)) volatile uint8_t * classb_test_in_progress;
__attribute__((persistent)) volatile uint8_t * wdt_test_in_progress;
__attribute__((persistent)) volatile uint16_t * interrupt_tests_status;

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
    ongoing_sst_id = (volatile uint8_t *)CLASSB_ONGOING_TEST_VAR_ADDR; 
    classb_test_in_progress = (volatile uint8_t *)CLASSB_TEST_IN_PROG_VAR_ADDR;
    wdt_test_in_progress = (volatile uint8_t *)CLASSB_WDT_TEST_IN_PROG_VAR_ADDR;
    interrupt_tests_status = (volatile uint16_t *)CLASSB_INTERRUPT_TEST_VAR_ADDR;

    ongoing_sst_id[0] = 0xff;
    classb_test_in_progress[0] = 0;
    wdt_test_in_progress[0] = 0;
    interrupt_tests_status[0] = 0;
    interrupt_tests_status[1] = 0;
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
    PORT_REGS->GROUP[2].PORT_DIRSET = (1 << 18);
    PORT_REGS->GROUP[2].PORT_OUTCLR = (1 << 18);
    // Infinite loop
    while (1) {}
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
    int i = 0x7ffff;
    PORT_REGS->GROUP[2].PORT_DIRSET = (1 << 18);
    PORT_REGS->GROUP[2].PORT_OUTCLR = (1 << 18);
    // Infinite loop
    while (1) {
        while(i--);
        i = 0x7ffff;
        PORT_REGS->GROUP[2].PORT_OUTTGL = (1 << 18);
    }
}

/*============================================================================
void CLASSB_SelfTest_FailSafe(CLASSB_TEST_ID cb_test_id)
------------------------------------------------------------------------------
Purpose: Called if a non-critical self-test is failed.
Input  : None
Output : None
Notes  : The application decides the contents of this function.
============================================================================*/
void CLASSB_SelfTest_FailSafe(CLASSB_TEST_ID cb_test_id)
{
#if (defined(__DEBUG) || defined(__DEBUG_D)) && defined(__XC32)
    __builtin_software_breakpoint();
#endif
    int i = 0x7fffff;
    PORT_REGS->GROUP[2].PORT_DIRSET = (1 << 18);
    PORT_REGS->GROUP[2].PORT_OUTCLR = (1 << 18);
    // Infinite loop
    while (1) {
        while(i--);
        i = 0x7fffff;
        PORT_REGS->GROUP[2].PORT_OUTTGL = (1 << 18);
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
    wdt_test_in_progress[0] = 1;
    
    /* If WDT ALWAYSON is set, wait till WDT resets the device */
    if (WDT_REGS->WDT_CTRLA & WDT_CTRLA_ALWAYSON_Msk)
    {
        // Infinite loop
        while (1) {}
    }
    else
    {
        // If WDT is not enabled, enable WDT and wait
        if (!(WDT_REGS->WDT_CTRLA & WDT_CTRLA_ENABLE_Msk))
        {
            // Configure timeout
            WDT_REGS->WDT_CONFIG = WDT_CONFIG_PER_CYC2048;
            WDT_REGS->WDT_CTRLA |= WDT_CTRLA_ENABLE_Msk;
            // Infinite loop
            while (1) {}
        }
        else
        {
            // Infinite loop
            while (1) {}
        }
    }
}

/*============================================================================
void CLASSB_Init(void)
------------------------------------------------------------------------------
Purpose: To check reset cause and decide the startup flow.
Input  : None
Output : None
Notes  : This function is executed on every device reset 
============================================================================*/

CLASSB_INIT_STATUS CLASSB_Init(void)
{
    CLASSB_INIT_STATUS ret_val = CLASSB_SST_NOT_DONE;
    
    if ((RSTC_REGS->RSTC_RCAUSE & RSTC_RCAUSE_WDT_Msk))
    {
        if (1 == wdt_test_in_progress[0])
        {
            wdt_test_in_progress[0] = 0;
        }
        else if (CLASSB_TEST_IN_PROG_PATTERN == classb_test_in_progress[0])
        {
            CLASSB_SST_WDT_Recovery();
        }
        else
        {
            CLASSB_App_WDT_Recovery();
        }
    }
    else if ((RSTC_REGS->RSTC_RCAUSE & RSTC_RCAUSE_SYST_Msk))
    {
        if (CLASSB_TEST_IN_PROG_PATTERN == classb_test_in_progress[0])
        {
            classb_test_in_progress[0] = 0;
            ret_val = CLASSB_SST_DONE;
        }
        else
        {
            bool result_area_test_ok = false;
            bool ram_buffer_test_ok = false;
            // Test the reserved SRAM
            result_area_test_ok = _CLASSB_RAMMarchC((uint32_t *)CLASSB_SRAM_START_ADDRESS,
                CLASSB_SRAM_TEST_BUFFER_SIZE);
            ram_buffer_test_ok = _CLASSB_RAMMarchC((uint32_t *)CLASSB_SRAM_BUFF_START_ADDRESS,
                CLASSB_SRAM_TEST_BUFFER_SIZE);
            if ((true == result_area_test_ok) && (true == ram_buffer_test_ok))
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

                }
            }
        }
    }
    else
    {
        bool result_area_test_ok = false;
        bool ram_buffer_test_ok = false;
        // Test the reserved SRAM
        result_area_test_ok = _CLASSB_RAMMarchC((uint32_t *)CLASSB_SRAM_START_ADDRESS,
            CLASSB_SRAM_TEST_BUFFER_SIZE);
        ram_buffer_test_ok = _CLASSB_RAMMarchC((uint32_t *)CLASSB_SRAM_BUFF_START_ADDRESS,
            CLASSB_SRAM_TEST_BUFFER_SIZE);
        if ((true == result_area_test_ok) && (true == ram_buffer_test_ok))
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
Notes  : None 
============================================================================*/
CLASSB_STARTUP_STATUS CLASSB_Startup_Tests(void)
{
    CLASSB_STARTUP_STATUS cb_startup_status = CLASSB_STARTUP_TEST_FAILED;
    CLASSB_STARTUP_STATUS cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    CLASSB_TEST_STATUS cb_test_status = CLASSB_TEST_NOT_EXECUTED;
    <#if CLASSB_CLOCK_TEST_OPT??>
        <#if CLASSB_CLOCK_TEST_OPT == true>
            <#if CLASSB_CLOCK_TEST_DURATION?has_content>
            <#lt>    uint16_t clock_test_rtc_cycles = ((${CLASSB_CLOCK_TEST_DURATION} * CLASSB_CLOCK_TEST_RATIO_NS_MS) / CLASSB_CLOCK_TEST_RTC_RATIO_NS);
            </#if>
        </#if>
    </#if>
    
    <#if CLASSB_FPU_OPT??>
        <#if CLASSB_FPU_OPT == true>
            <#lt>    // Enable FPU
            <#lt>    SCB->CPACR |= (0xFu << 20);
            <#lt>    __DSB();
            <#lt>    __ISB();
            <#lt>    // Test processor core registers and FPU registers
            <#lt>    cb_test_status = CLASSB_CPU_RegistersTest(CLASSB_FPU_TEST_ENABLE, false);
        <#else>
            <#lt>    // Test processor core registers
            <#lt>    cb_test_status = CLASSB_CPU_RegistersTest(CLASSB_FPU_TEST_DISABLE, false);
        </#if>
    </#if>
    
    if (CLASSB_TEST_PASSED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else if (CLASSB_TEST_FAILED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }

    // Program Counter test
    cb_test_status = CLASSB_CPU_PCTest(false);
    
    if (CLASSB_TEST_PASSED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else if (CLASSB_TEST_FAILED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }
    
    // SRAM test
    <#if CLASSB_SRAM_MARCH_ALGORITHM?has_content>
    cb_test_status = CLASSB_SRAM_MarchTestInit((uint32_t *)CLASSB_SRAM_RESERVE_AREA_END,
        CLASSB_SRAM_STARTUP_TEST_SIZE, ${CLASSB_SRAM_MARCH_ALGORITHM}, false);
    <#else>
    cb_test_status = CLASSB_SRAM_MarchTestInit((uint32_t *)CLASSB_SRAM_RESERVE_AREA_END,
        CLASSB_SRAM_STARTUP_TEST_SIZE, CLASSB_SRAM_MARCH_C, false);
    </#if>
    if (CLASSB_TEST_PASSED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else if (CLASSB_TEST_FAILED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }
    
    // Kick WDT
    WDT_REGS->WDT_CLEAR = WDT_CLEAR_CLEAR_KEY;
    
    <#if CLASSB_FLASH_CRC_CONF?has_content>
        <#if CLASSB_FLASH_CRC_CONF == true>
    // Flash test. Read CRC-32 and verify it
    cb_test_status = CLASSB_FlashCRCTest(0, (CLASSB_FLASH_CRC32_ADDR - 1),
        *(uint32_t *)CLASSB_FLASH_CRC32_ADDR, false);
    if (CLASSB_TEST_PASSED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
    }
    else if (CLASSB_TEST_FAILED == cb_test_status)
    {
        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
    }
        </#if>
    </#if>
    
    <#if CLASSB_INTERRUPT_TEST_OPT??>
        <#if CLASSB_INTERRUPT_TEST_OPT == true>
            <#lt>    cb_test_status = CLASSB_SST_InterruptTest();
            <#lt>    if (CLASSB_TEST_PASSED == cb_test_status)
            <#lt>    {
            <#lt>        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
            <#lt>    }
            <#lt>    else if (CLASSB_TEST_FAILED == cb_test_status)
            <#lt>    {
            <#lt>        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
            <#lt>    }
        </#if>
    </#if>
    
    <#if CLASSB_CLOCK_TEST_OPT??>
        <#if CLASSB_CLOCK_TEST_OPT == true>
            <#if CLASSB_CLOCK_TEST_PERCENT?has_content && CLASSB_CLOCK_TEST_DURATION?has_content>
                <#lt>    cb_test_status = CLASSB_ClockTest(CLASSB_CLOCK_DEFAULT_CLOCK_FREQ, ${CLASSB_CLOCK_TEST_PERCENT}, clock_test_rtc_cycles, false);
            <#else>
                <#lt>    cb_test_status = CLASSB_ClockTest(CLASSB_CLOCK_DEFAULT_CLOCK_FREQ, CLASSB_CLOCK_ERROR_PERCENT, CLASSB_CLOCK_TEST_RTC_CYCLES, false);
            </#if>
            <#lt>    if (CLASSB_TEST_PASSED == cb_test_status)
            <#lt>    {
            <#lt>        cb_temp_startup_status = CLASSB_STARTUP_TEST_PASSED;
            <#lt>    }
            <#lt>    else if (CLASSB_TEST_FAILED == cb_test_status)
            <#lt>    {
            <#lt>        cb_temp_startup_status = CLASSB_STARTUP_TEST_FAILED;
            <#lt>    }
        </#if>
    </#if>
    
    // TBD
    // Add all SSTs here
    if (CLASSB_STARTUP_TEST_PASSED == cb_temp_startup_status)
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
    CLASSB_INIT_STATUS init_status = CLASSB_Init();
    CLASSB_STARTUP_STATUS startup_tests_status = CLASSB_STARTUP_TEST_FAILED;
    
    if (CLASSB_SST_NOT_DONE == init_status)
    {
        classb_test_in_progress[0] = CLASSB_TEST_IN_PROG_PATTERN;
        startup_tests_status = CLASSB_Startup_Tests();
        if (CLASSB_STARTUP_TEST_PASSED == startup_tests_status)
        {
            NVIC_SystemReset();
        }
        else
        {
#if (defined(__DEBUG) || defined(__DEBUG_D)) && defined(__XC32)
        __builtin_software_breakpoint();
#endif
        // Infinite loop
        while (1) {}
        }
    }
    else if (CLASSB_SST_DONE == init_status)
    {
        // Clear flags
        classb_test_in_progress[0] = 0;
    }
}
