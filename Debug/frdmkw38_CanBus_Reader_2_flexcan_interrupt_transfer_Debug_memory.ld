/*
 * GENERATED FILE - DO NOT EDIT
 * Copyright 2008-2013 Code Red Technologies Ltd,
 * Copyright 2013-2024 NXP
 * Generated linker script file for MKW38A512xxx4
 * Created from memory.ldt by FMCreateLinkMemory
 * Using Freemarker v2.3.30
 * MCUXpresso IDE v11.9.0 [Build 2144] [2024-01-05] on 12 nov. 2024 17:25:30
 */

MEMORY
{
  /* Define each memory region */
  PROGRAM_FLASH (rx) : ORIGIN = 0x0, LENGTH = 0x40000 /* 256K bytes (alias Flash) */  
  FLEX_NVM (rx) : ORIGIN = 0x10000000, LENGTH = 0x40000 /* 256K bytes (alias Flash2) */  
  SRAM (rwx) : ORIGIN = 0x20000008, LENGTH = 0xbff8 /* 49144 bytes (alias RAM) */  
  SRAM1 (rwx) : ORIGIN = 0x1fffc400, LENGTH = 0x3c00 /* 15K bytes (alias RAM2) */  
  FLEX_RAM (rwx) : ORIGIN = 0x14000000, LENGTH = 0x2000 /* 8K bytes (alias RAM3) */  
  WARMBOOT_STACK (rwx) : ORIGIN = 0x1fffc000, LENGTH = 0x400 /* 1K bytes (alias RAM4) */  
  WARMBOOT_CONFIG (rwx) : ORIGIN = 0x20000000, LENGTH = 0x8 /* 8 bytes (alias RAM5) */  
}

  /* Define a symbol for the top of each memory region */
  __base_PROGRAM_FLASH = 0x0  ; /* PROGRAM_FLASH */  
  __base_Flash = 0x0 ; /* Flash */  
  __top_PROGRAM_FLASH = 0x0 + 0x40000 ; /* 256K bytes */  
  __top_Flash = 0x0 + 0x40000 ; /* 256K bytes */  
  __base_FLEX_NVM = 0x10000000  ; /* FLEX_NVM */  
  __base_Flash2 = 0x10000000 ; /* Flash2 */  
  __top_FLEX_NVM = 0x10000000 + 0x40000 ; /* 256K bytes */  
  __top_Flash2 = 0x10000000 + 0x40000 ; /* 256K bytes */  
  __base_SRAM = 0x20000008  ; /* SRAM */  
  __base_RAM = 0x20000008 ; /* RAM */  
  __top_SRAM = 0x20000008 + 0xbff8 ; /* 49144 bytes */  
  __top_RAM = 0x20000008 + 0xbff8 ; /* 49144 bytes */  
  __base_SRAM1 = 0x1fffc400  ; /* SRAM1 */  
  __base_RAM2 = 0x1fffc400 ; /* RAM2 */  
  __top_SRAM1 = 0x1fffc400 + 0x3c00 ; /* 15K bytes */  
  __top_RAM2 = 0x1fffc400 + 0x3c00 ; /* 15K bytes */  
  __base_FLEX_RAM = 0x14000000  ; /* FLEX_RAM */  
  __base_RAM3 = 0x14000000 ; /* RAM3 */  
  __top_FLEX_RAM = 0x14000000 + 0x2000 ; /* 8K bytes */  
  __top_RAM3 = 0x14000000 + 0x2000 ; /* 8K bytes */  
  __base_WARMBOOT_STACK = 0x1fffc000  ; /* WARMBOOT_STACK */  
  __base_RAM4 = 0x1fffc000 ; /* RAM4 */  
  __top_WARMBOOT_STACK = 0x1fffc000 + 0x400 ; /* 1K bytes */  
  __top_RAM4 = 0x1fffc000 + 0x400 ; /* 1K bytes */  
  __base_WARMBOOT_CONFIG = 0x20000000  ; /* WARMBOOT_CONFIG */  
  __base_RAM5 = 0x20000000 ; /* RAM5 */  
  __top_WARMBOOT_CONFIG = 0x20000000 + 0x8 ; /* 8 bytes */  
  __top_RAM5 = 0x20000000 + 0x8 ; /* 8 bytes */  
