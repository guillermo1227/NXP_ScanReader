/*
 * GENERATED FILE - DO NOT EDIT
 * Copyright 2008-2013 Code Red Technologies Ltd,
 * Copyright 2013-2024 NXP
 * Generated linker script file for MKW38A512xxx4
 * Created from linkscript.ldt by FMCreateLinkLibraries
 * Using Freemarker v2.3.30
 * MCUXpresso IDE v11.9.0 [Build 2144] [2024-01-05] on 12 nov. 2024 17:25:30
 */

INCLUDE "frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer_Debug_library.ld"
INCLUDE "frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer_Debug_memory.ld"

ENTRY(ResetISR)

SECTIONS
{
     .text_Flash2 : ALIGN(8)
    {
       FILL(0xff)
        *(.text_Flash2) /* for compatibility with previous releases */
        *(.text_FLEX_NVM) /* for compatibility with previous releases */
        *(.text.$Flash2)
        *(.text.$FLEX_NVM)
        *(.text_Flash2.*) /* for compatibility with previous releases */
        *(.text_FLEX_NVM.*) /* for compatibility with previous releases */
        *(.text.$Flash2.*)
        *(.text.$FLEX_NVM.*)
        *(.rodata.$Flash2)
        *(.rodata.$FLEX_NVM)
        *(.rodata.$Flash2.*)
        *(.rodata.$FLEX_NVM.*)            } > FLEX_NVM

    /* MAIN TEXT SECTION */
    .text : ALIGN(8)
    {
        FILL(0xff)
        __vectors_start__ = ABSOLUTE(.) ;
        KEEP(*(.isr_vector))
        /* Global Section Table */
        . = ALIGN(4) ;
        __section_table_start = .;
        __data_section_table = .;
        LONG(LOADADDR(.data));
        LONG(    ADDR(.data));
        LONG(  SIZEOF(.data));
        LONG(LOADADDR(.data_RAM2));
        LONG(    ADDR(.data_RAM2));
        LONG(  SIZEOF(.data_RAM2));
        LONG(LOADADDR(.data_RAM3));
        LONG(    ADDR(.data_RAM3));
        LONG(  SIZEOF(.data_RAM3));
        LONG(LOADADDR(.data_RAM4));
        LONG(    ADDR(.data_RAM4));
        LONG(  SIZEOF(.data_RAM4));
        LONG(LOADADDR(.data_RAM5));
        LONG(    ADDR(.data_RAM5));
        LONG(  SIZEOF(.data_RAM5));
        __data_section_table_end = .;
        __bss_section_table = .;
        LONG(    ADDR(.bss));
        LONG(  SIZEOF(.bss));
        LONG(    ADDR(.bss_RAM2));
        LONG(  SIZEOF(.bss_RAM2));
        LONG(    ADDR(.bss_RAM3));
        LONG(  SIZEOF(.bss_RAM3));
        LONG(    ADDR(.bss_RAM4));
        LONG(  SIZEOF(.bss_RAM4));
        LONG(    ADDR(.bss_RAM5));
        LONG(  SIZEOF(.bss_RAM5));
        __bss_section_table_end = .;
        __section_table_end = . ;
        /* End of Global Section Table */

        *(.after_vectors*)

        /* Kinetis Flash Configuration data */
        . = 0x400 ;
        PROVIDE(__FLASH_CONFIG_START__ = .) ;
        KEEP(*(.FlashConfig))
        PROVIDE(__FLASH_CONFIG_END__ = .) ;
        ASSERT(!(__FLASH_CONFIG_START__ == __FLASH_CONFIG_END__), "Linker Flash Config Support Enabled, but no .FlashConfig section provided within application");
        /* End of Kinetis Flash Configuration data */
        
       *(.text*)
       KEEP(*freertos*/tasks.o(.rodata*)) /* FreeRTOS Debug Config */
       *(.rodata .rodata.* .constdata .constdata.*)
       . = ALIGN(8);
    } > PROGRAM_FLASH
    /*
     * for exception handling/unwind - some Newlib functions (in common
     * with C++ and STDC++) use this.
     */
    .ARM.extab : ALIGN(8)
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > PROGRAM_FLASH

    .ARM.exidx : ALIGN(8)
    {
        __exidx_start = .;
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        __exidx_end = .;
    } > PROGRAM_FLASH
 
    _etext = .;
        
    /* possible MTB section for SRAM1 */
    .mtb_buffer_RAM2 (NOLOAD) :
    {
        KEEP(*(.mtb.$RAM2*))
        KEEP(*(.mtb.$SRAM1*))
    } > SRAM1

    /* DATA section for SRAM1 */

    .data_RAM2 : ALIGN(8)
    {
        FILL(0xff)
        PROVIDE(__start_data_RAM2 = .) ;
        PROVIDE(__start_data_SRAM1 = .) ;
        *(.ramfunc.$RAM2)
        *(.ramfunc.$SRAM1)
        *(.data.$RAM2)
        *(.data.$SRAM1)
        *(.data.$RAM2.*)
        *(.data.$SRAM1.*)
        . = ALIGN(8) ;
        PROVIDE(__end_data_RAM2 = .) ;
        PROVIDE(__end_data_SRAM1 = .) ;
     } > SRAM1 AT>PROGRAM_FLASH

    /* possible MTB section for FLEX_RAM */
    .mtb_buffer_RAM3 (NOLOAD) :
    {
        KEEP(*(.mtb.$RAM3*))
        KEEP(*(.mtb.$FLEX_RAM*))
    } > FLEX_RAM

    /* DATA section for FLEX_RAM */

    .data_RAM3 : ALIGN(8)
    {
        FILL(0xff)
        PROVIDE(__start_data_RAM3 = .) ;
        PROVIDE(__start_data_FLEX_RAM = .) ;
        *(.ramfunc.$RAM3)
        *(.ramfunc.$FLEX_RAM)
        *(.data.$RAM3)
        *(.data.$FLEX_RAM)
        *(.data.$RAM3.*)
        *(.data.$FLEX_RAM.*)
        . = ALIGN(8) ;
        PROVIDE(__end_data_RAM3 = .) ;
        PROVIDE(__end_data_FLEX_RAM = .) ;
     } > FLEX_RAM AT>PROGRAM_FLASH

    /* possible MTB section for WARMBOOT_STACK */
    .mtb_buffer_RAM4 (NOLOAD) :
    {
        KEEP(*(.mtb.$RAM4*))
        KEEP(*(.mtb.$WARMBOOT_STACK*))
    } > WARMBOOT_STACK

    /* DATA section for WARMBOOT_STACK */

    .data_RAM4 : ALIGN(8)
    {
        FILL(0xff)
        PROVIDE(__start_data_RAM4 = .) ;
        PROVIDE(__start_data_WARMBOOT_STACK = .) ;
        *(.ramfunc.$RAM4)
        *(.ramfunc.$WARMBOOT_STACK)
        *(.data.$RAM4)
        *(.data.$WARMBOOT_STACK)
        *(.data.$RAM4.*)
        *(.data.$WARMBOOT_STACK.*)
        . = ALIGN(8) ;
        PROVIDE(__end_data_RAM4 = .) ;
        PROVIDE(__end_data_WARMBOOT_STACK = .) ;
     } > WARMBOOT_STACK AT>PROGRAM_FLASH

    /* possible MTB section for WARMBOOT_CONFIG */
    .mtb_buffer_RAM5 (NOLOAD) :
    {
        KEEP(*(.mtb.$RAM5*))
        KEEP(*(.mtb.$WARMBOOT_CONFIG*))
    } > WARMBOOT_CONFIG

    /* DATA section for WARMBOOT_CONFIG */

    .data_RAM5 : ALIGN(8)
    {
        FILL(0xff)
        PROVIDE(__start_data_RAM5 = .) ;
        PROVIDE(__start_data_WARMBOOT_CONFIG = .) ;
        *(.ramfunc.$RAM5)
        *(.ramfunc.$WARMBOOT_CONFIG)
        *(.data.$RAM5)
        *(.data.$WARMBOOT_CONFIG)
        *(.data.$RAM5.*)
        *(.data.$WARMBOOT_CONFIG.*)
        . = ALIGN(8) ;
        PROVIDE(__end_data_RAM5 = .) ;
        PROVIDE(__end_data_WARMBOOT_CONFIG = .) ;
     } > WARMBOOT_CONFIG AT>PROGRAM_FLASH

    /* MAIN DATA SECTION */
    /* Default MTB section */
    .mtb_buffer_default (NOLOAD) :
    {
        KEEP(*(.mtb*))
    } > SRAM AT > SRAM
    .uninit_RESERVED (NOLOAD) : ALIGN(8)
    {
        _start_uninit_RESERVED = .;
        KEEP(*(.bss.$RESERVED*))
       . = ALIGN(8) ;
        _end_uninit_RESERVED = .;
    } > SRAM AT> SRAM

    /* Main DATA section (SRAM) */
    .data : ALIGN(8)
    {
       FILL(0xff)
       _data = . ;
       PROVIDE(__start_data_RAM = .) ;
       PROVIDE(__start_data_SRAM = .) ;
       *(vtable)
       *(.ramfunc*)
       KEEP(*(CodeQuickAccess))
       KEEP(*(DataQuickAccess))
       *(RamFunction)
       *(.data*)
       . = ALIGN(8) ;
       _edata = . ;
       PROVIDE(__end_data_RAM = .) ;
       PROVIDE(__end_data_SRAM = .) ;
    } > SRAM AT>PROGRAM_FLASH

    /* BSS section for SRAM1 */
    .bss_RAM2 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_bss_RAM2 = .) ;
       PROVIDE(__start_bss_SRAM1 = .) ;
       *(.bss.$RAM2)
       *(.bss.$SRAM1)
       *(.bss.$RAM2.*)
       *(.bss.$SRAM1.*)
       . = ALIGN (. != 0 ? 8 : 1) ; /* avoid empty segment */
       PROVIDE(__end_bss_RAM2 = .) ;
       PROVIDE(__end_bss_SRAM1 = .) ;
    } > SRAM1 AT> SRAM1

    /* BSS section for FLEX_RAM */
    .bss_RAM3 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_bss_RAM3 = .) ;
       PROVIDE(__start_bss_FLEX_RAM = .) ;
       *(.bss.$RAM3)
       *(.bss.$FLEX_RAM)
       *(.bss.$RAM3.*)
       *(.bss.$FLEX_RAM.*)
       . = ALIGN (. != 0 ? 8 : 1) ; /* avoid empty segment */
       PROVIDE(__end_bss_RAM3 = .) ;
       PROVIDE(__end_bss_FLEX_RAM = .) ;
    } > FLEX_RAM AT> FLEX_RAM

    /* BSS section for WARMBOOT_STACK */
    .bss_RAM4 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_bss_RAM4 = .) ;
       PROVIDE(__start_bss_WARMBOOT_STACK = .) ;
       *(.bss.$RAM4)
       *(.bss.$WARMBOOT_STACK)
       *(.bss.$RAM4.*)
       *(.bss.$WARMBOOT_STACK.*)
       . = ALIGN (. != 0 ? 8 : 1) ; /* avoid empty segment */
       PROVIDE(__end_bss_RAM4 = .) ;
       PROVIDE(__end_bss_WARMBOOT_STACK = .) ;
    } > WARMBOOT_STACK AT> WARMBOOT_STACK

    /* BSS section for WARMBOOT_CONFIG */
    .bss_RAM5 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_bss_RAM5 = .) ;
       PROVIDE(__start_bss_WARMBOOT_CONFIG = .) ;
       *(.bss.$RAM5)
       *(.bss.$WARMBOOT_CONFIG)
       *(.bss.$RAM5.*)
       *(.bss.$WARMBOOT_CONFIG.*)
       . = ALIGN (. != 0 ? 8 : 1) ; /* avoid empty segment */
       PROVIDE(__end_bss_RAM5 = .) ;
       PROVIDE(__end_bss_WARMBOOT_CONFIG = .) ;
    } > WARMBOOT_CONFIG AT> WARMBOOT_CONFIG

    /* MAIN BSS SECTION */
    .bss (NOLOAD) : ALIGN(8)
    {
        _bss = .;
        PROVIDE(__start_bss_RAM = .) ;
        PROVIDE(__start_bss_SRAM = .) ;
        *(.bss*)
        *(COMMON)
        . = ALIGN(8) ;
        _ebss = .;
        PROVIDE(__end_bss_RAM = .) ;
        PROVIDE(__end_bss_SRAM = .) ;
        PROVIDE(end = .);
    } > SRAM AT> SRAM

    /* NOINIT section for SRAM1 */
    .noinit_RAM2 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_noinit_RAM2 = .) ;
       PROVIDE(__start_noinit_SRAM1 = .) ;
       *(.noinit.$RAM2)
       *(.noinit.$SRAM1)
       *(.noinit.$RAM2.*)
       *(.noinit.$SRAM1.*)
       . = ALIGN(8) ;
       PROVIDE(__end_noinit_RAM2 = .) ;
       PROVIDE(__end_noinit_SRAM1 = .) ;
    } > SRAM1 AT> SRAM1

    /* NOINIT section for FLEX_RAM */
    .noinit_RAM3 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_noinit_RAM3 = .) ;
       PROVIDE(__start_noinit_FLEX_RAM = .) ;
       *(.noinit.$RAM3)
       *(.noinit.$FLEX_RAM)
       *(.noinit.$RAM3.*)
       *(.noinit.$FLEX_RAM.*)
       . = ALIGN(8) ;
       PROVIDE(__end_noinit_RAM3 = .) ;
       PROVIDE(__end_noinit_FLEX_RAM = .) ;
    } > FLEX_RAM AT> FLEX_RAM

    /* NOINIT section for WARMBOOT_STACK */
    .noinit_RAM4 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_noinit_RAM4 = .) ;
       PROVIDE(__start_noinit_WARMBOOT_STACK = .) ;
       *(.noinit.$RAM4)
       *(.noinit.$WARMBOOT_STACK)
       *(.noinit.$RAM4.*)
       *(.noinit.$WARMBOOT_STACK.*)
       . = ALIGN(8) ;
       PROVIDE(__end_noinit_RAM4 = .) ;
       PROVIDE(__end_noinit_WARMBOOT_STACK = .) ;
    } > WARMBOOT_STACK AT> WARMBOOT_STACK

    /* NOINIT section for WARMBOOT_CONFIG */
    .noinit_RAM5 (NOLOAD) : ALIGN(8)
    {
       PROVIDE(__start_noinit_RAM5 = .) ;
       PROVIDE(__start_noinit_WARMBOOT_CONFIG = .) ;
       *(.noinit.$RAM5)
       *(.noinit.$WARMBOOT_CONFIG)
       *(.noinit.$RAM5.*)
       *(.noinit.$WARMBOOT_CONFIG.*)
       . = ALIGN(8) ;
       PROVIDE(__end_noinit_RAM5 = .) ;
       PROVIDE(__end_noinit_WARMBOOT_CONFIG = .) ;
    } > WARMBOOT_CONFIG AT> WARMBOOT_CONFIG

    /* DEFAULT NOINIT SECTION */
    .noinit (NOLOAD): ALIGN(8)
    {
        _noinit = .;
        PROVIDE(__start_noinit_RAM = .) ;
        PROVIDE(__start_noinit_SRAM = .) ;
       *(NOINIT)
        *(.noinit*)
         . = ALIGN(8) ;
        _end_noinit = .;
       PROVIDE(__end_noinit_RAM = .) ;
       PROVIDE(__end_noinit_SRAM = .) ;        
    } > SRAM AT> SRAM

    /* Reserve and place Heap within memory map */
    _HeapSize = 0xbf8;
    .heap (NOLOAD) :  ALIGN(8)
    {
        _pvHeapStart = .;
        . += _HeapSize;
        . = ALIGN(8);
        _pvHeapLimit = .;
    } > SRAM

     _StackSize = 0xbf8;
     /* Reserve space in memory for Stack */
    .heap2stackfill (NOLOAD) :
    {
        . += _StackSize;
    } > SRAM
    /* Locate actual Stack in memory map */
    .stack ORIGIN(SRAM) + LENGTH(SRAM) - _StackSize - 0 (NOLOAD) :  ALIGN(8)
    {
        _vStackBase = .;
        . = ALIGN(8);
        _vStackTop = . + _StackSize;
    } > SRAM

    /* Provide basic symbols giving location and size of main text
     * block, including initial values of RW data sections. Note that
     * these will need extending to give a complete picture with
     * complex images (e.g multiple Flash banks).
     */
    _image_start = LOADADDR(.text);
    _image_end = LOADADDR(.data) + SIZEOF(.data);
    _image_size = _image_end - _image_start;
}