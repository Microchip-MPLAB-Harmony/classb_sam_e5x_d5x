/*******************************************************************************
  Class B Library ${REL_VER} Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_io_pin_test.h

  Summary:
    Header file for I/O pin self-tests

  Description:
    This file provides function prototypes, macros and datatypes for the
    I/O pin test.

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

#ifndef CLASSB_IO_PIN_TEST_H
#define CLASSB_IO_PIN_TEST_H

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

/*----------------------------------------------------------------------------
 *     Data types
 *----------------------------------------------------------------------------*/
// *****************************************************************************
/* PORT index definitions

  Summary:
    PORT index definitions for Class B library I/O pin test

  Description:
    This can be used in the I/O pin test.

  Remarks:
    None.
*/
typedef enum classb_port_index
{
    PORTA = 0,
    PORTB = 1,
    PORTC = 2,
    PORTD = 3
} CLASSB_PORT_INDEX;

// *****************************************************************************
/* PIN definitions

  Summary:
    PIN definitions for Class B library I/O pin test

  Description:
    This can be used in the I/O pin test.

  Remarks:
    None.
*/
typedef enum classb_port_pin
{
    PIN0 = 0,
    PIN1 = 1,
    PIN2 = 2,
    PIN3 = 3,
    PIN4 = 4,
    PIN5 = 5,
    PIN6 = 6,
    PIN7 = 7,
    PIN8 = 8,
    PIN9 = 9,
    PIN10 = 10,
    PIN11 = 11,
    PIN12 = 12,
    PIN13 = 13,
    PIN14 = 14,
    PIN15 = 15,
    PIN16 = 16,
    PIN17 = 17,
    PIN18 = 18,
    PIN19 = 19,
    PIN20 = 20,
    PIN21 = 21,
    PIN22 = 22,
    PIN23 = 23,
    PIN24 = 24,
    PIN25 = 25,
    PIN26 = 26,
    PIN27 = 27,
    PIN28 = 28,
    PIN29 = 29,
    PIN30 = 30,
    PIN31 = 31
} CLASSB_PORT_PIN;

// *****************************************************************************
/* PORT pin state

  Summary:
    PORT pin state

  Description:
    This can be used in the I/O pin test.

  Remarks:
    None.
*/
typedef enum classb_port_pin_state
{
    PORT_PIN_LOW  = 0,
    PORT_PIN_HIGH = 1,
    PORT_PIN_INVALID = 2
} CLASSB_PORT_PIN_STATE;

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/
CLASSB_TEST_STATUS CLASSB_RST_IOTest(CLASSB_PORT_INDEX port, CLASSB_PORT_PIN pin,
    CLASSB_PORT_PIN_STATE state);
void CLASSB_IO_InputSamplingEnable(CLASSB_PORT_INDEX port, CLASSB_PORT_PIN pin);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END
#endif // CLASSB_IO_PIN_TEST_H
