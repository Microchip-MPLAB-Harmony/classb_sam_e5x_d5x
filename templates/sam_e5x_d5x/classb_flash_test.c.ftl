/*******************************************************************************
  Class B Library ${REL_VER} Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_flash_test.c

  Summary:
    Class B Library flash program memory self-test source file

  Description:
    This file provides flash program memory self-test.

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
#include "classb/classb_flash_test.h"

/*----------------------------------------------------------------------------
 *     Constants
 *----------------------------------------------------------------------------*/

/* Functions in this library uses reversed representation of the
 * CRC-32 polynomial 0x04C11DB7
 */
#define CLASSB_FLASH_CRC32_POLYNOMIAL (0x${CLASSB_FLASH_CRC32_POLY}U)

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/
extern void _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE test_type,
    CLASSB_TEST_ID test_id, CLASSB_TEST_STATUS value);

/*============================================================================
uint32_t CLASSB_FlashCRCGenerate(uint32_t start_addr, uint32_t test_size)
------------------------------------------------------------------------------
Purpose: Generate CRC-32 checksum for the given area of the flash memory.
Input  : Start address, size of the area in bytes
Output : Generated checksum.
Notes  : None.
============================================================================*/
uint32_t CLASSB_FlashCRCGenerate(uint32_t start_addr, uint32_t size)
{
    uint32_t   i, value;
    uint32_t   crc32_table[256];
    uint32_t   crc = 0xffffffff;
    uint8_t    data;
    uint8_t    j;

    /* Generate table for CRC-32 calculation */
    for (i = 0; i < 256; i++)
    {
        value = i;

        for (j = 0; j < 8; j++)
        {
            if ((value & 1) == 1)
            {
                value = (value >> 1) ^ CLASSB_FLASH_CRC32_POLYNOMIAL;
            }
            else
            {
                value >>= 1;
            }
        }
        crc32_table[i] = value;
    }

    /* Generate checksum */
    for (i = 0; i < size; i++)
    {
        data = *(uint8_t *) (start_addr + i);
        crc = crc32_table[(crc ^ data) & 0xff] ^ (crc >> 8);
    }

    /*Return the 1's complement */
    return ~crc;
}

/*============================================================================
CLASSB_TEST_STATUS CLASSB_FlashCRCTest(uint32_t * start_addr,
    uint32_t test_size, uint32_t crc_val, bool running_context)
------------------------------------------------------------------------------
Purpose: Perform CRC-32 check on the internal flash memory.
Input  : Start address, size of the tested area, expected checksum
         and context (startup or run-time)
Output : Test status.
Notes  : None.
============================================================================*/
CLASSB_TEST_STATUS CLASSB_FlashCRCTest(uint32_t start_addr,
    uint32_t test_size, uint32_t crc_val, bool running_context)
{
    CLASSB_TEST_STATUS crc_test_status = CLASSB_TEST_NOT_EXECUTED;
    uint32_t calculated_crc = 0;
    uint32_t final_addr_tested = (start_addr + test_size) - 1;

    /* Size must be less than the total flash size
     * Tested address must not exceed the available flash memory address
     */
    if ((test_size <= FLASH_SIZE) && (final_addr_tested < FLASH_SIZE))
    {
        /* Update test status to 'In Progress' */
        if (running_context == true)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_FLASH,
                CLASSB_TEST_INPROGRESS);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_FLASH,
                CLASSB_TEST_INPROGRESS);
        }

        calculated_crc = CLASSB_FlashCRCGenerate(start_addr, test_size);

        if (calculated_crc == crc_val)
        {
            crc_test_status = CLASSB_TEST_PASSED;
        }
        else
        {
            crc_test_status = CLASSB_TEST_FAILED;
        }
    }
    else
    {
        ;
    }

    if (crc_test_status == CLASSB_TEST_PASSED)
    {
        if (running_context == true)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_FLASH,
                CLASSB_TEST_PASSED);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_FLASH,
                CLASSB_TEST_PASSED);
        }
    }
    else if (crc_test_status == CLASSB_TEST_FAILED)
    {
        if (running_context == true)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_FLASH,
                CLASSB_TEST_FAILED);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_FLASH,
                CLASSB_TEST_FAILED);
        }
        /* Remain in a while(1) loop if the Flash CRC test fails
         * If WDT is configured, this will result in a device reset
         */
        while (1)
        {
            ;
        }
    }

    return crc_test_status;
}
