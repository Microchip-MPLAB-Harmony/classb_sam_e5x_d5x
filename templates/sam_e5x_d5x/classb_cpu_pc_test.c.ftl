/*******************************************************************************
  Class B Library ${REL_VER} Release

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
#include "classb/classb_cpu_reg_test.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Data types
 *----------------------------------------------------------------------------*/

// *****************************************************************************
/* Class B library Program Counter Test input and output values

  Summary:
    Data type for PC Test input and output values.

  Description:
    The PC tests performs logical left-shift of the input value and returns it.
    Values from this enum can be used as arguments.

  Remarks:
    None.
*/
typedef enum classb_pc_test_val
{
    CLASSB_CPU_PC_TEST_ROUTINE_A_INPUT  = 1U,
    CLASSB_CPU_PC_ROUTINE_A_RET_VAL   = 2U,
    CLASSB_CPU_PC_ROUTINE_B_RET_VAL   = 4U,
    CLASSB_CPU_PC_ROUTINE_C_RET_VAL   = 8U,
    CLASSB_CPU_PC_TEST_INIT_VAL = 0U
} CLASSB_CPU_PC_TEST_VALUES;

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/
extern void _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE test_type,
    CLASSB_TEST_ID test_id, CLASSB_TEST_STATUS value);

/*Internal functions for PC test*/
static CLASSB_CPU_PC_TEST_VALUES __attribute__((optimize("-O0"))) _CLASSB_CPU_PCTestRoutineA(CLASSB_CPU_PC_TEST_VALUES);
static CLASSB_CPU_PC_TEST_VALUES __attribute__((optimize("-O0"))) _CLASSB_CPU_PCTestRoutineB(CLASSB_CPU_PC_TEST_VALUES);
static CLASSB_CPU_PC_TEST_VALUES __attribute__((optimize("-O0"))) _CLASSB_CPU_PCTestRoutineC(CLASSB_CPU_PC_TEST_VALUES);

/*============================================================================
static CLASSB_CPU_PC_TEST_VALUES _CLASSB_CPU_PCTestRoutineA(CLASSB_CPU_PC_TEST_VALUES pc_test_data)
------------------------------------------------------------------------------
Purpose: 'Test routine A' for PC self-test.
Input  : Data to be modified and returned.
Output : Modified data.
Notes  : This function is called from 'CLASSB_CPU_PCTest' to check the Program
         Counter (PC) functionality
============================================================================*/
static CLASSB_CPU_PC_TEST_VALUES _CLASSB_CPU_PCTestRoutineA(CLASSB_CPU_PC_TEST_VALUES pc_test_data)
{
    return (pc_test_data << 1);
}

/*============================================================================
static CLASSB_CPU_PC_TEST_VALUES _CLASSB_CPU_PCTestRoutineB(CLASSB_CPU_PC_TEST_VALUES pc_test_data)
------------------------------------------------------------------------------
Purpose: 'Test routine B' for PC self-test.
Input  : Data to be modified and returned.
Output : Modified data.
Notes  : This function is called from 'CLASSB_CPU_PCTest' to check the Program
         Counter (PC) functionality
============================================================================*/
static CLASSB_CPU_PC_TEST_VALUES _CLASSB_CPU_PCTestRoutineB(CLASSB_CPU_PC_TEST_VALUES pc_test_data)
{
    return (pc_test_data << 1);
}

/*============================================================================
static CLASSB_CPU_PC_TEST_VALUES _CLASSB_CPU_PCTestRoutineC(CLASSB_CPU_PC_TEST_VALUES pc_test_data)
------------------------------------------------------------------------------
Purpose: 'Test routine C' for PC self-test.
Input  : Data to be modified and returned.
Output : Modified data.
Notes  : This function is called from 'CLASSB_CPU_PCTest' to check the Program
         Counter (PC) functionality
============================================================================*/
static CLASSB_CPU_PC_TEST_VALUES _CLASSB_CPU_PCTestRoutineC(CLASSB_CPU_PC_TEST_VALUES pc_test_data)
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
    CLASSB_CPU_PC_TEST_VALUES pc_test_retval_a = CLASSB_CPU_PC_TEST_INIT_VAL;
    CLASSB_CPU_PC_TEST_VALUES pc_test_retval_b = CLASSB_CPU_PC_TEST_INIT_VAL;
    CLASSB_CPU_PC_TEST_VALUES pc_test_retval_c = CLASSB_CPU_PC_TEST_INIT_VAL;

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
        
        /* Remain in a while(1) loop if the Program Counter test fails
         * If WDT is configured, this will result in a device reset
         */
        while (1)
        {
            ;
        }
    }

    return pc_test_status;
}
