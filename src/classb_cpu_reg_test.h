/*******************************************************************************
  Class B Library CPU test

  Company:
    Microchip Technology Inc.

  File Name:
    classb_cpu_reg_test.h

  Summary:
    Header file for CPU self-tests

  Description:
    This file provides function prototypes, macros and datatypes for the CPU
    register tests.

*******************************************************************************/

/*******************************************************************************
Copyright (c) 2020 released Microchip Technology Inc.  All rights reserved.

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

#ifndef CLASSB_CPU_REGS_H
#define CLASSB_CPU_REGS_H

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

/*----------------------------------------------------------------------------
 *     Include files
 *----------------------------------------------------------------------------*/
#include "classb/src/classb_common.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/
#define CLASSB_CPU_PC_TEST_ROUTINE_A_INPUT     0x01U
#define CLASSB_CPU_PC_ROUTINE_A_RET_VAL        0x02U
#define CLASSB_CPU_PC_ROUTINE_B_RET_VAL        0x04U
#define CLASSB_CPU_PC_ROUTINE_C_RET_VAL        0x08U

/*----------------------------------------------------------------------------
 *     Data types
 *----------------------------------------------------------------------------*/

// *****************************************************************************
/* Class B library CPU register test configuration

  Summary:
    Data type for enabling FPU register test.

  Description:
    The CPU register test covers the processor core registers and FPU registers.
    Testing FPU registers can be optional since it may not be used by every
    appication.

  Remarks:
    None.
*/
    typedef enum classb_fpu_config
    {
        CLASSB_FPU_TEST_DISABLE  = 0,
        CLASSB_FPU_TEST_ENABLE   = 1
    } CLASSB_FPU_CONFIG;

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/

CLASSB_TEST_STATUS CLASSB_CPU_RegistersTest(CLASSB_FPU_CONFIG test_fpu, bool running_context);
CLASSB_TEST_STATUS __attribute__((optimize("-O0"))) CLASSB_CPU_PCTest(bool running_context);

/*Internal functions for PC test*/
uint8_t __attribute__((optimize("-O0"))) _CLASSB_CPU_PCTestRoutineA(uint8_t);
uint8_t __attribute__((optimize("-O0"))) _CLASSB_CPU_PCTestRoutineB(uint8_t);
uint8_t __attribute__((optimize("-O0"))) _CLASSB_CPU_PCTestRoutineC(uint8_t);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END
#endif // CLASSB_CPU_REGS_H
