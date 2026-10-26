[bits 64]

section .data
    hello_msg: db "Hello, Long Mode!", 0
    cursor_pos: dw 0

section .text
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

    call update_cursor

    mov rsi, hello_msg
    call print_string_64

    jmp $

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