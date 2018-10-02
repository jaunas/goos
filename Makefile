CC = gcc
CFLAGS = -m64 -mcmodel=kernel -ffreestanding -nostdlib -mno-red-zone -fno-pie -c

C_SOURCES = $(wildcard source/kernel/*.c source/drivers/*.c)
HEADERS = $(wildcard source/kernel/*.h source/drivers/*.h)
OBJS = ${C_SOURCES:.c=.o} tools/boot.o source/kernel/kernel.o

ISO := os.iso
OUTPUT := tools/iso/boot/kernel.sys

all: $(ISO)

$(ISO): $(OUTPUT)
	grub-mkrescue -o $@ tools/iso

$(OUTPUT): $(OBJS) tools/linker.ld
	ld -nodefaultlibs -T tools/linker.ld -o $@ $(OBJS)

.s.o:
	nasm -felf64 $< -o $@

source/kernel/kernel.o: source/kernel/kernel.go
	go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o $@ $<

%.o: %.c ${HEADERS}
	$(CC) $(CFLAGS) $< -o $@

clean:
	$(RM) $(OBJS) $(OUTPUT) $(ISO)
