/*******************************************************************************
  Class B Library ${REL_VER} Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_common.h

  Summary:
    Class B Library

  Description:
    Common type definitions for class b functions

*******************************************************************************/

/*******************************************************************************
Copyright (c) ${REL_YEAR} released Microchip Technology Inc.  All rights reserved.

Microchip licenses to you the right to use, modify, copy and distribute
Software only when embedded on a Microchip microcontroller or digital signal
controller that is integrated into your product or third party product
(pursuant to the sublicense terms in the accompanying license agreement).

You should refer to the license agreement accompanying this Software for
additional information regarding your rights and obligations.

SOFTWARE AND DOCUMENTATION ARE PROVIDED AS IS  WITHOUT  WARRANTY  OF  ANY  KIND,
EITHER EXPRESS  OR  IMPLIED,  INCLUDING  WITHOUT  LIMITATION,  ANY  WARRANTY  OF
MERCHANTABILITY, TITLE, NON-INFRINGEMENT AND FITNESS FOR A  PARTICULAR  PURPOSE.
IN NO EVENT SHALL MICROCHIP OR  ITS  LICENSORS  BE  LIABLE  OR  OBLIGATED  UNDER
CONTRACT, NEGLIGENCE, STRICT LIABILITY, CONTRIBUTION,  BREACH  OF  WARRANTY,  OR
OTHER LEGAL  EQUITABLE  THEORY  ANY  DIRECT  OR  INDIRECT  DAMAGES  OR  EXPENSES
INCLUDING BUT NOT LIMITED TO ANY  INCIDENTAL,  SPECIAL,  INDIRECT,  PUNITIVE  OR
CONSEQUENTIAL DAMAGES, LOST  PROFITS  OR  LOST  DATA,  COST  OF  PROCUREMENT  OF
SUBSTITUTE  GOODS,  TECHNOLOGY,  SERVICES,  OR  ANY  CLAIMS  BY  THIRD   PARTIES
(INCLUDING BUT NOT LIMITED TO ANY DEFENSE  THEREOF),  OR  OTHER  SIMILAR  COSTS.
*******************************************************************************/

#ifndef CLASSB_COMMON_H
#define CLASSB_COMMON_H

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

/*----------------------------------------------------------------------------
 *     Include files
 *----------------------------------------------------------------------------*/
#include <xc.h>
#include <stdbool.h>

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Globals
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Data types
 *----------------------------------------------------------------------------*/
 
// *****************************************************************************
/* Class B library self-test state

  Summary:
    Identifies Class B library test state

  Description:
    This data type is used to update flags which indicates whether a test
    has started or not.

  Remarks:
    None.
*/
typedef enum classb_test_state
{
    CLASSB_TEST_NOT_STARTED = 0,
    CLASSB_TEST_STARTED = 1
} CLASSB_TEST_STATE;

// *****************************************************************************
/* Class B library self-test identifier

  Summary:
    Identifies Class B library tests

  Description:
    This enumeration can be used to read the self-test status and update it.
    Test ID corresponds to the bit position at which the 2-bit test result
    is stored.

  Remarks:
    None.
*/
typedef enum classb_test_id
{
    CLASSB_TEST_CPU         = 0,
    CLASSB_TEST_PC          = 2,
    CLASSB_TEST_RAM         = 4,
    CLASSB_TEST_FLASH       = 6,
    CLASSB_TEST_CLOCK       = 8,
    CLASSB_TEST_INTERRUPT   = 10,
    CLASSB_TEST_IO          = 12,
    CLASSB_TEST_FPU          = 14
} CLASSB_TEST_ID;

// *****************************************************************************
/* Class B library self-test result

  Summary:
    Identifies result from Class B library test

  Description:
    This is return type for self-tests.

  Remarks:
    None.
*/
typedef enum classb_test_status
{
    CLASSB_TEST_NOT_EXECUTED  = 0,
    CLASSB_TEST_PASSED        = 1,
    CLASSB_TEST_FAILED        = 2,
    CLASSB_TEST_INPROGRESS    = 3
} CLASSB_TEST_STATUS;

// *****************************************************************************
/* Class B library initialization status

  Summary:
    Identifies Class B initialization status

  Description:
    This is return type for the function which initializes the Class B
    library during startup. This indicates whether the SSTs are executed or not.

  Remarks:
    None.
*/
typedef enum classb_init_status
{
    CLASSB_SST_DONE = 1,
    CLASSB_SST_NOT_DONE = 2
} CLASSB_INIT_STATUS;

// *****************************************************************************
/* Class B library startup self-tests status

  Summary:
    Identifies startup test status

  Description:
    This is return type for the function which calls all self-tests
    during startup.

  Remarks:
    None.
*/
typedef enum classb_startup_status
{
    CLASSB_STARTUP_TEST_NOT_EXECUTED  = 0,
    CLASSB_STARTUP_TEST_PASSED = 1,
    CLASSB_STARTUP_TEST_FAILED = 2
} CLASSB_STARTUP_STATUS;

// *****************************************************************************
/* Class B library self-test type

  Summary:
    Identifies type of the Class B library test

  Description:
    There are two categories of test. They are startup tests (SSTs) and
    run-time tests (RSTs). Test results for SSTs and RSTs are stored at
    separately in the SRAM.

  Remarks:
    None.
*/
typedef enum classb_test_type
{
    CLASSB_TEST_TYPE_SST  = 0,
    CLASSB_TEST_TYPE_RST  = 1
} CLASSB_TEST_TYPE;

// *****************************************************************************
/* Structure for Class B library self-test result

  Summary:
    Structure for Class B library self-test result

  Description:
    For bit-field representation of Class B library test results.

  Remarks:
    None.
*/
typedef struct classb_sst_result_bf
{
    CLASSB_TEST_STATUS CPU_STATUS:2;
    CLASSB_TEST_STATUS PC_STATUS:2;
    CLASSB_TEST_STATUS RAM_STATUS:2;
    CLASSB_TEST_STATUS FLASH_STATUS:2;
    CLASSB_TEST_STATUS CLOCK_STATUS:2;
    CLASSB_TEST_STATUS INTERRUPT_STATUS:2;
    CLASSB_TEST_STATUS FPU_STATUS:2;
} *CLASSB_SST_RESULT_BF;

// *****************************************************************************
/* Structure for Class B library self-test result

  Summary:
    Structure for Class B library self-test result

  Description:
    For bit-field representation of Class B library test results.

  Remarks:
    None.
*/
typedef struct classb_rst_result_bf
{
    CLASSB_TEST_STATUS CPU_STATUS:2;
    CLASSB_TEST_STATUS PC_STATUS:2;
    CLASSB_TEST_STATUS RAM_STATUS:2;
    CLASSB_TEST_STATUS FLASH_STATUS:2;
    CLASSB_TEST_STATUS CLOCK_STATUS:2;
    CLASSB_TEST_STATUS UNUSED_STATUS:2;
    CLASSB_TEST_STATUS IO_STATUS:2;
    CLASSB_TEST_STATUS FPU_STATUS:2;
} *CLASSB_RST_RESULT_BF;


/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/
/* Function called when a non-critical self-test fails */
void CLASSB_SelfTest_FailSafe(CLASSB_TEST_ID test_id);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END
#endif // CLASSB_COMMON_H
