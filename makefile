OBJS:=entry.o boot.o
OUT:=hhmb

CFLAGS:=--target=x86_64-none-elf -ffreestanding -mno-red-zone -fno-stack-protector -nostdlib -mcmodel=kernel -Isrc
ASFLAGS:=-felf64

CC:=clang
AS:=nasm
LD:=ld.lld

OBJS:=$(addprefix src/,$(OBJS))

all: link

link: $(OBJS)
	$(LD) -T link.lds $(OBJS) -o $(OUT)

clean:
	rm -f $(shell find . -name "*.o")
	rm -f $(shell find . -name "*.d")
	rm -f $(OUT)

run: link
	qemu-system-x86_64 -kernel $(OUT)

%.o: %.c
	$(CC) $(CFLAGS) -c -MD -o $@ $<

%.o: %.asm
	$(AS) $(ASFLAGS) -MD -o $@ $<

.PHONY:=all link clean run

