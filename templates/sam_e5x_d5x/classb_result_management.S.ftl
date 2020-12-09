/*******************************************************************************
  Class B Library ${REL_VER} Release

  Company:
    Microchip Technology Inc.

  File Name:
    classb_result_management.S

  Summary:
    Assembly functions to clear, modify and read test results.

  Description:
    This file provides assembly functions to clear, modify and read self-test
    results.

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

; /* CLASSB_TEST_STATUS CLASSB_GetTestResult(CLASSB_TEST_TYPE test_type,
;       CLASSB_TEST_ID test_id) */
.global CLASSB_GetTestResult

; /* void CLASSB_ClearTestResults(CLASSB_TEST_TYPE test_type) */
.global CLASSB_ClearTestResults

; /* void _CLASSB_UpdateTestResult(CLASSB_TEST_TYPE test_type,
;       CLASSB_TEST_ID test_id, CLASSB_TEST_STATUS value) */
.global _CLASSB_UpdateTestResult

; /* SRAM address for SST results */
.equ SST_RES_ADDRESS, 0x20000000
; /* SRAM address for RST results */
.equ RST_RES_ADDRESS, 0x20000002
; /* Result mask is 0x03 (2-bit results) */
.equ RESULT_BIT_MASK, 0x03
; /* CLASSB_TEST_STATUS */
.equ CLASSB_TEST_NOT_EXECUTED, 0x0

; /* Load to clear*/
.equ REG_CLEAR_VAL, 0x00000000

CLASSB_GetTestResult:
; /* Input arguments are test_type and test_id */
; /* test_type in r0, test_id in r1 */
    ; /* push used registers */
    push    {r4-r7}
    ldr     r4, =SST_RES_ADDRESS
    cbz     r0, GetResTestTypeSST
    ldr     r4, =RST_RES_ADDRESS
GetResTestTypeSST:
    ldr	    r6, =RESULT_BIT_MASK
    ; /* Load test result into r5 */
    ldrh    r5, [r4]
    ; /* Extract the test result and return via r0 */
    mov	    r0, r5
    ror	    r0, r0, r1
    and	    r0, r0, r6
    ; /* Load 1s complement result into r7 */
    ldrh    r7, [r4, #4]
    ; /* Check whether the read results are 1s complements */
    eor	    r5, r7, r5
    asr	    r5, r1
    and	    r5, r5, r6
    cmp	    r5, #3
    beq	    TestResultValid
    ; /* Result mismatch. Return CLASSB_TEST_NOT_EXECUTED */
    ldr	    r0, =CLASSB_TEST_NOT_EXECUTED
TestResultValid:
    pop     {r4-r7}
    bx	    r14

_CLASSB_UpdateTestResult:
; /* Input arguments are test_type, test_id and value */
; /* test_type in r0, test_id in r1, value in r2 */
    ; /* push used registers */
    push    {r4-r7}
    ldr     r4, =SST_RES_ADDRESS
    cbz     r0, UpdateResTestTypeSST
    ldr     r4, =RST_RES_ADDRESS
UpdateResTestTypeSST:
    ;/* read the existing result */
    ldrh    r5, [r4]
    ldrh    r6, =RESULT_BIT_MASK
    lsl	    r6, r6, r1
    mvn	    r6, r6
    ; /* Now r6 has ((~RESULT_BIT_MASK) << test_id) */
    and	    r5, r5, r6
    mov     r7, r2
    lsl	    r7, r7, r1
    orr	    r5, r5, r7
    strh    r5, [r4]
    ; /* Load the 1s complement of the result */
    ; /* For SSTs, this address is 0x20000004 */
    ; /* For RSTs, this address is 0x20000006 */
    ; /* Take 1s complement of the value */
    mvn	    r2, r5
    strh    r2, [r4, #4]

    pop     {r4-r7}
    bx	    r14

CLASSB_ClearTestResults:
; /* Input arguments are test_type and test_id */
; /* test_type in r0 */
    ; /* push used registers */
    push    {r4-r7}
    ldr     r4, =SST_RES_ADDRESS
    cbz     r0, ClearResTestTypeSST
    ldr     r4, =RST_RES_ADDRESS
ClearResTestTypeSST:
    ldr	    r5, =REG_CLEAR_VAL
    strh    r5, [r4]
    ; /* Store 1s complement of the result */
    mvn	    r5, r5
    ; /* Add 4 to get the address of 1s complement result */
    add	    r4, #4
    strh    r5, [r4]
    pop     {r4-r7}
    bx	    r14
