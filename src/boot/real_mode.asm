ORG 0x7E00  

mmap_entry_count equ 0x0500
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

main:
    mov si, welcome_message
    call print_string

    call obtain_smap
    call display_smap

    call check_a20

    ; load GDT
    cli
    lgdt [gdt_descriptor]

    ; set cr0 to 1
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; finally jump into 32-bit mode
    jmp CODE_SEG:start_protected_mode

    .hang:
        hlt
        jmp .hang

check_a20:
    pushf
    push ds
    push es
    push di
    push si 
    cli

    xor ax, ax
    mov es, ax ; es = 0x0000

    not ax
    mov ds, ax ; ds = 0xFFFF

    mov di, 0x0500
    mov si, 0x0510

    mov al, [es:di]
    push ax
    mov al, [ds:si]
    push ax

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF

    cmp byte [es:di], 0xFF

    pop ax
    mov [ds:si], al
    pop ax
    mov [es:di], al

    ; if equal, a20 must be set
    je .enable_a20

    ; else, finish
    jmp .a20_f

    .enable_a20:
        mov ax, 0x2401
        int 0x15
        jc .error
        cmp ah, 0
        jne .error
        jmp check_a20
    .error:
        mov si, a20_error_msg
        call print_string
        jmp .a20_f
    .a20_f:
        ; check bit
        in al, 0x92
        call print_formatted_hex

        pop si
        pop di
        pop es
        pop ds
        popf
        ret

display_smap:
    pusha
    mov si, memory_map_msg
    call print_string
    mov di, 0x5000
    mov cx, [mmap_entry_count]
print_entries:
    cmp cx, 0
    je end_display_smap

    mov si, base_address_msg
    call print_string
    mov eax, [es:di + 4]
    call print_hex
    mov eax, [es:di]
    call print_hex

    mov si, length_of_region_msg
    call print_string
    mov eax, [es:di + 12]
    call print_hex
    mov eax, [es:di + 8]
    call print_hex

    mov si, type_msg
    call print_string
    mov eax, [es:di + 16]
    call print_hex

    add di, 24
    dec cx
    jmp print_entries
end_display_smap:
    popa
    ret

obtain_smap:
    pusha
    
    ; set dest
    xor ax, ax
    mov es, ax
    mov di, 0x5000

    ; set parameters
    xor ebx, ebx
    xor bp, bp
    mov edx, 0x534D4150
    mov eax, 0x0000E820
    mov dword [es:di + 20], 1
    mov ecx, 24
    
    ; first inter call
    int 0x15
    jc .failed
    mov edx, 0x534D4150
    cmp eax, edx
    jne .failed
    test ebx, ebx
    je .failed
    jmp .jmpin

    ; loop through all data packets
    .e8201p:
        mov eax, 0xE820
        mov dword [es:di + 20], 1
        mov edx, 0x534D4150 
        mov ecx, 24
        int 0x15
        jc .e820f
    .jmpin:
        test ecx, ecx
        jz .skipent
        cmp ecx, 20
        jbe .notext
        test byte [es:di + 20], 1
        je .skipent
    .notext:
        mov eax, [es:di + 8]
        or eax, [es:di + 12]
        jz .skipent

        inc bp
        add di, 24
    .skipent:
        test ebx, ebx
        jne .e8201p

    .e820f:
        mov [mmap_entry_count], bp

        popa
        clc
        ret
    .failed: 
        mov si, smap_error_msg
        call print_string

        popa
        stc
        ret

print_string:  
    .loop:
        ; put char into al and test if its the null terminator
        mov al, [si]
        test al, al

        jz .done

        ; send char at location stored in si to bios screen  
        mov ah, 0x0E
        int 0x10

        ; increment si
        inc si

        jmp .loop

    .done:
        ret

print_formatted_hex:
    mov si, hex_begin_str
    call print_string

    call print_hex

    mov si, newline_str
    call print_string

    ret

print_hex:
    pusha

    mov ecx, 8
    mov ebx, eax

    print_hex_loop:
        rol ebx, 4
        mov al, bl
        and al, 0x0F
        cmp al, 10
        jl print_digit
        add al, 'A' - 10
        jmp print_hex_digit

    print_digit:
        add al, '0'
    print_hex_digit:
        mov ah, 0x0E
        int 0x10
        loop print_hex_loop

        popa
        ret

welcome_message: db "Booting lolOS...", 0x0D, 0x0A, 0
memory_map_msg: db 0xA, 0xD, "Memory Map:", 0xA, 0xD, 0
base_address_msg: db 'Base Address: ', 0
type_msg: db ' Type: ', 0
length_of_region_msg: db ' Length of region: ', 0
smap_error_msg: db "smap_error!", 0xA, 0xD, 0
a20_error_msg: db "a20_error!", 0xA, 0xD, 0
hex_begin_str: db "0x", 0
newline_str: db 0x0D, 0x0A, 0

; gdt must be at the end of real mode

gdt_start:
    gdt_null:
        dq 0
    gdt_code:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10011010
        ; p,p,t, type flags
        db 0b11001111
        ; other + limit
        db 0
    gdt_data:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10010010
         ; p,p,t, type flags
        db 0b11001111
         ; other + limit
        db 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; protected mode will immediately follow this file
start_protected_mode: