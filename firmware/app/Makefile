.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
TARGET:= blinky

CC := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy
SIZE := arm-none-eabi-size

ARCH_FLAGS := -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard
DEFS := -DSTM32L476xx
INCS := -I../vendor/cmsis_core -I../vendor/cmsis_device_l4 -Iinc
WARN_FLAGS := -Wall -Wextra
OPT_FLAGS := -Og -g3
CODEGEN_FLAGS := -ffreestanding -fno-common -ffunction-sections -fdata-sections
CFLAGS := $(ARCH_FLAGS) $(DEFS) $(INCS) $(WARN_FLAGS) $(OPT_FLAGS) $(CODEGEN_FLAGS) -std=c11 -MMD -MP

LDSCRIPT := ../ld/STM32L476RGTX_FLASH.ld
LDFLAGS := $(ARCH_FLAGS) -T$(LDSCRIPT) --specs=nano.specs --specs=nosys.specs -Wl,--gc-sections -Wl,-Map=build/$(TARGET).map -Wl,--print-memory-usage

LOCAL_SRCS := src/main.c
STARTUP_S_SRCS := ../startup/startup_stm32l476xx.s
STARTUP_C_SRCS := ../startup/system_stm32l4xx.c
OBJS := $(LOCAL_SRCS:src/%.c=build/local/%.o) $(STARTUP_S_SRCS:../startup/%.s=build/startup/%.o) $(STARTUP_C_SRCS:../startup/%.c=build/startup/%.o)
# $(info OBJS=[$(OBJS)])

all: build/blinky.bin

build/startup/startup_stm32l476xx.o: $(STARTUP_S_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

build/startup/system_stm32l4xx.o: $(STARTUP_C_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

build/local/main.o: $(LOCAL_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

build/$(TARGET).elf: $(LDSCRIPT) $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

build/$(TARGET).bin: build/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

flash: build/$(TARGET).elf
	openocd -f board/st_nucleo_l4.cfg -c "program $< verify reset exit"

clean:
	rm -rf build/

.PHONY: all clean flash

-include $(OBJS:.o=.d)
