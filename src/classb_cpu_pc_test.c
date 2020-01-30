/*******************************************************************************
  Class B Library v0.1.0 Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_cpu_pc_test.c

  Summary:
    Class B Library source file for Program Counter test

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
#include "classb/src/classb_cpu_reg_test.h"

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/

/*============================================================================
uint8_t _CLASSB_CPU_PCTestRoutineA(uint8_t pc_test_data)
------------------------------------------------------------------------------
Purpose: 'Test routine A' for PC self-test.
Input  : Data to be modified and returned.
Output : Modified data.
Notes  : This function is called from 'CLASSB_CPU_PCTest' to check the Program
         Counter (PC) functionality
============================================================================*/
uint8_t _CLASSB_CPU_PCTestRoutineA(uint8_t pc_test_data)
{
    return (pc_test_data << 1);
}

/*============================================================================
uint8_t _CLASSB_CPU_PCTestRoutineB(uint8_t pc_test_data)
------------------------------------------------------------------------------
Purpose: 'Test routine B' for PC self-test.
Input  : Data to be modified and returned.
Output : Modified data.
Notes  : This function is called from 'CLASSB_CPU_PCTest' to check the Program
         Counter (PC) functionality
============================================================================*/
uint8_t _CLASSB_CPU_PCTestRoutineB(uint8_t pc_test_data)
{
    return (pc_test_data << 1);
}

/*============================================================================
uint8_t _CLASSB_CPU_PCTestRoutineC(uint8_t pc_test_data)
------------------------------------------------------------------------------
Purpose: 'Test routine C' for PC self-test.
Input  : Data to be modified and returned.
Output : Modified data.
Notes  : This function is called from 'CLASSB_CPU_PCTest' to check the Program
         Counter (PC) functionality
============================================================================*/
uint8_t _CLASSB_CPU_PCTestRoutineC(uint8_t pc_test_data)
{
    return (pc_test_data << 1);
}

/*============================================================================
CLASSB_TEST_STATUS CLASSB_CPU_PCTest(void)
------------------------------------------------------------------------------
Purpose: Self-test function for the Program Counter
Input  : None
Output : Test status
Notes  : None
============================================================================*/
CLASSB_TEST_STATUS CLASSB_CPU_PCTest(bool running_context)
{
    CLASSB_TEST_STATUS pc_test_status = CLASSB_TEST_NOT_EXECUTED;
    uint8_t pc_test_retval_a = 0;
    uint8_t pc_test_retval_b = 0;
    uint8_t pc_test_retval_c = 0;

    if (running_context == true)
    {
        _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_PC,
            CLASSB_TEST_INPROGRESS);
    }
    else
    {
        _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_PC,
            CLASSB_TEST_INPROGRESS);
    }
    /* The test routines left-shift the received data and returns it */
    pc_test_retval_a = _CLASSB_CPU_PCTestRoutineA(CLASSB_CPU_PC_TEST_ROUTINE_A_INPUT);
    pc_test_retval_b = _CLASSB_CPU_PCTestRoutineB(pc_test_retval_a);
    pc_test_retval_c = _CLASSB_CPU_PCTestRoutineC(pc_test_retval_b);

    if ((pc_test_retval_a == CLASSB_CPU_PC_ROUTINE_A_RET_VAL)
        && (pc_test_retval_b == CLASSB_CPU_PC_ROUTINE_B_RET_VAL)
        && (pc_test_retval_c == CLASSB_CPU_PC_ROUTINE_C_RET_VAL))
    {
        pc_test_status = CLASSB_TEST_PASSED;
        if (running_context == true)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_PC,
                CLASSB_TEST_PASSED);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_PC,
                CLASSB_TEST_PASSED);
        }
    }
    else
    {
        pc_test_status = CLASSB_TEST_FAILED;
        if (running_context == true)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_PC,
                CLASSB_TEST_FAILED);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_PC,
                CLASSB_TEST_FAILED);
        }
    }

    return pc_test_status;
}
