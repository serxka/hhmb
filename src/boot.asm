;;;;;;;;;;;; CODE ;;;;;;;;;;;;

section .boot
[bits 32]
[global _start]
_start:
	cli                       ; Disable Interrupts
	push DWORD 0              ; Pad (64bit)
	push ebx                  ; Push Mutliboot Info Strucutre Location
	push DWORD 0              ; Pad (64bit)
	push eax                  ; Push Multiboot Magic Number
	
	mov eax, _pml4            ; Load CR3 with the PLM4
	mov cr3, eax

	mov eax, cr4
	or eax, 1 << 7 | 1 << 5   ; PGE, PAE
	mov cr4, eax

	mov ecx, 0xC000_0080      ; Read from the EFER MSR
	rdmsr
	or eax, 1 << 11 | 1 << 8  ; Set LME and NXE bits
	wrmsr

	mov eax, cr0              ; Enable Paging
	or eax, 1 << 31 | 1 << 16 ; Paging, WP Supervisor
	mov cr0, eax

	lgdt [_gdt_ptr]           ; Long Mode GDT
	jmp 0x8:_long_mode        ; Long Jump with code selector

[bits 64]
[extern _stack_bottom]
[extern entry]
_long_mode:
	mov ax, 0x10              ; Set data selectors
	mov ds, rax
	mov es, rax
	mov fs, rax
	mov gs, rax
	mov ss, rax

	pop rdi                   ; Magic Number
	pop rsi                   ; Multiboot Pointer
	mov rsp, _stack_bottom    ; Our stack

	call entry                ; Jump into our higher half 64bit kernel entry

.lp:	cli                       ; Halt CPU if we exit for whatever reason
	hlt
	jmp .lp

;;;;;;;;;;;; DATA ;;;;;;;;;;;;

HEADER_FLAGS     equ 1<<0 | 1<<1 | 1<<16 ; Page Boundary, Memory Info, A.OUT Kludge
HEADER_MAGIC     equ 0x1badb002   ; Multiboot Magic
HEADER_CHECKSUM  equ -( HEADER_MAGIC + HEADER_FLAGS )

[extern _bss]
[extern _end]
align 4
_multiboot_hdr:
	dd HEADER_MAGIC
	dd HEADER_FLAGS
	dd HEADER_CHECKSUM
	dd _multiboot_hdr         ; header_addr
	dd _start                 ; load_addr
	dd _bss                   ; load_end_addr
	dd _end                   ; bss_end_addr
	dd _start                 ; entry_addr

; 64bit global descriptor table
_gdt:
	dq 0                      ; Null (required first entry)
	db 0, 0, 0, 0, 0, 10011010b, 10101111b, 0 ; code 0x8
	db 0, 0, 0, 0, 0, 10010010b, 00000000b, 0 ; data 0x10
.end:

_gdt_ptr:
	dw _gdt.end - _gdt - 1    ; The size of the table
	dq _gdt                   ; The base of the table

; Our page tables
align 4096
_pml4:
	dq 0x0000_0000_0010_2003  ; pdpt_low
	dq 510 dup (0)
	dq 0x0000_0000_0010_3003  ; pdpt_high
_pdpt_low:                        ;
	dq 0x0000_0000_0000_0083  ; 0gb virt (1gb sz)
	dq 511 dup (0)
_pdpt_high:                       ; 
	dq 510 dup (0)
	dq 0x0000_0000_0000_0083  ; -2gb virt (1gb sz)
	dq 1 dup (0)

; Page attributes
;    0x003 : R/W, Present
;    0x083 : Page Size, R/W, Present

