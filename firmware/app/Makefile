TARGET := blinky
BUILD  := build

CC      := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy
SIZE    := arm-none-eabi-size

CPU := -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard

INCS := -Ivendor/cmsis_core -Ivendor/cmsis_device_l4 -Iinc
DEFS := -DSTM32L476xx

CFLAGS := $(CPU) $(DEFS) $(INCS) -Wall -Wextra -g3 -O0 -ffreestanding -fno-common -ffunction-sections -fdata-sections -MMD -MP

# instead of -nostdlib, we just use --specs=nano.specs and --specs=nosys.specs
#
# make sure to not use malloc anywhere in the project and
# don't use printf in the bootloader
#
# in future weeks, maybe 6 weeks from now, consider the bootloader size and flash
# layout. If newlib brings in too much data, we should switch only the bootloader
# to -nostdlib and then we write memcpy, memset, and mcmcmp ourselves. And also
# keep nano.specs for the application.
LDSCRIPT := linker/STM32L476RGTX_FLASH.ld
LDFLAGS  := $(CPU) -T$(LDSCRIPT) --specs=nano.specs --specs=nosys.specs -Wl,--gc-sections -Wl,-Map=$(BUILD)/$(TARGET).map

# note that src/system_stm32l4xx.c should be stripped to the minimal in the future probably
SRCS := src/startup_stm32l476xx.s src/system_stm32l4xx.c src/main.c
OBJS := $(SRCS:%.c=$(BUILD)/%.o)
OBJS := $(OBJS:%.s=$(BUILD)/%.o)

all: $(BUILD)/$(TARGET).bin

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/%.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@
	$(SIZE) $@

$(BUILD)/$(TARGET).bin: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

flash: $(BUILD)/$(TARGET).elf
	openocd -f board/st_nucleo_l4.cfg -c "program $< verify reset exit"

clean:
	rm -rf $(BUILD)

.PHONY: all flash clean

-include $(OBJS:.o=.d)
