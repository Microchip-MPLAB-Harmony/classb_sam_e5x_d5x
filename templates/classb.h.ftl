/*******************************************************************************
  Class B Library ${REL_VER} Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb.h

  Summary:
    Class B Library main header file

  Description:
    This file provides function prototypes, macros and datatypes for the
    Class B library

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

#ifndef CLASSB_H
#define CLASSB_H

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

/*----------------------------------------------------------------------------
 *     Include files
 *----------------------------------------------------------------------------*/
#include "classb/src/classb_common.h"
#include "classb/src/classb_cpu_reg_test.h"
#include "classb/src/classb_sram_test.h"
#include "classb/src/classb_flash_test.h"
#include "classb/src/classb_interrupt_test.h"
#include "classb/src/classb_clock_test.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/
#define CLASSB_RESULT_ADDR                  0x20000000
#define CLASSB_COMPL_RESULT_ADDR            0x20000004
#define CLASSB_ONGOING_TEST_VAR_ADDR        0x20000008
#define CLASSB_TEST_IN_PROG_VAR_ADDR        0x2000000c
#define CLASSB_WDT_TEST_IN_PROG_VAR_ADDR    0x20000010
#define CLASSB_TEST_IN_PROG_PATTERN         0xCB
#define CLASSB_FLASH_TEST_VAR_ADDR          0x20000014
#define CLASSB_FLASH_CRC32_ADDR             ${CLASSB_FLASHCRC_ADDR}
#define CLASSB_SRAM_STARTUP_TEST_SIZE       (HSRAM_SIZE - CLASSB_SRAM_RESERVE_AREA_SIZE)
#define CLASSB_INTERRUPT_TEST_VAR_ADDR      0x20000018
#define CLASSB_CLOCK_DEFAULT_CLOCK_FREQ     48000000
#define CLASSB_CLOCK_ERROR_PERCENT          5
#define CLASSB_CLOCK_TEST_RTC_CYCLES        200
// RTC is clocked from 32687 Hz Crystal. One RTC cycle is 30520 nano sec
#define CLASSB_CLOCK_TEST_RTC_RATIO_NS      30520
#define CLASSB_CLOCK_TEST_RATIO_NS_MS       1000000

/*----------------------------------------------------------------------------
 *     Data types
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/
void CLASSB_ClearTestResults(CLASSB_TEST_TYPE test_type);
CLASSB_TEST_STATUS CLASSB_GetTestResult(CLASSB_TEST_TYPE test_type,
    CLASSB_TEST_ID test_id);

// Functions called after WDT reset
void CLASSB_SST_WDT_Recovery(void);
void CLASSB_App_WDT_Recovery(void);

// Function to be called if a non-critical self-test is failed.
void CLASSB_SelfTest_FailSafe(CLASSB_TEST_ID cb_test_id);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END
#endif // CLASSB_H
