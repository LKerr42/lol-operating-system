BITS 16
ORG 0x7C00

mmap_entry_count equ 0x0500

start:
    cli

    ; establish known segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax  

    ; simple temp stack
    mov sp, 0x7C00

    sti

    ; load destination segment
    xor ax, ax
    mov es, ax
    mov bx, 0x7E00

    ; set parameters 
    ; (in order: read sector function, sectors, cylinder, start sector, head)
    mov ah, 0x02
    mov al, 16
    mov ch, 0
    mov cl, 2
    mov dh, 0

    ; call interup, handle a disc error
    int 0x13
    jc disc_error

    jmp 0x7E00

disc_error:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10

    .hang:
        hlt
        jmp .hang

times 510-($-$$) db 0   

dw 0xAA55

main:
    mov si, welcome_message
    call print_string

    call obtain_smap
    call display_smap

    ; mov ecx, 0
    ; jmp .loop_check

    ; .loop:
    ;     mov eax, ecx
    ;     call print_hex

    ;     mov si, newline_str
    ;     call print_string

    ;     inc ecx
    ; .loop_check:
    ;     cmp ecx, 100
    ;     jl .loop

    .hang:
        hlt
        jmp .hang

display_smap:
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
hex_begin_str: db "0x", 0
newline_str: db 0x0D, 0x0A, 0