# coding: utf-8
"""*****************************************************************************
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
*****************************************************************************"""
################################################################################
#### Call-backs ####
################################################################################
#Update Symbol Visibility
def setClassB_SymbolVisibility(MySymbol, event):
    MySymbol.setVisible(event["value"])
        
################################################################################
#### Component ####
################################################################################
def instantiateComponent(classBComponent):

    configName = Variables.get("__CONFIGURATION_NAME")

    classBMenu = classBComponent.createMenuSymbol("CLASSB_MENU", None)
    classBMenu.setLabel("Class B Startup Test Configuration")
    
    execfile(Module.getPath() +"/config/interface.py")
    
    #Device params
    classBFlashNode = ATDF.getNode("/avr-tools-device-file/devices/device/address-spaces/address-space/memory-segment@[name=\"FLASH\"]")
    if classBFlashNode != None:
        #Flash size
        classB_FLASH_SIZE = classBComponent.createIntegerSymbol("CLASSB_FLASH_SIZE", None)
        classB_FLASH_SIZE.setVisible(False)
        classB_FLASH_SIZE.setDefaultValue(int(classBFlashNode.getAttribute("size"), 16))
        
    classBSRAMNode = ATDF.getNode("/avr-tools-device-file/devices/device/address-spaces/address-space/memory-segment@[name=\"HSRAM\"]")
    if classBSRAMNode != None:
        #SRAM size
        classB_SRAM_SIZE = classBComponent.createIntegerSymbol("CLASSB_SRAM_SIZE", None)
        classB_SRAM_SIZE.setVisible(False)
        classB_SRAM_SIZE.setDefaultValue(int(classBSRAMNode.getAttribute("size"), 16))
        #SRAM address
        classB_SRAM_ADDR = classBComponent.createHexSymbol("CLASSB_SRAM_START_ADDRESS", None)
        classB_SRAM_ADDR.setVisible(False)
        classB_SRAM_ADDR.setDefaultValue(int(classBSRAMNode.getAttribute("start"), 16))
        #SRAM address MSB 24 bits
        classB_SRAM_START_MSB = classBComponent.createHexSymbol("CLASSB_SRAM_START_MSB", None)
        classB_SRAM_START_MSB.setVisible(False)
        classB_SRAM_START_MSB.setDefaultValue(int(classBSRAMNode.getAttribute("start"), 16) >> 8)
    
    # Insert CPU test
    classB_UseCPUTest = classBComponent.createBooleanSymbol("CLASSB_CPU_TEST_OPT", classBMenu)
    classB_UseCPUTest.setLabel("Test CPU?")
    classB_UseCPUTest.setVisible(True)
    classB_UseCPUTest.setDefaultValue(False)
    
    # Enable FPU register test
    classB_FPU_Option = classBComponent.createBooleanSymbol("CLASSB_FPU_OPT", classB_UseCPUTest)
    classB_FPU_Option.setLabel("Enable FPU test")
    classB_FPU_Option.setVisible(False)
    classB_FPU_Option.setDefaultValue(False)
    classB_FPU_Option.setDependencies(setClassB_SymbolVisibility, ["CLASSB_CPU_TEST_OPT"])
    
    # Insert SRAM test
    classB_UseSRAMTest = classBComponent.createBooleanSymbol("CLASSB_SRAM_TEST_OPT", classBMenu)
    classB_UseSRAMTest.setLabel("Test SRAM?")
    classB_UseSRAMTest.setVisible(True)
    classB_UseSRAMTest.setDefaultValue(False)
    
    # Select March algorithm for SRAM test
    classb_Ram_marchAlgo = classBComponent.createKeyValueSetSymbol("CLASSB_SRAM_MARCH_ALGORITHM", classB_UseSRAMTest)
    classb_Ram_marchAlgo.setLabel("Select RAM March algorithm")
    classb_Ram_marchAlgo.addKey("CLASSB_SRAM_MARCH_C", "0", "March C")
    classb_Ram_marchAlgo.addKey("CLASSB_SRAM_MARCH_C_MINUS", "1", "March C minus")
    classb_Ram_marchAlgo.addKey("CLASSB_SRAM_MARCH_B", "2", "March B")
    classb_Ram_marchAlgo.setOutputMode("Key")
    classb_Ram_marchAlgo.setDisplayMode("Description")
    classb_Ram_marchAlgo.setDescription("Selects the SRAM March algorithm to be used during startup")
    classb_Ram_marchAlgo.setDefaultValue(0)
    classb_Ram_marchAlgo.setVisible(False)
    #This should be enabled based on the above configuration
    classb_Ram_marchAlgo.setDependencies(setClassB_SymbolVisibility, ["CLASSB_SRAM_TEST_OPT"])
    
    # Size of the area to be tested
    classb_Ram_marchSize = classBComponent.createIntegerSymbol("CLASSB_SRAM_MARCH_SIZE", classB_UseSRAMTest)
    classb_Ram_marchSize.setLabel("Size of the tested area (bytes)")
    classb_Ram_marchSize.setDefaultValue(classB_SRAM_SIZE.getValue() / 4)
    classb_Ram_marchSize.setVisible(False)
    classb_Ram_marchSize.setMin(0)
    # 1024 bytes are reserved for the use of Class B library
    classb_Ram_marchSize.setMax(classB_SRAM_SIZE.getValue() - 1024)
    classb_Ram_marchSize.setDescription("Size of the SRAM area to be tested starting from 0x20000400")
    classb_Ram_marchSize.setDependencies(setClassB_SymbolVisibility, ["CLASSB_SRAM_TEST_OPT"])
    
    # CRC-32 checksum availability
    classB_FlashCRC_Option = classBComponent.createBooleanSymbol("CLASSB_FLASH_CRC_CONF", classBMenu)
    classB_FlashCRC_Option.setLabel("Test Internal Flash?")
    classB_FlashCRC_Option.setVisible(True)
    classB_FlashCRC_Option.setDefaultValue(False)
    classB_FlashCRC_Option.setDescription("Enable this option if the CRC-32 checksum of the application image is stored at a specific address in the Flash")
    
    # Address at which CRC-32 of the application image is stored
    classB_CRC_address = classBComponent.createHexSymbol("CLASSB_FLASHCRC_ADDR", classB_FlashCRC_Option)
    classB_CRC_address.setLabel("Flash CRC location")
    classB_CRC_address.setDefaultValue(0xFE000)
    classB_CRC_address.setMin(0)
    classB_CRC_address.setMax(classB_FLASH_SIZE.getValue() - 4)
    classB_CRC_address.setVisible(False)
    #This should be enabled based on the above configuration
    classB_CRC_address.setDependencies(setClassB_SymbolVisibility, ["CLASSB_FLASH_CRC_CONF"])
    
    # Insert Clock test
    classB_UseClockTest = classBComponent.createBooleanSymbol("CLASSB_CLOCK_TEST_OPT", classBMenu)
    classB_UseClockTest.setLabel("Test CPU Clock?")
    classB_UseClockTest.setVisible(True)
    
    # Acceptable CPU clock frequency error at startup
    classb_ClockTestPercentage = classBComponent.createKeyValueSetSymbol("CLASSB_CLOCK_TEST_PERCENT", classB_UseClockTest)
    classb_ClockTestPercentage.setLabel("Permitted CPU clock error at startup")
    classb_ClockTestPercentage.addKey("CLASSB_CLOCK_5PERCENT", "5", "+-5 %")
    classb_ClockTestPercentage.addKey("CLASSB_CLOCK_10PERCENT", "10", "+-10 %")
    classb_ClockTestPercentage.addKey("CLASSB_CLOCK_15PERCENT", "15", "+-15 %")
    classb_ClockTestPercentage.setOutputMode("Value")
    classb_ClockTestPercentage.setDisplayMode("Description")
    classb_ClockTestPercentage.setDescription("Selects the permitted CPU clock error at startup")
    classb_ClockTestPercentage.setDefaultValue(0)
    classb_ClockTestPercentage.setVisible(False)
    classb_ClockTestPercentage.setDependencies(setClassB_SymbolVisibility, ["CLASSB_CLOCK_TEST_OPT"])
    
    # Clock test duration
    classb_ClockTestDuration = classBComponent.createIntegerSymbol("CLASSB_CLOCK_TEST_DURATION", classB_UseClockTest)
    classb_ClockTestDuration.setLabel("Clock Test Duration (ms)")
    classb_ClockTestDuration.setDefaultValue(5)
    classb_ClockTestDuration.setVisible(False)
    classb_ClockTestDuration.setMin(5)
    classb_ClockTestDuration.setMax(20)
    classb_ClockTestDuration.setDependencies(setClassB_SymbolVisibility, ["CLASSB_CLOCK_TEST_OPT"])
    
    # Insert Interrupt test
    classB_UseInterTest = classBComponent.createBooleanSymbol("CLASSB_INTERRUPT_TEST_OPT", classBMenu)
    classB_UseInterTest.setLabel("Test Interrupts?")
    classB_UseInterTest.setVisible(True)
    classB_UseInterTest.setDefaultValue(False)
    classB_UseInterTest.setDescription("This self-test check interrupts operation with the help of NVIC, RTC and TC0")
    
    
    classBReadOnlyParams = classBComponent.createMenuSymbol("CLASSB_ADDR_MENU", None)
    classBReadOnlyParams.setLabel("Build parameters (read-only) used by the library")
    
    # Read-only symbol for start of non-reserved SRAM
    classb_AppRam_start = classBComponent.createHexSymbol("CLASSB_SRAM_APP_START", classBReadOnlyParams)
    classb_AppRam_start.setLabel("Start address of non-reserved SRAM")
    classb_AppRam_start.setDefaultValue(0x20000400)
    classb_AppRam_start.setReadOnly(True)
    classb_AppRam_start.setMin(0x20000400)
    classb_AppRam_start.setMax(0x20000400)
    classb_AppRam_start.setDescription("Initial 1kB of SRAM is used by the Class B library")
    
    #SRAM last word address
    classB_SRAM_lastWordAddr = classBComponent.createHexSymbol("CLASSB_SRAM_LASTWORD_ADDR", classBReadOnlyParams)
    classB_SRAM_lastWordAddr.setLabel("Address of the last word in SRAM")
    classB_SRAM_lastWordAddr.setReadOnly(True)
    classB_SRAM_lastWordAddr.setDefaultValue((0x20000000 + classB_SRAM_SIZE.getValue() - 4))
    classB_SRAM_lastWordAddr.setMin((0x20000000 + classB_SRAM_SIZE.getValue() - 4))
    classB_SRAM_lastWordAddr.setMax((0x20000000 + classB_SRAM_SIZE.getValue() - 4))
    sram_top = hex(classB_SRAM_lastWordAddr.getValue() + 4)
    classB_SRAM_lastWordAddr.setDescription("The SRAM memory address range is 0x20000000 to " + str(sram_top))
    
    # Read-only symbol for CRC-32 polynomial
    classb_FlashCRCPoly = classBComponent.createHexSymbol("CLASSB_FLASH_CRC32_POLY", classBReadOnlyParams)
    classb_FlashCRCPoly.setLabel("CRC-32 polynomial for Flash test")
    classb_FlashCRCPoly.setDefaultValue(0xEDB88320)
    classb_FlashCRCPoly.setReadOnly(True)
    classb_FlashCRCPoly.setMin(0xEDB88320)
    classb_FlashCRCPoly.setMax(0xEDB88320)
    classb_FlashCRCPoly.setDescription("The CRC-32 polynomial used for Flash self-test is " + str(hex(classb_FlashCRCPoly.getValue())))
    
    # Read-only symbol for max SysTick count
    classb_SysTickMaxCount = classBComponent.createHexSymbol("CLASSB_SYSTICK_MAXCOUNT", classBReadOnlyParams)
    classb_SysTickMaxCount.setLabel("Maximum SysTick count")
    classb_SysTickMaxCount.setDefaultValue(0xFFFFFF)
    classb_SysTickMaxCount.setReadOnly(True)
    classb_SysTickMaxCount.setMin(0xFFFFFF)
    classb_SysTickMaxCount.setMax(0xFFFFFF)
    classb_SysTickMaxCount.setDescription("The SysTick is a 24-bit counter with max count value " + str(hex(classb_SysTickMaxCount.getValue())))
    
    # Read-only symbol for max CPU clock frequency
    classb_CPU_MaxClock = classBComponent.createIntegerSymbol("CLASSB_CPU_MAX_CLOCK", classBReadOnlyParams)
    classb_CPU_MaxClock.setLabel("Maximum CPU clock frequency")
    classb_CPU_MaxClock.setDefaultValue(120000000)
    classb_CPU_MaxClock.setReadOnly(True)
    classb_CPU_MaxClock.setMin(120000000)
    classb_CPU_MaxClock.setMax(120000000)
    classb_CPU_MaxClock.setDescription("The self-test for CPU clock frequency assumes that the maximum CPU clock frequency is " + str(classb_CPU_MaxClock.getValue()) + "Hz")
    
    # Read-only symbol for expected RTC clock frequency
    classb_RTC_Clock = classBComponent.createIntegerSymbol("CLASSB_RTC_EXPECTED_CLOCK", classBReadOnlyParams)
    classb_RTC_Clock.setLabel("Expected RTC clock frequency")
    classb_RTC_Clock.setDefaultValue(32768)
    classb_RTC_Clock.setReadOnly(True)
    classb_RTC_Clock.setMin(32768)
    classb_RTC_Clock.setMax(32768)
    classb_RTC_Clock.setDescription("The self-test for CPU clock frequency expects the RTC clock frequency to be " + str(classb_RTC_Clock.getValue()) + "Hz")
    
    # Read-only symbol for maximum configurable accuracy for CPU clock self-test
    classb_MaxAccuracy = classBComponent.createIntegerSymbol("CLASSB_CPU_CLOCK_TEST_ACCUR", classBReadOnlyParams)
    classb_MaxAccuracy.setLabel("Maximum accuracy for CPU clock test")
    classb_MaxAccuracy.setDefaultValue(5)
    classb_MaxAccuracy.setReadOnly(True)
    classb_MaxAccuracy.setMin(5)
    classb_MaxAccuracy.setMax(5)
    classb_MaxAccuracy.setDescription("Error percentage selected for CPU clock frequency test must be " + str(classb_MaxAccuracy.getValue()) + "% or higher")
    
        
