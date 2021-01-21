---
grand_parent: Harmony 3 Class B Library for SAM E5x/D5x
parent: SAM E5x D5x Class B Library
title: Class B Library Interface
has_toc: true
nav_order: 5
---

# Class B Library Interface
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---


## Constants Summary

| Name | Description |
|-|-|
| CLASSB_RESULT_ADDR | Address of test results. |
| CLASSB_COMPL_RESULT_ADDR | Address of one's complement test results. |
| CLASSB_ONGOING_TEST_VAR_ADDR | Address at which the ID of ongoing test is stored. |
| CLASSB_TEST_IN_PROG_VAR_ADDR | Address of the variable which indicates that a Class B test is in progress. |
| CLASSB_WDT_TEST_IN_PROG_VAR_ADDR | Address of the variable which indicates that a WDT test is in progress. |
| CLASSB_FLASH_TEST_VAR_ADDR | Address of the variable which indicates that a flash test is in progress. |
| CLASSB_INTERRUPT_TEST_VAR_ADDR | Address of the variable which keeps interrupt test internal status. |
| CLASSB_INTERRUPT_COUNT_VAR_ADDR | Address of the variable which keeps interrupt count. |
| CLASSB_SRAM_STARTUP_TEST_SIZE | Size of the SRAM tested during startup. |
| CLASSB_CLOCK_ERROR_PERCENT | Clock error percentage selected for startup test. |
| CLASSB_CLOCK_RTC_CLK_FREQ | RTC clock frequency. |
| CLASSB_CLOCK_TEST_RTC_CYCLES | Duration of the CPU clock test. |
| CLASSB_CLOCK_TEST_RTC_RATIO_NS | Duration of RTC clock in nano seconds. |
| CLASSB_CLOCK_TEST_RATIO_NS_MS | Ratio of milli second to nano second. |
| CLASSB_CLOCK_DEFAULT_CLOCK_FREQ | Default CPU clock speed. |
| CLASSB_INVALID_TEST_ID | Invalid test ID. |
| CLASSB_CLOCK_MAX_CLOCK_FREQ | Maximum CPU clock speed. |
| CLASSB_CLOCK_MAX_SYSTICK_VAL | Upper limit of SysTick counter. |
| CLASSB_CLOCK_MAX_TEST_ACCURACY | Maximum detectable accuracy for clock self-test. |
| CLASSB_CLOCK_MUL_FACTOR | Multiplication factor used in clock test. |
| CLASSB_FLASH_CRC32_POLYNOMIAL | CRC-32 polynomial. |
| CLASSB_SRAM_TEST_BUFFER_SIZE | Defines the size of the buffer used for SRAM test. |
| CLASSB_SRAM_APP_AREA_START | Defines the start address of the SRAM for the application. |
| CLASSB_SRAM_FINAL_WORD_ADDRESS | Final word address in the SRAM. |
| CLASSB_SRAM_BUFF_START_ADDRESS | SRAM test buffer start address. |
| CLASSB_SRAM_TEMP_STACK_ADDRESS | Address of the temporary stack. |
| CLASSB_SRAM_ALL_32BITS_HIGH | Defines name for max 32-bit unsigned value. |
| CLASSB_INTR_DEVICE_VECT_OFFSET | Defines the offset for first device specific interrupt. |
| CLASSB_INTR_VECTOR_TABLE_SIZE | Defines the size of the vector table. |
| CLASSB_INTR_MAX_INT_COUNT | Defines the upper limit for interrupt count. |
| CLASSB_INTR_TEST_RTC_COUNT | Defines the counter value for RTC peripheral. |
| CLASSB_INTR_TEST_TC_COUNT | Defines the counter value for TC0 peripheral. |

## Data types Summary

| Name | Description |
|-|-|
| CLASSB_TEST_ID | Identifies Class B library tests. |
| CLASSB_TEST_STATUS | Identifies result from Class B library test. |
| CLASSB_TEST_STATE | Identifies Class B library test state. |
| CLASSB_INIT_STATUS | Identifies Class B initialization status. |
| CLASSB_STARTUP_STATUS | Identifies startup test status. |
| CLASSB_TEST_TYPE | Identifies type of the Class B library test. |
| *CLASSB_SST_RESULT_BF | Pointer to the structure for the Class B library startup self-test result. |
| *CLASSB_RST_RESULT_BF | Pointer to the structure for the Class B library run-time self-test result. |
| CLASSB_SRAM_MARCH_ALGO | Selects the RAM March algorithm to run. |
| CLASSB_PORT_INDEX | PORT index definitions for Class B library I/O pin test. |
| CLASSB_PORT_PIN | PIN definitions for Class B library I/O pin test. |
| CLASSB_PORT_PIN_STATE | PORT pin state. |
| CLASSB_CPU_PC_TEST_VALUES | Data type for PC Test input and output values. |

## Interface Routines Summary

