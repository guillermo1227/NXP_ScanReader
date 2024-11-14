################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../board/board.c \
../board/clock_config.c \
../board/pin_mux.c 

C_DEPS += \
./board/board.d \
./board/clock_config.d \
./board/pin_mux.d 

OBJS += \
./board/board.o \
./board/clock_config.o \
./board/pin_mux.o 


# Each subdirectory must supply rules for building sources it contributes
board/%.o: ../board/%.c board/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -std=gnu99 -D__REDLIB__ -DCPU_MKW38A512VFT4 -DCPU_MKW38A512VFT4_cm0plus -DFLEXCAN_WAIT_TIMEOUT=1000 -DfrdmKW38 -DSDK_DEBUGCONSOLE=1 -DCR_INTEGER_PRINTF -DPRINTF_FLOAT_ENABLE=0 -DSDK_DEBUGCONSOLE_UART -D__MCUXPRESSO -D__USE_CMSIS -DDEBUG -DFSL_RTOS_BM -DSDK_OS_BAREMETAL -DFSL_RTOS_FREE_RTOS -DSDK_OS_FREE_RTOS -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\drivers" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\CMSIS" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\source" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\utilities" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\component\uart" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\device" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\component\serial_manager" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\component\lists" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\amazon-freertos\freertos\portable" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\amazon-freertos\include" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\board" -O0 -fno-common -g3 -gdwarf-4 -Wall -c  -ffunction-sections  -fdata-sections  -ffreestanding  -fno-builtin -fmerge-constants -fmacro-prefix-map="$(<D)/"= -mcpu=cortex-m0plus -mthumb -D__REDLIB__ -fstack-usage -specs=redlib.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-board

clean-board:
	-$(RM) ./board/board.d ./board/board.o ./board/clock_config.d ./board/clock_config.o ./board/pin_mux.d ./board/pin_mux.o

.PHONY: clean-board

