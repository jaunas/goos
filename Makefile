C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

all: os-image.bin

os-image.bin: boot/boot_sector.bin kernel/kernel.bin
	cat $^ > $@

kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary -melf_i386

%.o: %.c ${HEADERS}
	gcc -ffreestanding -march=i386 -m32 -fno-pie -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	$(RM) boot/*.bin kernel/*.bin kernel/*.o drivers/*.o os-image.bin