| Name | Description |
|-|-|
| CLASSB_ClearTestResults | Clears the results of SSTs or RSTs. |
| CLASSB_GetTestResult | Returns the result of the specified self-test. |
| CLASSB_TestWDT | This function tests the WatchDog Timer (WDT). |
| CLASSB_GlobalsInit | This function initializes the global variables for the classb library. |
| CLASSB_Init | This function is executed on every device reset. This shall be called right after the reset, before any other initialization is performed. |
| CLASSB_Startup_Tests | This function executes all startup self-tests inserted into classb.c file. |
| CLASSB_SST_WDT_Recovery | This function is called if a WDT reset has happened during the execution of an SST. |
| CLASSB_App_WDT_Recovery | This function is called if a WDT reset has happened during run-time. |
| CLASSB_SelfTest_FailSafe | This function is called if any of the non-critical tests detects a failure. |
| CLASSB_CPU_RegistersTest | This self-test checks the processor core registers. |
| CLASSB_FPU_RegistersTest | This self-test checks the FPU registers. |
| CLASSB_CPU_PCTest | This self-test checks the Program Counter register (PC). |
| CLASSB_FlashCRCGenerate | Generates CRC-32 checksum for a given memory area. |
| CLASSB_FlashCRCTest | This self-test checks the internal Flash program memory to detect single bit faults. |
| CLASSB_SRAM_MarchTestInit | This self-test checks the SRAM with the help of RAM March algorithm. |
| CLASSB_ClockTest | This self-test checks whether the CPU clock frequency is within the permissible limit. |
| CLASSB_SST_InterruptTest | This self-test checks basic functionality of the interrupt handling mechanism. |
| CLASSB_RST_IOTest | This self-test can be used to perform plausibility checks on IO pins. |
| CLASSB_IO_InputSamplingEnable | Enable input sampling for an IO pin. |

## Constants


### CLASSB_RESULT_ADDR

**Summary**

Address of test results.

**Description**

This constant defines the address in SRAM where the test results are stored.

**Remarks**

This value must not be modified.

```c
#define CLASSB_RESULT_ADDR (0x20000000U)
```

### CLASSB_COMPL_RESULT_ADDR


**Summary**

Address of one's complement test results.

**Description**

This constant defines the address in SRAM where the one's complement of the test results are stored.

**Remarks**

This value must not be modified.

```c
#define CLASSB_COMPL_RESULT_ADDR (0x20000004U)
```

### CLASSB_ONGOING_TEST_VAR_ADDR


**Summary**

Address at which the ID of ongoing test is stored.

**Description**

This constant defines the address in SRAM where the the ID of ongoing test is stored.

**Remarks**

This value must not be modified.

```c
#define CLASSB_ONGOING_TEST_VAR_ADDR (0x20000008U)
```

### CLASSB_TEST_IN_PROG_VAR_ADDR


**Summary**

Address of the variable which indicates that a Class B test is in progress.

**Description**

Defines the address of the variable which indicates that a Class B test is in progress.

**Remarks**

This value must not be modified.

```c
#define CLASSB_TEST_IN_PROG_VAR_ADDR (0x2000000CU)
```

### CLASSB_WDT_TEST_IN_PROG_VAR_ADDR


**Summary**

Address of the variable which indicates that a WDT test is in progress.

**Description**

Defines the address of the variable which indicates that a WDT test is in progress.

**Remarks**

This value must not be modified.

```c
#define CLASSB_WDT_TEST_IN_PROG_VAR_ADDR (0x20000010U)
```

### CLASSB_FLASH_TEST_VAR_ADDR


**Summary**

Address of the variable which indicates that a flash test is in progress.

**Description**

Defines the address of the variable which indicates that a flash test is in progress.

**Remarks**

This value must not be modified.

```c
#define CLASSB_FLASH_TEST_VAR_ADDR (0x20000014U)
```

### CLASSB_INTERRUPT_TEST_VAR_ADDR


**Summary**

Address of the variable which keeps interrupt test internal status.

**Description**

Defines the address of the variable which keeps interrupt test internal status.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INTERRUPT_TEST_VAR_ADDR (0x20000018U)
```

### CLASSB_INTERRUPT_COUNT_VAR_ADDR


**Summary**

Address of the variable which keeps interrupt count.

**Description**

Defines the address of the variable which keeps interrupt count.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INTERRUPT_COUNT_VAR_ADDR (0x2000001cU)
```

### CLASSB_SRAM_STARTUP_TEST_SIZE


**Summary**

Size of the SRAM tested during startup.

**Description**

Defines the size of the SRAM tested during startup. Modify this macro to change the area of the
tested SRAM area. The test size must be a multiple of four.

**Remarks**

This value can be modified.

```c
#define CLASSB_SRAM_STARTUP_TEST_SIZE (65536U)
```

### CLASSB_CLOCK_ERROR_PERCENT


**Summary**

Clock error percentage selected for startup test.

**Description**

Defines the acceptable error percentage of the CPU clock. This value is configured via MHC and is used
during startup self-test of the CPU clock.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_ERROR_PERCENT (5U)
```

### CLASSB_CLOCK_RTC_CLK_FREQ


**Summary**

RTC clock frequency.

**Description**

Defines the RTC clock frequency.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_RTC_CLK_FREQ (32768U)
```

