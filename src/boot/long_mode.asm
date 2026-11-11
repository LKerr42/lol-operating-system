[bits 64]
section .boot.text

BOOT_INFO_ADDR      equ 0x6000

KERNEL_TEMP_ADDR    equ 0x7C00 + (512 * 4)     ; boot start + bootloader size (sector size * 4 sectors)
KERNEL_LOAD_ADDR    equ 0x100000
KERNEL_SIZE         equ 512 * 1     ; sector size * 1

_long_mode_main:
    ; segment registers
    mov ax, DATA_SEG_64
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; set stack pointer and frame pointer
    mov rsp, 0x90000
    xor rbp, rbp

    ; clear screen with blue
    call clear_screen_with_blue

    call update_cursor

    mov rsi, hello_msg
    call print_string_64

    call populate_boot_info

    ; move kernel to final location
    ; move kernel from temp location to final dest
    mov rsi, KERNEL_TEMP_ADDR   ; source
    mov rdi, KERNEL_LOAD_ADDR   ; dest
    mov rcx, KERNEL_SIZE        ; Number of bytes to copy
    cld                         ; auto-increment RSI and RDI
    rep movsb                   ; move data by bytes

    jmp kernel_entry

    jmp $

populate_boot_info:
    mov qword [BOOT_INFO_ADDR + 8], MEMORY_MAP_ADDR

    mov qword [BOOT_INFO_ADDR + 16], MEMORY_MAP_COUNT

    mov qword [BOOT_INFO_ADDR + 24], KERNEL_LOAD_ADDR

    mov qword [BOOT_INFO_ADDR + 32], KERNEL_SIZE

    ret

clear_screen_with_blue:
    mov edi, 0xB8000
    mov rcx, 500
    mov rax, 0x1F201F201F201F20    
    rep stosq

    mov rax, 0x1F6C1F6C1F651F48
    mov [edi], rax

    mov rax, 0x1F6F1F571F201F6F
    mov [edi + 8], rax

    mov rax, 0x1F211F641F6C1F72
    mov [edi + 16], rax

    mov edi, 0xB8000

    ret

print_string_64:
    movzx rdi, word [cursor_pos]
    shl rdi, 1
    add rdi, 0xB8000

    mov ah, 0x1F        ; attribute byte: white text (F) on blue background (1)

    .print_loop:
        lodsb           ; load next byte into al, increment rsi
        test al, al     ; test for zero
        jz .done

        cmp al, 0x0A
        je .newline

        stosw           ; store ax
        jmp .print_loop
    .newline:
        push rax
        push rbx
        push rdx
        
        xor rdx, rdx
        mov rax, rdi
        sub rax, 0xB8000
        mov rbx, 160

        div rbx

        mov rax, 160

        sub rax, rdx

        add rdi, rax

        pop rdx
        pop rbx
        pop rax

        jmp .print_loop
    .done:
        mov rax, rdi
        sub rax, 0xB8000
        shr rax, 1

        mov [cursor_pos], ax

        call update_cursor

        ret

update_cursor:
    ; BX = cursor position
    mov bx, [cursor_pos]

    ; low byte
    mov dx, 0x3D4
    mov al, 0x0F
    out dx, al

    mov dx, 0x3D5
    mov al, bl
    out dx, al

    ; high byte
    mov dx, 0x3D4
    mov al, 0x0E
    out dx, al

    mov dx, 0x3D5
    mov al, bh
    out dx, al

    ret

hello_msg: db "Hello, Long Mode!", 0x0A, 0
cursor_pos: dw 0