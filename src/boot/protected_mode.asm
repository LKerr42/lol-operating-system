[bits 32]

protected_mode_main:
    mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000		; 32 bit stack base pointer
	mov esp, ebp

    mov esi, load_message
    call pm_print_string

    .hang:
        hlt
        jmp .hang

pm_print_string:  
    pusha
    mov edi, 0xB8000
    mov ah, 0x0F

    .loop:
        ; put char into al and test if its the null terminator
        mov al, [esi]
        cmp al, 0
        je .done

        ; send char at location stored in si to screen  
        mov [edi], ax

        ; increment si and bx
        inc esi
        add edi, 2

        jmp .loop
    .done:
        popa
        ret

load_message: db "Loaded protected mode...", 0