### CLASSB_CLOCK_TEST_RTC_CYCLES


**Summary**

Duration of the CPU clock test.

**Description**

Defines the duration of the CPU clock test in terms of RTC cycles.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_TEST_RTC_CYCLES (200U)
```

### CLASSB_CLOCK_TEST_RTC_RATIO_NS


**Summary**

Duration of RTC clock in nano seconds.

**Description**

Defines the duration of RTC clock in nano seconds. This is used to calculate the duration of CPU clock test in terms of RTC cycles.

**Remarks**

RTC is clocked from 32768 Hz Crystal. One RTC cycle is 30517 nano sec. This value must not be modified.

```c
#define CLASSB_CLOCK_TEST_RTC_RATIO_NS (30517U)
```

### CLASSB_CLOCK_TEST_RATIO_NS_MS


**Summary**

Ratio of milli second to nano second.

**Description**

Defines the ratio of milli second to nano second. This is used to calculate the duration of CPU clock test in terms of RTC cycles.

**Remarks**

Used to avoid the use of floating point math. This value must not be modified.

```c
#define CLASSB_CLOCK_TEST_RATIO_NS_MS (1000000U)
```

### CLASSB_CLOCK_DEFAULT_CLOCK_FREQ


**Summary**

Default CPU clock speed.

**Description**

Defines the default CPU clock speed after a reset.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_DEFAULT_CLOCK_FREQ (48000000U)
```

### CLASSB_INVALID_TEST_ID


**Summary**

Invalid test ID.

**Description**

Defines a constant to initialize the variable which holds the ID of the ongoing self-test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INVALID_TEST_ID (0xFFU)
```

### CLASSB_CLOCK_MAX_CLOCK_FREQ


**Summary**

Maximum CPU clock speed.

**Description**

Defines the maximum CPU clock speed for the microcontroller.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_MAX_CLOCK_FREQ (120000000U)
```

### CLASSB_CLOCK_MAX_SYSTICK_VAL


**Summary**

Upper limit of SysTick counter.

**Description**

Defines the upper limit of SysTick counter.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_MAX_SYSTICK_VAL (0xffffffU)
```

### CLASSB_CLOCK_MAX_TEST_ACCURACY


**Summary**

Maximum detectable accuracy for clock self-test.

**Description**

Defines the maximum detectable accuracy for clock self-test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_MAX_TEST_ACCURACY (5U)
```

### CLASSB_CLOCK_MUL_FACTOR


**Summary**

Multiplication factor used in clock test.

**Description**

Defines the multiplication factor used in clock test. This is used to calculate the CPU clock error.
Used to avoid the use of floating point math.

**Remarks**

This value must not be modified.

```c
#define CLASSB_CLOCK_MUL_FACTOR (128U)
```

### CLASSB_FLASH_CRC32_POLYNOMIAL


**Summary**

CRC-32 polynomial.

**Description**

Defines the CRC-32 polynomial used for Flash self-test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_FLASH_CRC32_POLYNOMIAL (0xedb88320U)
```

### CLASSB_SRAM_TEST_BUFFER_SIZE


**Summary**

Defines the size of the buffer used for SRAM test.

**Description**

This constant defines the size of the buffer used for SRAM test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_SRAM_TEST_BUFFER_SIZE (512U)
```

### CLASSB_SRAM_APP_AREA_START


**Summary**

Defines the start address of the SRAM for the application.

**Description**

This constant defines the start address of the SRAM for the application. First 1kB of the SRAM is reserved for the Class B library.

**Remarks**

This value must not be modified.

```c
#define CLASSB_SRAM_APP_AREA_START (0x20000400U)
```

### CLASSB_SRAM_FINAL_WORD_ADDRESS


**Summary**

Final word address in the SRAM.

**Description**

This constant defines the final word address in the SRAM.

**Remarks**

This value must not be modified. Varies depending on the device.

```c
#define CLASSB_SRAM_FINAL_WORD_ADDRESS (0x2003fffcU)
```

### CLASSB_SRAM_BUFF_START_ADDRESS


**Summary**

SRAM test buffer start address.

**Description**

This constant defines the SRAM test buffer start address. This is used by the self-test for the SRAM.

**Remarks**

This value must not be modified.

```c
#define CLASSB_SRAM_BUFF_START_ADDRESS (0x20000200U)
```

### CLASSB_SRAM_TEMP_STACK_ADDRESS


**Summary**

Address of the temporary stack.

**Description**

This constant defines the address of the temporary stack used during SRAM self-test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_SRAM_TEMP_STACK_ADDRESS (0x20000100U)
```

### CLASSB_SRAM_ALL_32BITS_HIGH


**Summary**

Defines name for max 32-bit unsigned value.

**Description**

This constant defines a name for max 32-bit unsigned value.

**Remarks**

This value must not be modified.

```c
#define CLASSB_SRAM_ALL_32BITS_HIGH (0xFFFFFFFFU)
```

### CLASSB_INTR_DEVICE_VECT_OFFSET


**Summary**

Defines the offset for first device specific interrupt.

**Description**

This constant defines the offset for first device specific interrupt.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INTR_DEVICE_VECT_OFFSET (16U)
```

