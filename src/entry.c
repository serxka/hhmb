#include "types.h"

struct multiboot_info {
	u32 flags;
	u32 mem_lower;
	u32 mem_upper;
	u32 boot_device;
	u32 cmdline;
	u32 mods_count;
	u32 mods_addr;
	struct { u32 a, b, c, d; } _syms;
	u32 mmap_len;
	u32 mmap_addr;
	// Other items, refer to Multiboot spec if needed
};

struct multiboot_memory_map {
	u32 size;
	u32 base_addr_low;
	u32 base_addr_high;
	u32 length_low;
	u32 length_high;
	u32 type;
};

void entry(u32 magic, struct multiboot_info *mb) {

}

