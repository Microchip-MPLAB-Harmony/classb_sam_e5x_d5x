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
    classBMenu.setLabel("Class B Starup Configuration")
    
    execfile(Module.getPath() +"/config/interface.py")
    
    #Device params
    classBFlashNode = ATDF.getNode("/avr-tools-device-file/devices/device/address-spaces/address-space/memory-segment@[name=\"FLASH\"]")
    if classBFlashNode != None:
        #Flash size
        classB_FLASH_SIZE = classBComponent.createIntegerSymbol("CLASSB_FLASH_SIZE", None)
        classB_FLASH_SIZE.setVisible(False)
        classB_FLASH_SIZE.setDefaultValue(int(classBFlashNode.getAttribute("size"), 16))
        
    # Enable FPU register test
    classB_FPU_Option = classBComponent.createBooleanSymbol("CLASSB_FPU_OPT", classBMenu)
    classB_FPU_Option.setLabel("Enable FPU test")
    classB_FPU_Option.setVisible(True)
    classB_FPU_Option.setDefaultValue(False)
    
    # Select March algorithm for SRAM test
    classb_Ram_marchAlgo = classBComponent.createKeyValueSetSymbol("CLASSB_SRAM_MARCH_ALGORITHM", classBMenu)
    classb_Ram_marchAlgo.setLabel("Select RAM March algorithm")
    classb_Ram_marchAlgo.addKey("CLASSB_SRAM_MARCH_C", "0", "March C")
    classb_Ram_marchAlgo.addKey("CLASSB_SRAM_MARCH_C_MINUS", "1", "March C minus")
    classb_Ram_marchAlgo.addKey("CLASSB_SRAM_MARCH_B", "2", "March B")
    classb_Ram_marchAlgo.setOutputMode("Key")
    classb_Ram_marchAlgo.setDisplayMode("Description")
    classb_Ram_marchAlgo.setDescription("Selects the SRAM March algorithm to be used during startup")
    classb_Ram_marchAlgo.setDefaultValue(0)
    
    # CRC-32 checksum availability
    classB_FlashCRC_Option = classBComponent.createBooleanSymbol("CLASSB_FLASH_CRC_CONF", classBMenu)
    classB_FlashCRC_Option.setLabel("Read CRC-32 value from Flash?")
    classB_FlashCRC_Option.setVisible(True)
    classB_FlashCRC_Option.setDefaultValue(False)
    classB_FlashCRC_Option.setDescription("Enable this option if the CRC-32 checksum of the application image is stored at a spefic address in the Flash")
    
    # Address at which CRC-32 of the application image is stored
    classB_CRC_address = classBComponent.createIntegerSymbol("CLASSB_FLASHCRC_ADDR", classB_FlashCRC_Option)
    classB_CRC_address.setLabel("Flash CRC location")
    classB_CRC_address.setMin(0)
    classB_CRC_address.setMax(classB_FLASH_SIZE.getValue())
    classB_CRC_address.setDefaultValue(0xFE000)
    classB_CRC_address.setVisible(False)
    #This should be enabled based on the above configuration
    classB_CRC_address.setDependencies(setClassB_SymbolVisibility, ["CLASSB_FLASH_CRC_CONF"])
    
    # Insert Clock test
    classB_UseClockTest = classBComponent.createBooleanSymbol("CLASSB_CLOCK_TEST_OPT", classBMenu)
    classB_UseClockTest.setLabel("Test CPU Clock?")
    classB_UseClockTest.setVisible(True)
    classB_UseClockTest.setDefaultValue(False)
    
    # Acceptable CPU clock frequency error at startup
    classb_ClockTestPercentage = classBComponent.createKeyValueSetSymbol("CLASSB_CLOCK_TEST_PERCENT", classBMenu)
    classb_ClockTestPercentage.setLabel("Permitted CPU clock error at startup")
    classb_ClockTestPercentage.addKey("CLASSB_CLOCK_5PERCENT", "5", "5 %")
    classb_ClockTestPercentage.addKey("CLASSB_CLOCK_10PERCENT", "10", "10 %")
    classb_ClockTestPercentage.addKey("CLASSB_CLOCK_15PERCENT", "15", "15 %")
    classb_ClockTestPercentage.setOutputMode("Value")
    classb_ClockTestPercentage.setDisplayMode("Description")
    classb_ClockTestPercentage.setDescription("Selects the permitted CPU clock error at startup")
    classb_ClockTestPercentage.setDefaultValue(0)
    classb_ClockTestPercentage.setVisible(False)
    classb_ClockTestPercentage.setDependencies(setClassB_SymbolVisibility, ["CLASSB_CLOCK_TEST_OPT"])
    
    # Clock test duration
    classb_ClockTestDuration = classBComponent.createIntegerSymbol("CLASSB_CLOCK_TEST_DURATION", classBMenu)
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
    classBSourceSRAMTest.setSourcePath("/src/classb_sram_test.c")
    classBSourceSRAMTest.setOutputName("classb_sram_test.c")
    classBSourceSRAMTest.setDestPath("/classb/src")
    classBSourceSRAMTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceSRAMTest.setType("SOURCE")
    
    # Header File for SRAM test
    classBHeaderSRAMTest = classBComponent.createFileSymbol("CLASSB_HEADER_SRAM_TEST", None)
    classBHeaderSRAMTest.setSourcePath("/src/classb_sram_test.h")
    classBHeaderSRAMTest.setOutputName("classb_sram_test.h")
    classBHeaderSRAMTest.setDestPath("/classb/src")
    classBHeaderSRAMTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderSRAMTest.setType("HEADER")
    
    # Source File for Flash test
    classBSourceFLASHTest = classBComponent.createFileSymbol("CLASSB_SOURCE_FLASH_TEST", None)
    classBSourceFLASHTest.setSourcePath("/src/classb_flash_test.c")
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
    classBSourceClockTest.setSourcePath("/src/classb_clock_test.c")
    classBSourceClockTest.setOutputName("classb_clock_test.c")
    classBSourceClockTest.setDestPath("/classb/src")
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