### CLASSB_INTR_VECTOR_TABLE_SIZE


**Summary**

Defines the size of the vector table.

**Description**

This constant defines the size of the vector table.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INTR_VECTOR_TABLE_SIZE (CLASSB_INTR_DEVICE_VECT_OFFSET + PERIPH_MAX_IRQn)
```

### CLASSB_INTR_MAX_INT_COUNT


**Summary**

Defines the upper limit for interrupt count.

**Description**

This constant defines the upper limit for interrupt count for the interrupt self-test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INTR_MAX_INT_COUNT (30U)
```

### CLASSB_INTR_TEST_RTC_COUNT


**Summary**

Defines the counter value for RTC peripheral.

**Description**

This constant defines the counter value for RTC peripheral, for the interrupt self-test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INTR_TEST_RTC_COUNT (50U)
```

### CLASSB_INTR_TEST_TC_COUNT


**Summary**

Defines the counter value for TC0 peripheral.

**Description**

This constant defines the counter value for TC0 peripheral, for the interrupt self-test.

**Remarks**

This value must not be modified.

```c
#define CLASSB_INTR_TEST_TC_COUNT (100U)
```

## Data types


### CLASSB_TEST_ID

**Summary**

Identifies Class B library tests.

**Description**

This enumeration can be used to read the self-test status and update it. Test ID corresponds to the bit position
at which the 2-bit test result is stored.

**Remarks**

None.

```c
typedef enum
{
CLASSB_TEST_CPU = 0,
CLASSB_TEST_PC = 2,
CLASSB_TEST_RAM = 4,
CLASSB_TEST_FLASH = 6,
CLASSB_TEST_CLOCK = 8,
CLASSB_TEST_INTERRUPT = 10,
CLASSB_TEST_IO = 12
} CLASSB_TEST_ID;
```

### CLASSB_TEST_STATUS


**Summary**

Identifies result from Class B library test.

**Description**

This is return type for self-tests.

**Remarks**

None.

```c
typedef enum
{
CLASSB_TEST_NOT_EXECUTED = 0,
CLASSB_TEST_PASSED = 1,
CLASSB_TEST_FAILED = 2,
CLASSB_TEST_INPROGRESS = 3
} CLASSB_TEST_STATUS;
```

### CLASSB_TEST_STATE


**Summary**

Identifies Class B library test state.

**Description**

This data type is used to update flags which indicates whether a test has started or not.

**Remarks**

None.

```c
typedef enum
{
CLASSB_TEST_NOT_STARTED = 0,
CLASSB_TEST_STARTED = 1
} CLASSB_TEST_STATE;
```

### CLASSB_INIT_STATUS


**Summary**

Identifies Class B initialization status.

**Description**

This is return type for the function which initializes the Class B library during startup.
This indicates whether the SSTs are executed or not.

**Remarks**

None.

```c
typedef enum
{
CLASSB_SST_DONE = 1,
CLASSB_SST_NOT_DONE = 2
} CLASSB_INIT_STATUS;
```

### CLASSB_STARTUP_STATUS


**Summary**

Identifies startup test status.

**Description**

This is return type for the function which calls all self-tests during startup.

**Remarks**

None.

```c
typedef enum
{
CLASSB_STARTUP_TEST_PASSED = 1,
CLASSB_STARTUP_TEST_FAILED = 2
} CLASSB_STARTUP_STATUS;
```

### CLASSB_TEST_TYPE


**Summary**

Identifies type of the Class B library test.

**Description**

There are two categories of test. They are startup tests (SSTs) and run-time tests (RSTs).
Test results for SSTs and RSTs are stored at separate locations in the SRAM.

**Remarks**

None.

```c
typedef enum
{
CLASSB_TEST_TYPE_SST = 0,
CLASSB_TEST_TYPE_RST = 1
} CLASSB_TEST_TYPE;
```

### *CLASSB_SST_RESULT_BF


**Summary**

Pointer to the structure for the Class B library startup self-test result.

**Description**

For bit-field representation of Class B library test results.

**Remarks**

None.

```c
typedef struct
{
CLASSB_TEST_STATUS CPU_STATUS:2;
CLASSB_TEST_STATUS PC_STATUS:2;
CLASSB_TEST_STATUS RAM_STATUS:2;
CLASSB_TEST_STATUS FLASH_STATUS:2;
CLASSB_TEST_STATUS CLOCK_STATUS:2;
CLASSB_TEST_STATUS INTERRUPT_STATUS:2;
} *CLASSB_SST_RESULT_BF;
```

### *CLASSB_RST_RESULT_BF


**Summary**

Pointer to the structure for the Class B library run-time self-test result.

**Description**

For bit-field representation of Class B library test results.

**Remarks**

None.

```c
typedef struct
{
CLASSB_TEST_STATUS CPU_STATUS:2;
CLASSB_TEST_STATUS PC_STATUS:2;
CLASSB_TEST_STATUS RAM_STATUS:2;
CLASSB_TEST_STATUS FLASH_STATUS:2;
CLASSB_TEST_STATUS CLOCK_STATUS:2;
CLASSB_TEST_STATUS UNUSED_STATUS:2;
CLASSB_TEST_STATUS IO_STATUS:2;
} *CLASSB_RST_RESULT_BF;
```

### CLASSB_SRAM_MARCH_ALGO


**Summary**

Selects the RAM March algorithm to run.

**Description**

Selects the RAM March algorithm to be used for the SRAM self-test.

**Remarks**

None.

```c
typedef enum
{
CLASSB_SRAM_MARCH_C = 0,
CLASSB_SRAM_MARCH_C_MINUS = 1,
CLASSB_SRAM_MARCH_B = 2
} CLASSB_SRAM_MARCH_ALGO;
```

### CLASSB_PORT_INDEX


**Summary**

PORT index definitions for Class B library I/O pin test.

**Description**

This can be used in the I/O pin test.

**Remarks**

None.

```c
typedef enum
{
PORTA = 0,
PORTB = 1,
PORTC = 2,
PORTD = 3
} CLASSB_PORT_INDEX;
```

### CLASSB_PORT_PIN


**Summary**

PIN definitions for Class B library I/O pin test.

**Description**

This can be used in the I/O pin test.

**Remarks**

None.

```c
typedef enum
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
```

### CLASSB_PORT_PIN_STATE


**Summary**

PORT pin state.

**Description**

This can be used in the I/O pin test.

**Remarks**

None.

```c
typedef enum
{
PORT_PIN_LOW = 0,
PORT_PIN_HIGH = 1,
PORT_PIN_INVALID = 2
} CLASSB_PORT_PIN_STATE;
```

### CLASSB_CPU_PC_TEST_VALUES


**Summary**

Data type for PC Test input and output values.

**Description**

The PC tests performs logical left-shift of the input value and returns it. Values from this enum can be used as arguments.

**Remarks**

None.

```c
typedef enum classb_pc_test_val
{
CLASSB_CPU_PC_TEST_ROUTINE_A_INPUT = 1U,
CLASSB_CPU_PC_ROUTINE_A_RET_VAL = 2U,
CLASSB_CPU_PC_ROUTINE_B_RET_VAL = 4U,
CLASSB_CPU_PC_ROUTINE_C_RET_VAL = 8U,
CLASSB_CPU_PC_TEST_INIT_VAL = 0U
} CLASSB_CPU_PC_TEST_VALUES;
```

## Interface Routines


### CLASSB_ClearTestResults

**Function**

```c
void CLASSB_ClearTestResults(CLASSB_TEST_TYPE test_type);
```

**Summary**

Clears the results of SSTs or RSTs.

**Description**

This function clears all the test results of a given type of test.

**Precondition**

None.

**Parameters**

*test_type* - Can be CLASSB_TEST_TYPE_SST or CLASSB_TEST_TYPE_RST.

**Returns**

None.

**Example**

```c
CLASSB_ClearTestResults(CLASSB_TEST_TYPE_SST);
CLASSB_ClearTestResults(CLASSB_TEST_TYPE_RST);
```

**Remarks**

This function is called from CLASSB_Init().

### CLASSB_GetTestResult

**Function**

```c
CLASSB_TEST_STATUS CLASSB_GetTestResult(CLASSB_TEST_TYPE test_type, CLASSB_TEST_ID test_id);
```

**Summary**

Returns the result of the specified self-test.

**Description**

This function reads the test results from the reserved SRAM and extracts the result of the self-test
specified by the input arguments.

**Precondition**

None.

**Parameters**

*test_type* - Can be CLASSB_TEST_TYPE_SST or CLASSB_TEST_TYPE_RST.

*test_id* - Identifier for a Class B library test.

**Returns**

None.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
classb_test_status = CLASSB_GetTestResult(CLASSB_TEST_TYPE_SST, CLASSB_TEST_CPU);
```

