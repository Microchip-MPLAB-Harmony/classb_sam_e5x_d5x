/*******************************************************************************
  Class B Library Clock test

  Company:
    Microchip Technology Inc.

  File Name:
    classb_clock_test.h

  Summary:
    Header file for Clock self-tests

  Description:
    This file provides function prototypes, macros and datatypes for the
    Clock test.

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

#ifndef CLASSB_CLOCK_TEST_H
#define CLASSB_CLOCK_TEST_H

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
#define CLASSB_CLOCK_MAX_CLOCK_FREQ         120000000U
#define CLASSB_CLOCK_MAX_SYSTICK_VAL        0xFFFFFFU
#define CLASSB_CLOCK_RTC_CLK_FREQ           32768U
#define CLASSB_CLOCK_MAX_TEST_ACCURACY      2U
/* Since no floating point is used for clock test, multiply intermediate
 * values with 128.
 */
#define CLASSB_CLOCK_MUL_FACTOR             128U

/*----------------------------------------------------------------------------
 *     Data types
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/
CLASSB_TEST_STATUS CLASSB_ClockTest(uint32_t cpu_clock_freq,
    uint8_t error_limit,
    uint16_t clock_test_rtc_cycles,
    bool running_context);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END
#endif // CLASSB_CLOCK_TEST_H
