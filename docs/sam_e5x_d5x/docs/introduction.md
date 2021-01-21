---
grand_parent: Harmony 3 Class B Library for SAM E5x/D5x
parent: SAM E5x D5x Class B Library
title: Class B Peripheral Library Introduction
nav_order: 2
---


The Class B Library provides APIs to perform self-tests for the on-board systems of the microcontroller.

## Terms and Acronyms

| **Acronym**   | **Description**                                                 |
| ---           | ---                                                             |
| API           | Application Programming Interface. |
| AAPCS         | The Procedure Call Standard for the ARM Architecture. |
| Driver        | Driver is a software which depends on a lower software layer and abstract hardware and Real Time Operating System (RTOS) details for the middleware and applications. |
| MHC           | MPLAB® Harmony Configurator. |
| MHCM          | MPLAB® Harmony 3 Content Manager tool. |
| PC            | Program Counter |
| PLIB          | Peripheral Library in Harmony 3. A peripheral library contains simple functions to initialize and control peripherals and basic device features. |
| RST           | Run-time Self-test. |
| RSTC          | Reset Controller peripheral on the microcontroller. |
| RTC           | Real Time Counter peripheral on the microcontroller. |
| SST           | Startup Self-test. |
| Startup Code  | The code which runs right after the microcontroller comes out of reset. It contains initialization code for global/static variables and any other basic routines which need to be run before the main() function is called. |
| SysTick       | System Timer inside the ARM© Cortex M4F core. |
| WDT           | Watchdog Timer. |


## Features Tested by the Class B Library

Following table shows the components tested by the Class B library.

| **Component** | **Reference (Table H1 of IEC 60730-1)** | **Fault/Error** | **Acceptable Measures** |
| --- | --- | --- | --- |
| CPU Registers         | 1.1                             | Stuck-at                                | Static memory test |
| CPU Program Counter   | 1.3                             | Stuck-at                                | Static memory test |
| Interrupts            | 2                               | No interrupt / too frequent interrupt   | Functional test |
| CPU Clock             | 3                               | Wrong frequency                         | Frequency monitoring  |
| Flash                 | 4.1                             | All single bit faults                   | Modified checksum |
| SRAM                  | 4.2                             | DC fault                                | Static memory test |
| SRAM data path        | 5.1                             | Stuck-at                                | Static memory test |
| SRAM data path        | 5.2                             | Wrong address                           | Static memory test |
| Digital I/O           | 7.1                             | Abnormal operation                      | Input comparison or output verification |