**Remarks**

None.

### CLASSB_TestWDT

**Function**

```c
static void CLASSB_TestWDT(void);
```

**Summary**

This function tests the WatchDog Timer (WDT).

**Description**

This function is called from CLASSB_Init(). It tests whether the WDT can reset the device. After the WDT resets
the device, the Class B library clears the test flag and proceeds to the rest of the initialization routines.
Since the test flag is kept in reserved SRAM area, it is not touched by the general startup code.

**Precondition**

None.

**Parameters**

None.

**Returns**

None.

**Example**

```c
CLASSB_TestWDT(void);
```

**Remarks**

Calling this function results in device reset by the WDT.

### CLASSB_GlobalsInit

**Function**

```c
static void CLASSB_GlobalsInit(void);
```

**Summary**

This function initializes the global variables for the classb library.

**Description**

The parameters used by the Class B library are access with the help of pointer variables.
These variables are initialized by this function. 

**Precondition**

None.

**Parameters**

None.

**Returns**

None.

**Example**

```c
CLASSB_GlobalsInit();
```

**Remarks**

None.

### CLASSB_Init

**Function**

```c
static CLASSB_INIT_STATUS CLASSB_Init(void);
```

**Summary**

This function is executed on every device reset. This shall be called right after the reset, before any other
initialization is performed.

