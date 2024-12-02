/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLEs7VjZ.aml, Mon Aug 19 17:53:20 2024
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000171 (369)
 *     Revision         0x02
 *     Checksum         0xB3
 *     OEM ID           "BLPZ"
 *     OEM Table ID     "I2C1"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "BLPZ", "I2C1", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.I2C1.TPL1, DeviceObj)
    External (_SB_.PCI0.I2C1.TPL1.SBFG, IntObj)
    External (_SB_.PCI0.I2C1.TPL1.SBFH, IntObj)
    External (_SB_.PCI0.I2C1.TPL1.SBFI, IntObj)
    External (_SB_.PCI0.I2C1.TPL1.XCRS, IntObj)
    External (OSYS, FieldUnitObj)
    External (SBFI, IntObj)
    External (SDM1, FieldUnitObj)

    Scope (_SB.PCI0.I2C1)
    {
        If (_OSI ("Darwin"))
        {
            Name (SSCN, Package (0x03)
            {
                0x01B0, 
                0x01FB, 
                0x1E
            })
            Name (FMCN, Package (0x03)
            {
                0x48, 
                0xA0, 
                0x1E
            })
        }
    }

    Scope (_SB.PCI0.I2C1.TPL1)
    {
        Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
        {
            If (_OSI ("Darwin"))
            {
                Return (ConcatenateResTemplate (SBFH, SBFG))
            }
            Else
            {
                If ((OSYS < 0x07DC))
                {
                    Return (SBFI) /* External reference */
                }

                If ((SDM1 == Zero))
                {
                    Return (ConcatenateResTemplate (SBFH, SBFG))
                }

                Return (ConcatenateResTemplate (SBFH, SBFI))
            }
        }
    }
}

