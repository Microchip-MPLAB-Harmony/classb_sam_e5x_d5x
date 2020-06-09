/*******************************************************************************
  Class B Library ${REL_VER} Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_sram_test.h

  Summary:
    Header file for SRAM self-tests

  Description:
    This file provides function prototypes, macros and data types for the SRAM
    tests.

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

#ifndef CLASSB_SRAM_TEST_H
#define CLASSB_SRAM_TEST_H

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

/*----------------------------------------------------------------------------
 *     Include files
 *----------------------------------------------------------------------------*/
#include "classb/classb_common.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/
#define CLASSB_SRAM_TEST_BUFFER_SIZE        (512U) // Do not modify
#define CLASSB_SRAM_APP_AREA_START          (0x${CLASSB_SRAM_APP_START}U) // Do not modify

/*----------------------------------------------------------------------------
 *     Data types
 *----------------------------------------------------------------------------*/
// *****************************************************************************
/* Class B library SRAM test algorithm selection

  Summary:
    Select which of the March algorithms to run.

  Description:
    Select which of the March algorithms to run.

  Remarks:
    None.
*/
typedef enum classb_sram_march_algo
{
    CLASSB_SRAM_MARCH_C       = 0,
    CLASSB_SRAM_MARCH_C_MINUS = 1,
    CLASSB_SRAM_MARCH_B       = 2
} CLASSB_SRAM_MARCH_ALGO;

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/

CLASSB_TEST_STATUS CLASSB_SRAM_MarchTestInit(uint32_t * start_addr,
    uint32_t test_size, CLASSB_SRAM_MARCH_ALGO march_algo, bool running_context);
CLASSB_TEST_STATUS CLASSB_SRAM_MarchTest(uint32_t * start_addr,
    uint32_t test_size, CLASSB_SRAM_MARCH_ALGO march_algo, bool running_context);

/* RAM march algorithms
 * Optimization is set to zero, else the compiler optimizes these function away.
 */
bool __attribute__((optimize("-O0"))) CLASSB_RAMMarchC(uint32_t * start_addr, uint32_t test_size);
bool __attribute__((optimize("-O0"))) CLASSB_RAMMarchCMinus(uint32_t * start_addr, uint32_t test_size);
bool __attribute__((optimize("-O0"))) CLASSB_RAMMarchB(uint32_t * start_addr, uint32_t test_size);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END
#endif // CLASSB_SRAM_TEST_H