**Description**

This function performs the following,

a. It initializes the global variables used by the Class B library.

b. Checks the reset cause and decides next course of action.

c. If the reset is not caused by the Class B library, it tests the reserved SRAM area,
 clears all self-test results and performs a WDT test.

**Precondition**

None.

**Parameters**

None.

**Returns**

CLASSB_SST_DONE if all SSTs are successfully executed. CLASSB_SST_NOT_DONE if SSTs are yet to be executed.

**Example**

```c
CLASSB_INIT_STATUS init_status = CLASSB_Init();
```

**Remarks**

None.

### CLASSB_Startup_Tests

**Function**

```c
static CLASSB_STARTUP_STATUS CLASSB_Startup_Tests(void);
```

**Summary**

This function executes all startup self-tests inserted into classb.c file by the MHC.

**Description**

This function is called from the '_on_reset' function which is the first function to be executed after a reset.
If none of the self-tests are failed, this function returns 'CLASSB_STARTUP_TEST_PASSED'.
If any of the startup self-tests are failed, this function will not return. The self-tests for SRAM,
Clock and Interrupt are considered non-critical since it may be possible to execute a fail-safe function
after detecting a failure. In such case, the CLASSB_SelfTest_FailSafe() function is called when a failure
is detected. In the case of critical failures (CPU registers or internal flash), the corresponding self-test
remains in an infinite loop to avoid unsafe execution of code.

**Precondition**

None.

**Parameters**

None.

**Returns**

Pass or Fail.

**Example**

```c
CLASSB_STARTUP_STATUS startup_tests_status = CLASSB_STARTUP_TEST_FAILED;
startup_tests_status = CLASSB_Startup_Tests();
```

**Remarks**

This function does not return if any of the self-tests detects a failure.

### CLASSB_SST_WDT_Recovery

**Function**

```c
static void CLASSB_SST_WDT_Recovery(void);
```

**Summary**

This function is called if a WDT reset is caused while a startup self-test is running.

**Description**

This function is used inside the CLASSB_Init() function. When the device comes back from a WDT reset,
if there has been a startup self-test running, it is assumed that the WDT reset has happened because
a Class B self-test has taken more time that the WDT timeout period. In this case, the
CLASSB_SST_WDT_Recovery() function is called from CLASSB_Init().

**Precondition**

None.

**Parameters**

None.

**Returns**

None.

**Example**

```c
if ((RSTC_REGS->RSTC_RCAUSE & RSTC_RCAUSE_WDT_Msk) == RSTC_RCAUSE_WDT_Msk)
{
    if (*classb_test_in_progress == CLASSB_TEST_STARTED)
    {
        CLASSB_SST_WDT_Recovery();
    }
}
```

**Remarks**

This function is for the internal use of the Class B library.

### CLASSB_App_WDT_Recovery

**Function**

```c
static void CLASSB_App_WDT_Recovery(void);
```

**Summary**

This function is called if a WDT reset is caused during run-time.

**Description**

This function is used inside the CLASSB_Init() function. When the device comes back from a WDT reset,
if a WDT test by the Class B library has not been in progress, it is assumed that the WDT reset has
happened since the application failed to clear the WDT during regular intervals.
In this case, the CLASSB_App_WDT_Recovery() function is called from CLASSB_Init().

**Precondition**

None.

**Parameters**

None.

**Returns**

None.

**Example**

```c
if ((RSTC_REGS->RSTC_RCAUSE & RSTC_RCAUSE_WDT_Msk) == RSTC_RCAUSE_WDT_Msk)
{
    if (!(*wdt_test_in_progress == CLASSB_TEST_STARTED))
    {
        CLASSB_SST_WDT_Recovery();
    }
}
```

**Remarks**

This function is for the internal use of the Class B library.

### CLASSB_SelfTest_FailSafe

**Function**

```c
void CLASSB_SelfTest_FailSafe(CLASSB_TEST_ID test_id);
```

**Summary**

This function is called if any of the non-critical tests are failed.

**Description**

The self-tests for SRAM, Clock and Interrupt are considered non-critical since it may be possible
to execute a fail-safe function after detecting a failure, if the fail-safe routine does not use
the failed element on the microcontroller. Default implementation of this function is available
in classb.c file. The function contains an infinite loop. Further code shall be added as per the application need.

**Precondition**

None.

**Parameters**

*test_id* - Identification number of the failed test.

**Returns**

None.

**Example**

```c
if (classb_sram_status == CLASSB_TEST_FAILED)
{
    CLASSB_SelfTest_FailSafe(CLASSB_TEST_RAM);
}
```

**Remarks**

This function must not return to the Class B library since it is called due to a self-test failure.
Avoid using features which depend on the failed component. For example, if self-test for clock is failed,
it is not advisable to use UART for error reporting since BAUD rate may not be accurate. In the case of
SRAM failure, avoid the use of function calls or variables in SRAM. The error reporting mechanism in this
case can be an IO pin.

