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

#Update CRC write option visibility
def setClassB_CRCwriteVisibility(MySymbol, event):
    symObj = event["symbol"]
    if symObj.getValue() == True:
        MySymbol.setVisible(False)
    else:
        MySymbol.setVisible(True)
        
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
    
    classB_CRC_address = classBComponent.createIntegerSymbol("CLASSB_FLASHCRC_ADDR", classB_FlashCRC_Option)
    classB_CRC_address.setLabel("Flash CRC location")
    classB_CRC_address.setMin(0)
    classB_CRC_address.setMax(classB_FLASH_SIZE.getValue())
    classB_CRC_address.setDefaultValue(0xFE000)
    classB_CRC_address.setVisible(False)
    #This should be enabled based on the above configuration
    classB_CRC_address.setDependencies(setClassB_SymbolVisibility, ["CLASSB_FLASH_CRC_CONF"])

    
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
    
    # Main Soure File
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
    
    # Soure File for result handling
    classBSourceResultMgmt = classBComponent.createFileSymbol("CLASSB_SOURCE_RESULT_MGMT_S", None)
    classBSourceResultMgmt.setSourcePath("/src/classb_result_management.S")
    classBSourceResultMgmt.setOutputName("classb_result_management.S")
    classBSourceResultMgmt.setDestPath("/classb/src")
    classBSourceResultMgmt.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceResultMgmt.setType("SOURCE")

    # Soure File for CPU test
    classBSourceCpuTestAsm = classBComponent.createFileSymbol("CLASSB_SOURCE_CPUTEST_S", None)
    classBSourceCpuTestAsm.setSourcePath("/src/classb_cpu_reg_test.S")
    classBSourceCpuTestAsm.setOutputName("classb_cpu_reg_test.S")
    classBSourceCpuTestAsm.setDestPath("/classb/src")
    classBSourceCpuTestAsm.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceCpuTestAsm.setType("SOURCE")
    
    # Header File for CPU test
    classBHeaderCpuTestAsm = classBComponent.createFileSymbol("CLASSB_CPUTEST_HEADER", None)
    classBHeaderCpuTestAsm.setSourcePath("/src/classb_cpu_reg_test.h")
    classBHeaderCpuTestAsm.setOutputName("classb_cpu_reg_test.h")
    classBHeaderCpuTestAsm.setDestPath("/classb/src")
    classBHeaderCpuTestAsm.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderCpuTestAsm.setType("HEADER")
    
    # Soure File for CPU PC test
    classBSourceCpuPCTest = classBComponent.createFileSymbol("CLASSB_SOURCE_CPUPCTEST", None)
    classBSourceCpuPCTest.setSourcePath("/src/classb_cpu_pc_test.c")
    classBSourceCpuPCTest.setOutputName("classb_cpu_pc_test.c")
    classBSourceCpuPCTest.setDestPath("/classb/src")
    classBSourceCpuPCTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceCpuPCTest.setType("SOURCE")
    
    # Soure File for SRAM test
    classBSourceSRAMTest = classBComponent.createFileSymbol("CLASSB_SOURCE_SRAMTEST", None)
    classBSourceSRAMTest.setSourcePath("/src/classb_sram_test.c")
    classBSourceSRAMTest.setOutputName("classb_sram_test.c")
    classBSourceSRAMTest.setDestPath("/classb/src")
    classBSourceSRAMTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceSRAMTest.setType("SOURCE")
    
    # Header File for SRAM test
    classBHeaderSRAMTest = classBComponent.createFileSymbol("CLASSB_SRAMTEST_HEADER", None)
    classBHeaderSRAMTest.setSourcePath("/src/classb_sram_test.h")
    classBHeaderSRAMTest.setOutputName("classb_sram_test.h")
    classBHeaderSRAMTest.setDestPath("/classb/src")
    classBHeaderSRAMTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderSRAMTest.setType("HEADER")
    
    # Soure File for Flash test
    classBSourceFLASHTest = classBComponent.createFileSymbol("CLASSB_SOURCE_FLASHTEST", None)
    classBSourceFLASHTest.setSourcePath("/src/classb_flash_test.c")
    classBSourceFLASHTest.setOutputName("classb_flash_test.c")
    classBSourceFLASHTest.setDestPath("/classb/src")
    classBSourceFLASHTest.setProjectPath("config/" + configName + "/classb/src/")
    classBSourceFLASHTest.setType("SOURCE")
    
    # Header File for Flash test
    classBHeaderFLASHTest = classBComponent.createFileSymbol("CLASSB_FLASHTEST_HEADER", None)
    classBHeaderFLASHTest.setSourcePath("/src/classb_flash_test.h")
    classBHeaderFLASHTest.setOutputName("classb_flash_test.h")
    classBHeaderFLASHTest.setDestPath("/classb/src")
    classBHeaderFLASHTest.setProjectPath("config/" + configName +"/classb/src/")
    classBHeaderFLASHTest.setType("HEADER")
    
    
    # System Definition
    classBSystemDefFile = classBComponent.createFileSymbol("CLASSB_SYS_DEF", None)
    classBSystemDefFile.setType("STRING")
    classBSystemDefFile.setOutputName("core.LIST_SYSTEM_DEFINITIONS_H_INCLUDES")
    classBSystemDefFile.setSourcePath("/templates/system/definitions.h.ftl")
    classBSystemDefFile.setMarkup(True)
