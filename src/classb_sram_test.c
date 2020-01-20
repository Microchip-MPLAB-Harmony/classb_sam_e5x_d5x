/*******************************************************************************
  Class B Library v0.1.0 Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_sram_test.c

  Summary:
    Class B Library source file for the SRAM test

  Description:
    This file provides self-test functions for the SRAM.

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
#include "classb/src/classb_sram_test.h"

/*----------------------------------------------------------------------------
 *     Global Variables
 *----------------------------------------------------------------------------*/
extern uint32_t _heap;
extern uint32_t _min_heap_size;
extern uint32_t _stack;
/*----------------------------------------------------------------------------
 *     Functions
 *----------------------------------------------------------------------------*/

/*============================================================================
uint32_t _CLASSB_GetStackPointer(void)
------------------------------------------------------------------------------
Purpose: Get the address stored in the Stack Pointer.
Input  : None
Output : Address stored in the Stack Pointer register.
Notes  : This function is used by SRAM tests.
============================================================================*/
uint32_t _CLASSB_GetStackPointer(void)
{
    uint32_t result;

     __asm__ volatile ("MRS %0, msp\n" : "=r" (result));

    return(result);
}

/*============================================================================
void _CLASSB_SetStackPointer(uint32_t new_stack_address)
------------------------------------------------------------------------------
Purpose: Store a new address into the Stack Pointer.
Input  : New address for the Stack.
Output : None
Notes  : This function is used by SRAM tests.
============================================================================*/
void _CLASSB_SetStackPointer(uint32_t new_stack_address)
{
    __asm__ volatile ("MSR msp, %0\n" : : "r" (new_stack_address));
}

/*============================================================================
void _CLASSB_MemCopy(uint32_t* dest, uint32_t* src, uint32_t size_in_bytes)
------------------------------------------------------------------------------
Purpose: Copies given number of bytes, from one SRAM area to the other.
Input  : Destination address, source address and size
Output : None
Notes  : This function is used by SRAM tests.
============================================================================*/
void _CLASSB_MemCopy(uint32_t* dest, uint32_t* src, uint32_t size_in_bytes)
{
    uint32_t i = 0;
    uint32_t size_in_words = size_in_bytes / 4;
    
    for (i = 0; i < size_in_words; i++)
    {
        dest[i] = src[i];
    }
}