### CLASSB_CPU_RegistersTest

**Function**

```c
CLASSB_TEST_STATUS CLASSB_CPU_RegistersTest(bool running_context);
```

**Summary**

This self-test checks the processor core registers of the CPU, to detect stuck-at faults.

**Description**

This self-test writes test patterns into the processor core registers and special function registers
and read them back to detect stuck-at faults. Special function register bits
which are reserved and should not be modified during the test, are not written.

**Precondition**

None.

**Parameters**

*running_context* - False for startup test. True for run-time test.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform run-time test of the CPU registers
classb_test_status = CLASSB_CPU_RegistersTest(true);
```

**Remarks**

This self-test can be used during startup as well as run-time. If a failure is detected,
this self-test remains in an infinite loop to avoid unsafe code execution.

### CLASSB_FPU_RegistersTest

**Function**

```c
CLASSB_TEST_STATUS CLASSB_FPU_RegistersTest(bool running_context);
```

**Summary**

This self-test checks the FPU registers of the CPU, to detect stuck-at faults.

**Description**

This self-test writes test patterns into the FPU registers, and read them back
to detect stuck-at faults.
Special function register bits which are reserved or should not be modified
during the test, are not written.
Testing FPU registers is optional as it may not be used in every application.

**Precondition**

None.

**Parameters**

*running_context* - False for startup test. True for run-time test.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform run-time test of the FPU registers
classb_test_status = CLASSB_FPU_RegistersTest(true);
```

**Remarks**

This self-test can be used during startup as well as run-time. If a failure is detected,
this self-test remains in an infinite loop to avoid unsafe code execution.

### CLASSB_CPU_PCTest

**Function**

```c
CLASSB_TEST_STATUS CLASSB_CPU_PCTest(bool running_context);
```

**Summary**

This self-test checks the Program Counter register (PC) of the CPU, to detect stuck-at faults.

**Description**

This self-test calls multiple functions in predefined order and verifies that each function is
executed and returns the expected value. If the return values of all test functions are correct,
the Program Counter is assumed to be working fine.

**Precondition**

None.

**Parameters**

*running_context* - False for startup test. True for run-time test.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform run-time test of the PC
classb_test_status = CLASSB_CPU_PCTest(true);
```

**Remarks**

This self-test can be used during startup as well as run-time. If a failure is detected, this self-test
remains in an infinite loop to avoid unsafe code execution.

### CLASSB_FlashCRCGenerate

**Function**

```c
uint32_t CLASSB_FlashCRCGenerate(uint32_t start_addr, uint32_t test_size);
```

**Summary**

Generates CRC-32 checksum for a given memory area.

**Description**

This function runs CRC-32 algorithm with the polynomial 0xEDB88320 and returns the generated checksum.
It uses table based approach where the table is generated during the execution. It uses 0xffffffff as the initial value.

**Precondition**

None.

**Parameters**

*start_addr* - Starting address of the memory block.

*test_size* - Size of the memory block.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
uint32_t crc_val = 0;
// Generate CRC-32 for the internal Flash.
crc_val = CLASSB_FlashCRCGenerate(0, 0xFE000);
```

**Remarks**

This function is used inside the Class B library to generate CRC-32 of the internal Flash memory but
it can be used on any contiguous memory area.

### CLASSB_FlashCRCTest

**Function**

```c
CLASSB_TEST_STATUS CLASSB_FlashCRCTest(uint32_t start_addr, uint32_t test_size, uint32_t crc_val, bool running_context);
```

**Summary**

This self-test checks the internal Flash program memory to detect single bit faults.

**Description**

This self-test generates CRC-32 checksum for the given memory area and compares it with the expected checksum.

**Precondition**

None.

**Parameters**

*start_addr* - Starting address of the memory block.

*test_size* - Size of the memory block.

*crc_val* - Expected CRC-32 checksum.

*running_context* - False for startup test. True for run-time test.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform run-time test of the internal Flash
classb_test_status = CLASSB_FlashCRCTest(0, 0xFE000, *(uint32_t *)FLASH_CRC32_ADDR, true);
```

**Remarks**

This self-test can be used during startup as well as run-time. If a failure is detected, this self-test remains
in an infinite loop to avoid unsafe code execution.

### CLASSB_SRAM_MarchTestInit

**Function**

```c
CLASSB_TEST_STATUS CLASSB_SRAM_MarchTestInit(uint32_t * start_addr, uint32_t test_size, CLASSB_SRAM_MARCH_ALGO march_algo, bool running_context);
```

**Summary**

This self-test checks the SRAM with the help of RAM March algorithm.

**Description**

This self-test run the selected RAM March algorithm on the SRAM to detect stuck-at fault, DC fault and addressing fault.

**Precondition**

None.

**Parameters**

*start_addr* - Starting address of the memory block.

*test_size* - Size of the memory block.

*march_algo* - The selected RAM March algorithm. It can be March C, March C minus or March B.

*running_context* - False for startup test. True for run-time test.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform run-time test of the internal SRAM
classb_test_status = CLASSB_SRAM_MarchTestInit((uint32_t *)CLASSB_SRAM_APP_AREA_START,
    1024, CLASSB_SRAM_MARCH_C, true);
```