############################################################################
#### Code Generation ####
############################################################################

    # Main Header File
    classBHeaderFile = classBComponent.createFileSymbol("CLASSB_HEADER", None)
    classBHeaderFile.setSourcePath("/templates/classb.h.ftl")
    classBHeaderFile.setOutputName("classb.h")
    classBHeaderFile.setDestPath("/classb/src")
    classBHeaderFile.setProjectPath("config/" + configName + "/classb/src")
    classBHeaderFile.setType("HEADER")
    classBHeaderFile.setMarkup(True)
    
    # Main Source File
    classBSourceFile = classBComponent.createFileSymbol("CLASSB_SOURCE", None)
    classBSourceFile.setSourcePath("/templates/classb.c.ftl")
    classBSourceFile.setOutputName("classb.c")
    classBSourceFile.setMarkup(True)
    classBSourceFile.setDestPath("/classb/src")
    classBSourceFile.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceFile.setType("SOURCE")
    
    
    # Header File common for all tests
    classBCommHeaderFile = classBComponent.createFileSymbol("CLASSB_COMMON_HEADER", None)
    classBCommHeaderFile.setSourcePath("/src/classb_common.h")
    classBCommHeaderFile.setOutputName("classb_common.h")
    classBCommHeaderFile.setDestPath("/classb/src")
    classBCommHeaderFile.setProjectPath("config/" + configName +"/classb/src/")
    classBCommHeaderFile.setType("HEADER")
    
    # Source File for result handling
    classBSourceResultMgmt = classBComponent.createFileSymbol("CLASSB_SOURCE_RESULT_MGMT_S", None)
    classBSourceResultMgmt.setSourcePath("/src/classb_result_management.S")
    classBSourceResultMgmt.setOutputName("classb_result_management.S")
    classBSourceResultMgmt.setDestPath("/classb/src")
    classBSourceResultMgmt.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceResultMgmt.setType("SOURCE")

    # Source File for CPU test
    classBSourceCpuTestAsm = classBComponent.createFileSymbol("CLASSB_SOURCE_CPUTEST_S", None)
    classBSourceCpuTestAsm.setSourcePath("/src/classb_cpu_reg_test.S")
    classBSourceCpuTestAsm.setOutputName("classb_cpu_reg_test.S")
    classBSourceCpuTestAsm.setDestPath("/classb/src")
    classBSourceCpuTestAsm.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceCpuTestAsm.setType("SOURCE")
    
    # Header File for CPU test
    classBHeaderCpuTestAsm = classBComponent.createFileSymbol("CLASSB_HEADER_CPU_TEST", None)
    classBHeaderCpuTestAsm.setSourcePath("/src/classb_cpu_reg_test.h")
    classBHeaderCpuTestAsm.setOutputName("classb_cpu_reg_test.h")
    classBHeaderCpuTestAsm.setDestPath("/classb/src")
    classBHeaderCpuTestAsm.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderCpuTestAsm.setType("HEADER")
    
    # Source File for CPU PC test
    classBSourceCpuPCTest = classBComponent.createFileSymbol("CLASSB_SOURCE_CPUPC_TEST", None)
    classBSourceCpuPCTest.setSourcePath("/src/classb_cpu_pc_test.c")
    classBSourceCpuPCTest.setOutputName("classb_cpu_pc_test.c")
    classBSourceCpuPCTest.setDestPath("/classb/src")
    classBSourceCpuPCTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceCpuPCTest.setType("SOURCE")
    
    # Source File for SRAM test
    classBSourceSRAMTest = classBComponent.createFileSymbol("CLASSB_SOURCE_SRAM_TEST", None)
    classBSourceSRAMTest.setSourcePath("/templates/classb_sram_test.c.ftl")
    classBSourceSRAMTest.setOutputName("classb_sram_test.c")
    classBSourceSRAMTest.setMarkup(True)
    classBSourceSRAMTest.setDestPath("/classb/src")
    classBSourceSRAMTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceSRAMTest.setType("SOURCE")
    
    # Header File for SRAM test
    classBHeaderSRAMTest = classBComponent.createFileSymbol("CLASSB_HEADER_SRAM_TEST", None)
    classBHeaderSRAMTest.setSourcePath("/templates/classb_sram_test.h.ftl")
    classBHeaderSRAMTest.setMarkup(True)
    classBHeaderSRAMTest.setOutputName("classb_sram_test.h")
    classBHeaderSRAMTest.setDestPath("/classb/src")
    classBHeaderSRAMTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderSRAMTest.setType("HEADER")
    
    # Source File for Flash test
    classBSourceFLASHTest = classBComponent.createFileSymbol("CLASSB_SOURCE_FLASH_TEST", None)
    classBSourceFLASHTest.setSourcePath("/templates/classb_flash_test.c.ftl")
    classBSourceFLASHTest.setMarkup(True)
    classBSourceFLASHTest.setOutputName("classb_flash_test.c")
    classBSourceFLASHTest.setDestPath("/classb/src")
    classBSourceFLASHTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceFLASHTest.setType("SOURCE")
    
    # Header File for Flash test
    classBHeaderFLASHTest = classBComponent.createFileSymbol("CLASSB_HEADER_FLASH_TEST", None)
    classBHeaderFLASHTest.setSourcePath("/src/classb_flash_test.h")
    classBHeaderFLASHTest.setOutputName("classb_flash_test.h")
    classBHeaderFLASHTest.setDestPath("/classb/src")
    classBHeaderFLASHTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderFLASHTest.setType("HEADER")
    
    # Source File for Clock test
    classBSourceClockTest = classBComponent.createFileSymbol("CLASSB_SOURCE_CLOCK_TEST", None)
    classBSourceClockTest.setSourcePath("/templates/classb_clock_test.c.ftl")
    classBSourceClockTest.setOutputName("classb_clock_test.c")
    classBSourceClockTest.setDestPath("/classb/src")
    classBSourceClockTest.setMarkup(True)
    classBSourceClockTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceClockTest.setType("SOURCE")
    
    # Header File for Clock test
    classBHeaderClockTest = classBComponent.createFileSymbol("CLASSB_HEADER_CLOCK_TEST", None)
    classBHeaderClockTest.setSourcePath("/src/classb_clock_test.h")
    classBHeaderClockTest.setOutputName("classb_clock_test.h")
    classBHeaderClockTest.setDestPath("/classb/src")
    classBHeaderClockTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderClockTest.setType("HEADER")
    
    # Source File for Interrupt test
    classBSourceInterruptTest = classBComponent.createFileSymbol("CLASSB_SOURCE_INTERRUPT_TEST", None)
    classBSourceInterruptTest.setSourcePath("/src/classb_interrupt_test.c")
    classBSourceInterruptTest.setOutputName("classb_interrupt_test.c")
    classBSourceInterruptTest.setDestPath("/classb/src")
    classBSourceInterruptTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceInterruptTest.setType("SOURCE")
    
    # Header File for Interrupt test
    classBHeaderInterruptTest = classBComponent.createFileSymbol("CLASSB_HEADER_INTERRUPT_TEST", None)
    classBHeaderInterruptTest.setSourcePath("/src/classb_interrupt_test.h")
    classBHeaderInterruptTest.setOutputName("classb_interrupt_test.h")
    classBHeaderInterruptTest.setDestPath("/classb/src")
    classBHeaderInterruptTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderInterruptTest.setType("HEADER")
    
    # Source File for IO pin test
    classBSourceIOpinTest = classBComponent.createFileSymbol("CLASSB_SOURCE_IOPIN_TEST", None)
    classBSourceIOpinTest.setSourcePath("/src/classb_io_pin_test.c")
    classBSourceIOpinTest.setOutputName("classb_io_pin_test.c")
    classBSourceIOpinTest.setDestPath("/classb/src")
    classBSourceIOpinTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceIOpinTest.setType("SOURCE")
    
    # Header File for IO pin test
    classBHeaderIOpinTest = classBComponent.createFileSymbol("CLASSB_HEADER_IOPIN_TEST", None)
    classBHeaderIOpinTest.setSourcePath("/src/classb_io_pin_test.h")
    classBHeaderIOpinTest.setOutputName("classb_io_pin_test.h")
    classBHeaderIOpinTest.setDestPath("/classb/src")
    classBHeaderIOpinTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderIOpinTest.setType("HEADER")
    
    # System Definition
    classBSystemDefFile = classBComponent.createFileSymbol("CLASSB_SYS_DEF", None)
    classBSystemDefFile.setType("STRING")
    classBSystemDefFile.setOutputName("core.LIST_SYSTEM_DEFINITIONS_H_INCLUDES")
    classBSystemDefFile.setSourcePath("/templates/system/definitions.h.ftl")
    classBSystemDefFile.setMarkup(True)

    # Linker option to reserve 1kB of SRAM
    classB_xc32ld_reserve_sram = classBComponent.createSettingSymbol("CLASSB_XC32LD_RESERVE_SRAM", None)
    classB_xc32ld_reserve_sram.setCategory("C32-LD")
    classB_xc32ld_reserve_sram.setKey("appendMe")
    classB_xc32ld_reserve_sram.setValue("-DRAM_ORIGIN=0x20000400"+",-DRAM_LENGTH=" + hex(classB_SRAM_SIZE.getValue() - 1024))
    classB_xc32ld_reserve_sram.setAppend(True, ";")
    
    