CC := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy
SIZE := arm-none-eabi-size

ARCH_FLAGS := -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard
DEFS := -DSTM32L476xx
INCS := -I../vendor/cmsis_core -I../vendor/cmsis_device_l4 -Iinc
WARN_FLAGS := -Wall -Wextra
OPT_FLAGS := -Og -g3
CODEGEN_FLAGS := -ffreestanding -fno-common -ffunction-sections -fdata-sections
CFLAGS := $(ARCH_FLAGS) $(DEFS) $(INCS) $(WARN_FLAGS) $(OPT_FLAGS) -std=c11

LDSCRIPT := ../ld/STM32L476RGTX_FLASH.ld
LDFLAGS := $(ARCH_FLAGS) -T$(LDSCRIPT) --specs=nano.specs --specs=nosys.specs -Wl,--gc-sections -Wl,-Map=build/blinky.map -Wl,--print-memory-usage

all: build/blinky.bin

build/startup/startup_stm32l476xx.o: ../startup/startup_stm32l476xx.s
	mkdir -p build/startup/
	$(CC) $(CFLAGS) -c $< -o $@

build/startup/system_stm32l4xx.o: ../startup/system_stm32l4xx.c
	mkdir -p build/startup/
	$(CC) $(CFLAGS) -c $< -o $@

build/local/main.o: src/main.c
	mkdir -p build/local/
	$(CC) $(CFLAGS) -c $< -o $@

build/blinky.elf: build/local/main.o build/startup/startup_stm32l476xx.o build/startup/system_stm32l4xx.o
	$(CC) $(LDFLAGS) $^ -o $@

build/blinky.bin: build/blinky.elf
	$(OBJCOPY) -O binary $< $@
	
flash: build/blinky.elf
	openocd -f board/st_nucleo_l4.cfg -c "program $< verify reset exit"

clean:
	rm -rf build/