**Remarks**

This self-test can be used during startup as well as run-time. Initial 1kB of the SRAM must be reserved for the Class B library.

### CLASSB_ClockTest

**Function**

```c
CLASSB_TEST_STATUS CLASSB_ClockTest(uint32_t cpu_clock_freq, uint8_t error_limit, uint16_t clock_test_rtc_cycles, bool running_context);
```

**Summary**

This self-test checks whether the CPU clock frequency is within the permissible limit.

**Description**

This self-test uses RTC and SysTick to measure the CPU clock frequency. The RTC is clocked at 32768 Hz from
the XOSC32K and CPU clock can be from any other high frequency oscillator. If the CPU clock frequency is within
specified error limit, it returns PASS. The test duration is defined by the value of rtc_cycles. The RTC is
configured to take clock from an external 32.768 kHz accurate crystal.

**Precondition**

None.

**Parameters**

*cpu_clock_freq* - Expected CPU clock frequency.

*error_limit* - Permissible error limit (eg; 5 means +-5 percent).

*clock_test_rtc_cycles* - The test duration in terms of RTC cycles.

*running_context* - False for startup test. True for run-time test.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform run-time test of the CPU clock
classb_test_status = CLASSB_ClockTest(120000000, 5, 500, true);
```

**Remarks**

This self-test can be used during startup as well as run-time. This self-test shall be used only if there is
an external 32.768 kHz accurate crystal connected to the XOSC32K of the microcontroller.

### CLASSB_SST_InterruptTest

**Function**

```c
CLASSB_TEST_STATUS CLASSB_SST_InterruptTest(void);
```

**Summary**

This self-test checks basic functionality of the interrupt handling mechanism.

**Description**

This self-test configures the Nested Vectored Interrupt Controller (NVIC), the RTC peripheral and the TC0 peripheral
to test the interrupt handling mechanism of the microcontroller. It verifies that at least one interrupt is generated
and handled properly. This self-test also checks whether the number of interrupts generated are too many within a given
time period. It reports a PASS if the RTC has generated at least one interrupt and the total number of interrupts
generated by the TC0 is less than the specified upper limit and greater than one. The clock used for RTC is 1kHz
from the internal OSCULP32K and for TC0, the clock is same as the default CPU clock (48MHz from the DFLL48M).

**Precondition**

None.

**Parameters**

None.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform test of the Interrupt mechanism at start-up
classb_test_status = CLASSB_SST_InterruptTest();
```

**Remarks**

This self-test can be used only during startup.

### CLASSB_RST_IOTest

**Function**

```c
CLASSB_TEST_STATUS CLASSB_RST_IOTest(CLASSB_PORT_INDEX port, CLASSB_PORT_PIN pin, CLASSB_PORT_PIN_STATE state);
```

**Summary**

This self-test can be used to perform plausibility checks on IO pins.

**Description**

This self-test checks whether a given IO pin is at the expected logic state. As the exact use of an IO pin is
decide by the application, it is the responsibility of the caller to configure the IO pin direction and drive
the pin to the expected state before calling this self-test.

**Precondition**

Before testing an output pin, call CLASSB_IO_InputSamplingEnable() function to enable input sampling for the IO pin.

**Parameters**

*port* - Index of the IO PORT. Defined by enum CLASSB_PORT_INDEX.

*pin* - Index of the pin on the given PORT. Defined by enum CLASSB_PORT_PIN.

*state* - Expected logic state of the IO pin. It can be PORT_PIN_LOW or PORT_PIN_HIGH.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform test of an IO pin at run-time
classb_test_status = CLASSB_RST_IOTest(PORTB, PIN31, PORT_PIN_HIGH);
```

**Remarks**

This self-test can be used only during run-time.

### CLASSB_IO_InputSamplingEnable

**Function**

```c
void CLASSB_IO_InputSamplingEnable(CLASSB_PORT_INDEX port, CLASSB_PORT_PIN pin);
```

**Summary**

Enable input sampling for an IO pin.

**Description**

Before testing an output pin with CLASSB_RST_IOTest() API, call this function to enable input sampling,
so that the 'IN' register will have the data from the port pin.

**Precondition**

None.

**Parameters**

*port* - Index of the IO PORT. Defined by enum CLASSB_PORT_INDEX.

*pin* - Index of the pin on the given PORT. Defined by enum CLASSB_PORT_PIN.

*state* - Expected logic state of the IO pin. It can be PORT_PIN_LOW or PORT_PIN_HIGH.

**Returns**

*CLASSB_TEST_STATUS* - Status of the test.

**Example**

```c
CLASSB_TEST_STATUS classb_test_status = CLASSB_TEST_NOT_EXECUTED;
// Perform test of an IO pin at run-time
classb_test_status = CLASSB_RST_IOTest(PORTB, PIN31, PORT_PIN_HIGH);
```

**Remarks**

This self-test can be used only during run-time.