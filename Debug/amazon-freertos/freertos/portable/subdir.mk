################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../amazon-freertos/freertos/portable/heap_4.c \
../amazon-freertos/freertos/portable/port.c 

C_DEPS += \
./amazon-freertos/freertos/portable/heap_4.d \
./amazon-freertos/freertos/portable/port.d 

OBJS += \
./amazon-freertos/freertos/portable/heap_4.o \
./amazon-freertos/freertos/portable/port.o 


# Each subdirectory must supply rules for building sources it contributes
amazon-freertos/freertos/portable/%.o: ../amazon-freertos/freertos/portable/%.c amazon-freertos/freertos/portable/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -std=gnu99 -D__REDLIB__ -DCPU_MKW38A512VFT4 -DCPU_MKW38A512VFT4_cm0plus -DFLEXCAN_WAIT_TIMEOUT=1000 -DfrdmKW38 -DSDK_DEBUGCONSOLE=1 -DCR_INTEGER_PRINTF -DPRINTF_FLOAT_ENABLE=0 -DSDK_DEBUGCONSOLE_UART -D__MCUXPRESSO -D__USE_CMSIS -DDEBUG -DFSL_RTOS_BM -DSDK_OS_BAREMETAL -DFSL_RTOS_FREE_RTOS -DSDK_OS_FREE_RTOS -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\drivers" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\CMSIS" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\source" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\utilities" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\component\uart" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\device" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\component\serial_manager" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\component\lists" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\amazon-freertos\freertos\portable" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\amazon-freertos\include" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer" -I"C:\Users\Usuario1\Documents\MCUXpressoIDE_11.9.0_2144\workspace\frdmkw38_CanBus_Reader_2_flexcan_interrupt_transfer\board" -O0 -fno-common -g3 -gdwarf-4 -Wall -c  -ffunction-sections  -fdata-sections  -ffreestanding  -fno-builtin -fmerge-constants -fmacro-prefix-map="$(<D)/"= -mcpu=cortex-m0plus -mthumb -D__REDLIB__ -fstack-usage -specs=redlib.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-amazon-2d-freertos-2f-freertos-2f-portable

clean-amazon-2d-freertos-2f-freertos-2f-portable:
	-$(RM) ./amazon-freertos/freertos/portable/heap_4.d ./amazon-freertos/freertos/portable/heap_4.o ./amazon-freertos/freertos/portable/port.d ./amazon-freertos/freertos/portable/port.o

.PHONY: clean-amazon-2d-freertos-2f-freertos-2f-portable

