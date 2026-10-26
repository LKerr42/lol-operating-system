[bits 32]

SIZEOF_PAGE_TABLE equ 4096

PML4T_ADDR equ 0x1000
PDPT_ADDR equ 0x2000
PDT_ADDR equ 0x3000
PT_ADDR equ 0x4000

; the page table only uses certain parts of the actual address
PT_ADDR_MASK equ 0xFFFFF000
PT_PRESENT equ 1                 ; marks the entry as in use
PT_READABLE equ 2                ; marks the entry as r/w

ENTRIES_PER_PT equ 512
SIZEOF_PT_ENTRY equ 8
PAGE_SIZE equ 0x1000

CR4_PAE_ENABLE equ 1 << 5

EFER_MSR equ 0xC0000080
EFER_LM_ENABLE equ 1 << 8

CODE_SEG_64 equ gdt_code_64 - gdt_start
DATA_SEG_64 equ gdt_data_64 - gdt_start

protected_mode_main:
    mov ax, DATA_SEG_32
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000		; 32 bit stack base pointer
	mov esp, ebp

    mov edi, 0xB8000 ; set printing dest

    mov esi, load_message
    call print_string
    call cursor_to_newline

    call cpuid_check

    call set_pages

    mov esi, msg_page
    call print_string
    call cursor_to_newline

    ; finally, move to long mode

    ; disable IRQs
    mov al, 0xFF
    out 0xA1, al
    out 0x21, al

    mov esi, msg_IRQs
    call print_string
    call cursor_to_newline

    nop
    nop

    lidt [IDT]

    ; set PAE and PGE bit
    mov eax, cr4
    or eax, CR4_PAE_ENABLE
    mov cr4, eax

    push edi

    mov edi, PML4T_ADDR
    mov cr3, edi

    pop edi

    mov esi, msg_PAE
    call print_string
    call cursor_to_newline

    ; read from the EFER MSR
    mov ecx, EFER_MSR
    rdmsr

    ; set the LME bit
    or eax, EFER_LM_ENABLE
    wrmsr

    mov esi, msg_LME
    call print_string
    call cursor_to_newline

    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax

    mov esi, msg_jump
    call print_string
    call cursor_to_newline

    cli 
    ; lgdt [gdt_descriptor]

    jmp CODE_SEG_64:_long_mode_main

    .hang:
        hlt
        jmp .hang

set_pages:
    push edi

    ; Clear all four 4 KiB tables
    mov edi, PML4T_ADDR
    mov cr3, edi

    xor eax, eax
    mov ecx, (SIZEOF_PAGE_TABLE * 4) / 4

    cld
    rep stosd

    mov edi, cr3

    ; PML4[0] -> PDPT
    mov DWORD [edi], PDPT_ADDR & PT_ADDR_MASK | PT_PRESENT | PT_READABLE

    ; PDPT[0] -> PDT
    mov edi, PDPT_ADDR
    mov DWORD [edi], PDT_ADDR & PT_ADDR_MASK | PT_PRESENT | PT_READABLE

    ; PDT[0] -> PT
    mov edi, PDT_ADDR
    mov DWORD [edi], PT_ADDR & PT_ADDR_MASK | PT_PRESENT | PT_READABLE

    ; Fill PT
    mov edi, PT_ADDR
    mov ebx, PT_PRESENT | PT_READABLE
    mov ecx, ENTRIES_PER_PT

    .set_entry:
        mov DWORD [edi], ebx
        add ebx, PAGE_SIZE
        add edi, SIZEOF_PT_ENTRY
        loop .set_entry

    pop edi
    ret

cpuid_check:
    pushfd
    pop eax
    mov ecx, eax

    xor eax, 0x00200000 ; flip bit 21
    push eax
    popfd

    pushfd
    pop eax

    push ecx
    popfd

    xor eax, ecx
    and eax, 0x00200000 ; isolate bit 21

    test eax, eax

    jnz .passed

    jmp .no_long_mode

    .passed:
        mov eax, 0x80000000
        cpuid

        cmp eax, 0x80000001
        jb .no_long_mode

        mov eax, 0x80000001
        cpuid

        test edx, 0x20000000
        jz .no_long_mode

        mov esi, cpuid_msg
        call print_string
        call cursor_to_newline

        ret
    .no_long_mode:
        jmp $

print_string:  
    ; pusha
    push ax
    mov ah, 0x0F

    .loop:
        ; put char into al and test if its the null terminator
        mov al, [esi]
        cmp al, 0
        je .done

        ; send char at location stored in edi to screen  
        mov [edi], ax

        ; increment esi and edi
        inc esi
        add edi, 2

        jmp .loop
    .done:
        ; popa
        pop ax
        ret

cursor_to_newline:
    push eax
    push ebx
    push edx
    
    xor edx, edx
    mov eax, edi
    sub eax, 0xB8000
    mov ebx, 160

    div ebx

    mov eax, 160

    sub eax, edx

    add edi, eax

    pop edx
    pop ebx
    pop eax

    ret

IDT:
    .Length:       dw 0
    .Base:         dd 0

load_message: db "Loaded protected mode...", 0
cpuid_msg: db "Long mode is supported", 0
msg_page: db "pages created ", 0
msg_PAE: db "PAE enabled ", 0
msg_IRQs: db "IRQs disabled ", 0
msg_LME: db "EFER LME enabled ", 0
msg_jump: db "about to jump ", 0