/*============================================================================
bool _CLASSB_RAMMarchC(uint32_t * start_addr, uint32_t test_size_bytes)
------------------------------------------------------------------------------
Purpose: Runs March C algorithm on the given SRAM area
Input  : Start address and size
Output : Success or failure
Notes  : This function is used by SRAM tests. It performs the following,
        // March C
        // Low to high, write zero
        // Low to high, read zero write one
        // Low to high, read one write zero
        // Low to high, read zero

        // High to low, read zero write one
        // High to low, read one write zero
        // High to low, read zero
============================================================================*/
bool _CLASSB_RAMMarchC(uint32_t * start_addr, uint32_t test_size_bytes)
{
    bool sram_march_c_result = true;
    int32_t i = 0;
    uint32_t sram_read_val = 0;
    uint32_t test_size_words = (test_size_bytes / 4);
    
    // Test area is limited to CLASSB_SRAM_TEST_BUFFER_SIZE
    if (test_size_bytes > CLASSB_SRAM_TEST_BUFFER_SIZE)
    {
        sram_march_c_result = false;
    }
    
    // Perform the next check only if the previous stage is passed
    if (true == sram_march_c_result)
    {
        // Low to high, write zero
        for (i = 0; i < test_size_words; i++)
        {
            start_addr[i] = 0;
        }
        // Low to high, read zero write one
        for (i = 0; i < test_size_words; i++)
        {
            sram_read_val = start_addr[i];
            if (0 == sram_read_val)
            {
                start_addr[i]  = 0xFFFFFFFF;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        }
    }
    if (true == sram_march_c_result)
    {
        // Low to high, read one write zero
        for (i = 0; i < test_size_words; i++)
        {
            sram_read_val = start_addr[i];
            if (0xFFFFFFFF == sram_read_val)
            {
                start_addr[i]  = 0;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // Low to high, read zero
        for (i = 0; i < test_size_words; i++)
        {
            sram_read_val = start_addr[i];
            if (0 != sram_read_val)
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // High to low, read zero, write one
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0 == sram_read_val)
            {
                start_addr[i]  = 0xFFFFFFFF;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // High to low, read one, write zero
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0xFFFFFFFF == sram_read_val)
            {
                start_addr[i]  = 0;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // High to low, read zero
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0 != sram_read_val)
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    return sram_march_c_result;
}

/*============================================================================
bool _CLASSB_RAMMarchCMinus(uint32_t * start_addr, uint32_t test_size_bytes)
------------------------------------------------------------------------------
Purpose: Runs March C algorithm on the given SRAM area
Input  : Start address and size
Output : Success or failure
Notes  : This function is used by SRAM tests. It performs the following,
        // March C minus
        // Low to high, write zero
        // Low to high, read zero write one
        // Low to high, read one write zero

        // High to low, read zero write one
        // High to low, read one write zero
        // High to low, read zero
============================================================================*/
bool _CLASSB_RAMMarchCMinus(uint32_t * start_addr, uint32_t test_size_bytes)
{
    bool sram_march_c_result = true;
    int32_t i = 0;
    uint32_t sram_read_val = 0;
    uint32_t test_size_words = (test_size_bytes / 4);
    
    // Test area is limited to CLASSB_SRAM_TEST_BUFFER_SIZE
    if (test_size_bytes > CLASSB_SRAM_TEST_BUFFER_SIZE)
    {
        sram_march_c_result = false;
    }
    
    // Perform the next check only if the previous stage is passed
    if (true == sram_march_c_result)
    {
        // Low to high, write zero
        for (i = 0; i < test_size_words; i++)
        {
            start_addr[i] = 0;
        }
        // Low to high, read zero write one
        for (i = 0; i < test_size_words; i++)
        {
            sram_read_val = start_addr[i];
            if (0 == sram_read_val)
            {
                start_addr[i]  = 0xFFFFFFFF;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        }
    }
    if (true == sram_march_c_result)
    {
        // Low to high, read one write zero
        for (i = 0; i < test_size_words; i++)
        {
            sram_read_val = start_addr[i];
            if (0xFFFFFFFF == sram_read_val)
            {
                start_addr[i]  = 0;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // High to low, read zero, write one
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0 == sram_read_val)
            {
                start_addr[i]  = 0xFFFFFFFF;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // High to low, read one, write zero
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0xFFFFFFFF == sram_read_val)
            {
                start_addr[i]  = 0;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // High to low, read zero
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0 != sram_read_val)
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    return sram_march_c_result;
}

/*============================================================================
bool _CLASSB_RAMMarchB(uint32_t * start_addr, uint32_t test_size_bytes)
------------------------------------------------------------------------------
Purpose: Runs March C algorithm on the given SRAM area
Input  : Start address and size
Output : Success or failure
Notes  : This function is used by SRAM tests. It performs the following,
        // March B
        // Low to high, write zero
        // Low to high, read zero write one, read one write zero,
               read zero write one
        // Low to high, read one write zero, write one

        // High to low, read one write zero, write one write zero
        // High to low, read zero write one, write zero
============================================================================*/
bool _CLASSB_RAMMarchB(uint32_t * start_addr, uint32_t test_size_bytes)
{
    bool sram_march_c_result = true;
    int32_t i = 0;
    uint32_t sram_read_val = 0;
    uint32_t test_size_words = (test_size_bytes / 4);
    
    // Test area is limited to CLASSB_SRAM_TEST_BUFFER_SIZE
    if (test_size_bytes > CLASSB_SRAM_TEST_BUFFER_SIZE)
    {
        sram_march_c_result = false;
    }
    
    // Perform the next check only if the previous stage is passed
    if (true == sram_march_c_result)
    {
        // Low to high, write zero
        for (i = 0; i < test_size_words; i++)
        {
            start_addr[i] = 0;
        }
        // Low to high
        for (i = 0; i < test_size_words; i++)
        {
            // Read zero write one
            sram_read_val = start_addr[i];
            if (0 == sram_read_val)
            {
                start_addr[i]  = 0xFFFFFFFF;
                // Read one write zero
                sram_read_val = start_addr[i];
                if (0xFFFFFFFF == sram_read_val)
                {
                    start_addr[i]  = 0;
                    // Read zero write one
                    sram_read_val = start_addr[i];
                    if (0 == sram_read_val)
                    {
                        start_addr[i] = 0xFFFFFFFF;
                    }
                    else
                    {
                        sram_march_c_result = false;
                        break;
                    }
                }
                else
                {
                    sram_march_c_result = false;
                    break;
                }
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        }
    }
    
    if (true == sram_march_c_result)
    {
        // Low to high
        for (i = 0; i < test_size_words; i++)
        {
            // Read one write zero
            sram_read_val = start_addr[i];
            if (0xFFFFFFFF == sram_read_val)
            {
                start_addr[i]  = 0;
                // Write one
                start_addr[i] = 0xFFFFFFFF;
             }
            else
            {
                sram_march_c_result = false;
                break;
            }
        }
    }
    
    // High to low tests
    if (true == sram_march_c_result)
    {
        // High to low, read one, write zero
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0xFFFFFFFF == sram_read_val)
            {
                start_addr[i]  = 0;
                // Write one
                start_addr[i] = 0xFFFFFFFF;
                // Write zero
                start_addr[i] = 0;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    if (true == sram_march_c_result)
    {
        // High to low, read zero, write one
        for (i = (test_size_words - 1); i >= 0 ; i--)
        {
            sram_read_val = start_addr[i];
            if (0 == sram_read_val)
            {
                start_addr[i]  = 0xFFFFFFFF;
                // Write zero
                start_addr[i] = 0;
            }
            else
            {
                sram_march_c_result = false;
                break;
            }
        } 
    }
    
    return sram_march_c_result;
}

/*============================================================================
CLASSB_TEST_STATUS CLASSB_SRAM_MarchTestInit(uint32_t * start_addr,
    uint32_t test_size_bytes, CLASSB_SRAM_MARCH_ALGO march_algo,
    bool running_context)
------------------------------------------------------------------------------
Purpose: Initialize to perform March-tests on SRAM.
Input  : Start address, size of SRAM area to be tested, 
         selected algorithm and the context (startup or run-time)
Output : Test status.
Notes  : None.
============================================================================*/
CLASSB_TEST_STATUS CLASSB_SRAM_MarchTestInit(uint32_t * start_addr,
    uint32_t test_size_bytes, CLASSB_SRAM_MARCH_ALGO march_algo,
    bool running_context)
{
    /* This function uses register variables since the Stack also
     * need to be tested
     */
    // Find the last word address in the tested area
    register uint32_t march_test_end_address asm("r4") = (uint32_t)start_addr +
        test_size_bytes - 4;
    // Use a local variable for calculations
    register uint32_t mem_start_address  asm("r5") = (uint32_t)start_addr;
    // 'start_addr' and 'test_size_bytes' must be multiple of four
    
    register uint32_t stack_address asm("r6") = 0;
    register CLASSB_TEST_STATUS sram_init_retval asm("r7") =
        CLASSB_TEST_NOT_EXECUTED;
    
    /* The address and test size must be a multiple of 4
     * The tested area should be above the reserved SRAM for Class B library
     * Address should be within the last SRAM word address.
     */
    
    if ((0 != ((uint32_t)start_addr % 4))
            || (0 != (test_size_bytes % 4))
            || (march_test_end_address > CLASSB_SRAM_FINAL_WORD_ADDRESS)
            || (mem_start_address < CLASSB_SRAM_RESERVE_AREA_END))
    {
        ;
    }
    else
    {
        // Move stack pointer to the reserved area before any SRAM test
        stack_address = _CLASSB_GetStackPointer();
        _CLASSB_SetStackPointer(CLASSB_SRAM_TEMP_STACK_ADDRESS);
        if (running_context)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_RAM,
                CLASSB_TEST_INPROGRESS); 
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_RAM,
                CLASSB_TEST_INPROGRESS); 
        }
        sram_init_retval = CLASSB_SRAM_MarchTest(start_addr, test_size_bytes,
            march_algo, running_context);
        _CLASSB_SetStackPointer(stack_address);
    }
      
    return sram_init_retval;
}        

CLASSB_TEST_STATUS CLASSB_SRAM_MarchTest(uint32_t * start_addr,
    uint32_t test_size_bytes, CLASSB_SRAM_MARCH_ALGO march_algo,
    bool running_context)
{
    CLASSB_TEST_STATUS classb_sram_status = CLASSB_TEST_NOT_EXECUTED;
    bool march_test_retval = false;
    // Find the last word address in the tested area
    uint32_t march_test_end_address = (uint32_t)start_addr + test_size_bytes - 4;
    // Identify the memory area used by the application
    uint32_t app_used_sram_area = (uint32_t)&_heap + (uint32_t)&_min_heap_size;
    // Use a local variable for calculations
    uint32_t mem_start_address = (uint32_t)start_addr;
    // Test will be done on blocks on 512 bytes
    volatile uint32_t march_c_iterations = (test_size_bytes / CLASSB_SRAM_TEST_BUFFER_SIZE);
    // If the size is not a multiple of 512, then check the remaining area
    volatile uint32_t march_c_short_itr = (test_size_bytes % CLASSB_SRAM_TEST_BUFFER_SIZE);
    // Variable for loops
    int i = 0;
    
    /* Get SP address and decrement a few bytes
     * for local variables used by the following code
     */
   
    uint32_t stack_address = _CLASSB_GetStackPointer() - CLASSB_STACK_GUARD_BYTES;
    
    if ((mem_start_address < app_used_sram_area) || (march_test_end_address > stack_address))
    {
        for (i = 0; i < march_c_iterations; i++)
        {
            // Copy the tested area
            _CLASSB_MemCopy((uint32_t *)CLASSB_SRAM_BUFF_START_ADDRESS,
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE);
            // Run the selected RAM March algorithm
            if (CLASSB_SRAM_MARCH_C == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchC(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_C_MINUS == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchCMinus(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_B == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchB(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            if (false == march_test_retval)
            {
                // If March test fails, exit the loop
                classb_sram_status = CLASSB_TEST_FAILED;
                break;
            }
            else
            {
            // Restore the tested area
            _CLASSB_MemCopy(
                (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                (uint32_t *)CLASSB_SRAM_BUFF_START_ADDRESS,
                CLASSB_SRAM_TEST_BUFFER_SIZE);
            }
            classb_sram_status = CLASSB_TEST_PASSED;
        }

        // If the tested area is not a multiple of 512 bytes
        if (march_c_short_itr > 0)
        {
            _CLASSB_MemCopy(
                (uint32_t *)CLASSB_SRAM_BUFF_START_ADDRESS,
                (uint32_t *)(mem_start_address +
                (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                march_c_short_itr);
            // Run the selected RAM March algorithm
            if (CLASSB_SRAM_MARCH_C == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchC(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_C_MINUS == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchCMinus(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_B == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchB(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            if (false == march_test_retval)
            {
                classb_sram_status = CLASSB_TEST_FAILED;
            }
            else
            {
                classb_sram_status = CLASSB_TEST_PASSED;
                // Restore the tested area
                _CLASSB_MemCopy(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    (uint32_t *)CLASSB_SRAM_BUFF_START_ADDRESS, march_c_short_itr);
            }

        }

    }
 
    else
    {
        // If the tested area is not used by the application, run destructive test
        for (i = 0; i < (test_size_bytes / CLASSB_SRAM_TEST_BUFFER_SIZE); i++)
        {
            // Run the selected RAM March algorithm
            if (CLASSB_SRAM_MARCH_C == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchC(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_C_MINUS == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchCMinus(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_B == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchB(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            if (false == march_test_retval)
            {
                classb_sram_status = CLASSB_TEST_FAILED;
                break;
            }
            classb_sram_status = CLASSB_TEST_PASSED;
        }
        // If the tested area is not a multiple of 512 bytes
        if (march_c_short_itr > 0)
        {
            // Run the selected RAM March algorithm
            if (CLASSB_SRAM_MARCH_C == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchC(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_C_MINUS == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchCMinus(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            else if (CLASSB_SRAM_MARCH_B == march_algo)
            {
                march_test_retval = _CLASSB_RAMMarchB(
                    (uint32_t *)(mem_start_address + (i * CLASSB_SRAM_TEST_BUFFER_SIZE)),
                    CLASSB_SRAM_TEST_BUFFER_SIZE); 
            }
            if (false == march_test_retval)
            {
                classb_sram_status = CLASSB_TEST_FAILED;
            }
            else
            {
                classb_sram_status = CLASSB_TEST_PASSED;
            }
        }
    }

    if (CLASSB_TEST_PASSED == classb_sram_status)
    {
        if (true == running_context)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_RAM,
                CLASSB_TEST_PASSED);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_RAM,
                CLASSB_TEST_PASSED);
        }
    }
    else if (CLASSB_TEST_FAILED == classb_sram_status)
    {
        if (true == running_context)
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_RST, CLASSB_TEST_RAM,
                CLASSB_TEST_FAILED);
        }
        else
        {
            _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_RAM,
                CLASSB_TEST_FAILED);
        }
        CLASSB_SelfTest_FailSafe(CLASSB_TEST_RAM);
    }
    
    return classb_sram_status;
}
