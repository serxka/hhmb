ENTRY(_start)
SECTIONS
{
	. = 0x100000;

	.boot :
	{
		*(.boot)
	}

	_kernel_vma = 0xffffffff80000000;
	. += _kernel_vma;

	.text ALIGN(4K) : AT (ADDR (.text) - _kernel_vma)
	{
		_text = . - _kernel_vma;
		*(.text .text.*)
	}

	.data ALIGN(4K) : AT (ADDR (.data) - _kernel_vma)
	{
		_data = . - _kernel_vma;
		*(.data .data.*)
		*(.rodata .rodata.*)
	}

	.bss ALIGN(4K) : AT (ADDR (.bss) - _kernel_vma)
	{
		_bss = . - _kernel_vma;
		*(COMMON)
		*(.bss .bss.*)
		_stack_top = .;
		. += 8K;
		_stack_bottom = .;
	}

	_end = . - _kernel_vma;
}

